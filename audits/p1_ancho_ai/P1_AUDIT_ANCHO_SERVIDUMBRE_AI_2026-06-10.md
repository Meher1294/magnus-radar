# P1-AUDIT · Ancho efectivo de la servidumbre Andes Iron
### Auditoría geométrica reproducible · 2026-06-10
### Fuente única: `web/v1-h2/geojson/servidumbre_andes_iron.geojson` (37 vértices, 2 polígonos) · proyección de cálculo EPSG:32719 (UTM 19S) · geometrías NO modificadas

---

## Resumen ejecutivo

| Magnitud | Valor | Clasificación |
|---|---|---|
| Superficie total (geométrica) | **181,694 ha** (declarada 181,690 · Δ +0,00 %) | HECHO |
| Longitud de eje · 24-43 (H1) | **2.902 m** (az 69,5°) | HECHO (método documentado) |
| Longitud de eje · 24-123 (H2) | **2.456 m** (az 50,5°) | HECHO (método documentado) |
| Ancho promedio efectivo · H1 | **198,3 m** (área/longitud) · 197,6 m (media de cuerdas) | HECHO |
| Ancho promedio efectivo · H2 | **505,5 m** (área/longitud) · 495,5 m (media de cuerdas) | HECHO |
| Ancho mínimo / máximo · H1 | 3,3* / 279,1 m (*remate de vértice; p10 = 120,9 m) | HECHO |
| Ancho mínimo / máximo · H2 | 70,5 / **725,5 m** | HECHO |
| Forma | **Corredor continuo en abanico**: franja en H1 que se ensancha progresivamente hacia el SO en H2 — NO es faja de ancho constante | HECHO (verificación visual mapas 1–3) |
| Correspondencia plano→GeoJSON | Plano AIPD-01-AI-AIP001 **no disponible** en el árbol del proyecto (búsqueda `*AIPD*` sin resultados) | **NO VERIFICADO / NO_AUDITABLE** |
| Precisión posicional | Sin plano ni puntos de control | **NO VERIFICADO** |

**El dato que cambia la conversación:** la servidumbre solicitada sobre H2 no es una faja lineal — tiene **medio kilómetro de ancho medio** y alcanza 725 m. La única referencia interna previa de ancho (hipótesis EIA, capa 5 f0: 50 m) queda a ~10× del ancho efectivo medio pedido en H2.

---

## Paso 1 · Inventario geométrico (HECHO)

| # | Rol | Predio sirviente | Sup. declarada (ha) | Sup. geométrica (ha) | Δ | Perímetro (m) | BBox UTM (E,N) | Vértices |
|---|---|---|---|---|---|---|---|---|
| f0 | 24-43 | Lote A Hijuela 1 | 57,545 | **57,545** | −0,00 % | 6.026,0 | 281.517–284.351 / 6.734.859–6.735.863 | 17 |
| f1 | 24-123 | Resto Hijuela 2 (Lote 2A) | 124,145 | **124,149** | +0,003 % | 6.153,5 | 279.378–281.877 / 6.733.241–6.734.947 | 20 |
| — | **Total** | | **181,690** | **181,694** | +0,00 % | | extensión total ~5,0 × 2,6 km | 37 |

Longitud máxima (eje mayor OBB): H1 2.947 m · H2 2.652 m. Longitud mínima (lado menor OBB): H1 279 m · H2 734 m.

## Paso 2 · Eje longitudinal (método documentado, no manual)

Método primario: **oriented bounding box** (`shapely.minimum_rotated_rectangle`) → azimut del lado mayor. Verificación cruzada independiente: **PCA** sobre vértices del contorno (eigenvector principal de la covarianza). Resultado: H1 az_OBB 69,53° vs az_PCA 70,36° (Δ 0,8°) · H2 az_OBB 50,52° vs az_PCA 55,41° (Δ 4,9°). Ambos métodos convergen → eje aceptado.

**Limitación declarada:** rectangularidad (área polígono / área OBB) = 0,699 (H1) y 0,638 (H2) — los polígonos NO son rectángulos; el supuesto de eje recto introduce sesgo acotado en la longitud. Por eso el ancho se mide ADEMÁS por distribución de cuerdas (independiente de la longitud del eje) y ambos estimadores convergen (<2 % de diferencia), lo que valida el resultado.

## Paso 3 · Ancho efectivo y distribución (HECHO)

400 estaciones por polígono a lo largo del eje; en cada estación, cuerda perpendicular ∩ polígono = ancho local. Cuerdas efectivas: 381 (H1) · 357 (H2).

