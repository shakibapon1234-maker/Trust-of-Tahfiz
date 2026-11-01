-- ============================================================
-- Trust of Tahfiz - Ledger & Accounts
-- Run this ONCE in: Supabase Dashboard -> SQL Editor -> New query -> Run
-- (Safe to run again: it will not duplicate or break anything.)
-- ============================================================

create extension if not exists pgcrypto;

-- ------------------------------------------------------------
-- 1) Tables
-- ------------------------------------------------------------
create table if not exists public.tahfiz_ledger_entries (
    id uuid primary key default gen_random_uuid(),
    type text not null check (type in ('income', 'expense', 'transfer')),
    amount numeric(14, 2) not null check (amount > 0),
    category text not null,
    account text not null,
    transfer_account text,
    date date not null default current_date,
    notes text not null default 'No description',
    created_at timestamptz not null default now()
);

create table if not exists public.tahfiz_ledger_sources (
    id uuid primary key default gen_random_uuid(),
    name text not null unique,
    created_at timestamptz not null default now()
);

create table if not exists public.tahfiz_ledger_categories (
    id uuid primary key default gen_random_uuid(),
    name text not null unique,
    created_at timestamptz not null default now()
);

create table if not exists public.tahfiz_ledger_accounts (
    id uuid primary key default gen_random_uuid(),
    name text not null unique,
    created_at timestamptz not null default now()
);

create index if not exists tahfiz_ledger_entries_date_idx
    on public.tahfiz_ledger_entries (date desc, created_at desc);

-- ------------------------------------------------------------
-- 2) Row Level Security (only logged-in users can access data)
-- ------------------------------------------------------------
alter table public.tahfiz_ledger_entries    enable row level security;
alter table public.tahfiz_ledger_sources    enable row level security;
alter table public.tahfiz_ledger_categories enable row level security;
alter table public.tahfiz_ledger_accounts   enable row level security;

-- entries: read / add / update / delete
drop policy if exists "Tahfiz: read entries"   on public.tahfiz_ledger_entries;
drop policy if exists "Tahfiz: add entries"    on public.tahfiz_ledger_entries;
drop policy if exists "Tahfiz: update entries" on public.tahfiz_ledger_entries;
drop policy if exists "Tahfiz: delete entries" on public.tahfiz_ledger_entries;
create policy "Tahfiz: read entries"   on public.tahfiz_ledger_entries for select to authenticated using (true);
create policy "Tahfiz: add entries"    on public.tahfiz_ledger_entries for insert to authenticated with check (true);
create policy "Tahfiz: update entries" on public.tahfiz_ledger_entries for update to authenticated using (true) with check (true);
create policy "Tahfiz: delete entries" on public.tahfiz_ledger_entries for delete to authenticated using (true);

-- sources: read / add / delete
drop policy if exists "Tahfiz: read sources"   on public.tahfiz_ledger_sources;
drop policy if exists "Tahfiz: add sources"    on public.tahfiz_ledger_sources;
drop policy if exists "Tahfiz: delete sources" on public.tahfiz_ledger_sources;
create policy "Tahfiz: read sources"   on public.tahfiz_ledger_sources for select to authenticated using (true);
create policy "Tahfiz: add sources"    on public.tahfiz_ledger_sources for insert to authenticated with check (true);
create policy "Tahfiz: delete sources" on public.tahfiz_ledger_sources for delete to authenticated using (true);

-- categories: read / add / delete
drop policy if exists "Tahfiz: read categories"   on public.tahfiz_ledger_categories;
drop policy if exists "Tahfiz: add categories"    on public.tahfiz_ledger_categories;
drop policy if exists "Tahfiz: delete categories" on public.tahfiz_ledger_categories;
create policy "Tahfiz: read categories"   on public.tahfiz_ledger_categories for select to authenticated using (true);
create policy "Tahfiz: add categories"    on public.tahfiz_ledger_categories for insert to authenticated with check (true);
create policy "Tahfiz: delete categories" on public.tahfiz_ledger_categories for delete to authenticated using (true);

-- accounts: read / add / delete
drop policy if exists "Tahfiz: read accounts"   on public.tahfiz_ledger_accounts;
drop policy if exists "Tahfiz: add accounts"    on public.tahfiz_ledger_accounts;
drop policy if exists "Tahfiz: delete accounts" on public.tahfiz_ledger_accounts;
create policy "Tahfiz: read accounts"   on public.tahfiz_ledger_accounts for select to authenticated using (true);
create policy "Tahfiz: add accounts"    on public.tahfiz_ledger_accounts for insert to authenticated with check (true);
create policy "Tahfiz: delete accounts" on public.tahfiz_ledger_accounts for delete to authenticated using (true);

-- ------------------------------------------------------------
-- 3) Default income sources, expense categories and accounts
--    (you can add / remove these later from the app's Configurations tab)
-- ------------------------------------------------------------
insert into public.tahfiz_ledger_sources (name) values
    ('Donation (Sadaqah)'),
    ('Zakat Fund'),
    ('Monthly Student Fees'),
    ('Sponsor / Patron'),
    ('Lillah Fund'),
    ('Other Income')
on conflict (name) do nothing;

insert into public.tahfiz_ledger_categories (name) values
    ('Teacher Salaries'),
    ('Student Meals'),
    ('Building Rent'),
    ('Utility Bills'),
    ('Books & Study Materials'),
    ('Maintenance & Repairs'),
    ('Student Welfare'),
    ('Miscellaneous')
on conflict (name) do nothing;

insert into public.tahfiz_ledger_accounts (name) values
    ('Cash'),
    ('Bank Account'),
    ('bKash'),
    ('Nagad')
on conflict (name) do nothing;
