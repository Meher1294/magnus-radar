# Análisis de trazabilidad territorial — Foco "Corredor · Estancia La Higuera"
### Magnus Radar v1-h2 · `?foco=corredor` · 2026-06-10
### Regla aplicada: cada afirmación cita su fuente (archivo GeoJSON, código, o memoria operacional). Lo no verificable se marca **NO VERIFICADO**. Sin opinión estética.

---

## 0. Método y universo de evidencia

Fuentes inspeccionadas directamente en esta sesión (evidencia de primer nivel para este informe):

- Los 8 GeoJSON de `web/v1-h2/geojson/` (metadata + propiedades por feature + geometrías completas).
- `tiles/h2_ortofoto.jpg` (854 KB) + `docs/ingesta_ortofoto_h2/mosaico_amplio_meta.json`.
- Configuración `H2_LAYERS` / `H2_RASTERS` en `index.html` (colores, defaults, meta).
- Cálculo geométrico propio: shoelace esférico por polígono (verificación independiente de superficies declaradas).

Lo que los archivos **declaran** sobre sus fuentes externas (CBR, planos AI, SII, RTK) es HECHO *sobre el archivo*; el documento externo mismo (escritura, plano físico) no fue inspeccionado en esta sesión salvo que se indique. Esa distinción se mantiene en todo el informe.

---

## 1. Diagnóstico general

El foco corredor monta 9 capas: 8 vectoriales + 1 raster. Su calidad epistemológica es **heterogénea y está declarada dentro de los propios archivos** — el sistema viene etiquetado de origen con `estado_canonico`, `fuentes`, `caveats` y doctrinas aplicables por feature, lo que permite trazabilidad real y no reconstruida.

Estructura probatoria del corredor en una frase: **el activo (H2) está soportado por tres autoridades de superficie que NO coinciden** (SII 2.600,97 ha · RTK 2.164,97 ha · CBR 2.139 ha), **la afectación AI está soportada por un plano vinculante de la propia contraparte** (AIPD-01-AI-AIP001 Dic-2025, 181,69 ha), y **el precedente económico de servidumbre en el mismo predio existe** (InterChile 2014, canon pagado), pero con trazado que el propio plano declara aproximado. Las piezas débiles: la línea "Sector Lineal 26 km" antigua (HIPÓTESIS declarada), la servidumbre 924-644 (sin titular ni geometría) y el envoltorio matriz (bbox, no perímetro).

---

## 2. Tabla capa por capa

Convención: **Rep.** = qué representa · **Por qué** = rol en el visor · **Fuente** = la que declara el archivo · **Epis.** = estado epistemológico declarado en archivo · **Geom.** = cómo se determinó · **Precisión** · **Caveats** · **Decisión** que habilita · **Publicabilidad**.

### 2.1 H2 Cominetti (canon) — `capa_1_h2_cominetti.geojson`
| Campo | Contenido |
|---|---|
| Rep. | El activo: Hijuela 2 Cominetti. 4 polígonos: Lote C (rol 24-160) + 3 polígonos del rol 24-123 ("Resto Lotes A+B"). |
| Por qué | Es el objeto del mandato Magnus (metadata: `mandato.fuente = Rep. 24.327/2026`, detalle reservado). Centro de la narrativa del corredor. |
| Fuente | `capa_origen: "SII (KMZ-06 catastro)"` por feature; inscripciones CBR 2017 declaradas (fs 1.671 N°1.159 y fs 1.729 N°1.197, La Serena); fuentes EVT: `EVT-H2-MAGNUS-MANDATO-20260414`, `P2.8 RESUELTO`, `CANON_HIJUELA2_v2`. |
| Epis. | **HECHO** (estado_canonico en las 4 features; metadata `CANON_alta_confianza`, 2026-05-31). Matiz: el HECHO es la identidad y titularidad registral; la *geometría* es catastro SII, no mensura propia. |
| Geom. | Polígonos tomados del catastro SII (KMZ-06). 300 vértices totales (18 + 223 + 5 + 54). Extensión 13,1 × 4,9 km. |
| Precisión | La del catastro SII gráfico: decenas de metros típicas, **sin precisión declarada en archivo**. Verificación propia: área dibujada (2.591,81 ha) vs declarada SII (2.600,97 ha) = consistencia interna −0,35 %. |
| Caveats | `caveats: []` en archivo. Caveat estructural no escrito en la capa: superficie SII ≠ RTK ≠ CBR (ver §4). Doctrinas declaradas en metadata: rol-sii-no-es-identidad-territorial, homonimia, no-derivar-estrategia-sin-capa-ocupación, unidad-territorial-histórica. |
| Decisión | Identificación del activo ante cualquier interlocutor; ancla de la conversación con AI; base de la ficha territorial. |
| Publicable | Sí (ya saneada: titular "Reservado · mandato Magnus vigente"). Apta contraparte y municipio. |

