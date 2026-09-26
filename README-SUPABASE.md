# Trigvox + Supabase setup

1. Create a project at Supabase.
2. Open **SQL Editor** and run `supabase-schema.sql`.
3. Open **Project Settings -> API**.
4. Copy the **Project URL** and the **anon/public key**.
5. Open `index.html` and replace:
   - `YOUR_SUPABASE_URL`
   - `YOUR_SUPABASE_ANON_KEY`
6. Deploy the `trigvox_host` folder to your host (Vercel, Netlify, GitHub Pages with the needed SPA/static setup, etc.).

The app uses Supabase Auth for email/password login and stores profiles, contacts, settings and call history in Postgres. Passwords are handled by Supabase Auth; the app does not store them in localStorage.

If email confirmation is enabled in Supabase Auth, a new user must confirm their email before the first login. For testing, this can be changed under Authentication settings.
