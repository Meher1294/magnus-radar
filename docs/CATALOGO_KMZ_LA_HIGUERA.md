# Catálogo KMZ · La Higuera · arqueo 2026-05-31

**Tipo:** read-only · auditoría documental · Carril B+C (sin tocar Magnus Radar)
**Disparador:** Max corrigió "parálisis por disciplina" · avanzar trabajo paralelo independiente del runtime pendiente de HARDENING_01/02
**Cobertura:** 12 KMZ identificados en 4 carpetas mount · 8 únicos por contenido
**Método:** descompresión + parsing XML + cálculo Shoelace equirectangular + comparación etiqueta vs polígono real

---

## 1 · Resumen ejecutivo

| Categoría | Hallazgo |
|---|---|
| Duplicados bit-idénticos | **4 copias** del mismo `DataRoom_Cominetti_LaHiguera.kmz` (incluyendo el supuesto "_v2") |
| Pares casi-idénticos | `traslapo kmz` vs `traslapo kmz - corregido`: doc.kml idéntico · diferencia única es 1 tile imagen `c01/f13022.png` |
| Catastro SII candidato | KMZ-06 y KMZ-09 (7.687 placemarks c/u) · contenidos DISTINTOS · probables versiones del catastro completo |
| Nuevo conflicto detectado | **Franja servidumbre InterChile** · declarado 20.8 ha vs calculado 18.12 ha · delta **-12.9%** · mismo patrón que `KMZ_LABEL_VS_POLY_MISMATCH` |
| Re-cálculo G3 H2 | 1.683.03 ha (este arqueo) vs 1.671.26 ha (fixture v0.3) · diferencia 11.8 ha · misma magnitud, distinto Shoelace |
| Candidatos para G5+ | Franja InterChile, 8 torres T281-T288, vértices C1-C26 H2 |
| Roles SII "fantasma" 0-0 | **335 ocurrencias** sólo del par 0-0 en KMZ-09 · confirma el patrón `ROL_0_0_FALLBACK` ya registrado |

---

## 2 · Inventario completo

### 2.1 · Tabla maestra

| ID | Archivo | Carpeta | Tamaño | md5 | Tipo principal | Placemarks | Overlays | Estado arqueo |
|---|---|---|---|---|---|---|---|---|
| **KMZ-00** | DataRoom_Cominetti_LaHiguera.kmz | 04_PLANOS_CATASTRO | 4 KB | `1b777c...` | vector mixto (50 PM) | 50 | 0 | **canónico** (origen G3 Fase 7A) |
| KMZ-00-dup1 | DataRoom_Cominetti_LaHiguera.kmz | 11_PLANIMETRIA_DWG | 4 KB | `1b777c...` (=) | — | — | — | **duplicado exacto** |
| KMZ-00-dup2 | DataRoom_Cominetti_LaHiguera_v2.kmz | 11_PLANIMETRIA_DWG | 4 KB | `1b777c...` (=) | — | — | — | **duplicado exacto · nombre "_v2" engañoso** |
| KMZ-00-dup3 | DataRoom_Cominetti_LaHiguera.kmz | _OPERATIVO_INTERNO/_DUPLICADOS_REVISAR | 4 KB | `1b777c...` (=) | — | — | — | **duplicado exacto** (ya marcado revisión) |
| KMZ-01 | ContornoTotal_Mar2022.kmz | 01_LEGAL_TITULOS/.../ | 3 KB | `97b6d4...` | LineString | 1 | 0 | trazado 207 vertices · sin nombre · "UNKNOWN_LINE_TYPE" |
| KMZ-03 | actualisacion cominetti.kmz | 11_PLANIMETRIA_DWG | 1.8 KB | `31c11d...` | LineString | 1 | 0 | "Medición de la ruta" · 71 vertices |
| KMZ-04 | la higuera y sus poligonos.kmz | 11_PLANIMETRIA_DWG | 638 B | `6288ab...` | LineString | 1 | 0 | **engañoso**: nombre dice "poligonos", contenido es 1 línea de 2 puntos |
| KMZ-05 | la higuera.kmz | 11_PLANIMETRIA_DWG | **368 MB** | `18f3b5...` | raster mosaico | 0 | **1.059** | ortofotografía teselada · sin vectores |
| KMZ-06 | La_Higuera_UTF8.kmz | 17_MESA_ANDES_IRON_2026 | 1.37 MB | `2db502...` | catastro SII | **7.687** | 0 | doc.kml md5 `d44b27...` |
| KMZ-07 | traslapo kmz - corregido.kmz | Fotos Cominetti | 163 MB | `baaae8...` | raster overlay | 0 | **1.160** | doc.kml id idem KMZ-08 |
| KMZ-08 | traslapo kmz.kmz | Fotos Cominetti | 163 MB | `c95bc6...` | raster overlay | 0 | **1.160** | difiere de KMZ-07 en 1 tile (f13022.png) |
| KMZ-09 | La Higuera (1).KMZ | La Higuera2 (otro mount) | 1.37 MB | `140cd8...` | catastro SII | **7.687** | 0 | doc.kml md5 `a8508c...` ≠ KMZ-06 |

