# D2.C · Significados códigos zonificación PRC La Higuera

**Fecha:** 2026-05-31
**Fuente primaria:** Ordenanza Local PRC La Higuera, Decreto 676 / marzo 2020 · Art. 8-12
**Archivo fuente:** `/03_TERRITORIAL_NORMATIVA/Plan_Regulador/PRC_ORDENANZA.pdf` (pp. 9-22)
**Método:** lectura directa Ordenanza · NO inferencia · NO hipótesis
**Objetivo:** dotar de semántica a códigos detectados en D2.B + zonas potencialmente relevantes a Hijuela 2

---

## 1. Tabla canónica · 11 zonas + 3 áreas riesgo + 2 ZNE + 2 ZCH

```yaml
ZU1:
  nombre: Zona Urbana 1
  aplica_en: [La Higuera, Caleta Los Hornos, Chungungo, El Trapiche, Los Choros, Punta de Choros, Punta Colorada]
  subdivision_minima_m2: 300
  densidad_hab_ha: 300
  ocupacion_max: 0.5
  constructibilidad: 1.0
  altura_max_m: 7.0
  antejardin_m: 3.0
  agrupamiento: [aislado, pareado, continuo]
  usos_permitidos:
    residencial: [vivienda, hospedaje, hogares_acogida]
    equipamiento: [cientifico, comercio_sin_terminales, culto, cultura, deporte, educacion, salud, seguridad, servicios, social]
    actividad_productiva: [inofensiva]
  usos_prohibidos:
    equipamiento: [esparcimiento, medialuna, autodromo, centro_rehabilitacion_conductual, cementerio, crematorio, carcel]
    actividad_productiva: [molesta, insalubre, contaminante, peligrosa, planta_revision_tecnica]
    infraestructura: [transporte, sanitaria, energetica]
  relevancia_hijuela_2: ALTA (zona dominante del area urbana La Higuera)

ZU2:
  nombre: Zona Urbana 2
  aplica_en: [La Higuera, Caleta Los Hornos, Chungungo, El Trapiche, Los Choros, Punta de Choros]
  subdivision_minima_m2: 600
  densidad_hab_ha: 70
  ocupacion_max: 0.3
  constructibilidad: 0.8
  altura_max_m: 9.0
  antejardin_m: 3.0
  agrupamiento: [aislado]  # solo aislado · sin pareado ni continuo
  usos_permitidos:
    residencial: [vivienda, hospedaje, hogares_acogida]
    equipamiento: [cientifico, comercio_sin_terminales, culto, cultura, deporte, educacion, esparcimiento_limitado, salud, seguridad, servicios, social]
    actividad_productiva: [inofensiva]
  usos_prohibidos:
    actividad_productiva: [molesta, insalubre, contaminante, peligrosa, planta_revision_tecnica]
    infraestructura: [transporte, energetica]
  relevancia_hijuela_2: MEDIA (0.3% del cat5 segun D2.B · zona periferica del asentamiento)

ZU3:
  nombre: Zona Urbana 3
  aplica_en: [Caleta Los Hornos, Punta Colorada]
  subdivision_minima_m2: 500
  densidad_hab_ha: 40
  ocupacion_max: 0.6
  constructibilidad: 1.0
  altura_max_m: 10.0
  antejardin_m: 3.0
  agrupamiento: [aislado]
  particularidad: permite_infraestructura_sanitaria_y_transporte_terrestre (con limitaciones)
  relevancia_hijuela_2: NULA (no aplica a localidad La Higuera)

ZU4:
  nombre: Zona Urbana 4
  aplica_en: [Caleta Los Hornos, Chungungo, Punta de Choros, Punta Colorada]
  subdivision_minima_m2: 1000
  densidad_hab_ha: 30
  ocupacion_max: 0.2
  constructibilidad: 0.4
  altura_max_m: 7.0
  antejardin_m: 5.0
  agrupamiento: [aislado]
  particularidad: permite_esparcimiento_y_comercio_amplio (locales, restoranes, fuentes_soda, bares, discotecas) · prohibe terminales, grandes_tiendas, estaciones_servicio
  relevancia_hijuela_2: NULA (no aplica a La Higuera)

ZU5:
  nombre: Zona Urbana 5
  aplica_en: [Los Choros, Punta Colorada]
  subdivision_minima_m2: 2500
  densidad_hab_ha: 20
  ocupacion_max: 0.4
  constructibilidad: 0.8
  altura_max_m: 10.0
  antejardin_m: 5.0
  agrupamiento: [aislado]
  relevancia_hijuela_2: NULA (no aplica a La Higuera)

ZE:
  nombre: Zona Equipamiento (NO costero como aparece en Art. 8 · titulo abreviado del articulo)
  titulo_ordenanza: Zona Equipamiento Costero
  aplica_en: [Caleta Los Hornos, Chungungo, Punta de Choros]
  subdivision_minima_m2: 300
  ocupacion_max: 0.5
  constructibilidad: 1.0
  altura_max_m: 10.0
  antejardin_m: 3.0
  agrupamiento: [aislado]
  usos_permitidos:
    residencial: [hospedaje]  # NO vivienda
    equipamiento: [cientifico, comercio_sin_terminales, culto, cultura, deporte_sin_medialuna, esparcimiento_sin_zoologico, seguridad, servicios, social]
    actividad_productiva: [inofensiva]
    infraestructura: [transporte_terrestre, recintos_maritimos_portuarios]
  usos_prohibidos:
    residencial: [vivienda, hogares_acogida]
    equipamiento: [educacion, salud]
    infraestructura: [energetica, sanitaria]
  relevancia_hijuela_2: NULA (no aplica a La Higuera)

ZC:
  nombre: Zona Cementerio
  aplica_en: [Los Choros, Punta Colorada]
  subdivision_minima_m2: 2500
  ocupacion_max: 0.2
  constructibilidad: 0.4
  altura_max_m: 7.0
  antejardin_m: 5.0
  uso_unico: equipamiento_salud_cementerio
  todo_lo_demas: prohibido
  relevancia_hijuela_2: NULA (no aplica a La Higuera)

ZAP:
  nombre: Zona Actividades Productivas
  aplica_en: [La Higuera, Chungungo, El Trapiche, Los Choros, Punta de Choros, Punta Colorada]
  subdivision_minima_m2: 1500
  altura_max_m: 7-10
  antejardin_m: 5.0
  agrupamiento: [aislado · sin adosamiento]
  usos_permitidos:
    equipamiento: [comercio_sin_terminales, seguridad, servicios]
    actividad_productiva:
      inofensiva: {ocupacion: 0.6, constructibilidad: 1.2, altura: 7}
      molesta: {ocupacion: 0.6, constructibilidad: 1.8, altura: 10}  # constructibilidad MAS ALTA del PRC
    infraestructura: [transporte_terrestre · ocupacion 0.8 · constructibilidad 1.6 · altura 10]
  usos_prohibidos:
    residencial: [vivienda, hospedaje, hogares_acogida]
    equipamiento: [cientifico, culto, cultura, deporte, educacion, esparcimiento, salud, social]
    actividad_productiva: [insalubre, contaminante, peligrosa]
    infraestructura: [energetica, sanitaria]
  relevancia_hijuela_2: ALTA (clave para desarrollo comercial · constructibilidad mas alta · EDS molesta, talleres, bodegaje · localidad La Higuera SI esta en el listado)

ZIS:
  nombre: Zona Infraestructura Sanitaria
  aplica_en: [Caleta Los Hornos, Chungungo, El Trapiche, Los Choros, Punta de Choros, Punta Colorada]
  observacion: La_Higuera_NO_aparece_en_listado_oficial · pero APR municipal La Higuera existe · probable omision ordenanza o zona ZIS asignada solo donde la planta APR esta materializada en otras localidades
  subdivision_minima_m2: 800
  ocupacion_max: 0.5
  constructibilidad: 0.5
  altura_max_m: 10.0
  antejardin_m: 5.0
  uso_unico: plantas_e_instalaciones_agua_potable_y_aguas_servidas
  todo_lo_demas: prohibido
  relevancia_hijuela_2: NULA en La Higuera localidad (ZIS no listada para La Higuera) · pero APR local existe (probable conflicto formal con Ordenanza)

ZIP:
  nombre: Zona Infraestructura Portuaria
  aplica_en: [Caleta Los Hornos, Chungungo, Punta de Choros]
  subdivision_minima_m2: 1000
  agrupamiento: [aislado · sin adosamiento]
  altura_max_m: 7-12
  antejardin_m: 5.0
  usos_permitidos:
    equipamiento: [comercio, cientifico, deporte, seguridad]
    actividad_productiva: [inofensiva, molesta]
    infraestructura: [transporte_terrestre_maritimo_portuario, sanitaria_inofensiva]
  usos_prohibidos:
    residencial: [vivienda, hospedaje, hogares_acogida]
    equipamiento: [culto, cultura, educacion, esparcimiento, salud, servicios, social]
    infraestructura: [energetica]
  relevancia_hijuela_2: NULA (no aplica a La Higuera)

ZAV:
  nombre: Zona Area Verde
  aplica_en: [La Higuera, Caleta Los Hornos, Chungungo, El Trapiche, Los Choros, Punta de Choros, Punta Colorada]
  subdivision_minima_m2: no_especificada
  ocupacion_max: 0.2
  constructibilidad: 0.2  # muy baja · jardines, plazas con quincho, miradores
  altura_max_m: 3.5  # muy baja · pergolas, kioscos, escaleras
  antejardin_m: 5.0
  agrupamiento: [aislado]
  usos_permitidos:
    equipamiento: [cientifico, culto, cultura, deporte_sin_medialuna, esparcimiento_basico]
    espacio_publico: segun_OGUC
  usos_prohibidos:
    residencial: [vivienda, hospedaje, hogares_acogida]
    equipamiento: [comercio, educacion, salud, seguridad, servicios, social]
    actividad_productiva: [todas · inofensiva, molesta, insalubre, contaminante, peligrosa]
    infraestructura: [sanitaria, transporte, energetica]
  relevancia_hijuela_2: ALTA (15.9% del cat5 segun D2.B · 7.91 ha · funciona como restriccion fuerte al desarrollo edificado en cuadrantes Q11/Q20/Q21)
  consecuencia_para_tomas:
    si_una_toma_esta_dentro_de_ZAV: regularizacion_via_PRC_es_INCOMPATIBLE
      (la zona prohibe explicitamente vivienda y hogares_acogida)
    salida: requiere_modificacion_PRC_para_recodificar_a_ZU1_o_similar
```

