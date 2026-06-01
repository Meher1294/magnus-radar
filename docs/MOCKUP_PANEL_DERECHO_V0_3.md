# Mockup Textual · Panel Derecho Magnus Radar v0.3

**Fecha:** 2026-05-31
**Custodio:** Max Medina
**Mandato:** mockup textual del panel derecho enriquecido. NO código.
**Dirección adoptada:** dictamen Magnus v0.3 integrado · orden Max para sub-tabs.

---

## 0 · Lo que NO cambia

- Layout de 3 columnas (sidebar izquierdo · mapa central · panel derecho)
- El mapa sigue siendo el centro de gravedad
- Click sobre feature en mapa → abre panel derecho (igual que hoy)
- Comportamiento mobile (drawer izquierdo + bottom sheet derecho)
- Tabs top (catastro · infra · agua · dominga · alertas · timeline · inmobiliaria · comparar · análisis · docs)
- Sidebar izquierdo (filtros + capas)
- Header (brand · search global · auth)

---

## 1 · Lo que cambia

| Elemento | Hoy | v0.3 |
|---|---|---|
| Panel-tabs internos predio | Resumen · Eventos · Documentos · Vecinos (4) | Resumen · Superficies · Autoridades · Conflictos · Geometrías · Cadena · Hipótesis · Documentos (8 max) |
| Chip "parte de unidad" en ficha | no existe | aparece cuando el predio pertenece a unidad multi-rol |
| Toggle entre vista predio ↔ vista unidad | no existe | switch en header de la ficha |
| Sub-tabs adaptivos | siempre los 4 | solo los que tienen datos para esa entidad |
| Vocabulario de estados | parcial (reconciliación) | universal con iconos + colores en cada elemento |
| Sidebar "Unidades territoriales registradas" | no existe | bloque nuevo con conteo conflictos por unidad |
| Capa mapa "Estado de conciliación" | no existe | toggle nuevo en sidebar |

---

## 2 · Predio simple vs Unidad territorial — cuándo se muestra cada uno

### Caso A · Predio simple (rol único, sin unidad asociada)

El usuario hace click sobre un polígono cualquiera del mapa. La mayoría de predios del proyecto (>99%) son simples — no pertenecen a ninguna unidad territorial registrada en `its.unidades_territoriales`.

Panel derecho muestra:
- Header del predio (rol + comuna + superficie SII)
- Sub-tabs: Resumen · Documentos (los demás se ocultan automáticamente)
- Sin chip de unidad

Comportamiento idéntico al Magnus actual. Cero fricción para el 99% de los casos.

### Caso B · Predio que pertenece a unidad territorial multi-rol

El usuario hace click sobre el rol 24-123 (parte de Hijuela 2 Cominetti).

Panel derecho muestra:
- Header del predio + **chip "📍 Parte de Hijuela 2 Cominetti · [Ver unidad →]"**
- Sub-tabs Resumen · Documentos (vista predio individual)

Si click en el chip → cambia a Caso C.

### Caso C · Unidad territorial completa

Vista enriquecida con TODOS los sub-tabs disponibles. El header cambia a la identidad de la unidad. El mapa puede destacar el polígono compuesto (suma de roles).

```
[← Volver al predio individual]
HIJUELA 2 COMINETTI                                    [Vista predio | Vista unidad ✓]
Roles SII 24-123 + 24-160 · Mandato Magnus 24m 10%

[Resumen] [Superficies] [Autoridades] [Conflictos] [Geometrías] [Cadena] [Hipótesis] [Documentos]
```

### Caso D · Feature no-predio (SEIA, área protegida, oferta, etc.)

Sin cambios respecto a Magnus actual. Los sub-tabs nuevos no aplican.

---

## 3 · Sub-tabs en orden de implementación

**Orden Max:** 1. Superficies → 2. Autoridades → 3. Conflictos → 4. Geometrías → 5. Cadena → 6. Hipótesis

Cada uno desarrollado abajo, en ese orden.

---

## 4 · Sub-tab 1 · SUPERFICIES POR CAPA

