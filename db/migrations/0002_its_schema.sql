-- =============================================================================
-- Magnus Radar — Migration 0002 · Schema ITS v2 (Inteligencia Territorial Estratificada)
-- =============================================================================
--
-- Diseñado: 2026-05-31
-- Custodio: Max Medina (Magnus SpA)
-- Doctrina: CANON_HIJUELA2_v1.2 + ranking ITS Meher OS
-- Caso de prueba: Hijuela 2 Cominetti
--
-- PRINCIPIOS:
-- - Schema separado en namespace `its.` — NO toca tablas v1 (`public.*` actuales)
-- - Ontología: territorio → unidad_territorial → (representaciones, superficies, autoridades, hipotesis, conflictos, cadena_registral)
-- - Vocabulario de estados disciplinado (sin promoción por presión operacional)
-- - Evidencia primaria obligatoria para subir a estado `verificado`
-- - Reutilizable: cualquier expediente territorial complejo (Dominga, Club Ecuestre, Mocito Guapo, etc.)
--
-- NO EJECUTAR EN PRODUCCIÓN HASTA APROBACIÓN MANUAL DE MAX
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 0 · Schema namespace y dependencias
-- -----------------------------------------------------------------------------

CREATE SCHEMA IF NOT EXISTS its;
COMMENT ON SCHEMA its IS 'Inteligencia Territorial Estratificada · Meher OS · v2';

-- PostGIS ya cargado desde 0001
-- pgcrypto para gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- -----------------------------------------------------------------------------
-- 1 · Enums de estados (vocabulario disciplinado)
-- -----------------------------------------------------------------------------

CREATE TYPE its.estado_evidencia AS ENUM (
  'verificado',                       -- respaldado por autoridad primaria
  'identificado',                     -- existe y se sabe cuál es; falta extracción completa
  'localizado_pendiente_extraccion',  -- se sabe dónde está y cómo conseguirlo; aún no se tiene
  'parcialmente_verificado',          -- un elemento confirmado, otro pendiente
  'hipotesis_de_trabajo',             -- explicación útil, evidencia indirecta, no promovida
  'conflicto_documentado',            -- divergencia entre fuentes registrada
  'superseded',                       -- superado por evidencia/versión posterior, conservado
  'descalificado'                     -- descartado por evidencia contraria firme
);

CREATE TYPE its.tipo_representacion AS ENUM (
  'historica',                        -- plano matriz, saneamiento DL 2.695
  'juridica',                         -- subdivisión escriturada, plano CBR
  'operacional_intermedia',           -- KMZ proyecto, levantamientos rápidos
  'medicion_rtk',                     -- RTK / GPS de precisión
  'medicion_topografica',             -- topografía tradicional
  'imagen_satelital',                 -- ortofoto, SPOT, Sentinel
  'derivada_publica'                  -- IDE Chile, CIREN, BCN
);

CREATE TYPE its.naturaleza_superficie AS ENUM (
  'historica_matriz',                 -- plano matriz original
  'juridica_consolidada',             -- estudio títulos
  'operacional_rtk',                  -- medición directa actual
  'fiscal_sii',                       -- avalúo SII
  'mandato_declarada',                -- cifra contractual
  'expropiada',                       -- MOP, otros
  'gravada_servidumbre'               -- afecta a servidumbres
);

CREATE TYPE its.tipo_evento_registral AS ENUM (
  'saneamiento_dl_2695',
  'compraventa',
  'cesion_derechos',
  'subdivision',
  'fusion_predial',
  'expropiacion',
  'servidumbre_constitucion',
  'servidumbre_extincion',
  'hipoteca',
  'usufructo',
  'adjudicacion_particion',
  'dacion_pago',
  'mandato',
  'plano_registrado',
  'rectificacion',
  'cancelacion',
  'cambio_rol'
);

CREATE TYPE its.tipo_conflicto AS ENUM (
  'divergencia_superficie',
  'divergencia_geometria',
  'gap_documental',
  'rol_no_equivalente',
  'titular_no_conciliado',
  'deslinde_no_definido',
  'autoridad_no_resuelta',
  'hipotesis_no_validada'
);

