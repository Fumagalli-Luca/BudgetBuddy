import { jsonResponse, optionsResponse } from '../_shared/cors.ts';
import { requireUser, serviceClient } from '../_shared/supabase.ts';

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return optionsResponse();
  }

  try {
    const supabase = serviceClient();
    const user = await requireUser(req, supabase);
    const now = new Date();
    const start = new Date(now.getFullYear(), now.getMonth(), 1);
    const next = new Date(now.getFullYear(), now.getMonth() + 1, 1);

    const { data: expenses, error } = await supabase
      .from('expenses')
      .select('amount, category_id')
      .eq('user_id', user.id)
      .gte('spent_at', start.toISOString().slice(0, 10))
      .lt('spent_at', next.toISOString().slice(0, 10));

    if (error) {
      throw error;
    }

    const total = (expenses ?? []).reduce(
      (sum, expense) => sum + Number(expense.amount),
      0,
    );
    const delivery = (expenses ?? [])
      .filter((expense) => expense.category_id)
      .reduce((sum, expense) => sum + Number(expense.amount), 0);

    const body =
      `Questo mese hai registrato ${total.toFixed(0)} euro di spese manuali. ` +
      'Usa il dato come promemoria organizzativo, non come consulenza finanziaria.';

    await supabase.from('insights').insert({
      user_id: user.id,
      title: 'Riepilogo mese',
      body,
      kind: 'monthly_stats',
      source: 'edge_mock',
      metadata: {
        total,
        delivery,
        generated_at: now.toISOString(),
      },
    });

    return jsonResponse({ total, count: expenses?.length ?? 0 });
  } catch (error) {
    return jsonResponse({ error: String(error) }, 400);
  }
});
