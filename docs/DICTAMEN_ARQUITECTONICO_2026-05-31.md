# Dictamen Arquitectónico — Magnus Radar vs ITS v2 vs Magnus v0.3 integrado

**Fecha:** 2026-05-31
**Custodio:** Max Medina
**Origen:** decisión sesión 2026-05-31 post-render its.html v0 estático
**Mandato:** producir comparación honesta entre 3 alternativas. No diseñar todavía. Solo dictamen.

---

## 0 · Contexto

Construí `its.html` v0 como producto separado, unidad-céntrico. Max lo vio renderizado y detuvo el desarrollo. Su veredicto: la ontología ITS es válida, pero la traducción visual no debe ser un segundo producto. Debe integrarse dentro de Magnus Radar manteniendo el mapa como centro de gravedad.

Este dictamen evalúa tres caminos: dejar Magnus como está, mantener ITS como producto separado, o evolucionar Magnus a v0.3 absorbiendo lo valioso del ITS.

**Principio rector adoptado:** `Territorio → Unidad → Ficha` (NUNCA `Unidad → Ficha → Territorio`).

---

## 1 · Magnus Radar actual — anatomía

### 1.1 · Estructura existente

| Capa | Componentes |
|---|---|
| **Header** | brand · search box global · auth · botones acción |
| **Tabs top (10)** | catastro · infra · agua · dominga · alertas · timeline · inmobiliaria · comparar · análisis · docs |
| **Sidebar izquierdo** | Filtros + 15 capas toggleables + sub-filtros (sectores, tipos SEIA) |
| **Mapa central** | MapLibre GL JS, predios XU + SII oficial dual, DEM 3D, draw editor, mini-mapa PIP |
| **Panel derecho (ficha)** | Aparece al click sobre feature · diferentes renderers según tipo (predio, SEIA, área protegida, oferta, transacción, concesión, DGA, línea TX) |
| **Panel-tabs internos** | Predio: Resumen / Eventos / Documentos / Vecinos · SEIA: Resumen / Cronología / Expediente / Impacto territorial |
| **Capas duales catastro** | XU + SII oficial + `reconciliacionMap` por rol con deltas open/explained/no_delta |
| **Mobile** | drawer izquierdo + bottom sheet derecho |
| **Extras** | URL state + share + modo presentación + atajos teclado + onboarding tour + i18n es/en + email Resend + notifications bell |

**Tamaño:** 4.998 líneas single-file HTML. 15 capas activas. 10 tabs top + 4 panel-tabs por entidad.

### 1.2 · Lo que el Magnus actual YA hace bien

- **Mapa-céntrico real.** Click en feature → ficha. El usuario nunca pierde contexto geográfico.
- **Catastro dual XU vs SII oficial** con reconciliación por rol. Esto es proto-ontología territorial — el embrión de "múltiples representaciones".
- **Búsqueda fuzzy global** que retorna features de cualquier tipo.
- **Multi-comuna** con switch operacional.
- **Capas regulatorias** integradas (SEIA, SMA, DGA, concesiones mineras, áreas protegidas).
- **Ficha enriquecida del predio** con tasación automática + contribuciones SII via Data Inmobiliaria.
- **Disciplina semántica embrionaria** en `reconciliacion_catastral` con `evidence_status` y `reconciliation_status`.

### 1.3 · Lo que el Magnus actual NO modela

- **Concepto de "unidad territorial"** que agrupe múltiples roles. Hijuela 2 (24-123 + 24-160) hoy son 2 predios independientes en la base, sin nexo formal.
- **Múltiples geometrías concurrentes** por entidad. Cada predio tiene UN polígono.
- **Múltiples superficies por capa con autoridad.** Cada predio tiene UN valor de superficie (más la del catastro alternativo si existe).
- **Conflictos como entidad de primer nivel** navegable. Hoy viven implícitos en `reconciliacionMap` como deltas, sin tipologías ni autoridad resolutiva.
- **Hipótesis** declaradas. Hoy no existe el concepto.
- **Cadena registral estructurada** por capa temporal. El tab "timeline" actual es de eventos del proyecto, no de la cadena dominical de un activo.
- **Matriz de autoridad explícita** por dominio (rol, cabida, geometría, fiscal). Implícita en el código actual.
- **Vocabulario disciplinado de estados.** Hoy `evidence_status` tiene algunos valores; el ITS propone 8 valores universales con función SQL bloqueante.

