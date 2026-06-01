# Plan Técnico · Esqueleto Magnus Radar v0.3

**Fecha:** 2026-05-31
**Custodio:** Max Medina
**Estrategia adoptada (Max):** esqueleto completo de navegación + 8 sub-tabs (algunos con datos hardcoded) ANTES de optimizar detalles de cada tab.
**Mandato:** definir contrato técnico de implementación antes de tocar el monolito de 4.998 líneas. NO codear todavía.

---

## 1 · Objetivo del esqueleto v0.3

Validar la **arquitectura completa de navegación e información** del v0.3 integrado antes de pulir contenido de cada sub-tab.

**Qué debe demostrar el esqueleto:**

- Breadcrumb 3-niveles (Territorio → Unidad → Predio) funcionando con datos reales de Hijuela 2
- URL state predio↔unidad↔territorio con deep-linking real
- Los 8 sub-tabs visibles cuando aplican, ocultos cuando no
- Drill-down del chip "estado epistemológico" desde Resumen → sub-tab Conflictos
- Toggle de geometrías G1-G4 sobre el mapa principal
- Sidebar con bloque "Unidades territoriales registradas"
- Capa nueva "Estado de conciliación" toggleable
- Sub-tabs con esqueletos de contenido (no perfección estética todavía)

**Qué NO debe pulir todavía el esqueleto:**

- Diseño visual fino de cada sub-tab
- Drawers de detalle al click en cada elemento
- Funciones disciplinadas conectadas (eso requiere staging Supabase activo)
- Animaciones / transiciones
- Mobile UX completa (solo desktop primero)

---

## 2 · Cambios técnicos al repositorio actual

### 2.1 · Estado actual del frontend

```
magnus-radar/web/
├── index.html              ← 4.998 líneas (monolito v1 actual)
├── index-demo.html         ← 3.7 MB (versión offline · sin cambios)
└── og-cover.{png,svg}      ← assets
```

### 2.2 · Estado post-esqueleto v0.3

```
magnus-radar/web/
├── index.html              ← ~4.998 + N líneas (extiende, no reemplaza)
├── index-demo.html         ← sin cambios
├── og-cover.{png,svg}      ← sin cambios
└── js/                     ← NUEVO · módulos extraídos
    ├── panel-detail.js     ← orquestador panel derecho v0.3
    ├── its-renderers.js    ← funciones de render por sub-tab
    ├── state-badges.js     ← sistema universal de estados
    ├── authority-utils.js  ← helpers matriz de autoridad
    └── its-data.js         ← fixture Hijuela 2 (mientras no haya Supabase)
```

**Decisión:** módulos ES nativos importados desde index.html via `<script type="module">`. Sin bundler. Sin framework. Consistente con stack v1.

**Razón:** mantener el monolito index.html como entry point (preserva URL actual, deploy, cache headers) y extraer SOLO lo nuevo del v0.3 a módulos. No refactorizar el v1 ya funcional.

---

## 3 · Los 5 archivos JS nuevos en detalle

### 3.1 · `js/panel-detail.js`

**Responsabilidad:** orquestar el panel derecho cuando se selecciona una entidad con ontología ITS.

**Exporta:**

```js
export function mountPanelDetail({ entityType, entityId }) { ... }
// entityType: 'predio' | 'unidad' | 'territorio'
// entityId:   string (rol, codigo_unidad, codigo_territorio)
// Resuelve qué sub-tabs mostrar, renderiza breadcrumb, monta el sub-tab activo
```

```js
export function detectEntityFromFeature(mapFeature) { ... }
// Recibe feature MapLibre clickeada
// Devuelve { entityType, entityId, hasUnit, hasTerritory }
// Hace lookup en its-data.js para detectar pertenencia a unidad
```

**Tamaño estimado:** 150-200 líneas.

### 3.2 · `js/its-renderers.js`

**Responsabilidad:** funciones puras `renderXxx(data) → HTMLString` para cada sub-tab.

**Exporta:**

