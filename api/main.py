"""
Magnus Radar API — FastAPI
Endpoints públicos para consultar predios, SEIA y eventos de La Higuera.
"""
import os
from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from supabase import create_client, Client
from dotenv import load_dotenv
from typing import Optional

load_dotenv()

SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_KEY = os.environ.get("SUPABASE_ANON_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    raise RuntimeError("Setear SUPABASE_URL y SUPABASE_ANON_KEY en .env")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

app = FastAPI(
    title="Magnus Radar API",
    description="Inteligencia territorial pública — Comuna La Higuera",
    version="0.1.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # restringir en prod
    allow_credentials=True,
    allow_methods=["GET", "POST"],
    allow_headers=["*"],
)

# ============ HEALTH ============
@app.get("/health")
def health():
    return {"status": "ok", "service": "magnus-radar-api"}

# ============ COMUNAS ============
@app.get("/api/comunas")
def list_comunas():
    res = supabase.table("comunas").select("*").eq("publicado", True).execute()
    return res.data

@app.get("/api/comunas/{codigo}/stats")
def comuna_stats(codigo: int):
    res = supabase.table("stats_comuna").select("*").eq("codigo", codigo).single().execute()
    return res.data

# ============ PREDIOS ============
@app.get("/api/predios")
def list_predios(
    comuna: int = 4102,
    sector: Optional[str] = None,
    rol: Optional[str] = None,
    min_area: Optional[float] = None,
    limit: int = Query(default=500, le=10000)
):
    """Lista predios (sin geometría completa, solo centroide para listados)."""
    q = supabase.table("predios_publicos").select("*").eq("comuna_codigo", comuna)
    if sector: q = q.eq("sector", sector)
    if rol: q = q.ilike("rol", f"%{rol}%")
    res = q.limit(limit).execute()
    return res.data

@app.get("/api/predios/{predio_id}")
def get_predio(predio_id: int):
    res = supabase.table("predios").select("*").eq("id", predio_id).single().execute()
    if not res.data: raise HTTPException(404, "Predio no encontrado")
    return res.data

# ============ SEIA ============
@app.get("/api/seia")
def list_seia(comuna: int = 4102, estado: Optional[str] = None):
    q = supabase.table("proyectos_seia_publicos").select("*")
    if estado: q = q.ilike("estado", f"%{estado}%")
    res = q.execute()
    return res.data

@app.get("/api/seia/{seia_id}")
def get_seia(seia_id: int):
    res = supabase.table("proyectos_seia").select("*").eq("id", seia_id).single().execute()
    if not res.data: raise HTTPException(404)
    return res.data

# ============ EVENTOS ============
@app.get("/api/eventos")
def list_eventos(
    comuna: int = 4102,
    desde: Optional[str] = None,
    tipo: Optional[str] = None,
    limit: int = Query(default=100, le=500)
):
    q = supabase.table("eventos").select("*").eq("comuna_codigo", comuna)
    if desde: q = q.gte("fecha", desde)
    if tipo: q = q.eq("tipo", tipo)
    res = q.order("fecha", desc=True).limit(limit).execute()
    return res.data

# ============ BÚSQUEDA ============
@app.get("/api/search")
def search(q: str = Query(min_length=2)):
    """Búsqueda fuzzy en roles, sectores y proyectos."""
    predios = supabase.table("predios_publicos").select("id,rol,sector,area_ha,lat,lon")\
        .ilike("rol", f"%{q}%").limit(20).execute()
    seia = supabase.table("proyectos_seia_publicos").select("id,nombre,titular,lat,lon")\
        .or_(f"nombre.ilike.%{q}%,titular.ilike.%{q}%").limit(20).execute()
    return {"predios": predios.data, "seia": seia.data}
