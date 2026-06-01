# Issues Operacionales · Magnus Radar

**Custodio:** Max Medina
**Propósito:** registro de anomalías de datos / render / lógica detectadas durante uso real, ANTES de que se conviertan en bugs reportados o causen deuda silenciosa.
**Disciplina:** ningún issue se cierra sin causa raíz documentada + acción aplicada + verificación.

---

## Estructura de cada issue

```yaml
ID:                código corto único
estado:            abierto | mitigado | resuelto | descalificado
severidad:         alta | media | baja
componente:        capa donde se manifiesta
detectado_en:      sesión / fecha
detectado_por:     quién
descripcion:       síntoma observado por el usuario
hipotesis_causa:   posibles orígenes
evidencia:         logs, queries, líneas de código
plan_mitigacion:   acción concreta pendiente
prioridad:         orden vs otros issues
bloqueante_para:   trabajos que requieren resolverlo antes
```

---

## ROL_0_0_FALLBACK

```yaml
ID:                ROL_0_0_FALLBACK
estado:            abierto
severidad:         media
componente:        capa de predios XU (web/index.html · loadPrediosFromAPI línea ~1418)
detectado_en:      Sesión 2026-05-31 · validación Fase 1 v0.3
detectado_por:     Max Medina (click sobre feature del mapa)
```

### Síntoma observado

Al hacer click sobre un predio del mapa, el panel derecho muestra:

```
Rol 0-0
824,9 ha
La Higuera, Coquimbo
```

El "0-0" no parece ser un rol SII real. Es formato sospechoso (rol SII chileno tiene patrón `MM-PP` con MM = manzana y PP = predio, ambos enteros típicamente > 0).

### Hipótesis de causa (en orden de probabilidad)

**H1 · Fallback ETL en seed/scrape XU:** el scraper que pobló la tabla `predios` asignó `'0-0'` como string literal a registros sin rol SII válido (parcelas no roladas, predios fiscales, etc.). El frontend lo renderiza tal cual sin filtro.
- Evidencia: línea 1424 hace `rol: r.rol` directo desde Supabase, sin validación
- Evidencia: línea 2061 renderiza `<div class="panel-title">Rol ${p.rol}</div>` sin fallback explícito

**H2 · Concatenación de manzana y predio con valores 0:** algún registro tiene `manzana=0` y `predio=0` y el rol fue construido como `'0-0'` por template SQL o ETL.
- Evidencia: línea 1428 lee `manzana: r.manzana, predio: r.predio` pero el rol viene del campo `r.rol` directo, no construido en frontend

**H3 · Predio fiscal/sin rolar (BBNN, área pública):** algunos terrenos pertenecen al fisco y no tienen rol SII asignado; convención cartográfica chilena para esos casos es `0-0` o `S/R`.
- Evidencia: existencia de superficie razonable (824,9 ha) sugiere predio real, no error

**H4 · Bug en serialización JSON desde PostgreSQL:** un cast inadecuado convirtió `NULL` a `'0-0'` en algún paso del pipeline.

### Hipótesis MÁS PROBABLE

**Combinación H1 + H3:** existe en la tabla `predios` al menos un registro real con `rol = '0-0'` (string literal) correspondiente a terreno fiscal/no rolado. El scraper XU lo cargó así desde la fuente original, y el frontend lo renderiza sin distinguir entre rol legítimo y placeholder.

### Verificación pendiente

Query SQL a ejecutar en Supabase (NO ejecutada todavía):

```sql
SELECT rol, count(*) as n, sum(area_ha) as ha_total
FROM predios
WHERE rol IS NULL
   OR rol = ''
   OR rol = '0-0'
   OR rol LIKE '0-%'
   OR rol LIKE '%-0'
GROUP BY rol
ORDER BY n DESC;
```

Esto debería revelar:
- Cuántos predios tienen rol problemático
- Cuántas hectáreas representan
- Si hay otros patrones sospechosos (`'0-1'`, `'1-0'`, etc.)

### Impacto

| Dimensión | Impacto |
|---|---|
| Funcionalidad v1 | bajo · el predio se ve, click funciona, no rompe nada |
| Confianza en datos | medio-alto · usuario ve "Rol 0-0" y sospecha legítimamente |
| Integración ITS v0.3 | bajo · el predio NO pertenece a unidad registrada → no se renderiza chip ni sub-tabs ITS |
| Búsqueda / filtros | medio · si el usuario filtra por rol, "0-0" puede comportarse raro |
| Análisis estadístico | medio-alto · si hay N predios con `'0-0'` y se suman superficies por rol único, el `'0-0'` agrega todas las superficies como si fueran un solo predio |