### 2.2 · Reducción por contenido

| Bucket | Archivos físicos | Únicos por contenido | Comentario |
|---|---|---|---|
| DataRoom canónico (G3) | 4 | **1** | fuente original Fase 7A |
| Catastro SII | 2 | **2** distintos | KMZ-06 y KMZ-09 · contenidos divergentes pese a mismo conteo |
| Raster ortofoto base | 1 | **1** | KMZ-05 · sin vectores · uso potencial: imagen base mapa |
| Raster traslapo | 2 | **~1** | doc.kml idéntico · diff sólo 1 tile imagen |
| Líneas auxiliares | 3 | **3** | KMZ-01, KMZ-03, KMZ-04 · contenido escaso · baja prioridad |

---

## 3 · Análisis detallado del KMZ-00 (DataRoom canónico)

Sólo G3 (polígono Hijuela 2) fue extraído en Fase 7A. El KMZ contiene **50 placemarks**, no 1.

### 3.1 · Capas detectadas

| # | Tipo | Nombre | Geometría | Notas |
|---|---|---|---|---|
| 1 | Polígono | Polígono Hijuela 2 Cominetti | 26 vertices · 1683.03 ha | YA cargado como G3 (fixture: 1671.26 ha) |
| 2–27 | Puntos | C-1 a C-26 (uno faltante) | 26 vértices nombrados | mismos vértices del polígono Hijuela 2 etiquetados |
| 28 | Polígono | **Franja de servidumbre eléctrica** | 17 vertices · 18.12 ha | **NUEVO · no cargado** |
| 29–36 | Puntos | T281 a T288 | 8 torres InterChile | **NUEVO · no cargado** |
| 37–50 | (otros) | varios | varios | placemarks adicionales (no exhaustivo en este pase) |

### 3.2 · Hallazgos diagnósticos

**NUEVO conflicto detectado:**
```
INTERCHILE_LABEL_VS_POLY_MISMATCH
  declarado:  20.8 ha  (Franja servidumbre 20.8 ha · descripción placemark)
  calculado:  18.12 ha (Shoelace equirectangular)
  delta:      -12.9 %
  severidad:  media (>5 % de tolerancia · misma clase que KMZ_LABEL_VS_POLY_MISMATCH H2)
  fuente:     KMZ-00 placemark "Franja de servidumbre eléctrica"
```

**Re-cálculo G3 vs fixture v0.3:**
```
G3 superficie_calculada_ha en fixture:   1671.26
G3 superficie recalculada en este arqueo: 1683.03
delta entre cálculos:                      +0.70 % (11.77 ha)
explicación probable:                      distinto algoritmo Shoelace
                                          (Python equirectangular vs JS turf u otro)
implicación:                              NO contradicción semántica
                                          (ambos confirman delta ~−36 % vs declarado)
acción recomendada (futura):              canonizar UN solo Shoelace para todo el proyecto
```

**Metadata rica adicional en placemark Hijuela 2:**
- Roles SII: **24-123 y 24-160** (NO sólo 24-123 como tiene la fixture)
- Propietarias enumeradas: Silvana, Fabiana, Uberlinda Cominetti Palini + Agrícola Cantera SpA
- Esto **debería incorporarse** a `its-data.js` cuando se autorice próxima iteración

**Metadata franja InterChile (sin equivalente en fixture):**
- Línea: Maitencillo–Pan de Azúcar 2x500kV
- Titular: InterChile S.A.
- PES 020 (Rol 24-4, torres T281-T284) + PES 021 (Rol 24-48, torres T285-T288)

---

## 4 · Análisis del catastro SII (KMZ-06 y KMZ-09)

