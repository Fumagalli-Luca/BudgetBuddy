insert into auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at
)
values
  (
    '00000000-0000-0000-0000-000000000000',
    '00000000-0000-0000-0000-000000000101',
    'authenticated',
    'authenticated',
    'sofia.demo@example.com',
    crypt('BudgetBuddy123!', gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}',
    '{"display_name":"Sofia"}',
    now(),
    now()
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    '00000000-0000-0000-0000-000000000102',
    'authenticated',
    'authenticated',
    'marco.demo@example.com',
    crypt('BudgetBuddy123!', gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}',
    '{"display_name":"Marco"}',
    now(),
    now()
  ),
  (
    '00000000-0000-0000-0000-000000000000',
    '00000000-0000-0000-0000-000000000103',
    'authenticated',
    'authenticated',
    'giulia.demo@example.com',
    crypt('BudgetBuddy123!', gen_salt('bf')),
    now(),
    '{"provider":"email","providers":["email"]}',
    '{"display_name":"Giulia"}',
    now(),
    now()
  )
on conflict (id) do update
set email = excluded.email,
    encrypted_password = excluded.encrypted_password,
    updated_at = now();

insert into auth.identities (
  id,
  user_id,
  provider_id,
  identity_data,
  provider,
  last_sign_in_at,
  created_at,
  updated_at
)
values
  (
    '00000000-0000-0000-0000-000000000101',
    '00000000-0000-0000-0000-000000000101',
    'sofia.demo@example.com',
    '{"sub":"00000000-0000-0000-0000-000000000101","email":"sofia.demo@example.com"}',
    'email',
    now(),
    now(),
    now()
  ),
  (
    '00000000-0000-0000-0000-000000000102',
    '00000000-0000-0000-0000-000000000102',
    'marco.demo@example.com',
    '{"sub":"00000000-0000-0000-0000-000000000102","email":"marco.demo@example.com"}',
    'email',
    now(),
    now(),
    now()
  ),
  (
    '00000000-0000-0000-0000-000000000103',
    '00000000-0000-0000-0000-000000000103',
    'giulia.demo@example.com',
    '{"sub":"00000000-0000-0000-0000-000000000103","email":"giulia.demo@example.com"}',
    'email',
    now(),
    now(),
    now()
  )
on conflict (provider_id, provider) do nothing;

alter table public.profiles disable trigger profiles_prevent_role_escalation;

insert into public.profiles (
  id,
  email,
  username,
  display_name,
  avatar_emoji,
  level,
  xp,
  streak_count,
  goals_completed,
  role,
  privacy_show_percentages_only,
  locale
)
values
  ('00000000-0000-0000-0000-000000000101', 'sofia.demo@example.com', 'sofia_saves', 'Sofia', '🌙', 7, 1840, 12, 3, 'user', true, 'it'),
  ('00000000-0000-0000-0000-000000000102', 'marco.demo@example.com', 'marco_budget', 'Marco', '⚡', 5, 1190, 4, 1, 'user', true, 'it'),
  ('00000000-0000-0000-0000-000000000103', 'giulia.demo@example.com', 'giulia_admin', 'Giulia', '🌿', 8, 2210, 16, 4, 'admin', true, 'it')
on conflict (id) do update
set email = excluded.email,
    username = excluded.username,
    display_name = excluded.display_name,
    avatar_emoji = excluded.avatar_emoji,
    level = excluded.level,
    xp = excluded.xp,
    streak_count = excluded.streak_count,
    goals_completed = excluded.goals_completed,
    role = excluded.role,
    privacy_show_percentages_only = excluded.privacy_show_percentages_only,
    locale = excluded.locale;

alter table public.profiles enable trigger profiles_prevent_role_escalation;

