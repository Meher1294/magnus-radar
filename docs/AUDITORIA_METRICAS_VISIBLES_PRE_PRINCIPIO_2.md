# Auditoría · métricas visibles vs PRINCIPIO #2 · pre-runtime

**Fecha:** 2026-05-31
**Tipo:** read-only · inventario clasificado · cero modificaciones
**Disparador:** PRINCIPIO #2 canonizado en SPRINT_HARDENING_01
**Estado del sprint:** HARDENING_01 pendiente de validación runtime · esta auditoría NO bloquea su cierre
**Custodio:** Max Medina

---

## 0 · Alcance

| Carpeta | Archivos auditados | Cobertura |
|---|---|---|
| `web/js/` | 7 archivos (its-bootstrap, its-data, its-grafo-data, its-renderers, map-geometrias, panel-detail, state-badges) | 100% |
| `db/migrations/` | 6 archivos SQL (0001, 0001a, 0001b, 0002, 0002b, 0003) | 100% |
| `scripts/` | 0 archivos (carpeta vacía) | 100% |

**Patrones buscados:** `_count`, `_total`, `_sum`, `_avg`, `_max`, `_min`, `.length`, `.size`, `.reduce`, `.filter().length`, `count(*)`, `sum()`, `badge`, `chip`, contadores en headers/subtítulos visibles.

**Regla aplicada:** un patrón textual ≠ violación. Sólo es violación PRINCIPIO #2 si la métrica está **persistida en paralelo a su conjunto fuente** y **ambos están expuestos como verdad simultáneamente**. Una función pura `f(conjunto) → métrica` evaluada en render time CUMPLE el principio.

---

## 1 · Resumen ejecutivo

| Categoría | Cantidad |
|---|---|
| **Cumple PRINCIPIO #2** (derivación legítima en render/query time) | 28 |
| **Violaciones confirmadas** (cifra duplicada visible al usuario) | 0 |
| **Sospechas a revisar** (cifra persistida derivable, no visible HOY pero deuda silenciosa) | 4 |

**Conclusión preliminar:** el codebase está estructuralmente sano respecto a PRINCIPIO #2 en código activo. El fix H-A1 fue la única violación visible. Las 4 sospechas son deuda silenciosa contenida en `map-geometrias.js` · no requieren fix inmediato pero sí marcadores explícitos `[CACHE_NO_DECLARADO]` o eliminación si no agregan valor.

---

## 2 · Cumple PRINCIPIO #2 (28 casos)

Patrón canónico: `array.filter(...).length`, `array.length` o función pura aplicada en el punto de render. Sin persistencia paralela.

### 2.1 · web/js/its-renderers.js

| ID | Línea | Métrica visible | Fuente | Forma de cálculo |
|---|---|---|---|---|
| C-01 | 71 | `superficies.length === 0` (guard render) | `sups[]` | `.length` en render |
| C-02 | 88, 93 | `${autoridades.length} dominios registrados` | `autoridades[]` | `.length` en render |
| C-03 | 140 | `abiertosCount` header conflictos | `unidad.conflictos[]` | `countConflictosAbiertos()` (H-A1) |
| C-04 | 148–150 | `alta` / `media` / `baja` por severidad | `todos[]` | `filter(severidad).length` |
| C-05 | 222, 229 | `${geoms.length} concurrentes · ${disponibles} con geometría real` | `geoms[]` + `GEOMS_DISPONIBLES` | `length` + `filter().length` |
| C-06 | 275, 280 | `${eventos.length} eventos verificados/localizados` | `eventos[]` | `.length` |
| C-07 | 285, 287 | `${hipotesis.length} hipótesis activa(s)` | `hipotesis[]` | `.length` |
| C-08 | 325, 332 | `${hips.length} explicación(es) útil(es)` | `hips[]` | `.length` |
| C-09 | 409 | `total = tipos.reduce(...)` agregado evidencia | `grupos{}` | `reduce` derivado |
| C-10 | 422 | `${grupos[tipo].length}` por grupo evidencia | `grupos[tipo][]` | `.length` en render |
| C-11 | 481 | `padres.length > 0` (guard) | `padres[]` | `.length` |
| C-12 | 577 | `Padres directos (${padres.length})` | `padres[]` | `.length` |
| C-13 | 589 | `Hijos directos (${hijos.length})` | `hijos[]` | `.length` |
| C-14 | 603 | `${como_origen.length} como origen · ${como_destino.length} como destino` | `relaciones{}` | `.length` |
| C-15 | 614–617 | `totalArtefactos`, `totalRelaciones`, `afectados`, `descalificados` (header grafo) | `data.artefactos[]`, `data.relaciones[]` | `.length` + `filter().length` |
| C-16 | 653 | `${descendientes.length} artefactos vía propagación` | `descendientes[]` (CTE replicado) | `.length` |