### Plan de mitigación (NO aplicado todavía)

**Opción A · Cosmética en frontend** (15 min)
- Modificar línea 2061: `Rol ${p.rol === '0-0' ? 'Sin rol SII asignado' : p.rol}`
- Modificar línea 2040: `selectionCount` mismo tratamiento
- Pros: rápido, reversible, no toca datos
- Contras: oculta el síntoma sin atacar la causa

**Opción B · Diagnóstico en backend** (1 hora)
- Ejecutar la query verificadora arriba
- Identificar cuántos predios afectados
- Decidir si reasignar a NULL, descartar, o re-cargar desde fuente
- Pros: ataca la causa
- Contras: requiere acceso a datos, decisión sobre la fuente original

**Opción C · Adoptar ontología ITS para clasificar predios sin rol** (post-v0.3)
- Crear `its.predios_sin_rol_sii` con tipologías (fiscal, comunitario, no_rolado, error_etl)
- Asignar cada `'0-0'` a su categoría real
- Pros: solución estructural alineada con la doctrina
- Contras: requiere v0.3 + Supabase staging activo + clasificación manual

### Prioridad

**Media.** No bloquea Fase 1 ni Fase 2 del v0.3 (el predio "0-0" no pertenece a `predios_to_unidad`, así que la lógica ITS NO se activa para él). Pero debe resolverse antes de aplicar el sistema de estados disciplinados a predios individuales (Fase 5+ del v0.3).

### Bloqueante para

- NADA del esqueleto v0.3 (Fases 1-6)
- SÍ bloqueante para: aplicar `state-badges.js` a predios individuales con estado disciplinado, porque "0-0" no se puede etiquetar como `verificado`/`identificado` sin antes saber qué representa.

---

### DIAGNÓSTICO EJECUTADO · 2026-06-01

**Query Supabase prod (curqkgujgtimlutinhgu) vía anon key (pública):**

```yaml
predios_con_rol_0_0:           335    # 4.4% del total 7.686
predios_con_rol_NULL:            0    # ningún NULL en la tabla
predios_con_rol_vacio:           0    # ningún string vacío
predios_con_rol_terminado_en_-0: 741  # superset incluye los 335 + otros 406 "<algo>-0"

ha_acumuladas_rol_0_0:           ~75.664 ha
ha_top_8:                        ~70.000 ha (93% del total del cluster)
ha_top_1:                        30.724 ha (un solo polígono)
ha_top_2:                        19.234 ha
ha_top_3:                        8.395 ha

distribucion_sectores_rol_0_0:
  sin_sector:           261/335   # mayoría sin caracterización fina
  los_choros:            23/335
  quebrada_los_choros:   18/335
  la_higuera:             4/335
  playa_los_choros:       3/335
  punta_de_choros:        3/335
  islotes_apolillados:    3/335   # SNASPE Pingüino de Humboldt
  quebrada_el_pelicano:   3/335
  islotes_pajaros:        2/335   # SNASPE
  el_trapiche:            2/335
  islote_los_farallones:  2/335   # SNASPE
  punta_colorada:         2/335
  cementerio_los_choros:  1/335   # municipal/parroquial
  isla_tilgo:             1/335   # SNASPE Pingüino
  isla_chungungo:         1/335   # SNASPE Pingüino
```

**Hipótesis confirmada:** combinación H1 + H3 + ALGO MÁS — el rol `'0-0'` agrupa heterogéneamente:
- Reservas SNASPE (Reserva Nacional Pingüino de Humboldt: Islas Tilgo, Chungungo, Damas, Apolillados, Pájaros, Farallones)
- Bienes Nacionales fiscales (BBNN) — los 3 predios más grandes (30.724 + 19.234 + 8.395 ha)
- Cauces, playas, Bienes Nacionales de Uso Público (BNUP)
- Municipal/Parroquial (Cementerio Los Choros)
- Predios sin rolar pendientes de catastralización SII

**Consistencia con memoria:** coincide con `conocimiento_pendiente_rol_sii_no_es_unidad_geografica` (75.787 ha en roles 0-0 ≈ 18% de la comuna).

### FIX APLICADO · v1.0.9 · 2026-06-01

**Opción A (cosmética + estructural mínima):**

