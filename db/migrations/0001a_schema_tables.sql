-- ============================================================
-- MAGNUS RADAR — Schema Parte A (Extensiones + Tablas + Índices)
-- Ejecutar PRIMERO. Después ejecutar 0001b_schema_rls_views.sql
-- ============================================================

-- ============ EXTENSIONES ============
create extension if not exists postgis;
create extension if not exists pg_trgm;        -- búsqueda fuzzy de roles
create extension if not exists "uuid-ossp";

-- ============ ENUMS ============
do $$ begin
  create type plan_tier as enum ('free', 'pro', 'intelligence');
exception when duplicate_object then null; end $$;

do $$ begin
  create type evento_tipo as enum (
    'seia_ingreso','seia_rca','seia_recurso',
    'sma_procedimiento','sma_sancion',
    'dga_solicitud','dga_resolucion',
    'cbr_inscripcion','cbr_gravamen',
    'sii_actualizacion',
    'prensa','lobby'
  );
exception when duplicate_object then null; end $$;

do $$ begin
  create type criticidad as enum ('info','baja','media','alta','critica');
exception when duplicate_object then null; end $$;

-- ============ COMUNAS (multi-tenant base) ============
create table if not exists comunas (
  codigo integer primary key,                  -- 4102 La Higuera
  nombre text not null,
  region text not null,
  geom geometry(MultiPolygon, 4326),
  superficie_km2 numeric,
  publicado boolean default false,
  created_at timestamptz default now()
);

insert into comunas (codigo, nombre, region, publicado)
values (4102, 'La Higuera', 'Coquimbo', true)
on conflict (codigo) do nothing;

-- ============ PREDIOS (catastro SII) ============
create table if not exists predios (
  id bigserial primary key,
  comuna_codigo integer references comunas(codigo),
  rol text not null,                           -- 24-123 o 170-207
  manzana text,
  predio text,
  sector text,
  estado_sii text,                              -- V (vigente)
  area_ha numeric,
  geom geometry(Polygon, 4326) not null,
  centroide geometry(Point, 4326)
    generated always as (ST_Centroid(geom)) stored,
  propietario_rut text,                        -- nullable (privacidad)
  propietario_nombre text,                     -- nullable
  destino_sii text,                            -- Agrícola, Eriazo, etc.
  avaluo_fiscal_uf numeric,
  fuente text default 'sii',
  fuente_url text,
  fuente_fecha date,
  flags text[],                                -- ['mandato','andes-iron','vigilancia']
  metadata jsonb,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create unique index if not exists predios_rol_comuna_uq
  on predios(rol, comuna_codigo);
create index if not exists predios_geom_gix on predios using gist(geom);
create index if not exists predios_centroide_gix on predios using gist(centroide);
create index if not exists predios_sector_idx on predios(sector);
create index if not exists predios_area_idx on predios(area_ha desc);
create index if not exists predios_rol_trgm on predios using gin(rol gin_trgm_ops);

-- ============ PROYECTOS SEIA ============
create table if not exists proyectos_seia (
  id bigserial primary key,
  comuna_codigo integer references comunas(codigo),
  seia_id text unique,                         -- ID del expediente seia.sea.gob.cl
  nombre text not null,
  titular text,
  tipo text,                                   -- Minería, Energía, etc.
  tipologia text,                              -- DIA / EIA
  estado text,                                 -- Aprobado, Rechazado, En calificación
  fecha_ingreso date,
  fecha_rca date,
  inversion_usd_m numeric,                     -- en millones USD
  geom geometry(Point, 4326) not null,
  region text,
  flag text,                                   -- critical, historic
  url_expediente text,
  metadata jsonb,                              -- guarda payload SEIA completo
  ultima_actualizacion timestamptz default now()
);

create index if not exists seia_geom_gix on proyectos_seia using gist(geom);
create index if not exists seia_comuna_idx on proyectos_seia(comuna_codigo);
create index if not exists seia_estado_idx on proyectos_seia(estado);
create index if not exists seia_tipo_idx on proyectos_seia(tipo);

-- ============ USUARIOS (vincula a Supabase auth.users) ============
create table if not exists usuarios (
  id uuid primary key references auth.users(id) on delete cascade,
  email text unique not null,
  nombre text,
  empresa text,
  rut text,
  rol_grupo text,                              -- inmobiliaria, energetico, mineria, etc.
  plan plan_tier default 'free',
  plan_inicio date,
  plan_vence date,
  stripe_customer_id text,
  airtable_record_id text,
  preferencias jsonb default '{}'::jsonb,
  created_at timestamptz default now()
);

create index if not exists usuarios_plan_idx on usuarios(plan);

-- ============ POLÍGONOS DE VIGILANCIA DEL USUARIO ============
create table if not exists alertas_poligonos (
  id bigserial primary key,
  usuario_id uuid references usuarios(id) on delete cascade,
  nombre text not null,
  geom geometry(Polygon, 4326) not null,
  radio_km numeric,                            -- si es un radio, no polígono
  centro geometry(Point, 4326),
  filtros jsonb default '{}'::jsonb,           -- {tipos:['seia'], criticidad:['alta']}
  activa boolean default true,
  notif_email boolean default true,
  notif_realtime boolean default true,
  created_at timestamptz default now()
);

create index if not exists alertas_geom_gix on alertas_poligonos using gist(geom);
create index if not exists alertas_usuario_idx on alertas_poligonos(usuario_id);

-- ============ EVENTOS (timeline de la comuna) ============
create table if not exists eventos (
  id bigserial primary key,
  comuna_codigo integer references comunas(codigo),
  predio_id bigint references predios(id) on delete set null,
  proyecto_seia_id bigint references proyectos_seia(id) on delete set null,
  fecha date not null,
  tipo evento_tipo not null,
  titulo text not null,
  descripcion text,
  criticidad criticidad default 'info',
  geom geometry(Point, 4326),
  fuente text not null,                        -- seia, dga, sma, prensa, etc.
  fuente_url text,
  metadata jsonb,
  created_at timestamptz default now()
);

create index if not exists eventos_geom_gix on eventos using gist(geom);
create index if not exists eventos_fecha_idx on eventos(fecha desc);
create index if not exists eventos_tipo_idx on eventos(tipo);
create index if not exists eventos_comuna_fecha on eventos(comuna_codigo, fecha desc);

-- ============ NOTIFICACIONES ENVIADAS ============
create table if not exists notificaciones (
  id bigserial primary key,
  usuario_id uuid references usuarios(id) on delete cascade,
  evento_id bigint references eventos(id) on delete cascade,
  alerta_id bigint references alertas_poligonos(id) on delete set null,
  canal text not null,                         -- email, push, webhook
  estado text default 'pendiente',             -- pendiente, enviada, error
  enviada_at timestamptz,
  error text,
  created_at timestamptz default now()
);

create index if not exists notif_usuario_idx on notificaciones(usuario_id);
create index if not exists notif_estado_idx on notificaciones(estado);

