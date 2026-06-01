# ITS-CARTO-PLANO-0001 · PLANO_HIJUELAS_LA_HIGUERA_INTERVENIDO_PRE_DIGITAL_v1

**Fecha ingesta:** 2026-05-31
**Disparador:** entrega Max · plano histórico-cartográfico con anotaciones manuscritas posteriores
**Tipo de artefacto:** fuente estructural de reconstrucción histórica · NO solo imagen de respaldo
**Estado epistemológico:** `FUENTE_PRIMARIA_ESCANEADA`
**Confianza geométrica:** `NO_GEORREFERENCIADO`

---

## 0. Metadatos canónicos ITS

```yaml
asset_id: ITS-CARTO-PLANO-0001
title: PLANO_HIJUELAS_LA_HIGUERA_INTERVENIDO_PRE_DIGITAL_v1
source_type: scanned_map
epistemic_status: primary_source
geometry_status: not_georeferenced
contains_annotations: true
contains_manual_boundaries: true
requires_georeferencing: true

resolucion_imagen:
  original: 2600 × 1950 px
  displayed: 2000 × 1500 px
  factor_escala: 1.30 (multiplicar coordenadas display por 1.30 para mapear a original)

autoria_plano_base: desconocida (pendiente · presumiblemente IV-1-1777-S.R. derivado)
fecha_documento_original: desconocida (pendiente)
fecha_anotaciones_manuscritas: posterior al plano original · fecha no determinada
fechas_visibles_en_anotaciones: 2014-01-23 · 2015-01-23 · 2016-01-23 · 2017-01-23

territory:
  - La Higuera
  - Hijuela 1
  - Hijuela 2
  - Hijuela 3
  - Estancia Maray
  - Estancia Yerbas Buenas (mencionada SO)
  - Cordón del Barco
  - Quebrada Honda

entities_extraidas:
  - 1a · 1b (Hijuela 1)
  - 2a · 2b (Hijuela 2)
  - 3a · 3b (Hijuela 3)
  - C (Lote C de Hijuela 2)

open_questions:
  - Correspondencia exacta con plano IV-1-1777-S.R.
  - Correspondencia con rol 24-123 (catastro SII actual H2 Resto A+B)
  - Correspondencia con rol 24-160 (catastro SII actual H2 Lote C)
  - Correspondencia con perímetro RTK Daniel mayo 2026
  - Datación de las anotaciones manuscritas (¿pre o post estudio títulos canon?)
  - Autoría de las delimitaciones coloreadas
```

---

## 1. HECHOS_OBSERVADOS · directo de la imagen

### 1.1 · Unidades territoriales delimitadas

```yaml
unidades_visibles:
  1a: ubicada en sector NO superior del plano · texto pequeño "①ⓐ"
  1b: ubicada en sector NE central · texto "①ⓑ"
  2a: ubicada en sector W central · polígono rojo · contiene texto "2a" + anotación "863 Has"
  2b: ubicada en sector central E · polígono rojo · contiene texto "2b" + anotación "976 Has"
  C : ubicada en sector NW · polígono celeste/azul · contiene texto "C" + anotación "300 Has"
  3a: ubicada en sector SO · texto "③ⓐ"
  3b: ubicada en sector S central · texto "③ⓑ"
  2a_segunda_marca_roja: anotación "Z" + "863 Has" en zona 2a
  2b_segunda_marca: anotación "ZB" + "976 Has" en zona 2b
```

### 1.2 · Superficies manuscritas

```yaml
superficies_anotadas_visibles:
  "2A 863 Has" (rojo · encabezado superior centro)
  "ZB 976 Has" (naranja · encabezado superior derecho)
  "C 300 Has" (verde claro · encabezado superior derecho)
  
  bloque_suma_pie_pagina:
    "Lote 2a = 863 has" (rojo)
    "Lote 2b = 976 has" (rojo)
    "Lote C = 300 has" (rojo)
    suma_implícita: 1839 has + 300 has = 2139 has (consistente con canon Cominetti H2)
  
  otras_anotaciones_marginales:
    "1000.00" (probable cota o longitud · debajo de la zona 2a)
    "UF 28.700" (esquina inferior derecha)
    "(500.000)" (al lado de UF 28.700)
    "5.000 0/" (esquina inferior derecha · puede ser referencia escala)
    "1839 Has" (pie de página · suma 863 + 976)
    "300 has" (pie de página · Lote C)
    "Loty Lote C 300 has" (pie de página redundante)
```

### 1.3 · Topónimos visibles