### 2.2 H1 García Huidobro contextual — `capa_h1_garcia_huidobro_contextual.geojson`
| Campo | Contenido |
|---|---|
| Rep. | Hijuela 1 (roles 24-42 y 24-43), colindante norte/poniente; 5 polígonos, 2.092 ha SII sumadas. |
| Por qué | Contexto del corredor: la servidumbre AI cruza H1 (57,5 ha sobre 24-43) antes/después de H2. Sin H1 el corredor no se entiende como continuo. |
| Fuente | `capa_origen: SII (KMZ-06)`; titularidad "García Huidobro Sanfuentes Felipe **(según SII · informe HousePricing 12-mar-2026)**". |
| Epis. | **INFERENCIA** (declarada en archivo, metadata `INFERENCIA_NO_OPERACIONAL`). Titularidad no verificada contra CBR. |
| Geom. | Catastro SII. 390 vértices. |
| Precisión | Catastral SII, sin cifra declarada. |
| Caveats | En archivo, triple: "Magnus NO opera comercialmente sobre H1" + `no_comercial` (cláusula 5ª mandato Cominetti) + "idem 24-42". El visor renderiza banner cláusula 5ª al clic (verificado en vivo hoy). |
| Decisión | Encuadre territorial; deslinde legal explícito de qué NO hace Magnus. No habilita ninguna decisión comercial. |
| Publicable | Sí con el banner activo (ya gateado). El titular SII es dato público SII. |

### 2.3 Matriz AI 2021 envoltorio — `estancia_la_higuera_matriz_2021.geojson`
| Campo | Contenido |
|---|---|
| Rep. | Envoltorio conceptual de la Estancia La Higuera comprada por Andes Iron en 2021. 1 MultiPolygon. |
| Por qué | Contexto histórico: H2 es enclave dentro de la matriz AI. Categoría declarada: `contexto_historico`. |
| Fuente | Declarada en archivo: escritura `Rep FS 313 N°14.461 / 16-ago-2021 — CBR La Serena`; precio `UF 273.292,2657 al contado`; cadena previa completa (Agua Grande → El Tofo 2007 → Barrick → Cía. Minera Nevada 2016 USD 9.968.943 → Andes Iron 2021); exclusiones (Hijuelas Jarpa 1-2-3 segregadas 1990, 877,33 ha CMP, lotes Fisco MOP). Escritura misma: no inspeccionada en esta sesión (consta en data room según memoria operacional). |
| Epis. | Los **datos** (precio, cadena, exclusiones): HECHO declarado con fuente registral. La **geometría**: NO es un hecho — es un **bbox de 5 vértices, 119,9 × 49,7 km** (verificado hoy por conteo). Metadata además declara EVT `_PENDIENTE_CANONIZACION`. |
| Geom. | Rectángulo envolvente. No proviene de plano ni mensura. Caso fundante de la doctrina bbox-no-es-perímetro. |
| Precisión | Nula como perímetro (≈56× la superficie real de referencia; cubre océano). Válida solo como "existe una matriz en esta zona". |
| Caveats | El archivo NO declara caveat geométrico — **omisión relevante**: el consumidor desprevenido puede leer el rectángulo como deslinde. |
| Decisión | Solo narrativa de cadena dominial (quién compró qué, cuándo, a qué precio). Comparable VENTA_DOMINIO (no promediable con servidumbres — doctrina comparables-por-naturaleza-jurídica). |
| Publicable | Geometría: **no defendible ante terceros** (por eso quedó default OFF en el preset reunión, commit 354db29). Datos de escritura: públicos por naturaleza registral, pero exponerlos señaliza nuestro nivel de estudio → tratarlos como interno-salvo-decisión. |