---

## 2 · ITS v2 propuesto (lo que construí en its.html)

### 2.1 · Aporte real

| Elemento | Tipo de aporte |
|---|---|
| **Schema PostgreSQL `its.*` (11 tablas + 6 enums + 3 vistas + funciones disciplinadas)** | **Estructural** — la ontología capturada en base de datos |
| **Vocabulario de estados** (verificado / identificado / localizado / parcial / hipótesis / conflicto / superseded) | **Estructural** — disciplina invariante por contrato SQL |
| **Audit log + trigger genérico** | **Estructural** — detección de promociones sin disciplina |
| **CANON_HIJUELA2_v1.2** | **Documental** — doctrina del caso Hijuela 2 |
| **DOSSIER_PLANO_MBN + DOSSIER_PLANO_377** | **Documental** — fichas de piezas críticas |
| **Wireframe its.html** + 7 paneles + sistema color/tipo | **Visual** — la propuesta de UI separada |
| **its.html v0 estático con datos Hijuela 2 hardcoded** | **Visual** — la implementación de la propuesta |
| **`web/its/theme.css` (690 líneas)** | **Visual reutilizable** — sistema de design tokens |
| **`web/its/data.js` (242 líneas) como modelo de datos espejo del schema** | **Estructural reutilizable** — el shape del JSON que vendría de Supabase |

### 2.2 · Costos identificados

- **Layout unidad-céntrico** que sustituye al mapa como centro de gravedad. El mapa queda en columna lateral — invierte la jerarquía de Magnus actual.
- **Producto separado** (`its.html`) que duplica navegación, autenticación, búsqueda, sistema visual base.
- **Modelo mental dividido**: el usuario debe decidir cuándo está en "Magnus mapa" vs "ITS ficha". Confusión natural.
- **Mantenimiento doble**: dos shells, dos rutas de despliegue, dos lugares para corregir bugs comunes.
- **Riesgo de divergencia**: con el tiempo Magnus y ITS evolucionarían en direcciones distintas. Tipografías, copy, paleta podrían empezar a diferir.
- **Funcionalidad redundante**: titulares, capas de mapa, búsqueda — todas duplicadas.

### 2.3 · Lo correcto del ITS v2

- **La disciplina ontológica.** Sin discusión.
- **El vocabulario de estados.** Sin discusión.
- **La separación hecho/hipótesis visualmente.** Sin discusión.
- **La idea de matriz de autoridad explícita.** Sin discusión.
- **El sistema de color/tipo.** Reutilizable.

### 2.4 · Lo equivocado del ITS v2

- **La inversión jerárquica mapa→ficha.** El mapa es el centro de Magnus por buena razón: el negocio es territorial.
- **La consolidación de todo en una vista única.** Una ficha de 5 paneles + mapa lateral es un Excel disfrazado, no una herramienta operacional.
- **La separación de productos.** Duplica costos sin aportar valor.

---

## 3 · Magnus v0.3 integrado — propuesta arquitectónica

### 3.1 · Hipótesis central

La ontología ITS vive en:
1. **El modelo de datos** (schema PostgreSQL `its.*` se mantiene)
2. **La ficha del feature seleccionado** (el panel derecho gana riqueza)
3. **Una capa visual nueva en el mapa** (predios con conflictos abiertos destacados)
4. **Un sidebar adicional** (lista de unidades territoriales registradas)

NO vive en:
- Una página separada
- Una vista que oculte el mapa
- Un dashboard que centralice toda la información en una pantalla

### 3.2 · Cambios propuestos a Magnus actual

#### Cambio A · Concepto de "unidad territorial" en data layer

Cuando el usuario hace click en un predio que pertenece a una unidad multi-rol (ej: rol 24-123 que es parte de Hijuela 2 Cominetti):

```
Panel derecho actual:
  [Predio rol 24-123]
  Superficie SII: X ha
  Titular: Y

Panel derecho v0.3:
  [Predio rol 24-123]   📍 parte de "Hijuela 2 Cominetti" [Ver unidad →]
  ↑
  Chip nuevo que aparece solo cuando hay unidad asociada
```

Click en chip → carga la ficha de la unidad territorial completa (sigue siendo el mismo panel derecho, mismo flujo, solo cambia el contenido).

#### Cambio B · Sub-tabs enriquecidos en panel ficha

