# Wireframe Frontend ITS v2 — `web/its.html`

**Diseñado:** 2026-05-31
**Custodio:** Max Medina
**Estado:** wireframe textual · NO codificado
**Caso de referencia:** Hijuela 2 Cominetti

---

## 1 · Test ácido

**Una persona abre `its.html?u=hijuela_2_cominetti` por primera vez. No conoce el CANON. Tiene 60 segundos.**

Al finalizar debe poder responder:

1. ¿Qué activo estoy viendo y dónde está?
2. ¿Cuánto mide? — sin tener que elegir entre varios números
3. ¿Quién manda en cada cosa? — rol, cabida, geometría, fiscal
4. ¿Qué está roto o pendiente? — conflictos abiertos
5. ¿Cuántas versiones del activo existen? — geometrías concurrentes
6. ¿Cómo llegamos hasta acá? — cadena dominical resumida
7. ¿Dónde está en el mapa? — sin que el mapa sea el protagonista

Si la persona no responde 6 de 7 en 60 segundos, el wireframe falló.

---

## 2 · Principios de diseño

| Principio | Implicancia |
|---|---|
| **Unidad-céntrico** | La URL es `its.html?u={codigo_unidad}`. La unidad es la página, no el mapa. |
| **Cifras grandes, conflictos visibles** | Lo importante (superficies, conflictos abiertos) ocupa el área superior con tipografía grande. |
| **No esconder complejidad** | Las 5 superficies se muestran todas, no una "principal". El usuario aprende que hay múltiples por diseño. |
| **Estado siempre visible** | Cada elemento muestra su estado (`verificado`, `conflicto_documentado`, `hipotesis_de_trabajo`) con color + texto, nunca solo color. |
| **Densidad calibrada** | El usuario senior puede leer todo de una pasada. Densidad tipo Bloomberg terminal / dashboard de operación, no tipo landing page. |
| **Mapa contextual** | El mapa vive en una columna lateral. Confirma posición geográfica, no es el centro de decisión. |
| **Disciplina visible** | Los conflictos abiertos no se ocultan ni se minimizan. Aparecen con badge de severidad. |
| **Cero scroll horizontal** | Layout responsive desktop-first. Mobile = colapso vertical de las columnas. |

---

## 3 · Layout general (desktop 1440px)

