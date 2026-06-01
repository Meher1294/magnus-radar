# SPRINT_HARDENING_02 · Reporte final

**Fecha:** 2026-05-31
**Origen:** `AUDITORIA_METRICAS_VISIBLES_PRE_PRINCIPIO_2.md` · 4 sospechas en `web/js/map-geometrias.js`
**Alcance autorizado:** sólo opción B (convertir a derivación pura) · sin features nuevas · sin schema nuevo · sin UI nueva · sin cambios visuales intencionales
**Custodio:** Max Medina

---

## 1 · Resumen ejecutivo

| Sospecha | Estado | Fix |
|---|---|---|
| S-01 · `vertices_count: 26` (G3) | ✅ Resuelto | `vertexCount(g)` puro · `coords.reduce(sum,ring)` |
| S-02 · `polygons_count: 3` (G4) | ✅ Resuelto | `polygonCount(g)` puro · `coords.length` o 1 |
| S-03 · `vertices_total: 77` (G4) | ✅ Resuelto | mismo helper `vertexCount(g)` (cubre Polygon + MultiPolygon) |
| S-04 · `delta_pct G3+G4` | ✅ Resuelto | `deltaPct(g)` puro · `(calc - decl) / decl * 100` |

**Resultado:** 4 sospechas estructurales eliminadas. Cero campos derivables persistidos en `GEOM_DEFINITIONS`. Tres helpers puros exportados como contrato.

---

## 2 · Diff acumulado

| Archivo | Líneas antes | Líneas después | Δ | MD5 final |
|---|---|---|---|---|
| `web/js/map-geometrias.js` | 245 | 286 | +41 | `23c66a961458068ecb6921fe63bd7d50` |

Δ total: **+41 líneas** (helpers + comentarios `[HARDENING H-B1]` − 4 líneas de campos persistidos eliminados).

Versión bumped: `0.3.7A-real-geoms` → `0.3.7A-real-geoms-h02`.

---

## 3 · Helpers nuevos

```javascript
function vertexCount(g) {
  if (!g || !g.coords) return 0;
  if (g.geom_type === 'MultiPolygon') {
    return g.coords.reduce(
      (sum, poly) => sum + poly.reduce((s, ring) => s + ring.length, 0),
      0
    );
  }
  return g.coords.reduce((sum, ring) => sum + ring.length, 0);
}

function polygonCount(g) {
  if (!g || !g.coords) return 0;
  return g.geom_type === 'MultiPolygon' ? g.coords.length : 1;
}

function deltaPct(g) {
  if (!g) return null;
  const calc = g.superficie_calculada_ha;
  const decl = g.superficie_declarada_ha ?? g.superficie_declarada_ha_etiqueta_kmz;
  if (typeof calc !== 'number' || typeof decl !== 'number' || decl === 0) return null;
  return parseFloat((((calc - decl) / decl) * 100).toFixed(2));
}

export { vertexCount, polygonCount, deltaPct };
```

Características:
- Puras (sin side-effects, sin lectura de estado global).
- Cubren los 3 casos de fixture (G1/G2 sin coords → retornan 0/null limpiamente).
- Cubren Polygon y MultiPolygon.
- `deltaPct` cubre dos convenciones de campo declarada (`superficie_declarada_ha` y `superficie_declarada_ha_etiqueta_kmz`).
- Exportadas para uso externo o test.

---

## 4 · Cambios en `_toGeoJSON`

**Antes:**
```javascript
properties: {
  codigo, label,
  superficie_declarada_ha: g.superficie_declarada_ha ?? g.superficie_declarada_ha_etiqueta_kmz,
  superficie_calculada_ha: g.superficie_calculada_ha,
  delta_pct: g.delta_pct,                            // lectura de campo persistido
  vertices: g.vertices_count ?? g.vertices_total     // lectura de campo persistido
}
```

**Después:**
```javascript
properties: {
  codigo, label,
  superficie_declarada_ha: g.superficie_declarada_ha ?? g.superficie_declarada_ha_etiqueta_kmz,
  superficie_calculada_ha: g.superficie_calculada_ha,
  delta_pct: deltaPct(g),         // derivado en render
  vertices: vertexCount(g),       // derivado en render
  polygons: polygonCount(g)       // ahora también expuesto · derivado
}
```

---

## 5 · Verificación física consolidada (math test)

| Métrica | Antes (hardcoded) | Ahora (derivado) | Match | Fuente del cálculo |
|---|---|---|---|---|
| G3 vertexCount | 26 | **26** | ✓ idéntico | `coords[0].length` (suma rings) |
| G3 polygonCount | n/a | **1** | ✓ correcto | Polygon = 1 por construcción |
| G3 deltaPct | -36.7 | **-36.69** | △ 0.01 más preciso | `(1671.26 - 2640) / 2640 × 100` |
| G4 vertexCount | 77 | **77** | ✓ idéntico | `Σ rings.length sobre 3 polígonos (32+40+5)` |
| G4 polygonCount | 3 | **3** | ✓ idéntico | `coords.length` MultiPolygon |
| G4 deltaPct | -0.38 | **-0.38** | ✓ idéntico | `(2156.70 - 2164.97) / 2164.97 × 100` |