### 2.4 Perímetro RTK — `perimetro_rtk_daniel.geojson`
| Campo | Contenido |
|---|---|
| Rep. | Perímetro físico-legal cerrado de Hijuela 2, medido en terreno. 1 polígono, 71 vértices. |
| Por qué | Es la **capa física canon** del activo: la mejor geometría disponible de H2. Base de valorización (declarado en archivo). |
| Fuente | Declarada: `RTK_10m_Daniel_Martinez_Zurita`, interpolación de 26 vértices C-1→C-26 **del plano CBR coordenado**; `source_truth: fuente_primaria_CBR`; EVT-H2-RTK-DANIEL-202605; fecha carga 2026-05-17. |
| Epis. | **HECHO** (identidad_fisica, jerarquía de fuente primaria, confianza operacional alta — todo declarado en archivo). |
| Geom. | Levantamiento RTK con interpolación sobre vértices del plano CBR: 71 puntos desde 26 vértices. |
| Precisión | **10 m declarados** (única capa del corredor con precisión numérica declarada). Área: 2.164,97 ha declarada · 2.155,72 ha recalculada hoy (−0,4 %, consistente) · vs CBR 2.139 ha = delta +1 % que el propio archivo declara "tolerancia normal". |
| Caveats | El nombre de la feature expone el nombre de pila del operador ("Daniel") — dato de proceso interno, menor pero visible al clic. |
| Decisión | Superficie defendible para valorización y mesa AI; resolución de la brecha SII (§4). |
| Publicable | Sí (es la carta geométrica fuerte). Considerar renombrar la feature si molesta el dato de operador. |

### 2.5 Servidumbres H2 — `capa_5_servidumbres.geojson`
| Campo | Contenido |
|---|---|
| Rep. | 4 LineStrings esquemáticas: (f0) "Sector Lineal Andes Iron Dominga→Totoralillo" 26 km/ancho 50 m/160 ha; (f1) eje InterChile 2014; (f2) servidumbre histórica 924-644 (1994); (f3) faja Ruta 5 (expropiaciones MOP 2011-2017, Min. Golborne, lotes 319/320/331-1/331-3/333/334/335/338-1). |
| Por qué | Inventario de gravámenes y afectaciones que explican el premio de mesa y la brecha de superficie. |
| Fuente | Metadata: CADENA_REGISTRAL_HIJUELA_2, MEMO_EIA_Dominga_Sector_Lineal, XPU_Analisis_EIA. f2 cita "nota marginal inscripción matriz H2 1990". |
| Epis. | **Mixta y declarada por feature**: f0 = HIPÓTESIS; f1 = HECHO jurídico con `TRAZADO_APROXIMADO`; f2 = HECHO de existencia con titular dominante y geometría PENDIENTES; f3 = HECHO consumado (dominio Fisco). |
| Geom. | **12 vértices para 4 líneas** — esquemática pura. Caveat global del archivo: "geometrías aproximadas… hasta recuperar capas QGIS originales o vectorizar planos oficiales". f0 además declara `artefacto_perdido: andes_iron.geojson`. |
| Precisión | Sin valor métrico. Es un diagrama georreferenciado, no un trazado. |
| Caveats | Los declarados arriba + f0 contiene lectura estratégica propia (choke point "PAS Art 96 Reglamento SEIA · cambio uso suelo rural"). |
| Decisión | Interna: checklist de gravámenes a reconciliar; insumo de la brecha 503 ha (f3). |
| Publicable | **f0 interno-only** (revela lectura propia del EIA y estado de conocimiento; además quedó superada por 2.6). f2 interno (incompleta). f1/f3 publicables como existencia, no como trazado. |

### 2.6 Sector Lineal AI Dic-2025 — `servidumbre_andes_iron.geojson`
| Campo | Contenido |
|---|---|
| Rep. | La servidumbre legal minera de ocupación y tránsito de AI sobre el corredor: 2 polígonos — 57,545 ha sobre rol 24-43 (H1) + 124,145 ha sobre rol 24-123 (H2) = **181,69 ha**. |
| Por qué | Es **la afectación que motiva la mesa con AI**. Cierra la hipótesis de 2.5-f0 (metadata: `cierra_hipotesis: artefacto_perdido_andes_iron_geojson`). |
| Fuente | Declarada: **Plano Andes Iron AIPD-01-AI-AIP001, Diciembre 2025, Rev. 0, "Ejecutó: Angela Suckel D'Arcangeli", entregado por GH 17-may-2026**. Estado declarado: "Vinculante". El plano físico no está en el repo web → su contenido exacto: NO VERIFICADO en esta sesión (sí citado consistentemente en metadata + 2 features). |
| Epis. | **HECHO** (estado_canonico en ambas features) en cuanto a: existencia del plano, superficies declaradas y predios sirvientes. La **fidelidad de la vectorización** plano→GeoJSON es un eslabón sin auditoría declarada: no hay RMSE, método ni fecha de georreferenciación en el archivo → ese eslabón específico: **NO VERIFICADO**. |
| Geom. | 2 polígonos, 37 vértices, 5,0 × 2,5 km. Origen: vectorización del plano AI (método no declarado). |
| Precisión | No declarada. Las superficies del archivo (57,545/124,145) coinciden con el meta del visor (57,5+124,1=181,6) ✓. |
| Caveats | Declarado: "Servidumbre legal minera vinculante Dic-2025". Implícito: es el plano de la CONTRAPARTE — su trazado es la pretensión de AI, no un acuerdo. |
| Decisión | Núcleo de F2/F3 de la mesa: qué superficie exacta pretende AI, sobre qué roles, con qué naturaleza jurídica (forzosa minera ≠ voluntaria — doctrina comparables). |
| Publicable | Ante AI: sí (es su propio plano). Ante terceros: prudencia — revela el estado de la negociación. Municipio: solo como "existe afectación minera en trámite", sin el polígono fino. |

