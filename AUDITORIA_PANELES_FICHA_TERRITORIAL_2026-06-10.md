# Auditoría de paneles y diálogos — EJE 3
### Magnus Radar v1-h2 · 2026-06-10 · inventario capa × atributo × utilidad operacional
### Estado: diagnóstico + diseño · SIN implementación (regla del mandato)

---

## 1. Método y alcance

Trazado directo de código y datos (sin especulación): los tres renderers de ficha (`renderH2Detail` ~L6751, `renderPredioPanel` ~L3348, `showSeia`/familia v0), la lista exacta de atributos que cada uno muestra, y las propiedades reales disponibles en cada GeoJSON (inventariadas en `ANALISIS_TRAZABILIDAD_CAPAS_CORREDOR_2026-06-10.md`). Alcance: H2, H1, Servidumbre AI, InterChile, Torres, RTK, Ruta 5, Matriz AI, Predios SII.

**Cómo decide hoy el renderer H2 qué mostrar:** `renderH2Detail` arma la ficha desde una lista FIJA de claves: título = `nombre→titular→descripcion→conflicto_id→id`; identificación = `rol_sii_actual|rol_sii`, `alias_historicos`, `inscripcion_CBR`; atributos = `titular_documental, titular, area_ha_catastral, tier¬, año, rol_capa, autoridad, titular_dominante, titular_sirviente, longitud_km, ancho_m, capas, enunciado, resolucion, evidencia, observacion, categoria_ocupacional`; más estado epistemológico¬, caveats¬, doctrinas¬, fuentes¬ (¬ = oculto en modo reunión). **Cualquier propiedad fuera de esa lista no existe para el usuario.**

---

## 2. Hallazgo central

El problema no es falta de datos: es que **el mapeo del renderer fue diseñado para las capas originales (capa_1, capa_5) y las capas incorporadas después no calzan con sus claves**. Resultado: las capas con mayor densidad documental renderizan fichas casi vacías, y una de ellas con título roto:

| Capa | Título que muestra hoy | Atributos que muestra hoy | Datos ricos que tiene y NO muestra |
|---|---|---|---|
| **Sector Lineal AI** (capa principal del corredor) | **"1" / "2"** (cae al fallback `p.id` — no tiene `nombre`) | tipo de servidumbre vía `tipo`→no se muestra; prácticamente solo el chip de capa + estado | `predio_sirviente`, `rol`, **`superficie_ha` (124,145 / 57,545)**, `concesionario` (Andes Iron), `fecha_plano`, `rev`, `estado` ("Vinculante"), `fuente` (AIPD-01), `etiqueta` lista para usar |
| **Perímetro RTK** (capa física canon) | "Perímetro CBR Daniel RTK 10m — Hijuela 2 Cominetti" ✓ | ninguno (sus claves no calzan: `precision_metros`, `observacion_operacional` ≠ `observacion`) | **superficie 2.164,97 ha**, **precisión 10 m**, `fuente_geometria`, `jerarquia_fuente`, `naturaleza_geo`, delta vs CBR declarado en `observacion_operacional` |
| **Matriz AI 2021** | **"Sin nombre"** (no tiene `nombre` ni `titular` — tiene `titular_actual`) | solo rol SII 24-5 + estado | **titular Andes Iron**, `instrumento_actual` (Rep FS 313 N°14.461), `fecha_adquisicion`, **`precio` UF 273.292**, **`cadena_previa` completa**, **`exclusiones`** (Jarpa/CMP/Fisco) |
| **Torres InterChile** | "Sin nombre" (no tiene `nombre`; `torre_id` no es clave de título) | ninguno | `torre_id` (T280–T288), `tipo`, `cuerpos`, **`ancho_servidumbre_m`**, `plano_pes`, **`afecta_predio`**, `nota` |
| **InterChile corredor** | nombre técnico "INTERCHILE_PES020_LOTE_C…" (críptico) | ninguno (claves no calzan) | **`observacion_obligatoria`** (¡el dato la declara obligatoria!), `datum/proyeccion`, `concesionaria`, `proyecto`, `fecha_plano`, `fuente_archivo`, `predio` legible |
| H2 Cominetti | ✓ correcto post-foco.3 | rol/alias/CBR/titular reservado/superficie SII/observación partición | **`superficie_por_autoridad`** (SII/RTK/CBR — el dato clave nuevo), `estructura_operacional`, `capa_origen` |
| H1 GH | ✓ correcto + banner 5ª | titular según SII + caveats¬ | (razonable; falta solo N3 relación AI) |
| Predios SII | ficha catastral completa | rol/superficie/manzana/estado/destino/avalúo/centroide/Δ | es **ficha catastral, no territorial** (diagnóstico del mandato); capa OFF en reunión |
| Ruta 5 | **SIN ficha** — la capa no tiene click handler | — | la faja MOP/expropiaciones (componente de la brecha 503 ha) vive en capa 5 f3, no clickeable desde la línea |

