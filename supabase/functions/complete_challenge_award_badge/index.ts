import { jsonResponse, optionsResponse } from '../_shared/cors.ts';
import { requireUser, serviceClient } from '../_shared/supabase.ts';

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return optionsResponse();
  }

  try {
    const supabase = serviceClient();
    const user = await requireUser(req, supabase);
    const { challenge_id } = await req.json();

    if (!challenge_id) {
      return jsonResponse({ error: 'challenge_id is required' }, 422);
    }

    const { data: challenge, error: challengeError } = await supabase
      .from('challenges')
      .select('id, badge_id, reward_xp')
      .eq('id', challenge_id)
      .single();

    if (challengeError) {
      throw challengeError;
    }

    await supabase
      .from('challenge_participants')
      .upsert({
        challenge_id,
        user_id: user.id,
        progress_percentage: 100,
        completed: true,
        completed_at: new Date().toISOString(),
      });

    if (challenge.badge_id) {
      await supabase.from('user_badges').upsert({
        user_id: user.id,
        badge_id: challenge.badge_id,
        source_type: 'challenge',
        source_id: challenge_id,
      });
    }

    const { data: profile } = await supabase
      .from('profiles')
      .select('xp, level')
      .eq('id', user.id)
      .single();

    const nextXp = Number(profile?.xp ?? 0) + Number(challenge.reward_xp ?? 0);
    const nextLevel = Number(profile?.level ?? 1) + (challenge.reward_xp >= 180 ? 1 : 0);

    await supabase
      .from('profiles')
      .update({ xp: nextXp, level: nextLevel })
      .eq('id', user.id);

    await supabase.from('notifications').insert({
      user_id: user.id,
      title: 'Challenge completata',
      body: 'Hai ricevuto XP e, se previsto, un badge.',
      type: 'challenge_completed',
      metadata: { challenge_id, badge_id: challenge.badge_id },
    });

    return jsonResponse({
      challenge_id,
      badge_id: challenge.badge_id,
      xp: nextXp,
      level: nextLevel,
    });
  } catch (error) {
    return jsonResponse({ error: String(error) }, 400);
  }
});