Hoy: `Resumen / Eventos / Documentos / Vecinos`
v0.3: `Resumen / Superficies / Geometrías / Autoridades / Cadena / Conflictos / Documentos`

Cada sub-tab aplica solo cuando la entidad tiene datos relevantes. Si un predio simple no tiene 5 superficies ni 13 conflictos, los sub-tabs se ocultan automáticamente.

#### Cambio C · Capa nueva en mapa "Estado de conciliación"

Toggle en sidebar izquierdo. Cuando activa, los polígonos de predios se colorean por estado:
- Verde · `verificado`
- Amarillo · `parcialmente_verificado` o pendiente
- Rojo · con conflicto abierto
- Gris · sin información canónica

Mantiene el mapa como centro. Añade legibilidad sin sustituir la vista catastral.

#### Cambio D · Sidebar gana sección "Unidades territoriales"

Bloque adicional con conteo de unidades registradas + contador de conflictos abiertos por unidad. Click → centra mapa en la unidad + abre ficha.

```
SIDEBAR (extracto):
  ▼ Unidades territoriales (1)
    Hijuela 2 Cominetti
      24-123 + 24-160 · 13 ⚠
```

#### Cambio E · Tab top nuevo (opcional) "Disciplina"

Lista global de conflictos abiertos del proyecto + audit log de cambios sospechosos. Es la vista admin del estado epistemológico del sistema. Solo para Max.

#### Cambio F · Vocabulario de estados universal en toda la UI

Adoptar los 8 estados disciplinados y sus iconos en cualquier lugar donde aparezca un dato con estado. No solo en la ficha de unidad — también en SEIA, en concesiones, en derechos de agua.

---

## 4 · Comparación matricial honesta

| Dimensión | Magnus actual | ITS v2 separado | Magnus v0.3 integrado |
|---|---|---|---|
| **Mapa como centro** | ✅ sí | ❌ no (margen) | ✅ sí (intacto) |
| **Ontología ITS modelada** | ❌ no | ✅ sí, completa | ✅ sí, completa |
| **Disciplina de estados** | parcial (en reconciliación) | ✅ universal, bloqueada por SQL | ✅ universal, bloqueada por SQL |
| **Múltiples superficies** | parcial (XU vs SII) | ✅ N con autoridad | ✅ N con autoridad |
| **Múltiples geometrías** | ❌ una por predio | ✅ N por unidad | ✅ N por unidad |
| **Conflictos navegables** | ❌ no | ✅ entidad propia | ✅ entidad propia + capa mapa |
| **Hipótesis declaradas** | ❌ no | ✅ tabla separada | ✅ tabla separada + sección ficha |
| **Cadena registral estructurada** | parcial (tab timeline proyecto) | ✅ por unidad | ✅ por unidad en sub-tab |
| **Matriz autoridad explícita** | ❌ implícita | ✅ tabla en ficha | ✅ tabla en sub-tab ficha |
| **Costo desarrollo desde hoy** | 0 | alto (3+ meses paridad mínima) | medio (4-6 semanas) |
| **Deuda técnica nueva** | 0 | duplicación nav/auth/search/mapa | baja (extensión de existente) |
| **Mantenimiento futuro** | 1 producto | 2 productos | 1 producto |
| **Riesgo divergencia visual** | n/a | alto | bajo |
| **Riesgo confusión usuario** | bajo | medio-alto | bajo |
| **Pérdida funcionalidad** | n/a | ninguna del actual | ninguna del actual |
| **Curva aprendizaje Max** | 0 | media (2 modelos mentales) | baja (1 modelo evolucionado) |
| **Curva aprendizaje futuro usuario** | baja | alta | baja-media |
| **Reversibilidad** | n/a | media (descartar its.html) | alta (incremental) |
| **Aprovecha schema ITS v2** | 0% | 100% | 100% |
| **Aprovecha CSS ITS v2** | 0% | 100% | 60-80% (tokens reutilizables) |
| **Aprovecha código its.html** | 0% | 100% | 20-30% (renderers de paneles) |

---

## 5 · Mapeo elemento por elemento — qué del ITS v2 cabe dónde en Magnus v0.3

