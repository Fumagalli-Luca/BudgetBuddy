create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role in ('admin', 'moderator')
      and deleted_at is null
  );
$$;

create or replace function public.is_group_member(check_group_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.group_members
    where group_id = check_group_id
      and user_id = auth.uid()
      and status = 'active'
  );
$$;

create or replace function public.is_group_owner(check_group_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.groups
    where id = check_group_id
      and owner_id = auth.uid()
  );
$$;

create or replace function public.shares_group_with(check_user_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.group_members mine
    join public.group_members theirs on theirs.group_id = mine.group_id
    where mine.user_id = auth.uid()
      and mine.status = 'active'
      and theirs.user_id = check_user_id
      and theirs.status = 'active'
  );
$$;

create or replace function public.owns_goal(check_goal_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.savings_goals
    where id = check_goal_id
      and user_id = auth.uid()
  );
$$;

create or replace function public.prevent_profile_role_escalation()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.role is distinct from old.role and not public.is_admin() then
    raise exception 'Only admins can change profile roles';
  end if;
  return new;
end;
$$;

create trigger profiles_prevent_role_escalation
before update on public.profiles
for each row execute function public.prevent_profile_role_escalation();

alter table public.profiles enable row level security;
alter table public.user_settings enable row level security;
alter table public.expense_categories enable row level security;
alter table public.expenses enable row level security;
alter table public.savings_goals enable row level security;
alter table public.goal_transactions enable row level security;
alter table public.groups enable row level security;
alter table public.group_members enable row level security;
alter table public.badges enable row level security;
alter table public.challenges enable row level security;
alter table public.challenge_participants enable row level security;
alter table public.user_badges enable row level security;
alter table public.insights enable row level security;
alter table public.reports enable row level security;
alter table public.notifications enable row level security;
alter table public.admin_audit_logs enable row level security;

create policy "profiles_select_self_admin_or_group"
on public.profiles
for select
using (
  id = auth.uid()
  or public.is_admin()
  or public.shares_group_with(id)
);

create policy "profiles_insert_self"
on public.profiles
for insert
with check ((id = auth.uid() and role = 'user') or public.is_admin());

create policy "profiles_update_self_or_admin"
on public.profiles
for update
using (id = auth.uid() or public.is_admin())
with check (id = auth.uid() or public.is_admin());

create policy "profiles_delete_admin"
on public.profiles
for delete
using (public.is_admin());

create policy "settings_all_self_or_admin"
on public.user_settings
for all
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

create policy "categories_select_default_own_or_admin"
on public.expense_categories
for select
using (
  (is_default and is_active)
  or owner_id = auth.uid()
  or public.is_admin()
);

create policy "categories_insert_own_or_admin"
on public.expense_categories
for insert
with check (owner_id = auth.uid() or public.is_admin());

create policy "categories_update_own_or_admin"
on public.expense_categories
for update
using (owner_id = auth.uid() or public.is_admin())
with check (owner_id = auth.uid() or public.is_admin());

create policy "categories_delete_own_or_admin"
on public.expense_categories
for delete
using (owner_id = auth.uid() or public.is_admin());

create policy "expenses_all_own_or_admin"
on public.expenses
for all
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

create policy "goals_all_own_or_admin"
on public.savings_goals
for all
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

create policy "goal_transactions_select_own_or_admin"
on public.goal_transactions
for select
using (
  user_id = auth.uid()
  or public.owns_goal(goal_id)
  or public.is_admin()
);

create policy "goal_transactions_insert_own_or_admin"
on public.goal_transactions
for insert
with check (
  user_id = auth.uid()
  and public.owns_goal(goal_id)
  or public.is_admin()
);

create policy "goal_transactions_delete_admin"
on public.goal_transactions
for delete
using (public.is_admin());

create policy "groups_select_member_owner_or_admin"
on public.groups
for select
using (
  owner_id = auth.uid()
  or public.is_group_member(id)
  or public.is_admin()
);

create policy "groups_insert_owner"
on public.groups
for insert
with check (owner_id = auth.uid() or public.is_admin());

create policy "groups_update_owner_or_admin"
on public.groups
for update
using (owner_id = auth.uid() or public.is_admin())
with check (owner_id = auth.uid() or public.is_admin());

create policy "groups_delete_owner_or_admin"
on public.groups
for delete
using (owner_id = auth.uid() or public.is_admin());

create policy "group_members_select_group_member_or_admin"
on public.group_members
for select
using (public.is_group_member(group_id) or public.is_admin());

create policy "group_members_insert_self_owner_or_admin"
on public.group_members
for insert
with check (
  user_id = auth.uid()
  or public.is_group_owner(group_id)
  or public.is_admin()
);

create policy "group_members_update_self_owner_or_admin"
on public.group_members
for update
using (
  user_id = auth.uid()
  or public.is_group_owner(group_id)
  or public.is_admin()
)
with check (
  user_id = auth.uid()
  or public.is_group_owner(group_id)
  or public.is_admin()
);

create policy "group_members_delete_self_owner_or_admin"
on public.group_members
for delete
using (
  user_id = auth.uid()
  or public.is_group_owner(group_id)
  or public.is_admin()
);

