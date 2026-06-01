# Hardening Report · Magnus Radar v0.3 + ITS

**Fecha:** 2026-05-31
**Custodio:** Max Medina
**Modo:** bug-hunt + hardening (NO feature-driven)
**Alcance:** lectura crítica del código actual · sin codear fixes

---

## 0 · Honestidad del alcance

Este reporte se basa en **lectura del código fuente**, no en validación visual real en navegador. Lo que puedo verificar leyendo: duplicaciones, conceptos repetidos, deuda CSS, acoplamientos, terminología inconsistente, estructura DOM. Lo que NO puedo verificar sin navegador: render real, scroll comportamiento, responsive, performance percibido, accesibilidad visual.

Los hallazgos marcados **[código]** son verificables sin abrir el sitio. Los marcados **[navegador]** requieren tu inspección visual cuando ejecutes.

---

## 1 · Inventario actual (línea base)

| Componente | Líneas | Comentario |
|---|---|---|
| `web/index.html` | 5.929 | +931 vs v1 base (CSS ITS) |
| `web/js/state-badges.js` | 80 | 5 exports |
| `web/js/its-data.js` | 138 | 10 exports |
| `web/js/its-bootstrap.js` | 53 | 0 exports (side-effects) |
| `web/js/its-grafo-data.js` | 285 | 11 exports |
| `web/js/its-renderers.js` | 712 | 11 exports |
| `web/js/map-geometrias.js` | 244 | 11 exports |
| `web/js/panel-detail.js` | 582 | 2 exports |
| **Total JS** | **2.094 líneas** | **52 exports** |

**Acoplamientos globales identificados (window.*):**
1. `window.its` (read-write desde bootstrap · expone 14 properties)
2. `window.map` (set desde v1 inline script)
3. `window.selectPredio` (wrappers v1 + ITS)
4. `window.updateUrlHash` (wrappers v1 + ITS)

---

## 2 · Hallazgos por severidad

### ALTA · resolver antes de cualquier feature nuevo

#### H-A1 · Triple redundancia del conteo de conflictos [código]

**Hallazgo:** el número "13 conflictos abiertos" aparece en 3 lugares distintos para la misma unidad:
1. Badge del sub-tab Conflictos: `(13) ⚠`
2. Resumen · línea "Estado epistemológico": link rojo "13 conflictos abiertos ⚠"
3. Header del sub-tab Conflictos: subtítulo "13 en total"

**Evidencia:**
- `panel-detail.js` línea ~109: `SUB_TABS` con `badge: (u) => u.conflictos?.length`
- `panel-detail.js` función `renderResumenUnidad` · sección estado epistemológico
- `its-renderers.js` función `renderConflictos` · subtítulo con count

**Severidad alta:** un cambio en uno se desincroniza fácilmente de los otros (ya pasó con `conflictos_abiertos_count: 13 → 14` cuando agregamos KMZ_LABEL_VS_POLY_MISMATCH).

**Propuesta mínima:** una sola fuente de verdad. Función `getConflictosAbiertos(unidad).length` calculada en cada render, eliminar `conflictos_abiertos_count` del fixture.

---

#### H-A2 · Listener de inspector doblemente registrado [código]

**Hallazgo:** los nodos con `data-its-inspector` reciben listener desde DOS lugares:
1. `wireGrafoInteractions` en `panel-detail.js` (cuando se renderiza sub-tab Artefactos)
2. `openInspector` en `panel-detail.js` (cuando se abre el drawer y recorre nodos relacionados internos)

**Evidencia:**
- `panel-detail.js` función `wireGrafoInteractions`: `panel.querySelectorAll('[data-its-inspector]').forEach(...)`
- `panel-detail.js` función `openInspector`: `drawer.querySelectorAll('[data-its-inspector]').forEach(...)`

Como el panel se reemplaza con `innerHTML = pickSubTabContent()` cuando se cambia de sub-tab, los listeners de `wireGrafoInteractions` se pierden con la versión vieja. Pero **dentro del drawer** los items de "Padres directos" / "Hijos directos" también tienen `data-its-inspector` · si el panel principal está renderizado a la vez que el drawer, podría haber doble disparo.

**Severidad alta:** posible doble apertura/cierre o re-navegación inesperada.

**Propuesta mínima:** usar atributos distintos · `data-its-inspector-main` para nodos del grafo, `data-its-inspector-nav` para navegación interna del drawer. Cada uno con su listener específico.

