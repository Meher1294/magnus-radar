# D3 · Cruce rol SII × encuesta socioeconómica × cat5

**Fecha:** 2026-05-31
**Autorización del usuario (Max):** *"No cerraría estrategia comercial ni regularización por ahora. Primero hay que saber quién ocupa qué y bajo qué condición declarada."*
**Disciplina aplicada:** HECHO_OBSERVADO / INFERENCIA / HIPÓTESIS / BLOQUEADO declarados explícitamente · no se asume vivienda=rol, ocupante=titular, dirección=ubicación
**Pre-requisitos:** D2.C completado (semántica zonas PRC) + ingesta planilla socioeconómica (task #5) + cruce geometría↔rol SII (task #7)

---

## 0. Hallazgo zero · refutación de hipótesis #9 de la ingesta planilla

```yaml
hipotesis_9_ingesta_planilla:
  enunciado_original: "la planilla cubre el pueblo cabecera La Higuera, la ortofoto cubre OTRO asentamiento al lado oriental · son dos zonas territoriales distintas"
  estado: REFUTADA_POR_GEOMETRIA_2026-05-31
  evidencia:
    pueblo_cabecera_PRC: bbox UTM 19S E=[285436, 287648] N=[6732671, 6734366] · 196.7 ha
    bbox_H2_ortofoto: bbox UTM 19S E=[286221, 287517] N=[6732579, 6734101] · 197.2 ha
    interseccion_real: 136.5 ha (69.4% del pueblo · 69.2% del bbox H2)
    distancia_centroides: 287 m
  consecuencia: 
    el bbox H2 SI cubre la zona donde está la planilla
    el cat5 (Q10/Q11/Q20/Q21) está completamente dentro del pueblo cabecera
    la planilla socioeconómica SI aplica al cat5 (parcialmente)
```

---

## 1. D3.A · Estado de la capa SOCIAL del pueblo cabecera (HECHO_OBSERVADO)

```yaml
universo_planilla_DEFINITIVO_2_marzo_2019:
  viviendas_total: 466
  personas: 563
  instituciones: 22
  habitantes_declarados: 1372 (vs resumen oficial Hoja7 = 1365)
  hojas_origen: 7 hojas (Hoja1-7) · cabecera comunal La Higuera

tenencias_declaradas:
  propietario: 337 (77.8% de 433 tenencias)
  usufructuario: 79 (18.2%)
  arrendador: 15 (3.5%)
  comodatario: 2 (0.5%)
  TOTAL: 433 relaciones vivienda-tenencia

inscripcion_CBR_explicita:
  con_fojas+numero+anio: 363 / 433 tenencias (84%)
  sin_inscripcion_CBR: 70 tenencias (16%)
  consecuencia: titular_juridico se puede poblar para 84% del corpus sin visita al CBR

saneamiento_higienico:
  con_agua_potable: 377 viviendas (81%)
  solo_pozo_negro_sin_fosa_septica: 187 viviendas (40%)  · universo APR-saneamiento
  con_fosa_septica: 187 viviendas (40%)
  sin_servicio_higienico_declarado: 92 viviendas (20%)

habitacion:
  viviendas_con_n_habitantes_positivo: 405 (87%)
  viviendas_sin_dato_habitacion: 61 (13%) · potencialmente vacías o no encuestadas

distribucion_por_calle:
  calles_distintas: 59
  TOP_10_concentra: 192 viviendas (41%)
    1. Marta Brunett: 38
    2. José Orrego: 22
    3. Av. La Paz: 21
    4. Pedro Pablo Muñoz: 20
    5. Av. Gabriela Mistral: 19
    6. Nolberta Salas: 16
    7. Raúl Castellón: 15
    8. Rogelio Barraza: 14
    9. Rogelio Alday: 14
    10. Arturo Prat: 13
  sin_direccion: 44 (9% del corpus)
```

---

## 2. D3.B · Estado de la capa CATASTRAL del cat5 (HECHO_OBSERVADO)

```yaml
cat5_universo:
  cuadrantes: [Q10, Q11, Q20, Q21]  · grilla 4x4 sub-rectángulos bbox H2
  ha_total: 49.57 (cada cuadrante 12.39 ha)
  bbox: E=[286207, 286869] N=[6732953, 6733715] (UTM 19S)
  todos_categoria_ocupacional: 5  (máxima densidad de ocupación detectada)

roles_SII_que_intersectan_cat5:
  total_ha_en_roles: 21.73 ha de 49.57 (43.8% del cat5 tiene rol SII identificable)
  desglose_top_10:
    "0-0":     15.32 ha (70.5% de los 21.73 ha · 13 polígonos 0-0 distintos)
    "24-30":    2.05 ha (9.4%)   · canon P2.1 · titular identificable
    "24-154":   1.34 ha (6.2%)   · canon P2.1
    "24-43":    1.14 ha (5.3%)   · Hijuela 1 candidato
    "27-0":     0.39 ha (1.8%)
    "27-2":     0.37 ha (1.7%)
    "25-19":    0.33 ha (1.5%)
    "25-1":     0.30 ha (1.4%)
    "26-147":   0.28 ha (1.3%)
    "24-0":     0.20 ha (0.9%)

hallazgos_criticos_catastrales:
  1_HECHO: cat5 NO intersecta roles SII 24-123 ni 24-160 en la capa SII usada (KMZ-06)
     NO_implica_directamente: que cat5 no pertenezca jurídicamente a Hijuela 2
     razón: doctrina-rol-sii-no-es-identidad-territorial · SII/CBR/RTK pueden no coincidir
     relacion_juridica_cat5_H2:
       estatus: BLOQUEADA_hasta_cruce_CBR_RTK
       lo_que_se_puede_decir: el rol SII catastral H2 no se ve en el cat5
       lo_que_NO_se_puede_decir: el cat5 está fuera de H2 jurídicamente

  2: 70.5% del cat5 con rol SII identificable está en 0-0 (anomalía catastral preexistente)
     refuerza: doctrina_rol_sii_no_es_identidad_territorial

  3: 56.2% del cat5 (49.57 - 21.73 = 27.84 ha) NO tiene polígono catastral SII encima
     este_es_un_NUEVO_gap: cat5_sin_catastro_SII_alguno (similar al 29.9% sin zonificación)
     tratamiento: zona_de_verificacion_fina (no resolver por inferencia)

solape_cat5_con_perimetro_RTK_Hijuela_2:
  Q10: 47.2% dentro RTK H2
  Q11: 0%   fuera RTK H2
  Q20: 53.6% dentro RTK H2
  Q21: 34.1% dentro RTK H2
  promedio_cat5: ~34% dentro perímetro RTK H2
  consecuencia: el cat5 está PARCIALMENTE dentro H2 (no completamente)
```

---

## 3. D3.C · Cruce posible (sin asumir asociaciones)

### 3.1 · Solape geográfico planilla ↔ cat5 · disciplina HECHO / INFERENCIA / BLOQUEADO

```yaml
HECHO_OBSERVADO:
  pueblo_cabecera_total_ha: 196.7 (límite urbano PRC)
  cat5_total_ha: 49.57
  cat5_dentro_pueblo_cabecera_pct: ≥97.3% (D2.C · 48.22 ha)
  pueblo_cabecera_y_bbox_H2_solapan_pct: 69.4
  planilla_aplica_al_area_de_analisis: SI

INFERENCIA_valida_por_solape:
  entre 80 y 180 viviendas de la planilla PODRIAN caer dentro del cat5
  metodologia: 
    si distribución uniforme: 466 × (49.57/196.7) = 117 viviendas
    si heterogénea por calle dominante: rango 80-180
  estatus: PROYECCION · no asignación

BLOQUEADO:
  numero_exacto_de_viviendas_dentro_de_cat5:
    razon: direcciones de planilla sin georeferencia
    desbloquea_con: Daniel RTK o cruce CBR-KMZ06
  
  identidad_individual_de_cada_vivienda_con_cuadrante:
    razon: no_hay_matching vivienda↔polígono catastral en datasets actuales
    desbloquea_con: levantamiento social focalizado o RTK calles principales
```

### 3.2 · Cruce indirecto por inscripción CBR

```yaml
posibilidad_de_cruce_CBR_vivienda × CBR_rol_SII:
  planilla_CBR: 363 tenencias con (fojas, N°, año)
  catastro_KMZ_CBR: cada polígono catastral SII tiene (fojas, N°, año) en el KMZ-06
  cruce: matching (fojas, N°, año) entre los dos datasets
  
ejecucion_pendiente:
  esfuerzo: 90-120 min (parsear los 363 CBR de planilla + cruce contra KMZ-06 catastro)
  señal: ALTA · permitirá asignar rol SII a 363 viviendas (~78% del corpus)
  
bloqueado_por: nada · pero requiere acceso al KMZ-06 catastro completo con propiedades CBR
verificacion: KMZ-06 tiene atributo CBR explícito en SimpleData/ExtendedData?
```

### 3.3 · Cruce por nombre de calle (toponímico)

```yaml
top_5_calles_y_ubicacion_relativa_cat5:
  Av Gabriela Mistral: calle longitudinal histórica · 19 viviendas
    ubicacion_hipotetica: norte del pueblo · probablemente Q10/Q11
    es_donde_están_los_11_ICH_inmuebles_conservacion_historica
    
  Av La Paz: avenida central · 21 viviendas
    ubicacion_hipotetica: centro · probablemente Q11/Q20
    
  Marta Brunett: 38 viviendas (más densa)
    ubicacion_hipotetica: pendiente de verificar
    
  José Orrego: 22 viviendas
  Pedro Pablo Muñoz: 20 viviendas

PARA_VALIDAR:
  Daniel RTK · georeferenciar 5-10 esquinas principales
  o solicitar a DOM Municipal plano de nomenclatura vial
```

---

## 4. D3.D · Cruce BLOQUEADO sin georreferenciar

```yaml
preguntas_imposibles_de_responder_hoy:
  - ¿Cuántas viviendas de la planilla están en ZU1 vs ZAV vs AR1?
  - ¿Cuál de los 13 polígonos 0-0 del cat5 corresponde a cada vivienda?
  - ¿Cuántas tomas observadas en ortofoto coinciden con vivienda declarada en planilla?
  - ¿Cuántos arrendatarios viven en suelo declarado del Fisco?
  - ¿Cuántos usufructuarios están en sucesión no resuelta?

razon_del_bloqueo:
  las direcciones de la planilla son "calle sin numeración"
  no_hay coordenadas asignadas a cada vivienda
  no_hay matching directo vivienda↔polígono catastral
  
para_desbloquear:
  Acción_A (señal alta · esfuerzo medio · 1 día campo):
    Daniel RTK levanta 5-10 puntos clave por cada calle TOP-10
    permite triangular dirección → cuadrante
  
  Acción_B (señal alta · esfuerzo alto · 2-3 semanas):
    Levantamiento social puerta a puerta del cat5 (focalizado)
    pregunta: nombre + RUT + condición tenencia + año ocupación
    universo: ~117 viviendas estimadas en cat5
  
  Acción_C (señal media · esfuerzo bajo · 1 semana):
    Cruce CBR planilla × CBR KMZ-06 catastro
    permite asignar rol SII a 363 viviendas SIN ir a terreno
    pero NO resuelve quién OCUPA hoy (solo quién es TITULAR JURIDICO)
```

---

## 5. Síntesis epistemológica · qué SE PUEDE afirmar hoy

```yaml
HECHOS_OBSERVADOS_canonizables:
  1. Pueblo cabecera La Higuera tiene 466 viviendas + 22 instituciones + 1372 habitantes (PLANILLA_DEFINITIVO_2_2019)
  2. 77.8% de tenencias declaradas son "propietario" (337) · 18.2% usufructuario · 3.5% arrendador
  3. 84% de tenencias tienen inscripción CBR explícita en planilla
  4. 40% de viviendas tienen solo pozo negro (sin fosa séptica)
  5. El cat5 (49.57 ha) es subconjunto del pueblo cabecera (≥97.3% dentro límite urbano)
  6. El cat5 tiene 70.5% del área con rol SII identificable en macro-bloques 0-0
  7. Roles canon H2 [24-123, 24-160] NO intersectan el cat5
  8. Solape geográfico planilla-pueblo × bbox H2 = 69.4%
  9. Promedio del cat5 dentro perímetro RTK Hijuela 2 = ~34%

INFERENCIAS_validas:
  1. Entre 80 y 180 viviendas de la planilla PODRIAN caer geográficamente en el cat5 (proyección por solape · no asignación)
  2. El asentamiento cat5 es urbano-planificado (97.3% dentro límite urbano PRC) · NO rural-informal
  3. El cat5 catastralmente está en 0-0 + 24-30 + 24-154 + 24-43 en la capa SII usada · no se ve 24-123 ni 24-160
     NO_inferir: que cat5 esté fuera de H2 jurídicamente (CBR y RTK pendientes)
  4. La estrategia comercial NO puede cerrarse sin saber qué fracción de las viviendas estimadas son propietarios efectivos

HIPOTESIS_pendientes:
  1. Las 187 viviendas con solo pozo negro podrían concentrarse en cat5 (área más periférica) · NO verificado
  2. Las 70 tenencias sin CBR podrían concentrarse en zonas de toma / asentamiento informal · NO verificado
  3. El 56% del cat5 sin polígono catastral SII pueden ser cauces / BNUP / fiscal · paralelo al 29.9% sin zonificación
```

---

## 6. Lo que ESTO BLOQUEA (regla operacional)

```yaml
NO_PROMOVIBLES_HOY:
  estrategia_comercial_definitiva:
    razon: no se sabe qué fracción del cat5 está libre de ocupante con título
    
  estrategia_regularizacion_tomas:
    razon: no se sabe cuántas viviendas son tomas en sentido jurídico (vs ocupantes con título)
    pista_disponible: 121 viviendas pueblo sin CBR + 70 tenencias sin CBR
                    no necesariamente todas son "tomas" · pueden ser sucesiones no inscritas
    
  estrategia_PMB_saneamiento:
    razon: las 187 viviendas con pozo negro NO están todas en cat5 · solo una fracción
    desbloquea_parcialmente_con: Acción_A (RTK Daniel)
    
  oferta_a_Hijuela_2_residentes:
    razon: el cat5 catastralmente NO está en H2 (24-123, 24-160 no tocan cat5)
    consecuencia_operacional: oferta debe hacerse sobre área que SI esté en H2 · cuadrantes Q22/Q12/Q02 podrían ser candidatos · verificar
```

---

## 7. Acciones rankeadas (señal/esfuerzo) post-D3 · ORDEN OPERACIONAL CORREGIDO POR MAX

```yaml
1_Q22_Q12_Q02_dentro_RTK_H2:
  esfuerzo: 30 min · datos disponibles del cruce task #7
  señal: muy alta · responde si hay "suelo limpio" dentro perímetro operacional H2
  por_que_primero: define alcance real del problema · define si H2 tiene zona desarrollable libre
  prerequisito: nada
  
2_cruce_CBR_planilla_vs_KMZ06:
  esfuerzo: 90-120 min
  señal: alta · asigna rol SII a 363 viviendas sin terreno
  por_que_segundo: ataca la brecha social-catastral por la única columna trazable disponible
  prerequisito: verificar KMZ-06 tiene atributo CBR explícito
  
3_D4_ocupacion_observada_vs_encuesta:
  esfuerzo: 60-90 min
  señal: alta · cruza ortofoto (estructura física) vs planilla (declaración social)
  por_que_tercero: distingue tomas reales vs sucesiones no inscritas vs vivienda con título declarado
  prerequisito: D3 cerrado (ya hecho)
  
4_Daniel_RTK_calles_principales:
  esfuerzo: 1 día campo + 0.5 día procesado
  señal: muy alta · desbloquea georreferencia individual de viviendas
  prerequisito: agenda Daniel
  
5_levantamiento_social_focalizado_cat5:
  esfuerzo: 2-3 semanas terreno + procesado
  señal: muy alta · responde a la pregunta operacional definitiva
  costo: alto · justificable solo si decisión de avance Hijuela 2 lo amerita
  
6_re_extraer_codigos_zona_PRC_Q21_pendiente:
  esfuerzo: 30 min
  señal: complementaria · reduce 29.9% sin zonificación pero NO desbloquea ocupación
```

---

## 8. Frase de cierre canónica · qué hace y qué NO hace D3

```yaml
D3_no_cierra_titularidad:
  cierra_relevancia_social_del_area:
    planilla socioeconómica con 466 viviendas + 84% con CBR + 78% propietario aplica al área del cat5
  
  demuestra_que_la_planilla_aplica_al_cat5:
    solape geográfico 69.4% pueblo cabecera × bbox H2 (refuta hipótesis #9 ingesta planilla)
  
  detecta_brecha_entre_capa_social_y_capa_catastral:
    capa social: 78% propietario + 84% con CBR (alta formalización declarada)
    capa catastral: 70.5% del cat5 en macro-0-0 (alta anomalía catastral)
    brecha: el pueblo declara propiedad formal pero el catastro SII no la individualiza
  
  pero_no_asigna_aun_vivienda_individual_a_rol_ni_a_titular:
    se requiere: Daniel RTK + cruce CBR-KMZ06 + levantamiento focalizado
```

---

## 8. Pregunta crítica que emerge para próxima fase

```yaml
nueva_pregunta_estructural:
  los_cuadrantes_Q22_Q12_Q02 (parte oriental del bbox H2, fuera del cat5)
  ¿están dentro del perímetro RTK Hijuela 2?
  ¿qué ocupación tienen?
  ¿qué roles SII?
  
si_la_respuesta_es:
  A) sí_dentro_H2 + sin_ocupación: zona de desarrollo limpia · estrategia comercial directa
  B) sí_dentro_H2 + con_ocupación: replica el problema del cat5 en otra zona
  C) no_dentro_H2: el bbox H2 fue mal definido y H2 está en otro lugar

es_pre_requisito_para:
  cualquier_oferta_definitiva_a_Hijuela_2
  cualquier_proyecto_comercial_anclado_a_H2
```

---

**Linkado:**
- [[INGESTA_PLANILLA_SOCIOECONOMICA_LA_HIGUERA_ITS_v1]]
- [[cruce_geometria_rol_sii_v1]] (task #7)
- [[D2C_CODIGOS_PRC_LA_HIGUERA]]
- [[D2C_INVESTIGACION_29_9_PCT_SIN_ZONIFICACION]]
- [[CANON_HIJUELA2_v2]]
- [[doctrina-rol-sii-no-es-identidad-territorial]]
- [[doctrina-homonimia-territorial]]
- [[evt-h2-occupation-baseline-20260531]]
