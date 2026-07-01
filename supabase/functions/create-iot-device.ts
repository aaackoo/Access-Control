import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  // Setup CORS Headers
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type' } })
  }

  try {
    const { name, type = 'door', company_id, building_id } = await req.json()

    if (!name) throw new Error("Device 'name' is required.")

    // Initialize Supabase
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
    )

    // Get User & Verify Auth
    const { data: { user }, error: authError } = await supabase.auth.getUser()
    if (authError || !user) throw new Error("Unauthorized")

    // Insert into Supabase
    const { data: newDevice, error: dbError } = await supabase
      .from('devices')
      .insert([{ name, type, company_id, building_id }])
      .select()
      .single()

    if (dbError) throw new Error(`Database Error: ${dbError.message}`)

    const deviceId = newDevice.id

    // Prepare Azure Connection
    const connString = Deno.env.get('AZURE_CONNECTION_STRING')!
    if (!connString) throw new Error("Missing Azure configuration.")

    const parts = parseConnectionString(connString)
    const sasToken = await generateSasToken(parts.host, parts.keyName, parts.key, 5)

    // Create Device in Azure IoT Hub
    console.log(`Registering device ${deviceId} in Azure IoT Hub...`)
    const azureUrl = `https://${parts.host}/devices/${deviceId}?api-version=2020-03-13`

    const azureResp = await fetch(azureUrl, {
      method: 'PUT',
      headers: {
        'Authorization': sasToken,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        deviceId: deviceId,
        status: "enabled",
        authentication: { type: "sas" }
      })
    })

    // ROLLBACK if Azure Fails
    if (!azureResp.ok) {
      const azureErrorData = await azureResp.text()
      console.error("Azure IoT Hub Error:", azureErrorData)
      await supabase.from('devices').delete().match({ id: deviceId })
      return new Response(JSON.stringify({ error: "Failed to create device in Azure. Database record rolled back." }), { status: 502, headers: { 'Content-Type': 'application/json' } })
    }

    // Return result to access control mobile app
    return new Response(
      JSON.stringify({ success: true, message: "Device successfully created in Supabase and Azure IoT Hub", device: newDevice }),
      { status: 200, headers: { 'Content-Type': 'application/json' } }
    )

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
