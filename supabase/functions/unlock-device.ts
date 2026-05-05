import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  // Setup CORS Headers
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type' } })
  }

  try {
    const { device_id } = await req.json()

    // Initialize Supabase
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
    )
    
    // Get User
    const { data: { user } } = await supabase.auth.getUser()
    if (!user) throw new Error("Unauthorized")

    // CHECK PERMISSIONS (RPC Call)
    const { data: isAllowed, error: rpcError } = await supabase.rpc('can_unlock_device', {
      user_id: user.id,
      device_id: device_id
    })

    if (rpcError) throw new Error(`RPC Error: ${rpcError.message}`)

    // Prepare Azure Connection
    const connString = Deno.env.get('AZURE_CONNECTION_STRING')!
    const parts = parseConnectionString(connString)
    const sasToken = await generateSasToken(parts.host, parts.keyName, parts.key, 5)
    
    // UNLOCK or DENY
    const methodName = isAllowed ? "unlock" : "deny"
    const azureUrl = `https://${parts.host}/twins/${device_id}/methods?api-version=2020-03-13`
    
    console.log(`Sending '${methodName}' command to device: ${device_id}...`)

    const azureResp = await fetch(azureUrl, {
      method: 'POST',
      headers: {
        'Authorization': sasToken,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        methodName: methodName, // 'unlock' or 'deny'
        responseTimeoutInSeconds: 10,
        payload: { 
          user_email: user.email,
          access_granted: isAllowed 
        }
      })
    })

    if (!azureResp.ok) {
       return new Response(JSON.stringify({ error: "Device unreachable" }), { status: 502 })
    }

    // Return result to access control mobile app
    if (isAllowed) {
        return new Response(JSON.stringify({ success: true, message: "Door Unlocked" }), { headers: { 'Content-Type': 'application/json' } })
    } else {
        return new Response(JSON.stringify({ success: false, error: "Access Denied" }), { status: 403, headers: { 'Content-Type': 'application/json' } })
    }

  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), { status: 400, headers: { 'Content-Type': 'application/json' } })
  }
})

// MARK: - Helpers
function parseConnectionString(cs: string) {
  const parts: any = {}
  cs.split(';').forEach(part => {
    const [key, value] = part.split('=', 2)
    if (key === 'HostName') parts.host = value
    if (key === 'SharedAccessKeyName') parts.keyName = value
    if (key === 'SharedAccessKey') parts.key = value
  })
  return parts
}

async function generateSasToken(resourceUri: string, keyName: string, key: string, expiresInMins: number) {
  const expiresIn = Math.ceil(Date.now() / 1000 + expiresInMins * 60)
  const toSign = encodeURIComponent(resourceUri) + '\n' + expiresIn
  const encoder = new TextEncoder()
  const binaryKey = Uint8Array.from(atob(key), c => c.charCodeAt(0))
  const cryptoKey = await crypto.subtle.importKey(
    "raw", binaryKey, { name: "HMAC", hash: "SHA-256" }, false, ["sign"]
  )
  const signature = await crypto.subtle.sign("HMAC", cryptoKey, encoder.encode(toSign))
  const signatureBase64 = btoa(String.fromCharCode(...new Uint8Array(signature)))
  return `SharedAccessSignature sr=${encodeURIComponent(resourceUri)}&sig=${encodeURIComponent(signatureBase64)}&se=${expiresIn}&skn=${keyName}`
}