**Cuándo se muestra:** cuando la entidad seleccionada tiene >1 superficie registrada en `its.superficies` (caso unidad) o tiene datos de reconciliación catastral (caso predio individual).

**Cuándo se oculta:** predio simple sin datos extra.

### Layout dentro del panel derecho

```
┌─────────────────────────────────────────────────┐
│ Superficies por capa                            │
│ No existe superficie única.                     │ ← subtítulo pedagógico
│ Cada cifra pertenece a una capa con autoridad.  │
│                                                 │
│ ┌─────────────────────────────────────────────┐ │
│ │ 2.642        ha   ✓ verificado              │ │ ← card horizontal compacta
│ │ HISTÓRICA · 1990 · CBR fs.97 N°91/1990      │ │   (NO grid 5 columnas como ITS v2)
│ └─────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────┐ │
│ │ 2.139,35     ha   ✓ verificado              │ │
│ │ JURÍDICA · 2017 · Estudio títulos           │ │
│ │ Resto A 863 + Resto B 976,35 + Lote C 300   │ │
│ └─────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────┐ │
│ │ 2.164,97     ha   ✓ verificado              │ │
│ │ RTK · 2026 · Daniel Magnus · ±10m UTM 19S   │ │
│ └─────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────┐ │
│ │ 1.800        ha   ✓ verificado              │ │
│ │ MANDATO · 2026 · Rep. 24.327                │ │
│ └─────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────┐ │ ← card conflicto (rojo)
│ │ ⚠ CONFLICTO                                 │ │
│ │ 26,41 ha (DI BQ) / 2.640,93 ha (DD)         │ │
│ │ FISCAL · SII · pendiente sii_directo        │ │
│ │ → Acción: consulta mapas.sii.cl             │ │
│ └─────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────┘
```

**Diferencia con ITS v2 separado:** cards horizontales una debajo de otra (no grid 5-col), porque el panel derecho es ~360px de ancho. La cifra grande sigue siendo prominente pero acompañada de label y fuente.

**Comportamiento:**
- Click en card → drawer overlay con detalle completo (valores observados, evidencia, autoridad, historial)
- Hover en card → tooltip con composición si aplica
- Card de conflicto siempre se renderiza al final (no se oculta)

**Datos consumidos:**
- `its.superficies` filtradas por `unidad_id` o `rol_sii` según el caso
- `its.conflictos` para enlazar conflicto fiscal con su card

---

## 5 · Sub-tab 2 · AUTORIDADES

**Cuándo se muestra:** cuando hay >=3 registros en `its.autoridades` para la entidad. Menos de 3 dominios no justifica un sub-tab dedicado.

**Cuándo se oculta:** predio simple sin matriz de autoridad cargada.

### Layout

```
┌─────────────────────────────────────────────────┐
│ Matriz de autoridad                             │
│ Quién manda en cada dominio.                    │
│                                                 │
│ ┌─────────────────────────────────────────────┐ │
│ │ DOMINIO          AUTORIDAD       ESTADO     │ │
│ ├─────────────────────────────────────────────┤ │
│ │ Rol SII          SII oficial     ✓          │ │
│ │ Avalúo           SII oficial     ✓          │ │
│ │ Contribuciones   SII oficial     ✓          │ │
│ │ Sup. fiscal      SII directo     ⚠ pend.    │ │
│ │ Cabida jurídica  Estudio títulos ✓          │ │
│ │ Geom. jurídica   Plano N°377-06  ⏳ local.  │ │
│ │ Geom. operac.    RTK Daniel 2026 ✓          │ │
│ │ Geom. histórica  Plano MBN IV-1  ◉ ident.   │ │
│ │ Infraestructura  KMZ DataRoom    ✓          │ │
│ │ Servidumbres     CBR La Serena   ◐ parcial  │ │
│ │ Contexto envolv. Andes Iron      ✓          │ │
│ │ Mandato          Rep. 24.327     ✓          │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
│ [Agrupar por capa temporal] [Ver historial]    │ ← toggles opcionales
└─────────────────────────────────────────────────┘
```

