-- ============================================================
-- MAGNUS RADAR — Schema Parte B (RLS + Funciones + Vistas)
-- Ejecutar DESPUÉS de 0001a_schema_tables.sql
-- ============================================================

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
create or replace view stats_comuna as
select
  c.codigo, c.nombre,
  count(distinct p.id) as predios_total,
  sum(p.area_ha) as superficie_total_ha,
  count(distinct ps.id) as proyectos_seia,
  sum(ps.inversion_usd_m) as inversion_seia_usd_m,
  count(distinct e.id) filter (where e.fecha >= current_date - 30) as eventos_mes
from comunas c
left join predios p on p.comuna_codigo = c.codigo
left join proyectos_seia ps on ps.comuna_codigo = c.codigo
left join eventos e on e.comuna_codigo = c.codigo
group by c.codigo, c.nombre;

-- ============ FIN SCHEMA INICIAL ============
