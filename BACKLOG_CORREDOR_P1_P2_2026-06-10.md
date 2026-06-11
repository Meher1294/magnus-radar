# Backlog Corredor AI + Estructura Operacional H2
### Instrucción consolidada Max · 2026-06-10 · estado tras v1.2-foco.3

## Estado de cumplimiento de la instrucción

| Punto | Estado |
|---|---|
| 1. H2 representada como Resto A / Resto B / Lote C (roles SII como atributo secundario) | ✅ Implementado (commit 1e34e1e + foco.3): nombres, labels de mapa, `estructura_operacional`, "Partición A/B pendiente de reconciliación documental" visible en ficha (campo observación, ambos modos) |
| 2. Servidumbre AI Dic-2025 = capa principal del corredor; metadata de auditoría declarada | ✅ `servidumbre_andes_iron.geojson` con bloque `auditoria_geometrica: NO_AUDITADA` (HECHOS vs NO VERIFICADO según instrucción) |
| 3. Línea esquemática 26 km = contexto, no base de negociación | ✅ Default OFF en modo reunión (toggle disponible) + props `vigencia_negociacion: NO_BASE_DE_NEGOCIACION`, `superada_por: AIPD-01` en el dato |
| 4. Regla dura (no partir, no inventar, no precisión ficticia) | ✅ Hashes geométricos invariantes verificados en cada edición (capa_1 `1c048fe8…`, capa_5 `9e1e12ca…`, AI `4f25bc0a…`) |

Set default del modo reunión quedó: Cominetti (Resto A+B / Lote C) · H1 contextual · RTK · **Servidumbre AI Dic-2025** · InterChile 2014 + 9 torres · ortofoto. La leyenda y el panel ejecutivo reflejan exactamente ese set.

---

## P1 — Auditoría geométrica servidumbre AI

**Objetivo:** validar que la vectorización representa fielmente el plano `AIPD-01-AI-AIP001` (Diciembre 2025, Rev. 0, entregado por GH 17-may-2026).

**HECHO (ya declarado en metadata del GeoJSON):** existencia del plano; predios afectados (roles 24-43 H1 / 24-123 H2); superficies declaradas 57,545 + 124,145 = 181,69 ha; coincidencia GeoJSON↔declaradas.

**NO VERIFICADO (objeto del P1):** método de vectorización · RMSE · sistema de control geométrico · precisión posicional · auditoría plano→GeoJSON.

**Entregables:**
1. Plano fuente incorporado al data room (hoy: citado, no archivado en repo).
2. Datum identificado.
3. Método documentado.
4. RMSE documentado.
5. Comparación superficie plano vs GeoJSON.
6. **Veredicto: VALIDADO / REQUIERE_AJUSTE / NO_AUDITABLE** → registrar en `metadata.auditoria_geometrica.estado`.

**Dependencias:** acceso al plano físico/PDF AIPD-01. Andamiaje técnico reutilizable: el de georreferenciación P1 del plano histórico (`p1_georreferenciacion/`, criterio RMSE ≤ 50 m).

---

## P2 — Reconciliación Resto A / Resto B

**Objetivo:** asignar espacialmente los cuerpos operacionales históricos (Resto A = 863 ha · Resto B = 976 ha, anotaciones plano histórico).

**Estado de evidencia (verificado 2026-06-10):**
- Resto a+b = 1.839,35 ha (adjudicaciones feb-2017) + Lote C 300 ha = **2.139,35 ha ≈ CBR 2.139** ✓ y ≈ 863+976+300 ✓ — reconciliación jurídica de superficies CERRADA.
- `titularidad_cominetti_2023.geojson` usa una geometría placeholder única (hash idéntico en las 8 cuotas) → **no aporta geometría para separar A/B**.
- Los 3 cuerpos catastrales SII del rol 24-123 (1.399,93 / 0,15 / 901,71 ha) **no corresponden** a la partición jurídica A/B.

**Fuentes candidatas:** ITS-CARTO-PLANO-0001 (georreferenciación pendiente, P1 del expediente carto) · adjudicaciones 2017 · plano CBR coordenado · perímetro RTK.

**Regla vigente hasta cerrar P2:** Resto A y Resto B son entidades jurídicas válidas pero **NO polígonos georreferenciados validados**. El visor las muestra unificadas ("Resto A+B") con pendiente explícito.

---

## P3 — Brecha SII ↔ CBR/RTK (observación Max 2026-06-10)

> "La brecha grande pendiente ya no es A/B; es SII (≈2.601 ha) versus CBR/RTK (≈2.139–2.165 ha). Esa es la reconciliación que un tercero técnico probablemente cuestionará primero."

**Magnitud:** SII 2.600,97 − RTK 2.164,97 ≈ **436 ha** (− CBR 2.139 ≈ 462 ha).
**Candidato documental declarado** (capa 5, f3): expropiaciones faja Ruta 5 (MOP 2011-2017, lotes 319/320/331-1/331-3/333/334/335/338-1) como "componente principal de brecha 503 ha".
**Acción:** reconciliación lote a lote expropiado vs diferencia catastral; producto = tabla de autoridades de superficie con desglose de la brecha (insumo directo de la Ficha Territorial Corredor v0).
**Doctrina aplicable:** la brecha se declara con acción de verificación, no se cierra con hipótesis.

---
*Las tres prioridades son documentales/geométricas — ninguna requiere tocar el visor. El visor ya tiene el andamiaje (`particion_ab`, `superficie_por_autoridad`, `auditoria_geometrica`, `label_mapa`) para absorber sus resultados sin rediseño.*