**Comportamiento:**
- Hover en estado → tooltip con definición ("identificado: existe y se sabe cuál es; falta extracción completa")
- Click en fila → drawer con detalle (capa temporal, vigente desde/hasta, documentos de evidencia, notas)
- Toggle "Agrupar por capa" → reordena por columna oculta `capa_temporal` (capa 1 histórica primero, capa 7 fiscal al final)
- Toggle "Ver historial" → muestra autoridades superseded (las que cambiaron en el tiempo)

**Datos consumidos:**
- `its.autoridades` con join a `its.fuentes` para mostrar tipo de fuente
- `its.estado_changes_log` para historial (opcional)

---

## 6 · Sub-tab 3 · CONFLICTOS

**Cuándo se muestra:** cuando hay >=1 conflicto abierto (`estado IN ('conflicto_documentado', 'hipotesis_de_trabajo', 'localizado_pendiente_extraccion', 'parcialmente_verificado')`) en `its.conflictos` para la entidad.

**Cuándo se oculta:** sin conflictos registrados.

**Badge en el sub-tab:** muestra count con color (ej: "Conflictos · 13 ⚠"). Indica al usuario que hay trabajo pendiente sin tener que entrar.

### Layout

```
┌─────────────────────────────────────────────────┐
│ Conflictos abiertos                             │
│ 6 visibles · 13 totales · ordenados severidad   │
│                                                 │
│ [Todos] [Alta] [Media] [Baja] [Por autoridad ▼]│ ← filtros chips
│                                                 │
│ ┌─────────────────────────────────────────────┐ │
│ │ ⚠ ALTA                                      │ │
│ │ SII_SURFACE_FACTOR_100                      │ │ ← code mono
│ │ Factor 100 entre DI BQ y DD                 │ │
│ │ autoridad: SII directo                      │ │
│ │ acción: consulta mapas.sii.cl rol 24-123    │ │
│ └─────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────┐ │
│ │ ◐ MEDIA                                     │ │
│ │ GAP_PLANO_22_1990                           │ │
│ │ Anexo CBR localizado · pendiente extracción │ │
│ │ autoridad: CBR La Serena                    │ │
│ │ acción: solicitud copia certificada         │ │
│ └─────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────┐ │
│ │ ◐ MEDIA                                     │ │
│ │ GAP_VENTA_VELASQUEZ_PRE_1996                │ │
│ │ Estado: hipótesis de trabajo                │ │
│ │ ...                                         │ │
│ └─────────────────────────────────────────────┘ │
│ [Ver los 7 conflictos restantes ↓]              │
│                                                 │
│ ─────────────────────────────────────────────── │
│ Resueltos recientemente (4)                     │ ← colapsable
│ [Expandir ↓]                                    │
└─────────────────────────────────────────────────┘
```

**Comportamiento:**
- Click en conflicto → drawer con detalle: valores observados (JSONB renderizado), documentos de evidencia, historia de cambios, botón "Marcar como resuelto" (que invoca `its.resolve_conflicto()` y exige documento de evidencia primaria)
- Filtros chips → recargan la lista in-place
- Click en "Marcar como resuelto" sin documento → modal pidiendo evidencia primaria, no permite cerrar sin ella
- Audit log automático del cambio de estado

**Datos consumidos:**
- `its.conflictos` filtrada por unidad
- `its.documentos_evidencia` para evidencia asociada
- `its.estado_changes_log` para historial

---

## 7 · Sub-tab 4 · GEOMETRÍAS

**Cuándo se muestra:** cuando hay >=2 representaciones en `its.representaciones_geometricas` para la unidad. Una sola geometría no necesita sub-tab.

**Cuándo se oculta:** predio simple con geometría única.

### Layout

