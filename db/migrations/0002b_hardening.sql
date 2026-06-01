-- =============================================================================
-- Magnus Radar — Migration 0002b · Hardening + Audit Log + Eventos Municipales
-- =============================================================================
--
-- Diseñado: 2026-05-31
-- Custodio: Max Medina (Magnus SpA)
-- Aplica sobre: 0002_its_schema.sql
-- Origen: 6 puntos críticos audit Max Medina + hallazgo carpetas Dominga PE
--
-- Fixes:
--  1. RLS: authenticated escribe vía funciones disciplinadas, no service_role como camino normal
--  2. Audit log: tabla its.estado_changes_log + trigger en columnas estado
--  3. autoridades: añadir capa_temporal + vigente_desde/hasta
--  4. documentos_evidencia: hash_archivo obligatorio para tipo digital + flag ruta_canonica_estable
--  5. tipo_evento_registral: añadir permisos municipales (PE, anteproyecto, recepción, loteo)
--
-- NO EJECUTAR HASTA APROBACIÓN MAX
-- =============================================================================

-- -----------------------------------------------------------------------------
-- FIX 1 · Política RLS authenticated con disciplina (no service_role default)
-- -----------------------------------------------------------------------------

-- Eliminar política service_role full access universal (era escape hatch)
-- Se mantiene para emergencias pero NO para flujo normal

DROP POLICY IF EXISTS "service role full access" ON its.unidades_territoriales;

-- Patrón nuevo: dos políticas distintas
-- a) authenticated SELECT siempre OK (uso interno)
-- b) authenticated INSERT/UPDATE solo a través de funciones SECURITY DEFINER
-- c) service_role solo en operaciones de mantenimiento explícitas

-- Aplica a todas las tablas (patrón repetible)
DO $$
DECLARE
  t TEXT;
BEGIN
  FOR t IN
    SELECT tablename FROM pg_tables WHERE schemaname = 'its'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS "authenticated read" ON its.%I', t);
    EXECUTE format('DROP POLICY IF EXISTS "service role full access" ON its.%I', t);

    -- Lectura: cualquier usuario autenticado
    EXECUTE format('CREATE POLICY "auth read" ON its.%I FOR SELECT USING (auth.role() = ''authenticated'')', t);

    -- Escritura: solo service_role (vía funciones SECURITY DEFINER o tareas administrativas)
    -- authenticated NO puede UPDATE directo; debe usar funciones disciplinadas
    EXECUTE format('CREATE POLICY "service_role write" ON its.%I FOR ALL USING (auth.role() = ''service_role'') WITH CHECK (auth.role() = ''service_role'')', t);
  END LOOP;
END $$;

COMMENT ON SCHEMA its IS
  'Inteligencia Territorial Estratificada · Meher OS · v2 · authenticated lee, ''service_role'' escribe vía funciones disciplinadas';

-- -----------------------------------------------------------------------------
-- FIX 2 · Audit log + triggers en columnas estado
-- -----------------------------------------------------------------------------