```
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│  MAGNUS RADAR · ITS                                                  buscador  |  ☰ menú        │
├─────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                 │
│  HIJUELA 2 DE LA ESTANCIA LA HIGUERA                          ┌─────────────────────────────┐   │
│  Roles SII 24-123 + 24-160 · Comuna La Higuera · Coquimbo     │ ESTADO: identificado        │   │
│  Mandato vigente Magnus SpA · Rep. 24.327 · 24 meses          │ 13 conflictos abiertos  ⚠   │   │
│                                                               │ Última actualización 31-may │   │
│                                                               └─────────────────────────────┘   │
│                                                                                                 │
├─────────────────────────────────────────────────────────────────┬───────────────────────────────┤
│                                                                 │                               │
│  SUPERFICIES POR CAPA                                           │  MAPA · vista contextual      │
│  ┌─────────┬─────────┬─────────┬─────────┬─────────────────┐    │  ┌─────────────────────────┐  │
│  │ 2.642   │ 2.139,35│ 2.164,97│ 1.800   │     ?           │    │  │                         │  │
│  │ ha      │ ha      │ ha      │ ha      │  conflicto      │    │  │  [polígono Hijuela 2]   │  │
│  │ HIST    │ JURIDICA│ RTK     │ MANDATO │  SII            │    │  │  ◇ contornos G1 G2 G4   │  │
│  │ 1990 ✓  │ 2017 ✓  │ 2026 ✓  │ 2026 ✓  │  26 vs 2.641    │    │  │  ◯ tomas                │  │
│  │ CBR     │ Estudio │ RTK Mag │ Mandato │  ⚠ sii_directo  │    │  │  ▲ InterChile           │  │
│  └─────────┴─────────┴─────────┴─────────┴─────────────────┘    │  │                         │  │
│                                                                 │  └─────────────────────────┘  │
│                                                                 │  ▢ G1 plano matriz MBN        │
│  MATRIZ DE AUTORIDAD                                            │  ▢ G2 plano N°531/1992        │
│  ┌──────────────────────────────────────────────────────────┐   │  ▣ G3 KMZ XPU (superseded)    │
│  │ Dominio              | Autoridad         | Estado        │   │  ▣ G4 RTK Daniel 2026         │
│  ├──────────────────────────────────────────────────────────┤   │  ▢ G5 plano N°377-2006 ⏳     │
│  │ Rol SII              | SII oficial       | ✓ verificado  │   │                               │
│  │ Avalúo               | SII oficial       | ✓ verificado  │   │  [Pantalla completa] [PNG]    │
│  │ Cabida jurídica      | Estudio títulos   | ✓ verificado  │   │                               │
│  │ Sup. fiscal SII      | SII directo       | ⚠ conflicto   │   ├───────────────────────────────┤
│  │ Geom. histórica      | Plano MBN 1988    | ◉ identificado│   │                               │
│  │ Geom. jurídica       | Plano N°377-2006  | ⏳ localizado │   │  TITULARES (5)                │
│  │ Geom. operacional    | RTK Daniel 2026   | ✓ verificado  │   │  ┌─────────────────────────┐  │
│  │ Servidumbres         | CBR La Serena     | ◐ parcial     │   │  │ Silvia M. Cominetti 18.75│ │
│  │ Mandato              | Repertorio 24.327 | ✓ verificado  │   │  │ Claudia C. Cominetti 18.75│ │
│  └──────────────────────────────────────────────────────────┘   │  │ Lidia R.V. Cominetti 18.75│ │
│                                                                 │  │ Sucesión Bruno G.   18.75│  │
│                                                                 │  │ Agrícola Cantera Ltda 25 │  │
│                                                                 │  └─────────────────────────┘  │
├─────────────────────────────────────────────────────────────────┴───────────────────────────────┤
│                                                                                                 │
│  CONFLICTOS ABIERTOS  · 13 abiertos · 4 cerrados                                  [Ver todos]   │
│  ┌──────────────────────────────────────────────────────────────────────────────────────────┐   │
│  │ ⚠ alta  SII_SURFACE_FACTOR_100         · Factor 100 entre DI y DD                        │   │
│  │         autoridad: SII directo         · acción: consulta mapas.sii.cl                   │   │
│  │ ◐ med   GAP_PLANO_22_1990              · localizado_pendiente_extraccion                 │   │
│  │         autoridad: CBR La Serena       · acción: solicitud copia certificada             │   │
│  │ ◐ med   GAP_VENTA_VELASQUEZ_PRE_1996   · hipotesis_de_trabajo                            │   │
│  │         autoridad: CBR La Serena       · acción: búsqueda registral 1990-1996           │   │
│  │ ◐ med   GAP_CAJETIN_PLANO_MBN          · falta autor/escala/datum                        │   │
│  │ ◐ med   GAP_MUTACION_CATASTRAL_24_4    · cuándo y por qué cambió el rol                  │   │
│  │ ○ baja  GAP_DESLINDE_EL_MOLLE          · predio aledaño no caracterizado                 │   │
│  └──────────────────────────────────────────────────────────────────────────────────────────┘   │
│                                                                                                 │
├─────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                 │
│  REPRESENTACIONES GEOMÉTRICAS · 4 concurrentes (ninguna sobrescribe)                            │
│  ┌─────────────────┬─────────────────┬─────────────────┬─────────────────┐                      │
│  │ G1              │ G2              │ G3              │ G4              │                      │
│  │ ┌─[thumb]─┐     │ ┌─[thumb]─┐     │ ┌─[thumb]─┐     │ ┌─[thumb]─┐     │                      │
│  │ │ 6 hij   │     │ │ planim  │     │ │ KMZ     │     │ │ RTK     │     │                      │
│  │ │ A-M     │     │ │ XX/21   │     │ │ XPU     │     │ │ 77 vert │     │                      │
│  │ └─────────┘     │ └─────────┘     │ └─────────┘     │ └─────────┘     │                      │
│  │ MBN IV-1-1777   │ N°531/1992      │ DataRoom 2026-04│ Daniel 2026-05  │                      │
│  │ 1990 · histórica│ 1992 · jurídica │ 2026 · operac.  │ 2026 · medic.   │                      │
│  │ ◉ identificado  │ ⏳ pendiente    │ ⊘ SUPERSEDED    │ ✓ verificado    │                      │
│  │ 2.642 ha        │ 1.163 + 300 ha  │ 2.640 ha (sin   │ 2.164,97 ha     │                      │
│  │                 │                 │ capa)           │ ±10m UTM 19S    │                      │
│  └─────────────────┴─────────────────┴─────────────────┴─────────────────┘                      │
│                                                                                                 │
├─────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                 │
│  CADENA REGISTRAL · 6 capas estratigráficas                                                     │
│                                                                                                 │
│   1990         1992        1996        2000       2006-2014     2017         2023         2026  │
│   ●━━━━━━━━━━━●━━━━━━━━━━━●━━━━━━━━━━━●━━━━━━━━━━●━━━━━━━━━━━━●━━━━━━━━━━━●━━━━━━━━━━━━●        │
│   │           │           │           │           │            │           │            │       │
│   Sanea-      Subdiv.     Compra-     Cesión      Planos       Cofanti +   Dación       Mandato │
│   miento      Lote A      venta       Virginia    377-397      adjudic.    pago Bruno G.Magnus  │
│   DL 2.695    Plano 531   Bruno +     → Bruno     21 lám.      4 herma-    → Cantera    24m 10% │
│   2.642 ha    1.163 ha    Virginia    100% Bruno  ⏳ pendiente nos C.I.    Ltda.        1.800 ha│
│   fs.97       Lote C 300  fs.1.994                            Rep FS 694   25%          decla-  │
│   N°91/1990   Resto 863   N°1.813                             N°26.309                  rada    │
│   CBR ✓       CBR ⏳      CBR ✓       CBR ✓       CBR ⏳       CBR ✓       CBR ✓        ✓       │
│                                                                                                 │
│  [Ver detalle completo cadena registral →]                                                      │
│                                                                                                 │
├─────────────────────────────────────────────────────────────────────────────────────────────────┤
│                                                                                                 │
│  CONTEXTO ENVOLVENTE                                                                            │
│  Estancia La Higuera (Rol 24-5) · 60.000 ha · Andes Iron SpA RUT 76.097.759-4 · adq. 2021-08-16 │
│  Hijuela 2 es enclave dentro de la matriz Andes Iron.                                           │
│                                                                                                 │
│  HIPÓTESIS ACTIVAS · 2                                                                          │
│  ◐ HIP_VELASQUEZ_PRE_1996   · pago en especie agrimensura · evidencia indirecta CBR 1990        │
│  ◐ HIP_MOTOR_GEOMETRICO_2006 · planos 377-397 son reescritura coordinada · req. extracción     │
│                                                                                                 │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 4 · Diseño por componente

### 4.1 · Header (top)

| Elemento | Contenido | Comportamiento |
|---|---|---|
| Logo + título | "MAGNUS RADAR · ITS" | Click → dashboard de todas las unidades |
| **Badge modo lectura** | "👁 MODO LECTURA · sin escritura" | Chip prominente fondo amarillo claro · siempre visible · tooltip: "ITS v2 es de solo lectura. Las ediciones se hacen vía funciones SQL disciplinadas, no por UI." |
| Buscador | Input típo "Hijuela 2", "rol 24-123", "Cominetti" | Autocomplete por unidad, rol, titular, conflicto |
| Menú | acceso a v1 mapa catastral, settings, audit log | Drawer lateral |

**Sticky:** sí, en scroll permanece visible.

**Ajuste 1 (sesión 2026-05-31 Max):** el badge "modo lectura" es obligatorio. Evita confusión con interfaz editable. ITS v2 es ficha operacional navegable, no editor.

### 4.2 · Identidad de la unidad

| Elemento | Contenido | Tipografía |
|---|---|---|
| Nombre unidad | "Hijuela 2 de la Estancia La Higuera" | 28px · serif (Georgia) |
| Línea secundaria | Roles SII · Comuna · Región | 14px · sans-serif gris |
| Línea terciaria | Estado del mandato vigente | 14px · sans-serif acento |
| Chip estado | "ESTADO: identificado · 13 conflictos abiertos" | 12px uppercase · fondo amarillo (warning) si N conflictos > 5 |

### 4.3 · Panel superficies por capa

**Header de sección obligatorio (Ajuste 2 · Max 2026-05-31):**

```
SUPERFICIES POR CAPA
No existe superficie única. Cada cifra pertenece a una capa con su autoridad.
```

Subtítulo en gris medio, 13px, debajo del header del panel. Pedagógico: explica al usuario nuevo por qué hay 5 números distintos.

Grid horizontal de 5 cards. Cada card:

| Línea | Contenido |
|---|---|
| 1 (grande) | Valor numérico — 36px · bold |
| 2 (small) | "ha" |
| 3 (badge) | Capa: HIST / JURIDICA / RTK / MANDATO / FISCAL |
| 4 | Año + fuente abreviada |
| 5 (status) | Icono + estado |

**Card de conflicto fiscal SII (Ajuste 3 · Max 2026-05-31):**

NO mostrar "?" solitario (parece dato faltante). En su lugar, mostrar ambos valores observados:

```
┌─────────────────────────┐
│ CONFLICTO               │  ← línea 1: badge "conflicto" 12px uppercase rojo
│ 26,41 / 2.640,93        │  ← línea 2: ambos valores 22px (más chico que las otras cards)
│ ha                      │  ← línea 3: "ha"
│ FISCAL · SII            │  ← línea 4: capa
│ ⚠ pendiente sii_directo │  ← línea 5: estado + autoridad resolutiva
└─────────────────────────┘
```

Fondo rojo claro `--surface-conflict-bg`. Click → drawer del conflicto SII_SURFACE_FACTOR_100 con valores observados, hipótesis abiertas, y botón "marcar como resuelto" (que invoca función disciplinada).

**No hay card "destacada" o "principal".** Las 5 son iguales en jerarquía visual. La card de conflicto NO se oculta ni se minimiza — la disciplina es mostrarlo claramente.

### 4.4 · Matriz de autoridad

Tabla compacta de 3 columnas: Dominio | Autoridad | Estado

**Iconos de estado:**
- ✓ verde · `verificado`
- ⏳ amarillo · `localizado_pendiente_extraccion`
- ◉ azul · `identificado`
- ◐ naranja · `parcialmente_verificado`
- ⚠ rojo · `conflicto_documentado`
- ⊘ gris · `superseded`

**Click en fila** → modal lateral con detalle: documentos de evidencia asociados, capa temporal, vigencia, notas.

### 4.5 · Panel mapa contextual (columna derecha)

| Capa | Visible por defecto | Toggle | Rótulo en lista |
|---|---|---|---|
| Polígono unidad (geometría operacional G4) | sí | obligatoria | "G4 RTK Daniel 2026 · vigente" |
| G1 plano matriz contorno | no | sí | "G1 plano matriz MBN · histórica" |
| G2 plano subdivisión contorno | no (cuando exista) | sí | "G2 plano N°531/1992 · pendiente" |
| **G3 KMZ XPU** | **NO (apagada por defecto · Ajuste 4 Max)** | sí, **con label rojo "⊘ SUPERSEDED"** | "G3 KMZ XPU 2026-04 · ⊘ SUPERSEDED" |
| G4 RTK Daniel | sí | sí | "G4 RTK Daniel · ✓ verificada" |
| G5 plano 377-2006 | no (pendiente) | placeholder | "G5 plano N°377-2006 · ⏳ pendiente" |
| Tomas | sí | sí | "Tomas · contexto operacional" |
| InterChile servidumbre | sí | sí | "InterChile · gravamen vigente" |
| Andes Iron matriz envolvente | no | sí | "Andes Iron · contexto envolvente" |

**Ajuste 4 (Max 2026-05-31):** G3 KMZ debe estar OFF por defecto. Si el usuario la activa, debe verla con opacidad reducida + label rojo prominente "⊘ SUPERSEDED" superpuesto. Razón: la cifra "2.640 ha" del KMZ sin capa puede confundir si aparece junto a las representaciones vigentes.

**Controles mínimos:**
- Zoom in/out
- Toggle capas (lista vertical bajo el mapa)
- Botón "pantalla completa"
- Botón "exportar PNG"

**Lo que NO está en este mapa (intencional):**
- Tabs múltiples
- Búsqueda en mapa (la búsqueda está en el header global)
- Modo presentación
- Mini-mapa PIP
- 3D / DEM
- DGA / SEIA (todo eso vive en v1)

### 4.6 · Panel titulares

Lista compacta de 5 filas, una por titular. Cada fila:
- Nombre completo (truncate si > 30 chars)
- Participación % (alineado derecha)
- Color de fondo sutil según tipo (persona natural / sucesión / persona jurídica)

**Click en titular** → drawer con detalle: RUT, origen de adquisición, fecha vigencia desde, otros activos del titular en el sistema.

### 4.7 · Panel conflictos abiertos

Lista vertical. Cada conflicto en una fila de 2 líneas:

```
[badge severidad] [codigo]              · [descripción 1 línea]
                  autoridad: [X]        · acción: [Y]