### 2.7 InterChile servidumbre 2014 — `interchile_servidumbre_2014.geojson`
| Campo | Contenido |
|---|---|
| Rep. | Franja de servidumbre eléctrica voluntaria línea Maitencillo–Pan de Azúcar 2×500 kV sobre H2 (planos PES-020 Lote C / PES-021 Resto H2). 1 MultiPolygon. |
| Por qué | (a) Infraestructura real que cruza el corredor; (b) **precedente económico**: servidumbre voluntaria con canon pagado en el MISMO predio; (c) el archivo declara que el plano 2014 "reconoce separación predial funcional entre Lote C y Resto Hijuela 2" — valor probatorio de identidad territorial. |
| Fuente | Declarada: `ISA_002___PES_020_21.10.2015.pdf / ISA_002___PES_021_21.10.2015.pdf` (planos ISA/InterChile, julio 2014), datum WGS84/UTM 19S, carga 2026-05-17, EVT-H2-INTERCHILE-2014. PDFs no inspeccionados en esta sesión → contenido exacto NO VERIFICADO aquí; cita interna consistente. |
| Epis. | **HECHO** jurídico (metadata CANON_alta_confianza) con honestidad geométrica explícita en archivo: `naturaleza_geo: fisico_legal_aproximado`, `jerarquia_fuente: secundaria`, `confianza: media`, `precision_metros: null`, `tiene_desfase_declarado: true`, y la observación de que **el propio plano declara trazado aproximado** no validado por criterios eléctricos/mecánicos. |
| Geom. | Vectorización de planos PES (43 vértices, 0,9 × 3,0 km). |
| Precisión | No cuantificada; desfase declarado. |
| Caveats | Los anteriores. RUT concesionaria ya saneado ("RUT_RESERVADO"). |
| Decisión | Comparable SERVIDUMBRE_VOLUNTARIA para la mesa AI (sin promediar con forzosa minera); prueba de convivencia histórica del predio con infraestructura. |
| Publicable | Sí como franja indicativa, declarando el aproximado. |

### 2.8 InterChile 9 torres físicas — `interchile_torres.geojson`
| Campo | Contenido |
|---|---|
| Rep. | 9 puntos: torres T280–T288, con tipo (A/D), cuerpos, ancho de servidumbre por torre (46–68 m), plano PES de origen y flag `afecta_predio` (T280: false — "solo referencia"). |
| Por qué | Infraestructura física consolidada 2014: lo más tangible del corredor para un tercero. |
| Fuente | Misma familia ISA/InterChile (planos PES-020/021), EVT-H2-INTERCHILE-2014. |
| Epis. | **HECHO** (infraestructura). Las torres existen físicamente; posición tomada de los planos. |
| Geom. | 9 puntos, datum declarado WGS84 UTM 19S. |
| Precisión | No declarada; hereda el aproximado de su plano fuente. Verificable barato contra ortofoto en el tramo cubierto (§6). |
| Caveats | T280 no afecta el predio (declarado). |
| Decisión | Ancla visual/realidad en cualquier mesa; cruce con canon pagado por torre. |
| Publicable | Sí. |

### 2.9 Ortofoto sector oriental (raster) — `tiles/h2_ortofoto.jpg`
| Campo | Contenido |
|---|---|
| Rep. | Mosaico fotográfico 2125×2400 px del sector oriental de H2 (asentamiento + cruce sector lineal). |
| Por qué | Evidencia visual de ocupación e infraestructura; fondo de verdad para validar capas vectoriales en su extensión. |
| Fuente | `mosaico_amplio_meta.json`: 846 tiles, bbox [-71.2057, -29.5181, -71.1920, -29.5046] = 1,32 × 1,50 km. Código declara "Mosaico 2026-05 · 0.4 m/px · 6.8 km² = 12.6 % perímetro RTK". **Proveedor/fecha de captura de los tiles: no declarados en el meta → NO VERIFICADO** (el meta registra la ingesta, no el sensor). |
| Epis. | **Capa auxiliar** (evidencia visual). No prueba límites ni titularidad; prueba estado físico observable a la fecha del mosaico. |
| Geom. | Image source MapLibre con 4 esquinas fijas (georreferenciación por bbox). |
| Precisión | 0,4 m/px nominal de píxel; la precisión de POSICIONAMIENTO depende del georreferenciado del bbox, no declarada. |
| Caveats | Cubre solo 12,6 % del perímetro; sesgo de disponibilidad (doctrina ausencia-de-observación: lo no cubierto no es "sin ocupación"). |
| Decisión | Lectura de ocupaciones (junto a EVT-H2-OCCUPATION-BASELINE-20260531, memoria); comunicación visual con municipio. |
| Publicable | Sí. |

