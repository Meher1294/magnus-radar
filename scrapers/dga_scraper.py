#!/usr/bin/env python3
"""DGA scraper — Derechos de aprovechamiento de agua La Higuera. (Stub)"""
import os, datetime
from supabase import create_client
from dotenv import load_dotenv
load_dotenv()
sb = create_client(os.environ["SUPABASE_URL"], os.environ["SUPABASE_SERVICE_ROLE_KEY"])

def main():
    print(f"[{datetime.datetime.utcnow().isoformat()}] DGA scraper stub")
    # TODO: scrape snia.mop.gob.cl / CPA — derechos en comuna La Higuera

if __name__ == "__main__":
    main()
