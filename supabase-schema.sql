-- ══════════════════════════════════════════════════════════════
-- ThermalTech Pricing Suite — Supabase Schema
-- Run this in: Supabase Dashboard → SQL Editor → New Query
-- ══════════════════════════════════════════════════════════════

-- 1. Units table
CREATE TABLE IF NOT EXISTS units (
  model_number  TEXT PRIMARY KEY,
  brand         TEXT,
  unit_type     TEXT,
  tonnage       TEXT,
  notes         TEXT,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Parts table
CREATE TABLE IF NOT EXISTS parts (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  unit_model    TEXT NOT NULL REFERENCES units(model_number) ON DELETE CASCADE,
  part_number   TEXT,
  description   TEXT NOT NULL,
  category      TEXT DEFAULT 'Other',
  cost          DECIMAL(10,2) DEFAULT 0,
  sell_price    DECIMAL(10,2) DEFAULT 0,
  superseded_by TEXT,   -- newer part number (one level)
  supersedes    TEXT,   -- older part number (one level)
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Labour defaults table
CREATE TABLE IF NOT EXISTS labour_defaults (
  category      TEXT PRIMARY KEY,
  default_hours DECIMAL(4,1) NOT NULL DEFAULT 1.0
);

-- 4. Reports table (unknown models flagged by techs)
CREATE TABLE IF NOT EXISTS reports (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  model_number  TEXT NOT NULL,
  notes         TEXT,
  status        TEXT DEFAULT 'pending',
  reported_at   TIMESTAMPTZ DEFAULT NOW()
);

-- ── Indexes for fast lookups ──────────────────
CREATE INDEX IF NOT EXISTS idx_parts_unit_model ON parts(unit_model);
CREATE INDEX IF NOT EXISTS idx_reports_status    ON reports(status);

-- ── Seed default labour hours ─────────────────
INSERT INTO labour_defaults (category, default_hours) VALUES
  ('Compressor',         5.0),
  ('Motor / Fan Motor',  1.5),
  ('Capacitor',          0.5),
  ('Control Board',      1.5),
  ('Valve',              2.0),
  ('Sensor / Thermostat',0.5),
  ('Heat Exchanger',     4.0),
  ('Coil',               3.0),
  ('Pump',               2.5),
  ('Igniter / Burner',   1.0),
  ('Filter Dryer',       1.0),
  ('Contactor',          0.5),
  ('Relay',              0.5),
  ('Transformer',        1.0),
  ('Blower',             1.5),
  ('Damper',             1.0),
  ('Other',              1.0)
ON CONFLICT (category) DO NOTHING;

-- ── Row Level Security (RLS) ──────────────────
-- Enable RLS on all tables
ALTER TABLE units           ENABLE ROW LEVEL SECURITY;
ALTER TABLE parts           ENABLE ROW LEVEL SECURITY;
ALTER TABLE labour_defaults ENABLE ROW LEVEL SECURITY;
ALTER TABLE reports         ENABLE ROW LEVEL SECURITY;

-- Public read access (techs can look up without auth)
CREATE POLICY "Public read units"    ON units           FOR SELECT USING (true);
CREATE POLICY "Public read parts"    ON parts           FOR SELECT USING (true);
CREATE POLICY "Public read labour"   ON labour_defaults FOR SELECT USING (true);

-- Public insert for reports (techs can submit reports)
CREATE POLICY "Public insert reports" ON reports FOR INSERT WITH CHECK (true);

-- Public read reports (admin reads them via anon key — Phase 3 will tighten this)
CREATE POLICY "Public read reports"   ON reports FOR SELECT USING (true);

-- Full access for all operations via anon key (admin uses same key)
-- In production, replace with proper auth. For internal tool this is fine.
CREATE POLICY "Anon full units"    ON units           FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Anon full parts"    ON parts           FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Anon full labour"   ON labour_defaults FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Anon full reports"  ON reports         FOR ALL USING (true) WITH CHECK (true);
