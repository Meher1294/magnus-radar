#!/usr/bin/env python3
"""
Scraper SEIA — Comuna La Higuera (código 4101 en SEIA).
Corre como GitHub Action cron diario. Inserta nuevos proyectos a Supabase
y registra eventos en la tabla `eventos`.

Variables de entorno requeridas:
  SUPABASE_URL
  SUPABASE_SERVICE_ROLE_KEY
"""
import os, re, sys, json, time, datetime
import httpx
from bs4 import BeautifulSoup
from supabase import create_client

SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")
if not SUPABASE_URL or not SUPABASE_KEY:
    sys.exit("ERROR: setear SUPABASE_URL y SUPABASE_SERVICE_ROLE_KEY")

sb = create_client(SUPABASE_URL, SUPABASE_KEY)
COMUNA = 4102  # Código SII La Higuera (en nuestra DB)
SEIA_COMUNA = 4101  # Código SEIA La Higuera (verificar al primer run)
USER_AGENT = "MagnusRadar/0.1 (contacto: max@xpu.cl)"

def fetch_seia_page(offset=0, page_size=50):
    """SEIA público sin auth. HTML parseable con BS4."""
    url = "https://seia.sea.gob.cl/busqueda/buscarProyecto.php"
    params = {
        "_paginador_row_count_": page_size,
        "_paginador_offset_": offset,
        "regiones": 4,        # IV Coquimbo
        "comunas": SEIA_COMUNA,
    }
    r = httpx.get(url, params=params, headers={"User-Agent": USER_AGENT}, timeout=30, follow_redirects=True)
    r.raise_for_status()
    return r.text

def parse_proyectos(html):
    """Extrae proyectos del HTML del SEIA."""
    soup = BeautifulSoup(html, "lxml")
    proyectos = []

    # SEIA usa tabla con id "tabla_resultados" o similar; parse robusto
    for row in soup.select("table tr"):
        cells = [c.get_text(strip=True) for c in row.find_all(["td", "th"])]
        if len(cells) < 5:
            continue
        # Saltar header
        if "Nombre" in cells[0] or not cells[0]:
            continue

        # Buscar link al expediente
        a = row.find("a", href=True)
        seia_id = None
        url_expediente = None
        if a:
            url_expediente = a["href"]
            m = re.search(r"id_expediente=(\d+)", url_expediente)
            if m:
                seia_id = m.group(1)
            if not url_expediente.startswith("http"):
                url_expediente = "https://seia.sea.gob.cl" + url_expediente

        proyectos.append({
            "seia_id": seia_id,
            "nombre": cells[0] if len(cells) > 0 else None,
            "tipologia": cells[1] if len(cells) > 1 else None,
            "region": cells[2] if len(cells) > 2 else None,
            "tipo": cells[3] if len(cells) > 3 else None,
            "titular": cells[4] if len(cells) > 4 else None,
            "fecha_ingreso_raw": cells[5] if len(cells) > 5 else None,
            "estado": cells[6] if len(cells) > 6 else None,
            "url_expediente": url_expediente,
        })

    return proyectos

def parse_fecha(s):
    """Convierte 'dd/mm/yyyy' o similar a ISO date."""
    if not s: return None
    for fmt in ("%d/%m/%Y", "%Y-%m-%d", "%d-%m-%Y"):
        try:
            return datetime.datetime.strptime(s.strip(), fmt).date().isoformat()
        except: pass
    return None

def upsert_proyecto(p):
    """Inserta o actualiza proyecto. Devuelve True si era nuevo."""
    if not p.get("seia_id") or not p.get("nombre"):
        return False

    # Geometría: si no tenemos coords, usar centroide aproximado de La Higuera
    geom_wkt = "POINT(-71.10 -29.40)"  # default: centro La Higuera

    existing = sb.table("proyectos_seia").select("id, ultima_actualizacion").eq("seia_id", p["seia_id"]).execute()
    is_new = not existing.data

    payload = {
        "comuna_codigo": COMUNA,
        "seia_id": p["seia_id"],
        "nombre": p["nombre"][:200],
        "titular": p.get("titular"),
        "tipo": p.get("tipo"),
        "tipologia": p.get("tipologia"),
        "estado": p.get("estado"),
        "fecha_ingreso": parse_fecha(p.get("fecha_ingreso_raw")),
        "url_expediente": p.get("url_expediente"),
        "region": "Coquimbo",
        "ultima_actualizacion": datetime.datetime.utcnow().isoformat(),
    }

    if is_new:
        # Insert con geometry placeholder
        sb.rpc("exec_sql", {"sql": ""}).execute() if False else None  # skip
        # Direct insert sin geom; el frontend usa lat/lon de la vista
        try:
            sb.table("proyectos_seia").insert({**payload, "geom": geom_wkt}).execute()
        except Exception:
            # Fallback con raw SQL si la geom da problemas
            sb.postgrest.rpc("exec_sql", {"sql": f"INSERT INTO proyectos_seia (comuna_codigo, seia_id, nombre, titular, tipo, tipologia, estado, fecha_ingreso, url_expediente, region, ultima_actualizacion, geom) VALUES ({COMUNA}, '{p['seia_id']}', '{p['nombre'][:200]}', NULL, NULL, NULL, NULL, NULL, NULL, 'Coquimbo', now(), ST_SetSRID(ST_GeomFromText('{geom_wkt}'), 4326))"})
        # Registrar evento
        sb.table("eventos").insert({
            "comuna_codigo": COMUNA,
            "fecha": datetime.date.today().isoformat(),
            "tipo": "seia_ingreso",
            "titulo": f"Nuevo en SEIA: {p['nombre'][:120]}",
            "descripcion": f"Titular: {p.get('titular') or 'N/D'}. Tipología: {p.get('tipologia') or 'N/D'}.",
            "fuente": "scraper_seia",
            "fuente_url": p.get("url_expediente"),
            "criticidad": "media",
        }).execute()
    else:
        sb.table("proyectos_seia").update(payload).eq("seia_id", p["seia_id"]).execute()
    return is_new

def main():
    print(f"[{datetime.datetime.utcnow().isoformat()}] SEIA scraper start")
    all_proyectos = []
    offset = 0
    while True:
        try:
            html = fetch_seia_page(offset=offset, page_size=50)
        except Exception as e:
            print(f"  ERROR fetch offset={offset}: {e}")
            break
        proyectos = parse_proyectos(html)
        if not proyectos:
            print(f"  No más proyectos en offset={offset}")
            break
        all_proyectos.extend(proyectos)
        print(f"  offset={offset} → {len(proyectos)} proyectos en esta página")
        if len(proyectos) < 50: break
        offset += 50
        time.sleep(1)  # cortés con el servidor

    print(f"\nTotal scrapeados: {len(all_proyectos)}")
    nuevos = 0
    for p in all_proyectos:
        try:
            if upsert_proyecto(p):
                nuevos += 1
                print(f"  NUEVO: {p.get('seia_id')} · {p.get('nombre')[:60]}")
        except Exception as e:
            print(f"  ERROR upsert {p.get('seia_id')}: {e}")

    # Evento resumen
    sb.table("eventos").insert({
        "comuna_codigo": COMUNA,
        "fecha": datetime.date.today().isoformat(),
        "tipo": "seia_ingreso",
        "titulo": f"Scraper SEIA: {len(all_proyectos)} proyectos verificados, {nuevos} nuevos",
        "fuente": "scraper_seia",
        "criticidad": "info",
    }).execute()
    print(f"\n✓ Done. Nuevos: {nuevos} / Total: {len(all_proyectos)}")

if __name__ == "__main__":
    main()