```yaml
edit_1:
  archivo: web/v1-h2/index.html
  funcion: renderPredioPanel
  cambio: |
    - panel-type: "Predio · Rol SII" → "Predio sin rolar · Bien fiscal / SNASPE / BNUP" (cuando rol='0-0')
    - panel-title: "Rol 0-0" → "Sin rol SII · fiscal/no rolado"
    - flag agregado: SIN ROL SII (tooltip explica cluster)

edit_2:
  archivo: web/v1-h2/index.html
  funcion: selectionCount
  cambio: |
    - "Rol 0-0 · 824.9 ha" → "Sin rol SII · Sin sector · 824.9 ha"
```

**Pendiente (NO aplicado todavía):**
- Opción C estructural · clasificación efectiva de los 335 en SNASPE/BBNN/BNUP/Municipal/Sin_Rolar requiere cruce con capas oficiales (SNASPE, BBNN, MOP, Municipalidades) — Tarea bloqueada por ausencia de capas oficiales descargadas en data room
- Filtro de búsqueda: si usuario busca "0-0" debería retornar lista clusterizada por sector, no agregar todo como un único "predio". Pendiente decisión Max.

### Estado actual

```yaml
ID:                ROL_0_0_FALLBACK
estado:            mitigado          # v1.0.9 · fix cosmético aplicado
severidad:         media → baja      # render ya no engaña al usuario
causa_raíz:        no_resuelta       # estructural pendiente (Opción C)
verificacion:      COMPLETADA 2026-06-01 (335 predios · 75.664 ha)
proximo_paso:     decidir si clasificación estructural (Opción C) o se mantiene cosmético (Opción A · default)
```

### Verificación de que ITS v0.3 no se rompe con este caso

Confirmado por código:

```js
// js/its-data.js línea 154
export function getUnitForPredio(rol) {
  return FIXTURE.predios_to_unidad[rol] || null;
}
```

`FIXTURE.predios_to_unidad['0-0']` es `undefined` → operador `||` devuelve `null`.

**Resultado:** `window.its.getUnitForPredio('0-0')` retorna `null`. ✓

El chip "📍 Parte de unidad" en Fase 2 NO se renderizará para roles que no estén en el mapping. Por construcción, ROL_0_0_FALLBACK NO contamina la integración ITS.

### Próxima acción

Esperar a que Max ejecute la query verificadora en Supabase o decida qué opción de mitigación aplicar. Issue queda en `estado: abierto` hasta entonces.

---

## Plantilla para nuevos issues

```yaml
ID:                XXX_NOMBRE_DESCRIPTIVO
estado:            abierto
severidad:         alta | media | baja
componente:        [capa donde se manifiesta]
detectado_en:      [sesión / fecha]
detectado_por:     [quién]

descripcion:       [síntoma observado]
hipotesis_causa:   [posibles orígenes con evidencia]
plan_mitigacion:   [acción pendiente]
prioridad:         [orden]
bloqueante_para:   [trabajos que requieren resolverlo]
```

---

## SANDBOX_OVERLAY_LOSS

```yaml
ID:                SANDBOX_OVERLAY_LOSS
estado:            abierto
severidad:         alta
componente:        infraestructura sandbox del asistente IA (Cowork mode)
detectado_en:      Sesión 2026-05-31 · post-Fase 4 v0.3
detectado_por:     Claude (auto-detección al intentar validar Fase 4 vía DOM headless)
```

### Síntoma observado

Al intentar validar estructuralmente los renderers de Fase 4 con jsdom, la herramienta `cp` desde sandbox bash reportó `cannot stat 'web/js/its-data.js': No such file or directory`. Investigación inmediata reveló:

- `web/js/` directorio NO existe en filesystem real
- Los 5 archivos JS de Fases 1-4 (state-badges, its-data, its-bootstrap, panel-detail, its-renderers) NO existen
- `web/index.html` NO contiene los 4 bloques `ITS v0.3 SKELETON` ni el `<script type="module">` que supuestamente fueron insertados
- **PERO** una escritura nueva inmediata vía Write tool sí persistió (verificado con `_FS_TEST_2026-05-31.txt`)

### Hipótesis de causa

**H1 (alta probabilidad):** el sandbox fue reseteado durante el compactado de contexto (entre invocaciones del asistente). Los Write/Edit ejecutados pre-compactado vivían en una capa de overlay temporal que NO se sincronizó al filesystem real del Mac antes del reset.

**H2:** las herramientas Write/Edit reportaron success basándose en escritura a un caché local, pero el commit al filesystem real falla silenciosamente en algunas condiciones.

**H3:** problema de timing entre invocaciones del asistente y el flush del filesystem mounted.

### Evidencia