---

## 3. Detalle solicitado: capa H2 Cominetti (canon), polígono por polígono

Verificado hoy contra el archivo y recálculo geométrico independiente:

**1. ¿Cuántos polígonos? 4** (todos `Polygon`, 1 anillo cada uno, sin huecos).

**2-3-6. Tabla de trazabilidad polígono → rol → superficie → fuente:**

| # | Nombre en archivo | Rol SII actual | Alias hist. | Sup. SII declarada (ha) | Sup. geométrica recalculada (ha) | Vértices | Inscripción CBR declarada | Origen geometría |
|---|---|---|---|---|---|---|---|---|
| f0 | Cominetti H2 · **Lote C** | **24-160** | 24-4 | 299,18 | 298,10 | 18 | fs 1.729 N°1.197 / 2017 La Serena | SII (KMZ-06 catastro) |
| f1 | Cominetti H2 · **Resto Lotes A+B** | **24-123** | 24-48 | 1.399,93 | 1.395,11 | 223 | fs 1.671 N°1.159 / 2017 La Serena | SII (KMZ-06 catastro) |
| f2 | Cominetti H2 · Resto Lotes A+B | 24-123 | 24-48 | 0,15 | 0,15 | 5 | fs 1.671 N°1.159 / 2017 La Serena | SII (KMZ-06 catastro) |
| f3 | Cominetti H2 · Resto Lotes A+B | 24-123 | 24-48 | 901,71 | 898,45 | 54 | fs 1.671 N°1.159 / 2017 La Serena | SII (KMZ-06 catastro) |
| — | **Total capa** | | | **2.600,97** | **2.591,81** | 300 | | |

La consistencia interna SII-declarado vs geometría-dibujada es −0,35 % (sana). f2 es una astilla de 0,15 ha del propio catastro (5 vértices), no un lote operativo.

**4. Relación entre Resto A, Resto B, Lote C, 24-123, 24-160, alias 24-48:**

- **Lote C = rol 24-160**, ex rol **24-4** (mutación declarada en metadata y en memoria P2.8: 24-4 → 24-160). Inscripción propia (fs 1.729 N°1.197/2017).
- **"Resto Lotes A+B" = rol 24-123**, ex rol **24-48** (mutación 24-48 → 24-123). Inscripción propia (fs 1.671 N°1.159/2017). El rol se dibuja en **3 polígonos no contiguos** (1.399,93 + 0,15 + 901,71 = 2.301,79 ha SII) — doctrina rol-≠-unidad-geográfica: un rol = 1..n geometrías.
- **La capa NO distingue Lote A de Lote B**: la etiqueta es unificada "Resto Lotes A+B". Si f1 corresponde a "A" y f3 a "B" (o viceversa) **NO está declarado en el archivo → NO VERIFICADO**. Dato cruzado relevante: el plano AI AIPD-01 llama al predio sirviente de rol 24-123 "Resto Hijuela 2 … **Lote A (Lote 2A)**", y el plano histórico intervenido (ITS-CARTO-PLANO-0001, memoria) trae sublotes 1a/1b/2a/2b/3a/3b/C con anotaciones 863+976+300 = 2.139 ha que cuadran EXACTO con la cifra CBR — la correspondencia sublote→polígono SII es una tarea de reconciliación pendiente, no un hecho.

**5. ¿La geometría mostrada es el 100 % de Hijuela 2 o solo el subconjunto del corredor AI?**

Es la **representación catastral SII completa de los roles 24-123 + 24-160** — extensión 13,1 × 4,9 km, y los 4 bboxes caen dentro del bbox del perímetro RTK (verificado hoy). NO es un recorte del corredor AI (el sector lineal mide 5,0 × 2,5 km). Ahora bien, "100 % de Hijuela 2" exige declarar autoridad, porque hay tres que no coinciden:

| Autoridad | Superficie H2 | Fuente |
|---|---|---|
| SII (catastro, suma 4 polígonos) | 2.600,97 ha | capa_1, declarado por feature |
| RTK Daniel (perímetro físico-legal medido) | 2.164,97 ha (recalc. 2.155,72) | perimetro_rtk, precisión 10 m |
| CBR (cifra declarada en plano coordenado) | 2.139 ha | citada en perimetro_rtk y plano histórico |

Delta SII vs RTK ≈ **+436 ha**. Candidato documental principal (declarado en capa 5, f3): expropiaciones faja Ruta 5 (MOP 2011-2017) como "componente principal de brecha 503 ha". Por doctrina (29,9 % = zona de verificación fina), la brecha **se declara, no se cierra con hipótesis**: la reconciliación SII−RTK−CBR es trabajo pendiente con acción específica (§7).

---

## 4. Separación HECHO / INFERENCIA / HIPÓTESIS (consolidada)

**HECHO (con fuente declarada en archivo):**
- Identidad y roles de H2 (24-123/24-160, ex 24-48/24-4) con inscripciones CBR 2017.
- Perímetro RTK 10 m, 2.164,97 ha, desde vértices del plano CBR coordenado.
- Existencia y datos de la compra matriz AI 2021 (Rep FS 313 N°14.461, UF 273.292, cadena previa) — *el dato, no el rectángulo*.
- Plano de servidumbre AI AIPD-01-AI-AIP001 Dic-2025: 124,145 ha (24-123) + 57,545 ha (24-43), vinculante, entregado 17-may-2026.
- Servidumbre InterChile 2014 y 9 torres T280–T288 (jurídico + infraestructura), con trazado declaradamente aproximado.
- Expropiaciones faja Ruta 5 (MOP 2011-2017, lotes individualizados).
- Existencia de servidumbre histórica 924-644 (nota marginal 1990).

**INFERENCIA (declarada como tal):**
- Titularidad H1 García Huidobro (fuente SII + informe HousePricing 12-mar-2026, sin CBR).
- Correspondencia sublotes históricos (A/B) ↔ polígonos SII f1/f3 (no declarada — pendiente).

**HIPÓTESIS (declarada como tal):**
- Trazado de la línea "Sector Lineal Dominga→Totoralillo 26 km" de capa 5 (f0) — superada para el tramo H2/H1 por el plano AIPD-01, pero el resto del trazado comuna-wide sigue siendo hipótesis con artefacto perdido.

**AUXILIAR:** ortofoto (evidencia visual, no probatoria de límites).

**NO VERIFICADO (en esta sesión, desde archivos):** contenido exacto de los PDFs ISA PES-020/021; plano físico AIPD-01; informe HousePricing; método/RMSE de vectorización del sector lineal; proveedor y fecha de captura del mosaico ortofoto.

---

## 5. Caveats de precisión (resumen transversal)

1. **Solo el RTK declara precisión numérica (10 m).** Ninguna otra capa del corredor tiene `precision_metros` poblado (InterChile lo declara explícitamente `null` con desfase reconocido — honestidad correcta; las demás simplemente no lo traen).
2. Catastro SII (H2 y H1): precisión gráfica catastral típica de decenas de metros, no declarada.
3. Sector Lineal AI: superficies declaradas finas (3 decimales) sobre una vectorización sin auditoría de georreferenciación — la cifra es del plano; el dibujo es nuestro.
4. Matriz: bbox sin valor de perímetro (5 vértices, 120 km).
5. Capa 5 servidumbres: 12 vértices/4 líneas = esquema.
6. Ortofoto: 0,4 m/px de píxel ≠ precisión de posicionamiento (bbox de 4 esquinas, sin RMSE).

---

## 6. Riesgos de interpretación

1. **Leer el rectángulo matriz como deslinde de la propiedad AI** — el riesgo más grave frente a terceros; mitigado en reunión (default OFF) pero el archivo sigue sin caveat geométrico interno.
2. **Sumar o promediar naturalezas jurídicas distintas**: InterChile (voluntaria, canon pagado), AI Dic-2025 (legal minera, pretensión vinculante), Ruta 5 (expropiación consumada), 924-644 (histórica indeterminada) son economías distintas — prohibido interpolar (doctrina comparables).
3. **Tomar la superficie SII (2.601 ha) como superficie del activo** en una valorización — el archivo canon de valorización es el RTK (2.165 ha); la diferencia es justamente parte del caso (expropiaciones).
4. **Confundir la pretensión AI con un acuerdo**: el polígono Dic-2025 es el plano de la contraparte ("vinculante" en cuanto instrumento entregado), no una servidumbre constituida de común acuerdo ni valorizada.
5. **Leer la línea de 26 km de capa 5 como trazado real** — es hipótesis declarada con artefacto perdido.
6. **Inferir "sin ocupación" donde la ortofoto no cubre** (87,4 % del perímetro sin mosaico).
7. **Doble conteo Sector Lineal**: coexisten la línea esquemática (capa 5 f0) y los polígonos vinculantes (capa 2.6) — en el visor ambas pueden encenderse; en análisis usar solo 2.6 para el tramo H2/H1.