---

#### H-A3 · `!important` proliferando en CSS Geometrías [código]

**Hallazgo:** la clase `.its-geom-card__toggle--active` usa `!important` en 5 propiedades para sobreescribir el estilo base "disabled-looking" del toggle.

**Evidencia:** `index.html` líneas 1215-1219:
```css
.its-geom-card__toggle--active {
  cursor: pointer !important;
  opacity: 1 !important;
  color: var(--its-state-identified) !important;
  font-style: normal !important;
  font-weight: 600;
}
```

**Severidad alta:** `!important` es señal de deuda. Cuando agreguemos más estados al toggle (deshabilitado, hover, focus) la cascada será impredecible.

**Propuesta mínima:** invertir la lógica. La base `.its-geom-card__toggle` debe ser estado neutral. Estados específicos (`--disabled`, `--active`) agregan especificidad sin necesitar `!important`.

---

### MEDIA · resolver en próximo ciclo

#### H-M1 · z-index del inspector salta 100× respecto al sistema v1 [código]

**Hallazgo:** Inspector drawer y backdrop usan `z-index: 10000` y `10001`. El v1 usa máximo `z-index: 100`.

**Evidencia:** `index.html` clases `.its-inspector-backdrop` y `.its-inspector-drawer`.

**Severidad media:** si alguien agrega un nuevo modal en v1 con z-index 200, el inspector lo seguirá tapando (intencional ahora, pero romperá expectativas si crece).

**Propuesta mínima:** sistema de stacking documentado. Inspector = 200. Backdrop = 199. Coherente con el orden de magnitud del v1.

---

#### H-M2 · 14 `console.*` residuales en panel-detail.js [código]

**Hallazgo:** 14 llamadas console.info/warn/error en producción. Útiles en desarrollo, ruido en operación real.

**Evidencia:** `panel-detail.js` · contador: 14 console statements.

**Severidad media:** no rompe nada pero contamina consola. Si el usuario abre DevTools por otra razón, verá ruido ITS.

**Propuesta mínima:** namespace `_log(msg)` que se activa solo si `window.its.debug = true`. Reemplazar todos los `console.info('[ITS]...')` por `_log(...)`. Default desactivado.

---

#### H-M3 · Vocabulario inconsistente en marcadores de bloques CSS [código]

**Hallazgo:** los bloques CSS ITS están marcados con nomenclatura mixta: `Fase 1.4`, `Fase 2.3`, `Fase 3.5`, `Fase 4.3`, `Fase 5.2`, `Fase 6`, `Fase 7A`, `Fase P3`. Mezcla numérica con prefijo P. Algunas con punto, otras con letra.

**Evidencia:** `grep "ITS v0.3 SKELETON Fase" index.html` muestra 10+ marcadores.

**Severidad media:** dificulta navegación y futuro rollback selectivo de bloques.

**Propuesta mínima:** normalizar a `[bloque-N · descripción-corta]`. Ejemplo: `[01-states] [02-chip] [03-breadcrumb] [04-superficies] [05-grafo] [06-inspector]`.

---

#### H-M4 · Acumulación visual de badges en nodos del grafo [código]

**Hallazgo:** un nodo del grafo puede mostrar simultáneamente hasta 8 badges en una línea:
```
[código] [nombre] [⊘ descalificada] [↺ afectado_proxy_corrido] [⚓ ancla] [2.200,93 ha] [IA 35%] [↡ impacta 10] [↧ profundidad 3]
```

**Evidencia:** `its-renderers.js` función `renderArtefactoNodo`.

**Severidad media:** información rica pero saturación visual. Cognitivamente difícil de procesar en escaneo rápido.

**Propuesta mínima:** agrupar en 2 líneas. Línea 1: identidad (código + nombre + estado). Línea 2: métricas (superficie + IA + impacto + profundidad). Sin tocar lógica de datos.

---

#### H-M5 · Inspector NO distingue padres directos vs todas las relaciones [código]

**Hallazgo:** sección "Padres directos" del inspector usa `getPadresDirectos` que filtra solo `propagacion === 'automatica_fuerte'`. Si un artefacto tiene padres vía `comparada_contra` (débil), no aparecen como padres directos · solo se mencionan en "Otras relaciones" como conteo.