```

**Severidad visual:**
- ⚠ alta · rojo · fondo rojo claro
- ◐ media · naranja · fondo naranja claro
- ○ baja · gris · sin fondo

**Filtros disponibles:**
- Todos / Por severidad / Por autoridad resolutiva / Por tipo
- Por defecto: ordenado por severidad descendente

**Click en conflicto** → drawer con detalle completo: valores observados (JSONB renderizado), documentos de evidencia, historia del conflicto, botón "marcar como resuelto" (que invoca `its.resolve_conflicto()`).

### 4.8 · Panel representaciones geométricas

Grid horizontal de 4 cards (5 cuando G5 esté). Cada card:

| Elemento | Contenido |
|---|---|
| Thumbnail | 200×150px · render simplificado del polígono / preview del plano |
| Código | G1, G2, G3, G4, G5 — grande |
| Fuente | "MBN IV-1-1777" · "N°531/1992" etc. |
| Año + tipo | "1990 · histórica" |
| Estado | Icono + texto |
| Superficie | Valor numérico (si declarada) |
| Notas técnicas | datum, precisión (si aplica) |

**Card superseded** → opacidad 60% + badge ⊘ "SUPERSEDED"
**Card pendiente** → fondo gris + ⏳ "pendiente extracción"

**Click en card** → modal con:
- Thumbnail grande
- Toda la metadata
- Lista de documentos de evidencia asociados con link al data room
- Mapa con la geometría destacada
- Botón "extraer" (si pendiente) → tarea operacional

### 4.9 · Cadena registral (timeline horizontal)

**Ajuste 5 (Max 2026-05-31):** la timeline principal SOLO muestra eventos `verificado` o `localizado_pendiente_extraccion`. Las hipótesis NO se mezclan como eslabones de la cadena.

**Estructura visual obligatoria:**

```
TIMELINE PRINCIPAL (cadena dominical verificada/localizada)
  1990 ━●━━ 1992 ━●━━ 1996 ━●━━ 2000 ━●━━ 2014 ━●━━ 2017 ━●━━ 2023 ━●━━ 2026 ━●━
       ✓        ⏳        ✓        ✓        ✓        ✓        ✓        ✓