Corolario: en la mesa AI, un clic sobre **la servidumbre que motiva la reunión** muestra hoy "1". El clic sobre **la base de valorización** (RTK) no muestra ni superficie ni precisión. Ese es el delta entre ficha catastral y ficha territorial.

---

## 3. Inventario capa × atributo × utilidad operacional

Leyenda: ✅ visible hoy · 📦 existe en GeoJSON, no visible · ❌ no existe como dato (requiere trabajo documental o cruce) · 🔒 gated reunión (correcto OPSEC).

### 3.1 H2 Cominetti (canon)
| Atributo | Estado | Utilidad operacional |
|---|---|---|
| Estructura operacional (Resto A+B / Lote C) | ✅ (título+label) | identidad de mesa |
| Rol SII actual + aliases históricos | ✅ | trazabilidad SII |
| Inscripción CBR 2017 | ✅ | título de dominio |
| Superficie SII del cuerpo | ✅ | — (puede confundir sin autoridades) |
| **Superficies por autoridad (SII/RTK/CBR)** | 📦 `superficie_por_autoridad` | **núcleo N2: evita anclar 2.601 ha ante un técnico** |
| Partición A/B pendiente | ✅ (observación) | honestidad epistemológica |
| Mandato Magnus vigente | 📦 metadata capa (`Rep. 24.327`, detalle reservado) | N2 operacional (mostrar "Vigente", no economía) 🔒 detalle |
| Relación corredor AI (124,145 ha sobre 24-123) | ❌ cruce inter-capa | **N3: la cifra de la mesa** |
| Riesgos abiertos (brecha SII-RTK, P1, P2) | 📦 parcial (caveats¬) | N4 |
| Estado epistemológico / caveats / doctrinas / fuentes | ✅🔒 | auditoría interna |

### 3.2 H1 García Huidobro
| Atributo | Estado | Utilidad |
|---|---|---|
| Banner cláusula 5ª | ✅ | protección legal |
| Titular según SII/HousePricing + INFERENCIA | ✅ (🔒 estado) | encuadre |
| Relación AI (57,545 ha sobre 24-43) | ❌ cruce | N3 contexto corredor |

### 3.3 Servidumbre AI Dic-2025 ⟵ prioridad 1 de ficha
| Atributo | Estado | Utilidad |
|---|---|---|
| Título legible ("Servidumbre AI · rol 24-123 · 124,145 ha") | 📦 (`etiqueta` ya trae el texto) | hoy muestra "1"/"2" — **rompe credibilidad en mesa** |
| Predio sirviente + rol | 📦 | identifica el afectado |
| Superficie declarada | 📦 `superficie_ha` | **la cifra de negociación** |
| Concesionario (Andes Iron SpA) | 📦 | contraparte |
| Naturaleza ("Servidumbre legal minera ocupación y tránsito") | 📦 `tipo` | doctrina comparables: naturaleza jurídica |
| Plano fuente + fecha + rev ("Vinculante · entregado GH 17-may-2026") | 📦 | peso probatorio |
| Auditoría geométrica NO_AUDITADA (P1) | 📦 metadata | N4: incertidumbre declarada |

### 3.4 Perímetro RTK ⟵ prioridad 2
| Atributo | Estado | Utilidad |
|---|---|---|
| Superficie medida 2.164,97 ha | 📦 metadata (`superficie_medida_ha`) | **autoridad geométrica del activo** |
| Precisión 10 m + método (RTK s/vértices CBR) | 📦 | defendibilidad técnica |
| Delta vs CBR (+1 % declarado) | 📦 `observacion_operacional` | anticipa la pregunta del técnico |
| Jerarquía fuente primaria CBR | 📦 | peso probatorio |
| Nombre del operador en título | ✅ (dato de proceso interno) | considerar genérico "RTK 10 m" en N1 |

### 3.5 InterChile corredor + 3.6 Torres
| Atributo | Estado | Utilidad |
|---|---|---|
| Identificación legible (predio + plano PES) | 📦 | precedente en el mismo predio |
| `observacion_obligatoria` (trazado aproximado declarado por el plano) | 📦 | honestidad geométrica — **el dato la exige** |
| Torre: T-id, ancho servidumbre (46–68 m), afecta_predio | 📦 | tangibilidad + canon por torre |
| Año 2014 + concesionaria | 📦/✅ parcial | comparable voluntaria |