**Evidencia:** `its-renderers.js` función `renderArtefactoInspector` + `its-grafo-data.js` función `getPadresDirectos`.

**Severidad media:** para artefactos como TOPO 2007 que tienen una sola relación (vs RTK · débil), el inspector dice "Sin padres · este es un nodo raíz" cuando en realidad tiene 1 relación importante.

**Propuesta mínima:** dos secciones separadas. "Padres directos (propagación fuerte)" y "Referencias (propagación débil)". Mostrar ambas explícitamente.

---

#### H-M6 · Tres avisos "fixture" para el mismo concepto [código]

**Hallazgo:** el estado "datos no validados en runtime" se comunica en 3 lugares del sub-tab Artefactos:
1. Badge `fixture` en el chip del sub-tab
2. Bloque amarillo prominente "Vista preliminar · grafo cargado desde fixture local"
3. Bloque azul info "Cuando se ejecute staging la consulta canónica..."

**Evidencia:** `panel-detail.js` `renderSubTabsHTML` + `its-renderers.js` `renderArtefactos`.

**Severidad media:** redundancia defensiva intencional pero puede sentirse repetitivo.

**Propuesta mínima:** mantener badge (siempre visible) + bloque amarillo (disciplina epistemológica). Eliminar bloque azul al final o moverlo al inspector como sección "Cuando staging exista".

---

### BAJA · cosmético / mejoras futuras

#### H-B1 · Bug UX · filtro Artefactos pierde estado al cambiar sub-tab [código]

**Hallazgo:** filtro "Derivación" activo · click sub-tab Superficies · vuelta a Artefactos · filtro resetea a "Todas".

**Evidencia:** `its-renderers.js` `renderArtefactos` línea con `key === 'todas' ? ' active' : ''` (hardcoded).

**Severidad baja:** no rompe nada, pero requiere re-aplicar filtro.

**Propuesta mínima:** persistir filtro activo en variable módulo `_activeGrafoFilter` similar a `_activeSubTab`.

---

#### H-B2 · Inspector aparece como hijo del body, no del panel [código]

**Hallazgo:** `document.body.appendChild(backdrop/drawer)` en `openInspector`. El drawer NO es hijo del panel ITS sino del body global.

**Evidencia:** `panel-detail.js` función `openInspector`.

**Severidad baja:** funciona correctamente pero rompe encapsulamiento. Si el usuario cambia de unidad o sale del panel, el drawer queda huérfano en DOM hasta el siguiente click.

**Propuesta mínima:** `closeInspector` debería también ejecutarse cuando se cierra el panel principal · listener en `panel.classList.remove('open')`.

---

#### H-B3 · `mailto:` hardcoded para "Solicitar comuna" v1 [código]

**Hallazgo:** `index.html` línea 4953 tiene `window.open('mailto:max@xpu.cl?...')` hardcoded.

**Evidencia:** una sola ocurrencia · es del v1, no del ITS.

**Severidad baja:** no es de ITS · documenta como deuda v1 pre-existente.

**Propuesta mínima:** ninguna · está fuera del alcance de ITS.

---

#### H-B4 · Mezcla de hex literales y variables CSS en inspector [código]

**Hallazgo:** algunos colores del inspector usan hex directo (`background: #fff` en línea sticky header) en vez de variables CSS.

**Evidencia:** `index.html` bloque Fase P3, varias líneas.

**Severidad baja:** dificulta theming futuro.

**Propuesta mínima:** sustituir todos los hex por var. Tiempo: 10 minutos.

---

#### H-B5 · Profundidad del inspector vs profundidad del nodo [código]

**Hallazgo:** el inspector muestra `↧ profundidad N` para el artefacto seleccionado. Pero el badge del nodo en el grafo principal también lo muestra. Misma info, dos lugares.

**Evidencia:** `its-renderers.js` funciones `renderArtefactoNodo` y `renderArtefactoInspector`.

**Severidad baja:** redundancia esperada (drill-down). No es problema.

**Propuesta mínima:** ninguna · es información canónica que el usuario espera ver en ambos lugares.

---

#### H-B6 · Tipografía dual en inspector [código]

**Hallazgo:** secciones mono (Tipo, Fuente archivo) en JetBrains Mono · resto en sans-serif. Mezcla.

**Evidencia:** `index.html` clases `.its-inspector__valor.mono`.