```yaml
toponimia_observada:
  zonas_principales:
    - "Pueblo de La Higuera" (centro · próximo a ②ⓑ)
    - "Estancia Maray" (NE marginal · al lado de Cordón del Barco)
    - "Estancia Yerbas Buenas" (esquina SO inferior)
    - "Cordón del Barco" (margen E · línea de elevaciones)
    - "Cordón del Tofo / del Si..." (margen NO superior)
    - "Comunidad Quebrada Honda" (zona S marginal entre 3b)
    - "Agrícola..." (parcialmente legible · borde S)
    - "Portezuelo" (esquina inferior izquierda · sector 21-22)
  
  hidrografia_y_quebradas:
    - "Quebrada Honda" (zona S marginal)
    - "Quebrada Aires" (lectura tentativa · puede ser "Buenos Aires")
    - "Agua Escondida" (zona NE)
    - "Quebrada Las Pediltas" (SO)
    - "Quebrada La Mañaca" (E)
    - "Quebrada Cimarrones" (S)
  
  cerros_y_referencias:
    - "Cerro El Romero · 1421" (NE)
    - "Cerro del Romero · 1367" (NE)
    - "Cerro El Carbón · 1470" (E)
    - "Cerro La Cimarrona · 1453" (S)
    - "Cerro San Juan · 1520" (S)
    - "Cerro Tilgo · 1172" (SO)
    - "Cerro La Rinconada · 1448" (E)
  
  predios_excluidos_o_vecinos:
    - "Jaime Ugarte Lee" + "Julio Brito Rifeo" (centro-W, debajo del Lote C) ← El Molle exclusión L
```

### 1.4 · Infraestructura visible

```yaml
infraestructura_lineal:
  - "Línea Proyectada" (anotación verde superior derecha · línea trazada hacia E)
  - "Camino acceso Norte" (línea diagonal del NE hacia centro)
  - "Camino antiguo Totoralillo" (diagonal NO hacia centro · sector 2a)
  - "Camino acceso..." (otros caminos parciales)
  - Curvas de nivel topográficas (toda la imagen · base IGM 1:50.000)

vertices_HR (Hitos Referenciales · concuerdan con plano IV-1-1777-S.R.):
  - HR.1 · HR.2 · HR.3 · HR.5 · HR.6 · HR.121 · HR.125 · HR.171 · HR.172 · HR.231
  - referencias geodésicas usadas en el saneamiento Jarpa 1990
```

### 1.5 · Polígonos coloreados (capas temporales)

```yaml
poligono_rojo_oscuro:
  encierra: zonas 2a + 2b (Hijuela 2 completa)
  superficie_anotada: 863 + 976 = 1839 ha
  identificacion: Cominetti H2 Resto Lotes A+B (rol 24-123 actual)
  
poligono_azul_celeste:
  encierra: zona C (con vertices etiquetados H, F, G, B)
  superficie_anotada: 300 ha
  identificacion: Lote C Hijuela 2 (rol 24-160 actual)
  ubicacion_relativa: al N del Lote 2a · separación con caminos antiguos
  
poligono_naranja:
  encierra: zona 2b reforzada
  identificacion: probable reposición o validación posterior del Lote 2b

poligono_rosa_NO_superior:
  encierra: zona externa al 1a · borde NO
  identificacion: BLOQUEADO

linea_naranja_punteada:
  trayectoria: bordeando 2b por el E hasta zona Estancia Maray
  identificacion: HIPÓTESIS · servidumbre o trazado proyectado
```

### 1.6 · Fechas y anotaciones cronológicas

```yaml
fechas_visibles_en_secuencia:
  "23/01/2014" (zona E central · sobre el polígono 2b)
  "23/01/2015"
  "23/01/2016"
  "23/01/2017"
  
hipotesis_de_significado (NO canonizar):
  H_FECHA_1: fechas de inscripciones consecutivas de expropiaciones MOP Ruta 5 (2013-2017 son canon)
  H_FECHA_2: aniversarios o ciclos anuales de notarización
  H_FECHA_3: marcas temporales del trabajo de reconstrucción posterior al saneamiento
  
valor_economico_anotado:
  "UF 28.700" (probable valoración del paño)
  "(500.000)" (probable referencia en UF al Lote C o valor unitario)
```

---

## 2. HIPÓTESIS abiertas (NO canonizar)

