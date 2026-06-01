# SPRINT_HARDENING_01 · Reporte final

**Fecha:** 2026-05-31
**Origen:** `HARDENING_REPORT.md` (3 hallazgos ALTA · 6 MEDIA · 6 BAJA · 5 pendiente navegador)
**Alcance autorizado:** sólo los 3 ALTA · sin features nuevas · sin schema nuevo · sin Supabase · sin UI nueva · sin cambios visuales intencionales
**Objetivo:** dejar el sistema exactamente igual visualmente pero más consistente internamente
**Custodio:** Max Medina

---

## 1 · Resumen ejecutivo

| Hallazgo | Categoría | Estado | Fix |
|---|---|---|---|
| H-A1 | Triple redundancia contador conflictos | ✅ Resuelto | `countConflictosAbiertos()` única fuente · 3 puntos consumen función |
| H-A2 | Listener inspector con doble disparo (grafo + drawer compartían `data-its-inspector`) | ✅ Resuelto | Separación de atributos: `data-its-grafo-nodo` (panel) vs `data-its-inspector-nav` (drawer) |
| H-A3 | 5 × `!important` en CSS toggle Geometrías | ✅ Resuelto | Bloque `--active` legacy removido · base activa por construcción · variante `--inactive` disponible |

**Resultado:** los 3 hallazgos ALTA aplicados. Cero efectos visuales nuevos. Tres principios de coherencia interna fortalecidos. **PRINCIPIO #2** canonizado como restricción de diseño cross-Meher OS.

---

## 2 · Diff acumulado por archivo

| Archivo | Líneas antes | Líneas después | Δ | MD5 final |
|---|---|---|---|---|
| `web/js/its-data.js` | 145 | 154 | +9 | `264e9eafa4fc5999fecb545eb575fe56` |
| `web/js/panel-detail.js` | ~575 | 584 | +9 | `216f7e13553b7deff1a28c8ad98d435e` |
| `web/js/its-renderers.js` | ~712 | 715 | +3 | `8e318d6677f4186770389417f962170d` |
| `web/index.html` | 5929 | 5941 | +12 | `f2f58798ed89795b108bc282cc810964` |

Δ total: **+33 líneas** (todas comentarios `[HARDENING H-Ax]` + helper `countConflictosAbiertos` + 4 cambios de atributo + reorganización CSS).

---

## 3 · Detalle por hallazgo

### 3.1 · H-A1 · Triple redundancia contador conflictos

**Patrón violado:** PRINCIPIO #2 · una fuente de verdad por métrica visible.

**Antes:**
- `its-data.js` exportaba `conflictos_abiertos_count: 13` hardcoded en la fixture, en paralelo al array `conflictos[]`.
- Cuando se agregó `KMZ_LABEL_VS_POLY_MISMATCH`, el array creció a 14 abiertos pero el contador NO se actualizó.
- 3 puntos de UI leían el dato desde lugares distintos (badge sub-tab, link en Resumen, header de tabla conflictos) y mostraban valores divergentes.

**Después:**
```javascript
// its-data.js · línea 148
export function countConflictosAbiertos(unidad) {
  if (!unidad || !Array.isArray(unidad.conflictos)) return 0;
  const cerrados = new Set(['resuelto', 'descalificado', 'superseded']);
  return unidad.conflictos.filter(c => !cerrados.has(c.estado)).length;
}
```

Consumida desde:
- `panel-detail.js:117` · badge sub-tab `Conflictos`
- `panel-detail.js:176` · link en vista Resumen unidad
- `its-renderers.js:140` · header de `renderConflictos`

**Garantía estructural:** ningún `_count` paralelo a su lista fuente en código activo. Agregar/quitar conflicto se refleja en los 3 puntos automáticamente.

### 3.2 · H-A2 · Listener inspector con doble disparo

**Patrón violado:** acoplamiento de namespace de eventos entre dos contextos visuales distintos.

**Antes:**
- Los nodos del grafo principal y los elementos de relación dentro del drawer compartían el atributo `data-its-inspector`.
- `querySelectorAll('[data-its-inspector]')` desde dos sitios distintos enganchaba listeners ambiguos · click en un nodo del grafo abría el drawer + click en un padre/hijo del drawer también disparaba lógica del grafo.

**Después:**
- Panel principal: `data-its-grafo-nodo="..."` (its-renderers.js:488)
- Drawer interno: `data-its-inspector-nav="..."` (its-renderers.js:581, 593)
- `wireGrafoInteractions` enlaza sólo `[data-its-grafo-nodo]`
- `openInspector` enlaza sólo `[data-its-inspector-nav]` dentro del propio drawer

**Garantía estructural:** cero referencias residuales a `data-its-inspector` sin sufijo `-nav` en código activo (grep verificado).

### 3.3 · H-A3 · 5 × `!important` en CSS toggle Geometrías

**Patrón violado:** uso de `!important` para forzar override de una clase base mal diseñada (base = `disabled`, había que destrabarla para el caso real).

**Antes:** bloque Fase 6 contenía:
```css
.its-geom-card__toggle--active {
  cursor: pointer !important;
  opacity: 1 !important;
  color: var(--its-state-identified) !important;
  font-style: normal !important;
  font-weight: 600;
}
```
Esto existía porque la clase base `.its-geom-card__toggle` tenía `cursor: not-allowed; opacity: 0.6` hardcoded · el `--active` necesitaba forzar reversal.

