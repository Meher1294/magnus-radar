# TRACK 1 · Cruce planilla socioeconómica × KMZ-06 catastro SII

**Fecha:** 2026-05-31
**Instrucción del usuario (Max):** *"Ejecutar inmediatamente TRACK 1: CBR planilla × KMZ-06 / DataRoom_Cominetti_LaHiguera.kmz. Objetivo: resolver la brecha social-catastral-jurídica del pueblo/cat5."*
**Reglas aplicadas (declaradas por Max):**
- no inferir propietario desde ocupante
- no inferir ocupación desde rol
- no inferir titularidad desde inscripción declarada sin contrastar fuente

---

## 0. Hallazgo bloqueante zero · el KMZ-06 NO tiene CBR

```yaml
HECHO_OBSERVADO:
  KMZ_06_canonico: La_Higuera_UTF8.kmz (1.4 MB · 7687 placemarks)
  atributos_disponibles_por_placemark:
    - COMUNA (4102 · La Higuera)
    - MANZ_SII (manzana SII)
    - PREDIO (número predial)
    - ROL_SII (composición manz-predio)
    - SECTOR (vacío en 85% · solo 4 placemarks "La Higuera")
    - ESTADO (V vigente / otros)
    - ESTADO_REV
  
  NO_DISPONIBLE:
    - fojas (CBR)
    - numero_inscripcion (CBR)
    - año_inscripcion (CBR)
    - nombre_titular
    - direccion

consecuencia:
  el cruce planeado por bisagra CBR (fojas, N°, año) NO existe estructuralmente
  el catastro KMZ-06 NO contiene inscripción CBR
  la planilla SI contiene CBR para 363 de 433 tenencias (84%)
  la asimetría es definitiva · no se resuelve con otro pass

ajuste_de_alcance:
  cruce_por_bisagra_CBR: IMPOSIBLE
  cruce_geográfico_por_centroides: POSIBLE (solo agregado)
  cruce_por_calle ↔ SECTOR: IMPOSIBLE (sector vacío 85% · 0 calles planilla coinciden con sectores KMZ-06)
  cruce_por_calle ↔ MANZ_SII: POSIBLE como hipótesis (calles agrupadas por manzana · requiere RTK validación)
```

---

## 1. D3.T1.A · Estado catastral del pueblo cabecera (HECHO_OBSERVADO)

```yaml
universo_kmz_06_centroides_en_pueblo_cabecera_PRC:
  total_predios: 693
  predios_individualizados (rol distinto a 0-0): 623
  predios_en_0_0 (sin individualización SII): 70 (10.1%)
  roles_unicos_individualizados: 536
  
  manzanas_SII_dominantes:
    manz 25: 189 predios
    manz 27: 167 predios
    manz 26: 141 predios
    manz 0:  70 predios (= los 70 polígonos 0-0)
    manz 24: 52 predios (incluye los 11 ICH + roles canon 24-123/24-160 si vecinos)
    manz 227: 37 predios
    otras (12 manzanas): 35 predios
  
  diferencia_con_planilla:
    planilla: 466 viviendas + 22 instituciones = 488
    KMZ-06: 693 predios
    delta: +205 predios catastrales sin contraparte planilla
    
  hipotesis_para_+205 (NO promovible · BLOQUEADO):
    - predios urbanos vacíos (sin construcción)
    - predios con vivienda no encuestada por planilla 2019
    - subdivisiones catastrales post-2019
    - errores SII (polígonos duplicados o anómalos)
    accion_para_resolver: RTK + cruce visual ortofoto + revisión catastral SII vigente
```

---

## 2. D3.T1.B · Estado social-jurídico del pueblo cabecera (HECHO_OBSERVADO)

```yaml
universo_planilla_DEFINITIVO_2_marzo_2019:
  viviendas: 466
  instituciones: 22
  tenencias_declaradas: 433 (relaciones vivienda-tipo-persona)
  
  tenencias_por_tipo:
    propietario: 337 (77.8%)
    usufructuario: 79 (18.2%)
    arrendador: 15 (3.5%)
    comodatario: 2 (0.5%)
  
  inscripcion_CBR_declarada:
    con (fojas + N° + año): 363 (84% de 433)
    sin inscripcion: 70 (16%)  ← COINCIDENCIA CUANTITATIVA con 70 polígonos 0-0 KMZ-06
    
  rol_SII_declarado_en_planilla:
    explicitamente_mencionado: 1 (Parroquia Católica · rol 24-010)
    el_resto: sin mencionar rol SII en planilla
    
  alertas_de_saneamiento:
    viviendas_sin_CBR_declarada: 70 tenencias (universo crítico saneamiento)
    viviendas_sin_agua_potable: 89
    viviendas_solo_pozo_negro: 187
    viviendas_sin_dato_habitacion: 61 (potencialmente vacías)
```