```yaml
H1_artefacto:
  enunciado: "El polígono azul podría corresponder a una interpretación posterior del Lote A"
  estado: NO_VALIDADA · pero observación visual sugiere que es Lote C, no Lote A
  contraste_canon: el Lote C tiene 300 ha + es separable (rol 24-160) · coincide visualmente
  acción_validación: cruce con escritura constitución Lote C + RTK Daniel

H2_artefacto:
  enunciado: "Las superficies manuscritas podrían ser antecedentes usados en la reconstrucción de Hijuela 2"
  estado: NO_VALIDADA · pero suma 863 + 976 + 300 = 2.139 ha coincide al gramo con canon Cominetti H2
  consecuencia_si_se_valida: 
    el plano es la FUENTE_BASE del canon Cominetti 2.139 ha
    las superficies manuscritas son anteriores al estudio títulos formal
  acción_validación: datación de la tinta + comparación con cartulinas del saneamiento DL 2.695

H3_artefacto:
  enunciado: "Las delimitaciones rojas podrían haber sido utilizadas para negociaciones posteriores (InterChile, Andes Iron, Magnus o estudios de títulos)"
  estado: NO_VALIDADA
  pista: la línea proyectada visible podría corresponder a la futura LT InterChile 2014 (PES_020 + PES_021)
  acción_validación: superposición con KMZ InterChile + KMZ Andes Iron

H4_artefacto:
  enunciado: "Este plano podría ser una versión de trabajo utilizada para reconstruir la división histórica Jarpa"
  estado: NO_VALIDADA
  pista: los vértices HR concuerdan con el plano IV-1-1777-S.R. (geodésicos del saneamiento 1990)
  acción_validación: cruce vértice por vértice con plano IV-1-1777-S.R.
```

---

## 3. ENTIDADES extraídas (catálogo ITS preliminar)

```yaml
toponimia_normalizable:
  pueblos: [La Higuera]
  estancias: [Maray, Yerbas Buenas]
  comunidades_indigenas: [Quebrada Honda]
  cordones: [Cordón del Barco, Cordón del Tofo/Sí...]
  cerros: [El Romero 1421, El Romero 1367, El Carbón 1470, La Cimarrona 1453, San Juan 1520, Tilgo 1172, La Rinconada 1448]
  quebradas: [Honda, Aires/Buenos Aires, Las Pediltas, La Mañaca, Cimarrones, Agua Escondida]
  predios_excluidos: [Jaime Ugarte Lee + Julio Brito Rifeo (El Molle)]
  
unidades_territoriales:
  hijuelas: [1a, 1b, 2a, 2b, 3a, 3b]
  lotes_separados: [C (300 ha · azul/celeste)]
  
superficies_documentadas:
  Lote_2a: 863 ha
  Lote_2b: 976 ha
  Lote_C: 300 ha
  Suma_canon: 2.139 ha (consistente con HIJUELA_2 vigente)

infraestructura_dibujada:
  caminos: [acceso Norte, antiguo Totoralillo]
  linea_proyectada: [trazada al E]
  vertices_HR: [HR.1, HR.2, HR.3, HR.5, HR.6, HR.121, HR.125, HR.171, HR.172, HR.231]

valoraciones_anotadas:
  UF_28.700
  500.000_(probable_UF_o_CLP_miles)
```

---

## 4. ACCIONES de validación

### 4.1 · Prioridad P1 · Georreferenciar

```yaml
puntos_de_control_propuestos:
  1. Pueblo de La Higuera (centro plano · zona ②ⓑ)
     coords_KMZ_06: UTM ~286500, 6733500
  2. Quebrada Honda (zona S marginal)
     coords_KMZ_06: UTM ~286000-287000, 6730000-6731000
  3. Portezuelo (esquina inferior izquierda)
     coords_KMZ_06: UTM ~285500, 6729000
  4. Estancia Maray (margen E)
     coords_KMZ_06: UTM ~289000+, 6734000+
  5. Vértices HR (al menos HR.1, HR.121 · vértices del IV-1-1777-S.R.)
     coords_PSAD56_FICHA_documento:
       HR.1: E 287.008,86 / N 6.735.557,19
       HR.121: E 287.111,42 / N 6.733.304,63

método:
  herramienta: QGIS Georreferenciador
  CRS_destino: EPSG:32719 (UTM 19S WGS84)
  transformación: polinomial 2do orden mínimo
  
output:
  plano_georeferenciado.tif (GeoTIFF)
  matriz_transformación.csv
  reporte_residuales_RMS
```

### 4.2 · Prioridad P2 · Vectorizar polígonos coloreados

