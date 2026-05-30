#!/usr/bin/env python3
"""Carga los 17 proyectos SEIA reales de La Higuera a Supabase."""
import os, sys, json
from pathlib import Path
import psycopg2
from psycopg2.extras import execute_batch
from dotenv import load_dotenv

load_dotenv(Path(__file__).parent.parent.parent / ".env")
DB_URL = os.environ.get("SUPABASE_DB_URL")
if not DB_URL: sys.exit("setear SUPABASE_DB_URL")

PROYECTOS = [
  {"seia_id":"2128565332","nombre":"Dominga","titular":"Andes Iron SpA","tipo":"Minería + Puerto","tipologia":"EIA","fecha":"2013-09-13","estado":"RCA 161/2021 (litigada)","inversion":2500,"lon":-71.295,"lat":-29.345,"flag":"critical","url":"https://seia.sea.gob.cl/expediente/ficha/fichaPrincipal.php?modo=ficha&id_expediente=2128565332"},
  {"seia_id":None,"nombre":"Puerto Cruz Grande","titular":"CMP / Minera Huasco","tipo":"Infraestructura portuaria","tipologia":"EIA","fecha":"2012-08-03","estado":"Aprobado (RCA 2015)","inversion":320,"lon":-71.315,"lat":-29.432,"flag":None,"url":"https://seia.sea.gob.cl/busqueda/buscarProyecto.php?regiones=4&comunas=4101"},
  {"seia_id":None,"nombre":"LT 2x500 kV Cardones–Polpaico","titular":"Interchile S.A. (ISA)","tipo":"Transmisión eléctrica","tipologia":"EIA","fecha":"2013-12-01","estado":"RCA 1608/2015 · operativa","inversion":1000,"lon":-71.10,"lat":-29.40,"flag":None,"url":"https://www.sea.gob.cl/revision-de-la-rca-del-proyecto-plan-de-expansion-chile-lt-2x500-kv-cardones-polpaico"},
  {"seia_id":None,"nombre":"LT 2x220 kV Punta Colorada – Pan de Azúcar","titular":"Eletrans III (InterChile/ISA)","tipo":"Transmisión eléctrica","tipologia":"DIA","fecha":"2016-01-01","estado":"Aprobado · operativa","inversion":None,"lon":-71.10,"lat":-29.34,"flag":None,"url":"https://seia.sea.gob.cl/busqueda/buscarProyecto.php?regiones=4&comunas=4101"},
  {"seia_id":None,"nombre":"Parque Eólico Punta Colorada","titular":"Barrick Chile Generación","tipo":"Energía eólica","tipologia":"DIA","fecha":"2010-01-01","estado":"Operativo desde 2011","inversion":70,"lon":-71.272,"lat":-29.354,"flag":None,"url":"https://seia.sea.gob.cl/busqueda/buscarProyecto.php?regiones=4&comunas=4101"},
  {"seia_id":None,"nombre":"Central Termo Punta Colorada","titular":"Barrick Chile Generación","tipo":"Termoeléctrica","tipologia":"DIA","fecha":"2009-01-01","estado":"Aprobado · operativa","inversion":None,"lon":-71.270,"lat":-29.358,"flag":None,"url":"https://seia.sea.gob.cl/busqueda/buscarProyecto.php?regiones=4&comunas=4101"},
  {"seia_id":None,"nombre":"PFV La Huella (87 MWp)","titular":"Austrian Solar Chile / Clean Capital","tipo":"Solar fotovoltaico","tipologia":"DIA","fecha":"2018-01-01","estado":"Operativo desde nov-2021","inversion":70,"lon":-71.15,"lat":-29.45,"flag":None,"url":"https://seia.sea.gob.cl/busqueda/buscarProyecto.php?regiones=4&comunas=4101"},
  {"seia_id":None,"nombre":"PFV Punta del Viento (145 MW)","titular":"FRV / Fotowatio","tipo":"Solar fotovoltaico","tipologia":"DIA","fecha":"2019-01-01","estado":"Aprobado (RCA 2020)","inversion":138,"lon":-71.20,"lat":-29.40,"flag":None,"url":"https://seia.sea.gob.cl/busqueda/buscarProyecto.php?regiones=4&comunas=4101"},
  {"seia_id":None,"nombre":"PFV Los Rastrojos (141 MW)","titular":"La Serena Ocho SpA","tipo":"Solar fotovoltaico","tipologia":"DIA","fecha":"2019-01-01","estado":"Aprobado","inversion":185,"lon":-71.20,"lat":-29.50,"flag":None,"url":"https://seia.sea.gob.cl/busqueda/buscarProyecto.php?regiones=4&comunas=4101"},
  {"seia_id":None,"nombre":"PFV La Higuera (200 MW)","titular":"Aprobado Comisión Evaluación Coquimbo","tipo":"Solar fotovoltaico","tipologia":"DIA","fecha":"2016-01-01","estado":"Aprobado","inversion":200,"lon":-71.15,"lat":-29.50,"flag":None,"url":"https://seia.sea.gob.cl/busqueda/buscarProyecto.php?regiones=4&comunas=4101"},
  {"seia_id":None,"nombre":"PFV Alto Solar (210 MW + LT 67km)","titular":"Alto Solar SpA","tipo":"Solar fotovoltaico","tipologia":"DIA","fecha":"2023-01-01","estado":"En calificación","inversion":161,"lon":-71.05,"lat":-29.45,"flag":None,"url":"https://seia.sea.gob.cl/busqueda/buscarProyecto.php?regiones=4&comunas=4101"},
  {"seia_id":None,"nombre":"Continuidad Distrito Pleito Fase 3","titular":"CMP","tipo":"Minería (hierro)","tipologia":"DIA","fecha":None,"estado":"Aprobado","inversion":35,"lon":-71.10,"lat":-29.55,"flag":None,"url":"https://seia.sea.gob.cl/busqueda/buscarProyecto.php?regiones=4&comunas=4101"},
  {"seia_id":None,"nombre":"LT Adecuación Cruz Grande","titular":"CAP / CMP","tipo":"Transmisión eléctrica","tipologia":"DIA","fecha":"2013-01-01","estado":"Aprobado","inversion":None,"lon":-71.30,"lat":-29.43,"flag":None,"url":"https://seia.sea.gob.cl/busqueda/buscarProyecto.php?regiones=4&comunas=4101"},
  {"seia_id":None,"nombre":"Central Barrancones (DESISTIDO)","titular":"Suez Energy / GDF","tipo":"Termoeléctrica carbón","tipologia":"EIA","fecha":"2007-01-01","estado":"Desistido tras intervención Piñera (2010)","inversion":1100,"lon":-71.34,"lat":-29.27,"flag":"historic","url":"https://seia.sea.gob.cl/busqueda/buscarProyecto.php?regiones=4&comunas=4101"},
  {"seia_id":"2132372562","nombre":"Recurso Reclamación Dominga","titular":"Andes Iron SpA","tipo":"Reclamación EIA","tipologia":"EIA","fecha":"2017-01-01","estado":"Activo · Comité de Ministros","inversion":None,"lon":-71.295,"lat":-29.348,"flag":"critical","url":"http://seia.sea.gob.cl/expediente/expedientes.php?id_expediente=2132372562"},
  {"seia_id":"2131608818","nombre":"ANDES LNG (Regasificación)","titular":"Andes LNG SpA","tipo":"Terminal GNL","tipologia":"EIA","fecha":None,"estado":"En calificación","inversion":None,"lon":-71.33,"lat":-29.40,"flag":None,"url":"http://seia.sea.gob.cl/expediente/ficha/fichaPrincipal.php?modo=ficha&id_expediente=2131608818"},
  {"seia_id":None,"nombre":"Desaladora Dominga (parte EIA)","titular":"Andes Iron SpA","tipo":"Infraestructura hídrica","tipologia":"EIA","fecha":"2013-01-01","estado":"Incluida en RCA Dominga","inversion":None,"lon":-71.32,"lat":-29.40,"flag":None,"url":"https://seia.sea.gob.cl/expediente/ficha/fichaPrincipal.php?modo=ficha&id_expediente=2128565332"},
]

def main():
    conn = psycopg2.connect(DB_URL); conn.autocommit = False
    cur = conn.cursor()
    cur.execute("delete from proyectos_seia where comuna_codigo = 4102;")
    rows = [(
        4102, p["seia_id"], p["nombre"], p["titular"], p["tipo"], p["tipologia"],
        p["estado"], p["fecha"], p["inversion"], p["lon"], p["lat"], "Coquimbo",
        p["flag"], p["url"]
    ) for p in PROYECTOS]
    execute_batch(cur, """
        insert into proyectos_seia
          (comuna_codigo, seia_id, nombre, titular, tipo, tipologia, estado,
           fecha_ingreso, inversion_usd_m, geom, region, flag, url_expediente)
        values
          (%s,%s,%s,%s,%s,%s,%s,%s,%s,
           ST_SetSRID(ST_MakePoint(%s,%s),4326), %s,%s,%s)
    """, rows)
    conn.commit()
    cur.execute("select count(*) from proyectos_seia where comuna_codigo = 4102;")
    print(f"Proyectos SEIA cargados: {cur.fetchone()[0]}")
    cur.close(); conn.close()

if __name__ == "__main__": main()