---

## 3. D3.T1.C · Salidas mínimas (las 6 que pediste)

```yaml
1_viviendas_con_CBR:
  cantidad: 363 tenencias · 84% del universo de tenencias declaradas
  tipo:
    propietario_con_CBR: ~285 (proyección · 84% de 337)
    usufructuario_con_CBR: ~66 (proyección · 84% de 79)
    arrendador_con_CBR: ~13
    comodatario_con_CBR: ~2
  estado_epistemico:
    HECHO: declaran fojas+N°+año en planilla
    NO_HECHO_aun: la inscripción declarada coincide con catastro CBR real (BLOQUEADO sin verificación CBR de Conservador)

2_viviendas_sin_CBR:
  cantidad: 70 tenencias · 16% del universo
  estado_epistemico: HECHO declarado en planilla
  PRIORIDAD: ALTA (universo de saneamiento jurídico)
  COINCIDENCIA_CUANTITATIVA_a_validar:
    70 tenencias sin CBR ↔ 70 polígonos 0-0 en pueblo cabecera
    NO_es_demostracion · es señal a investigar
    BLOQUEADO: asignación individual sin georreferenciar
  acción_de_validación:
    georreferenciar las direcciones de las 70 tenencias sin CBR (RTK Daniel)
    verificar si caen sobre los 70 polígonos 0-0 (intersección geometríca)

3_viviendas_con_rol_probable:
  cantidad: BLOQUEADO de manera individual
  agregado_observable: 693 predios catastrales en pueblo · 536 roles únicos
  estado_epistemico: BLOQUEADO sin georreferenciación de direcciones planilla
  acción_de_validación:
    RTK Daniel calles principales (TOP 10 = 192 viviendas, 41% del corpus)
    permitirá asignar manz_SII → calle → vivienda

4_viviendas_sin_rol_probable:
  cantidad: BLOQUEADO individualmente
  agregado_observable: si una vivienda cae en polígono 0-0, NO tiene rol SII individualizado
  estado_epistemico: BLOQUEADO hasta cruce geográfico (acción 3)

5_viviendas_en_0_0:
  cantidad_polígonos_0_0_en_pueblo: 70 (HECHO)
  cantidad_viviendas_planilla_en_polígonos_0_0: BLOQUEADO sin georreferencia
  estado_epistemico: 
    HECHO_estructural: existen 70 zonas catastralmente sin individualización dentro del pueblo
    BLOQUEADO: cuántas viviendas declaradas se ubican en esas zonas

6_viviendas_prioritarias_saneamiento:
  
  rank_1_sin_CBR_declarada:
    cantidad: 70 tenencias
    razon: ausencia de inscripción CBR registrable
    accion: RTK + cruce ortofoto + revisión CBR vigente
  
  rank_2_con_persona_fallecida_en_grupo_familiar:
    cantidad: 32 viviendas (dato del documento INGESTA · pendiente verificación en CSV)
    razon: sucesión no inscrita probable · 32 viviendas con marca "fallecido" en columna nombre
    accion: cruce nombre fallecido × planilla CBR · revisión cadena registral
  
  rank_3_solo_pozo_negro_sin_fosa:
    cantidad: 187 viviendas
    razon: universo del programa APR/saneamiento higiénico
    NOTA: NO es prioridad saneamiento jurídico (CBR) · es saneamiento sanitario
    accion: PMB + extensión red APR
  
  rank_4_sin_dato_habitacion:
    cantidad: 61 viviendas
    razon: posiblemente vacías o no encuestadas · pueden ser tomas
    accion: levantamiento focalizado para confirmar uso
  
  rank_5_sin_agua_potable:
    cantidad: 89 viviendas
    razon: marginalidad de servicios básicos · indicador de informalidad
    accion: cruce con AR1/AR2/AR3 (puede ser zona inundable)
```

---

## 4. D3.T1.D · Campos BLOQUEADOS + acción de validación

