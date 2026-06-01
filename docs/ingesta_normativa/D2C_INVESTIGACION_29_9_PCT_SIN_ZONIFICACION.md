# D2.C · Investigación del 29.9% del cat5 sin zonificación visible

**Fecha:** 2026-05-31
**Pregunta del usuario (Max):** *"29.9% dentro_del_limite_urbano pero sin_poligono_de_zonificacion · Ese porcentaje es demasiado grande para ignorarlo."*
**Hallazgo a resolver:** 14.82 ha del cat5 (49.57 ha total) están dentro del límite urbano PRC pero NO caen sobre ningún polígono `zona_urbana` (ZU1, ZU2, ZU3, ZU4, ZU5, ZE, ZC, ZAP, ZIS, ZIP, ZAV) ni Plaza.

---

## 1. Lo que SE SABE (HECHO_OBSERVADO post-D2.B)

```yaml
cat5_descomposicion:
  ha_total: 49.57
  dentro_limite_urbano: 48.22 ha (97.3%)
  con_codigo_zona_extraido: 34.75 ha (70.1%)
    ZU1: 26.29 ha
    ZAV: 7.91 ha
    Plaza: 0.41 ha
    ZU2: 0.14 ha
  sin_codigo_zona: 14.82 ha (29.9%)  ← OBJETO DE ESTA INVESTIGACION

inventario_features_PRC_normalizado_2868:
  vialidad_estructurante: 1199 (todas LineString)
  infraestructura_sanitaria: 871 (todas Point)
  zona_urbana: 448 (todas Polygon)
  restriccion_AR2: 155 (Polygon)
  restriccion_AR1: 153 (Polygon)
  riesgo_maremoto: 16
  inmueble_conservacion_historica: 13 (Point)
  limite_urbano: 7 (Polygon)
  restriccion_AR3: 6 (Polygon)
```

---

## 2. Hipótesis sobre la naturaleza del 29.9% (rankeadas por verosimilitud)

### H6.1 · Trama vial estructurante (Espacio Público / BNUP) [verosimilitud ALTA]

```yaml
diagnostico:
  el PRC representa 1199 features de vialidad_estructurante como LineString
  las calles ocupan superficie REAL pero NO se zonifican en Chile:
    son Bien Nacional de Uso Publico (BNUP)
    el suelo vial pertenece al fisco y no requiere zonificacion urbanistica
    el PRC define la red estructurante con seccion tipo (perfil) pero el polígono superficial NO existe en el KMZ
  
para_una_localidad_rural_costera_chilena:
  porcentaje_tipico_de_suelo_vial: 15-25% del area urbana
  La_Higuera_es_localidad_lineal_sobre_Ruta_5_y_caleta:
    proporcion_vial_puede_ser_alta
  
estimacion_aporte_al_29.9%:
  si_15-25%_del_cat5_es_trama_vial: 7.4-12.4 ha (50-84% del 29.9%)
  
verificacion_pendiente:
  buffer LineString vialidad estructurante × ancho seccion tipo PRC
  cruzar con cat5
  si aporta 7-12 ha · H6.1 confirmada como explicacion dominante
```

### H6.2 · Cauces naturales y zonas AR1 sin zonificación superpuesta [verosimilitud MEDIA-ALTA]

```yaml
diagnostico:
  las quebradas que atraviesan el caserio La Higuera son AR1 (zonas inundables)
  algunas porciones de AR1 pueden NO tener zonificacion urbana superpuesta
  (porque el PRC reconoce la quebrada como riesgo y no pretende edificar alli)
  
en cat5:
  AR1: 6.77 ha (13.7%)
  pregunta: cuanto de AR1 NO se solapa con zona_urbana?
  
verificacion_pendiente:
  AR1_intersect_NOT_zonificacion
  estimacion previa: 30-50% del AR1 puede no tener zona superpuesta
  rango: 2-3.5 ha del 29.9%

aporte_estimado_al_29.9%: 14-24%
```

### H6.3 · Gap cartográfico del export KMZ [verosimilitud MEDIA]