- Archivos creados antes del compactado (docs/, db/, CANON, dossiers) → **persisten correctamente**
- Archivos creados después del compactado (web/js/*, modificaciones a web/index.html) → **NO persistieron**
- Test de escritura ACTUAL → persiste OK

### Impacto

| Dimensión | Impacto |
|---|---|
| Funcionalidad v1 Magnus Radar | NINGUNO (el v1 nunca se modificó, sigue intacto) |
| Validaciones aprobadas operacionalmente por Max para Fases 2-4 | **degradadas a "aprobación conceptual no verificada físicamente"** |
| Tiempo invertido | ~3 horas de trabajo de Fases 1-4 que debe re-aplicarse |
| Confianza en reportes del asistente | erosionada; toda afirmación de "archivo creado" requiere verificación inmediata Read+bash |
| Disciplina epistemológica del proyecto | reforzada: este incidente es ejemplo perfecto de por qué la validación funcional NO es opcional |

### Plan de mitigación

1. **Auditoría completa filesystem** ✓ realizada
2. **Re-aplicación Fase 1-4** desde contenido en contexto de conversación · verificación inmediata cada Write con Read+bash
3. **Nueva disciplina del asistente**: después de cada Write/Edit crítico, ejecutar inmediatamente `ls -la` o `cat | head` vía bash para confirmar persistencia
4. **Reportar al usuario diff físico verificado**, no diff conceptual basado en historial de la sesión
5. **Si hay compactado de contexto en el futuro**: re-ejecutar auditoría antes de continuar trabajo

### Prioridad

**Alta.** El incidente revela una clase de fallo silencioso que puede contaminar cualquier trabajo futuro del asistente que use Write/Edit sin verificación inmediata.

### Bloqueante para

- Cualquier avance de Fase 5+ en v0.3 hasta completar re-aplicación
- Confianza operacional general en reportes de "completado" del asistente
- Validaciones del usuario que se basaron en suposición de que los archivos existían

---

## MAP_GLOBAL_EXPOSURE

```yaml
ID:                MAP_GLOBAL_EXPOSURE
estado:            abierto · aceptado como deuda
severidad:         baja
componente:        web/index.html (Fase 6 v0.3)
detectado_en:      Sesión 2026-05-31 · implementación Fase 6
detectado_por:     Max Medina (revisión dictamen)
```

### Síntoma

`web/index.html` agrega la línea `window.map = map;` al final del script v1 (junto al ya existente `window.__sb = sb;`) para exponer la instancia de MapLibre a los módulos ES.

Sin esa exposición, `js/map-geometrias.js` no puede acceder al mapa para agregar/quitar capas (los `const` del v1 son scope local de su `<script>`).

### Por qué se aceptó

- Sin esta línea, los toggles G1-G4 del sub-tab Geometrías no pueden encender capas reales sobre el mapa
- El beneficio operacional (geometrías comparables visualmente) supera el costo (1 línea de acoplamiento global)
- Sigue el patrón ya existente del v1 (`window.__sb = sb`)
- Rollback trivial: eliminar la línea

### Alternativas futuras (no aplicadas)

| Alternativa | Pro | Contra |
|---|---|---|
| **Map registry pattern** (módulo dedicado expone get/set del map) | Encapsula, evita variable global | Requiere refactor del v1 |
| **Event bus** (custom event `magnus:map-ready` que dispara el v1) | Sin acoplamiento global | Requiere modificación adicional al v1 |
| **Dependency injection** (panel-detail.js recibe map por parámetro al init) | Limpio arquitectónicamente | Requiere reordenar timing de inicialización |
| **Polling** (`setInterval` esperando una pista del mapa en DOM) | Sin tocar v1 | Frágil, anti-patrón |

### Impacto actual

| Dimensión | Impacto |
|---|---|
| Funcionalidad v1 | NINGUNO (la línea solo agrega referencia) |
| Funcionalidad v0.3 | habilitante (sin esto Fase 6 no funciona) |
| Acoplamiento global | mínimo · 1 variable adicional en window |
| Seguridad | nulo · `map` es objeto cliente, no expone secretos |
| Migración futura | media · cuando se modularice el frontend, esto se reemplaza por DI o registry |

### Bloqueante para

- Nada. Aceptado como deuda hasta refactor del frontend (post-v0.3).

### Plan de mitigación

1. Mantener vigilancia de cualquier otro objeto del v1 que necesite exposición similar (evitar proliferación)
2. Cuando se modularice index.html (post-v0.5 estimado), eliminar la línea y usar map registry pattern
3. NO aumentar la superficie de exposición global más allá de `map` y `__sb` actuales

---

## KMZ_LABEL_VS_POLY_MISMATCH

```yaml
ID:                KMZ_LABEL_VS_POLY_MISMATCH
estado:            abierto
severidad:         alta
componente:        representaciones_geometricas.G3 · DataRoom_Cominetti_LaHiguera.kmz
detectado_en:      Sesión 2026-05-31 · Fase 7A (extracción geometrías reales)
detectado_por:     Claude (cálculo automático de área Shoelace post-extracción) + Max Medina (clasificación)
```

### Síntoma

El archivo `04_PLANOS_CATASTRO/DataRoom_Cominetti_LaHiguera.kmz` contiene un placemark titulado:

```
"1. PREDIO COMINETTI — Hijuela 2 (2.640 ha)"
```

Pero al extraer el polígono real del placemark (26 vértices · WGS84) y calcular su área con fórmula de Shoelace en proyección equirectangular ajustada por latitud centroide:

| Métrica | Valor |
|---|---|
| Etiqueta KMZ (texto) | **2.640,00 ha** |
| Área calculada desde geometría | **1.671,26 ha** |
| Delta absoluto | -968,74 ha |
| Delta relativo | **-36,7 %** |

### Por qué es alta severidad

No es un conflicto entre dos fuentes distintas. Es un conflicto **dentro de la misma evidencia primaria**:

- Fuente A dice X y fuente B dice Y → conflicto típico de reconciliación
- El propio archivo dice X en el atributo y Y en la geometría → **inconsistencia interna**

Esto afecta directamente la confiabilidad del KMZ como representación operacional, incluso para uso histórico. Cualquier decisión territorial pasada que se basó en la cifra "2.640 ha" leyendo la etiqueta del KMZ está cuestionada — el polígono que la respaldaba no corresponde.

### Triangulación adicional (post-detección)

Hallazgo paralelo durante Fase 7A: el archivo `TOPO_COMINETTI_2007_UTM19S.gpkg` (levantamiento topográfico encargado por los propietarios en 2007, ver `DOSSIER_TOPO_COMINETTI_2007.md`) calcula 2.200,93 ha · bbox overlap 97,8% vs RTK G4.

Dos mediciones independientes (TOPO 2007 + RTK 2026) convergen alrededor de **2.150-2.200 ha**. El KMZ G3 con 1.671 ha es atípico respecto a ambas.

### Hipótesis abiertas (NO concluidas)

| Hipótesis | Implicación si verdadera |
|---|---|
| **H1** · La etiqueta "2.640 ha" es incorrecta | El KMZ tenía dato textual erróneo · el polígono dibujado podría ser correcto pero corresponder a una sub-área (~1.671 ha) |
| **H2** · El polígono está incompleto (faltan vértices) | El polígono real de Hijuela 2 es mayor · alguien dibujó solo una parte sin completar |
| **H3** · La superficie 2.640 corresponde a otra agregación territorial distinta | "2.640 ha" puede ser una suma que incluya parcelas vecinas, servidumbres, o conceptos no equivalentes a "el polígono" |

Ninguna de las 3 puede cerrarse con la evidencia disponible. Mantener abiertas.

### Verificación pendiente

1. Comparar polígono KMZ contra catastro SII directo (mapas.sii.cl roles 24-123 + 24-160)
2. Comparar polígono KMZ contra plano 377/2006 cuando se extraiga del CBR
3. Indagar quién y cuándo construyó el KMZ (autor del archivo)
4. Verificar si "2.640 ha" provino de etiqueta SII histórica antigua (rol 24-4 pre-mutación catastral, ver `GAP_MUTACION_CATASTRAL_24_4_A_24_123_24_160`)

### Bloqueante para

- Usar G3 como referencia cuantitativa en cualquier decisión operacional (debe quedar marcado superseded + nota explícita en UI)
- Cualquier análisis que dependa del polígono histórico documental hasta resolver las 3 hipótesis

### Impacto en el sistema

- ✅ Ya visible: G3 está marcado superseded en sub-tab Geometrías + render con opacidad reducida + línea discontinua
- ✅ Pendiente: registrar como conflicto ITS en `its-data.js` fixture (será visible en sub-tab Conflictos de la ficha Hijuela 2)
- Comunicar al equipo: NO citar "2.640 ha" como superficie respaldada por geometría · usar 2.139,35 (jurídica), 2.156,70 (RTK calculada) o 2.164,97 (RTK declarada)