HIPÓTESIS (banda separada visualmente, debajo, con título distinto)
  ◇ HIP_VELASQUEZ_PRE_1996      · evento ubicado tentativamente entre 1992-1996
  ◇ HIP_MOTOR_GEOMETRICO_2006   · evento ubicado tentativamente entre 2006-2014
```

La banda de hipótesis:
- Fondo distinto (sutil gris claro)
- Marcador ◇ (diamante hueco) en vez de ● (círculo lleno)
- Línea de la timeline ausente (las hipótesis no son eslabones, son anotaciones laterales)
- Header explícito: "HIPÓTESIS · no son eslabones verificados de la cadena"

**Eventos representados visualmente en timeline principal:**
- ● grande · saneamiento, mandato (eventos estructurales)
- ● mediano · compraventa, subdivisión
- ● pequeño · cesión, anotación marginal

**Color del marcador según estado:**
- verde ✓ · `verificado`
- amarillo ⏳ · `localizado_pendiente_extraccion`
- gris ⊘ · `superseded` (no debería aparecer en timeline principal, solo si fue evento que después se invalidó)

**Hover sobre marcador** → tooltip con descripción 1 línea.
**Click en marcador** → drawer con detalle completo del evento + inscripción + foja + N° + notario + documentos.
**Click en hipótesis** → drawer con texto de la hipótesis, evidencia de apoyo, evidencia contraria, condición de promoción.

**Botón "ver detalle completo"** → tabla full-screen con todos los eventos cronológicos + hipótesis en columna separada.

**Razón doctrinal del ajuste:** mezclar hipótesis como eslabones de la cadena dominical viola la disciplina del CANON §1 regla 6 ("hipotesis y autoridades son nodos de primer nivel, no propiedades incrustadas en otros nodos"). Si una hipótesis se promueve a hecho (vía función `its.cambiar_estado` con evidencia primaria), entonces sí migra a la timeline principal.

### 4.10 · Contexto envolvente + hipótesis

Bloque footer-area con:
- Resumen de la matriz envolvente (Estancia La Higuera + Andes Iron)
- Lista compacta de hipótesis activas (las que no son conflictos)
- Pie de página con metadata del documento (última actualización, versión del schema, link al CANON)

---

## 5 · Estados de interacción

### 5.1 · Hover

- Cards y filas: ligero levantamiento + sombra (shadow-md)
- Iconos de estado: tooltip con la definición del estado ("identificado: existe y se sabe cuál es; falta extracción completa")
- Cifras grandes: tooltip con composición (p.ej. hover sobre "2.139,35 ha" → "Resto A 863 + Resto B 976,35 + Lote C 300")

### 5.2 · Click expand

- Click en cualquier card → drawer/modal lateral derecho con detalle completo
- Click fuera del drawer o ESC → cerrar
- Drawer NO bloquea la lectura del dashboard principal (overlay parcial)

### 5.3 · Estados de carga

- Skeleton screens grises mientras carga (no spinners genéricos)
- Mostrar la estructura del layout aunque los datos no hayan llegado
- Lazy load de thumbnails de representaciones geométricas

### 5.4 · Estados vacíos

- Si una unidad NO tiene conflictos abiertos: panel muestra "✓ Sin conflictos abiertos" en verde
- Si no tiene hipótesis: panel se oculta
- Si no tiene titulares cargados: panel muestra alerta "Titulares no cargados — revisar fixture"

---

## 6 · Lo que NO está en v2 inicial

| Funcionalidad | Por qué no | Cuándo |
|---|---|---|
| Multi-unidad simultánea | Foco en el caso de una unidad por pantalla | v2.1 |
| Edición inline | Disciplina: ediciones vía funciones SQL disciplinadas, no UI | quizá nunca, o v3 |
| Dominga PE | Backlog documental, no parte del fixture inicial | v2.2 |
| Multi-tenant | Magnus uso interno hoy | v3 si emerge cliente externo |
| Filtros geográficos complejos | El v1 mapa-céntrico ya lo hace | v1 sigue siendo el visor catastral |
| Comparador entre unidades | Funcionalidad emergente · esperar caso real | v2.3 |
| Exportar a PDF la ficha completa | Out of scope inicial · usar print-to-PDF mientras tanto | v2.1 |
| Notificaciones / alertas | El v1 ya tiene · no replicar | n/a |
| Editor de polígonos | El v1 ya tiene · ITS es solo lectura | n/a |
| 3D / DEM terrain | El v1 ya tiene · sobra para uso operacional | n/a |
| Idiomas | Magnus opera en castellano | n/a |

---

## 7 · Stack técnico mínimo propuesto

| Capa | Tecnología | Por qué |
|---|---|---|
| HTML | HTML5 estático | Consistente con v1 |
| CSS | CSS variables + utility classes (sin framework) | Bajo overhead. Tipografía y color coherentes. |
| JS | Vanilla ES2020 modular | Mantiene consistencia con v1. Sin React/Vue. |
| Mapa | MapLibre GL JS 4.7.1 | Mismo que v1 |
| Datos | Supabase REST (PostgREST) | Mismo backend que v1 |
| Autenticación | Supabase Auth Magic Link | Mismo que v1 |
| Build | Ninguno (single file o módulos ES nativos) | Coherencia con v1 |

**Archivos propuestos:**

```
web/
├── index.html              ← v1 mapa-céntrico (sin cambios)
├── its.html                ← v2 unidad-céntrico (nuevo)
├── its/
│   ├── core.js             ← bootstrap, routing por ?u=
│   ├── unidad.js           ← carga datos de unidad vía Supabase
│   ├── panels/
│   │   ├── superficies.js
│   │   ├── autoridades.js
│   │   ├── conflictos.js
│   │   ├── representaciones.js
│   │   ├── cadena.js
│   │   ├── titulares.js
│   │   └── hipotesis.js
│   ├── mapa.js             ← mapa contextual reducido
│   ├── drawers.js          ← lógica de modales/drawers laterales
│   └── theme.css           ← variables + utility classes
```

**Decisión:** módulos JS nativos `import / export`, no bundler. El navegador moderno lo soporta. Bajo overhead.

---

## 8 · Tipografía y color (sistema mínimo)

### Tipografía

| Uso | Familia | Tamaño | Peso |
|---|---|---|---|
| Títulos de unidad | Georgia, serif | 28px | 400 |
| Cifras grandes (superficies) | Inter, sans-serif | 36px | 700 |
| Headers de panel | Inter, sans-serif | 16px UPPERCASE | 600 |
| Body | Inter, sans-serif | 14px | 400 |
| Caption / metadata | Inter, sans-serif | 12px | 400 |
| Código / IDs | JetBrains Mono, monospace | 12px | 400 |

### Color (semántico, no decorativo)

| Token | Hex | Uso |
|---|---|---|
| `--ink-primary` | #1a1a1a | Texto principal |
| `--ink-secondary` | #5a5a5a | Texto secundario |
| `--ink-muted` | #9a9a9a | Metadata |
| `--bg-page` | #fafafa | Fondo página |
| `--bg-panel` | #ffffff | Fondo paneles |
| `--accent-verified` | #2e7d32 | ✓ verificado |
| `--accent-pending` | #ed6c02 | ⏳ pendiente |
| `--accent-identified` | #1976d2 | ◉ identificado |
| `--accent-partial` | #f57c00 | ◐ parcial |
| `--accent-conflict` | #d32f2f | ⚠ conflicto |
| `--accent-superseded` | #757575 | ⊘ superseded |
| `--surface-warning-bg` | #fff8e1 | Fondo de chip warning |
| `--surface-conflict-bg` | #ffebee | Fondo de fila conflicto alta |

**Sin gradientes. Sin sombras de colores. Sin animaciones decorativas.** Estética de operación, no de marketing.

---

## 9 · Validación del wireframe contra el test ácido

| Pregunta del test | Respuesta visible | Posición visual |
|---|---|---|
| ¿Qué activo y dónde? | Título grande + comuna/región | Header de unidad |
| ¿Cuánto mide? | 5 cards de superficie con cifras grandes | Panel superficies (arriba izquierda) |
| ¿Quién manda? | Tabla matriz de autoridad con 13 dominios | Centro izquierda |
| ¿Qué está roto? | Lista de conflictos abiertos con badges de severidad | Centro |
| ¿Cuántas versiones del activo? | 4 cards de geometrías con thumbnails | Debajo de conflictos |
| ¿Cómo llegamos hasta acá? | Timeline horizontal de cadena registral | Footer |
| ¿Dónde está? | Mini-mapa contextual con polígono | Columna derecha |

**Verificación:** las 7 respuestas son lecturables en la primera pantalla sin scroll (asumiendo monitor 1440×900 o superior). En pantallas menores requiere 1 scroll moderado.

---

## 10 · Próximo paso (post-aprobación wireframe)

1. **Tú revisas este wireframe**. Vetá lo que sobra, identificá lo que falta, ajustá jerarquía visual.
2. **Si aprobás**: paso a HTML/CSS estático del wireframe (sin lógica, solo estructura visual con datos hardcoded de Hijuela 2). Tiempo estimado: 4-6 horas de output.
3. **Luego**: conexión con Supabase staging (cuando esté ejecutado) para reemplazar datos hardcoded por queries reales.
4. **Después**: iteración basada en uso real de Max + posibles hallazgos nuevos del CANON.

**Lo que NO hago hasta tu aprobación:** código. Solo wireframe.

---

## 11 · Riesgos del diseño

| Riesgo | Mitigación |
|---|---|
| Densidad demasiado alta para usuarios no-expertos | Magnus Radar es uso interno · Max es el usuario principal · densidad calibrada para senior |
| Mapa marginalizado puede generar resistencia visual | Mapa sigue siendo prominente en columna derecha · v1 sigue disponible para usos mapa-céntricos |
| Drawer/modal pattern puede romperse en mobile | Mobile = colapso vertical de paneles + drawers full-screen |
| 4 cards de geometría no escalan a 8+ | Si emergen más de 6, se convierte en grid 3×2 o carousel horizontal |
| Cadena registral con >15 eventos satura el timeline | Compresión por agrupación · zoom temporal · botón "ver detalle completo" para tabla |
| Tipografía Georgia/Inter falla en algunos sistemas | Fallback a fuentes del sistema · `font-family: Georgia, 'Times New Roman', serif;` |