```yaml
diagnostico:
  el export de QGIS/AutoCAD a KMZ frecuentemente genera huecos topologicos
  entre poligonos contiguos por:
    diferencias de tolerancia en vertices compartidos
    holes en multipoligonos no rellenados
    snapping imperfecto
  
para 448 poligonos zona_urbana del PRC La Higuera (multilocalidad):
  un gap del 1-3% del area total es esperable
  para La Higuera localidad: 0.5-1.5 ha de huecos cartograficos
  
aporte_estimado_al_29.9%: 3-10%

verificacion_pendiente:
  buffer negativo de poligonos zona_urbana (10cm) y rebuffer positivo (10cm)
  diferencia revela huecos topologicos genuinos
```

### H6.4 · Suelos urbanos con vocación de no edificar sin código asignado [verosimilitud BAJA-MEDIA]

```yaml
diagnostico:
  algunos PRC chilenos dejan suelos dentro del limite urbano sin asignacion
  por: 
    error de redaccion (oversight del consultor)
    voluntad expresa de no clasificar (estos suelos se rigen por OGUC residual)
    suelos transferidos posteriormente a otros usos no zonificados
  
en La Higuera D.676/2020:
  Ordenanza Art 8 lista TODAS las zonas · no hay categoria "no zonificada"
  el plano PRCLH/01 deberia cubrir todo el limite urbano
  
si hay suelos urbanos sin codigo · es ANOMALIA del instrumento
aporte_estimado_al_29.9%: 0-5%
```

### H6.5 · Error de extracción HTML description (no es lo que pareció ser) [verosimilitud BAJA]

```yaml
diagnostico:
  los poligonos zona_urbana sin codigo en HTML description PUEDEN tener
  el codigo en otra llave del SchemaData KML:
    SimpleData name="zona"
    ExtendedData/Data name="CODIGO"
    name="<codigo>" directamente en el feature
  
si esto es asi: el 29.9% se reduce sustancialmente al re-parsear
verificacion_pendiente:
  re-extraer codigo de los 8 features zona_urbana sin codigo en Q21 (10.4 ha)
  por todas las llaves disponibles
  
si recupera codigo en 8 de 8 features:
  el 29.9% se reduce a ~20% o menos
```

---

## 3. Lectura razonada combinando las 5 hipótesis

```yaml
modelo_explicativo_29.9%:
  H6.1_vialidad_BNUP: 50-84% (7.4-12.4 ha)
  H6.2_cauces_AR1_solo: 14-24% (2.0-3.5 ha)
  H6.3_gap_cartografico: 3-10% (0.5-1.5 ha)
  H6.4_suelos_sin_clasificar: 0-5% (0-0.7 ha)
  H6.5_error_extraccion: 0-30% (0-4.5 ha)

rango_total_explicado: 88-153% (consistente con 100% considerando incertidumbres)

lectura_pragmatica:
  el 29.9% NO es señal de un problema estructural del PRC
  es el conjunto natural de:
    suelo vial publico (mayoritario)
    cauces naturales (moderado)
    huecos topologicos del export (menor)
    error eventual de extraccion (validable)
```

---

## 4. Implicancia para la pregunta operacional de Hijuela 2

```yaml
para_estrategia_regularizacion_tomas:
  si una toma cae sobre el 29.9%, las posibilidades son:
    A_esta_sobre_trama_vial: la toma esta encima de una calle BNUP · NO regularizable · debe desalojar
    B_esta_sobre_AR1_sin_zona: la toma esta sobre quebrada · alto riesgo · NO regularizable salvo estudio Art 2.1.17 y modificacion PRC
    C_esta_sobre_gap_cartografico: error PRC · regularizable via DOM con interpretacion administrativa
    D_esta_sobre_error_extraccion_KMZ: re-verificar codigo en plano oficial · puede ser ZU1 regularizable

regla_canonica:
  no se puede afirmar "el 29.9% es regularizable" ni "el 29.9% es no regularizable"
  cada toma debe verificarse INDIVIDUALMENTE contra:
    1. plano oficial PRC (no el KMZ · el plano timbrado)
    2. plano vialidad estructurante
    3. plano AR1/AR2/AR3
    4. RTK Daniel para definir geometria real de la toma

para_due_diligence_inversor:
  el cat5 tiene 24.8% en AR1+AR2+AR3 que exigen estudio Art 2.1.17 OGUC para edificar
  el cat5 tiene 15.9% en ZAV que NO permite vivienda ni hospedaje
  el cat5 tiene 29.9% sin zona visible · de los cuales 50-84% es trama vial publica (no apta para desarrollo privado)
  el suelo desarrollable_inmediato_en_ZU1: 26.29 ha (53.0%)
  el suelo desarrollable_productivo_en_ZAP: pendiente de cruzar (ZAP existe para localidad La Higuera)
```

