#!/usr/bin/env python3
"""
SMA scraper — Procedimientos sancionatorios SNIFA en La Higuera.
Cron diario via GitHub Actions.
"""
import os, sys, datetime, httpx
from bs4 import BeautifulSoup
from supabase import create_client

SUPABASE_URL = os.environ["SUPABASE_URL"]
SUPABASE_KEY = os.environ["SUPABASE_SERVICE_ROLE_KEY"]
sb = create_client(SUPABASE_URL, SUPABASE_KEY)
COMUNA = 4102
USER_AGENT = "MagnusRadar/0.1 (contacto@magnusradar.cl)"

# SNIFA permite búsqueda por palabra clave
SNIFA_SEARCH = "https://snifa.sma.gob.cl/Sancionatorio/Resultado"

def fetch_snifa():
    """Busca procedimientos relacionados con La Higuera en SNIFA."""
    try:
        r = httpx.get(SNIFA_SEARCH, params={"busqueda": "La Higuera"},
                      headers={"User-Agent": USER_AGENT}, timeout=30, follow_redirects=True)
        r.raise_for_status()
        return r.text
    except Exception as e:
        print(f"  ERROR fetch SNIFA: {e}")
        return None

def parse_procedimientos(html):
    """Extrae procedimientos sancionatorios."""
    if not html: return []
    soup = BeautifulSoup(html, "lxml")
    procs = []
    for row in soup.select("table tr"):
        cells = [c.get_text(strip=True) for c in row.find_all("td")]
        if len(cells) < 4: continue
        a = row.find("a", href=True)
        url = a["href"] if a else None
        if url and not url.startswith("http"):
            url = "https://snifa.sma.gob.cl" + url
        procs.append({
            "rol": cells[0] if len(cells) > 0 else "",
            "titular": cells[1] if len(cells) > 1 else "",
            "fecha": cells[2] if len(cells) > 2 else "",
            "estado": cells[3] if len(cells) > 3 else "",
            "url": url
        })
    return procs

def main():
    print(f"[{datetime.datetime.utcnow().isoformat()}] SMA scraper start")
    html = fetch_snifa()
    procs = parse_procedimientos(html)
    print(f"  Procedimientos encontrados: {len(procs)}")

    nuevos = 0
    for p in procs:
        if not p.get("rol"): continue
        titulo = f"SMA: {p['titular'][:80]} · {p['estado']}"
        try:
            # Check si ya existe (por rol + fuente)
            existing = sb.table("eventos").select("id").eq("fuente", "scraper_sma").eq("titulo", titulo).execute()
            if existing.data: continue
            sb.table("eventos").insert({
                "comuna_codigo": COMUNA,
                "fecha": datetime.date.today().isoformat(),
                "tipo": "sma_procedimiento",
                "titulo": titulo,
                "descripcion": f"Rol SMA: {p['rol']} · Titular: {p['titular']}",
                "fuente": "scraper_sma",
                "fuente_url": p.get("url"),
                "criticidad": "media" if "sanci" in p['estado'].lower() else "info",
            }).execute()
            nuevos += 1
        except Exception as e:
            print(f"  Error insert: {e}")

    # Resumen
    sb.table("eventos").insert({
        "comuna_codigo": COMUNA,
        "fecha": datetime.date.today().isoformat(),
        "tipo": "sma_procedimiento",
        "titulo": f"Scraper SMA: {len(procs)} procedimientos verificados, {nuevos} nuevos",
        "fuente": "scraper_sma",
        "criticidad": "info",
    }).execute()
    print(f"✓ Done. Nuevos: {nuevos}")

if __name__ == "__main__": main()