create policy "badges_select_all"
on public.badges
for select
using (true);

create policy "badges_admin_write"
on public.badges
for all
using (public.is_admin())
with check (public.is_admin());

create policy "challenges_select_allowed"
on public.challenges
for select
using (
  (visibility = 'public' and is_active)
  or created_by = auth.uid()
  or (group_id is not null and public.is_group_member(group_id))
  or public.is_admin()
);

create policy "challenges_insert_creator_or_admin"
on public.challenges
for insert
with check (created_by = auth.uid() or public.is_admin());

create policy "challenges_update_creator_or_admin"
on public.challenges
for update
using (created_by = auth.uid() or public.is_admin())
with check (created_by = auth.uid() or public.is_admin());

create policy "challenges_delete_creator_or_admin"
on public.challenges
for delete
using (created_by = auth.uid() or public.is_admin());

create policy "challenge_participants_select_allowed"
on public.challenge_participants
for select
using (
  user_id = auth.uid()
  or public.is_admin()
  or exists (
    select 1
    from public.challenges c
    where c.id = challenge_id
      and (
        (c.visibility = 'public' and c.is_active)
        or (c.group_id is not null and public.is_group_member(c.group_id))
      )
  )
);

create policy "challenge_participants_insert_self_or_admin"
on public.challenge_participants
for insert
with check (user_id = auth.uid() or public.is_admin());

create policy "challenge_participants_update_self_or_admin"
on public.challenge_participants
for update
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

create policy "challenge_participants_delete_self_or_admin"
on public.challenge_participants
for delete
using (user_id = auth.uid() or public.is_admin());

create policy "user_badges_select_self_group_or_admin"
on public.user_badges
for select
using (
  user_id = auth.uid()
  or public.shares_group_with(user_id)
  or public.is_admin()
);

create policy "user_badges_admin_write"
on public.user_badges
for all
using (public.is_admin())
with check (public.is_admin());

create policy "insights_all_own_or_admin"
on public.insights
for all
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

create policy "reports_select_reporter_or_admin"
on public.reports
for select
using (reporter_id = auth.uid() or public.is_admin());

create policy "reports_insert_reporter"
on public.reports
for insert
with check (reporter_id = auth.uid());

create policy "reports_update_admin"
on public.reports
for update
using (public.is_admin())
with check (public.is_admin());

create policy "notifications_all_own_or_admin"
on public.notifications
for all
using (user_id = auth.uid() or public.is_admin())
with check (user_id = auth.uid() or public.is_admin());

create policy "audit_logs_select_admin"
on public.admin_audit_logs
for select
using (public.is_admin());

create policy "audit_logs_insert_admin"
on public.admin_audit_logs
for insert
with check (public.is_admin());

create or replace function public.get_admin_aggregate_stats()
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_admin() then
    raise exception 'Admin role required';
  end if;

  return jsonb_build_object(
    'users', (select count(*) from public.profiles where deleted_at is null),
    'expenses', (select count(*) from public.expenses),
    'goals', (select count(*) from public.savings_goals),
    'active_challenges', (select count(*) from public.challenges where is_active),
    'open_reports', (select count(*) from public.reports where status in ('open', 'reviewing')),
    'average_goal_progress', (
      select coalesce(avg(current_amount / nullif(target_amount, 0)), 0)
      from public.savings_goals
    )
  );
end;
$$;

create or replace function public.get_group_scoreboard(check_group_id uuid)
returns table (
  user_id uuid,
  display_name text,
  avatar_emoji text,
  level int,
  streak_count int,
  goal_progress_percentage numeric
)
language plpgsql
security definer
set search_path = public
as $$
begin
  if not (public.is_group_member(check_group_id) or public.is_admin()) then
    raise exception 'Group membership required';
  end if;

  return query
  select
    p.id,
    p.display_name,
    p.avatar_emoji,
    p.level,
    p.streak_count,
    coalesce(avg(g.current_amount / nullif(g.target_amount, 0)) * 100, 0)::numeric(5,2)
  from public.group_members gm
  join public.profiles p on p.id = gm.user_id
  left join public.savings_goals g on g.user_id = p.id and g.status = 'active'
  where gm.group_id = check_group_id
    and gm.status = 'active'
  group by p.id, p.display_name, p.avatar_emoji, p.level, p.streak_count;
end;
$$;

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'avatars',
  'avatars',
  true,
  2097152,
  array['image/png', 'image/jpeg', 'image/webp']
)
on conflict (id) do nothing;

create policy "avatars_public_read"
on storage.objects
for select
using (bucket_id = 'avatars');

create policy "avatars_user_upload"
on storage.objects
for insert
with check (
  bucket_id = 'avatars'
  and auth.uid()::text = (storage.foldername(name))[1]
);

create policy "avatars_user_update"
on storage.objects
for update
using (
  bucket_id = 'avatars'
  and auth.uid()::text = (storage.foldername(name))[1]
)
with check (
  bucket_id = 'avatars'
  and auth.uid()::text = (storage.foldername(name))[1]
);

create policy "avatars_user_delete"
on storage.objects
for delete
using (
  bucket_id = 'avatars'
  and auth.uid()::text = (storage.foldername(name))[1]
);
