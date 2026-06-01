# MAGNUS_RADAR_WEB_V1_H2_LA_HIGUERA

**Versión:** 1.0.9.2
**Build:** 2026-06-01 (hotfix-2 P0-SEC · VERSION.md saneado)
**Estado:** MVP operativo · no canon final

---

## Frase rectora

> Publicar Magnus Radar como visor de inteligencia territorial trazable de H2 / Estancia La Higuera, sin mezclarlo con firma ni negociación futura de H1 García Huidobro.

---

## Regla canónica del producto

> Magnus Radar visualiza territorio, evidencia y relaciones documentales.
> No ejecuta corretaje, negociación ni gestión comercial.

---

## Cambios v1.0.1

```yaml
mejoras_v1_0_1:
  
  DATA_STATUS_badge_visible:
    ubicacion: esquina superior izquierda del mapa
    estados: cargando · ok · warn · err
    contenido_si_ok: "✓ X features · Y capas · v1.0.1"
    contenido_si_err: "✗ 0 features · X de Y capas fallaron + lista errores"
    contenido_si_file_protocol: warning explícito con comando python3 -m http.server
  
  contador_por_capa:
    nuevo: badge "N ft" al lado de cada capa en panel izquierdo
    estados: ok (verde) · err (rojo)
    tooltip: muestra error específico si hay fallo
  
  warning_explicito_si_0_features:
    console.warn visible
    DATA STATUS badge cambia a estado err
    statusbar dot cambia a rojo
  
  reestructura_directorios:
    de:  web/v1-h2/data/
    a:   web/v1-h2/geojson/
    nuevos: web/v1-h2/tiles/  (placeholder PMTiles futuro)
            web/v1-h2/styles/ (placeholder style.json MapLibre futuro)
    razon: preparar transición de GeoJSON → vector tiles sin rediseñar visor
  
  status_bar_protocolo:
    muestra: "protocolo: file:" o "protocolo: http:" en statusbar
    permite: diagnóstico inmediato del problema más común
  
  manejo_robusto_errores_fetch:
    if HTTP !ok: lanza Error con código
    if exception: catch y mostrar en DATA STATUS
    NO promueve cargas incompletas a "OK"
```

---

## Alcance v1

```yaml
INCLUYE:
  - H2 Cominetti (roles 24-123 + 24-160 · aliases 24-48, 24-4)
  - Estancia La Higuera matriz (Plano IV-1-1777-S.R. · bbox aproximado)
  - Daniel RTK (capa física · marcador flag pendiente)
  - Ocupaciones (ortofoto KMZ super-overlay · 19 features)
  - Servidumbres (924-644 · InterChile · MOP Ruta 5 · Andes Iron Sector Lineal)
  - Conflictos (C11 resuelto · C13 resuelto · rol 24-5 geometría pendiente)
  - H1 García Huidobro como capa CONTEXTUAL (NO operacional · default OFF)

NO_INCLUYE:
  - firma H1 García Huidobro
  - negociación con García Huidobro
  - cronogramas de exclusiva H1
  - cualquier dependencia comercial H1
  - operaciones comerciales (Magnus Radar muestra inteligencia · no ejecuta)
```

## Reglas de visor aplicadas

```yaml
separacion_capas:
  - SII (catastro · KMZ-06)
  - CBR (jurídica · inscripciones · pendiente cruce)
  - RTK (física operacional · pendiente Daniel)

rol_sii_NO_es_clave_primaria:
  todo polígono muestra aliases históricos visibles
  ejemplo: 24-123 ← alias [24-48]
  
fuente_obligatoria:
  cada feature lista fuentes documentales en panel detalle

estados_epistemologicos_visibles:
  HECHO · evidencia documental directa
  INFERENCIA · derivada con respaldo
  HIPÓTESIS · no demostrada
  BLOQUEADO · pendiente validación

prohibido_visualmente:
  promover 0-0 a titular conocido
  decir proxy_GPKG = rol_24-5
  mezclar EXP_H2 con EXP_DOMINGA_SERVIDUMBRES
```