---

## 7. Respuestas explícitas

**¿Por qué esas capas y no otras?** Selección del preset reunión (DOCUMENTO_A/B + sesión 2026-06-10): criterio doble foco+OPSEC — entran las capas que (a) construyen el corredor físico-jurídico GH–Cominetti–Sector Lineal–servidumbres y (b) no exponen aparato interno. Quedaron fuera: conflictos canonizados, titularidad interna 8 sub-lotes, ocupaciones, predios 885 (estrategia/PII interna), y todas las comuna-wide (ruido). Matriz quedó como toggle OFF por geometría indefendible. La capa 5 (servidumbres esquemáticas) está disponible en el listado del foco — su f0 es interno-only por contenido estratégico (ver abajo).

**¿Cómo se determinó el trazado del Sector Lineal AI?** Dos generaciones: (1) línea esquemática 26 km (capa 5 f0) construida desde MEMO/Análisis XPU del EIA Dominga — HIPÓTESIS declarada, con `andes_iron.geojson` original perdido y vectorización del plano A-104 del EIA pendiente; (2) **la vigente**: polígonos vectorizados desde el plano de la propia Andes Iron `AIPD-01-AI-AIP001 (Dic-2025, Rev.0)`, entregado por García Huidobro el 17-may-2026 — 124,145 ha sobre 24-123 + 57,545 ha sobre 24-43. La metadata declara que esta capa cierra la hipótesis anterior para el cruce del corredor. Eslabón sin auditar: fidelidad de la vectorización (sin RMSE declarado).

**¿Diferencia entre H2 canon, perímetro RTK y matriz AI envoltorio?** Tres objetos distintos que comparten zona: **H2 canon** = identidad catastral-registral del activo (qué roles, qué inscripciones, geometría SII, 2.601 ha); **RTK** = geometría física medida del mismo activo (mejor precisión disponible, 10 m, 2.165 ha, base de valorización); **matriz envoltorio** = contexto histórico del predio madre de AI que rodea a H2 (dato registral HECHO + geometría placeholder sin valor). H2 canon y RTK son dos autoridades sobre EL MISMO objeto (con brecha que es parte del caso); la matriz es OTRO objeto (el envolvente), hoy mal representado geométricamente.

**¿Qué está confirmado documentalmente y qué es inferido?** Ver §4. En corto: identidad/roles/CBR de H2, RTK, plano AI Dic-2025, InterChile 2014, expropiaciones Ruta 5 y compra matriz 2021 = documental (declarado con fuente). Titularidad H1 = inferencia SII/HousePricing. Trazado 26 km = hipótesis. Vectorizaciones = nuestras, sin auditoría declarada.

**¿Qué capas sirven para negociar con Andes Iron?** Núcleo: **Sector Lineal AI Dic-2025** (la pretensión de la contraparte, su propio plano), **H2 canon** (identidad y títulos), **RTK** (superficie defendible), **InterChile 2014 + torres** (precedente de servidumbre remunerada en el mismo predio — comparable de naturaleza voluntaria, citable sin promediarlo), **matriz (solo el dato registral 2021)** como ancla de cadena/contexto de capacidad. H1 contextual encuadra el corredor sin activar la cláusula 5ª.

**¿Qué capas sirven para explicar el caso a la Municipalidad?** H2 canon + RTK (qué es el predio y cuánto mide), ortofoto (estado físico/ocupaciones del sector oriental), torres InterChile (infraestructura existente), faja Ruta 5/expropiaciones (historia de afectaciones públicas). El detalle fino de la servidumbre AI y cualquier lectura económica: no es conversación municipal.

**¿Qué capas NO deberían mostrarse a terceros?** (i) Capa 5 f0 — línea 26 km con choke point regulatorio: revela lectura estratégica propia del EIA; (ii) matriz envoltorio como geometría; (iii) fuera de este foco pero en el visor general: conflictos, titularidad interna 8 sub-lotes, ocupaciones, ofertas/CBR (ya gateadas en meeting). Menores: nombre del operador RTK en el título de la feature; nombre de la ejecutora del plano AI en props.