| Estadístico | 24-43 (H1) | 24-123 (H2) |
|---|---|---|
| ancho_promedio = superficie/longitud_eje | **198,29 m** | **505,54 m** |
| media de cuerdas | 197,61 m | 495,49 m |
| desviación estándar | 56,25 m | 137,54 m |
| mínimo | 3,32 m (remate) | 70,47 m |
| p10 | 120,87 m | 308,21 m |
| p50 | 191,10 m | 505,73 m |
| p90 | 264,43 m | 680,02 m |
| máximo | 279,09 m | **725,51 m** |
| ancho máximo inscrito (erosión, bisección 40 it.) | 278,6 m | 673,1 m |

La dispersión (σ/μ = 28 % en both) confirma que NO existe "un ancho" único: la afectación crece sistemáticamente de NE (H1) a SO (H2).

## Paso 4 · Auditoría de consistencia (HECHO)

Las cifras **cierran geométricamente de forma exacta**: 57,545 ha y 124,145→124,149 ha reproducen las superficies declaradas con Δ ≤ 0,003 %, y el total 181,694 vs 181,690 ha (Δ +0,002 %). Verificación de coherencia interna: longitud × ancho_promedio = 2.902×198,3 = 57,55 ha ✓ · 2.456×505,5 = 124,15 ha ✓ (identidad por construcción del estimador, reportada como control).

**Inferencia declarada:** la coincidencia a 4 decimales entre GeoJSON y cifras declaradas sugiere que la vectorización fue construida/calibrada contra las superficies del plano AIPD-01 — INFERENCIA (la fidelidad de FORMA y POSICIÓN sigue NO VERIFICADA sin el plano).

## Paso 5 · Verificación visual (sin modificar geometrías)

- `mapa1_eje_longitudinal.png` — ejes OBB sobre ambos polígonos.
- `mapa2_secciones_transversales.png` — 60 cuerdas por polígono: se observa el corredor continuo y el ensanchamiento progresivo.
- `mapa3_etiquetas_ancho.png` — cuerdas p10/p50/p90 etiquetadas con su ancho en metros.

## Paso 6 · Cruce con plano AIPD-01-AI-AIP001

Plano **no disponible** en el árbol del proyecto (búsqueda exhaustiva sin resultados). Datum/escala/ancho explícito del plano: NO VERIFICADOS. Comparación ancho_plano vs ancho_geojson: **NO_AUDITABLE** hasta incorporar el plano al data room (entregable 1 del backlog P1). El estado `auditoria_geometrica: NO_AUDITADA` del GeoJSON permanece correcto y vigente.

## Matriz epistemológica

| Dato | Clasificación |
|---|---|
| Superficie (por polígono y total) | **HECHO** (cálculo UTM 19S reproducible) |
| Longitud de eje | **HECHO** (método OBB documentado + verificación PCA; limitación de rectangularidad declarada) |
| Ancho promedio / mínimo / máximo / percentiles | **HECHO** (cuerdas perpendiculares, N≈380/357) |
| Forma en abanico (no faja constante) | **HECHO** (distribución + mapas) |
| Vectorización calibrada contra superficies del plano | **INFERENCIA** (coincidencia Δ0,00 %) |
| Correspondencia plano→GeoJSON | **NO VERIFICADO · NO_AUDITABLE** (plano ausente) |
| Precisión posicional | **NO VERIFICADO** |

## Lecturas derivadas (aritmética sobre supuestos declarados — NO juicio comercial)

1. Si la afectación sobre H2 tuviera la geometría de faja con el ancho p10 de H1 (120,9 m, dato interno medido) sobre la misma longitud de eje (2.456 m): superficie resultante = **29,7 ha** vs 124,145 ha solicitadas (relación 4,2×). Supuesto declarado: faja uniforme; es aritmética de referencia, no propuesta.
2. La hipótesis interna previa (capa 5 f0, MEMO EIA: ancho 50 m) sobre la longitud H2: 2.456 × 50 m = **12,3 ha** vs 124,145 ha (relación 10,1×). Mismo carácter: referencia documental interna.
3. Qué instalaciones justifican el ancho real es pregunta para el PLANO y la negociación — fuera del alcance geométrico de esta auditoría.

## Reproducibilidad

Insumos: GeoJSON citado · shapely 2.1.2 + pyproj 3.7.1 · EPSG:4326→32719 · OBB + PCA + 400 cuerdas/polígono + erosión por bisección (40 iteraciones). Cualquier tercero técnico con el mismo archivo y método obtiene los mismos valores.

## Prohibiciones — cumplimiento

Sin "parece" ni "aproximadamente" sin cálculo · sin anchos típicos de servidumbres mineras · sin referencias externas (la única comparación de ancho usa el dato INTERNO de capa 5, citado y clasificado) · sin juicio comercial (las lecturas derivadas son aritmética con supuestos explícitos).