### 3.7 Matriz AI 2021
| Atributo | Estado | Utilidad |
|---|---|---|
| Título "Matriz AI 2021 · contexto histórico" | ✅ chip (foco.4) / título de ficha "Sin nombre" 📦 | — |
| NO representa perímetro real | ✅ tooltip sidebar (foco.4) / ❌ en ficha | el caveat debe viajar CON la ficha |
| Compra 2021: instrumento, fecha, precio UF 273.292 | 📦 | cadena/capacidad — **uso interno**, evaluar 🔒 en reunión |
| Cadena previa + exclusiones | 📦 | contexto dominial interno |

### 3.8 Predios SII (base 7.686) y 3.9 Ruta 5
Predios: ficha catastral completa ✅, sin lectura territorial (sin autoridades de superficie, sin relación corredor, sin estructura) — correctamente OFF en reunión. Ruta 5: **sin handler de clic**; la historia relevante (faja MOP, expropiaciones lotes 319–338-1, brecha 503 ha) existe en capa 5 f3 📦 pero no es alcanzable desde la línea visible.

---

## 4. Problemas UX transversales

1. **Tres plantillas de ficha conviven** (panel-header v0 para SEIA/predios; `padding:18px` para H2; exec panel reunión) con jerarquías y tipografías distintas → inconsistencia perceptible al alternar clics.
2. **Títulos rotos** ("1", "Sin nombre") en capas clave — daño directo de credibilidad (ya inventariado §2).
3. **Jerarquía plana**: los atributos se listan en grid uniforme 10–11 px; la cifra que importa (superficie, ha de servidumbre) pesa lo mismo que `rev: 0`. En proyección (reunión) 10 px es ilegible a 2 m.
4. **Claves crípticas en pantalla**: `rol capa`, `cat. ocupacional`, nombres técnicos de archivo como título (INTERCHILE_PES020…).
5. **Contraste**: `--muted` sobre fondo oscuro funciona en monitor, marginal en proyector; los chips epistemológicos (HECHO verde / INFERENCIA ámbar / HIPÓTESIS) son el mejor patrón existente — extenderlo, no reemplazarlo.
6. **El dato clave nuevo no viaja**: `superficie_por_autoridad` quedó en el GeoJSON pero ningún renderer lo conoce (consecuencia del patrón lista-fija).
7. Sin estado vacío informativo: cuando una ficha no tiene atributos mapeados, no dice "sin datos" — simplemente queda muda.

---

## 5. Diseño — Estándar de Ficha Territorial (4 niveles) · NO implementar aún

Plantilla única para TODAS las capas (reemplaza las divergencias), con render condicional por disponibilidad y gates OPSEC por modo:

**N1 · Identificación** — Qué es esto.
`titulo_operacional` (nuevo campo estándar por feature; fallback inteligente: etiqueta→nombre→torre_id→predio_sirviente→capa+rol) · rol(es) SII + aliases · superficie con SU autoridad declarada · fuente primaria · estado epistemológico (chip; en reunión se muestra solo si es HECHO — propuesta, decisión OPSEC pendiente).

**N2 · Operacional** — Qué sabemos del activo. (ejemplo H2)
Mandato: Vigente 🔒detalle · Estructura: Resto A+B + Lote C · Autoridad geométrica: RTK · **RTK 2.164,97 ha / CBR 2.139,35 / SII 2.600,97** (tabla de autoridades SIEMPRE junta — nunca una cifra sola).

**N3 · Relación corredor AI** — Qué lo cruza.
Servidumbre AI: 124,145 ha · Plano AIPD-01-AI-AIP001 · Vinculante · Auditoría: Pendiente. **Mecanismo propuesto (diseño):** join en runtime por rol SII contra `servidumbre_andes_iron.geojson` ya cargado en `window.__H2_LAYERS_DATA` (cero datos nuevos, cero capas nuevas — cumple regla final); alternativa estática: props de relación pre-calculadas. Decisión en implementación.

**N4 · Riesgos abiertos** — Qué falta.
Brecha SII–RTK: Abierta (≈436 ha) · Partición A/B: Pendiente · Auditoría AI: Pendiente. Fuente: caveats + backlog P1/P2/P3 (mapeo directo desde `BACKLOG_CORREDOR_P1_P2`).

**Reglas del estándar:** (a) ninguna superficie sin autoridad al lado; (b) claves en lenguaje de mesa, no de schema; (c) cifra principal en cuerpo 16–18 px, metadatos 11–12 px; (d) caveats geométricos viajan con la ficha (matriz: "NO representa perímetro" dentro del panel, no solo tooltip); (e) los gates de reunión actuales se conservan; la matriz evalúa 🔒 de precio/cadena en modo reunión; (f) estado vacío explícito ("ficha mínima · datos en reconciliación").

