create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  username text unique,
  display_name text not null,
  avatar_url text,
  avatar_emoji text default '🌱',
  birth_year int check (birth_year is null or birth_year between 1900 and extract(year from now())::int),
  level int not null default 1 check (level >= 1),
  xp int not null default 0 check (xp >= 0),
  streak_count int not null default 0 check (streak_count >= 0),
  goals_completed int not null default 0 check (goals_completed >= 0),
  role text not null default 'user' check (role in ('user', 'moderator', 'admin')),
  privacy_show_percentages_only boolean not null default true,
  locale text not null default 'it' check (locale in ('it', 'en')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create table public.user_settings (
  user_id uuid primary key references public.profiles(id) on delete cascade,
  theme_mode text not null default 'system' check (theme_mode in ('system', 'light', 'dark')),
  notification_consent boolean not null default false,
  fcm_token text,
  onboarding jsonb not null default '{}'::jsonb,
  monthly_budget numeric(12,2) not null default 0 check (monthly_budget >= 0),
  saving_style text not null default 'balanced' check (saving_style in ('light', 'balanced', 'aggressive')),
  main_goal_kind text not null default 'other' check (main_goal_kind in ('travel', 'car', 'rent', 'emergency', 'concert', 'study', 'other')),
  preferred_categories text[] not null default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.expense_categories (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid references public.profiles(id) on delete cascade,
  name text not null,
  icon text not null default 'tag',
  color_hex text not null default '#6C4DFF',
  is_default boolean not null default false,
  is_active boolean not null default true,
  sort_order int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (owner_id, name)
);

create table public.expenses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  category_id uuid references public.expense_categories(id) on delete set null,
  amount numeric(12,2) not null check (amount > 0),
  spent_at date not null default current_date,
  description text,
  payment_method text not null default 'card' check (payment_method in ('cash', 'card', 'transfer', 'wallet', 'other')),
  tags text[] not null default '{}',
  is_recurring boolean not null default false,
  recurring_rule jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.savings_goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  emoji text not null default '🎯',
  target_amount numeric(12,2) not null check (target_amount > 0),
  current_amount numeric(12,2) not null default 0 check (current_amount >= 0),
  deadline date not null,
  status text not null default 'active' check (status in ('active', 'completed', 'paused', 'archived')),
  visibility text not null default 'private' check (visibility in ('private', 'percentage_only', 'group')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.goal_transactions (
  id uuid primary key default gen_random_uuid(),
  goal_id uuid not null references public.savings_goals(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  amount numeric(12,2) not null,
  transaction_type text not null default 'virtual_deposit' check (transaction_type in ('virtual_deposit', 'virtual_withdrawal', 'adjustment')),
  note text,
  created_at timestamptz not null default now()
);

create table public.groups (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  name text not null,
  invite_code text not null unique,
  privacy_mode text not null default 'percentages_only' check (privacy_mode in ('percentages_only', 'badges_only')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.group_members (
  group_id uuid not null references public.groups(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  role text not null default 'member' check (role in ('owner', 'member', 'moderator')),
  status text not null default 'active' check (status in ('invited', 'active', 'removed')),
  show_percentages_only boolean not null default true,
  joined_at timestamptz not null default now(),
  primary key (group_id, user_id)
);

create table public.badges (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  name text not null,
  description text not null,
  emoji text not null default '✨',
  created_at timestamptz not null default now()
);

create table public.challenges (
  id uuid primary key default gen_random_uuid(),
  created_by uuid references public.profiles(id) on delete set null,
  group_id uuid references public.groups(id) on delete cascade,
  badge_id uuid references public.badges(id) on delete set null,
  title text not null,
  description text not null,
  kind text not null default 'custom' check (kind in ('no_delivery_week', 'weekend_under_30', 'no_impulse_7_days', 'save_5_per_day', 'custom')),
  duration_days int not null check (duration_days > 0 and duration_days <= 365),
  reward_xp int not null default 0 check (reward_xp >= 0),
  visibility text not null default 'public' check (visibility in ('public', 'group', 'private')),
  is_active boolean not null default true,
  starts_at date,
  ends_at date,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.challenge_participants (
  challenge_id uuid not null references public.challenges(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  group_id uuid references public.groups(id) on delete cascade,
  progress_percentage numeric(5,2) not null default 0 check (progress_percentage >= 0 and progress_percentage <= 100),
  completed boolean not null default false,
  joined_at timestamptz not null default now(),
  completed_at timestamptz,
  primary key (challenge_id, user_id)
);

create table public.user_badges (
  user_id uuid not null references public.profiles(id) on delete cascade,
  badge_id uuid not null references public.badges(id) on delete cascade,
  awarded_at timestamptz not null default now(),
  source_type text not null default 'challenge' check (source_type in ('challenge', 'goal', 'manual')),
  source_id uuid,
  primary key (user_id, badge_id)
);

create table public.insights (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  body text not null,
  kind text not null default 'mock',
  source text not null default 'local_mock',
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid references public.profiles(id) on delete set null,
  target_type text not null check (target_type in ('profile', 'group', 'challenge', 'comment', 'content', 'other')),
  target_id text,
  reason text not null,
  status text not null default 'open' check (status in ('open', 'reviewing', 'closed', 'rejected')),
  moderator_id uuid references public.profiles(id) on delete set null,
  resolution_note text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  body text not null,
  type text not null default 'system',
  metadata jsonb not null default '{}'::jsonb,
  read_at timestamptz,
  created_at timestamptz not null default now()
);

create table public.admin_audit_logs (
  id uuid primary key default gen_random_uuid(),
  admin_id uuid references public.profiles(id) on delete set null,
  action text not null,
  target_type text not null,
  target_id text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index profiles_role_idx on public.profiles(role);
create index expenses_user_spent_at_idx on public.expenses(user_id, spent_at desc);
create index goals_user_status_idx on public.savings_goals(user_id, status);
create index goal_transactions_goal_idx on public.goal_transactions(goal_id, created_at desc);
create index challenge_participants_user_idx on public.challenge_participants(user_id);
create index group_members_user_idx on public.group_members(user_id);
create index reports_status_idx on public.reports(status, created_at desc);
create index notifications_user_unread_idx on public.notifications(user_id, read_at) where read_at is null;

create trigger profiles_set_updated_at
before update on public.profiles
for each row execute function public.set_updated_at();

create trigger user_settings_set_updated_at
before update on public.user_settings
for each row execute function public.set_updated_at();

create trigger expense_categories_set_updated_at
before update on public.expense_categories
for each row execute function public.set_updated_at();

create trigger expenses_set_updated_at
before update on public.expenses
for each row execute function public.set_updated_at();

create trigger savings_goals_set_updated_at
before update on public.savings_goals
for each row execute function public.set_updated_at();

create trigger groups_set_updated_at
before update on public.groups
for each row execute function public.set_updated_at();

create trigger challenges_set_updated_at
before update on public.challenges
for each row execute function public.set_updated_at();

create trigger reports_set_updated_at
before update on public.reports
for each row execute function public.set_updated_at();

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, email, username, display_name)
  values (
    new.id,
    new.email,
    split_part(new.email, '@', 1),
    coalesce(new.raw_user_meta_data->>'display_name', split_part(new.email, '@', 1))
  )
  on conflict (id) do nothing;

  insert into public.user_settings (user_id)
  values (new.id)
  on conflict (user_id) do nothing;

  return new;
end;
$$;

create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();