```
┌─────────────────────────────────────────────────┐
│ Representaciones geométricas                    │
│ 4 concurrentes · ninguna sobrescribe a otra     │
│                                                 │
│ ┌─────────────────────────────────────────────┐ │
│ │ G1  ◉ identificado          [👁 mostrar]    │ │ ← card más compacta que ITS v2
│ │ Plano MBN IV-1-1777-S.R.                    │ │
│ │ 1990 · histórica · 2.642 ha                 │ │
│ │ cuerpo extraído · cajetín pendiente         │ │
│ └─────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────┐ │
│ │ G2  ⏳ pendiente            [👁 mostrar]    │ │
│ │ Plano N°531/1992                            │ │
│ │ 1992 · jurídica · 1.163 ha                  │ │
│ │ subdivisión Lote A: Lote C 300 + Resto 863  │ │
│ └─────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────┐ │
│ │ G3  ⊘ superseded            [👁 mostrar]    │ │ ← opacidad 60%
│ │ DataRoom_Cominetti.kmz                      │ │
│ │ 2026-04 · operacional intermedia · 2.640 ha │ │
│ │ errores documentales conocidos              │ │
│ └─────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────┐ │
│ │ G4  ✓ verificado            [👁 mostrar ✓]  │ │ ← visible por default
│ │ RTK Daniel 2026-05                          │ │
│ │ 2026 · medición RTK · 2.164,97 ha           │ │
│ │ 77 vértices · WGS84 UTM 19S · ±10m          │ │
│ └─────────────────────────────────────────────┘ │
│                                                 │
│ [Ver comparación cruzada en mapa]               │ ← acción especial
└─────────────────────────────────────────────────┘
```

**Comportamiento clave:**
- Cada card tiene toggle `👁 mostrar` que renderiza la geometría sobre el mapa con color distintivo
- G3 superseded: si se activa el toggle, aparece sobre el mapa con label rojo "SUPERSEDED" pegado al polígono
- Botón "Ver comparación cruzada en mapa" → activa los 4 toggles simultáneamente, ajusta opacidad para que se vean superpuestas, abre legenda flotante
- Click en card (no en toggle) → drawer con detalle completo: thumbnail grande, metadata, documentos de evidencia, link al data room

**Datos consumidos:**
- `its.representaciones_geometricas` filtradas por unidad
- Cada `geom` se renderiza como source/layer separado en MapLibre cuando se activa

---

## 8 · Sub-tab 5 · CADENA REGISTRAL

**Cuándo se muestra:** cuando hay >=2 eventos en `its.cadena_registral` para la entidad.

**Cuándo se oculta:** entidad sin historial registrado.

**Nota:** este sub-tab reemplaza/evoluciona el tab actual "Eventos" del predio.

### Layout

```
┌─────────────────────────────────────────────────┐
│ Cadena registral                                │
│ 9 eventos verificados/localizados               │
│                                                 │
│ [Vista timeline] [Vista tabla] ← toggle         │
│                                                 │
│ TIMELINE                                        │
│                                                 │
│ 1990  ●━━━ Saneamiento DL 2.695  · 2.642 ha  ✓ │ ← vertical, no horizontal
│       │   fs.97 N°91/1990                       │   (panel angosto)
│       │                                         │
│ 1992  ●━━━ Subdivisión Lote A · Plano 531 ⏳   │
│       │   Lote C 300 + Resto A 863              │
│       │                                         │
│ 1996  ●━━━ Compraventa Jarpa → Bruno+Virginia ✓│
│       │   fs.1.994 N°1.813 · CLP 19.5M          │
│       │                                         │
│ 2000  ●━━━ Cesión Virginia → Bruno          ✓  │
│       │   fs.838 N°754 · CLP 13M                │
│       │                                         │
│ 2006  ●━━━ Planos 377-397 (21 láminas)      ⏳ │
│       │   Motor geométrico probable             │
│       │                                         │
│ 2014  ●━━━ Cofanti compra · CLP 25M          ✓ │
│       │                                         │
│ 2017  ●━━━ Adjudicación 4 hermanos C.I.      ✓ │
│       │   Rep FS 694 N°26.309                   │
│       │                                         │
│ 2023  ●━━━ Dación pago → Cantera Ltda.       ✓ │
│       │                                         │
│ 2026  ●━━━ Mandato Magnus 24m 10%            ✓ │
│           Rep. N°24.327                         │
│                                                 │
│ ─────────────────────────────────────────────── │
│ ◇ HIPÓTESIS (no son eslabones)        [↗ tab]  │ ← link al sub-tab Hipótesis
│ ◇ HIP_VELASQUEZ_PRE_1996                       │
│ ◇ HIP_MOTOR_GEOMETRICO_2006                    │
└─────────────────────────────────────────────────┘
```