insert into public.user_settings (
  user_id,
  theme_mode,
  notification_consent,
  onboarding,
  monthly_budget,
  saving_style,
  main_goal_kind,
  preferred_categories
)
values
  ('00000000-0000-0000-0000-000000000101', 'system', true, '{"completed":true}', 850, 'balanced', 'travel', array['food','transport','fun','delivery']),
  ('00000000-0000-0000-0000-000000000102', 'dark', false, '{"completed":true}', 720, 'light', 'concert', array['food','fun']),
  ('00000000-0000-0000-0000-000000000103', 'light', true, '{"completed":true}', 1100, 'aggressive', 'emergency', array['home','transport','study'])
on conflict (user_id) do update
set theme_mode = excluded.theme_mode,
    notification_consent = excluded.notification_consent,
    onboarding = excluded.onboarding,
    monthly_budget = excluded.monthly_budget,
    saving_style = excluded.saving_style,
    main_goal_kind = excluded.main_goal_kind,
    preferred_categories = excluded.preferred_categories;

insert into public.expense_categories (id, name, icon, color_hex, is_default, sort_order)
values
  ('00000000-0000-0000-0000-000000000201', 'Food', 'restaurant', '#6C4DFF', true, 1),
  ('00000000-0000-0000-0000-000000000202', 'Delivery', 'takeout_dining', '#C8F560', true, 2),
  ('00000000-0000-0000-0000-000000000203', 'Transport', 'train', '#2BB3A3', true, 3),
  ('00000000-0000-0000-0000-000000000204', 'Fun', 'music_note', '#FFB84D', true, 4),
  ('00000000-0000-0000-0000-000000000205', 'Study', 'school', '#FF6B6B', true, 5),
  ('00000000-0000-0000-0000-000000000206', 'Home', 'home', '#9A78FF', true, 6)
on conflict (id) do update
set name = excluded.name,
    icon = excluded.icon,
    color_hex = excluded.color_hex,
    is_default = excluded.is_default,
    sort_order = excluded.sort_order;

insert into public.badges (id, code, name, description, emoji)
values
  ('00000000-0000-0000-0000-000000000301', 'starter', 'Primo passo', 'Prima spesa registrata', '✨'),
  ('00000000-0000-0000-0000-000000000302', 'delivery_free', 'Delivery detox', 'Una settimana senza delivery', '🥗'),
  ('00000000-0000-0000-0000-000000000303', 'weekend_guardian', 'Weekend smart', 'Weekend sotto budget', '🛡️'),
  ('00000000-0000-0000-0000-000000000304', 'impulse_master', 'Anti impulso', '7 giorni senza acquisti impulsivi', '🧘'),
  ('00000000-0000-0000-0000-000000000305', 'daily_saver', '5 euro hero', 'Risparmio giornaliero costante', '💚'),
  ('00000000-0000-0000-0000-000000000306', 'goal_25', '25 percento', 'Primo quarto obiettivo', '🌱'),
  ('00000000-0000-0000-0000-000000000307', 'goal_50', 'Meta vicina', 'Meta obiettivo raggiunta', '🏁'),
  ('00000000-0000-0000-0000-000000000308', 'group_energy', 'Squadra', 'Challenge di gruppo completata', '🤝')
on conflict (id) do update
set code = excluded.code,
    name = excluded.name,
    description = excluded.description,
    emoji = excluded.emoji;