### 2.2 · web/js/panel-detail.js

| ID | Línea | Métrica visible | Fuente | Forma de cálculo |
|---|---|---|---|---|
| C-17 | 115 | Badge `Superficies` | `u.superficies[]` | `u.superficies?.length` |
| C-18 | 117 | Badge `Conflictos` | `u.conflictos[]` | `countConflictosAbiertos(u)` (H-A1) |
| C-19 | 120 | Badge `Hipótesis` | `u.hipotesis[]` | `u.hipotesis?.length` |
| C-20 | 176 | Link `Resumen` → "X conflictos abiertos" | `unidad.conflictos[]` | `countConflictosAbiertos(unidad)` |

### 2.3 · web/js/its-data.js

| ID | Línea | Métrica visible | Fuente | Forma de cálculo |
|---|---|---|---|---|
| C-21 | 148 | `countConflictosAbiertos()` export | `unidad.conflictos[]` | función pura filter+length |

### 2.4 · db/migrations/0001_initial_schema.sql + 0001b_schema_rls_views.sql

| ID | Línea | Métrica visible | Fuente | Forma de cálculo |
|---|---|---|---|---|
| C-22 | 268–272 / 91–95 | `predios_total`, `superficie_total_ha`, `proyectos_seia`, `inversion_seia_usd_m`, `eventos_mes` | tablas `predios`, `proyectos_seia`, `eventos` | view SQL · `count(*)` / `sum()` en query time |

### 2.5 · db/migrations/0002_its_schema.sql

| ID | Línea | Métrica visible | Fuente | Forma de cálculo |
|---|---|---|---|---|
| C-23 | 427 | `n_geometrias` | `its.representaciones_geometricas` | view · `count(*)` query time |
| C-24 | 428 | `n_superficies` | `its.superficies` | view · `count(*)` query time |
| C-25 | 429 | `n_autoridades` | `its.autoridades` | view · `count(*)` query time |
| C-26 | 430 | `n_hipotesis` | `its.hipotesis` | view · `count(*)` query time |
| C-27 | 431 | `n_conflictos_abiertos` | `its.conflictos WHERE estado=conflicto_documentado` | view · `count(*)` query time |
| C-28 | 432, 433 | `n_eventos_registrales`, `n_titulares` | `its.cadena_registral`, `its.unidades_titulares` | view · `count(*)` query time |

### 2.6 · db/migrations/0003_artefactos_grafo.sql

| ID | Línea | Métrica visible | Fuente | Forma de cálculo |
|---|---|---|---|---|
| C-29 | 343–355 | `artefactos_totales`, `raices_sin_padre`, `hojas_sin_hijo`, `huerfanos_aislados`, `afectados_propagacion`, `descalificados`, `aristas_totales` | `its.artefactos`, `its.relaciones_artefactos` | view `grafo_artefactos_resumen` · todas son `count(*) FILTER (...)` query time |

**Observación general SQL:** todas las vistas usan `CREATE OR REPLACE VIEW`, ninguna es `MATERIALIZED VIEW`, ninguna tabla persiste columnas `_count` / `_total` / `_sum` / `_avg` físicas. Esto cumple PRINCIPIO #2 por construcción.

---

## 3 · Violaciones confirmadas (0 casos)

**Cero.** No hay ninguna cifra persistida en paralelo a su conjunto fuente que sea visible al usuario en este momento. La única violación visible que existió (H-A1 · `conflictos_abiertos_count: 13`) fue resuelta en SPRINT_HARDENING_01.

---

## 4 · Sospechas a revisar (4 casos · deuda silenciosa)