## Estructura de archivos

```
web/v1-h2/
├── index.html                                   # entry point · MapLibre + vanilla JS + DATA STATUS
├── geojson/                                     # capas vectoriales v1
│   ├── capa_1_h2_cominetti.geojson              # 4 polígonos · canon alta confianza
│   ├── capa_2_estancia_matriz.geojson           # bbox aproximado + 2 vértices HR
│   ├── capa_3_daniel_rtk.geojson                # marcador flag pendiente
│   ├── capa_4_ocupaciones.geojson               # 19 features ortofoto
│   ├── capa_5_servidumbres.geojson              # 4 líneas
│   ├── capa_6_conflictos.geojson                # 3 conflictos
│   └── capa_h1_garcia_huidobro_contextual.geojson  # 5 polígonos · NO operacional
├── tiles/                                       # placeholder PMTiles vector tiles (v2)
│   └── README.md
├── styles/                                      # placeholder style.json custom (v2)
│   └── README.md
├── VERSION.md                                   # changelog
└── DEPLOY_INSTRUCTIONS.md                       # cómo desplegar
```

## Stack técnico

```yaml
map_engine_canonizado:
  nombre: MapLibre GL JS
  estado: CANON_V1 (canon-maplibre-motor-cartografico-v1)
  version: 4.7.1
  prohibido_mezclar_con: [Mapbox, Leaflet, Cesium, OpenLayers]

frontend: HTML + vanilla JS + MapLibre GL JS 4.7.1
basemap: Carto Dark No-Labels (raster tiles)
crs: EPSG:4326 (datos) · EPSG:3857 (mapa) · EPSG:32719 (cálculos)
backend: ninguno (filesystem-first)
storage: archivos estáticos
deploy: cualquier servidor estático
escalabilidad: GeoJSON v1 → PMTiles v2 (sin cambiar motor)
```

## Criterio de publicación · cumplido

```yaml
visor_permite:
  ✅ ver H2 (capa principal con polígonos catastrales)
  ✅ ver capas SII/CBR/RTK separadas (3 capas diferenciadas)
  ✅ consultar ficha por unidad territorial (click → panel detalle)
  ✅ mostrar fuente (fuentes_chip en panel detalle)
  ✅ mostrar estado HECHO / INFERENCIA / HIPÓTESIS / BLOQUEADO (badges)
  ✅ aliases históricos visibles (alias_chip morado)
  ✅ caveats epistemológicos visibles (bordeados amarillo)
  ✅ doctrinas aplicables visibles (chips con regla canónica)
  ✅ DATA STATUS visible · diferencia OK / error / file:// 
  ✅ contador features por capa visible en panel izquierdo
```

## Cómo desplegar

### Opción 1 · servidor local (test inmediato · CRÍTICO post-cambios)

```bash
cd magnus-radar/web/v1-h2
python3 -m http.server 8080
# abrir http://localhost:8080
# verificar DATA STATUS badge muestre "✓ 39 features · 7 capas · v1.0.1"
```

### Opción 2 · GitHub Pages

```bash
cd magnus-radar
git add web/v1-h2/
git commit -m "feat: Magnus Radar v1.0.1 H2 · DATA STATUS + reestructura geojson/tiles/styles"
git push origin main
# habilitar GitHub Pages apuntando a /web
# URL: https://meher1294.github.io/magnus-radar/v1-h2/
```

### Opción 3 · Hostinger VPS

```bash
ssh ubuntu@srv1571481.hstgr.cloud
cd ~/magnus-radar && git pull
sudo systemctl reload caddy
# URL: https://srv1571481.hstgr.cloud/v1-h2/
```

## Pendientes para v1.1

