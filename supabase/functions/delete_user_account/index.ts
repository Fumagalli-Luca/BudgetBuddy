import { jsonResponse, optionsResponse } from '../_shared/cors.ts';
import { requireUser, serviceClient } from '../_shared/supabase.ts';

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return optionsResponse();
  }

  try {
    const supabase = serviceClient();
    const user = await requireUser(req, supabase);
    const { confirmation } = await req.json();

    if (confirmation !== 'DELETE') {
      return jsonResponse({ error: 'Confirmation must be DELETE' }, 422);
    }

    await supabase
      .from('profiles')
      .update({ deleted_at: new Date().toISOString() })
      .eq('id', user.id);

    const { error } = await supabase.auth.admin.deleteUser(user.id);
    if (error) {
      throw error;
    }

    return jsonResponse({
      deleted: true,
      message: 'Account and personal data deletion requested.',
    });
  } catch (error) {
    return jsonResponse({ error: String(error) }, 400);
  }
});
