#!/usr/bin/env python3
"""SMA scraper — Procedimientos sancionatorios SNIFA La Higuera. (Stub)"""
import os, datetime
from supabase import create_client
from dotenv import load_dotenv
load_dotenv()
sb = create_client(os.environ["SUPABASE_URL"], os.environ["SUPABASE_SERVICE_ROLE_KEY"])

def main():
    print(f"[{datetime.datetime.utcnow().isoformat()}] SMA scraper stub")
    # TODO: scrape snifa.sma.gob.cl filtrado por La Higuera

if __name__ == "__main__":
    main()