```yaml
vectorización_propuesta:
  poligono_rojo: 
    nombre: "P_ROJO_HIJUELA_2_AB"
    superficie_anotada_ha: 1839
    hipótesis_identidad: Resto Lotes A+B Cominetti H2 (rol 24-123)
    
  poligono_azul_celeste:
    nombre: "P_AZUL_LOTE_C"
    superficie_anotada_ha: 300
    hipótesis_identidad: Lote C Cominetti H2 (rol 24-160)
    
  poligono_naranja:
    nombre: "P_NARANJA_2B_REFUERZO"
    superficie_anotada_ha: ~976
    hipótesis_identidad: validación visual posterior del Lote 2b
    
  línea_proyectada:
    nombre: "L_LINEA_PROYECTADA"
    hipótesis_identidad: LT InterChile o futuro Sector Lineal Andes Iron

salida: 
  capa_GeoJSON_por_polígono
  capa_LineString_línea_proyectada
  almacén: magnus-radar/docs/ingesta_plano_intervenido/vectorizado/
```

### 4.3 · Prioridad P3 · Datación de anotaciones

```yaml
preguntas_a_resolver:
  ¿la_anotación_863+976+300_es_anterior_o_posterior_al_estudio_títulos_canonizado?
  ¿las_fechas_2014_2015_2016_2017_corresponden_a_la_serie_expropiaciones_MOP?
  ¿el_UF_28.700_corresponde_a_qué_operación?
  
método_de_datación:
  análisis_visual_de_tintas (rojo · azul · naranja · negro)
  comparación_con_documentación_canonizada
  consulta_con_Max_o_propietario_sobre_origen_del_plano

implicación_canónica:
  si_anotaciones_son_PRE_estudio_títulos:
    el plano es la FUENTE BASE de las superficies 863 + 976 + 300
    canon Cominetti tiene anclaje gráfico verificable
  
  si_anotaciones_son_POST_estudio_títulos:
    el plano es un derivado del canon
    valor como ilustración de reconstrucción · no como fuente
```

---

## 5.0 · Tabla de correspondencia graduada (ajuste canónico Max 2026-05-31)

```yaml
correspondencia_canonica:
  
  geometrica_en_el_plano (CONFIRMADA):
    2a → 863 ha: anotación manuscrita visible · polígono rojo identificable
    2b → 976 ha: anotación manuscrita visible · polígono rojo identificable
    C  → 300 ha: anotación manuscrita visible · polígono azul/celeste identificable
    suma 2a + 2b = 1.839 ha: aritméticamente correcta
    suma 2a + 2b + C = 2.139 ha: aritméticamente correcta
  
  identificacion_con_estructura_juridica_actual (MUY CONSISTENTE pero NO demostrada):
    2a + 2b → Resto A + Resto B Cominetti: MUY CONSISTENTE con escritura Cofanti 2017 (Resto a 863 ha + Resto b 976.35 ha)
    C → Rol 24-160: MUY CONSISTENTE con Lote C 300 ha mandato Rep 24.327
    suma 2.139 ha ↔ superficie operativa Cominetti: MUY CONSISTENTE con canon vigente
  
  salto_pendiente_de_demostracion:
    "quien hizo las anotaciones usaba la misma ontología jurídica actualmente vigente"
    estado: PENDIENTE_DE_GEORREFERENCIACION
    razon: hasta no demostrar que los polígonos del plano coinciden geométricamente con los polígonos catastrales SII actuales (24-123 + 24-160), la identificación es inferencia fuerte pero no hecho

regla_canonica_para_ITS:
  No promover a HECHO la identificación "2a+2b+C = estructura jurídica Cominetti vigente"
  Promover a HECHO solo las correspondencias geométricas y aritméticas DENTRO del plano
  La transición de "plano" a "ontología jurídica actual" requiere P1 + cruce CBR + RTK Daniel
```

---

## 5. HALLAZGO CRÍTICO · el plano es la lógica 1a/1b/2a/2b/3a/3b operativa