```yaml
P1_georreferenciacion_plano_historico:
  archivo: ITS-CARTO-PLANO-0001
  desbloquea: capa 2 matriz con geometría precisa + sublotes 1a/1b/2a/2b/3a/3b/C reales
  
RTK_Daniel:
  reemplaza: marcador placeholder por perímetro real H2
  
artefacto_andes_iron_geojson:
  recupera: trazado preciso Sector Lineal (hoy aproximado)

cruce_CBR:
  agrega: capa CBR como tercera vista separada de SII

oficio_BBNN:
  valida: hipótesis macro-fiscal 80-0 + 79-1 + 1075-1
```

## Migración v2 prevista (cuando aplique)

```yaml
de_GeoJSON_a_PMTiles:
  trigger: cuando corpus supere ~500 polígonos visibles simultáneos
  archivo_nuevo: tiles/predios_la_higuera.pmtiles (single file)
  cambio_en_index_html: 
    de: { type:'geojson', data: '/geojson/...' }
    a:  { type:'vector', url: 'pmtiles:///tiles/predios.pmtiles' }
  motor_se_mantiene: MapLibre GL JS (CANON_V1)
```

## Changelog

- **v1.0.8** · 2026-05-31 · GeometryFix nativo (sin turf.js): centroide real ponderado por área para Polygon/MultiPolygon · haversine para distancias reales · auto-parche properties.lat/lon (rol 24-123 multi-polígono desfases 863m/2059m/6936m del centroide real) + ficha predio muestra Δ vs lat/lon + n_parcelas + búsqueda multi-polígono con tag "parcela X/N" ordenado por superficie + drawBtn deshabilitado con label "Dibujar · próximamente" (era placeholder roto) · expone window.__MAGNUS_GEO con utilidades
- **v1.0.7** · 2026-05-31 · Canon privacidad uso interno (PII/comisión aceptable transitoriamente · futuro auth max@xpu.cl) + 5 fixes accesibilidad/SEO: (1) versión única visible v1.0.7 (eliminadas v0.2 conviviendo) · (2) link rel=canonical agregado · (3) text-shadow WCAG AA en botones naranjas (.btn-primary, .h2-focus-btn) · (4) basemap/color-mode pills activos con texto oscuro #0A111F · (5) console.log gated detrás de window.__MAGNUS_DEBUG flag
- **v1.0.6** · 2026-05-31 · RECONCILIACIÓN VERDAD: TruthReconciler runtime (deriva SEIA/DGA/predios desde sources reales · etiqueta universos · cifras hardcoded reemplazadas) + H2 Click Priority (ficha H2 gana sobre predios SII vía interceptor global) + estados normalizados (estado_canonico → estado · raw preservado en estado_raw_legacy · 39/39 features con 4 estados canónicos · 0 estados libres)
- **v1.0.5** · 2026-05-31 · HOTFIX .gitignore (publicar GeoJSON H2 + andamiaje P1) · normalizar estados a 4 canónicos HECHO/INFERENCIA/HIPOTESIS/BLOQUEADO (37 features distribuidos) · BLOQUEADO en Daniel RTK + titular asignado · datos económicos del mandato visibles en ficha H2 (saneados después en v1.0.9.1) · caveats array · flag no_comercial H1 · gate pre-push canon (git ls-files check)
- **v1.0.4** · 2026-05-31 · 7 fixes post-deploy: smartFetchGeoJSON (4 paths fallback) · build_failed overlay si 0 features HTTP · tasación mailto (no chat) · filtros SEIA handler · label Sector Lineal Andes Iron · basemap claro default · h2_rtk OFF · banner H1 no comercial
- **v1.0.3** · 2026-05-31 · sidebar colapsable + buscador + contadores por sección
- **v1.0.2** · 2026-05-31 · OPCIÓN B · clonar v0 + inyectar capas H2 + sistema epistemológico
- **v1.0.1** · 2026-05-31 · DATA STATUS badge + contador por capa + warning file:// + reestructura geojson/tiles/styles · DESCARTADO con pelado
- **v1.0.0** · 2026-05-31 · MVP pelado · 6 capas mínimas · DESCARTADO (no era el estándar)

## Autor

Magnus SpA · Inversiones Magnus SpA