**Contenido N1–N4 por capa** (resumen): Sector AI = N1 etiqueta+naturaleza, N2 superficie+concesionario+plano+vinculante, N3 inverso (a quién afecta), N4 auditoría pendiente · RTK = N1 método+precisión, N2 superficie medida+delta CBR, N4 brecha SII · InterChile/Torres = N1 legible+año, N2 ancho/afecta_predio, N4 trazado aproximado declarado · Matriz = N1 contexto histórico+NO perímetro, N2 compra 2021 🔒evaluar, N4 geometría envolvente.

---

## 6. Priorización sugerida (para cuando se autorice implementar)

1. **Sector Lineal AI** — título + N1/N2 (es la capa de la mesa; hoy dice "1").
2. **RTK** — superficie+precisión visibles (base de valorización).
3. **H2** — tabla de autoridades (`superficie_por_autoridad` ya está en el dato).
4. InterChile + Torres — identificación legible + observación obligatoria.
5. Matriz — caveat en ficha + decisión 🔒 reunión.
6. Plantilla unificada + jerarquía tipográfica (transversal).
7. N3 join por rol (cruce corredor).
8. Ruta 5: decisión de producto (handler hacia la historia MOP de capa 5 f3, o documentar que es solo referencia visual).

## 7. Cumplimiento de la regla final

NO se agregaron capas, IA, scoring ni datos nuevos en este documento. Todo lo propuesto reutiliza propiedades existentes de los GeoJSON o cruces de capas ya cargadas. La única creación de datos sugerida es `titulo_operacional` (campo de presentación, no de evidencia) y queda para la fase de implementación autorizada.

---

## ADDENDUM — EJE 3.1–3.5 formalizados + Sprint UX-A ejecutado (2026-06-10, v1.2-foco.5)

**EJE 3.1 · Criterio rector (regla nueva canonizada):** `ninguna_capa_puede_mostrar_menos_información_que_la_importancia_que_tiene_en_el_caso`. La tabla de jerarquía invertida de Max (Servidumbre AI/RTK importancia máxima ↔ ficha muy pobre; Predios SII importancia baja ↔ ficha rica) queda como test de regresión permanente: cualquier capa nueva debe pasar por esta matriz antes de publicarse.

**EJE 3.2 · Sprint UX-A — EJECUTADO con autorización expresa:** P1 Servidumbre AI: ficha ahora titula "Servidumbre AI · H2 (Cominetti)" y muestra superficie 124,145 ha (plano AI · Dic-2025), rol, concesionario, predio sirviente, naturaleza jurídica, estado Vinculante, plano Dic-2025 Rev.0 y auditoría geométrica Pendiente (P1). P2 RTK: titula "Perímetro RTK · Hijuela 2", superficie 2.164,97 ha (RTK 2026 · autoridad geométrica vigente), precisión 10 m, jerarquía primaria, observación con delta CBR. P3 H2: bloque "Autoridades de superficie · H2 total" con RTK 2.164,97 destacada / CBR 2.139,35 / SII 2.600,97 + brecha ≈436 ha en reconciliación (fuente: `metadata.superficies_h2_totales` agregada a capa_1 con fuentes declaradas). Bonus del mismo mapeo: Torres ("Torre T280", tipo, ancho servidumbre, afecta predio), InterChile (título humano + observación obligatoria visible), Matriz (titular/instrumento/adquisición + "Envolvente conceptual · NO representa perímetro real" EN la ficha; precio/cadena/exclusiones gated a modo interno).

**EJE 3.3 · Regla de lenguaje:** aplicada en fichas (títulos operacionales, labels humanos). Pendiente menor en sidebar: "(canon)", "capa física", "(raster)" — inventariado en UX-CARTO §8.

**EJE 3.4 · Regla de autoridad:** implementada en las fichas tocadas — ninguna superficie se muestra sin autoridad: "(SII · cuerpo catastral)", "(RTK 2026 · autoridad geométrica vigente)", "(plano AI · Dic-2025)". Esta regla es extensión UI de las doctrinas no-superficie-única y UF-total-HECHO.

**EJE 3.5 · Preset reuniones AI:** verificado CONFORME al set aprobado (ON: H2, H1, RTK, Servidumbre AI, InterChile, Torres · OFF: ortofoto, matriz, línea 26 km, predios SII) — implementado en foco.3/foco.4, sin cambios adicionales necesarios.

**Regla de cierre del mandato:** cada clic debe responder qué es / por qué importa / qué evidencia lo respalda / qué incertidumbres siguen abiertas / qué decisión habilita — las fichas P1/P2/P3 ya responden las cinco; el resto de capas queda mapeado en §3 y priorizado en §6.

*EJE 3 ejecutado 2026-06-10 · fuentes: renderH2Detail/renderPredioPanel trazados línea a línea + inventario de props del análisis de trazabilidad · Sprint UX-A implementado bajo autorización expresa; el resto del estándar sigue en diseño.*
