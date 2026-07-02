import { jsonResponse, optionsResponse } from '../_shared/cors.ts';
import { requireUser, serviceClient } from '../_shared/supabase.ts';

const milestones = [25, 50, 75, 100];

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return optionsResponse();
  }

  try {
    const supabase = serviceClient();
    const user = await requireUser(req, supabase);

    const { data: goals, error } = await supabase
      .from('savings_goals')
      .select('id, title, target_amount, current_amount')
      .eq('user_id', user.id)
      .eq('status', 'active');

    if (error) {
      throw error;
    }

    const unlocked: Array<{ goal_id: string; milestone: number }> = [];

    for (const goal of goals ?? []) {
      const progress =
        Number(goal.target_amount) === 0
          ? 0
          : Number(goal.current_amount) / Number(goal.target_amount) * 100;
      for (const milestone of milestones) {
        if (progress >= milestone) {
          unlocked.push({ goal_id: goal.id, milestone });
        }
      }
    }

    for (const item of unlocked) {
      await supabase.from('notifications').insert({
        user_id: user.id,
        title: `Milestone ${item.milestone}%`,
        body: 'Hai raggiunto una nuova milestone su un obiettivo.',
        type: 'goal_milestone',
        metadata: item,
      });
    }

    return jsonResponse({ unlocked });
  } catch (error) {
    return jsonResponse({ error: String(error) }, 400);
  }
});
