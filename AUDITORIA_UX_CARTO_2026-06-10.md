# UX-CARTO-01..05 — Auditoría Cartográfica Magnus Radar
### 2026-06-10 · contra la gramática C1–C5 (instrucción UX-CARTO-01) · SIN implementación
### Fuente: parámetros reales de `addH2GeojsonLayer` + capas comuna + basemaps (trazado de código, no estimación)

---

## 0. Diagnóstico en una línea

Hoy la jerarquía visual la carga **solo el color**: todas las capas fill comparten `fill-opacity 0.22 / stroke 2 px`, las líneas `3 px dash`, los puntos `radio 8 px fijo`, y **ninguna capa H2 tiene gating por escala**. Es exactamente el anti-patrón "un color por capa": el activo, las afectaciones, el contexto y lo histórico pesan igual; la lectura de 5 segundos depende de la leyenda. La gramática C1–C5 hoy NO está implementada — el mapa es plano en significado.

## 1. Mapeo capa → categoría oficial (estado actual medido)

| Capa | Cat. | Color actual | Stroke actual | Fill actual | Label actual | Escala actual |
|---|---|---|---|---|---|---|
| H2 Cominetti (Resto A+B / Lote C) | **C1** | #C97B3A | 2 px | 0.22 | `label_mapa` 12 px siempre | siempre |
| Servidumbre AI Dic-2025 | **C2** | #EC4899 | 2 px | 0.22 | sin label de mapa | siempre |
| InterChile corredor 2014 | **C2** | #7C3AED | 2 px | 0.22 | sin label | siempre |
| Servidumbres históricas (capa 5, línea) | C2/C5 | #3B82F6 | 3 px dash | — | "TRAZADO APROXIMADO" 10 px | siempre (OFF default) |
| Torres InterChile | **C3** | #7C3AED | r=8 px fijo + stroke blanco 1.5 | 0.95 | sin label | **siempre (violación: visibles a zoom comunal)** |
| H1 García Huidobro | **C4** | #6B7280 | 2 px | 0.22 (**4–7× el objetivo 3–5 %**) | sin label | siempre |
| Matriz AI 2021 | **C5** | #A855F7 | 2 px | 0.22 (**10× el objetivo 0–2 %**) | sin label | toggle OFF ✓ |
| Perímetro RTK | C1-aux (autoridad geométrica) | #10B981 | 2 px | 0.22 | sin label | siempre |
| Ortofoto | aux | raster | — | 0.85 | — | toggle OFF en reunión ✓ |
| Ruta 5 | contexto vial | rosa | línea comuna | — | — | siempre |

**Lecturas inmediatas:** (a) C1 no domina: mismo peso que C4/C5; (b) la torre (r8 + borde blanco) pesa MÁS en pantalla que la servidumbre que representa a zoom medio — violación directa de la regla de infraestructura puntual; (c) RTK no tiene categoría en la gramática C1–C5: es autoridad geométrica del activo — propuesta: tratarla como variante de C1 (borde sin relleno) o categoría C1-G explícita, decisión de Max.

## 2. UX-CARTO-01 · Colores — brechas y propuesta

Brecha: 7 hues distintos sin semántica compartida (naranjo/gris/púrpura/verde/azul/rosa/violeta) = identidad de archivo, no de significado.

Propuesta de paleta por TIPO (diseño, valores finales a calibrar sobre fondo gris):

| Cat. | Significado | Hue propuesto | Nota |
|---|---|---|---|
| C1 | Activo Magnus | **mantener #C97B3A (cobre Magnus)** | único elemento "cálido protagonista" del mapa |
| C1-G | Autoridad geométrica (RTK) | mismo #C97B3A, borde discontinuo fino, fill 0 | "el contorno verdadero del activo", no otra cosa |
| C2 | Afectaciones directas | familia magenta-violeta: AI #EC4899 sólido / InterChile #7C3AED | mismo mensaje ("esto grava"), trazo distingue instrumento |
| C3 | Infraestructura | gris-azul frío #64748B, símbolo pequeño | nunca caliente |
| C4 | Contrapartes (H1, vecinos) | gris neutro #6B7280 (mantener) | casi monocromo con el fondo |
| C5 | Histórico (matriz, línea 26 km) | gris-púrpura desaturado, casi invisible | watermark |

## 3. UX-CARTO-02 · Grosores

| Cat. | Actual | Objetivo mandato | Acción de diseño |
|---|---|---|---|
| C1 H2 | 2 px | 3 px | subir a 3 px (polígono grande: NO más de 3) |
| C2 AI/InterChile | 2 px | 2–3 px | AI 2.5 px / InterChile 2 px (AI > InterChile: vigente > histórica) |
| C3 torres | r8 fijo | símbolo ≤ peso servidumbre | radio interpolado por zoom: 3 px @z10 → 7 px @z15 |
| C4 H1 | 2 px | 1–1.5 px | bajar a 1.25 px |
| C5 matriz | 2 px | 1 px | bajar a 1 px |