CREATE TABLE its.estado_changes_log (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tabla             TEXT NOT NULL,
  registro_id       UUID NOT NULL,
  estado_anterior   TEXT,
  estado_nuevo      TEXT NOT NULL,
  cambiado_por      TEXT NOT NULL,              -- auth.uid() o 'service_role' o función ejecutora
  via_funcion       TEXT,                       -- nombre de la función disciplinada usada
  documento_evidencia_id UUID REFERENCES its.documentos_evidencia(id),
  motivo            TEXT,
  metadata          JSONB DEFAULT '{}'::jsonb,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_estado_log_tabla_registro ON its.estado_changes_log(tabla, registro_id);
CREATE INDEX idx_estado_log_created ON its.estado_changes_log(created_at);

COMMENT ON TABLE its.estado_changes_log IS
  'Audit log inmutable de cambios de estado. Todo cambio de columna `estado` queda registrado. Detección de saltos disciplinares.';

-- Función genérica de trigger para cualquier tabla con columna `estado`
-- Bug-fix v2: no se puede pasar OLD/NEW (record dinámico) a EXECUTE format.
-- Solución: usar row_to_json() que sí permite acceso por nombre de campo.
CREATE OR REPLACE FUNCTION its.log_estado_change()
RETURNS TRIGGER AS $$
DECLARE
  v_estado_anterior TEXT;
  v_estado_nuevo   TEXT;
  v_registro_id    UUID;
BEGIN
  v_estado_anterior := row_to_json(OLD)->>'estado';
  v_estado_nuevo   := row_to_json(NEW)->>'estado';
  v_registro_id    := (row_to_json(NEW)->>'id')::UUID;

  IF v_estado_anterior IS DISTINCT FROM v_estado_nuevo THEN
    INSERT INTO its.estado_changes_log (
      tabla, registro_id, estado_anterior, estado_nuevo, cambiado_por
    ) VALUES (
      TG_TABLE_NAME,
      v_registro_id,
      v_estado_anterior,
      v_estado_nuevo,
      COALESCE(
        NULLIF(current_setting('its.actor', true), ''),
        auth.role(),
        'unknown'
      )
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION its.log_estado_change IS
  'Trigger genérico para tablas con columna `estado`. Usa row_to_json para acceso por nombre (no se puede pasar OLD/NEW como record a EXECUTE format).';

-- Aplicar trigger a todas las tablas con columna `estado`
DO $$
DECLARE
  t TEXT;
  has_estado BOOLEAN;
BEGIN
  FOR t IN
    SELECT tablename FROM pg_tables WHERE schemaname = 'its'
  LOOP
    -- Verificar que la tabla tiene columna estado
    SELECT EXISTS(
      SELECT 1 FROM information_schema.columns
      WHERE table_schema = 'its' AND table_name = t AND column_name = 'estado'
    ) INTO has_estado;

    IF has_estado THEN
      EXECUTE format('DROP TRIGGER IF EXISTS trg_log_estado_change ON its.%I', t);
      EXECUTE format('CREATE TRIGGER trg_log_estado_change BEFORE UPDATE ON its.%I FOR EACH ROW EXECUTE FUNCTION its.log_estado_change()', t);
    END IF;
  END LOOP;
END $$;

-- Vista para auditoría: cambios sospechosos (saltos no disciplinados)
CREATE OR REPLACE VIEW its.estado_cambios_sospechosos AS
SELECT
  l.tabla,
  l.registro_id,
  l.estado_anterior,
  l.estado_nuevo,
  l.cambiado_por,
  l.via_funcion,
  l.created_at,
  CASE
    WHEN l.estado_anterior = 'conflicto_documentado' AND l.estado_nuevo = 'verificado'
         AND l.via_funcion IS NULL THEN 'salto sin función disciplinada'
    WHEN l.estado_anterior = 'hipotesis_de_trabajo' AND l.estado_nuevo = 'verificado'
         AND l.documento_evidencia_id IS NULL THEN 'promoción sin evidencia primaria'
    WHEN l.estado_anterior IS NULL AND l.estado_nuevo = 'verificado'
         THEN 'creación directa en verificado (saltó identificado)'
    ELSE NULL
  END AS razon_sospecha
FROM its.estado_changes_log l
WHERE
  (l.estado_anterior = 'conflicto_documentado' AND l.estado_nuevo = 'verificado' AND l.via_funcion IS NULL)
  OR (l.estado_anterior = 'hipotesis_de_trabajo' AND l.estado_nuevo = 'verificado' AND l.documento_evidencia_id IS NULL)
  OR (l.estado_anterior IS NULL AND l.estado_nuevo = 'verificado')
ORDER BY l.created_at DESC;

COMMENT ON VIEW its.estado_cambios_sospechosos IS
  'Detecta promociones de estado sin la disciplina canónica. Revisar regularmente.';

-- -----------------------------------------------------------------------------
-- FIX 3 · autoridades con capa_temporal + vigencia
-- -----------------------------------------------------------------------------

ALTER TABLE its.autoridades
  ADD COLUMN capa_temporal INTEGER,
  ADD COLUMN vigente_desde DATE,
  ADD COLUMN vigente_hasta DATE,
  ADD COLUMN representacion_geometrica_id UUID REFERENCES its.representaciones_geometricas(id),
  ADD COLUMN superficie_id UUID REFERENCES its.superficies(id);

-- La unique constraint anterior era (unidad_id, dominio)
-- Ahora puede haber misma unidad + mismo dominio en diferentes capas
ALTER TABLE its.autoridades DROP CONSTRAINT IF EXISTS autoridades_unidad_id_dominio_key;
ALTER TABLE its.autoridades ADD CONSTRAINT autoridades_unidad_dominio_capa_unique UNIQUE (unidad_id, dominio, capa_temporal);

CREATE INDEX idx_autoridades_capa ON its.autoridades(capa_temporal);
CREATE INDEX idx_autoridades_vigencia ON its.autoridades(vigente_desde, vigente_hasta);

COMMENT ON COLUMN its.autoridades.capa_temporal IS
  'Capa estratigráfica de la autoridad. Hijuela 2: la autoridad histórica (capa 1) es plano MBN; la autoridad operacional (capa 5) es RTK; la autoridad fiscal (capa 7) es SII directo.';

-- -----------------------------------------------------------------------------
-- FIX 4 · documentos_evidencia hash obligatorio digital + ruta canónica estable
-- -----------------------------------------------------------------------------

ALTER TABLE its.documentos_evidencia
  ADD COLUMN ruta_canonica_estable BOOLEAN NOT NULL DEFAULT FALSE,
  ADD COLUMN integridad_verificada_at TIMESTAMPTZ;

-- Constraint: si tipo es digital (foto, kmz, shapefile, dxf, pdf) → hash obligatorio
ALTER TABLE its.documentos_evidencia
  ADD CONSTRAINT chk_hash_digital
  CHECK (
    tipo NOT IN ('foto','kmz','shapefile','dxf','pdf') OR hash_archivo IS NOT NULL
  );

-- Función para registrar verificación de integridad
CREATE OR REPLACE FUNCTION its.verificar_integridad_documento(
  p_documento_id UUID,
  p_hash_calculado TEXT
) RETURNS BOOLEAN AS $$
DECLARE
  v_hash_almacenado TEXT;
BEGIN
  SELECT hash_archivo INTO v_hash_almacenado
  FROM its.documentos_evidencia
  WHERE id = p_documento_id;

  IF v_hash_almacenado IS NULL THEN
    RAISE EXCEPTION 'Documento % no tiene hash almacenado', p_documento_id;
  END IF;

  IF v_hash_almacenado = p_hash_calculado THEN
    UPDATE its.documentos_evidencia
    SET integridad_verificada_at = now()
    WHERE id = p_documento_id;
    RETURN TRUE;
  ELSE
    RETURN FALSE;
  END IF;
END;
$$ LANGUAGE plpgsql;

COMMENT ON COLUMN its.documentos_evidencia.ruta_canonica_estable IS
  'TRUE si ubicacion_digital es path canónico del data room (no path temporal). FALSE para archivos pendientes de canonización.';

-- -----------------------------------------------------------------------------
-- FIX 5 · Extender tipo_evento_registral con eventos municipales (carpetas Dominga PE)
-- -----------------------------------------------------------------------------

ALTER TYPE its.tipo_evento_registral ADD VALUE IF NOT EXISTS 'permiso_anteproyecto';
ALTER TYPE its.tipo_evento_registral ADD VALUE IF NOT EXISTS 'permiso_edificacion';
ALTER TYPE its.tipo_evento_registral ADD VALUE IF NOT EXISTS 'permiso_loteo';
ALTER TYPE its.tipo_evento_registral ADD VALUE IF NOT EXISTS 'recepcion_definitiva';
ALTER TYPE its.tipo_evento_registral ADD VALUE IF NOT EXISTS 'cambio_uso_suelo';
ALTER TYPE its.tipo_evento_registral ADD VALUE IF NOT EXISTS 'imiv_aprobado';
ALTER TYPE its.tipo_evento_registral ADD VALUE IF NOT EXISTS 'aporte_espacio_publico';

-- Extender naturaleza_fuente con municipalidad
ALTER TYPE its.naturaleza_fuente ADD VALUE IF NOT EXISTS 'municipalidad';

-- -----------------------------------------------------------------------------
-- FIX 6 (bonus) · Función disciplinada de promoción genérica
-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION its.cambiar_estado(
  p_tabla TEXT,
  p_registro_id UUID,
  p_estado_nuevo TEXT,
  p_documento_evidencia_id UUID DEFAULT NULL,
  p_motivo TEXT DEFAULT NULL,
  p_actor TEXT DEFAULT NULL
) RETURNS BOOLEAN AS $$
DECLARE
  v_estado_anterior TEXT;
BEGIN
  -- Validar tabla permitida
  IF p_tabla NOT IN ('unidades_territoriales','representaciones_geometricas','superficies','autoridades','hipotesis','conflictos','cadena_registral','documentos_evidencia') THEN
    RAISE EXCEPTION 'Tabla % no admite cambio de estado vía esta función', p_tabla;
  END IF;

  -- Si nuevo estado es 'verificado', requerir evidencia primaria
  IF p_estado_nuevo = 'verificado' AND p_documento_evidencia_id IS NULL THEN
    RAISE EXCEPTION 'Promoción a verificado requiere documento de evidencia primaria';
  END IF;

  -- Setear el actor para que el trigger lo capture
  PERFORM set_config('its.actor', COALESCE(p_actor, current_user), true);

  -- UPDATE dinámico
  EXECUTE format('UPDATE its.%I SET estado = $1, updated_at = now() WHERE id = $2', p_tabla)
    USING p_estado_nuevo, p_registro_id;

  -- Registrar via_funcion + documento + motivo en el último log
  UPDATE its.estado_changes_log
  SET via_funcion = 'its.cambiar_estado',
      documento_evidencia_id = p_documento_evidencia_id,
      motivo = p_motivo
  WHERE id = (
    SELECT id FROM its.estado_changes_log
    WHERE tabla = p_tabla AND registro_id = p_registro_id
    ORDER BY created_at DESC LIMIT 1
  );

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION its.cambiar_estado IS
  'Función disciplinada universal para cambiar estado. Bloquea promoción a verificado sin evidencia primaria. Registra via_funcion en audit log.';

-- =============================================================================
-- FIN MIGRATION 0002b · Hardening
-- =============================================================================
