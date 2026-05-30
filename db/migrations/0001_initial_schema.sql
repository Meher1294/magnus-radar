-- ============================================================
-- MAGNUS RADAR — SCHEMA INICIAL (Supabase + PostGIS)
-- Versión: 0.1
-- Ejecutar en: Supabase Studio → SQL Editor → New query
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
  geom geometry(MultiPolygon, 4326) not null,   -- MultiPolygon (algunos predios SII tienen múltiples polígonos)
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

-- index NO único: un mismo rol SII puede tener múltiples polígonos físicos
create index if not exists predios_rol_idx on predios(rol, comuna_codigo);
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

-- ============ RLS (Row-Level Security) ============
-- Predios y SEIA: lectura pública (datos públicos)
alter table predios enable row level security;
alter table proyectos_seia enable row level security;
alter table comunas enable row level security;
alter table eventos enable row level security;

create policy predios_lectura_publica on predios for select using (true);
create policy seia_lectura_publica on proyectos_seia for select using (true);
create policy comunas_lectura_publicas on comunas for select using (publicado = true);
create policy eventos_lectura_publica on eventos for select using (true);

-- Usuarios: solo el propio usuario lee sus datos
alter table usuarios enable row level security;
create policy usuarios_propio_acceso on usuarios
  for all using (auth.uid() = id);

-- Alertas: solo del propio usuario
alter table alertas_poligonos enable row level security;
create policy alertas_propio_acceso on alertas_poligonos
  for all using (auth.uid() = usuario_id);

-- Notificaciones: solo del propio usuario
alter table notificaciones enable row level security;
create policy notif_propio_acceso on notificaciones
  for all using (auth.uid() = usuario_id);

-- ============ FUNCIONES ÚTILES ============

-- Predios dentro de un polígono (búsqueda espacial)
create or replace function predios_en_poligono(poly geometry)
returns setof predios as $$
  select * from predios where ST_Intersects(geom, poly);
$$ language sql stable;

-- Eventos cerca de un punto, últimos N días
create or replace function eventos_cercanos(
  lon float, lat float, radio_metros float, dias int default 90
) returns setof eventos as $$
  select * from eventos
  where ST_DWithin(
    geom::geography,
    ST_SetSRID(ST_MakePoint(lon, lat), 4326)::geography,
    radio_metros
  )
  and fecha >= current_date - dias
  order by fecha desc;
$$ language sql stable;

-- Trigger updated_at
create or replace function set_updated_at() returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger predios_updated_at before update on predios
  for each row execute function set_updated_at();

-- ============ VISTAS PARA EL FRONTEND ============

create or replace view predios_publicos as
select
  id, rol, sector, area_ha,
  estado_sii, comuna_codigo,
  ST_AsGeoJSON(geom)::json as geometry,
  ST_X(centroide) as lon, ST_Y(centroide) as lat,
  flags
from predios
where comuna_codigo in (select codigo from comunas where publicado = true);

create or replace view proyectos_seia_publicos as
select
  id, seia_id, nombre, titular, tipo, tipologia,
  estado, fecha_ingreso, inversion_usd_m,
  ST_X(geom) as lon, ST_Y(geom) as lat,
  flag, url_expediente
from proyectos_seia
where comuna_codigo in (select codigo from comunas where publicado = true);

-- ============ STATS POR COMUNA ============
-- IMPORTANTE: usar subqueries (no JOINs) para evitar cartesianos que inflan los totales
create or replace view stats_comuna as
select c.codigo, c.nombre,
  (select count(*) from predios p where p.comuna_codigo = c.codigo) as predios_total,
  (select sum(area_ha) from predios p where p.comuna_codigo = c.codigo) as superficie_total_ha,
  (select count(*) from proyectos_seia ps where ps.comuna_codigo = c.codigo) as proyectos_seia,
  (select sum(inversion_usd_m) from proyectos_seia ps where ps.comuna_codigo = c.codigo) as inversion_seia_usd_m,
  (select count(*) from eventos e where e.comuna_codigo = c.codigo and e.fecha >= current_date - 30) as eventos_mes
from comunas c;

-- ============ FIN SCHEMA INICIAL ============