CREATE TYPE its.naturaleza_fuente AS ENUM (
  'cbr',                              -- Conservador de Bienes Raíces
  'notaria',                          -- Notarías
  'sii',                              -- Servicio de Impuestos Internos
  'bbnn_seremi',                      -- Bienes Nacionales SEREMI
  'mop_dgop',                         -- MOP DGOP expropiaciones
  'sea_sma',                          -- SEA / SMA ambiental
  'dga',                              -- Derechos agua
  'ciren',                            -- CIREN suelo
  'ide_chile_geoportal',              -- IDE Chile + Geoportal Nacional
  'bcn',                              -- BCN vectorial
  'osm',                              -- OpenStreetMap
  'levantamiento_propio',             -- XPU, RTK Magnus
  'estudio_titulos',                  -- abogado externo
  'plano_matriz_mbn',                 -- plano MBN saneamiento
  'kmz_proyecto',                     -- KMZ interno
  'investigacion_propia'
);

-- -----------------------------------------------------------------------------
-- 2 · Catálogos
-- -----------------------------------------------------------------------------

-- 2.1 · Ranking canónico de fuentes ITS / Meher OS (8 fuentes, prioridad estructural)
CREATE TABLE its.fuentes_ranking (
  prioridad   INTEGER PRIMARY KEY,
  fuente      TEXT NOT NULL UNIQUE,
  valor       TEXT NOT NULL,
  notas       TEXT
);

INSERT INTO its.fuentes_ranking (prioridad, fuente, valor, notas) VALUES
  (1, 'IDE Chile + Geoportal Nacional', 'columna vertebral pública',     'Catastro nacional, divisiones administrativas, capas regulatorias oficiales'),
  (2, 'Xpert Urban / RTK',              'geometría operacional',         'Precisión medida en terreno (XPU + RTK Magnus)'),
  (3, 'CBR + estudio de títulos',       'capa jurídica',                 'Dominio, gravámenes, cabida consolidada'),
  (4, 'CIREN',                          'suelo agrícola y rural',        'Capacidad de uso, clase, riego'),
  (5, 'OSM',                            'infraestructura comunitaria',   'Caminos, edificaciones, POIs'),
  (6, 'BCN vectorial',                  'contexto territorial',          'Límites, comunas, distritos'),
  (7, 'SII',                            'fiscal',                        'Rol, avalúo, contribuciones — NO autoridad cabida'),
  (8, 'SEIA / SMA / DGA',               'capa regulatoria',              'Proyectos, sanciones, derechos de agua');

COMMENT ON TABLE its.fuentes_ranking IS 'Ranking canónico adoptado sesión 2026-05-31 Max Medina · CANON §8.6';