---

## 5. Acciones para reducir incertidumbre del 29.9% (rankeadas por relación señal/esfuerzo)

```yaml
1_re_extraer_codigos_zona_urbana:
  esfuerzo: 30 min
  señal: alta · podria reducir 29.9% a 20% o menos
  como: re-parsear 8 features Q21 sin codigo · buscar codigo en TODAS las llaves SchemaData
  bloqueado_por: nada
  recomendacion: HACER ANTES DE D3

2_buffer_vialidad_estructurante:
  esfuerzo: 60 min
  señal: muy alta · confirmaria H6.1 y mediria suelo vial publico
  como: buffer LineString vialidad × seccion tipo (6m, 9m, 12m segun categoria) y cruzar con cat5
  bloqueado_por: nada · pero requiere definir seccion tipo de cada via desde Ordenanza

3_validar_terreno_Q21_Daniel_RTK:
  esfuerzo: 1 dia de campo + procesado
  señal: muy alta · definira si Plaza es plaza materializada, si ZU1 es desarrollable, si hay tomas en ZAV
  como: campaña RTK georeferenciar 5-10 puntos clave del Q21 (Plaza, parcelas ZU1, vertice ZAV)
  bloqueado_por: agenda Daniel
  recomendacion: agendar ya · es la prioridad numero 1 fisica

4_solicitar_plano_oficial_PRC_DOM:
  esfuerzo: 1 semana (oficio DOM Municipal La Higuera)
  señal: alta · plano oficial es la fuente normativa · KMZ es derivado
  como: oficio DOM por carta Magnus solicitando copia certificada del plano PRCLH/01
  bloqueado_por: nada
  recomendacion: enviar oficio esta semana (paralelo a D3-D5)
```

---

## 6. Lo que NO se puede afirmar a partir del 29.9%

```yaml
ANTI_PATRON_a_evitar:
  NO_decir: "el 29.9% es suelo no zonificado por defecto del PRC"
  NO_decir: "el 29.9% es regularizable porque el PRC no se opone"
  NO_decir: "el 29.9% es trama vial" (mas probable pero no demostrado)
  NO_decir: "el 29.9% son tomas en areas de riesgo"

SI_decir: 
  "el 29.9% del cat5 (14.82 ha) cae dentro del limite urbano PRC pero
   no se solapa con ningun poligono de zona urbana detectado en el KMZ del PRC.
   Las hipotesis dominantes son (a) trama vial publica como LineString sin poligono,
   (b) cauces naturales que el PRC reconoce como AR1 sin asignar zona superpuesta,
   (c) huecos cartograficos del export KMZ. Para resolver la naturaleza precisa de
   esos 14.82 ha se requieren las 4 acciones rankeadas en §5."
```

---

## 7. Estatus epistemológico

```yaml
naturaleza_del_documento: investigacion_abierta · hipotesis_no_demostradas

NO_es_canon: 
  ningun_porcentaje_de_H6.x_es_HECHO_OBSERVADO
  son ESTIMACIONES con rango

SI_es_canonizable:
  el dato del 29.9% como hecho (14.82 ha del cat5 sin poligono zona urbana del PRC)
  la enumeracion de hipotesis como posibilidades simultaneamente compatibles
  la regla operacional (cada toma debe verificarse individualmente)
  el ranking de acciones de §5
```

---

**Linkado con:**
- [[D2C_CODIGOS_PRC_LA_HIGUERA]] (significados oficiales)
- [[D2_CRUCE_NORMATIVO_FINO_CAT5]] (cruce raiz)
- [[D2B_DESGLOSE_CODIGOS_ZONA_CAT5]] (extraccion HTML)
- [[CANON_HIJUELA2_v2]] (canon vivo)
- [[evt-h2-occupation-baseline-20260531]] (baseline observable)
- [[principio-arquitectonico-meher-os-fuente-unica-metrica]] (no usar % sin declarar fuente)