---

## 2. Areas de Riesgo · capa SUPERPUESTA · no sustituye zonificacion

```yaml
AR1:
  nombre: Zonas inundables o potencialmente inundables
  causales: [maremotos, tsunamis, proximidad_a_lagos, rios, esteros, quebradas, cursos_agua_no_canalizados, napas_freaticas, pantanos]
  superficie_en_cat5_ha: 6.77 (13.7% del cat5)

AR2:
  nombre: Zonas propensas a avalanchas, rodados, aluviones o erosiones acentuadas
  superficie_en_cat5_ha: 3.89 (7.8% del cat5)

AR3:
  nombre: Zonas o terrenos con riesgos generados por la actividad o intervencion humana
  superficie_en_cat5_ha: 1.61 (3.2% del cat5)

regla_canonica_Art_10_Ordenanza:
  "Las normas urbanisticas aplicables a los proyectos localizados en estas areas
   y que cumplan los requisitos del inciso quinto del Art. 2.1.17 OGUC,
   seran las correspondientes a la zona donde se emplaza el proyecto"

implicancia:
  AR1/AR2/AR3 son CAPAS SUPERPUESTAS · NO sustituyen zonificacion
  un_predio_puede_ser_ZU1_y_AR2_simultaneamente
  el_riesgo_NO_prohibe_construir · pero exige estudio adicional Art 2.1.17 OGUC
```

