-- ============================================================
-- 0002_OPSEC_ONLY.sql
-- Fase 0 · Playbook Magnus Radar v1.0 (2026-06-02)
-- ============================================================
-- PROPÓSITO:
--   Remediación de exposición OPSEC ACTIVA en v1.1.12 live.
--   1. Vista predios_publicos · IDÉNTICA al original SIN columna flags.
--   2. Cerrar acceso anon a tabla cruda predios (que hoy expone
--      propietario_rut · propietario_nombre · avaluo · flags via RLS using(true)).
--   3. Mantener grants a la vista pública para que el frontend
--      siga cargando contra predios_publicos.
--
-- SCOPE ESTRICTO (NO toca):
--   - tabla energia (entra en F1)
--   - columnas estratégicas tipo_dominio / estatus_dato / delta_score (F1)
--   - RPC buscar_predios y RPC con gate por plan (F1)
--   - proyectos_seia / eventos / alertas_poligonos (revisar en F1 · también tienen using(true))
--
-- CANON APLICADO:
--   - doctrina-OPSEC-precede-validacion-comercial (P1 absoluto)
--   - doctrina-audit-post-deploy-único-válido (verificación al final · curl desde fuera)
--   - doctrina-decision-cerrada-sin-falsador-no-es-decision (excepción declarada · OPSEC permanente)
--
-- CANONIZAR POST-APLICAR como: EVT-MAGNUS-RADAR-OPSEC-FIX-202606
-- ============================================================

BEGIN;

-- ============================================================
-- 1) DROP de la policy abierta de predios
--    (origen de la fuga · 0001_initial_schema.sql linea 190)
-- ============================================================
DROP POLICY IF EXISTS predios_lectura_publica ON predios;


-- ============================================================
-- 2) Recrear predios_publicos · IDENTICA al original SIN flags
--    Columnas que SE PROYECTAN (9 campos no sensibles):
--      id · rol · sector · area_ha · estado_sii · comuna_codigo
--      geometry (GeoJSON) · lon · lat
--    Columna ELIMINADA: flags
-- ============================================================
DROP VIEW IF EXISTS predios_publicos CASCADE;

CREATE VIEW predios_publicos AS
SELECT
  id,
  rol,
  sector,
  area_ha,
  estado_sii,
  comuna_codigo,
  ST_AsGeoJSON(geom)::json AS geometry,
  ST_X(centroide) AS lon,
  ST_Y(centroide) AS lat
FROM predios
WHERE comuna_codigo IN (
  SELECT codigo FROM comunas WHERE publicado = true
);

COMMENT ON VIEW predios_publicos IS
  'F0 OPSEC 2026-06-02 · vista pública sin flags · sin propietario · sin avalúo · sin metadata estratégica. Canon: doctrina-OPSEC-precede-validacion-comercial';


-- ============================================================
-- 3) REVOKE acceso a tabla cruda predios desde anon
--    (defense in depth · grants explícitos además de drop policy)
-- ============================================================
REVOKE ALL ON predios FROM anon;

-- authenticated también se cierra · en F1 se restablecerá selectivamente
-- vía RPC con gate por plan (intelligence ve flags · pro ve subset · free ve público)
REVOKE ALL ON predios FROM authenticated;


-- ============================================================
-- 4) GRANT SELECT a la vista pública (anon + authenticated)
--    PostgREST expone esto vía /rest/v1/predios_publicos
-- ============================================================
GRANT SELECT ON predios_publicos TO anon;
GRANT SELECT ON predios_publicos TO authenticated;


-- ============================================================
-- 5) Asegurar RLS habilitada en predios (defense in depth)
--    Sin policy abierta · solo service_role pasa
-- ============================================================
ALTER TABLE predios ENABLE ROW LEVEL SECURITY;


COMMIT;


