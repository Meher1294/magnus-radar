#!/usr/bin/env python3
"""
Carga los 7.686 predios SII de La Higuera desde GeoJSON a Supabase.

Uso:
    pip install psycopg2-binary python-dotenv
    cp ../../.env.example ../../.env  # y completa SUPABASE_DB_URL
    python load_predios.py ../../../la-higuera-predios.geojson
"""
import json, sys, os
from pathlib import Path
import psycopg2
from psycopg2.extras import execute_batch
from dotenv import load_dotenv

load_dotenv(Path(__file__).parent.parent.parent / ".env")

DB_URL = os.environ.get("SUPABASE_DB_URL")
if not DB_URL:
    sys.exit("ERROR: setear SUPABASE_DB_URL en .env")

def main(geojson_path):
    print(f"Leyendo {geojson_path}...")
    with open(geojson_path, "r", encoding="utf-8") as f:
        gj = json.load(f)

    feats = gj["features"]
    print(f"Predios a cargar: {len(feats)}")

    rows = []
    for f in feats:
        p = f["properties"]
        geom = json.dumps(f["geometry"])
        rows.append((
            4102,                                # comuna_codigo La Higuera
            p["rol"],
            p.get("manz") or None,
            p.get("predio") or None,
            p.get("sector") or None,
            p.get("estado") or None,
            p.get("area_ha"),
            geom,
            "sii_kmz_2026-04-21",
        ))

    conn = psycopg2.connect(DB_URL)
    conn.autocommit = False
    cur = conn.cursor()

    print("Truncando tabla predios (comuna 4102)...")
    cur.execute("delete from predios where comuna_codigo = 4102;")

    print("Insertando...")
    sql = """
        insert into predios
          (comuna_codigo, rol, manzana, predio, sector, estado_sii, area_ha, geom, fuente)
        values
          (%s, %s, %s, %s, %s, %s, %s, ST_GeomFromGeoJSON(%s), %s)
        on conflict (rol, comuna_codigo) do update set
          area_ha = excluded.area_ha,
          sector = excluded.sector,
          geom = excluded.geom,
          updated_at = now();
    """
    execute_batch(cur, sql, rows, page_size=500)

    conn.commit()
    cur.execute("select count(*) from predios where comuna_codigo = 4102;")
    n = cur.fetchone()[0]
    print(f"OK. Predios en DB: {n}")
    cur.close()
    conn.close()

if __name__ == "__main__":
    path = sys.argv[1] if len(sys.argv) > 1 else "la-higuera-predios.geojson"
    main(path)
