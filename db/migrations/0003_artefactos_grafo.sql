-- =============================================================================
-- Magnus Radar · ITS v0.4 · Migration 0003 · Grafo de Artefactos
-- =============================================================================
--
-- Diseñado: 2026-05-31
-- Custodio: Max Medina (Magnus SpA)
-- Aplica PRINCIPIO #1 Meher OS · auditoría operacional previa ejecutada
-- (ver `XPU/La Higuera/00_CORE/PRINCIPIO_ARQUITECTONICO_MEHER_OS.md`)
--
-- ## Reframe estructural respetado
--
-- Este schema NO trata "representaciones geométricas con dependencias".
-- Trata ARTEFACTOS GENÉRICOS con relaciones.
-- Una geometría es solo UN tipo de artefacto. El mismo modelo aplica a:
--   KMZ, GPKG, plano escaneado, inscripción CBR, RCA, oficio sectorial,
--   informe técnico, contrato, foto evidencia.
--
-- ## Auditoría previa ejecutada (PRINCIPIO #1)
--
-- Universo: 24 GPKG + 53 fragmentos de texto analizados.
--
-- Vocabulario del laboratorio que se RESPETA (no traduce):
--   - artefacto_origen / artefacto_destino (NO parent/child en inglés)
--   - tipo_relacion (NO dependency_type)
--   - jerarquia_fuente con valor 'laboratorio' (14 ocurrencias · más frecuente)
--   - naturaleza_geo con valor 'logico_inferido' (14 ocurrencias)
--   - uso con valores específicos del laboratorio (escenario_geometrico_no_canonico, etc.)
--   - nota_degradacion + degradacion_fecha (semántica preservada)
--   - afectado_proxy_corrido (concepto crítico · NO se omite)
--
-- Tipos de relación detectados empíricamente en data room:
--   13 'descalificada_por_offset_vs' (TOPO 2007 vs RTK)
--   12 'derivada_de' (LOTE_B_PROXY ← TOPO 2007, R5_* ← LOTE_B_PROXY)
--   10 'comparada_contra' (todos contra RTK como benchmark)
--    7 'buffer_de' (R5_BUFFER_* ← geometría base)
--    3 'interseccion_con' (VEL_* = buffer ∩ LOTE_B_PROXY)
--    1 'recortada_por' (TOPO2007_SPLIT_BY_RUTA5 ← TOPO + EJE_RUTA_5)
--
-- ## Conceptos del laboratorio que ITS v0.3 NO capturaba (ahora SÍ)
--   - confidence_score_ia
--   - jerarquia_fuente = laboratorio
--   - naturaleza_geo = logico_inferido
--   - uso = escenario_geometrico_no_canonico
--   - afectado_proxy_corrido (con grafo de propagación)
--   - observacion_obligatoria
--   - métricas derivadas (area_ha_dentro_rtk, area_ha_fuera_rtk)
--
-- NO EJECUTAR EN PRODUCCIÓN HASTA APROBACIÓN MANUAL DE MAX
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1 · Enums extendidos del vocabulario del laboratorio
-- -----------------------------------------------------------------------------

-- Tipos de artefacto (super-entidad genérica)
CREATE TYPE its.tipo_artefacto AS ENUM (
  'geometria_vectorial',      -- GPKG, KMZ, GeoJSON, Shapefile, DXF
  'plano_escaneado',          -- HEIC, JPG, TIFF de planos
  'plano_tecnico_digital',    -- DWG, PDF vectorial técnico
  'inscripcion_registral',    -- fs.X N°Y/AAAA del CBR
  'resolucion_administrativa',-- RCA, Res. SEREMI, ST-XXX
  'oficio_sectorial',         -- DGA, SAG, CONADI, SMA
  'informe_tecnico',          -- Due Diligence, Estudio Títulos
  'documento_contractual',    -- Mandato, Compraventa, Cesión
  'foto_evidencia',           -- fotos CBR, RTK overview, cuerpo cartográfico
  'otro'
);

