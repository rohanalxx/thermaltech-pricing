# ThermalTech Pricing Suite

HVAC parts pricing, markup calculator, and AI-powered model lookup.

## Setup (Phase 1 — Foundation)

### 1. Supabase
1. Create free account at [supabase.com](https://supabase.com)
2. New project → copy **Project URL** and **anon public key**
3. Open app → Settings ⚙ → paste URL + key → Save
4. In Supabase SQL Editor, run the schema in `supabase-schema.sql`

### 2. Admin PIN
- Default PIN: `1234`
- Change in Settings ⚙ → Admin PIN field → Save

### 3. Enter Admin Mode
- Settings ⚙ → "Enter Admin Mode" → type PIN

### 4. Deploy to GitHub Pages
1. Create GitHub account at github.com
2. New repository: `thermaltech-pricing`
3. Upload this folder
4. Settings → Pages → Source: main branch / root
5. Share the `https://yourusername.github.io/thermaltech-pricing/` URL with techs

### 5. Install as App (techs)
- iPhone: Open URL in Safari → Share → Add to Home Screen
- Android: Open URL in Chrome → ⋮ menu → Add to Home Screen

## Keyboard Shortcuts
- `Alt+1` Part tab
- `Alt+2` Material tab
- `Alt+3` Filter tab
- `Alt+4` Lookup tab
- `Esc` Close modals

## Phases
- ✅ Phase 1 — Foundation (Supabase, PWA, Admin PIN, 4 tabs)
- 🔲 Phase 2 — Lookup Tab (model search, tech censored view, total)
- 🔲 Phase 3 — Admin Panel (units/parts CRUD, reports, AI research)
- 🔲 Phase 4 — Polish (offline cache, mobile refinement)
