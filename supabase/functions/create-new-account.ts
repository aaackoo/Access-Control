import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  // Setup CORS Headers
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: { 'Access-Control-Allow-Origin': '*', 'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type' } })
  }

  try {
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) throw new Error('Missing Authorization header')

    // Initialize Supabase
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      { global: { headers: { Authorization: authHeader } } }
    )

    // Admin Client
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // Get Caller & Verify Token
    const { data: { user: caller }, error: userError } = await supabaseClient.auth.getUser()
    if (userError || !caller) throw new Error('Invalid Token')

    // Verify Caller Role
    const { data: callerAccount, error: roleError } = await supabaseAdmin
      .from('accounts')
      .select('role')
      .eq('id', caller.id)
      .single()

    if (roleError || !callerAccount) throw new Error('Caller account not found')

    const allowedRoles = ['owner', 'area_manager', 'building_manager']
    if (!allowedRoles.includes(callerAccount.role)) {
      return new Response(
        JSON.stringify({ error: `Unauthorized. Role '${callerAccount.role}' cannot create users.` }),
        { status: 403, headers: { 'Content-Type': 'application/json' } }
      )
    }

    // Create New User
    const { email, company_id, target_role } = await req.json()

    if (!email || !company_id || !target_role) {
      throw new Error('Missing required fields: email, company_id, or target_role')
    }

    const { data, error: createError } = await supabaseAdmin.auth.admin.createUser({
      email: email,
      password: "abcdef", // TODO: For dev testing!
      email_confirm: true,
      user_metadata: {
        company_id: company_id,
        role: target_role
      }
    })

    if (createError) throw createError

    // Return result to access control mobile app
    return new Response(
      JSON.stringify({ message: 'User created successfully', user: data.user, tempPassword: "password" }),
      { headers: { 'Content-Type': 'application/json' } }
    )

  } catch (err: any) {
    return new Response(JSON.stringify({ error: err.message }), { status: 400, headers: { 'Content-Type': 'application/json' } })
  }
})