Cifras persistidas en fixture, **derivables matemáticamente de otro dato presente en el mismo objeto**. **NO se muestran al usuario HOY** (sin popup MapLibre, sin tooltip, sin render en sub-tab Geometrías). Por eso no son violaciones visibles. Pero son la misma clase estructural que H-A1 antes de manifestarse: si en el futuro alguien edita las `coords` sin actualizar el contador, el bug aparece silenciosamente.

| ID | Archivo | Línea | Métrica persistida | Derivable de | Verificación matemática |
|---|---|---|---|---|---|
| S-01 | `web/js/map-geometrias.js` | 58 | `vertices_count: 26` (G3 Polygon) | `coords[0].length` | ✓ Confirmado: `coords[0].length = 26` (calculado con node) |
| S-02 | `web/js/map-geometrias.js` | 72 | `polygons_count: 3` (G4 MultiPolygon) | `coords.length` | ✓ El bloque coords tiene 3 sub-arrays de polígonos |
| S-03 | `web/js/map-geometrias.js` | 73 | `vertices_total: 77` (G4) | `Σ coords[i].length` | ✓ Coincide con la suma de vértices de los 3 polígonos |
| S-04 | `web/js/map-geometrias.js` | 57, 76 | `delta_pct: -36.7` (G3) y `delta_pct: -0.38` (G4) | `(superficie_calculada_ha − superficie_declarada_ha) / declarada × 100` | ✓ G3: `(1671.26-2640)/2640 = -36.69%` ≈ -36.7 · G4: `(2156.70-2164.97)/2164.97 = -0.382%` ≈ -0.38 |

### 4.1 · ¿Por qué son SOSPECHA y no VIOLACIÓN?

`map-geometrias.js` inyecta estos campos en `_toGeoJSON` (líneas 112–115) como `properties` del Feature. MapLibre los recibe pero **ningún handler de popup / tooltip / sub-tab los lee y los muestra al usuario** (grep exhaustivo en `web/js/` y `web/index.html` confirmó cero render activo).

Mientras esto siga así, son **datos internos del módulo**, no métricas visibles. PRINCIPIO #2 aplica a métricas **visibles**.

### 4.2 · ¿Por qué documentarlas como sospecha y no ignorarlas?

Tres razones:

1. **Probabilidad alta de ascenso a violación.** El sub-tab Geometrías ya muestra estado, fuente, año, superficie. Si en una iteración futura se agrega "26 vértices" al card de G3 leyéndolo desde `properties.vertices`, sin recalcular desde coords, repetimos exactamente el patrón H-A1.
2. **`delta_pct` ya tiene un hermano homónimo visible.** En `index.html:3487` la función `renderReconciliacionTabla` lee `rec.delta_pct` (de tabla `reconciliacion_dual_*` backend) y lo muestra al usuario. Ese caso SQL es legítimo (delta entre dos catastros, calculado server-side al cargar). Pero genera colisión semántica: hay dos `delta_pct` en el codebase con orígenes distintos. Riesgo de copy-paste futuro.
3. **Costo de remediación cuasi-cero.** Son 4 líneas de fixture. Reemplazarlas por funciones puras (`getVerticesCount(g)`, `getDeltaPct(g)`) o eliminarlas del fixture y calcular siempre en `_toGeoJSON` desde `coords` toma minutos.

### 4.3 · Recomendación (NO ejecutar sin autorización)

Opción A · **marcar como cache no declarado**: agregar comentario `// [CACHE_NO_DECLARADO] derivable de coords · mantener sincronizado manualmente` al lado de cada uno. Sin cambio funcional. Bajo costo, baja garantía.

Opción B · **convertir a derivación pura**: eliminar los 4 campos del fixture, agregar helpers `vertexCount(g)`, `polygonCount(g)`, `deltaPct(g)` en `map-geometrias.js`, usar en `_toGeoJSON`. Costo: ~20 líneas. Garantía estructural completa.

Opción C · **eliminar si no se usan**: si confirmado que `properties.vertices` / `properties.delta_pct` nunca llegarán a un popup, simplemente removerlos del objeto inyectado. Más radical pero más limpio. Riesgo: si un consumer externo los espera, rompe contrato silencioso.

Mi recomendación si se ejecuta cierre: **opción B**. Es exactamente la disciplina H-A1 aplicada preventivamente.