```js
export const renderers = {
  resumen:       (entity) => htmlString,
  superficies:   (entity) => htmlString,
  autoridades:   (entity) => htmlString,
  conflictos:    (entity) => htmlString,
  geometrias:    (entity) => htmlString,
  cadena:        (entity) => htmlString,
  hipotesis:     (entity) => htmlString,
  evidencia:     (entity) => htmlString
};

export function shouldShowSubTab(subTab, entity) { ... }
// Decide visibilidad adaptiva según condiciones definidas en mockup §12
```

**Tamaño estimado:** 350-450 líneas.

### 3.3 · `js/state-badges.js`

**Responsabilidad:** sistema universal de estados disciplinados.

**Exporta:**

```js
export const STATES = {
  verificado:                       { icon: '✓', label: 'verificado',                cls: 'state--verified',   tooltip: '...' },
  identificado:                     { icon: '◉', label: 'identificado',              cls: 'state--identified', tooltip: '...' },
  localizado_pendiente_extraccion:  { icon: '⏳', label: 'localizado',                cls: 'state--pending',    tooltip: '...' },
  parcialmente_verificado:          { icon: '◐', label: 'parcial',                   cls: 'state--partial',    tooltip: '...' },
  hipotesis_de_trabajo:             { icon: '◇', label: 'hipótesis',                 cls: 'state--hypothesis', tooltip: '...' },
  conflicto_documentado:            { icon: '⚠', label: 'conflicto',                 cls: 'state--conflict',   tooltip: '...' },
  superseded:                       { icon: '⊘', label: 'superseded',                cls: 'state--superseded', tooltip: '...' },
  descalificado:                    { icon: '✗', label: 'descalificado',             cls: 'state--disqualified', tooltip: '...' }
};

export function badge(estado) { return `<span class="state ${STATES[estado].cls}" title="${STATES[estado].tooltip}">${STATES[estado].icon} ${STATES[estado].label}</span>`; }
```

**Tamaño estimado:** 80-120 líneas. Reutilizable en TODO el index.html, no solo en v0.3.

### 3.4 · `js/authority-utils.js`

**Responsabilidad:** lógica de matriz de autoridad y helpers de capas temporales.

**Exporta:**

```js
export function groupByCapa(autoridades) { ... }
export function groupByDominio(autoridades) { ... }
export function getAuthorityForDomain(entity, dominio) { ... }
export function buildAuthorityMatrix(entity) { ... }
```

**Tamaño estimado:** 80-120 líneas.

### 3.5 · `js/its-data.js`

**Responsabilidad:** fixture de Hijuela 2 + helpers de lookup mientras no haya conexión Supabase REST a tablas `its.*`.

**Exporta:**

```js
export const ITS_FIXTURE = {
  territorios: [{ codigo: 'estancia_la_higuera', ... }],
  unidades: [{ codigo: 'hijuela_2_cominetti', roles_sii: ['24-123','24-160'], ... }],
  predios_to_unidad: { '24-123': 'hijuela_2_cominetti', '24-160': 'hijuela_2_cominetti' },
  // resto del shape de data.js de its.html v0
};

export async function getEntity(type, id) { ... }
// Mientras hardcoded: lookup en ITS_FIXTURE
// Después: query a Supabase REST its.*
```

**Tamaño estimado:** 250-300 líneas (incluye fixture completo).

**Transición a Supabase:** cuando staging esté activo, se sustituye el cuerpo de `getEntity()` por fetch REST. Las renderers no se enteran del cambio.

---

## 4 · Cambios al `index.html` actual

### 4.1 · Imports en `<head>`

Agregar UN solo `<script type="module">` al final del body:

```html
<script type="module" src="js/its-bootstrap.js"></script>
```

`its-bootstrap.js` es un sexto archivo mínimo que conecta los módulos al window y se engancha al ciclo de selección de features ya existente.

### 4.2 · Hooks en código existente

Identificar puntos exactos del index.html donde:

- Se llama `selectPredio(feature)` → hook para detectar si pertenece a unidad
- Se renderiza `renderPredioPanel(p, isHijuela2)` → reemplazar por `mountPanelDetail()` cuando la entidad tiene ontología ITS
- Se renderiza la sidebar de capas → agregar bloque "Unidades territoriales"
- Se construye URL state → agregar parámetros `?u=` y `?p=` y `?t=`

**Aproximación:** wrapper functions sobre las existentes (como ya está hecho con `origSelectPredio` en línea 4534 del index.html). NO reemplazar las funciones del v1; añadir un hook posterior.

### 4.3 · CSS

Agregar al `<style>` existente del index.html:

- Variables CSS con los 8 colores de estados (migrados desde `its/theme.css`)
- Clases `.state--verified`, `.state--conflict`, etc.
- Clases para los nuevos sub-tabs
- Clases para el breadcrumb
- Clases para el chip "modo lectura" si se adopta

**Tamaño estimado:** +150-250 líneas al `<style>` actual.

---

## 5 · URL state schema completo

### 5.1 · Parámetros

```
#map=Z/Y/X            ← mapa state (ya existe en v1)
&p=24-123             ← predio seleccionado (nuevo)
&u=hijuela_2_cominetti ← unidad seleccionada (nuevo)
&t=estancia_la_higuera ← territorio (futuro, post-v0.3)
&tab=conflictos       ← sub-tab activo del panel (nuevo)
&l=g1,g4              ← geometrías visibles toggleables (nuevo)
```

### 5.2 · Reglas

- `p` y `u` mutuamente excluyentes (uno u otro, no ambos)
- `tab` solo válido si hay `p` o `u`
- `l` solo válido si hay `u` con representaciones
- Si URL tiene `u=hijuela_2_cominetti` pero la unidad no existe en data → fallback a `p` del primer rol asociado, o vacío

### 5.3 · Migración del URL state actual

El v1 ya tiene URL state con `?tab=`. El esquema nuevo lo extiende. Compatibilidad hacia atrás obligatoria.

---

## 6 · Comportamiento de navegación 3-niveles

### 6.1 · Caso típico

1. Usuario abre `https://...index.html` sin parámetros → estado vacío como hoy
2. Click en polígono rol 24-123 → URL → `?p=24-123&tab=resumen`
3. Panel muestra breadcrumb: `Estancia La Higuera ▸ Hijuela 2 ▸ Rol 24-123`
4. Panel muestra sub-tabs: `Resumen | Evidencia` (predio simple desde su perspectiva)
5. Header del panel muestra chip "📍 Parte de Hijuela 2 Cominetti · [Ver unidad →]"
6. Click en chip → URL → `?u=hijuela_2_cominetti&tab=resumen`
7. Panel cambia a vista unidad, breadcrumb: `Estancia La Higuera ▸ Hijuela 2`
8. Sub-tabs ampliados: `Resumen | Superficies | Autoridades | Conflictos (13)⚠ | Geometrías | Cadena | Hipótesis ◇ | Evidencia`
9. Click en breadcrumb "Estancia La Higuera" → URL → `?t=estancia_la_higuera` → vista territorio (post-v0.3, placeholder ahora)
10. Click en breadcrumb "Hijuela 2" desde vista predio → equivalente al chip → URL → `?u=hijuela_2_cominetti`

### 6.2 · Navegación browser

- Back/forward del navegador funciona naturalmente (URL hash change)
- Refresh preserva contexto
- Compartir URL preserva estado completo

---

## 7 · Riesgos de tocar el monolito index.html

| Riesgo | Mitigación |
|---|---|
| Romper `selectPredio()` existente al añadir hook | Usar patrón wrapper como ya hace v1 con `origSelectPredio` línea 4534 |
| Romper renderizado de SEIA / áreas / ofertas al cambiar panel | Mantener funciones `showSeia()` `showOferta()` etc. intactas; solo enriquecer `renderPredioPanel()` |
| Romper URL state existente | Detectar parámetros nuevos sin tocar los actuales |
| Romper capas MapLibre al añadir toggles de geometrías | Las nuevas capas se agregan al map cuando se activan, no en bootstrap |
| Romper i18n es/en | Los strings nuevos se agregan al diccionario existente |
| Inflar index.html de 4.998 a 6.500+ líneas | La mayoría del código nuevo va a `js/*.js`, NO al index.html |
| Conflicto entre módulos ES y código vanilla del index.html | `js/its-bootstrap.js` hace el puente: imports módulos, expone a `window.its` |