**Severidad baja:** intencional (mono para identificadores técnicos), pero se siente fragmentado.

**Propuesta mínima:** ninguna · convención aceptable.

---

## 3 · Hallazgos que requieren validación en navegador (no verifiqué)

### N-1 · Responsive del drawer en mobile

`@media (max-width: 480px) { .its-inspector-drawer { width: 100vw; } }` está en CSS. **Confirmar en navegador real mobile:** ¿el header sticky del drawer permanece accesible al scrollear?

### N-2 · Scroll anidado

El drawer tiene `overflow-y: auto`. El panel también. Si el usuario abre inspector dentro del panel angosto, podría tener 2 scrolls anidados. **Confirmar UX visualmente.**

### N-3 · Tab "Artefactos · grafo" en mobile

El label es largo. Junto al badge fixture amarillo, en pantallas mobile el sub-tab probablemente se sale o se trunca. **Confirmar en navegador.**

### N-4 · Persistencia del filtro Artefactos al hacer click en nodo

Si filtro = "Derivación" + click en nodo VEL → abre inspector → cierra inspector → ¿filtro se mantuvo?

### N-5 · Visualización del grafo con 14 artefactos

Saturación visual potencial. Si crece a 30+ artefactos (cuando se carguen otros casos), el árbol vertical se hace inmanejable. **Verificar visualmente.**

---

## 4 · Resumen de severidades

| Severidad | Hallazgos | Tiempo estimado fix |
|---|---|---|
| ALTA | 3 (H-A1, H-A2, H-A3) | 1-2 horas |
| MEDIA | 6 (H-M1 a H-M6) | 2-3 horas |
| BAJA | 6 (H-B1 a H-B6) | 1 hora cosmética |
| Navegador (pendiente validación) | 5 (N-1 a N-5) | depende de tu inspección |

**Total deuda detectada por lectura:** ~15 hallazgos.

---

## 5 · Lo que el reporte NO encontró (verificable por lectura)

- ✅ No hay funciones export duplicadas (cada renderer es único)
- ✅ No hay TODOs/FIXMEs/HACKs pendientes en el código ITS
- ✅ No hay imports rotos (cross-check entre módulos OK · syntax check 7/7 OK)
- ✅ No hay URLs hardcoded a producción Supabase en módulos ITS
- ✅ Vocabulario de estados (`verificado`, `identificado`, `superseded`, etc.) coherente entre fixture, renderers, CSS
- ✅ El badge `fixture` advierte correctamente el estado epistemológico
- ✅ Los rollback paths siguen funcionando (`window.its._rollback()`)

---

## 6 · Recomendación de orden de fix (si decides aplicar)

1. **H-A1** (triple redundancia conflictos) · 30 min · evita bugs de desincronización futuros
2. **H-A2** (listener doble inspector) · 20 min · evita bugs de doble disparo
3. **H-A3** (`!important` CSS) · 20 min · reduce deuda CSS antes de crecer
4. **H-M2** (consoles residuales) · 15 min · limpieza simple
5. **H-M4** (badges acumulados nodo grafo) · 30 min · mejora cognitiva alta
6. **H-M5** (padres directos vs todas) · 30 min · arregla semántica del inspector
7. Resto puede esperar o agruparse en próximo sprint

**Total fix sugerido sprint hardening:** ~2 horas para H-A* y H-M2,M4,M5. El resto puede vivir con TODO documentado.

---

## 7 · Lo que NO se propone

- ✗ Nuevos sub-tabs
- ✗ Nuevos conceptos ontológicos
- ✗ Migrations SQL adicionales
- ✗ Conexión Supabase
- ✗ Workflows / persistencia / edición
- ✗ EPIC nuevos

Cumple instrucción explícita: solo estabilizar, no expandir.

---

## 8 · Próximo paso esperado

Tu decisión:

| Opción | Implicancia |
|---|---|
| A · Aplicar fixes ALTA (3 items) | 1-2 horas · sistema más sólido antes de crecer |
| B · Aplicar fixes ALTA + MEDIA (9 items) | 3-4 horas · hardening completo |
| C · Solo registrar reporte · postergar fixes | 0 tiempo · deuda documentada visible |
| D · Otra cosa (especificar) | — |

Mi recomendación: **A**. Las 3 ALTA son riesgos reales de regresión silenciosa. Las MEDIA pueden vivir un sprint más.
