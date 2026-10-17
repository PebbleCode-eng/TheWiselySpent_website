-- Beta waitlist for the signup form on the-earn-lens.html.
-- Run once in the Supabase SQL editor.

create table if not exists public.beta_waitlist (
  id bigint generated always as identity primary key,
  email text not null unique
    check (char_length(email) <= 254 and email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  platform text not null default 'ios' check (platform in ('ios', 'android')),
  source text check (char_length(source) <= 64),
  created_at timestamptz not null default now()
);

alter table public.beta_waitlist enable row level security;

-- The website can add signups but never read, change or delete them.
drop policy if exists "Anyone can join the waitlist" on public.beta_waitlist;
create policy "Anyone can join the waitlist"
  on public.beta_waitlist
  for insert
  to anon
  with check (true);

revoke all on public.beta_waitlist from anon;
grant insert (email, platform, source) on public.beta_waitlist to anon;