-- Naturaleza geometría (preserva vocabulario laboratorio · valor más frecuente: logico_inferido 14x)
CREATE TYPE its.naturaleza_geo_v2 AS ENUM (
  'fisico_legal',               -- 2x · plano original
  'fisico_legal_topografico',   -- 2x · medición física topográfica
  'fisico_legal_aproximado',    -- 1x · plano aproximado declarado
  'logico_inferido',            -- 14x · derivado por computación (buffer, intersect)
  'no_aplica'                   -- para artefactos no geométricos
);

-- Source truth (de los GPKG del laboratorio)
CREATE TYPE its.source_truth_v2 AS ENUM (
  'fuente_primaria_CBR',
  'fuente_topografica_historica',
  'interchile_2014',
  'levantamiento_propio_RTK',
  'fuente_externa_kmz',
  'fuente_administrativa_oficial',
  'laboratorio_derivado',
  'sin_clasificar'
);

-- Jerarquía fuente (preserva valor más frecuente: laboratorio 14x)
CREATE TYPE its.jerarquia_fuente_v2 AS ENUM (
  'primaria',     -- CBR, SII directo, título original
  'auxiliar',     -- TOPO histórico, croquis propietarios
  'secundaria',   -- InterChile (proveedor externo)
  'laboratorio'   -- artefactos generados por equipo Magnus (14x · más común)
);

-- Tipo de relación entre artefactos (vocabulario empírico del data room)
CREATE TYPE its.tipo_relacion AS ENUM (
  'derivada_de',                       -- 12 ocurrencias · A = transformación de B
  'descalificada_por_offset_vs',       -- 13 ocurrencias · A se descalifica al comparar con B
  'comparada_contra',                  -- 10 ocurrencias · A se valida vs B (benchmark · NO deriva)
  'buffer_de',                         --  7 ocurrencias · A es buffer de B
  'interseccion_con',                  --  3 ocurrencias · A = X ∩ B
  'recortada_por',                     --  1 ocurrencia · A = boundary de B
  'extraida_de',                       -- A es fragmento de B
  'referenciada_por',                  -- A es citada como ejemplo en B (cita normativa)
  'respaldada_por',                    -- A se apoya documentalmente en B
  'hipotesis_apoyada_en'               -- A es hipótesis que se apoya en B
);

-- Modo de propagación cuando un artefacto cambia de estado
CREATE TYPE its.modo_propagacion AS ENUM (
  'automatica_fuerte',   -- derivada_de, buffer_de, interseccion_con, recortada_por, extraida_de
  'sugerida_humana',     -- comparada_contra, referenciada_por
  'no_propagable'        -- respaldada_por, hipotesis_apoyada_en (independientes en estado)
);

-- Uso del artefacto (vocabulario del laboratorio)
CREATE TYPE its.uso_artefacto AS ENUM (
  'operacional_canonico',
  'referencia_historica',
  'escenario_geometrico_no_canonico',         -- 3x en data room
  'interseccion_no_canonico',                 -- 4x
  'buffer_vial_no_canonico',                  -- 4x
  'deslinde_inferido_no_canonico',            -- 1x
  'hipotesis_velasquez_pre2007_no_canonico',  -- 1x
  'referencia_ilustrativa_no_operacional',    -- 1x
  'experimental_descartable'
);

-- -----------------------------------------------------------------------------
-- 2 · Tabla principal · its.artefactos (super-entidad genérica)
-- -----------------------------------------------------------------------------