---

## 3. ZNE · Zonas No Edificables

```yaml
ZNE_1:
  nombre: Faja Via FFCC
  fuente_normativa: Ley General de Ferrocarriles · DS 1.157 / 1931 / Min Fomento
  ancho_faja: variable segun tipo

ZNE_2:
  nombre: Faja Linea Alta Tension
  fuente_normativa: 
    DFL 1 Mineria 1982 Art. 56
    Reglamento SEC NSEG 5En.71 Arts. 108-111
  ancho_faja: variable segun tension

regla:
  solo_actividades_transitorias
  proyectos_permanentes_prohibidos

relevancia_hijuela_2:
  ZNE_1: NULA (no hay FFCC en La Higuera localidad)
  ZNE_2: ALTA si pasa linea AT (verificar en cat5 con KMZ MOP)
```

---

## 4. ZCH · Zonas Conservacion Historica

```yaml
ZCH1:
  nombre: Zona Conservacion Historica 1
  localidad: Los Choros (exclusivamente)
  relevancia_hijuela_2: NULA

ZCH2:
  nombre: Zona Conservacion Historica 2
  localidad: Chungungo (exclusivamente)
  relevancia_hijuela_2: NULA

ICH_La_Higuera:
  cantidad: 11 inmuebles
  ubicacion: Av Gabriela Mistral (acera norte, sur, poniente) + Av La Paz
  roles_SII: [24-012, 24-013, 8-02, 24-016, 24-017, 24-018, 26-006, 26-004, 26-003, 26-002, 24-010, 25-021]
  superficie_en_cat5_ha: 0.14 (0.3% · 11 puntos minimos · son edificaciones individuales)
  NO_coincide_con_roles_Hijuela_2 (24-123 y 24-160)
  relevancia_hijuela_2: NULA EN PREDIO · alta como contexto patrimonial vecino
```