**Patrón observado:** ambos archivos tienen 7.687 placemarks con polígonos georreferenciados de roles SII de la comuna 4102 (La Higuera). Contenidos del `doc.kml` distintos (md5 ≠).

### 4.1 · Estadísticas KMZ-09 (representativo)

| Métrica | Valor |
|---|---|
| Placemarks totales | 7.687 |
| Roles únicos (por nombre) | 6.629 |
| **Duplicados por nombre** | **1.058** |
| Rol `0-0` (sin asignación SII) | **335 ocurrencias** ← confirma patrón ROL_0_0_FALLBACK |
| Otros top duplicados | `66-0` (92), `67-0` (65), `49-24` (62), `33-469` (52) |
| Polígono más grande | un `0-0` con 527 vértices · 735.29 ha |

### 4.2 · Vínculo con Supabase

Magnus Radar ya cargó **7.686 predios SII** a Supabase (tarea #23). Diferencia respecto al KMZ: 1 placemark (probable duplicado adicional · 7.687 − 7.686 = 1). **Alta probabilidad de que KMZ-06 o KMZ-09 sea la fuente real** del catastro Supabase actual. Validación pendiente (no ejecutada · requiere consulta a Supabase).

### 4.3 · Pregunta abierta

¿Cuál de los dos es la versión vigente? Posibles hipótesis:
- KMZ-06 (Andes Iron 17.4) = versión negociada/auditada con Andes Iron
- KMZ-09 (La Higuera2) = versión interna/canónica
- Diferencia en md5 doc.kml puede ser: ordering, edición manual, coordenadas afinadas, atributos enriquecidos

Resolución requiere diff línea-por-línea de los dos doc.kml. **No ejecutado en este pase.** Recomendado para próximo arqueo.

---

## 5 · Recomendaciones operacionales

### 5.1 · Para data-room-governance (acción documental · cero riesgo runtime)

| Acción | Prioridad | Detalle |
|---|---|---|
| Consolidar duplicados DataRoom | alta | 4 copias bit-idénticas · dejar 1 canónica en `04_PLANOS_CATASTRO/` · resto archivar como link simbólico o anotar como `superseded` |
| Renombrar "_v2" engañoso | alta | El archivo `DataRoom_Cominetti_LaHiguera_v2.kmz` NO es v2 · es idéntico al v1 · genera ruido y confusión versionar incorrectamente |
| Renombrar KMZ-04 engañoso | media | `la higuera y sus poligonos.kmz` contiene 1 línea trivial, no polígonos |
| Anotar KMZ-07 vs KMZ-08 | baja | doc.kml idéntico · diff es 1 tile imagen menor · marcar uno como canónico |
| Comparar KMZ-06 vs KMZ-09 | media | Pendiente diff línea-por-línea · decidir cuál es canónico para catastro |

### 5.2 · Para modelo ITS (sin tocar Magnus Radar todavía)

Candidatos para próxima iteración del fixture/schema 0003:

**Nuevos artefactos detectados:**
- `A-FRANJA-INTERCHILE-MAITENCILLO-PA` · Polygon 17 vertices · 18.12 ha
  - Relaciones: `comparada_contra → A-ROL-24-4` y `→ A-ROL-24-48`
  - Tipo: servidumbre eléctrica
  - Fuente: KMZ-00 placemark "Franja de servidumbre eléctrica"
- `A-TORRES-INTERCHILE-T281-T288` · MultiPoint 8 torres
  - Relaciones: `parte_de → A-FRANJA-INTERCHILE`
- `A-VERTICES-H2-C1-C26` · MultiPoint 26 vértices del polígono Hijuela 2
  - Relaciones: `parte_de → G3_H2`

**Nuevos conflictos detectados:**
- `INTERCHILE_LABEL_VS_POLY_MISMATCH` · severidad media · delta -12.9 %
  - Patrón estructural idéntico a `KMZ_LABEL_VS_POLY_MISMATCH` (Hijuela 2 H2)
  - **Si el KMZ canónico exhibe el mismo defecto en 2 polígonos distintos**, la hipótesis "error de etiquetado puntual" se debilita y emerge sospecha de **error sistemático del editor/exportador KMZ**

**Nueva metadata para artefactos existentes:**
- Hijuela 2 tiene 2 roles SII: 24-123 **y 24-160** (la fixture sólo registra 24-123)
- Propietarias enumeradas: 3 hermanas + 1 SpA (vs cifra genérica actual)

### 5.3 · Para el roadmap Magnus Radar (post-PASS runtime)

Sin tocar nada ahora · sólo dejar registrado:

| Candidato | Origen del dato | Valor |
|---|---|---|
| G5_franja_interchile | KMZ-00 capa 28 | añade servidumbre como geometría visualizable |
| G6_torres_interchile | KMZ-00 capas 29-36 | 8 puntos para overlay |
| G7_vertices_h2 | KMZ-00 capas 2-27 | vértices del polígono nombrados (diagnóstico) |
| Capa ortofoto base | KMZ-05 (368 MB · 1.059 tiles) | imagen aérea real bajo el mapa vectorial |
| Capa traslapo overlay | KMZ-07 o KMZ-08 (~1.160 tiles) | overlay diagnóstico de traslapo |

Ninguno se ejecuta sin PASS runtime + autorización explícita.

---

## 6 · Detección automática del patrón KMZ_LABEL_VS_POLY_MISMATCH

| KMZ origen | Placemark | Declarado (ha) | Calculado (ha) | Delta % | Conflicto |
|---|---|---|---|---|---|
| KMZ-00 | Polígono Hijuela 2 Cominetti | 2.640 | 1.683 | **-36.2** | ya conocido (`KMZ_LABEL_VS_POLY_MISMATCH`) |
| KMZ-00 | Franja servidumbre InterChile | 20.8 | 18.12 | **-12.9** | **NUEVO** (`INTERCHILE_LABEL_VS_POLY_MISMATCH`) |

**Total detectado en este arqueo: 2 conflictos del mismo patrón** dentro del mismo archivo canónico. Probabilidad alta de que más KMZ contengan el mismo defecto · este arqueo cubrió sólo los 8 únicos · arqueo iterativo de los catastros SII (KMZ-06/09 · 7.687 placemarks cada uno) requeriría procesamiento masivo no ejecutado.

---

## 7 · Lo que NO se hizo en este pase (queda para próximo arqueo)

- Diff línea-por-línea de los 2 doc.kml de KMZ-06 vs KMZ-09 (decidir versión canónica catastro)
- Validación de cuál KMZ es la fuente real del catastro Supabase ya cargado
- Procesamiento masivo de los 7.687 placemarks SII buscando más mismatches sup. declarada vs calculada
- Lectura del placemark 37–50 restantes del KMZ-00 (cobertura parcial · top 30 reportados)
- Extracción metadata de los 2.219 + 1.160 tiles raster (KMZ-05/07/08) · sólo conteo confirmado
- Diff visual de los 8 KML del catastro vs la geometría del polígono Hijuela 2 (¿el predio aparece en el catastro municipal?)
- Cruce de los 50 placemarks del KMZ-00 con el grafo de artefactos 0003 (cuáles ya están, cuáles no)

---

## 8 · Conclusión operacional

**Carril B+C entregó valor inmediato sin tocar Magnus Radar:**

1. ✓ Confirmación de 4 copias bit-idénticas de DataRoom → input para data-room-governance
2. ✓ Descubrimiento de un **nuevo conflicto del mismo patrón** (INTERCHILE_LABEL_VS_POLY_MISMATCH) → input para schema 0003
3. ✓ Identificación de **4 nuevos artefactos candidatos** (franja + torres + vértices) → input para grafo
4. ✓ Identificación de **metadata adicional para Hijuela 2** (rol 24-160 olvidado) → input para fixture
5. ✓ Patrón ROL_0_0_FALLBACK confirmado empíricamente (335 ocurrencias en KMZ-09) → confirma issue existente
6. ✓ Inventario completo del corpus KMZ pendiente para próximas iteraciones

**Lo que sigue dependiendo del runtime PASS de Magnus Radar v0.3:**
- Cerrar HARDENING_01/02
- Promover a `magnus_v0_3 = estable_local_fixture`
- Decidir siguiente bloque (staging 0003 vs continuar arqueo PDF/DWG)

**Lo que puede avanzar mientras esperamos el PASS:**
- Arqueo de los 70 DWG/DXF
- Triage de los 1.826 PDF (identificar "altos": planos catastrales, escrituras, dictámenes)
- Diff KMZ-06 vs KMZ-09 para decidir versión catastral canónica
- Comparación cruzada de los 24 GPKG ya arqueados contra estos 8 KMZ (matriz de cobertura)

Si autorizas, sigo con cualquiera de los 4 anteriores.