-- 2.2 · Catálogo extendido de fuentes específicas (instancias del ranking)
CREATE TABLE its.fuentes (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre          TEXT NOT NULL,
  naturaleza      its.naturaleza_fuente NOT NULL,
  ranking_prioridad INTEGER REFERENCES its.fuentes_ranking(prioridad),
  organismo       TEXT,
  url_o_ubicacion TEXT,
  notas           TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_fuentes_naturaleza ON its.fuentes(naturaleza);
CREATE INDEX idx_fuentes_ranking ON its.fuentes(ranking_prioridad);

-- 2.3 · Titulares (personas naturales o jurídicas)
CREATE TABLE its.titulares (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre          TEXT NOT NULL,
  rut             TEXT,
  tipo            TEXT CHECK (tipo IN ('persona_natural','persona_juridica','sucesion','comunidad','desconocido')),
  estado          TEXT CHECK (estado IN ('vivo','fallecido','vigente','disuelta','desconocido')) DEFAULT 'vigente',
  domicilio       TEXT,
  notas           TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (nombre, rut)
);

CREATE INDEX idx_titulares_rut ON its.titulares(rut);

-- 2.4 · Documentos / evidencia (fotos, escrituras, planos, oficios)
CREATE TABLE its.documentos_evidencia (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  fuente_id        UUID REFERENCES its.fuentes(id),
  tipo             TEXT NOT NULL,  -- 'foto', 'escritura', 'plano', 'oficio', 'inscripcion', 'kmz', 'shapefile', 'dxf'
  identificador    TEXT NOT NULL,  -- p.ej. "fs. 97 N°91/1990" o "PHOTO-2026-05-17-18-19-39 5.jpg"
  fecha_documento  DATE,
  ubicacion_fisica TEXT,           -- archivo, CBR, notaría
  ubicacion_digital TEXT,          -- path en data room, URL Supabase Storage
  hash_archivo     TEXT,           -- SHA-256 si está digitalizado
  descripcion      TEXT,
  metadata         JSONB DEFAULT '{}'::jsonb,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (fuente_id, identificador)
);

CREATE INDEX idx_documentos_tipo ON its.documentos_evidencia(tipo);
CREATE INDEX idx_documentos_fecha ON its.documentos_evidencia(fecha_documento);
CREATE INDEX idx_documentos_metadata ON its.documentos_evidencia USING gin(metadata);

-- -----------------------------------------------------------------------------
-- 3 · Núcleo ontológico
-- -----------------------------------------------------------------------------

-- 3.1 · Territorios (nivel macro: Estancia La Higuera, etc.)
CREATE TABLE its.territorios (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nombre          TEXT NOT NULL UNIQUE,
  tipo            TEXT CHECK (tipo IN ('estancia','fundo','sector','poblado','area_proyecto','comuna_completa')),
  comuna          TEXT,
  provincia       TEXT,
  region          TEXT,
  rol_sii_matriz  TEXT,  -- rol del territorio macro, si aplica
  titular_matriz_id UUID REFERENCES its.titulares(id),
  superficie_aprox_ha NUMERIC,
  geom_envolvente GEOMETRY(MULTIPOLYGON, 4326),
  notas           TEXT,
  metadata        JSONB DEFAULT '{}'::jsonb,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_territorios_geom ON its.territorios USING gist(geom_envolvente);
CREATE INDEX idx_territorios_comuna ON its.territorios(comuna);

-- 3.2 · Unidades territoriales (entidad de primer nivel: Hijuela 2 Cominetti)
CREATE TABLE its.unidades_territoriales (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  territorio_id   UUID REFERENCES its.territorios(id),
  codigo          TEXT NOT NULL UNIQUE,  -- p.ej. 'hijuela_2_cominetti', 'dominga_sector_lineal'
  nombre          TEXT NOT NULL,
  roles_sii       TEXT[],                -- p.ej. ['24-123', '24-160']
  comuna_codigo   TEXT,                  -- p.ej. '4102'
  superficie_reportada_ha NUMERIC,       -- cifra "oficial" según fuente principal (con cautela)
  superficie_reportada_fuente TEXT,
  estado          its.estado_evidencia NOT NULL DEFAULT 'identificado',
  notas           TEXT,
  metadata        JSONB DEFAULT '{}'::jsonb,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_unidades_territorio ON its.unidades_territoriales(territorio_id);
CREATE INDEX idx_unidades_codigo ON its.unidades_territoriales(codigo);
CREATE INDEX idx_unidades_estado ON its.unidades_territoriales(estado);
CREATE INDEX idx_unidades_roles ON its.unidades_territoriales USING gin(roles_sii);

-- 3.3 · Titulares actuales por unidad (con participación)
CREATE TABLE its.unidades_titulares (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  unidad_id       UUID NOT NULL REFERENCES its.unidades_territoriales(id) ON DELETE CASCADE,
  titular_id      UUID NOT NULL REFERENCES its.titulares(id),
  participacion_pct NUMERIC CHECK (participacion_pct BETWEEN 0 AND 100),
  rol_sii_especifico TEXT,                -- si la participación es solo sobre un rol
  vigente_desde   DATE,
  vigente_hasta   DATE,
  origen_adquisicion TEXT,                -- p.ej. "Rep FS 694 N°26.309/24-feb-2017"
  fuente_id       UUID REFERENCES its.fuentes(id),
  notas           TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_unidades_titulares_unidad ON its.unidades_titulares(unidad_id);
CREATE INDEX idx_unidades_titulares_titular ON its.unidades_titulares(titular_id);

-- 3.4 · Representaciones geométricas (múltiples por unidad, coexisten)
CREATE TABLE its.representaciones_geometricas (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  unidad_id       UUID NOT NULL REFERENCES its.unidades_territoriales(id) ON DELETE CASCADE,
  codigo          TEXT NOT NULL,         -- p.ej. 'g1_plano_matriz_mbn_1988'
  tipo            its.tipo_representacion NOT NULL,
  fuente_id       UUID REFERENCES its.fuentes(id),
  fuente_descripcion TEXT,               -- texto libre si la fuente no está en catálogo
  fecha_documento DATE,
  fecha_levantamiento DATE,
  autor           TEXT,
  escala          TEXT,
  datum           TEXT,                  -- 'PSAD56', 'WGS84', 'SIRGAS-Chile'
  proyeccion      TEXT,                  -- 'UTM 19S', 'TM-Chile'
  precision_m     NUMERIC,
  superficie_declarada_ha NUMERIC,
  vigencia        TEXT CHECK (vigencia IN ('vigente','superseded','en_construccion','descalificada')) DEFAULT 'vigente',
  estado          its.estado_evidencia NOT NULL DEFAULT 'identificado',
  geom            GEOMETRY(MULTIPOLYGON, 4326),  -- nullable: puede existir sin georef
  desfase_conocido TEXT,
  documentos_evidencia UUID[],           -- referencias a its.documentos_evidencia
  notas           TEXT,
  metadata        JSONB DEFAULT '{}'::jsonb,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (unidad_id, codigo)
);

CREATE INDEX idx_repr_unidad ON its.representaciones_geometricas(unidad_id);
CREATE INDEX idx_repr_tipo ON its.representaciones_geometricas(tipo);
CREATE INDEX idx_repr_estado ON its.representaciones_geometricas(estado);
CREATE INDEX idx_repr_vigencia ON its.representaciones_geometricas(vigencia);
CREATE INDEX idx_repr_geom ON its.representaciones_geometricas USING gist(geom);

-- 3.5 · Superficies (múltiples por unidad, cada una con autoridad y capa)
CREATE TABLE its.superficies (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  unidad_id       UUID NOT NULL REFERENCES its.unidades_territoriales(id) ON DELETE CASCADE,
  codigo          TEXT NOT NULL,         -- p.ej. 's_historica_matriz_jarpa_1990'
  naturaleza      its.naturaleza_superficie NOT NULL,
  valor_ha        NUMERIC,               -- nullable si está en conflicto
  fuente_id       UUID REFERENCES its.fuentes(id),
  fuente_descripcion TEXT,
  capa_temporal   INTEGER,               -- 1=histórica, 2=consolidada, etc.
  representacion_geometrica_id UUID REFERENCES its.representaciones_geometricas(id),
  estado          its.estado_evidencia NOT NULL DEFAULT 'declarada_sin_verificar',
  conflicto_id    UUID,                  -- FK a its.conflictos si está en conflicto
  composicion     JSONB,                 -- p.ej. {"lote_a": 1163, "lote_b": 1479}
  evidencia_documentos UUID[],
  notas           TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (unidad_id, codigo)
);

CREATE INDEX idx_sup_unidad ON its.superficies(unidad_id);
CREATE INDEX idx_sup_estado ON its.superficies(estado);
CREATE INDEX idx_sup_naturaleza ON its.superficies(naturaleza);

-- 3.6 · Autoridades (matriz de atribución por dominio)
CREATE TABLE its.autoridades (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  unidad_id       UUID NOT NULL REFERENCES its.unidades_territoriales(id) ON DELETE CASCADE,
  dominio         TEXT NOT NULL,         -- 'rol_sii', 'avaluo', 'cabida_juridica', 'geometria_juridica', 'geometria_operacional', 'servidumbres', etc.
  autoridad_actual TEXT NOT NULL,        -- p.ej. "SII oficial", "Estudio de títulos consolidado", "RTK Daniel"
  fuente_id       UUID REFERENCES its.fuentes(id),
  estado          its.estado_evidencia NOT NULL DEFAULT 'identificado',
  documentos_evidencia UUID[],
  notas           TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (unidad_id, dominio)
);

CREATE INDEX idx_autoridades_unidad ON its.autoridades(unidad_id);
CREATE INDEX idx_autoridades_dominio ON its.autoridades(dominio);

-- 3.7 · Hipótesis (explicaciones útiles no promovidas)
CREATE TABLE its.hipotesis (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  unidad_id       UUID REFERENCES its.unidades_territoriales(id) ON DELETE CASCADE,
  codigo          TEXT NOT NULL,         -- p.ej. 'HIP_VELASQUEZ_PRE_1996'
  descripcion     TEXT NOT NULL,
  estado          TEXT NOT NULL CHECK (estado IN ('hipotesis_de_trabajo','hipotesis_descartada','hipotesis_promovida_a_hecho')) DEFAULT 'hipotesis_de_trabajo',
  evidencia_apoyo UUID[],                -- referencias a documentos
  evidencia_contra UUID[],
  promovible_si   TEXT,                  -- condición necesaria para elevar a hecho
  fecha_promocion DATE,                  -- si fue promovida, cuándo
  fecha_descarte  DATE,
  autoridad_promotora_id UUID REFERENCES its.fuentes(id),
  notas           TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_hipotesis_unidad ON its.hipotesis(unidad_id);
CREATE INDEX idx_hipotesis_estado ON its.hipotesis(estado);

-- 3.8 · Conflictos (divergencias documentadas con autoridad resolutiva asignada)
CREATE TABLE its.conflictos (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  unidad_id       UUID REFERENCES its.unidades_territoriales(id) ON DELETE CASCADE,
  codigo          TEXT NOT NULL UNIQUE,  -- p.ej. 'SII_SURFACE_FACTOR_100'
  tipo            its.tipo_conflicto NOT NULL,
  descripcion     TEXT NOT NULL,
  estado          its.estado_evidencia NOT NULL DEFAULT 'conflicto_documentado',
  autoridad_resolutiva TEXT NOT NULL,    -- 'sii_directo', 'cbr_la_serena', 'estudio_titulos', etc.
  accion_requerida TEXT,
  impacto         TEXT,
  valores_observados JSONB,              -- p.ej. [{"fuente":"DI", "valor": 26.41}, {"fuente":"DD", "valor": 2640.93}]
  elementos_confirmados TEXT[],
  elementos_pendientes TEXT[],
  documentos_evidencia UUID[],
  superseded_por_evidencia UUID,         -- FK a documento que lo resolvió, si aplica
  fecha_resolucion DATE,
  notas           TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_conflictos_unidad ON its.conflictos(unidad_id);
CREATE INDEX idx_conflictos_estado ON its.conflictos(estado);
CREATE INDEX idx_conflictos_tipo ON its.conflictos(tipo);

-- Resolver FK pendiente desde superficies
ALTER TABLE its.superficies
  ADD CONSTRAINT fk_superficies_conflicto
  FOREIGN KEY (conflicto_id) REFERENCES its.conflictos(id);

-- 3.9 · Cadena registral (eventos append-only con capa temporal)
CREATE TABLE its.cadena_registral (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  unidad_id       UUID NOT NULL REFERENCES its.unidades_territoriales(id) ON DELETE CASCADE,
  capa_temporal   INTEGER NOT NULL,      -- 1..N, capas estratigráficas
  fecha           DATE NOT NULL,
  tipo_evento     its.tipo_evento_registral NOT NULL,
  inscripcion     TEXT,                  -- p.ej. "fs. 97 N°91/1990"
  repertorio      TEXT,                  -- p.ej. "Rep FS 313 N°14.461"
  cbr             TEXT,                  -- "La Serena"
  notaria         TEXT,                  -- "Pedro Reveco Hormazábal Santiago"
  titulares_origen UUID[],
  titulares_destino UUID[],
  monto_clp       NUMERIC,
  monto_uf        NUMERIC,
  superficie_involucrada_ha NUMERIC,
  rol_sii_involucrado TEXT[],
  descripcion     TEXT NOT NULL,
  documentos_evidencia UUID[],
  estado          its.estado_evidencia NOT NULL DEFAULT 'identificado',
  metadata        JSONB DEFAULT '{}'::jsonb,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_cadena_unidad ON its.cadena_registral(unidad_id);
CREATE INDEX idx_cadena_fecha ON its.cadena_registral(fecha);
CREATE INDEX idx_cadena_capa ON its.cadena_registral(capa_temporal);
CREATE INDEX idx_cadena_tipo ON its.cadena_registral(tipo_evento);

-- -----------------------------------------------------------------------------
-- 4 · Vistas operacionales
-- -----------------------------------------------------------------------------

-- 4.1 · Vista canónica: todo lo de una unidad con autoridad explícita
CREATE OR REPLACE VIEW its.unidad_canonica AS
SELECT
  u.id                       AS unidad_id,
  u.codigo                   AS unidad_codigo,
  u.nombre                   AS unidad_nombre,
  t.nombre                   AS territorio,
  u.roles_sii,
  u.comuna_codigo,
  u.estado                   AS estado_unidad,
  -- conteos por nodo ontológico
  (SELECT count(*) FROM its.representaciones_geometricas WHERE unidad_id = u.id) AS n_geometrias,
  (SELECT count(*) FROM its.superficies WHERE unidad_id = u.id)                  AS n_superficies,
  (SELECT count(*) FROM its.autoridades WHERE unidad_id = u.id)                  AS n_autoridades,
  (SELECT count(*) FROM its.hipotesis WHERE unidad_id = u.id)                    AS n_hipotesis,
  (SELECT count(*) FROM its.conflictos WHERE unidad_id = u.id AND estado = 'conflicto_documentado') AS n_conflictos_abiertos,
  (SELECT count(*) FROM its.cadena_registral WHERE unidad_id = u.id)             AS n_eventos_registrales,
  (SELECT count(*) FROM its.unidades_titulares WHERE unidad_id = u.id)           AS n_titulares
FROM its.unidades_territoriales u
LEFT JOIN its.territorios t ON t.id = u.territorio_id;

-- 4.2 · Vista superficies por unidad con autoridad y estado (para queries frontend)
CREATE OR REPLACE VIEW its.superficies_por_unidad AS
SELECT
  u.codigo        AS unidad_codigo,
  s.codigo        AS superficie_codigo,
  s.naturaleza,
  s.valor_ha,
  s.capa_temporal,
  s.estado,
  f.nombre        AS fuente,
  f.naturaleza    AS fuente_naturaleza,
  c.codigo        AS conflicto_codigo
FROM its.superficies s
JOIN its.unidades_territoriales u ON u.id = s.unidad_id
LEFT JOIN its.fuentes f ON f.id = s.fuente_id
LEFT JOIN its.conflictos c ON c.id = s.conflicto_id
ORDER BY u.codigo, s.capa_temporal;

-- 4.3 · Vista conflictos abiertos (dashboard operacional)
CREATE OR REPLACE VIEW its.conflictos_abiertos AS
SELECT
  c.codigo,
  c.tipo,
  u.codigo        AS unidad,
  c.descripcion,
  c.autoridad_resolutiva,
  c.accion_requerida,
  c.impacto,
  c.created_at,
  EXTRACT(DAY FROM (now() - c.created_at)) AS dias_abierto
FROM its.conflictos c
LEFT JOIN its.unidades_territoriales u ON u.id = c.unidad_id
WHERE c.estado = 'conflicto_documentado'
ORDER BY c.created_at;

-- -----------------------------------------------------------------------------
-- 5 · Funciones disciplinares (impiden promoción de estado sin evidencia)
-- -----------------------------------------------------------------------------

-- 5.1 · Promoción de superficie a 'verificado' requiere evidencia primaria
CREATE OR REPLACE FUNCTION its.promote_superficie_to_verified(
  p_superficie_id UUID,
  p_documento_evidencia_id UUID
) RETURNS BOOLEAN AS $$
DECLARE
  v_documento_existe BOOLEAN;
  v_fuente_naturaleza its.naturaleza_fuente;
BEGIN
  SELECT EXISTS(SELECT 1 FROM its.documentos_evidencia WHERE id = p_documento_evidencia_id)
    INTO v_documento_existe;

  IF NOT v_documento_existe THEN
    RAISE EXCEPTION 'Documento evidencia % no existe', p_documento_evidencia_id;
  END IF;

  -- Verificar que la fuente del documento sea autoridad primaria
  SELECT f.naturaleza INTO v_fuente_naturaleza
  FROM its.documentos_evidencia d
  JOIN its.fuentes f ON f.id = d.fuente_id
  WHERE d.id = p_documento_evidencia_id;

  IF v_fuente_naturaleza NOT IN ('cbr', 'sii', 'bbnn_seremi', 'mop_dgop', 'notaria', 'plano_matriz_mbn') THEN
    RAISE EXCEPTION 'Fuente % no es autoridad primaria. Promoción rechazada por disciplina epistemológica.', v_fuente_naturaleza;
  END IF;

  UPDATE its.superficies
  SET estado = 'verificado',
      evidencia_documentos = array_append(COALESCE(evidencia_documentos, '{}'), p_documento_evidencia_id),
      updated_at = now()
  WHERE id = p_superficie_id;

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION its.promote_superficie_to_verified IS 'Disciplina: una superficie solo sube a verificado con evidencia de autoridad primaria (CBR/SII/BBNN/MOP/Notaría/Plano matriz)';

-- 5.2 · Cerrar conflicto requiere evidencia + autoridad resolutiva
CREATE OR REPLACE FUNCTION its.resolve_conflicto(
  p_conflicto_id UUID,
  p_documento_evidencia_id UUID,
  p_nuevo_estado its.estado_evidencia DEFAULT 'verificado'
) RETURNS BOOLEAN AS $$
BEGIN
  IF p_nuevo_estado NOT IN ('verificado','superseded','descalificado') THEN
    RAISE EXCEPTION 'Estado de resolución inválido: %', p_nuevo_estado;
  END IF;

  UPDATE its.conflictos
  SET estado = p_nuevo_estado,
      superseded_por_evidencia = p_documento_evidencia_id,
      fecha_resolucion = CURRENT_DATE,
      documentos_evidencia = array_append(COALESCE(documentos_evidencia, '{}'), p_documento_evidencia_id),
      updated_at = now()
  WHERE id = p_conflicto_id;

  RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- -----------------------------------------------------------------------------
-- 6 · RLS (Row Level Security) — preparada para uso interno + futuro multi-tenant
-- -----------------------------------------------------------------------------

ALTER TABLE its.territorios ENABLE ROW LEVEL SECURITY;
ALTER TABLE its.unidades_territoriales ENABLE ROW LEVEL SECURITY;
ALTER TABLE its.representaciones_geometricas ENABLE ROW LEVEL SECURITY;
ALTER TABLE its.superficies ENABLE ROW LEVEL SECURITY;
ALTER TABLE its.autoridades ENABLE ROW LEVEL SECURITY;
ALTER TABLE its.hipotesis ENABLE ROW LEVEL SECURITY;
ALTER TABLE its.conflictos ENABLE ROW LEVEL SECURITY;
ALTER TABLE its.cadena_registral ENABLE ROW LEVEL SECURITY;
ALTER TABLE its.titulares ENABLE ROW LEVEL SECURITY;
ALTER TABLE its.documentos_evidencia ENABLE ROW LEVEL SECURITY;

-- Política inicial: uso interno Magnus → service_role full access, auth users solo read
CREATE POLICY "service role full access" ON its.unidades_territoriales
  FOR ALL USING (auth.role() = 'service_role') WITH CHECK (auth.role() = 'service_role');

CREATE POLICY "authenticated read" ON its.unidades_territoriales
  FOR SELECT USING (auth.role() = 'authenticated');

-- (Repetir patrón para todas las tablas — comprimido aquí para brevedad del archivo doctrinal)

-- -----------------------------------------------------------------------------
-- 7 · Comentarios doctrinales en tablas (autodocumentación)
-- -----------------------------------------------------------------------------

COMMENT ON TABLE its.territorios IS 'Nivel macro: estancias, fundos, sectores. Contiene unidades territoriales.';
COMMENT ON TABLE its.unidades_territoriales IS 'Entidad canónica de primer nivel. Una unidad puede tener múltiples geometrías, múltiples superficies, múltiples titulares.';
COMMENT ON TABLE its.representaciones_geometricas IS 'Múltiples representaciones coexisten. Ninguna sobrescribe a otra. CANON_HIJUELA2 §4.';
COMMENT ON TABLE its.superficies IS 'Múltiples superficies por unidad. Cada una declara capa temporal + autoridad. No existe superficie única. CANON_HIJUELA2 §5.';
COMMENT ON TABLE its.autoridades IS 'Matriz de atribución: qué dominio resuelve qué pregunta. CANON_HIJUELA2 §8.5.';
COMMENT ON TABLE its.hipotesis IS 'Hipótesis declaradas explícitamente. NUNCA se contrabandean como hechos. CANON_HIJUELA2 doctrina §1 regla 11.';
COMMENT ON TABLE its.conflictos IS 'Conflictos documentados con autoridad resolutiva asignada. CANON_HIJUELA2 §7.';
COMMENT ON TABLE its.cadena_registral IS 'Eventos append-only con capa temporal. Cadena dominical y registral.';

-- =============================================================================
-- FIN MIGRATION 0002 · Schema ITS v2
-- =============================================================================