---

## 5. Plaza · codigo no oficial Ordenanza

```yaml
Plaza:
  estatus: codigo_aparente_KMZ_no_es_codigo_oficial_Ordenanza
  hipotesis: en el KMZ del PRC, el poligono Plaza tiene atributo `name=Plaza`
            pero la Ordenanza NO incluye "Plaza" como zona en Art. 8
  interpretacion_canonica:
    es ZAV (Area Verde) con denominacion toponimica especifica
    OR es Espacio Publico segun OGUC (no zonificado expresamente)
  superficie_en_cat5_ha: 0.41 (0.8%)
  localizacion: cuadrante Q21 mayoritariamente (0.15 ha) · Q10 (0.13 ha) · Q11/Q20 (resto)
  para_validacion: terreno Daniel RTK · verificar si es plaza materializada o suelo solo declarado
```

---

## 6. Tabla resumen cat5 cuadrante Q21 (mejor candidato validacion RTK)

```yaml
Q21:
  ha_total: 12.39
  ZU1: 0.06 (0.5%)
  ZAV: 0.33 (2.7%)
  Plaza: 0.15 (1.2%)
  ZU2: 0.12 (1.0%)
  AR1: 0.29 (2.3%)
  AR2: 0.16 (1.3%)
  Limite_urbano: 12.39 (100%)
  Zonificacion_total_zona_urbana: 0.66 (5.3% · BAJO comparado con D2 anterior que reporto 89.1%)

discrepancia_a_verificar:
  D2_main: Zonificacion en Q21 = 89.1% (11.04 ha)
  D2_B: ZU1+ZU2+ZAV+Plaza en Q21 = 5.3% (0.66 ha)
  brecha: 83.8 puntos porcentuales = 10.4 ha
  hipotesis: D2_main contabilizo poligonos zona_urbana con codigo NULO (SIN_CODIGO) como "Zonificacion"
            D2_B solo conto los con codigo extraido del HTML description
  accion: revisar 8 features zona_urbana con codigo NULO en Q21
```

---

## 7. Lo que ESTA en cat5 vs lo que NO esta (Sintesis HECHO_OBSERVADO)

```yaml
HECHO_OBSERVADO_cat5_49.57_ha:
  cubre_limite_urbano: 48.22 ha (97.3%)
  con_codigo_zona_extraible: 34.75 ha (70.1%)
    ZU1: 26.29 ha (53.0%)  · zona dominante · permite vivienda hasta 7m altura
    ZAV: 7.91 ha (15.9%)   · area verde · prohibe vivienda
    Plaza: 0.41 ha (0.8%)  · subtype de ZAV o espacio publico
    ZU2: 0.14 ha (0.3%)    · zona perifierica
  sin_codigo_zona_extraible: 14.82 ha (29.9%)  ← INVESTIGADO EN D2C.B
  con_AR_superpuesta: 12.27 ha (24.8%)  · NO sustituye zonificacion
    AR1: 6.77 ha (13.7%)
    AR2: 3.89 ha (7.8%)
    AR3: 1.61 ha (3.2%)
  con_ICH_superpuesto: 0.14 ha (0.3%) · 11 inmuebles patrimoniales
```

---

## 8. Lo que esto IMPLICA para Hijuela 2