**Diferencia con ITS v2:** timeline VERTICAL (no horizontal), porque el panel derecho es angosto. Cada evento ocupa 2-3 líneas. Las hipótesis aparecen al final con link al sub-tab dedicado.

**Comportamiento:**
- Click en evento → drawer con detalle: inscripción completa, foja, número, repertorio, notario, monto, documentos de evidencia
- Toggle "Vista tabla" → cambia a tabla compacta con columnas: año / capa / tipo / inscripción / descripción
- Toggle entre vistas se persiste en localStorage del usuario

**Datos consumidos:**
- `its.cadena_registral` ordenada por `capa_temporal, fecha`
- Iconos según `estado` (verificado / pending / superseded)

---

## 9 · Sub-tab 6 · HIPÓTESIS

**Cuándo se muestra:** cuando hay >=1 hipótesis activa en `its.hipotesis` para la entidad.

**Cuándo se oculta:** entidad sin hipótesis declaradas.

### Layout

```
┌─────────────────────────────────────────────────┐
│ Hipótesis activas                               │
│ Explicaciones útiles · no son hechos canónicos  │
│                                                 │
│ ┌─────────────────────────────────────────────┐ │
│ │ ◇ HIP_VELASQUEZ_PRE_1996                    │ │
│ │ hipótesis de trabajo                        │ │
│ │                                             │ │
│ │ Venta franja sur Lote B ~502 ha a           │ │
│ │ Heriberto H. Velásquez Gallardo pre-1996    │ │
│ │ como pago en especie por agrimensura plano  │ │
│ │ MBN.                                        │ │
│ │                                             │ │
│ │ Contexto temporal: entre 1992 y 1996        │ │
│ │                                             │ │
│ │ Promovible si: localizar inscripción CBR    │ │
│ │ específica 1990-1996                        │ │
│ │                                             │ │
│ │ [Evidencia apoyo: 2] [Evidencia contra: 0] │ │
│ │ [Marcar como promovida] [Descartar]         │ │
│ └─────────────────────────────────────────────┘ │
│ ┌─────────────────────────────────────────────┐ │
│ │ ◇ HIP_MOTOR_GEOMETRICO_2006                 │ │
│ │ hipótesis de trabajo                        │ │
│ │                                             │ │
│ │ Planos 377-397/2006 son reescritura         │ │
│ │ espacial coordinada (motor geométrico, no   │ │
│ │ solo registro).                             │ │
│ │                                             │ │
│ │ Promovible si: extraer Plano N°377-2006     │ │
│ │ y verificar contenido                       │ │
│ │ [...]                                       │ │
│ └─────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────┘
```

**Comportamiento:**
- Botón "Marcar como promovida" → modal pidiendo documento de evidencia primaria que cumpla `promovible_si`. Sin evidencia, no se promueve.
- Botón "Descartar" → modal pidiendo evidencia contraria + motivo. Audit log obligatorio.
- Una hipótesis promovida migra al sub-tab "Cadena registral" como evento verificado.
- Click en "Evidencia apoyo" → drawer listando los documentos de evidencia indirecta

**Datos consumidos:**
- `its.hipotesis` filtrada por unidad
- `its.documentos_evidencia` para evidencia apoyo/contra

---

## 10 · Resumen — el sub-tab base que siempre se muestra

**El "Resumen" actual se mantiene y se enriquece sutilmente.**