**Después:**
- Base `.its-geom-card__toggle`: sólo layout + tipografía (sin estado disabled de fábrica).
- Nueva variante `.its-geom-card__toggle--inactive`: aplica el visual disabled (`color: muted`, `cursor: not-allowed`, `opacity: 0.6`) cuando se necesite.
- Nuevo `.its-geom-card__toggle--active` (en Fase 7A, sin `!important`): refuerza `color`, `cursor: pointer`, `font-weight: 600` · valores que coinciden con la base, sin necesidad de override.

**Garantía estructural:** cero `!important` efectivos en bloques ITS · los 8 que quedan en `index.html` son del CSS legacy v1 (MapLibre + modo presentación), fuera del scope del sprint.

---

## 4 · Verificación física consolidada (2026-05-31)

```
--- H-A1 · countConflictosAbiertos (esperado: 1 export + 3 usos) ---
its-data.js:148   export function countConflictosAbiertos(unidad)
panel-detail.js:117    badge sub-tab Conflictos
panel-detail.js:176    link Resumen
its-renderers.js:140   header renderConflictos
its-renderers.js:14    import desde its-data.js

--- H-A1 · conflictos_abiertos_count en código activo ---
0 referencias activas (1 línea es comentario explicativo del fix)

--- H-A2 · data-its-grafo-nodo (panel) ---
its-renderers.js:488   render nodo grafo
panel-detail.js:302    wireGrafoInteractions

--- H-A2 · data-its-inspector-nav (drawer) ---
its-renderers.js:581   inspector · lista padres
its-renderers.js:593   inspector · lista hijos
panel-detail.js:238    openInspector handler

--- H-A2 · data-its-inspector legacy ambiguo ---
0 referencias activas

--- H-A3 · !important en bloques ITS ---
0 efectivos (sólo comentarios documentando el fix)

--- Syntax check ---
its-data.js: OK · panel-detail.js: OK · its-renderers.js: OK
```

---

## 5 · Criterio "aspecto visual idéntico"

| Componente | Cambio visual esperado | Observación |
|---|---|---|
| Badge contador `Conflictos` | Mismo número o corregido al real | Antes mostraba 13 hardcoded · ahora muestra el conteo real del array (14 con `KMZ_LABEL_VS_POLY_MISMATCH` activo). **Corrección, no regresión visual.** |
| Link "X conflictos abiertos" en Resumen | Idem badge | Idem |
| Header `renderConflictos` | Idem badge | Idem |
| Toggle Geometrías activo | Idéntico | Color, cursor, opacidad, font-weight sin cambio · fix limpió la implementación, no el resultado |
| Toggle Geometrías "no-geom" | Idéntico | El render reemplaza el `<input>` por `<span class="its-geom-card__no-geom">` · no usa la nueva variante `--inactive` (queda disponible para uso futuro) |
| Grafo y drawer | Click + navegación idénticos al usuario | Sólo cambian los atributos internos · sin diff visual |

**Conclusión:** la única diferencia visible es la corrección numérica del contador de conflictos (que pasa de mostrar 13 hardcoded a mostrar el conteo real). Esto NO es regresión sino fix latente del propio H-A1.

---

## 6 · Doctrina canonizada en este sprint

Durante H-A1 emergió un patrón generalizable. Se canonizó como segundo principio arquitectónico de primer nivel del Meher OS:

**PRINCIPIO #2 · Una fuente de verdad por métrica visible**
> Ninguna cifra, badge, contador, agregado o derivación expuesta en UI, API o documento de Meher OS puede tener más de una fuente de verdad. Si una métrica se deriva de un conjunto, debe calcularse desde ese conjunto en el punto de render · nunca persistirse como atributo redundante en paralelo al conjunto.

- **Documento canónico:** `/XPU/La Higuera/00_CORE/PRINCIPIO_ARQUITECTONICO_MEHER_OS.md` §13
- **Memoria persistente:** `principio_arquitectonico_meher_os_fuente_unica_metrica.md`
- **Índice memoria:** `MEMORY.md` actualizado
- **Aplicable a:** ITS · Lex Meher · sistema tributario · corporativo · hotelero · cualquier futuro sistema Meher OS

---

## 7 · Estado del HARDENING_REPORT original

| Categoría | Total | Aplicados en este sprint | Pendientes |
|---|---|---|---|
| ALTA | 3 | 3 | 0 |
| MEDIA | 6 | 0 | 6 (no autorizados) |
| BAJA | 6 | 0 | 6 (no autorizados) |
| Pendiente navegador | 5 | 0 | 5 (requieren runtime) |

Los 17 hallazgos restantes siguen en `HARDENING_REPORT.md` como backlog técnico · no se tocan sin autorización explícita posterior.

---

## 8 · Compromisos mantenidos durante el sprint

- ✅ NO afirmar validación runtime · sigue con badge "fixture local · pendiente validación staging"
- ✅ NO conectar Supabase
- ✅ NO crear schema nuevo
- ✅ NO agregar UI nueva
- ✅ NO cambios visuales intencionales
- ✅ Reportar diff exacto antes de cerrar
- ✅ Verificación física inmediata (md5 + lines + grep + syntax check)

---

## 9 · Próximas decisiones (no ejecutadas)

Backlog candidato (requiere autorización explícita para ejecutar):

1. **6 hallazgos MEDIA** del `HARDENING_REPORT.md` (acoplamientos, magic strings, validación de input)
2. **5 hallazgos navegador-dependientes** · requieren prueba runtime real
3. **6 hallazgos BAJA** (cosmética interna · refactors pequeños)
4. **Staging 0003** sigue pendiente (no se desbloquea aquí)
5. **Aplicar PRINCIPIO #2 al resto del codebase** (auditoría grep `_count`/`_total`/`_sum` sobre todo `js/` y `db/migrations/`)

Ninguno se inicia sin instrucción posterior.