```yaml
para_canon_HIJUELA_2_v3:
  hecho_canonizable:
    1: del cat5 (asentamiento dentro bbox H2), 53% esta en ZU1 · esto SI permite vivienda hospedaje comercio inofensivo y EDS  
    2: del cat5, 15.9% esta en ZAV · esto NO permite vivienda · regularizar tomas en ZAV exige modificar PRC
    3: del cat5, 24.8% tiene AR1/AR2/AR3 superpuesta · construir alli exige estudio Art 2.1.17 OGUC
    4: 29.9% del cat5 no tiene codigo zona extraible · investigado en D2C.B documento separado
    5: ZAP (zona actividades productivas) SI aplica a localidad La Higuera · constructibilidad 1.8 · es el caballo de batalla para EDS, strip center con bodega, talleres
    6: ZIS NO esta listada para La Higuera localidad en Ordenanza · pero APR municipal existe · probable inconsistencia formal o ZIS asignada por modificacion posterior

para_estrategia_tomas:
  si_toma_en_ZU1: regularizable_via_PMB_y_Art_55_LGUC (ZU1 permite vivienda)
  si_toma_en_ZAV: NO_regularizable_sin_modificacion_PRC (ZAV prohibe vivienda · proceso lento, SEREMI MINVU + CORE + EAE)
  si_toma_en_AR1_AR2_AR3: regularizable_con_estudio_riesgo Art 2.1.17 OGUC (NO prohibitivo per se)
  si_toma_en_ICH: NO_regularizable · debe demolerse o trasladarse

para_estrategia_comercial:
  EDS_o_strip_center_en_ZU1: VIABLE (ZU1 permite EDS 1 cada 10 m2 + comercio)
  EDS_grande_o_galpon_logistico_en_ZAP: ÓPTIMO (constructibilidad 1.8 · usos productivos molestos permitidos · sin uso residencial competidor)
  hospedaje_turistico_en_ZAV: PROHIBIDO
  vivienda_de_alta_densidad_en_ZU2: LIMITADA (ZU2 = solo aislado, densidad 70 hab/ha vs ZU1 que es 300 hab/ha)
```

---

## 9. Caveats epistemologicos

```yaml
caveat_1:
  el_cat5_es_4_subrectangulos_de_grilla_4x4_ortofoto · NO la silueta exacta del asentamiento detectado
  los porcentajes son sobre los 4 cuadrantes · no sobre la huella real del asentamiento

caveat_2:
  D2_main vs D2_B reportan superficies "Zonificacion" distintas
  D2_main: 34.75 ha (todos los poligonos zona_urbana del PRC dentro de cat5, con codigo o sin codigo)
  D2_B:    34.75 ha (solo los poligonos con codigo extraido del HTML description)
  AUNQUE_los_totales_coinciden, los_desgloses_por_cuadrante_pueden_NO_coincidir
  para Q21: D2_main reporta 89.1% (11.04 ha) Zonificacion · D2_B reporta 5.3% (0.66 ha) con codigo
  brecha: 10.4 ha de poligono zona_urbana en Q21 sin codigo en HTML description
  hipotesis_a_validar: en el KMZ original esos poligonos tienen codigo en otra columna (CODIGO, COD_ZONA, etc.)
  accion_pendiente: re-parsear esos poligonos buscando codigo en otras llaves del SchemaData

caveat_3:
  ZIS no aparece para La Higuera localidad en Ordenanza · APR municipal SI existe
  3 posibilidades: 
    a) modificacion posterior al D.676/2020 que la incorporo
    b) la APR esta fuera del limite urbano · se rige por Art 55 LGUC
    c) hay inconsistencia formal entre instrumento PRC y realidad operacional
  No promovible como canon sin verificacion en terreno o resolucion DOM

caveat_4:
  Plaza no es codigo oficial Art 8 Ordenanza
  es probable denominacion local de un poligono ZAV
  pendiente: verificar en terreno y en plano oficial PRCLH/01
```

---

## 10. Pendientes inmediatos post-D2.C

```yaml
D2_C_complemento:
  - re-parsear poligonos zona_urbana sin codigo en Q21 (10.4 ha) buscando codigo en otras llaves
  - verificar si Plaza es ZAV con nombre o categoria distinta
  - investigar el 29.9% sin codigo y sin clasificacion (D2C.B documento separado)

D3:
  cruce: roles SII catastral vs encuesta socioeconomica residentes
  bloqueado_por: nada · puede ejecutarse cuando se autorice

D4:
  cruce: ocupacion observada (ortofoto) vs encuesta
  bloqueado_por: nada

D5:
  cruce: titularidad (CBR) vs ocupacion (RTK + encuesta)
  corazon_de_procesos_saneamiento
  bloqueado_por: D3+D4 previos
```

---

**Documento canonizable:** SI · fuente primaria es la Ordenanza Local PRC La Higuera D.676/2020 · texto literal Art. 8-12 leido directamente del PDF en data room.

**Linkado con:**
- [[CANON_HIJUELA2_v2]] (debera extenderse con bloque normativo)
- [[INGESTA_NORMATIVA_PRI_PRC_ITS_v1]]
- [[D2_CRUCE_NORMATIVO_FINO_CAT5]]
- [[D2B_DESGLOSE_CODIGOS_ZONA_CAT5]]
- [[D2C_INVESTIGACION_29_9_PCT_SIN_ZONIFICACION]] (siguiente)
- [[ANALISIS_PRC_ZONIFICACION_HIJUELA2_2026]] (análisis previo abril 2026 · este documento lo confirma y extiende)