CREATE TABLE its.artefactos (
  id                            UUID PRIMARY KEY DEFAULT gen_random_uuid(),

  -- Identidad (vocabulario laboratorio)
  id_canonico_propuesto         TEXT NOT NULL UNIQUE,
  nombre                        TEXT NOT NULL,
  tipo                          its.tipo_artefacto NOT NULL,

  -- Procedencia (vocabulario laboratorio)
  fuente_dato                   TEXT,             -- "Levantamiento topográfico encargado por familia Cominetti en 2007"
  fuente_archivo                TEXT,             -- "ContornoTotal_Mar2022.kmz (fecha de nombre engañosa)"
  ano_levantamiento_real        TEXT,             -- "2007" (puede ser distinto al año del archivo)
  origen_digitalizacion         TEXT,             -- "levantamiento_topografico_propietarios"
  soporte_documental            TEXT,             -- "levantamiento_topografico_pendiente_verificacion"

  -- Clasificación canónica
  naturaleza_geo                its.naturaleza_geo_v2,
  source_truth                  its.source_truth_v2,
  jerarquia_fuente              its.jerarquia_fuente_v2 NOT NULL,
  uso                           its.uso_artefacto,

  -- Confianza (preserva DOS dimensiones detectadas en laboratorio)
  nivel_confianza_operacional   TEXT CHECK (nivel_confianza_operacional IN ('alta','media','baja','desconocida')),
  precision_metros              NUMERIC,
  confidence_score_ia           INTEGER CHECK (confidence_score_ia BETWEEN 0 AND 100),

  -- Vigencia y estado disciplinado (preserva semántica)
  vigencia                      TEXT CHECK (vigencia IN ('vigente','validando','superseded','descalificada','revisar','desconocida')),
  estado                        its.estado_evidencia NOT NULL DEFAULT 'identificado',

  -- Desfase declarado
  tiene_desfase_declarado       BOOLEAN DEFAULT FALSE,
  vector_desfase_metros         TEXT,             -- texto · puede ser "~217 m" o "desconocido"

  -- Degradación (preserva campos laboratorio · CRÍTICO para PRINCIPIO #1)
  afectado_proxy_corrido        BOOLEAN DEFAULT FALSE,
  nota_degradacion              TEXT,
  degradacion_fecha             DATE,
  fecha_reclasificacion         DATE,

  -- Hipótesis asociada
  hipotesis_asociada_id         UUID REFERENCES its.hipotesis(id),
  hipotesis_asociada_texto      TEXT,             -- texto si la hipótesis no está aún en tabla

  -- Verificación pendiente (lista de acciones pendientes)
  pendiente_verificacion        TEXT,

  -- Auditoría obligatoria (PRESERVADO del laboratorio · CRÍTICO)
  observacion_obligatoria       TEXT,             -- debe leerse antes de usar el dato

  -- Vínculo con la unidad territorial (FK opcional)
  unidad_territorial_id         UUID REFERENCES its.unidades_territoriales(id),

  -- Geometría (NULLABLE · solo para artefactos geométricos)
  geom                          GEOMETRY,         -- tipo y SRS los define cada artefacto
  geom_srs_id                   INTEGER,          -- EPSG code

  -- Métricas derivadas (si aplican · pueden ser NULL)
  superficie_ha                 NUMERIC,
  superficie_ha_calculada       NUMERIC,
  superficie_ha_declarada       NUMERIC,
  delta_pct                     NUMERIC,
  metricas_derivadas            JSONB,            -- area_ha_dentro_rtk, area_ha_fuera_rtk, etc.

  -- Renombrado histórico
  historial_renombres           TEXT[],           -- equivalente al campo __rename__

  -- Trazabilidad estándar
  fecha_carga_inicial           DATE,
  metadata                      JSONB DEFAULT '{}'::jsonb,
  created_at                    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at                    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_artefactos_tipo ON its.artefactos(tipo);
CREATE INDEX idx_artefactos_jerarquia ON its.artefactos(jerarquia_fuente);
CREATE INDEX idx_artefactos_estado ON its.artefactos(estado);
CREATE INDEX idx_artefactos_vigencia ON its.artefactos(vigencia);
CREATE INDEX idx_artefactos_unidad ON its.artefactos(unidad_territorial_id);
CREATE INDEX idx_artefactos_afectado_proxy ON its.artefactos(afectado_proxy_corrido) WHERE afectado_proxy_corrido = TRUE;
CREATE INDEX idx_artefactos_geom ON its.artefactos USING gist(geom);
CREATE INDEX idx_artefactos_metadata ON its.artefactos USING gin(metadata);
CREATE INDEX idx_artefactos_metricas ON its.artefactos USING gin(metricas_derivadas);

COMMENT ON TABLE its.artefactos IS
  'Super-entidad genérica para artefactos territoriales · subsume representaciones geométricas, planos, inscripciones, oficios, informes, contratos, fotos. PRINCIPIO #1 aplicado · vocabulario del laboratorio preservado.';

-- -----------------------------------------------------------------------------
-- 3 · Tabla its.relaciones_artefactos (grafo causal)
-- -----------------------------------------------------------------------------

CREATE TABLE its.relaciones_artefactos (
  id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  artefacto_origen_id         UUID NOT NULL REFERENCES its.artefactos(id) ON DELETE CASCADE,
  artefacto_destino_id        UUID NOT NULL REFERENCES its.artefactos(id) ON DELETE CASCADE,
  tipo_relacion               its.tipo_relacion NOT NULL,

  -- Modo de propagación (define qué pasa si destino cambia de estado)
  modo_propagacion            its.modo_propagacion NOT NULL,

  -- Confianza en la relación (puede ser distinta de confianza en los artefactos)
  nivel_confianza             TEXT CHECK (nivel_confianza IN ('alta','media','baja','desconocida')) DEFAULT 'media',
  fecha_deteccion             DATE NOT NULL DEFAULT CURRENT_DATE,

  -- Justificación textual (PRESERVA texto original del laboratorio cuando posible)
  justificacion               TEXT NOT NULL,
  operacion_aplicada          TEXT,             -- "buffer 120m + intersect", "split por EJE_RUTA_5", etc.

  -- Audit
  detectada_por               TEXT,             -- "arqueo_automatico_2026-05-31" o nombre humano
  metadata                    JSONB DEFAULT '{}'::jsonb,
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Constraint: no auto-relación
  CONSTRAINT chk_no_auto_relacion CHECK (artefacto_origen_id != artefacto_destino_id),

  -- Unique: una sola relación de cada tipo entre par de artefactos
  CONSTRAINT uq_relacion_origen_destino_tipo UNIQUE (artefacto_origen_id, artefacto_destino_id, tipo_relacion)
);

CREATE INDEX idx_relaciones_origen ON its.relaciones_artefactos(artefacto_origen_id);
CREATE INDEX idx_relaciones_destino ON its.relaciones_artefactos(artefacto_destino_id);
CREATE INDEX idx_relaciones_tipo ON its.relaciones_artefactos(tipo_relacion);
CREATE INDEX idx_relaciones_propagacion ON its.relaciones_artefactos(modo_propagacion);

COMMENT ON TABLE its.relaciones_artefactos IS
  'Grafo causal entre artefactos. tipo_relacion + modo_propagacion permiten responder: "si A se descalifica, qué le pasa a B y por qué". Vocabulario empírico del data room.';

-- -----------------------------------------------------------------------------
-- 4 · Tabla its.eventos_validacion (audit log inmutable)
-- -----------------------------------------------------------------------------

CREATE TYPE its.tipo_evento_validacion AS ENUM (
  'creacion',                         -- artefacto cargado al sistema
  'cambio_estado',                    -- estado_evidencia cambió
  'descalificacion',                  -- vigencia → descalificada
  'rehabilitacion',                   -- vigencia ← previa
  'propagacion_recibida',             -- artefacto fue afectado por cambio en padre
  'propagacion_override',             -- humano marcó "OK a pesar de propagación"
  'verificacion_realizada',           -- alguien verificó contra fuente primaria
  'medicion_actualizada',             -- métricas (superficie, vértices) recalculadas
  'relacion_detectada',               -- nueva arista en grafo
  'relacion_invalidada'               -- arista declarada incorrecta
);

CREATE TABLE its.eventos_validacion (
  id                          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  artefacto_id                UUID NOT NULL REFERENCES its.artefactos(id) ON DELETE CASCADE,
  tipo_evento                 its.tipo_evento_validacion NOT NULL,
  fecha_evento                TIMESTAMPTZ NOT NULL DEFAULT now(),

  -- Quién hizo qué
  actor                       TEXT NOT NULL,    -- 'sistema_propagacion', 'max_medina', 'daniel_rtk', 'arqueo_2026-05-31'
  origen_evento               TEXT,             -- nombre función SQL, script, sesión manual

  -- Si vino por propagación, qué artefacto lo originó
  propagado_desde_artefacto_id UUID REFERENCES its.artefactos(id),
  propagado_via_relacion_id   UUID REFERENCES its.relaciones_artefactos(id),

  -- Cambio específico
  estado_anterior             TEXT,
  estado_nuevo                TEXT,
  motivo                      TEXT NOT NULL,

  -- Override / autorización
  override_humano             BOOLEAN DEFAULT FALSE,
  override_motivo             TEXT,

  -- Datos completos del evento
  payload                     JSONB DEFAULT '{}'::jsonb,
  created_at                  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_eventos_artefacto ON its.eventos_validacion(artefacto_id);
CREATE INDEX idx_eventos_tipo ON its.eventos_validacion(tipo_evento);
CREATE INDEX idx_eventos_fecha ON its.eventos_validacion(fecha_evento);
CREATE INDEX idx_eventos_actor ON its.eventos_validacion(actor);
CREATE INDEX idx_eventos_propagado ON its.eventos_validacion(propagado_desde_artefacto_id) WHERE propagado_desde_artefacto_id IS NOT NULL;

COMMENT ON TABLE its.eventos_validacion IS
  'Audit log inmutable de validaciones, cambios de estado y propagaciones. Toda modificación a artefactos genera una fila aquí. Inmutable.';

-- -----------------------------------------------------------------------------
-- 5 · Vistas operacionales
-- -----------------------------------------------------------------------------

-- 5.1 · Cadena de descendientes (qué se propaga si descalificás un artefacto)
CREATE OR REPLACE VIEW its.artefactos_afectados_si_descalifico AS
WITH RECURSIVE descendientes AS (
  SELECT
    a.id AS root_artefacto_id, a.id_canonico_propuesto AS root, a.id AS afectado_id,
    a.id_canonico_propuesto AS afectado, 0 AS nivel, ARRAY[]::TEXT[] AS cadena
  FROM its.artefactos a
  UNION ALL
  SELECT
    d.root_artefacto_id, d.root, r.artefacto_origen_id, ao.id_canonico_propuesto,
    d.nivel + 1, d.cadena || ao.id_canonico_propuesto
  FROM descendientes d
  JOIN its.relaciones_artefactos r ON r.artefacto_destino_id = d.afectado_id
  JOIN its.artefactos ao ON ao.id = r.artefacto_origen_id
  WHERE r.modo_propagacion = 'automatica_fuerte' AND d.nivel < 10
)
SELECT root, afectado, nivel, cadena FROM descendientes WHERE nivel > 0;

-- 5.2 · Resumen del grafo (cuántos huérfanos, raíces, hojas)
CREATE OR REPLACE VIEW its.grafo_artefactos_resumen AS
SELECT
  count(*) AS artefactos_totales,
  count(*) FILTER (WHERE NOT EXISTS (
    SELECT 1 FROM its.relaciones_artefactos r WHERE r.artefacto_origen_id = a.id
  )) AS raices_sin_padre,
  count(*) FILTER (WHERE NOT EXISTS (
    SELECT 1 FROM its.relaciones_artefactos r WHERE r.artefacto_destino_id = a.id
  )) AS hojas_sin_hijo,
  count(*) FILTER (WHERE NOT EXISTS (
    SELECT 1 FROM its.relaciones_artefactos r WHERE r.artefacto_origen_id = a.id OR r.artefacto_destino_id = a.id
  )) AS huerfanos_aislados,
  count(*) FILTER (WHERE afectado_proxy_corrido) AS afectados_propagacion,
  count(*) FILTER (WHERE vigencia = 'descalificada') AS descalificados,
  (SELECT count(*) FROM its.relaciones_artefactos) AS aristas_totales
FROM its.artefactos a;

-- 5.3 · Vista del audit log filtrada por sospechosos
CREATE OR REPLACE VIEW its.eventos_sospechosos AS
SELECT
  e.id, e.fecha_evento, e.actor, e.tipo_evento,
  a.id_canonico_propuesto AS artefacto,
  e.estado_anterior, e.estado_nuevo, e.motivo,
  CASE
    WHEN e.tipo_evento = 'cambio_estado' AND e.estado_anterior = 'conflicto_documentado' AND e.estado_nuevo = 'verificado' AND NOT e.override_humano
      THEN 'cambio sin override humano explícito'
    WHEN e.tipo_evento = 'rehabilitacion' AND e.override_humano IS FALSE
      THEN 'rehabilitación automática sin verificación humana'
    ELSE NULL
  END AS razon_sospecha
FROM its.eventos_validacion e
JOIN its.artefactos a ON a.id = e.artefacto_id
WHERE
  (e.tipo_evento = 'cambio_estado' AND e.estado_anterior = 'conflicto_documentado' AND e.estado_nuevo = 'verificado' AND NOT e.override_humano)
  OR (e.tipo_evento = 'rehabilitacion' AND e.override_humano IS FALSE);

-- -----------------------------------------------------------------------------
-- 6 · Función disciplinada de propagación
-- -----------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION its.propagar_degradacion(
  p_artefacto_origen_id UUID,
  p_motivo TEXT,
  p_actor TEXT DEFAULT 'sistema_propagacion'
) RETURNS TABLE(
  artefacto_afectado_id UUID,
  artefacto_afectado_codigo TEXT,
  nivel_cadena INTEGER
) AS $$
DECLARE
  v_rec RECORD;
BEGIN
  -- Recorrer todos los descendientes vía modo_propagacion = 'automatica_fuerte'
  FOR v_rec IN
    SELECT a.id, a.id_canonico_propuesto, d.nivel
    FROM its.artefactos_afectados_si_descalifico d
    JOIN its.artefactos a ON a.id_canonico_propuesto = d.afectado
    WHERE d.root = (SELECT id_canonico_propuesto FROM its.artefactos WHERE id = p_artefacto_origen_id)
  LOOP
    -- Marcar como afectado
    UPDATE its.artefactos
    SET afectado_proxy_corrido = TRUE,
        nota_degradacion = COALESCE(nota_degradacion || E'\n\n', '') ||
          '[propagación auto ' || CURRENT_DATE || '] ' || p_motivo,
        updated_at = now()
    WHERE id = v_rec.id;

    -- Audit log
    INSERT INTO its.eventos_validacion (
      artefacto_id, tipo_evento, actor, propagado_desde_artefacto_id,
      motivo, payload
    ) VALUES (
      v_rec.id, 'propagacion_recibida', p_actor, p_artefacto_origen_id,
      p_motivo, jsonb_build_object('nivel_cadena', v_rec.nivel)
    );

    artefacto_afectado_id := v_rec.id;
    artefacto_afectado_codigo := v_rec.id_canonico_propuesto;
    nivel_cadena := v_rec.nivel;
    RETURN NEXT;
  END LOOP;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION its.propagar_degradacion IS
  'Propaga automáticamente degradación a todos los descendientes vía relaciones con modo_propagacion = automatica_fuerte. Registra cada propagación en audit log.';

-- =============================================================================
-- FIN MIGRATION 0003 · Grafo de Artefactos
-- =============================================================================