| Elemento ITS v2 | Destino en Magnus v0.3 | Tratamiento |
|---|---|---|
| Schema `its.*` PostgreSQL completo | Mismo (sin cambio) | Backend sigue siendo el mismo |
| 0002b hardening + audit log + funciones disciplinadas | Mismo (sin cambio) | Backend sigue siendo el mismo |
| Concepto unidad_territorial | Nuevo bloque en sidebar + chip en ficha de predio | Integra |
| Panel "Identidad de unidad" (header grande) | Adaptado como header de ficha cuando se selecciona unidad | Integra |
| Panel "Superficies por capa" (5 cards) | Nuevo sub-tab "Superficies" en ficha | Integra |
| Panel "Matriz de autoridad" (13 filas) | Nuevo sub-tab "Autoridades" en ficha | Integra |
| Panel "Conflictos abiertos" (lista severidad) | Nuevo sub-tab "Conflictos" en ficha + tab top global opcional | Integra |
| Panel "Representaciones geométricas" (4 cards) | Nuevo sub-tab "Geometrías" en ficha + cada geometría toggleable en mapa | Integra |
| Panel "Cadena registral" (timeline horizontal) | Sub-tab "Cadena" en ficha (reemplaza/enriquece "Eventos" actual) | Integra evolucionando |
| Panel "Hipótesis" (banda separada) | Sub-bloque dentro del sub-tab "Cadena" | Integra |
| Panel "Titulares" | Mantiene en "Resumen" como ya está | **Descarta** (duplica) |
| Panel "Contexto envolvente" | Nota inline en "Resumen" | **Descarta** (duplica) |
| Chip "modo lectura" en header | Adoptable en header global Magnus | Integra |
| Vocabulario 8 estados | Adoptable en cualquier elemento UI con estado | Integra |
| Sistema color/tipo (theme.css tokens) | Migrar variables CSS al index.html | Integra parcial |
| Mapa contextual lateral | **Descarta** (el mapa principal es el centro) | **Descarta** |
| Buscador propio del header ITS | **Descarta** (Magnus ya tiene global) | **Descarta** |
| Layout grid 2-col unidad/mapa | **Descarta** | **Descarta** |
| `its.html` como página | **Descarta** | **Descarta** |
| `its/app.js` renderers | Reutilizables como funciones helper en index.html, no como app independiente | Parcial |

---

## 6 · Qué descartar de its.html

Si v0.3 es el camino, los siguientes archivos quedan como **referencia documental** pero NO se mantienen activos:

- `web/its.html` — archivo de referencia visual, no para producción
- `web/its/app.js` — renderers se canibalizan al integrarse en index.html
- `web/RUN_ITS_V0.md` — referencia histórica

**Lo que SÍ se conserva activo** del trabajo hecho:

- `web/its/theme.css` — sus tokens (variables CSS, paleta semántica, sistema de iconos) se migran al `<style>` de index.html
- `web/its/data.js` — se transforma en el shape estándar de respuesta de Supabase REST para la nueva tabla `its.*`
- Toda la documentación: CANON, dossiers, SCHEMA_V2_ITS, HIJUELA_2_COMO_CASO_DE_PRUEBA, WIREFRAME_ITS_V2 — quedan como doctrina de referencia
- Todo el schema SQL (0002 + 0002b) — sin cambio, se ejecuta en staging cuando corresponda

---

## 7 · Riesgos por camino

### 7.1 · Riesgos de Magnus actual (no hacer nada)

- **Pérdida del valor del schema ITS v2.** El trabajo hecho queda en la documentación pero no se materializa.
- **Acumulación de hallazgos no canonizados.** El audit Hijuela 2 demostró que el modelo actual no captura múltiples superficies / geometrías / autoridades. Más casos como Dominga lo agravarían.
- **Imposibilidad de detectar disciplina perdida.** Sin audit log + funciones bloqueantes, las promociones de estado sin evidencia son invisibles.
- **Erosión silenciosa.** El proyecto crece, los conflictos se ocultan en notas mentales del equipo, la confianza en el sistema baja.

### 7.2 · Riesgos de ITS v2 separado

- **Duplicación de mantenimiento.** Dos productos que evolucionan en paralelo. Realista: uno se queda atrás.
- **Modelo mental fragmentado.** Max trabajaría unas veces en Magnus, otras en ITS, según la tarea. Cambio de contexto.
- **Pérdida del centro de gravedad cartográfico.** ITS marginaliza el mapa. Magnus siempre lo tuvo en el centro porque es lo que el negocio territorial demanda.
- **Riesgo de divergencia visual y de copy.** Sin disciplina central, dos paletas, dos voces, dos vocabularios.
- **Curva de aprendizaje para futuros usuarios.** "¿Cuándo usar Magnus, cuándo usar ITS?"

