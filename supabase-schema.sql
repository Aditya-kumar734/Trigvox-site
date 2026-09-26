-- Trigvox Supabase database setup
-- Run this entire file in Supabase Dashboard -> SQL Editor.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  name text not null default 'User',
  settings jsonb not null default '{"shareLocation":false,"policeFallback":false,"policeNumber":"112","beeps":true,"cancelPhrase":"Cancel call"}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.contacts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  phone text not null,
  icon text default '👤',
  created_at timestamptz not null default now()
);

create table if not exists public.call_history (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  contact_name text not null,
  phone text not null,
  location_shared boolean not null default false,
  latitude double precision,
  longitude double precision,
  created_at timestamptz not null default now()
);


create table if not exists public.live_locations (
  user_id uuid primary key references auth.users(id) on delete cascade,
  latitude double precision not null,
  longitude double precision not null,
  accuracy double precision,
  active boolean not null default false,
  updated_at timestamptz not null default now()
);
alter table public.live_locations enable row level security;
drop policy if exists "live_location_select_own" on public.live_locations;
drop policy if exists "live_location_insert_own" on public.live_locations;
drop policy if exists "live_location_update_own" on public.live_locations;
create policy "live_location_select_own" on public.live_locations for select using (auth.uid() = user_id);
create policy "live_location_insert_own" on public.live_locations for insert with check (auth.uid() = user_id);
create policy "live_location_update_own" on public.live_locations for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

alter table public.profiles enable row level security;
alter table public.contacts enable row level security;
alter table public.call_history enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
drop policy if exists "profiles_insert_own" on public.profiles;
drop policy if exists "profiles_update_own" on public.profiles;
drop policy if exists "contacts_select_own" on public.contacts;
drop policy if exists "contacts_insert_own" on public.contacts;
drop policy if exists "contacts_update_own" on public.contacts;
drop policy if exists "contacts_delete_own" on public.contacts;
drop policy if exists "history_select_own" on public.call_history;
drop policy if exists "history_insert_own" on public.call_history;
drop policy if exists "history_delete_own" on public.call_history;

create policy "profiles_select_own" on public.profiles for select using (auth.uid() = id);
create policy "profiles_insert_own" on public.profiles for insert with check (auth.uid() = id);
create policy "profiles_update_own" on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);

create policy "contacts_select_own" on public.contacts for select using (auth.uid() = user_id);
create policy "contacts_insert_own" on public.contacts for insert with check (auth.uid() = user_id);
create policy "contacts_update_own" on public.contacts for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "contacts_delete_own" on public.contacts for delete using (auth.uid() = user_id);

create policy "history_select_own" on public.call_history for select using (auth.uid() = user_id);
create policy "history_insert_own" on public.call_history for insert with check (auth.uid() = user_id);
create policy "history_delete_own" on public.call_history for delete using (auth.uid() = user_id);

-- Optional: create a profile automatically whenever a user signs up.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, name)
  values (new.id, coalesce(new.raw_user_meta_data->>'name', split_part(new.email, '@', 1)))
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();