**Compromiso:** **CERO modificaciones que rompan funcionalidad v1**. Si algo se rompe en validación, rollback inmediato.

---

## 8 · Plan de rollback

Si algo sale mal en cualquier punto:

```bash
# Rollback del esqueleto v0.3 (preserva v1 100% funcional):
cd magnus-radar/web/
rm -rf js/                      # elimina módulos nuevos
# Revertir cambios al index.html (3 cambios menores):
#  - quitar <script type="module" src="js/its-bootstrap.js">
#  - quitar hooks de panel-detail
#  - quitar CSS de estados nuevos
git diff index.html | patch -R    # si está en git
```

**v1 sigue funcionando porque NO se reemplazó nada del código existente. Solo se agregaron hooks externos.**

---

## 9 · Orden de implementación propuesto (esqueleto v0.3)

**Fase 0 · Preparación**
- Confirmar dirección (este documento)
- Verificar que index.html actual está committeado a git
- Crear branch `v0.3-skeleton` si trabajas con git

**Fase 1 · Infraestructura mínima** (~1-2 horas)
1. Crear `js/state-badges.js` — vocabulario universal
2. Crear `js/its-data.js` con fixture Hijuela 2 + helper `getEntity()`
3. Crear `js/its-bootstrap.js` minimal
4. Agregar variables CSS de estados al `<style>` del index.html
5. Validar que index.html abre sin errores en consola

**Fase 2 · Hook de detección unidad** (~1 hora)
1. Wrapper sobre `selectPredio()` para detectar `predios_to_unidad`
2. Renderizar chip "📍 Parte de Hijuela 2" si aplica
3. URL state: agregar `?u=` y `?p=` al hash
4. Validar: click en rol 24-123 muestra chip, click en chip cambia URL a `?u=`

**Fase 3 · Breadcrumb 3-niveles** (~1 hora)
1. Crear `js/panel-detail.js` con `mountPanelDetail()`
2. Renderizar breadcrumb en el top del panel derecho
3. Click en breadcrumb navega entre niveles
4. Validar: navegación bidireccional predio↔unidad↔territorio funciona

**Fase 4 · Sub-tabs adaptivos** (~2 horas)
1. Crear `js/its-renderers.js` con esqueletos de los 8 renderers
2. Lógica de visibilidad adaptiva (`shouldShowSubTab`)
3. Renderers devuelven HTML mínimo (no contenido pulido todavía)
4. Validar: Hijuela 2 muestra 8 sub-tabs, predio simple muestra 2

**Fase 5 · Drill-down chip + geometrías mapa** (~1 hora)
1. Chip epistemológico del Resumen es clickeable → tab Conflictos
2. Toggle de geometrías agrega/quita capas MapLibre
3. Validar: drill-down funciona, geometrías se muestran sobre mapa

**Fase 6 · Sidebar enriquecido** (~30 min)
1. Bloque "Unidades territoriales registradas" en sidebar
2. Capa "Estado de conciliación" toggleable
3. Validar: ambos elementos funcionan

**Total estimado:** 6-7 horas de implementación, con validación tuya entre fases.

**No incluye:** pulir contenido visual de cada sub-tab (eso viene después).
**No incluye:** conectar Supabase REST (eso es cuando staging esté activo).

---

## 10 · Validación tuya entre fases

Después de cada Fase del orden propuesto, abrir index.html en navegador y verificar el checklist específico. Si algo falla → no avanzar, corregir o hacer rollback.

**Validaciones críticas del esqueleto completo:**

