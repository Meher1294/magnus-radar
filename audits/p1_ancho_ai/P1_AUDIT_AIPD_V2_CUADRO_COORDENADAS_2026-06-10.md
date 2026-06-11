# P1-AUDIT-AIPD v2 · Cuadro de coordenadas oficial vs GeoJSON
### 2026-06-10 · autoridad geométrica primaria: Cuadro de Coordenadas UTM Perímetro Servidumbre (fotografía del plano, 29 puntos)

---

## Respuesta a la pregunta crítica de P1

> ¿El GeoJSON de Magnus Radar es realmente el mismo polígono que define el cuadro de coordenadas del plano?

**SÍ — para el rol 24-123 (H2), con identidad exacta:** Hausdorff **0,00 m** · IoU **100,00 %** · Δ área **0,000 %** · distancia de centroides **0,00 m** · 29 = 29 vértices. El GeoJSON no es una digitalización gráfica del plano: **fue construido directamente desde este cuadro de coordenadas**, vértice por vértice. **VEREDICTO: COINCIDE** (supera el umbral más estricto).

El rol 24-43 (H1) queda **PENDIENTE**: su cuadro no está capturado en la fotografía (se ven fragmentos de otros cuadros en el plano).

---

## Paso 1 · Digitalización (29/29 puntos legibles · ninguno NO_LEGIBLE)

| Pt | Norte (m) | Este (m) | Pt | Norte (m) | Este (m) |
|---|---|---|---|---|---|
| 1 | 6.734.947,30 | 281.516,65 | 16 | 6.733.478,12 | 279.608,93 |
| 2 | 6.734.859,03 | 281.877,35 | 17 | 6.733.498,65 | 279.580,35 |
| 3 | 6.734.256,62 | 280.926,77 | 18 | 6.733.553,43 | 279.540,31 |
| 4 | 6.733.240,70 | 279.912,67 | 19 | 6.733.578,07 | 279.511,78 |
| 5 | 6.733.267,51 | 279.880,86 | 20 | 6.733.592,60 | 279.489,78 |
| 6 | 6.733.293,95 | 279.858,24 | 21 | 6.733.610,71 | 279.469,24 |
| 7 | 6.733.319,73 | 279.844,18 | 22 | 6.733.638,13 | 279.454,39 |
| 8 | 6.733.347,71 | 279.821,47 | 23 | 6.733.650,17 | 279.445,49 |
| 9 | 6.733.355,93 | 279.810,79 | 24 | 6.733.671,44 | 279.434,64 |
| 10 | 6.733.386,94 | 279.741,45 | 25 | 6.733.692,73 | 279.416,34 |
| 11 | 6.733.409,00 | 279.710,89 | 26 | 6.733.704,46 | 279.410,57 |
| 12 | 6.733.416,43 | 279.695,95 | 27 | 6.733.712,21 | 279.402,91 |
| 13 | 6.733.422,94 | 279.677,34 | 28 | 6.733.750,89 | 279.377,94 |
| 14 | 6.733.436,62 | 279.655,52 | 29 | 6.734.564,89 | 280.563,71 |
| 15 | 6.733.458,75 | 279.627,53 | | | |

**Control de calidad de la transcripción:** la identidad Hausdorff = 0,00 m contra el GeoJSON auto-valida los 29 puntos — un solo dígito mal transcrito habría producido distancia ≠ 0.

## Paso 2 · Datum / proyección / huso / hemisferio

Visible en el cuadro: solo "COORDENADAS UTM". **Datum nominal del plano: NO_VERIFICADO** (la fotografía no captura la viñeta; no se asume WGS84). Por contexto territorial (La Higuera, E≈280.000 / N≈6.733.000-6.735.000): **huso 19, hemisferio sur** — HECHO contextual. Evidencia adicional: el cuadro coincide al centímetro con el GeoJSON interpretado en EPSG:32719 → consistencia interna total del par cuadro↔GeoJSON en ese marco; la confirmación del datum nominal (SIRGAS/WGS84 vs PSAD56) requiere la viñeta del plano — pendiente del entregable 1 del P1 (plano completo al data room).