```
┌─────────────────────────────────────────────────┐
│ Hijuela 2 Cominetti                             │
│ Roles SII 24-123 + 24-160                       │
│ Comuna La Higuera · Coquimbo                    │
│                                                 │
│ [Vista predio | Vista unidad ✓]                 │ ← toggle vista
│                                                 │
│ ─────────────────────────────────────────────── │
│ Mandato vigente Magnus · 24m · 10%              │
│ Rep. N°24.327 · 14-abr-2026                     │
│                                                 │
│ Titulares actuales (5)                          │
│ • Silvia M. Cominetti        18,75%             │
│ • Claudia C. Cominetti       18,75%             │
│ • Lidia R.V. Cominetti       18,75%             │
│ • Sucesión Bruno G.          18,75%             │
│ • Agrícola Cantera Ltda.     25,00%             │
│                                                 │
│ Contexto envolvente                             │
│ Estancia La Higuera · Rol 24-5 · ~60.000 ha    │
│ Andes Iron SpA desde 16-ago-2021                │
│ Hijuela 2 es enclave dentro de la matriz.       │
│                                                 │
│ ─────────────────────────────────────────────── │
│ Estado epistemológico                           │
│ ◉ identificado · 13 conflictos abiertos        │
│ Última actualización: 31-may-2026               │
│                                                 │
│ [Ver detalle por sub-tab →]                     │
└─────────────────────────────────────────────────┘
```

**Cambios clave:**
- Bloque "Estado epistemológico" al final, sintetiza lo que hay en los demás sub-tabs
- Toggle "Vista predio | Vista unidad" en la parte superior cuando aplica
- Sin "5 cards horizontales de superficie" en Resumen — eso vive en el sub-tab Superficies (Resumen no satura)

---

## 11 · Transición predio → unidad → predio

### Flujo del usuario

1. Click en polígono del mapa (rol 24-123)
2. Panel abre vista predio individual con sub-tabs Resumen + Documentos
3. Chip "📍 Parte de Hijuela 2 Cominetti · [Ver unidad →]" visible en header
4. Click en chip → panel cambia a vista unidad (más sub-tabs disponibles)
5. Header muestra "[← Volver al predio individual]" + toggle "Vista predio | Vista unidad ✓"
6. Click en "Volver al predio individual" o en el toggle → regresa a vista predio
7. URL refleja el estado: `?p=24-123` o `?u=hijuela_2_cominetti`
8. Compartir URL preserva la vista

### Comportamiento del mapa

- Vista predio: polígono del rol seleccionado destacado, los otros roles de la unidad en color secundario
- Vista unidad: TODOS los roles de la unidad destacados como bloque coherente, polígono compuesto se calcula como union

---

## 12 · Sub-tabs adaptivos · lógica de visibilidad

| Sub-tab | Condición para mostrar | Badge si datos |
|---|---|---|
| Resumen | siempre | — |
| Superficies | >1 superficie en `its.superficies` | "Superficies (N)" |
| Autoridades | >=3 registros en `its.autoridades` | — |
| Conflictos | >=1 conflicto abierto | "Conflictos (N) ⚠" |
| Geometrías | >=2 representaciones | — |
| Cadena | >=2 eventos cadena registral | "Cadena (N)" |
| Hipótesis | >=1 hipótesis activa | "Hipótesis (N) ◇" |
| Evidencia | siempre (renombrado desde "Documentos") | "Evidencia (N)" si datos |

**Cuando un sub-tab no aplica, NO se muestra (no aparece deshabilitado).** Confirmado por Max 2026-05-31: "la interfaz debe revelar complejidad cuando existe, no anunciarla cuando no existe."

Ejemplo predio simple sin ontología ITS:
```
Resumen   Evidencia
```

Ejemplo Hijuela 2 (los 8 sub-tabs activos):
```
Resumen  Superficies  Autoridades  Conflictos (13)⚠  Geometrías  Cadena  Hipótesis ◇  Evidencia
```

**Cuando los 8 sub-tabs están activos**, el orden es estricto: Resumen → Superficies → Autoridades → Conflictos → Geometrías → Cadena → Hipótesis → Evidencia. Sin reordenamiento por usuario.

---

## 13 · Vocabulario de estados — universal en toda la UI