---

## 5 · Patrones que NO son violación pero merecen mención

### 5.1 · `superficie_declarada_ha` vs `superficie_calculada_ha`

Coexisten en el mismo objeto G1–G4 (`map-geometrias.js`). **No es violación.** Son dos métricas semánticamente distintas:
- `superficie_declarada_ha`: cifra que el documento de origen (KMZ, plano, escritura) declara. Es **primitiva**, viene de la fuente externa. No derivable de coords.
- `superficie_calculada_ha`: cifra que el polígono cubre geométricamente cuando se proyecta a un sistema métrico. Derivada del polígono pero almacenada por costo de cómputo y porque depende de la proyección elegida (sería un `cache_` legítimo si se quiere ser estricto).

La coexistencia es **el punto** del módulo: comparar declarado vs calculado es la base de `delta_pct` y del conflicto `KMZ_LABEL_VS_POLY_MISMATCH`. No tocar.

### 5.2 · Fixtures con valores numéricos por registro

Múltiples superficies en `its-data.js` (líneas 18, 48–52, 82–85, 89–97) tienen valores tipo `valor_ha: 2642.00`, `año: 1990`, etc. **No es violación.** Son datos primitivos del registro, no derivaciones agregadas. Cada valor representa un hecho independiente del fixture. Si en el futuro se construye un agregado tipo "promedio de superficies declaradas", ese agregado debe ser función pura, no campo nuevo.

### 5.3 · `confidence_ia` por artefacto

En `its-grafo-data.js` líneas 88, 92: `confidence_ia: 35`. Es **primitiva por artefacto** (la IA emitió un score sobre ese artefacto específico). No es agregado, no es derivable de otro dato del objeto. Cumple por construcción.

---

## 6 · Sobre `scripts/`

Carpeta presente pero vacía. Cero hallazgos. Si se agregan scripts de seed/migration/import futuros, el principio aplica.

---

## 7 · Salida final clasificada (YAML completo)

```yaml
cumple_principio_2:
  count: 28
  ubicacion:
    web_js_its_renderers:   16 casos
    web_js_panel_detail:     4 casos
    web_js_its_data:         1 caso (helper H-A1)
    db_migrations:           7 casos (vistas SQL · cero materialized · cero columnas físicas)
  patron: array.length / filter().length / reduce / count(*) / sum() en render o query time
  riesgo: cero

violaciones_confirmadas:
  count: 0
  detalle: ninguna cifra duplicada visible al usuario hoy
  nota: la única violación visible histórica (H-A1) fue resuelta en SPRINT_HARDENING_01

sospechas_a_revisar:
  count: 4
  ubicacion: web/js/map-geometrias.js · líneas 57, 58, 72, 73, 76
  campos:
    - vertices_count G3   # derivable coords[0].length = 26
    - polygons_count G4   # derivable coords.length = 3
    - vertices_total G4   # derivable Σ coords[i].length = 77
    - delta_pct G3 + G4   # derivable (calculada - declarada) / declarada
  visibilidad_actual: no se renderiza al usuario · grep negativo en web/js + index.html
  riesgo_actual: deuda silenciosa · mismo patrón H-A1 antes de manifestarse
  recomendacion: opcion_B (convertir a derivación pura) si se autoriza SPRINT_HARDENING_02
  bloquea_cierre_HARDENING_01: no
```

---

## 8 · Decisión propuesta

| Hallazgo | Acción |
|---|---|
| Cero violaciones confirmadas | No se requiere SPRINT_HARDENING_02 obligatorio |
| 4 sospechas en `map-geometrias.js` | Decisión del Custodio · 3 opciones (marcar / derivar / eliminar) |
| Estado runtime HARDENING_01 | Sigue pendiente · esta auditoría no lo bloquea |

**Si Max valida runtime PASS y decide cerrar:** sistema queda **sin violaciones visibles de PRINCIPIO #2**. Las 4 sospechas se anotan en backlog técnico para iteración futura · no son crítico.

**Si Max valida runtime PASS y autoriza limpieza preventiva:** abrir SPRINT_HARDENING_02 con alcance único `web/js/map-geometrias.js` opción B · ~20 líneas · cero impacto visual · cero riesgo runtime · ~30 minutos de trabajo.