**Única diferencia numérica:** G3 `delta_pct` pasa de -36.7 a -36.69 (un decimal adicional). Convención uniforme · 2 decimales fijos vía `parseFloat(x.toFixed(2))`. **Esta cifra NO se renderiza en UI**, por lo que el cambio es invisible al usuario.

---

## 6 · Verificación grep + syntax check

```
=== Eliminaciones verificadas (código activo) ===
vertices_count en código activo: 0
vertices_total en código activo: 0
polygons_count en código activo: 0
delta_pct hardcoded literal:     0 (sólo aparece en 2 comentarios documentando el fix)

=== Helpers nuevos definidos ===
function vertexCount   (línea 112)
function polygonCount  (línea 125)
function deltaPct      (línea 130)

=== Exports nuevos ===
export { vertexCount, polygonCount, deltaPct }

=== Syntax ===
node --check web/js/map-geometrias.js → OK
```

---

## 7 · Criterio "aspecto visual idéntico"

| Componente | Cambio visual esperado | Observación |
|---|---|---|
| Mapa G1, G2 | Idéntico | Toggle "no disponible" intacto · no usaban campos eliminados |
| Mapa G3 | Idéntico | `_toGeoJSON` produce GeoJSON con misma geometría y propiedades semánticamente equivalentes |
| Mapa G4 | Idéntico | Idem |
| Sub-tab Geometrías cards | Idéntico | El sub-tab no lee de `properties` del GeoJSON · lee de fixture directo (campos no eliminados) |
| Popup MapLibre | Sin cambio (no existe popup activo hoy) | El `properties.delta_pct` y `properties.vertices` no se renderizan en ninguna UI actual |
| Acción `Encuadrar`, `Ocultar`, toggle activación | Idéntico | Estas funciones no usan los campos eliminados |

**Conclusión:** cero diff visual al usuario. Diff invisible: G3 internal `delta_pct` pasa de -36.7 a -36.69 (campo no expuesto en UI hoy).

---

## 8 · Doctrina · audit log PRINCIPIO #2 (segunda aplicación)

Esta es la **segunda aplicación verificada del PRINCIPIO #2 canonizado en SPRINT_HARDENING_01**. Confirma que el principio es operacional preventivamente, no sólo reactivo a bugs visibles.

| Fecha | Sistema | Patrón | Fix | Quién |
|---|---|---|---|---|
| 2026-05-31 (mañana) | Magnus Radar / ITS fixture · H-A1 | `conflictos_abiertos_count` paralelo a `conflictos[]` · violación visible | `countConflictosAbiertos()` única fuente | Max Medina |
| 2026-05-31 (tarde) | Magnus Radar / map-geometrias.js · H-B1 | 4 campos derivables persistidos · deuda silenciosa pre-bug | helpers puros `vertexCount` / `polygonCount` / `deltaPct` | Max Medina |

**Lectura cualitativa:** la auditoría exhaustiva (pos-canonización) detectó 4 sospechas estructurales antes de que se manifestaran como bug visible. Esto valida la disciplina del principio como preventivo, no sólo correctivo. La regla "grep `_count`/`_total`/`_sum` + verificar derivabilidad" funciona como filtro rápido.

---

## 9 · Compromisos mantenidos

- ✅ NO features nuevas
- ✅ NO schema nuevo (cero cambios en SQL)
- ✅ NO conectar Supabase
- ✅ NO UI nueva (cero cambios en `index.html`, cero CSS)
- ✅ NO cambios visuales intencionales (único cambio interno invisible: G3 deltaPct precisión +1 decimal)
- ✅ Verificación física inmediata (md5 + size + lines + grep + syntax + math test)
- ✅ Reportar diff exacto

---

## 10 · Estado consolidado HARDENING

| Sprint | Hallazgos | Estado |
|---|---|---|
| SPRINT_HARDENING_01 | 3 ALTA (H-A1, H-A2, H-A3) | Aplicados · runtime PENDIENTE |
| SPRINT_HARDENING_02 | 4 sospechas (H-B1) | Aplicados · runtime PENDIENTE |
| Backlog técnico (HARDENING_REPORT.md) | 6 MEDIA + 6 BAJA + 5 navegador | Sin tocar |

**Conjunto runtime pendiente:** los mismos 4 puntos PASS/FAIL del HARDENING_01 ahora también cubren H-B1 implícitamente (si G3/G4 se muestran en el mapa correctamente con la nueva derivación, H-B1 está runtime-validado · si rompió `_toGeoJSON`, el toggle G3 o G4 fallaría visualmente).

**Recomendación operativa:** ejecutar el mismo formato runtime PASS/FAIL una sola vez · cubre ambos sprints.

---

## 11 · Lo NO ejecutado (por disciplina · no por capacidad)

- 6 MEDIA + 6 BAJA del `HARDENING_REPORT.md` original (siguen como backlog)
- 5 hallazgos navegador-dependientes (requieren runtime)
- Staging schema 0003 (sigue pendiente · no se desbloquea)
- Auditoría grep equivalente sobre carpetas externas a `magnus-radar/` (ej. otros sistemas Meher OS · aplicación cross-dominio del PRINCIPIO #2)

Ninguno se inicia sin autorización posterior.