insert into public.expenses (
  id,
  user_id,
  category_id,
  amount,
  spent_at,
  description,
  payment_method,
  tags,
  is_recurring
)
values
  ('00000000-0000-0000-0000-000000000701', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000201', 12.50, current_date - 1, 'Pranzo universita', 'card', array['uni'], false),
  ('00000000-0000-0000-0000-000000000702', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000203', 7.20, current_date - 2, 'Metro', 'wallet', array['trasporti'], false),
  ('00000000-0000-0000-0000-000000000703', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000202', 22.00, current_date - 3, 'Delivery poke', 'card', array['delivery'], false),
  ('00000000-0000-0000-0000-000000000704', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000201', 4.50, current_date - 4, 'Caffe e snack', 'cash', array['snack'], false),
  ('00000000-0000-0000-0000-000000000705', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000204', 18.00, current_date - 5, 'Cinema', 'card', array['weekend'], false),
  ('00000000-0000-0000-0000-000000000706', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000205', 39.00, current_date - 6, 'Libro usato', 'card', array['studio'], false),
  ('00000000-0000-0000-0000-000000000707', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000204', 9.90, current_date - 7, 'Streaming', 'card', array['ricorrente'], true),
  ('00000000-0000-0000-0000-000000000708', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000202', 16.40, current_date - 8, 'Pizza con amici', 'card', array['delivery'], false),
  ('00000000-0000-0000-0000-000000000709', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000206', 32.00, current_date - 9, 'Spesa casa', 'card', array['casa'], false),
  ('00000000-0000-0000-0000-000000000710', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000203', 6.00, current_date - 10, 'Bus extra', 'wallet', array['trasporti'], false),
  ('00000000-0000-0000-0000-000000000711', '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000201', 14.00, current_date - 2, 'Aperitivo leggero', 'card', array['amici'], false),
  ('00000000-0000-0000-0000-000000000712', '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000204', 24.50, current_date - 3, 'Concerto local', 'card', array['musica'], false),
  ('00000000-0000-0000-0000-000000000713', '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000201', 11.20, current_date - 4, 'Mensa', 'card', array['uni'], false),
  ('00000000-0000-0000-0000-000000000714', '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000202', 19.80, current_date - 5, 'Sushi delivery', 'card', array['delivery'], false),
  ('00000000-0000-0000-0000-000000000715', '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000201', 3.50, current_date - 6, 'Colazione', 'cash', array['bar'], false),
  ('00000000-0000-0000-0000-000000000716', '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000206', 27.00, current_date - 1, 'Detersivi', 'card', array['casa'], false),
  ('00000000-0000-0000-0000-000000000717', '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000203', 8.00, current_date - 2, 'Monopattino', 'wallet', array['mobilita'], false),
  ('00000000-0000-0000-0000-000000000718', '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000205', 15.00, current_date - 3, 'Appunti stampati', 'cash', array['studio'], false),
  ('00000000-0000-0000-0000-000000000719', '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000204', 21.00, current_date - 4, 'Regalo compleanno', 'card', array['regali'], false),
  ('00000000-0000-0000-0000-000000000720', '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000201', 5.50, current_date - 5, 'Gelato', 'cash', array['weekend'], false)
on conflict (id) do update
set amount = excluded.amount,
    spent_at = excluded.spent_at,
    description = excluded.description,
    tags = excluded.tags,
    is_recurring = excluded.is_recurring;

insert into public.savings_goals (id, user_id, title, emoji, target_amount, current_amount, deadline, status, visibility)
values
  ('00000000-0000-0000-0000-000000000401', '00000000-0000-0000-0000-000000000101', 'Interrail estate', '🚆', 900, 540, current_date + 95, 'active', 'percentage_only'),
  ('00000000-0000-0000-0000-000000000402', '00000000-0000-0000-0000-000000000101', 'MacBook usato', '💻', 1200, 220, current_date + 180, 'active', 'private'),
  ('00000000-0000-0000-0000-000000000403', '00000000-0000-0000-0000-000000000102', 'Concerto a Berlino', '🎤', 260, 180, current_date + 45, 'active', 'group'),
  ('00000000-0000-0000-0000-000000000404', '00000000-0000-0000-0000-000000000103', 'Fondo emergenza', '🛟', 600, 310, current_date + 150, 'active', 'percentage_only')
on conflict (id) do update
set title = excluded.title,
    target_amount = excluded.target_amount,
    current_amount = excluded.current_amount,
    deadline = excluded.deadline,
    status = excluded.status,
    visibility = excluded.visibility;

insert into public.goal_transactions (id, goal_id, user_id, amount, transaction_type, note, created_at)
values
  ('00000000-0000-0000-0000-000000000411', '00000000-0000-0000-0000-000000000401', '00000000-0000-0000-0000-000000000101', 240, 'virtual_deposit', 'Primo trasferimento virtuale', now() - interval '28 days'),
  ('00000000-0000-0000-0000-000000000412', '00000000-0000-0000-0000-000000000401', '00000000-0000-0000-0000-000000000101', 300, 'virtual_deposit', 'Extra risparmio', now() - interval '8 days'),
  ('00000000-0000-0000-0000-000000000413', '00000000-0000-0000-0000-000000000402', '00000000-0000-0000-0000-000000000101', 220, 'virtual_deposit', 'Vendita usato', now() - interval '10 days'),
  ('00000000-0000-0000-0000-000000000414', '00000000-0000-0000-0000-000000000403', '00000000-0000-0000-0000-000000000102', 180, 'virtual_deposit', 'Regalo compleanno', now() - interval '6 days')
on conflict (id) do nothing;

insert into public.groups (id, owner_id, name, invite_code, privacy_mode)
values ('00000000-0000-0000-0000-000000000501', '00000000-0000-0000-0000-000000000101', 'Weekend Berlino', 'BERLINO30', 'percentages_only')
on conflict (id) do update
set name = excluded.name,
    invite_code = excluded.invite_code,
    privacy_mode = excluded.privacy_mode;

insert into public.group_members (group_id, user_id, role, status, show_percentages_only)
values
  ('00000000-0000-0000-0000-000000000501', '00000000-0000-0000-0000-000000000101', 'owner', 'active', true),
  ('00000000-0000-0000-0000-000000000501', '00000000-0000-0000-0000-000000000102', 'member', 'active', true),
  ('00000000-0000-0000-0000-000000000501', '00000000-0000-0000-0000-000000000103', 'member', 'active', true)
on conflict (group_id, user_id) do update
set role = excluded.role,
    status = excluded.status,
    show_percentages_only = excluded.show_percentages_only;

insert into public.challenges (
  id,
  created_by,
  group_id,
  badge_id,
  title,
  description,
  kind,
  duration_days,
  reward_xp,
  visibility,
  is_active
)
values
  ('00000000-0000-0000-0000-000000000601', '00000000-0000-0000-0000-000000000103', null, '00000000-0000-0000-0000-000000000302', 'No delivery week', 'Cucina o organizza pasti per 7 giorni.', 'no_delivery_week', 7, 180, 'public', true),
  ('00000000-0000-0000-0000-000000000602', '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000501', '00000000-0000-0000-0000-000000000303', 'Weekend sotto 30 euro', 'Divertiti senza superare 30 euro.', 'weekend_under_30', 2, 120, 'group', true),
  ('00000000-0000-0000-0000-000000000603', '00000000-0000-0000-0000-000000000103', null, '00000000-0000-0000-0000-000000000304', '7 giorni senza acquisti impulsivi', 'Aspetta 24 ore prima di comprare.', 'no_impulse_7_days', 7, 160, 'public', true),
  ('00000000-0000-0000-0000-000000000604', '00000000-0000-0000-0000-000000000103', null, '00000000-0000-0000-0000-000000000305', 'Risparmia 5 euro al giorno', 'Sposta 5 euro virtuali verso un obiettivo.', 'save_5_per_day', 10, 220, 'public', true),
  ('00000000-0000-0000-0000-000000000605', '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000501', '00000000-0000-0000-0000-000000000308', 'Study week smart', 'Budget leggero per materiali e pause.', 'custom', 5, 90, 'group', true)
on conflict (id) do update
set title = excluded.title,
    description = excluded.description,
    reward_xp = excluded.reward_xp,
    visibility = excluded.visibility,
    is_active = excluded.is_active;

insert into public.challenge_participants (challenge_id, user_id, group_id, progress_percentage, completed)
values
  ('00000000-0000-0000-0000-000000000601', '00000000-0000-0000-0000-000000000101', null, 45, false),
  ('00000000-0000-0000-0000-000000000601', '00000000-0000-0000-0000-000000000102', null, 33, false),
  ('00000000-0000-0000-0000-000000000602', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000501', 70, false),
  ('00000000-0000-0000-0000-000000000602', '00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000501', 58, false),
  ('00000000-0000-0000-0000-000000000602', '00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000501', 88, false),
  ('00000000-0000-0000-0000-000000000603', '00000000-0000-0000-0000-000000000101', null, 25, false),
  ('00000000-0000-0000-0000-000000000604', '00000000-0000-0000-0000-000000000101', null, 60, false),
  ('00000000-0000-0000-0000-000000000605', '00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000501', 35, false)
on conflict (challenge_id, user_id) do update
set progress_percentage = excluded.progress_percentage,
    completed = excluded.completed;

insert into public.user_badges (user_id, badge_id, source_type, source_id)
values
  ('00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000301', 'manual', null),
  ('00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000306', 'goal', '00000000-0000-0000-0000-000000000401'),
  ('00000000-0000-0000-0000-000000000101', '00000000-0000-0000-0000-000000000303', 'challenge', '00000000-0000-0000-0000-000000000602'),
  ('00000000-0000-0000-0000-000000000102', '00000000-0000-0000-0000-000000000301', 'manual', null),
  ('00000000-0000-0000-0000-000000000103', '00000000-0000-0000-0000-000000000308', 'challenge', '00000000-0000-0000-0000-000000000605')
on conflict (user_id, badge_id) do nothing;

insert into public.insights (id, user_id, title, body, kind, source, metadata)
values
  ('00000000-0000-0000-0000-000000000901', '00000000-0000-0000-0000-000000000101', 'Delivery sotto la lente', 'Questo mese delivery pesa il 24 percento delle spese.', 'category_share', 'local_mock', '{"category":"delivery"}'),
  ('00000000-0000-0000-0000-000000000902', '00000000-0000-0000-0000-000000000101', 'Budget ancora respirabile', 'Hai ancora margine nel budget manuale.', 'budget_status', 'local_mock', '{}')
on conflict (id) do update
set title = excluded.title,
    body = excluded.body,
    metadata = excluded.metadata;

insert into public.reports (id, reporter_id, target_type, target_id, reason, status, moderator_id, resolution_note)
values
  ('00000000-0000-0000-0000-000000000801', '00000000-0000-0000-0000-000000000101', 'comment', 'comment-demo-1', 'Commento poco costruttivo', 'open', null, null),
  ('00000000-0000-0000-0000-000000000802', '00000000-0000-0000-0000-000000000102', 'profile', '00000000-0000-0000-0000-000000000103', 'Avatar da verificare', 'reviewing', '00000000-0000-0000-0000-000000000103', null),
  ('00000000-0000-0000-0000-000000000803', '00000000-0000-0000-0000-000000000103', 'challenge', '00000000-0000-0000-0000-000000000605', 'Testo ambiguo', 'closed', '00000000-0000-0000-0000-000000000103', 'Contenuto aggiornato')
on conflict (id) do update
set status = excluded.status,
    moderator_id = excluded.moderator_id,
    resolution_note = excluded.resolution_note;

insert into public.notifications (id, user_id, title, body, type, metadata)
values
  ('00000000-0000-0000-0000-000000000911', '00000000-0000-0000-0000-000000000101', 'Riepilogo settimanale', 'Hai fatto progressi su Interrail estate.', 'weekly_summary', '{}'),
  ('00000000-0000-0000-0000-000000000912', '00000000-0000-0000-0000-000000000101', 'Milestone vicina', 'Sei oltre il 50 percento del tuo obiettivo.', 'goal_milestone', '{"goal_id":"00000000-0000-0000-0000-000000000401"}')
on conflict (id) do nothing;

insert into public.admin_audit_logs (id, admin_id, action, target_type, target_id, metadata)
values
  ('00000000-0000-0000-0000-000000000921', '00000000-0000-0000-0000-000000000103', 'seed_demo', 'system', 'seed.sql', '{}')
on conflict (id) do nothing;
