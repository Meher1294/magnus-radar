# /tiles/

Placeholder para PMTiles / Vector Tiles (MapLibre).

**Estado:** vacío · sin tiles en v1
**Uso futuro:** cuando el corpus pase de ~100 features GeoJSON a miles de polígonos SII (7687 predios catastrales completos), reemplazar GeoJSON por PMTiles single-file.

**Migración prevista v2:**
```yaml
de:  web/v1-h2/geojson/capa_X.geojson (decenas/cientos de features)
a:   web/v1-h2/tiles/predios_la_higuera.pmtiles (vector tiles · single file)
mantener: MapLibre como motor (CANON_V1) · cambiar solo el source
```

**Protocolo:** PMTiles via maplibre-pmtiles-plugin · `protocol: 'pmtiles://'`
