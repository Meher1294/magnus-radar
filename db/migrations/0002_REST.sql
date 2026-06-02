-- ============================================================
-- 0002_REST.sql · Fase 1 · Playbook Magnus Radar v1.0 (2026-06-02)
-- ============================================================
-- TODO 0002 MENOS la parte OPSEC (ya aplicada en F0 vía 0002_OPSEC_ONLY.sql)
-- Agrega: tabla energía + columnas estratégicas en predios + RPC buscar_predios
--
-- ORDEN DE DESPLIEGUE F1:
--   1. Este archivo (0002_REST.sql) en Supabase SQL Editor → Run
--   2. Luego 0003_seed_energia.sql (subestaciones + 4 líneas SEN reales)
--   3. Edge Function ask (CLI · supabase functions deploy ask)
--   4. Patch ask-frontend.js en web/index.html → git push
--   5. scrape_destino_sii.py en VPS (nohup · 5-6h background)
--   6. Audit post-deploy + 3 queries canónicas Q1/Q2/Q3
--
-- ALCANCE CANON (canon doctrina-decision-cerrada-sin-falsador):
--   - 1 cerebro (free) · sin RAG · sin Diario Oficial · sin agente
--   - el gate por plan está EN EL RPC (auto-gatea columnas estratégicas)
--   - anon = free = campos públicos
--   - tiers · agente · RAG → F3 (gateado por F2)
--
-- CANONIZAR POST-VERDE como: EVT-MAGNUS-RADAR-F1-DEMO-202606
-- ============================================================