| Estado | Icono | Color | Aplica en |
|---|---|---|---|
| `verificado` | ✓ | verde | superficies, autoridades, conflictos resueltos, eventos cadena |
| `identificado` | ◉ | azul | representaciones que existen pero falta extracción |
| `localizado_pendiente_extraccion` | ⏳ | amarillo | sabemos dónde está pero no se tiene |
| `parcialmente_verificado` | ◐ | naranja | un elemento confirmado, otro pendiente |
| `hipotesis_de_trabajo` | ◇ | púrpura | hipótesis activa no promovida |
| `conflicto_documentado` | ⚠ | rojo | divergencia entre fuentes |
| `superseded` | ⊘ | gris | superado por evidencia/versión posterior |
| `descalificado` | ✗ | gris oscuro | descartado por evidencia firme |

Aparecen siempre como `icono + texto` (nunca solo icono). Accesibilidad.

---

## 14 · Interacciones críticas

### 14.1 · Tooltip universal en estados

Hover sobre cualquier icono de estado → tooltip con la definición canónica del estado (igual texto que en el schema SQL comment).

### 14.2 · Drawer overlay (no modal bloqueante)

Click en card o fila → drawer aparece desde la derecha como overlay parcial (75% width). El usuario sigue viendo parte del panel y del mapa. ESC o click fuera cierra.

### 14.3 · Empty states

Si un sub-tab se muestra pero hay 0 datos (caso raro de transición), muestra: "Sin {tipo} registrados aún. [Sugerir ingreso ↗]" con link a documentación de carga.

### 14.4 · Loading states

Skeleton screens grises (no spinners). Estructura visible aunque datos no hayan llegado.

### 14.5 · Promociones disciplinadas

Cualquier acción que invoque `its.cambiar_estado()` o `its.resolve_conflicto()` o `its.promote_superficie_to_verified()` exige modal con:
- Selector de documento de evidencia (de `its.documentos_evidencia`)
- Campo motivo (texto libre)
- Confirmación "Sé que esta acción queda en audit log permanente"

Sin el modal, sin estos campos, la función SQL rechaza la operación.

---

## 15 · Sidebar izquierdo · cambios mínimos

### 15.1 · Nuevo bloque "Unidades territoriales registradas"

```
▼ Unidades territoriales (1)
  Hijuela 2 Cominetti
    24-123 + 24-160
    13 conflictos abiertos ⚠
```

Click en unidad → mapa centra + abre panel con vista unidad.

### 15.2 · Nueva capa "Estado de conciliación"

Toggle en el bloque de capas:

```
☐ Estado de conciliación   [info ℹ]
   Resalta predios por estado epistemológico
```

Cuando activa, los polígonos se colorean según el estado de la unidad (si pertenecen a una) o el reconciliation_status (predios individuales).

---

## 16 · Tab top opcional · DISCIPLINA

**Decisión pendiente Max:** ¿se crea o no?

Si sí, sería tab #11 (después de "docs"). Contiene:
- Lista global de todos los conflictos abiertos del proyecto (todas las unidades)
- Audit log de cambios de estado sospechosos (vista `its.estado_cambios_sospechosos`)
- Estadística: cuántos elementos en cada estado
- Función "Forzar refresh ranking ITS" (admin)

Solo para Max / admin. No visible a usuarios normales.

---

## 17 · Decisiones tomadas (sesión 2026-05-31 Max)

1. **URL state predio ↔ unidad: SÍ desde el inicio.** Formato decidido:
   - Vista predio: `#map=10.2/-29.40/-71.09&p=24-123`
   - Vista unidad: `#map=10.2/-29.40/-71.09&u=hijuela_2_cominetti`
   - Razón: deep-linking, compartir análisis, recuperar contexto, futuro MCP/API. Sin esto después duele migrarlo.

2. **Drill-down chip epistemológico: SÍ.** El chip "IDENTIFICADO · 13 conflictos abiertos" del Resumen es clickeable → abre directamente el sub-tab Conflictos. La UI debe permitir navegar desde incertidumbre hacia evidencia.

3. **Geometrías sobre mapa principal: SÍ.** No mini-mapa. La potencia de Magnus es espacial. Los toggles G1/G2/G3/G4 actúan sobre el mapa central. Inicialmente como contornos simples; refinable después.

