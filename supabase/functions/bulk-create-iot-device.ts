import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  // Setup CORS Headers
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type' } })
  }

  try {
    // Parse Request Payload
    const {
      name_prefix,
      pad_length,
      count,
      type = 'door',
      company_id,
      building_id
    } = await req.json()

    if (!name_prefix || !pad_length || !count) {
      throw new Error("Missing required fields: name_prefix, pad_length, or count.")
    }

    // Initialize Supabase
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
    )

    // Get User & Verify Auth
    const { data: { user }, error: authError } = await supabase.auth.getUser()
    if (authError || !user) throw new Error("Unauthorized")

    // Generate Devices Array
    const devicesToInsert = Array.from({ length: count }).map((_, index) => {
      const paddedNumber = String(index + 1).padStart(pad_length, '0')
      return { name: `${name_prefix}${paddedNumber}`, type, company_id, building_id }
    })

    // BULK INSERT into Supabase
    const { data: dbDevices, error: dbError } = await supabase
      .from('devices')
      .insert(devicesToInsert)
      .select()

    if (dbError) throw new Error(`Database Error: ${dbError.message}`)

    // Prepare Azure Connection
    const connString = Deno.env.get('AZURE_CONNECTION_STRING')!
    if (!connString) throw new Error("Missing AZURE_CONNECTION_STRING secret.")

    const parts = parseConnectionString(connString)

    console.log(`Starting bulk sync to Azure for ${dbDevices.length} devices...`)

    // Sync to Azure in Parallel
    const azurePromises = dbDevices.map(async (device) => {
      const sasToken = await generateSasToken(parts.host, parts.keyName, parts.key, 5)
      const azureUrl = `https://${parts.host}/devices/${device.id}?api-version=2020-03-13`

      const response = await fetch(azureUrl, {
        method: 'PUT',
        headers: {
          'Authorization': sasToken,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          deviceId: device.id,
          status: "enabled",
          authentication: { type: "sas" }
        })
      })

      if (!response.ok) {
        const errText = await response.text()
        throw new Error(`Azure failed for ${device.id}: ${errText}`)
      }
      return device.id
    })

    // HANDLE PARTIAL FAILURES (Compensating Transaction)
    const results = await Promise.allSettled(azurePromises)
    const failedDeviceIds: string[] = []

    results.forEach((result, index) => {
      if (result.status === 'rejected') {
        console.error(result.reason)
        failedDeviceIds.push(dbDevices[index].id)
      }
    })

    if (failedDeviceIds.length > 0) {
      console.warn(`Rolling back ${failedDeviceIds.length} failed devices from Supabase...`)
      await supabase.from('devices').delete().in('id', failedDeviceIds)

      return new Response(
        JSON.stringify({
          warning: "Partial success. Some devices failed to register in Azure and were rolled back.",
          successful_count: dbDevices.length - failedDeviceIds.length,
          failed_count: failedDeviceIds.length
        }),
        { status: 207, headers: { 'Content-Type': 'application/json' } }
      )
    }

    // Return result to access control mobile app
    return new Response(
      JSON.stringify({
        success: true,
        message: "All devices successfully created in Supabase and Azure.",
        count: dbDevices.length,
        devices: dbDevices
      }),
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
