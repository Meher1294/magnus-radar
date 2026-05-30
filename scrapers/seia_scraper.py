#!/usr/bin/env python3
"""
SEIA scraper — Comuna La Higuera.

Stub inicial. Falta implementar el scrape real del SIG SEA con coordenadas oficiales.
Por ahora valida conexión a Supabase y registra evento de ejecución.
"""
import os, datetime
from supabase import create_client
from dotenv import load_dotenv

load_dotenv()
sb = create_client(os.environ["SUPABASE_URL"], os.environ["SUPABASE_SERVICE_ROLE_KEY"])

def main():
    now = datetime.datetime.utcnow().isoformat()
    print(f"[{now}] SEIA scraper start — comuna 4102 La Higuera")
    # TODO: scrapear sig.sea.gob.cl con polígono comuna La Higuera
    # TODO: comparar contra DB, insertar nuevos proyectos y eventos
    sb.table("eventos").insert({
        "comuna_codigo": 4102,
        "fecha": datetime.date.today().isoformat(),
        "tipo": "seia_ingreso",
        "titulo": "Scraper SEIA ejecutado (stub)",
        "fuente": "scraper_seia",
        "criticidad": "info"
    }).execute()
    print(f"[{now}] SEIA scraper done")

if __name__ == "__main__":
    main()