## 4. UX-CARTO-03 · Opacidades

| Cat. | Actual | Objetivo | Delta |
|---|---|---|---|
| C1 | 0.22 | 0.15–0.20 | −10/30 % (queda protagonista al bajar el resto) |
| C2 | 0.22 | 0.08–0.12 | **−50 %** |
| C4 | 0.22 | 0.03–0.05 | **−80 %** |
| C5 | 0.22 | 0.00–0.02 | **−90 % (watermark)** |

Hoy la única jerarquía de opacidad existente es accidental (raster 0.85, puntos 0.95).

## 5. UX-CARTO-04 · Visibilidad por escala

Estado: **cero gating** en capas H2 (solo `seia-labels minzoom 11` en comuna). Propuesta de bandas (calibrar):

| Banda | Zoom | Muestra | Oculta |
|---|---|---|---|
| Comunal | ≤ 11.5 | H2 (C1), H1 (C4 tenue), franja corredor C2 simplificada | torres, labels secundarios, detalle |
| Operacional | 11.5–13.5 | + servidumbres con label, InterChile, RTK | torres opcionales (aparecen ~13) |
| Detalle | ≥ 13.5 | + torres con id, anchos, elementos puntuales | — |

Implementación futura = `minzoom`/`maxzoom` + `interpolate` por zoom en radius/width — sin capas nuevas.

## 6. UX-CARTO-05 · Jerarquía de etiquetas

| Nivel | Elemento | Actual | Objetivo |
|---|---|---|---|
| 1 · siempre | H2 COMINETTI (Resto A+B / Lote C) | 12 px igual que todo | 13 px, peso 600, halo fuerte, siempre |
| 2 · zoom operacional | Servidumbre AI · InterChile | sin label | 11 px desde z≈12 |
| 3 · contextual | H1 | sin label | 10.5 px desde z≈12.5, gris |
| 4 · histórico | Matriz | sin label | solo si capa ON, 10 px |

El mecanismo `label_mapa` + `namelabel` creado en foco.3/.5 ya soporta esto: agregar `label_mapa` a las features C2/C4 y graduar `text-size` por capa — cero estructuras nuevas.

## 7. Fondo cartográfico

Actual: OSM estándar (beige/amarillento, calles naranjas) — confirma el problema detectado: obliga a saturar. Satélite Esri disponible como alternativa. **Propuesta:** sumar opción de basemap gris claro cartográfico (p. ej. CARTO Positron `light_all` u equivalente con atribución correcta) y hacerla **default del modo reunión**; OSM queda como opción. Es un cambio de fuente raster del basemap, no una capa de datos — pero altera percepción global: probar A/B en proyector antes de fijarlo.

## 8. Regla de lenguaje (sidebar — pendientes menores)

Fichas ya corregidas (Sprint UX-A). Quedan en el sidebar: "H2 Cominetti **(canon)**" (jerga interna → "H2 Cominetti · Resto A+B / Lote C"), "Perímetro RTK · **capa física**" (→ "Perímetro RTK · autoridad geométrica"), "Ortofoto sector oriental **(raster)**" (→ quitar "(raster)").

## 9. Test de 5 segundos — estado

| Pregunta | ¿Se responde hoy sin leyenda? |
|---|---|
| ¿Cuál es el activo principal? | Parcial — labels Resto A+B/Lote C ayudan; el peso visual no acompaña |
| ¿Qué lo afecta? | No — AI e InterChile pesan igual que H1 |
| ¿Qué es contexto? | No — H1 al 0.22 parece otro activo |
| ¿Qué es histórico? | Sí por ausencia (matriz OFF) — no por diseño |
| ¿Qué requiere atención? | No — nada pulsa ni destaca |

**Veredicto: la jerarquía cartográfica todavía no está resuelta** (criterio del propio mandato). La buena noticia: el 100 % de las correcciones son paramétricas (opacity/width/zoom/text-size sobre capas existentes) — Sprint cartográfico futuro de bajo riesgo, sin tocar datos ni geometrías.

## 10. Orden sugerido del sprint cartográfico (cuando se autorice)

1. Opacidades por categoría (mayor impacto, 1 parámetro por capa).
2. Grosores por categoría.
3. Escala: torres con minzoom + radius interpolado.
4. Etiquetas jerarquizadas (label_mapa a C2/C4 + text-size).
5. Basemap gris default reunión (validar en proyector).
6. Lenguaje sidebar (3 renombres).
Validación: render servido A/B por banda de zoom + test 5 segundos con un tercero que no conozca el proyecto.

---
*UX-CARTO-01..05 ejecutadas como auditoría · parámetros medidos en código (`fill-opacity 0.22`, `line-width 2/3`, `circle-radius 8`, sin minzoom H2, basemap OSM) · cero implementación, conforme al mandato.*