```yaml
campos_bloqueados_post_TRACK1:

  matching_individual_vivienda_↔_rol_SII:
    estatus: BLOQUEADO
    razon: KMZ-06 sin direcciones · planilla sin coordenadas
    acción: RTK Daniel · 1 día campo + 0.5 día procesado
    señal_esperada: muy alta · resuelve >80% del universo

  matching_tenencia_↔_inscripcion_CBR_real:
    estatus: BLOQUEADO
    razon: KMZ-06 NO contiene CBR (asimetría estructural definitiva)
    acción: 
      a) consulta CBR La Serena directa para 70 tenencias sin CBR + 32 con fallecido (102 casos)
      b) cruce manual con tabla de propiedades CBR si se obtiene desde Conservador
    señal_esperada: alta · resuelve titularidad jurídica
    costo: 1-2 semanas trámite + costo CBR por inscripción

  separación_dominio_declarado_vs_titularidad_jurídica:
    estatus: PARCIALMENTE_DESBLOQUEADO
    lo_que_SI_se_sabe:
      planilla declara 337 propietarios (77.8%) con 84% de ellos con CBR explícita
      planilla declara 79 usufructuarios + 15 arrendadores + 2 comodatarios
    lo_que_NO_se_sabe_aún:
      cuántos de los 337 propietarios declarados tienen titularidad CBR efectiva post-2019
      cuántos están en estado actual (fallecido del titular, transferencia, herencia inscrita)
    acción: verificación CBR para muestra estratificada · al menos los 102 casos prioritarios

  identificación_de_los_70_polígonos_0_0_pueblo:
    estatus: BLOQUEADO
    razon: ¿son tomas? ¿BNUP? ¿predios fiscales urbanos? ¿errores SII?
    acción: 
      a) cruce ortofoto + RTK
      b) consulta SII reasignación de roles
      c) verificación si están sobre AR1/AR2/AR3 (puede explicar parte)
```

---

## 5. D3.T1.E · Tabla de casos priorizados para Daniel RTK

```yaml
PRIORIDAD_1_70_tenencias_sin_CBR + posibles_0_0:
  cantidad: 70 tenencias
  pregunta_central: ¿están geográficamente en los 70 polígonos 0-0 del pueblo?
  costo_RTK: 0.5 día (georeferenciar las direcciones de estas 70 tenencias)
  valor: muy alto · resuelve el grueso de la brecha jurídico-catastral
  desbloquea:
    - estrategia regularización (PMB urbano vs saneamiento BBNN)
    - identificación de tomas reales vs sucesiones no inscritas
    - oferta a propietarios con título declarado pero sin inscripción

PRIORIDAD_2_32_viviendas_con_fallecido_en_familia:
  cantidad: 32 viviendas
  pregunta_central: ¿la sucesión está inscrita? ¿hay título vigente?
  costo: 0.25 día RTK + consulta CBR
  valor: alto · indicador de proceso de saneamiento legal pendiente

PRIORIDAD_3_TOP_10_calles_para_georreferenciar_estructura:
  calles_y_n_viviendas:
    - Marta Brunett: 38
    - José Orrego: 22
    - Av. La Paz: 21
    - Pedro Pablo Muñoz: 20
    - Av. Gabriela Mistral: 19  ← donde están los 11 ICH
    - Nolberta Salas: 16
    - Raúl Castellón: 15
    - Rogelio Barraza: 14
    - Rogelio Alday: 14
    - Arturo Prat: 13
  cantidad_total: 192 viviendas (41% del corpus)
  costo_RTK: 1 día campo (esquinas + puntos medios)
  valor: muy alto · permite asignar cada vivienda a manzana SII → rol SII

PRIORIDAD_4_44_viviendas_sin_dirección_en_planilla:
  cantidad: 44 viviendas
  pregunta_central: ¿dónde están físicamente?
  costo: alto · requiere levantamiento puerta a puerta o cruce con DOM
  valor: medio · son ~10% del corpus

PRIORIDAD_5_validar_si_predio_+205_son_construidos_o_vacíos:
  cantidad: 205 predios catastrales sin contraparte planilla
  pregunta_central: ¿están construidos? ¿son urbanos vacíos? ¿son cat5 no encuestado?
  costo: 0.5 día RTK + cruce ortofoto
  valor: medio-alto · explicaría la brecha cuantitativa
```

---

## 6. Síntesis con disciplina HECHO / INFERENCIA / BLOQUEADO / ACCIÓN