## Paso 3 · Polígono oficial reconstruido (HECHO_DERIVADO)

| Magnitud | Valor |
|---|---|
| Superficie | **1.241.486,2 m² = 124,149 ha** (declarada en plano/GeoJSON: 124,145) |
| Perímetro | 6.153,5 m |
| Centroide | E 280.452,46 · N 6.734.124,98 |
| Validez | polígono simple y válido (orden 1→29, anillo cerrado) |

## Paso 4 · Comparación contra `servidumbre_andes_iron.geojson`

| Métrica | vs rol 24-123 | vs rol 24-43 (control negativo) |
|---|---|---|
| area_plano / area_geojson | 124,149 / 124,149 ha | 124,149 / 57,545 ha |
| delta_area_pct | **+0,000 %** | −53,6 % |
| distancia_centroides_m | **0,00** | 2.684,1 |
| intersección/área_plano · IoU | **100,00 % · 100,00 %** | 0 % · 0 % |
| hausdorff_distance_m | **0,00** | 2.640,1 |
| vértices | **29 = 29** | 29 vs 6 |

## Paso 5 · Veredicto (umbrales explícitos)

Umbrales definidos para esta auditoría: **COINCIDE** = Δárea ≤ 0,5 % ∧ centroides ≤ 5 m ∧ IoU ≥ 99 % ∧ Hausdorff ≤ 10 m · **COINCIDE_CON_DESFASE** = IoU ≥ 90 % con desfase sistemático ≤ 50 m · **NO_COINCIDE** = resto.

**Rol 24-123: COINCIDE** (identidad exacta, todos los umbrales superados por margen infinito). **Rol 24-43: NO_AUDITABLE** con esta fotografía.

## Paso 6 · Métricas de ancho sobre el polígono oficial

Dado que el polígono oficial ES el GeoJSON (identidad), las métricas de P1-AUDIT v1 quedan **revalidadas sobre la autoridad primaria** sin recálculo divergente: eje 2.456 m (az 50,5°, OBB+PCA) · **ancho promedio efectivo 505,5 m** · p10 308,2 / p50 505,7 / p90 680,0 · mín 70,5 / máx 725,5 m · forma en abanico. Estas cifras describen ahora, con respaldo documental directo, **lo que el plano de Andes Iron solicita sobre H2**.

## Matriz epistemológica actualizada

| Dato | v1 | **v2** |
|---|---|---|
| Cuadro de coordenadas UTM (29 pts) | — | **HECHO_DOCUMENTAL** |
| Polígono reconstruido | — | **HECHO_DERIVADO** |
| Correspondencia plano→GeoJSON (24-123) | NO VERIFICADO | **HECHO · VALIDADO** |
| Correspondencia (24-43) | NO VERIFICADO | NO_AUDITABLE (cuadro no capturado) |
| Vectorización construida desde el cuadro | INFERENCIA | **HECHO** (identidad vértice a vértice) |
| Datum nominal del plano | NO VERIFICADO | NO_VERIFICADO (viñeta pendiente) |
| Ancho promedio / distribución (24-123) | HECHO sobre GeoJSON | **HECHO sobre autoridad primaria** |
| Ancho oficial definido expresamente por el plano | — | **NO_DEMOSTRADO** (el cuadro define vértices, no un ancho; si la viñeta declara un ancho, está pendiente de captura) |

## Efectos

1. `metadata.auditoria_geometrica` del GeoJSON actualizada: `PARCIALMENTE_VALIDADA` — 24-123 VALIDADO con fuente y métricas; 24-43 pendiente (hash geométrico invariante `4f25bc0a`).
2. El P1 del backlog avanza: ya no se necesita auditar el MÉTODO de vectorización del 24-123 (fue transcripción del cuadro). Quedan: cuadro del 24-43, viñeta (datum + eventual ancho declarado), y plano completo al data room.
3. Las cifras de ancho (505 m medio, 726 máx sobre H2) pasan a ser **defendibles ante tercero técnico con respaldo documental directo**.