1. **v1 sigue funcionando idéntico.** Catastro, SEIA, alertas, DGA, todo. Ninguna regresión.
2. **Click en rol 24-123 muestra chip "Parte de Hijuela 2".**
3. **Click en chip cambia URL a `?u=hijuela_2_cominetti` y muestra los 8 sub-tabs.**
4. **Click en rol que NO es Cominetti NO muestra chip ni sub-tabs ITS.**
5. **Refresh navegador con URL `?u=hijuela_2_cominetti` reabre vista unidad.**
6. **Breadcrumb es clickeable y funcional.**
7. **Toggle de geometrías G1-G4 dibuja contornos sobre el mapa principal.**
8. **Sub-tab "Conflictos" muestra los 13 (esqueleto, no pulido).**
9. **Chip "13 conflictos abiertos" del Resumen lleva al sub-tab Conflictos.**

Si las 9 validaciones pasan → esqueleto v0.3 funcional. Recién entonces se puede iterar contenido de cada sub-tab.

---

## 11 · Decisiones técnicas explícitas

### 11.1 · Sí usar módulos ES (`type="module"`)

Razón: el v0 ya demostró que funcionan en navegadores modernos. Magnus es uso interno con browsers actualizados. Sin bundler.

### 11.2 · NO usar React/Vue/framework

Razón: consistencia con stack v1. El monolito de 4.998 líneas es vanilla. Mezclar React con vanilla en el mismo HTML es deuda técnica que el equipo no necesita asumir hoy.

### 11.3 · NO refactorizar el monolito v1

Razón: el v1 funciona. Refactorizarlo sin razón operacional es riesgo gratis. La modularización viene cuando index.html supere ~6.500 líneas Y haya razón concreta (mantenibilidad imposible, performance, equipo más grande). Hoy no aplica.

### 11.4 · SÍ extraer todo lo nuevo a `js/*.js`

Razón: el nuevo código del v0.3 NO se mezcla con el monolito v1. Vive en módulos separados. Reduce el riesgo de tocar lo que funciona.

### 11.5 · Hardcoded fixture mientras no haya Supabase staging

Razón: el esqueleto valida arquitectura, no la conexión backend. Cuando staging esté ejecutado, se sustituye 1 función (`getEntity()`) y todo lo demás sigue igual.

### 11.6 · CSS inline en index.html (no archivo separado)

Razón: consistencia con v1. Si en algún momento se separa, se hace para todo el `<style>`, no solo el del v0.3.

---

## 12 · Qué este plan NO decide

1. Si la branch git se llama `v0.3-skeleton` o `feature/its-v0.3` o algo distinto
2. Si los commits se hacen por Fase (1-6) o uno solo al final
3. Si se despliega a GitHub Pages tras cada Fase o solo al final
4. Si se reemplaza el toggle SII-oficial existente por la nueva capa "Estado de conciliación" o si conviven
5. Si Hijuela 2 debe aparecer como "destacada" en el sidebar de unidades (es la única que hay)
6. Si el sub-tab "Cadena" reemplaza al tab "Eventos" actual del predio o coexisten

---

## 13 · Próximo paso post-aprobación de este plan

Si Max aprueba este plan técnico:

1. Comenzar Fase 1 · Infraestructura mínima
2. Reportar cada fase completada con validación
3. Si una validación falla → no avanzar, ajustar
4. Al completar Fase 6 → esqueleto v0.3 funcional
5. Entonces sí iterar contenido de cada sub-tab según orden Max (Superficies → Autoridades → ...)

**Lo que NO hago hasta tu aprobación de este plan:** crear ningún archivo en `js/`, tocar `index.html`, modificar CSS.

---

## 14 · Honestidad operacional

El plan parece largo. La razón: el monolito de 4.998 líneas es delicado. Cada cambio sin contrato técnico claro tiene riesgo de romper el v1 que ya funciona. Definir el contrato ahora cuesta 1 hora de lectura. Recuperar de una regresión cuesta horas y erosiona confianza.

**Si preferís ir directo a código sin este plan**, me decís y lo hago. Pero mi recomendación honesta es: aprobá el plan o ajustá lo que no te convence, y después codeamos sobre contrato sólido.
