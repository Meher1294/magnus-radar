# /tiles/

Capas raster del visor v1-h2.

## Contenido actual

### h2_ortofoto.jpg (v1.1.10 · 2026-06-02)

```yaml
formato: JPEG progressive quality 82
dimensiones: 1700 × 1920 px
peso: 834 KB
fuente_original: docs/ingesta_ortofoto_h2/05_mosaico_asentamiento_amplio.png (8.2 MB · 2125×2400)
pipeline: PIL/Pillow downscale + LANCZOS + progressive JPEG
bbox_geo:
  W: -71.2056624238989
  E: -71.19200880981892
  S: -29.518136215465194
  N: -29.50462817876295
extension: 1.32 km × 1.50 km = ~6.8 km²
resolucion_efectiva: ~0.4 m/pixel
cobertura_relativa_H2: 12.6% del perímetro Daniel RTK
zona: sector oriental H2 · incluye asentamiento + sector lineal AI

uso_en_visor:
  source_type: image (MapLibre)
  layer_type: raster
  paint: raster-opacity 0.85 · raster-fade-duration 250ms
  insertado: debajo de capas vectoriales H2 (fondo)
  default: OFF (activable desde sidebar FOCO H2)
  toggle_label: "Ortofoto sector oriental (raster)"
```

## Migración futura prevista v2

```yaml
de:  imagen JPEG única (zoom limitado a 16-17)
a:   PMTiles single-file vector + raster pyramid
mantener: MapLibre como motor (CANON_V1) · cambiar solo el source
protocolo: PMTiles via maplibre-pmtiles-plugin · `protocol: 'pmtiles://'`

cuando_migrar:
  - cuando llegue ortofoto del dron Daniel (100% cobertura del perímetro RTK)
  - o cuando corpus GeoJSON supere ~10.000 features (PMTiles para vector)
```

## Doctrinas aplicables

- doctrina-capas-no-es-conocimiento-dealx-consume-eventos: este raster alimenta EVT-H2-OCCUPATION-BASELINE-20260531 · NO genera TENSIÓN
- canon-privacidad-magnus-radar: ortofoto pública (uso interno Magnus/XPU · sin PII identificable)
- doctrina-audit-post-deploy-único-válido: estado declarado verde solo post-deploy contra URL viva
