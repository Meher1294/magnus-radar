# QA_AUDIT · Magnus Radar v1.0.8

**Fecha:** 2026-05-31
**Disparador:** auditoría ronda 4 Max · funciones y validación geométrica · distancias punto-a-punto entre roles erradas + botón Dibujar polígono placeholder + búsqueda multi-polígono confusa

---

## P1 · Distancias con centroide real (GeometryFix nativo)

### Hallazgo Max
```yaml
rol_24-123_3_polígonos:
  desfase_lat_lon_vs_centroide_real:
    polígono_1: 863 m
    polígono_2: 2.059 m
    polígono_3: 6.936 m
  
distancia_24-123_vs_24-160_punto_a_punto: 4.85 km
realidad: polígonos COLINDANTES dentro de la misma Hijuela 2
métrica_punto_a_punto: ERRADA por kilómetros
```

### Fix aplicado

```yaml
estrategia: GeometryFix IIFE nativo (sin turf.js · sin dependencias externas)
ubicación: web/v1-h2/index.html · línea ~6520 (post H2 click priority)
expone_globalmente: window.__MAGNUS_GEO con utilities

algoritmos_implementados:
  polygonCentroid: centroide ponderado por área (algoritmo Mapping Lab) · O(n) sobre el ring
  polygonAreaHa: shoelace + proyección equirectangular local · O(n) por ring
  featureCentroid: ponderado por área entre TODAS las parcelas (Polygon o MultiPolygon)
  haversine: distancia entre lat/lon en metros · 6371000 m radio terrestre
  distanceFeatures: distancia mínima entre parcelas de 2 features (no solo entre centroides agregados)

auto_parche_propiedades:
  itera_sources: predios · seia · dga · concesiones · h2-src-*
  para_cada_feature_con_geometría:
    f.properties._centroide_calc_lon
    f.properties._centroide_calc_lat
    f.properties._n_parcelas
    f.properties._area_geom_ha (recalculada)
    f.properties._desfase_lat_lon_m (vs lat/lon original)
    f.properties._desfase_significativo (true si > 100 m)

ficha_predio_corrige_centroide:
  antes:  ${p.lat.toFixed(4)}, ${p.lon.toFixed(4)}
  ahora:  ${(p._centroide_calc_lat ?? p.lat).toFixed(4)}, ${(p._centroide_calc_lon ?? p.lon).toFixed(4)}
          + tag "· N parcelas" si multi-polígono
          + tag "· Δ Xm vs lat/lon" si desfase > 100 m
  resultado_esperado_24-123:
    centroide real visible (ya no lat/lon hardcoded incorrecto)
    "· 3 parcelas" visible
    "· Δ 863m vs lat/lon" (o más · para la parcela con mayor desfase)

uso_externo:
  desde_consola: __MAGNUS_GEO.distanceFeatures(featA, featB)
  retorna: { centroide_a_centroide_m, minima_entre_parcelas_m, a_partes, b_partes }
```

---

## P2 · Botón "Dibujar polígono" deshabilitado honesto

### Hallazgo Max
```yaml
botón_actual: "Dibujar polígono"
comportamiento_real: nada · placeholder sin handler
problema_UX: promete función inexistente
```

### Fix aplicado

```yaml
cambio_HTML:
  antes: <button class="map-btn" id="drawBtn">...Dibujar polígono</button>
  ahora: <button class="map-btn" id="drawBtn" disabled title="Próximamente · v2" style="opacity:0.45;cursor:not-allowed">...Dibujar · próximamente</button>
  
efectos:
  visualmente_deshabilitado: opacity 0.45 · cursor not-allowed
  título_tooltip: "Próximamente · v2"
  label: "Dibujar · próximamente" (en lugar de prometer función)
  HTML_disabled: bloquea click programáticamente

opciones_v2_futuras:
  habilitar_real: maplibre-gl-draw plugin (+50 KB)
  alternativa_nativa: dibujar con click + double-click para cerrar (sin dependencia)
```

---

## P3 · Búsqueda multi-polígono diferenciada

### Hallazgo Max
```yaml
búsqueda_24-123: devuelve 3 resultados
sub_textos_actuales: "1.402 ha · 903 ha · 0,15 ha"
problema_UX: usuario no sabe que las 3 entradas son la MISMA hijuela en parcelas distintas
```

### Fix aplicado

```yaml
estrategia: agrupar duplicados por rol + mostrar tag "parcela X/N"

cambios_funcionales:
  ordenamiento: por superficie desc (más grande primero)
  límite_aumentado: de 5 a 8 resultados (para acomodar duplicados)
  conteo_por_rol: pre-cálculo rolCount[r] antes de render
  tag_parcela: solo si rolCount[r] > 1

render_resultado:
  antes:
    "Rol 24-123"
    "Sin sector · 1.402 ha"
  ahora:
    "Rol 24-123 · parcela 1/3"
    "Sin sector · 1.402 ha"
    
    "Rol 24-123 · parcela 2/3"
    "Sin sector · 903 ha"
    
    "Rol 24-123 · parcela 3/3"
    "Sin sector · 0,15 ha"
```

