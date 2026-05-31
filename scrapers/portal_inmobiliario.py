#!/usr/bin/env python3
"""
Scraper Portal Inmobiliario / Yapo / Toctoc — La Higuera + Andacollo.
Diario via GitHub Actions cron.

NOTA: Portal Inmobiliario tiene anti-bot agresivo. Para producción usar:
  - Mercado Libre Items API oficial (requiere registro dev)
  - Playwright/Puppeteer headless
  - O servicio third-party como ScrapingBee / Bright Data

Por ahora: stub que valida conexión Supabase y registra ejecución.
"""
import os, sys, datetime, httpx
from supabase import create_client

SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")
if not SUPABASE_URL or not SUPABASE_KEY: sys.exit("setear SUPABASE_*")
sb = create_client(SUPABASE_URL, SUPABASE_KEY)

COMUNAS = [(4102, "La Higuera"), (4302, "Andacollo")]

def main():
    print(f"[{datetime.datetime.utcnow().isoformat()}] Portal Inmobiliario scraper")
    # TODO: implementar con Playwright o Mercado Libre API
    sb.table("eventos").insert({
        "comuna_codigo": 4102,
        "fecha": datetime.date.today().isoformat(),
        "tipo": "prensa",
        "titulo": "Scraper portales inmobiliarios ejecutado (stub)",
        "fuente": "scraper_portales",
        "criticidad": "info"
    }).execute()
    print("✓ Stub ejecutado · implementar parsing real con Playwright/ML API")

if __name__ == "__main__":
    main()
