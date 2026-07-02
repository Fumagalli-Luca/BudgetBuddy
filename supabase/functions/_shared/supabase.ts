import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

export function serviceClient() {
  const url = Deno.env.get('SUPABASE_URL');
  const key = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');

  if (!url || !key) {
    throw new Error('Missing Supabase service configuration');
  }

  return createClient(url, key, {
    auth: {
      persistSession: false,
      autoRefreshToken: false,
    },
  });
}

export async function requireUser(req: Request, supabase: ReturnType<typeof serviceClient>) {
  const authorization = req.headers.get('Authorization') ?? '';
  const token = authorization.replace('Bearer ', '').trim();

  if (!token) {
    throw new Error('Missing bearer token');
  }

  const { data, error } = await supabase.auth.getUser(token);
  if (error || !data.user) {
    throw new Error('Invalid bearer token');
  }

  return data.user;
}