-- ============================================================
-- 1. INFRAESTRUCTURA ENERGÍA (tabla queryable · seed real en 0003)
-- ============================================================
CREATE TABLE IF NOT EXISTS infraestructura_energia (
  id            bigserial PRIMARY KEY,
  comuna_codigo integer REFERENCES comunas(codigo) DEFAULT 4102,
  tipo          text NOT NULL,                  -- 'subestacion' | 'linea' | 'nodo'
  nombre        text NOT NULL,
  tension_kv    numeric,
  vertimiento   boolean DEFAULT false,
  capacidad_mw  numeric,
  geom          geometry(Geometry, 4326) NOT NULL,
  estatus_dato  text DEFAULT 'T2',
  fuente        text,
  metadata      jsonb,
  created_at    timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS energia_geom_gix ON infraestructura_energia USING gist(geom);
CREATE INDEX IF NOT EXISTS energia_tipo_idx ON infraestructura_energia(tipo);

COMMENT ON TABLE infraestructura_energia IS
  'F1 Playbook v1.0 · capa energía queryable · seed real en 0003_seed_energia.sql · subestaciones + líneas SEN · estatus_dato T0/T1/T2 según fuente';


-- ============================================================
-- 2. COLUMNAS ESTRATÉGICAS EN PREDIOS (gate por plan vía RPC)
-- ============================================================
ALTER TABLE predios ADD COLUMN IF NOT EXISTS tipo_dominio text;
ALTER TABLE predios ADD COLUMN IF NOT EXISTS estatus_dato text DEFAULT 'T2';
ALTER TABLE predios ADD COLUMN IF NOT EXISTS delta_score  numeric;

COMMENT ON COLUMN predios.tipo_dominio IS
  'F1 · privado/hereditaria/fragmentada/fiscal/desconocido · curación en 0003 + masiva CSV/CBR (F3)';
COMMENT ON COLUMN predios.estatus_dato IS
  'F1 · T0 (validado terreno) / T1 (validado documento) / T2 (catastral) · canon trazabilidad';
COMMENT ON COLUMN predios.delta_score IS
  'F1 · cache opcional del scoring · si NULL el RPC lo calcula on-the-fly · visible solo intelligence';


-- ============================================================
-- 3. RPC: buscar_predios · motor del chat F1
--    Auto-gatea columnas estratégicas según plan del usuario:
--      anon/free → solo campos públicos
--      pro/intelligence → tipo_dominio + avaluo_fiscal_uf + delta_score
-- ============================================================
CREATE OR REPLACE FUNCTION buscar_predios(
  p_sector                  text default null,
  p_min_area                numeric default null,
  p_max_area                numeric default null,
  p_destino                 text default null,
  p_max_avaluo_uf           numeric default null,
  p_tipo_dominio            text[] default null,
  p_max_dist_subestacion_km numeric default null,
  p_requiere_vertimiento    boolean default null,
  p_max_dist_seia_km        numeric default null,
  p_intel                   boolean default false,
  p_limit                   int default 60
)
RETURNS TABLE (
  id bigint, rol text, sector text, area_ha numeric,
  destino_sii text, estado_sii text,
  lon double precision, lat double precision,
  dist_subestacion_km numeric, dist_seia_km numeric,
  tipo_dominio text, estatus_dato text, avaluo_fiscal_uf numeric, delta_score numeric
)
LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
DECLARE
  v_plan text;
  v_intel boolean;
BEGIN
  -- Determinar plan del usuario (anon = free)
  v_plan  := COALESCE((SELECT plan::text FROM usuarios WHERE id = auth.uid()), 'free');
  v_intel := p_intel AND v_plan IN ('pro','intelligence');

  RETURN QUERY
  WITH sub AS (
    SELECT geom FROM infraestructura_energia
    WHERE tipo = 'subestacion'
      AND (p_requiere_vertimiento IS NOT TRUE OR vertimiento = true)
  ),
  base AS (
    SELECT p.*,
      (SELECT MIN(ST_Distance(p.centroide::geography, s.geom::geography))/1000.0 FROM sub s) AS d_sub,
      (SELECT MIN(ST_Distance(p.centroide::geography, ps.geom::geography))/1000.0
         FROM proyectos_seia ps WHERE ps.comuna_codigo = p.comuna_codigo) AS d_seia
    FROM predios p
    WHERE p.comuna_codigo = 4102
      AND (p_sector       IS NULL OR p.sector = p_sector)
      AND (p_min_area     IS NULL OR p.area_ha >= p_min_area)
      AND (p_max_area     IS NULL OR p.area_ha <= p_max_area)
      AND (p_destino      IS NULL OR p.destino_sii ILIKE '%'||p_destino||'%')
      AND (p_max_avaluo_uf IS NULL OR p.avaluo_fiscal_uf <= p_max_avaluo_uf)
      AND (p_tipo_dominio IS NULL OR p.tipo_dominio = ANY(p_tipo_dominio))
  )
  SELECT
    b.id, b.rol, b.sector, b.area_ha, b.destino_sii, b.estado_sii,
    ST_X(b.centroide), ST_Y(b.centroide),
    ROUND(b.d_sub::numeric, 2), ROUND(b.d_seia::numeric, 2),
    CASE WHEN v_intel THEN b.tipo_dominio END,
    b.estatus_dato,
    CASE WHEN v_intel THEN b.avaluo_fiscal_uf END,
    CASE WHEN v_intel THEN COALESCE(b.delta_score, (
        LEAST(100,
          COALESCE(CASE WHEN b.d_sub <= 2 THEN 30 WHEN b.d_sub <= 5 THEN 20 WHEN b.d_sub <= 10 THEN 10 ELSE 0 END, 0)
          + CASE WHEN b.tipo_dominio IN ('hereditaria','fragmentada','fiscal') THEN 25 ELSE 5 END
          + CASE WHEN b.destino_sii ILIKE '%eriaz%' THEN 15 ELSE 5 END
          + CASE WHEN b.area_ha >= 1000 THEN 20 WHEN b.area_ha >= 100 THEN 12 ELSE 6 END
        )
    )::numeric) END
  FROM base b
  WHERE (p_max_dist_subestacion_km IS NULL OR b.d_sub <= p_max_dist_subestacion_km)
    AND (p_max_dist_seia_km        IS NULL OR b.d_seia <= p_max_dist_seia_km)
  ORDER BY
    CASE WHEN v_intel THEN COALESCE(b.delta_score, 0) ELSE b.area_ha END DESC NULLS LAST
  LIMIT p_limit;
END $$;

-- Grant a anon y authenticated · el gate por plan vive dentro de la función
GRANT EXECUTE ON FUNCTION buscar_predios TO anon, authenticated;

COMMENT ON FUNCTION buscar_predios IS
  'F1 Playbook v1.0 · motor del chat NL · auto-gatea columnas estratégicas por plan (anon=free=público · pro/intelligence=delta_score/tipo_dominio/avaluo) · alcance F1: 1 cerebro free · tiers reales en F3';


-- ============================================================
-- VERIFICACIÓN INTRA-SQL_EDITOR (correr después de RUN)
-- ============================================================
-- A) Confirmar tabla energía existe y vacía (seed real en 0003):
--    SELECT count(*) FROM infraestructura_energia;
--    Esperado: 0 (se llena con 0003_seed_energia.sql)
--
-- B) Confirmar columnas nuevas en predios:
--    SELECT column_name FROM information_schema.columns
--    WHERE table_name = 'predios' AND column_name IN ('tipo_dominio','estatus_dato','delta_score');
--    Esperado: 3 filas
--
-- C) Confirmar RPC creada:
--    SELECT proname FROM pg_proc WHERE proname = 'buscar_predios';
--    Esperado: 1 fila
--
-- D) Test RPC mínimo (con tabla energía vacía · distancias serán NULL):
--    SELECT rol, area_ha FROM buscar_predios(p_limit => 3);
--    Esperado: 3 filas de predios · sin tipo_dominio (anon=free)
--
-- E) Confirmar grants:
--    SELECT has_function_privilege('anon', 'buscar_predios(text,numeric,numeric,text,numeric,text[],numeric,boolean,numeric,boolean,int)', 'EXECUTE');
--    Esperado: true

-- ============================================================
-- LO QUE ESTE SCRIPT NO HACE (intencional · scope F1 parcial)
-- ============================================================
-- - NO siembra subestaciones reales · NO siembra líneas SEN (0003)
-- - NO marca tipo_dominio Cominetti / 78-2 (0003)
-- - NO instala Edge Function ask (CLI · paso 2 del runbook)
-- - NO toca proyectos_seia / eventos / alertas (F3+)
-- - NO crea 3 cerebros por plan (F3 gateado por F2)
-- - NO RAG · NO Diario Oficial · NO agente
--
-- Siguiente paso: 0003_seed_energia.sql