---

## Decisiones diferidas

```yaml
P4_i18n_EN_completa:
  decisión: NO_CODEAR_v1_0_8
  razón: visor uso interno · idioma español OK · i18n EN parcial actual no rompe nada
  diferido_a: v2 cuando se difunda públicamente
  
P5_modo_presentación_F:
  no_probado_Max
  acción: verificación manual pendiente (no es fix · es validación)
  diferido_a: próxima ronda QA
  
PII_RUT_propietario_visible_sin_login:
  decisión: NO_CODEAR_v1_0_8
  razón: canon-privacidad-magnus-radar (uso interno aceptable transitoriamente)
  refinamiento_post_ronda_4: "no difundir URL públicamente hasta migrar a auth"
  diferido_a: cuando se cruce línea de difusión pública · entonces auth obligatorio
```

---

## Resumen técnico

```yaml
v1_0_8_tamaño: 316 KB (era 308 KB v1.0.7) · +8 KB para GeometryFix nativo
canon_MapLibre: intacto (mapbox=0 · cesium=0 · turf=0 · GeometryFix nativo sin dependencias)
servidor_local: 200 OK
inyecciones_acumuladas:
  v1.0.4: smartFetchGeoJSON + buildFailedOverlay + filtros SEIA + label Andes Iron + banner H1
  v1.0.5: estados canónicos + comisión 10% + Daniel RTK BLOQUEADO
  v1.0.6: TruthReconciler + H2 click priority + estados normalizados render-time
  v1.0.7: canon privacidad + WCAG AA + version única + canonical
  v1.0.8: GeometryFix nativo + drawBtn disabled + búsqueda multi-polígono
```

---

## Comandos push v1.0.8 (consolidado v1.0.6+v1.0.7+v1.0.8)

```bash
cd "/Users/maxmedina/Desktop/Master Meher/Magnus Proyectos/MAGNUS RADAR/MVP LA HIGUERA/MVP MAGNUS RADAR LA HIGUERZ/magnus-radar"
rm -f .git/index.lock

git add web/v1-h2/index.html \
        web/v1-h2/VERSION.md \
        web/v1-h2/geojson/*.geojson \
        docs/RECONCILIACION_VERDAD_v1_0_6.md \
        docs/QA_AUDIT_v1_0_7.md \
        docs/QA_AUDIT_v1_0_8.md

git status --short | head -15

git commit -m "fix: Magnus Radar v1.0.8 · GeometryFix nativo + drawBtn honesto + busqueda multi-poligono

Consolida v1.0.6 + v1.0.7 + v1.0.8:
- v1.0.6: TruthReconciler runtime · H2 click priority · estados canonicos · Comparar runtime · tasacion bajo solicitud
- v1.0.7: canon privacidad uso interno · WCAG AA · version unica · canonical SEO · console gated
- v1.0.8: GeometryFix nativo sin turf · centroide real Polygon/MultiPolygon · haversine · auto-parche lat/lon · drawBtn proximamente · busqueda multi-poligono con parcela X/N

Auditorias ronda 3 + 4 Max: cifras SEIA 22 vs 17 · distancias multi-poligono · privacidad interna OK transitoriamente"

git push origin main
```

---

## Validación post-push v1.0.8

```yaml
checklist_online:
  □ activar window.__MAGNUS_DEBUG = true en consola
  □ recargar Cmd+Shift+R
  □ console: [v1.0.8 GeometryFix] N features con centroide calculado
  □ buscar "24-123" en search → ver 3 entradas con "parcela 1/3" · "parcela 2/3" · "parcela 3/3" + superficie desc
  □ click sobre parcela 1/3 → ficha muestra centroide real (no lat/lon original)
  □ ficha predio H2: campo Centroide muestra "· N parcelas" + "· Δ Xm vs lat/lon" si aplica
  □ botón "Dibujar · próximamente" visible · disabled · cursor not-allowed · tooltip "Próximamente · v2"
  □ desde consola: __MAGNUS_GEO.distanceFeatures(featA, featB) retorna distancia real
  □ panel VERDAD CALCULADA runtime sigue funcional (de v1.0.6)
  □ click H2 abre ficha epistemológica (de v1.0.6 H2ClickPriority)
```

---

**Linkado:**
- [[QA_AUDIT_v1_0_7]]
- [[QA_AUDIT_v1_0_5]]
- [[RECONCILIACION_VERDAD_v1_0_6]]
- [[canon-privacidad-magnus-radar]]
- [[canon-maplibre-motor-cartografico-v1]]
- auditoría ronda 4 Max (este ciclo)
