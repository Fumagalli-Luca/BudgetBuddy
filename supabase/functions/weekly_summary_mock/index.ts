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
    const start = new Date(now);
    start.setDate(now.getDate() - 7);

    const { data: expenses, error: expenseError } = await supabase
      .from('expenses')
      .select('amount')
      .eq('user_id', user.id)
      .gte('spent_at', start.toISOString().slice(0, 10));

    if (expenseError) {
      throw expenseError;
    }

    const { data: goals, error: goalError } = await supabase
      .from('savings_goals')
      .select('id, title, target_amount, current_amount')
      .eq('user_id', user.id)
      .eq('status', 'active');

    if (goalError) {
      throw goalError;
    }

    const total = (expenses ?? []).reduce(
      (sum, expense) => sum + Number(expense.amount),
      0,
    );
    const bestGoal = (goals ?? []).sort((a, b) => {
      const aProgress = Number(a.current_amount) / Number(a.target_amount);
      const bProgress = Number(b.current_amount) / Number(b.target_amount);
      return bProgress - aProgress;
    })[0];

    const body = bestGoal
      ? `Questa settimana hai registrato ${total.toFixed(0)} euro. L obiettivo piu avanzato e ${bestGoal.title}.`
      : `Questa settimana hai registrato ${total.toFixed(0)} euro. Crea un obiettivo per dare direzione al risparmio.`;

    await supabase.from('insights').insert({
      user_id: user.id,
      title: 'Riepilogo settimanale',
      body,
      kind: 'weekly_summary',
      source: 'edge_mock',
      metadata: { total, generated_at: now.toISOString() },
    });

    await supabase.from('notifications').insert({
      user_id: user.id,
      title: 'Riepilogo settimanale',
      body,
      type: 'weekly_summary',
      metadata: { total },
    });

    return jsonResponse({ total, goals: goals?.length ?? 0 });
  } catch (error) {
    return jsonResponse({ error: String(error) }, 400);
  }
});