```yaml
hallazgo:
  el plano usa exactamente la nomenclatura que aparece en:
    - CADENA_REGISTRAL_HIJUELA_2 (canon)
    - EXCLUSIVA_HIJUELA1_GARCIA_HUIDOBRO (borrador no firmado)
    - escrituras Cofanti 16.pdf
    - mandato Cominetti firmado
  
  correspondencia_propuesta:
    1a = Hijuela 1 Lote A (Pablo Jarpa · 620 ha plano MBN) → García Huidobro
    1b = Hijuela 1 Lote B (1.519 ha plano MBN) → García Huidobro
    2a = Hijuela 2 Lote A (1.163 ha plano MBN · 863 ha residual post-expropiaciones) → Cominetti
    2b = Hijuela 2 Lote B (1.479 ha plano MBN · 976 ha residual) → Cominetti
    3a = Hijuela 3 Lote A (910 ha plano MBN) → Patricio Jarpa origen → fragmentado
    3b = Hijuela 3 Lote B (1.227 ha plano MBN) → Patricio Jarpa origen → fragmentado
    C  = Lote C (300 ha · unidad dominical separada) → Cominetti rol 24-160

implicancia_para_ITS:
  el plano es FUENTE ESTRUCTURAL de reconstrucción histórica
  NO es solo "imagen de respaldo"
  ordena la cosmología territorial del corredor Estancia La Higuera
  
implicancia_para_Magnus:
  si_se_georreferencia + se_vectoriza:
    se obtiene el ÚNICO mapa que muestra simultáneamente:
      - matriz Estancia La Higuera 1988
      - 3 hijuelas con sus 6 sub-lotes
      - El Molle como deslinde
      - Cordón del Barco (deslinde E)
      - Quebrada Honda (comunidad indígena vecina S)
      - Línea Proyectada (posible LT InterChile o Sector Lineal)
  
  valor_estratégico:
    insumo para mesa Andes Iron (visualizar quién es quién en el corredor)
    insumo para coalición H1+H2 (mostrar a García Huidobro su predio en contexto)
    insumo para presentación Magnus a inversionistas (storytelling territorial)
```

---

## 6. Estado del registro ITS

```yaml
asset_creado: SI
asset_id: ITS-CARTO-PLANO-0001
estado: registrado · NO canonizado
canon_promovible_desde_este_plano: NINGUNO sin georreferenciación P1 + vectorización P2

próximos_pasos_ranked:
  1. preguntar a Max: ¿origen del plano? ¿fecha aproximada de las anotaciones? ¿quién las hizo?
  2. P1 georeferenciar (1-2 hrs QGIS)
  3. P2 vectorizar 3 polígonos (1 hr)
  4. cruzar contra plano IV-1-1777-S.R. + KMZ-06 SII + RTK Daniel
  5. promover a canon visual de HISTORIA_ESTANCIA_HIJUELAS_LA_HIGUERA_v1
```

---

## 7. Disciplina HECHO / HIPÓTESIS / BLOQUEADO

```yaml
HECHOS_OBSERVADOS_directos_imagen:
  1. Plano usa nomenclatura 1a/1b/2a/2b/3a/3b/C
  2. Anotaciones manuscritas: 863 + 976 + 300 = 2.139 ha
  3. Polígonos coloreados: rojo (2a+2b) · azul (C) · naranja (2b refuerzo)
  4. Vértices HR coinciden con plano IV-1-1777-S.R.
  5. Topónimos: Pueblo La Higuera + Estancia Maray + Quebrada Honda + Cordón del Barco
  6. Predios excluidos: Jaime Ugarte Lee + Julio Brito Rifeo (El Molle)
  7. Fechas en secuencia: 23/01/2014, 2015, 2016, 2017
  8. Valor anotado: UF 28.700 + (500.000)

HIPÓTESIS_no_canonizables_hoy:
  H1: polígono azul = Lote C (no Lote A)
  H2: anotaciones manuscritas = fuente del canon Cominetti
  H3: línea proyectada = LT InterChile o Sector Lineal Andes Iron
  H4: el plano es versión de trabajo del IV-1-1777-S.R. anotada posteriormente

BLOQUEADOS:
  autoría del plano base
  fecha exacta del plano original
  fecha de cada capa de anotaciones
  significado de UF 28.700 y (500.000)
  significado de fechas 2014-2017
  georreferenciación geométrica
```

---

**Linkado:**
- [[HISTORIA_ESTANCIA_HIJUELAS_LA_HIGUERA_v1]]
- [[CANON_HIJUELA2_v2]]
- [[CADENA_REGISTRAL_HIJUELA_2]]
- [[Plano_MBN_IV-1-1777-SR_FICHA_DOCUMENTO]] (plano base candidato)
- [[doctrina-unidad-territorial-estratificada]]
- [[correccion-doctrinal-unidad-territorial-historica]]
- [[doctrina-homonimia-territorial]]
- mandato Cominetti firmado (Rep 24.327)
- borrador H1 García Huidobro (no firmado)
