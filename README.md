# Trust of Tahfiz — Ledger & Accounts

## Files
- `index.html` — main app (Supabase cloud database, login, charts, CSV export, print report)
- `client_ledger.html` — offline version (stores data only in the browser, no login)
- `supabase_schema.sql` — run once in Supabase
- `logo.svg`, `logo.png` — logo

## Setup (cloud version)
1. Create a **new** Supabase project (recommended: do not share one with another ledger).
2. Supabase → SQL Editor → paste all of `supabase_schema.sql` → Run.
3. Open `index.html` (or the hosted site). On first load enter
   *Project URL* and *Anon Key* from Supabase → Project Settings → API.
   (Optional: paste them into `SUPABASE_URL` / `SUPABASE_ANON_KEY` near the top of the `<script>` in `index.html` to skip this screen.)
4. Click **Sign Up**, create your admin account, sign in.
5. Then in Supabase → Authentication → Sign In / Providers, **turn off "Allow new users to sign up"**
   so nobody else can create an account and read the ledger.