**¿Qué falta para que el corredor sea una ficha territorial defendible?** Ordenado por peso probatorio:
1. **Reconciliación de superficies SII −436 ha→ RTK/CBR** con desglose documental (expropiaciones MOP lote a lote vs brecha 503 ha declarada) — hoy es la inconsistencia más visible ante un tercero técnico.
2. **Auditoría de georreferenciación del Sector Lineal AI** (RMSE plano AIPD-01 → GeoJSON; misma exigencia del andamiaje P1 del plano histórico) + obtener el plano físico al data room si no está.
3. **Servidumbre 924-644**: cruce CBR para titular dominante y geometría (hoy HECHO de existencia, nada más).
4. **Titularidad H1 a nivel CBR** (hoy inferencia SII) — necesaria si el corredor se presenta como continuo.
5. **Matriz**: sustituir bbox por perímetro real (georreferenciación ITS-CARTO-PLANO-0001 + exclusiones declaradas) o etiquetar la capa visiblemente como envolvente conceptual.
6. **Correspondencia sublotes A/B ↔ polígonos f1/f3** (plano histórico 863+976+300=2.139 vs SII).
7. **Verificación de torres contra ortofoto** en el tramo cubierto (barata, sube confianza de InterChile a "validada en imagen").
8. Declarar `precision_metros` y fecha/fuente en TODAS las capas (estándar del RTK como plantilla).

---

## 8. Recomendaciones de mejora (sin tocar código hoy)

1. Tratar el caveat geométrico de la matriz como deuda del DATO (agregar al GeoJSON cuando se reabra edición), no solo del visor.
2. Etiquetar en la capa 5 la f0 como SUPERADA-para-H2 (referencia cruzada a servidumbre_andes_iron) para evitar doble conteo.
3. Plantilla de metadata mínima por capa: fuente primaria, método geométrico, precisión, fecha, autoridad de superficie — el RTK ya la cumple; usarla de patrón.
4. La tabla de autoridades de superficie (§3.5) debería viajar SIEMPRE con cualquier cifra de H2 que salga del sistema.

## 9. Próximo paso ejecutable (sin código)

**Redactar la "Ficha Territorial Corredor v0"** (documento, no visor): tabla de autoridades de superficie + inventario de gravámenes con naturaleza jurídica separada + las 3 brechas declaradas (SII↔RTK/CBR, 924-644, vectorización AI sin RMSE) + anexo de fuentes citadas. Insumo directo: este informe. Es el entregable que convierte el corredor en objeto defendible ante AI, municipio o un tercero técnico, y define el backlog de reconciliación documental con dueño y acción por brecha.

---

## ADDENDUM — Instrucción consolidada ejecutada (2026-06-10, v1.2-foco.3)

Posterior a este informe, Max emitió la instrucción consolidada "Corredor AI + Estructura Operacional H2". Cambios aplicados (geometrías invariantes, hashes verificados):

1. **§2.1/§3 actualizados en los datos**: la capa H2 canon ahora se etiqueta `Lote C` / `Resto A+B · cuerpo catastral mayor/menor/astilla`, con labels de mapa, `estructura_operacional`, `superficie_por_autoridad` y "Partición A/B pendiente de reconciliación documental" visible en ficha. Roles SII = atributo secundario de trazabilidad. **Hallazgo que cierra la aritmética jurídica:** adjudicaciones feb-2017 "Resto Hijuela 2 (Resto a+b)" 1.839,35 ha + Lote C 300 ha = 2.139,35 ha ≈ CBR 2.139 ✓ ≈ 863+976+300 (plano histórico) ✓. La capa `titularidad_2023` usa geometría placeholder única (8 cuotas, mismo hash) → confirmado que NO existe fuente geométrica para partir A/B.
2. **§2.5/§2.6**: la línea esquemática 26 km quedó marcada en el dato como `NO_BASE_DE_NEGOCIACION` (superada por AIPD-01 para el cruce H2/H1) y su capa salió del set default del modo reunión. `servidumbre_andes_iron.geojson` lleva ahora bloque `auditoria_geometrica: NO_AUDITADA` con los 5 NO-VERIFICADOS y los entregables del P1.
3. **Backlog formalizado** en `BACKLOG_CORREDOR_P1_P2_2026-06-10.md`: P1 auditoría geométrica AI · P2 reconciliación A/B · P3 brecha SII↔CBR/RTK (la reconciliación que un tercero técnico cuestionará primero, ≈436–462 ha, candidato documental: expropiaciones Ruta 5).

*Generado 2026-06-10 · fuentes: 8 GeoJSON + meta ortofoto + H2_LAYERS (inspección directa) · recálculos geométricos propios · memoria operacional citada como tal · sin fuentes inventadas.*