-- ============================================================
-- VERIFICACIÓN DENTRO DEL SQL EDITOR (correr después de COMMIT)
-- ============================================================
--
-- A) La vista pública debe tener 9 columnas · sin "flags":
--    SELECT column_name FROM information_schema.columns
--    WHERE table_name = 'predios_publicos' ORDER BY ordinal_position;
--    Esperado: id · rol · sector · area_ha · estado_sii · comuna_codigo · geometry · lon · lat
--
-- B) Confirmar que NO hay policy abierta en predios:
--    SELECT policyname FROM pg_policies WHERE tablename = 'predios';
--    Esperado: 0 filas (o solo policies restrictivas)
--
-- C) Confirmar que RLS está habilitada:
--    SELECT relrowsecurity FROM pg_class WHERE relname = 'predios';
--    Esperado: t
--
-- D) Confirmar que anon NO tiene SELECT sobre predios:
--    SELECT has_table_privilege('anon', 'predios', 'SELECT');
--    Esperado: false
--
-- E) Confirmar que anon SÍ tiene SELECT sobre predios_publicos:
--    SELECT has_table_privilege('anon', 'predios_publicos', 'SELECT');
--    Esperado: true


-- ============================================================
-- AUDIT POST-DEPLOY · desde FUERA del SQL Editor (canon)
-- Reemplazar PROJECT_REF y ANON_KEY con valores reales
-- ============================================================

/*
SUPABASE_URL="https://PROJECT_REF.supabase.co"
ANON_KEY="ey...ANON_KEY..."

# Q1 · /predios debe rechazar a anon (401 o 403)
curl -s -o /dev/null -w "predios anon → %{http_code}\n" \
  "$SUPABASE_URL/rest/v1/predios?select=*&limit=1" \
  -H "apikey: $ANON_KEY" \
  -H "Authorization: Bearer $ANON_KEY"
# Esperado: 401 ó 403 ó {"code":"42501","message":"permission denied for table predios"}

# Q2 · /predios_publicos debe devolver 200 con 9 keys (sin flags)
curl -s \
  "$SUPABASE_URL/rest/v1/predios_publicos?select=*&limit=1" \
  -H "apikey: $ANON_KEY" \
  -H "Authorization: Bearer $ANON_KEY" | jq '.[0] | keys'
# Esperado: ["area_ha","comuna_codigo","estado_sii","geometry","id","lat","lon","rol","sector"]
# NO debe aparecer "flags" · NO "propietario_rut" · NO "propietario_nombre" · NO "avaluo"

# Q3 · visor live debe seguir cargando
# Abrir https://meher1294.github.io/magnus-radar/v1-h2/
# Verificar:
#   - statusbar dice "Magnus Radar v1.1.12 · La Higuera"
#   - mapa carga predios (sigue habiendo polígonos)
#   - badges "MANDATO MAGNUS" / "ANDES IRON" YA NO aparecen en el panel público
#   - canon doctrina-audit-post-deploy aplica: ese es el HECHO observable de F0 cerrada
*/


-- ============================================================
-- LO QUE ESTE SCRIPT NO HACE (intencional · scope F0)
-- ============================================================
--   - NO toca tabla energia · NO crea subestaciones (F1)
--   - NO crea columnas tipo_dominio / estatus_dato / delta_score (F1)
--   - NO crea RPC buscar_predios con gate por plan (F1)
--   - NO toca proyectos_seia ni su policy abierta (anotar para revisión F1)
--   - NO toca eventos · alertas_poligonos · notificaciones (F1+)
--   - NO instala Edge Function ask (F1)
--   - NO corre scrape_destino_sii.py (F1)
--
-- Si este script falla · revertir con:
--   BEGIN;
--     DROP VIEW IF EXISTS predios_publicos CASCADE;
--     -- restaurar la vista original con flags (ver 0001_initial_schema.sql linea 245)
--     CREATE POLICY predios_lectura_publica ON predios FOR SELECT USING (true);
--     GRANT SELECT ON predios TO anon;
--   COMMIT;
-- (NO recomendado · pero está documentado por canon de reversibilidad)