### 7.3 · Riesgos de Magnus v0.3 integrado

- **Crecimiento de complejidad del index.html actual.** Ya tiene 4.998 líneas. Agregar 7 sub-tabs + capa nueva + sidebar adicional podría llevarlo a 6.500-7.000 líneas. Mantenibilidad de un monolito de ese tamaño es limítrofe.
- **Necesidad eventual de modularización del frontend.** No hoy, pero en 3-6 meses podría ser obligatorio. Decisión postergable.
- **Sub-tabs en ficha pueden saturar.** 7 sub-tabs es el límite cognitivo. Necesita disciplina para no agregar más.
- **El concepto de unidad_territorial tiene que tener UI clara sin opacar el predio individual.** Si se hace mal, el usuario confunde "predio" con "unidad".

**Mitigaciones para v0.3:**

- Modularizar JS de index.html en archivos auxiliares (igual que se hizo con its/) cuando supere 6.000 líneas. Costo: ~1 día de refactor.
- Mantener disciplina de sub-tabs: si llega un 8º, alguno tiene que fusionarse o moverse.
- Diseñar la transición visual predio↔unidad con chip claro + breadcrumb visible.

---

## 8 · Conclusión del dictamen

**Recomendación: Magnus v0.3 integrado.**

Razones:

1. **Preserva el centro de gravedad correcto** (el mapa) que coincide con la naturaleza del negocio.
2. **Absorbe el 100% del valor ontológico del ITS v2** sin pagar el costo de un producto separado.
3. **Reutiliza ~80% del trabajo CSS/visual hecho** vía migración de tokens.
4. **Reutiliza el 100% del schema PostgreSQL** sin cambios.
5. **Costo de desarrollo medio** (4-6 semanas vs 3+ meses).
6. **Reversibilidad alta** — cada cambio es incremental al index.html actual.
7. **Curva de aprendizaje baja** — un solo modelo mental evolucionado, no dos.
8. **Mantiene la disciplina epistemológica** (estados, conflictos, hipótesis, autoridades) sin sacrificar nada.

**Pero hay una condición ineludible:** la modularización del index.html debe estar en el radar. Hoy 4.998 líneas. Post-v0.3 probablemente 6.500. En algún punto entre v0.3 y v0.5 hay que partir el monolito. Esa deuda hay que reconocerla ahora, no descubrirla después.

---

## 9 · Lo que este dictamen NO decide

Cosas que requieren decisión separada de Max:

1. **¿Se ejecuta el schema ITS en producción Supabase o en staging primero?** (sigue siendo válida la recomendación staging del `RUN_STAGING.md`).
2. **¿Orden de implementación de los 6 cambios A-F?** Habría que priorizar.
3. **¿Magnus v0.3 también absorbe las carpetas Dominga PE como nueva categoría de unidad territorial?** (probablemente sí, post-v0.3).
4. **¿Cuándo se modulariza el frontend?** Hoy no es urgente. Post v0.3 lo será.
5. **¿its.html se borra del repo o se mueve a `docs/visual_references/`?** Sugerencia: lo segundo.

---

## 10 · Próximo paso propuesto

Si Max aprueba la dirección v0.3 integrada:

- **Antes de codear**: producir mockup textual + esquema visual del panel derecho v0.3 enriquecido (sub-tabs nuevos) y de la capa "estado de conciliación" en el mapa
- **Después**: implementación incremental, sub-tab por sub-tab, con validación tuya en cada bloque
- **En paralelo**: ejecución staging del schema 0002+0002b para tener backend listo cuando los sub-tabs empiecen a consumir datos reales

---

## 11 · Honestidad operacional

Construí its.html en ~2 horas. Era código razonable. Pero respondía a una pregunta mal planteada por mí: "¿cómo materializo la ontología en una UI?". La pregunta correcta — la que tú formulaste antes de que yo respondiera — era: "¿cómo absorbe Magnus la ontología sin perder su naturaleza?". El dictamen es lo que debí pedir antes de codear, no después.

El trabajo hecho no se pierde: el schema, el CANON, los dossiers, los tokens visuales, el vocabulario de estados, la separación hecho/hipótesis — todo reutilizable en v0.3. Lo único que queda en standby es la cáscara de `its.html` como producto independiente.