4. **Tab superior Disciplina: NO ahora.** Post-v0.3. Riesgo de construir herramienta para administradores antes que para usuarios territoriales. La disciplina ya vive en estados + conflictos + auditoría + funciones SQL; no necesita tab visible todavía.

5. **Documentos → Evidencia: SÍ.** Cambio importante. "Documentos" es contenedor; "Evidencia" es función epistemológica. Fuerza pensar en trazabilidad, no en almacenamiento. Sub-tab final del orden queda: ... → Hipótesis → **Evidencia**.

---

## 17.1 · Jerarquía 3-niveles SIEMPRE VISIBLE (Max 2026-05-31)

**Observación adicional crítica del usuario:** la triple jerarquía es una de las mayores innovaciones conceptuales de Hijuela 2. Si no se ve en la interfaz, se pierde.

```
Nivel 1: Territorio       ← Estancia La Higuera
   ↓
Nivel 2: Unidad           ← Hijuela 2 Cominetti
   ↓
Nivel 3: Objeto           ← Rol 24-123
```

**Implementación obligatoria:** breadcrumb visible en la parte superior del panel derecho cuando se selecciona cualquier feature.

```
┌─────────────────────────────────────────────────┐
│ Estancia La Higuera ▸ Hijuela 2 ▸ Rol 24-123   │ ← breadcrumb clickeable
│                                                 │
│ [Vista predio | Vista unidad]                   │
│                                                 │
│ ... (resto del panel) ...                       │
└─────────────────────────────────────────────────┘
```

- Cada nivel es clickeable y carga ese contexto en el panel
- Si la unidad no existe (predio simple), el breadcrumb muestra solo: `Estancia La Higuera ▸ Rol XX-XXX`
- Si el territorio no existe (predio fuera de unidad y fuera de territorio registrado), el breadcrumb solo muestra: `Rol XX-XXX`

**Comportamiento URL state:**
- `?u=hijuela_2_cominetti` → carga vista unidad (Nivel 2)
- `?p=24-123` → carga vista predio (Nivel 3) con breadcrumb mostrando unidad/territorio si aplica
- Sin parámetro → panel vacío (estado actual)
- `?t=estancia_la_higuera` (futuro) → carga vista territorio (Nivel 1) — post-v0.3

---

## 18 · Lo que NO está en este mockup (descartes explícitos)

- Buscador propio dentro del panel · usa el global del header
- Mapa lateral · usa el mapa principal de Magnus
- Bloque "Identidad de unidad" como sección dedicada · vive en el header del panel actual
- Header sticky aparte · el panel ya tiene su header
- Layout 2 columnas dentro del panel · se mantiene single column
- Chip "modo lectura" en el header del panel · vive en header global de Magnus

---

## 19 · Próximo paso post-aprobación mockup

Si Max aprueba este mockup:

1. **Extraer 4 módulos JS mínimos** (según dirección Max):
   - `panel-detail.js` (lógica principal del panel derecho enriquecido)
   - `its-renderers.js` (funciones de render por sub-tab)
   - `state-badges.js` (iconos + colores + tooltips de estados)
   - `authority-utils.js` (helpers de la matriz de autoridad)
2. **Mover `web/its.html` y dependencias** a `docs/visual_references/its_v0_static/`
3. **Aplicar token CSS migration** del theme.css ITS al `<style>` del index.html
4. **Implementar sub-tabs en el orden Max:** Superficies → Autoridades → Conflictos → Geometrías → Cadena → Hipótesis
5. **Validar contra Hijuela 2** en cada sub-tab antes de pasar al siguiente
6. **En paralelo:** ejecutar staging Supabase (RUN_STAGING.md)

---

## 20 · Honestidad operacional

Este mockup es una propuesta. Cualquier sub-tab puede:
- No convencerte visualmente
- Sobrar
- Faltar
- Tener orden invertido respecto a tu intuición

Antes de codear, espero feedback sub-tab por sub-tab si lo querés, o aprobación global con ajustes puntuales. El costo de iterar el mockup en texto es bajo; el costo de iterar código ya escrito es alto.