```yaml
HECHOS_OBSERVADOS_canonizables:
  1. KMZ-06 (La_Higuera_UTF8.kmz · 7687 placemarks) tiene atributos COMUNA/MANZ_SII/PREDIO/ROL_SII/SECTOR/ESTADO · NO tiene CBR
  2. 693 predios catastrales con centroide dentro del pueblo cabecera La Higuera (límite urbano PRC)
  3. 70 de esos 693 son polígonos 0-0 (10.1%) · macro-bloques sin individualización SII dentro del área urbana
  4. 536 roles individualizados en pueblo (sin 0-0)
  5. 23 manzanas SII únicas en pueblo · manz 25/27/26 concentran 497 predios (72%)
  6. Planilla declara 466 viviendas + 22 instituciones · 84% con CBR declarada · 78% propietario declarado
  7. 70 tenencias planilla sin CBR declarada · coincidencia cuantitativa con 70 polígonos 0-0 (no demostración)
  8. SECTOR del KMZ-06 está vacío en 85% · NO sirve como bisagra de cruce
  9. 0 de las 10 calles principales de planilla coinciden con valores de SECTOR del KMZ-06

INFERENCIAS_validas:
  1. La cobertura catastral SII del pueblo (693 predios) supera nominalmente la cobertura planilla (488 unidades) · ratio 1.42
  2. La coincidencia 70 sin CBR ↔ 70 polígonos 0-0 es ESTADÍSTICAMENTE LLAMATIVA · pendiente validación geográfica
  3. El cruce CBR planilla × KMZ-06 NO se puede ejecutar individualmente por asimetría de atributos

BLOQUEADOS:
  1. Matching individual vivienda ↔ rol SII (sin georreferencia direcciones)
  2. Matching tenencia ↔ inscripción CBR vigente (sin acceso CBR La Serena)
  3. Identificación de los 70 polígonos 0-0 del pueblo (¿tomas? ¿BNUP? ¿error SII?)
  4. Resolución de la brecha +205 predios catastrales sin contraparte planilla

ACCIONES_DE_DESBLOQUEO_ranked:
  A1. RTK Daniel · 70 tenencias sin CBR (PRIORIDAD 1 · 0.5 día)
  A2. RTK Daniel · TOP 10 calles (PRIORIDAD 3 · 1 día)
  A3. Consulta CBR · 102 casos prioritarios (PRIORIDAD 2 · 1-2 semanas)
  A4. Cruce ortofoto + RTK · 205 predios catastrales sin contraparte (0.5 día)
  A5. Oficio SII · reasignación roles 0-0 urbanos (1 semana)
```

---

## 7. Frase de cierre canónica · TRACK 1

```yaml
TRACK_1_resuelve:
  cobertura_catastral_del_pueblo:
    693 polígonos SII / 536 roles individualizados / 70 polígonos 0-0
  
  asimetría_estructural_planilla_vs_catastro:
    planilla tiene CBR pero no rol
    catastro tiene rol pero no CBR
    bisagra CBR planeada NO existe en KMZ-06
  
  coincidencia_cuantitativa_70_vs_70:
    70 tenencias planilla sin CBR ↔ 70 polígonos 0-0 dentro pueblo
    señal a investigar · NO demostración
  
  ranking_de_5_acciones_RTK_Daniel:
    accion 1 (70 sin CBR) tiene el mejor retorno señal/esfuerzo
    accion 3 (TOP 10 calles) desbloquea estructura completa

TRACK_1_no_resuelve:
  matching_individual_vivienda_↔_rol
  titularidad_juridica_verificable (requiere CBR La Serena)
  identidad_de_los_70_poligonos_0_0
  brecha_cuantitativa_+205_predios
```

---

**Datos derivados guardados en:**
- `magnus-radar/docs/ingesta_planilla_socioec/TRACK1_roles_sii_en_pueblo.json`

**Linkado:**
- [[D3_CRUCE_ROL_SII_VS_ENCUESTA_v1]]
- [[D3_NEXT_Q22_Q12_Q02_y_FILA_INFERIOR_H2_v1]]
- [[INGESTA_PLANILLA_SOCIOECONOMICA_LA_HIGUERA_ITS_v1]]
- [[QUALITY_SCAN_CATASTRO_SII_LA_HIGUERA]]
- [[DIFF_KMZ_06_VS_09_CATASTRO_SII]]
- [[doctrina-rol-sii-no-es-identidad-territorial]]
- [[doctrina-no-derivar-estrategia-sin-capa-ocupacion]]
- [[doctrina-29-9-pct-es-zona-de-verificacion-fina]]
- [[canon-zonificacion-prc-la-higuera-v1]]
