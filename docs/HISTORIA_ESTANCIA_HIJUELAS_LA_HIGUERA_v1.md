# FASE D · Historia Estancia Hijuelas La Higuera · v1

**Fecha:** 2026-05-31
**Corrección doctrinal autorizada por Max:** El objeto NO es "predio >1 ha" aislado · ES `unidad_territorial_historica` con matriz + hijuelas + servidumbres + corredor lineal + mutaciones SII + cadena CBR + validación RTK.
**Alcance:** reconstruir el relato territorial completo desde la merced de tierras 1822 → matriz Jarpa 1988 → 3 hijuelas → titulares actuales → servidumbres → corredor lineal Andes Iron → Totoralillo.

---

## 1. La matriz · Estancia La Higuera

```yaml
ESTANCIA_LA_HIGUERA:
  origen_remoto: merced de tierras de 1822 (referencia EXCLUSIVA_HIJUELA1)
  
  saneamiento_DL_2.695_1979:
    resolucion_SEREMI_BBNN_IV: 87-102 (10-ene-1990)
    expediente: 880972-6
    plano_oficial: IV-1-1777-S.R. (Bienes Nacionales IV Región · 1988)
    superficie_total_matriz: 6.918 ha
    
  saneamiento_NO_cadena_tradicional:
    base: posesión material acreditada ante SEREMI BBNN
    plazo_DL_Art_15: vencido 1991 · plenamente saneado
    
  3_hijuelas_originales (Plano IV-1-1777-S.R. tabla solicitantes):
    H1: Pablo Jarpa Díaz de Valdés        · Lote a 620 + Lote b 1.519 = 2.139 ha
    H2: Luis Emilio Jarpa Díaz de Valdés  · Lote a 1.163 + Lote b 1.479 = 2.642 ha
    H3: Patricio Joaquín Jarpa Díaz de Valdés · Lote a 910 + Lote b 1.227 = 2.137 ha
  
  exclusiones_dentro_del_plano (296.26 ha · 13 puntos A-M):
    A_Adaros_Zepeda: 1.5 ha
    B_Aquea_Molina (cabrero): 0.5 ha
    C_Gahona (minero): 1.5 ha
    D_Oscar_Gonzalez_Planta_Minera: 6.0 ha
    E_Municipalidad_LH_Cementerio: 1.19 ha
    F-K_cabreros_y_mineros_menores: ~3.5 ha
    I_VARIOS_Limite_Urbano: 115 ha
    L_El_Molle_Ugarte_Brito_Cia_Minera_Porvenir: 150 ha
    M_Municipalidad_LH_Plano_IV-1-881-SR: 18.12 ha
  
  requirente_formal_inscripcion: Empresa Heraclio Velásquez (Empresa de ingeniería geomensora)
  ingeniero: Juan García V.
```

---

## 2. Las 3 hijuelas hoy · estado dominical y catastral

### 2.1 · Hijuela 1 · GARCÍA HUIDOBRO

```yaml
HIJUELA_1_GARCIA_HUIDOBRO:
  titular_actual: Felipe García Huidobro Sanfuentes
  origen_documental: EXCLUSIVA_ESTANCIA_LA_HIGUERA_HIJUELA1_GARCIA_HUIDOBRO_2026.docx (13-mar-2026)
  estatus_mandato: BORRADOR · NO FIRMADO (corrección Max 2026-05-31)
  asesoria_inmobiliaria_destinataria: Xpert Urban SpA
  
  composicion_catastral:
    rol_24-42: 566.46 ha (centroide -71.2457, -29.4912)
    rol_24-43: 2 polígonos · 1.524.90 ha (centroides -71.1674, -29.5108 + -71.2166, -29.5011)
    total_KMZ_06: 2.091.36 ha
  
  superficie_declarada_mandato: 2.139 ha
  diferencia: 48 ha (2.2%) · CONCORDANCIA ALTA
  
  ultima_transaccion_SII: 26-nov-2001 · UF 1.384 (ambos lotes A y B)
  fuente_SII: HousePricing 12-mar-2026
  
  cadena_origen:
    Pablo_Jarpa_Diaz_Valdes_1990 → ¿transferencias 1990-2001? → García_Huidobro
  
  conflictos: pendiente estudio títulos 20 años · diligencia CBR La Serena
  
  estado_titularidad_García_Huidobro: CONFIRMADO_documental (titular según SII según mandato)
  estado_mandato_Magnus_XPU: BORRADOR_no_firmado · sin compromiso vinculante con propietario
  tier: 1
  
  clasificacion_suelos: secano no arable (clases 6 y 7) · zona semiárida
  uso_actual: agrícola-ganadero extensivo
```

### 2.2 · Hijuela 2 · COMINETTI

```yaml
HIJUELA_2_COMINETTI:
  titular_actual: Silvia María Cominetti Infanti (C.I. 7.011.575-1) + herederos
  mandato_Magnus: Repertorio 24.327 (14-abr-2026) Inversiones Magnus SpA
  
  composicion_catastral:
    rol_24-123: 2 polígonos · 1.399.93 + 901.71 = 2.301.64 ha (Resto Lotes A+B post-mutación)
    rol_24-160: 1 polígono · 299.18 ha (Lote C)
    total_KMZ_06: 2.600.82 ha
    
  alias_historicos:
    24-48 → 24-123 (mutación catastral SII post-2017)
    24-4 → 24-160 (mutación catastral SII post-2017)
  
  superficie_canonica_operativa: 2.139.35 ha (Resto A + Resto B + Lote C · validado RTK Daniel 2026)
  diferencia_catastral_vs_canonica: +461 ha (catastro SII supera canon dominical)
  diferencia_matriz_vs_canonica: -503 ha (matriz 2.642 menos canon 2.139)
  
  brecha_503_ha_explicada_parcialmente:
    (i) expropiaciones MOP Ruta 5 (2013-2017 · 8 lotes 319, 320, 331-1, 331-3, 333, 334, 335, 338-1)
    (ii) transferencia Heraclio Humberto Velásquez Gallardo (deslinde sur Lote b · franja 3.465 m)
    (iii) fragmentación Cofanti (liquidación 2016-2017)
    (iv) rectificaciones planimétricas
  
  cadena_completa:
    1988: Plano IV-1-1777-S.R. (2.642 ha)
    10-ene-1990: Resolución saneamiento SEREMI BBNN N°87-102
    24-ene-1990: Inscripción matriz fs. 97 N°91 / 1990 CBR La Serena (Luis Emilio Jarpa)
    1992: Transferencia Lote A · fs. 4.531 / 1992 · adquirente PENDIENTE
    1994: Constitución servidumbre 924-644 · titular sirviente/dominante PENDIENTE
    1996: Transferencia Resto · fs. 1.813 / 1996 · adquirente PENDIENTE
    2011: Resoluciones MOP N°1.972 y N°2.051 (Min. Laurence Golborne) Ruta 5 La Serena-Vallenar
    2013-2017: 8 inscripciones Fisco (Lotes 319, 320, 331-1, 331-3, 333, 334, 335, 338-1)
    2014: Servidumbre InterChile Maitencillo-Pan de Azúcar 2x500 kV (PES_020 Lote C + PES_021 Resto · Torres T280-T288 · Rodrigo Sánchez)
    2014: Inversiones Cofanti Limitada titular registral · fs. 5.023 N°3.613 / 2014
    19-dic-2016: Escritura disolución Cofanti · Notario Pedro Reveco Hormazábal · Rep 25.963 · 19ª Notaría Stgo
    20-ene-2017: Rectificación · Notaria Valeria Ronchera Flores
    06-ene-2017: Publicación Diario Oficial N°41.651
    24-feb-2017: Adjudicación Silvia M. Cominetti · 25% del Resto · Rep FS 694 N°26.309 · CLP $6.976.080
    2025: Servidumbre Andes Iron Sector Lineal · vinculante diciembre 2025 (capa QGIS verificada)
  
  estado_titularidad: CONFIRMADO_canon
  tier: 1
```

### 2.3 · Hijuela 3 · PATRICIO JOAQUÍN JARPA → ¿FINDEL?

```yaml
HIJUELA_3:
  titular_origen_1990: Patricio Joaquín Jarpa Díaz de Valdés
  superficie_matriz: 2.137 ha (Lote a 910 + Lote b 1.227)
  inscripcion_origen: foja 95 N°89 / 1990 CBR La Serena (diligencia documental pendiente)
  
  titular_actual: NO CONSOLIDADO bajo único rol SII
  fragmentacion_documentada:
    Findel_Westermeier_Gerardo_Ernesto: 
      Lote_D_Punta_Colorada: 129 ha
      otros_lotes_menores: ~116 ha
      total_atribuido: 245 ha en 7 roles fragmentados
    pendiente_atribucion: ~1.600 ha
      Lotes_E-N_Estancia_El_Romero
      Estancia_Pozos_Jarilla (Felipe Balbontín · CBR plano 275 año 2000 · 28.6 ha en 4 roles)
      Punta_Colorada_urbano
  
  estado_titularidad: FRAGMENTADO_pendiente_consolidacion
  tier: 2
  
  diligencia_critica:
    consulta_CBR_La_Serena_foja_95_N89_1990: pendiente
    output_esperado: identificar cadena 1990-2001 + adquirentes
```

---

## 3. Servidumbres conocidas sobre Hijuela 2 · cadena temporal

```yaml
servidumbres_documentadas_H2:
  
  1994_S_924-644:
    nombre: Servidumbre histórica 924-644
    año: 1994
    fuente: nota marginal inscripción matriz 1990
    titular_sirviente: H2 Jarpa
    titular_dominante: PENDIENTE individualizar
    estado: vigente · sin pérdida de superficie · grava dominio
    relevancia: pieza del rompecabezas predial 1990-2014
  
  2011_2017_S_FISCO_MOP_RUTA5:
    nombre: Expropiaciones fiscales Ruta 5 Norte La Serena-Vallenar
    resoluciones: MOP N°1.972 + N°2.051 (agosto 2011)
    firmante: Ministro Laurence Golborne Riveros
    inscripciones: 2013-2017 · 8 lotes (319, 320, 331-1, 331-3, 333, 334, 335, 338-1)
    titular_dominante: Fisco de Chile
    superficie_perdida: PENDIENTE geometrización QGIS (componente principal de la brecha 503 ha)
    estado: consumada · dominio Fisco
  
  2014_S_INTERCHILE:
    nombre: Servidumbre InterChile Maitencillo-Pan de Azúcar 2x500 kV
    año: 2014
    planos: PES_020 (Lote C) + PES_021 (Resto Hijuela 2)
    titular_dominante: InterChile S.A.
    contacto: Rodrigo Sánchez
    obras_superficiales: Torres T280 a T288 (9 torres)
    estado: vigente · canon pagado · documentación completa
  
  2025_S_ANDES_IRON_SECTOR_LINEAL:
    nombre: Servidumbre Sector Lineal Proyecto Dominga
    fecha_vinculante: diciembre 2025
    titular_dominante: Andes Iron SpA (RCA N°161/2021)
    naturaleza: 4 capas superpuestas:
      - acueducto subterráneo (Totoralillo → Dominga)
      - concentraducto subterráneo (Dominga → Totoralillo)
      - línea transmisión 66 kV superficial
      - camino de servicio superficial
    obras_complementarias_superficie:
      - estaciones de bombeo concentraducto + acueducto
      - estaciones de disipación de energía
      - piscinas de emergencia para contención de derrames
      - sistema detección de fugas con monitoreo remoto
    estado_documental: capa QGIS verificada · falta firma · negociación abierta en mesa
    artefacto_perdido: andes_iron.geojson (referenciado en 4 .qgz · ausente en data room)
```

---

## 4. CORREDOR LINEAL ANDES IRON · prioridad crítica (Max)

```yaml
SECTOR_LINEAL_DOMINGA:
  fuente_primaria: 
    - EIA Dominga 2013 (Anexo DP-2 · A-104 Layout Sector Lineal Rev 0)
    - MEMO_EIA_Dominga_Sector_Lineal_Mesa_Andes (mayo 2026)
    - XPU_Analisis_EIA_Dominga_Sector_Lineal.pdf
    - documentación Fluor diciembre 2025
  
  geometria:
    longitud_total: 26 km
    tramo_paralelo_Ruta_5: 14 km
    superficie: 160 ha aproximadamente
    franja_ancho: ~50 m
    extremos:
      origen: Sector Dominga (mina + planta procesamiento)
      destino: Sector Totoralillo (terminal de embarque)
  
  trazado_funcional:
    minimiza interferencias topográficas + infraestructura + impacto entorno
    privilegia áreas ya intervenidas
    sigue camino de servicio + concentraducto + acueductos + línea 66 kV
  
  predios_que_cruza (HIPÓTESIS pendiente cruce QGIS):
    eje_norte_sur:
      Sector_Dominga (matriz Andes Iron 24-5 / predio fiscal 2007 · C13)
      ↓
      predios_macro_fiscales hipotéticos (80-0 + 79-1)
      ↓
      Hijuela_3_fragmentada (Findel + pendientes)
      ↓
      Hijuela_2_Cominetti (servidumbre 4 capas)
      ↓
      Hijuela_1_García_Huidobro (servidumbre "bastante avanzada" NO firmada)
      ↓
      paralelo_Ruta_5 (14 km)
      ↓
      Totoralillo (Sector Totoralillo Norte · predio fiscal fs.4856 N°4411/2007 · C13)
  
  choke_point_regulatorio_critico:
    Permiso Ambiental Sectorial Art 96 Reglamento SEIA
    requiere cambio de uso de suelo en terreno rural
    NO se otorga sin consentimiento del propietario
    consecuencia: cada hijuela es punto de bloqueo soberano
  
  vacios_estructurales_EIA_2013:
    (i) cero menciones de Cominetti o propietarios privados de la franja
    (ii) cero acuerdos vinculantes registrados bajo Art 13 bis Ley 19.300
    (iii) levantamientos ambientales/patrimoniales incompletos en corredor (vs Sector Dominga acabado)
  
  vida_util_proyecto: 26.5 años
  inversion_total: USD 2.500 millones
  trabajadores_pico_construccion: 9.800
```

---

## 5. Mapa de poder territorial del corredor · síntesis XPU Mayo 2026

```yaml
EJE_PROPIETARIOS_PRIVADOS_PAÑO_GRANDE:
  Garcia_Huidobro_Sanfuentes_Felipe: 2.139 ha (H1)
  Cominetti_Infanti_y_herederos: 2.940 ha (H2 + adicional)
  Findel_Westermeier_Gerardo: ~245 ha en 7 roles fragmentados (H3 parcial)
  subtotal: 5.324 ha

EJE_MINERO_INDUSTRIAL_HISTORICO:
  CMP_Compañia_Minera_Pacifico:
    inscripcion: 1982 (fajas costeras + parte Estancia La Higuera)
    superficie: ~968 ha agregadas
      126 ha Chungungo
      841 ha parte estancia (item 8 archivo histórico · sin inscripción documentada en el doc XPU)
      Totoralillo
    estado: propietario superficial silencioso · contraparte obligada Andes Iron · NO en mesa Magnus
  
  Andes_Iron_SpA:
    matriz_predio_RCA_161_2021: rol canon 24-5 (NO en KMZ-06 · refuerza doctrina rol-sii)
    cadena: 1986 Cía Minera Santa Dominga → Aristía → Agua Grande / El Tofo (2007) → Compañía Minera Nevada (2016) → Andes Iron SpA (2021 · Rep FS 313 N°14.461 · UF 273.292)

EJE_FISCAL_Y_MILITAR:
  Fisco_de_Chile: 
    expropiaciones_Ruta_5 (2013-2017 · 8 lotes H2)
    macro-bloques hipotéticos (80-0 · 79-1 · 1075-1 = 192.194 ha · 46% comuna)
    Sector_Totoralillo_Norte (fs.4856 N°4411/2007 · ESC-GT-000011 · C13 abierto)
  
  Armada_de_Chile:
    Rol 30-5 Cruz Grande (parte Santuario DS N°33/2023 MMA)
  
  Municipalidad_La_Higuera:
    Cementerio 1.19 ha (exclusión E Plano MBN)
    18.12 ha plano IV-1-881-SR (exclusión M)
  
  Reservas_pueblos_originarios:
    Quebrada Honda
    Los Choros
```

---

## 6. Estructura Magnus en el corredor · disciplina HECHO/INFERENCIA/BLOQUEADO

```yaml
ACTIVOS_BAJO_MANDATO_FIRMADO_Magnus:
  
  Hijuela_2_Cominetti:
    estatus: FIRMADO_vigente
    instrumento: Repertorio 24.327 (14-abr-2026)
    titular_mandante: Silvia María Cominetti Infanti
    superficie_operativa: 2.139 ha
    estado: vigente · exclusiva en marcha
    
  total_firmado: 2.139 ha (H2 únicamente)

ACTIVOS_EN_BORRADOR_NO_FIRMADO_Magnus_XPU:
  
  Hijuela_1_Garcia_Huidobro:
    estatus: BORRADOR · NO FIRMADO (corrección Max 2026-05-31)
    documento: EXCLUSIVA_ESTANCIA_LA_HIGUERA_HIJUELA1_GARCIA_HUIDOBRO_2026.docx (13-mar-2026)
    asesoria_destinataria: Xpert Urban SpA
    titular_propietario: Felipe García Huidobro Sanfuentes
    superficie_potencial: 2.139 ha
    estado_juridico: SIN_COMPROMISO_VINCULANTE · sin instrumento firmado
    
  total_no_firmado: 2.139 ha (H1 potencial)

LECTURA_DISCIPLINADA:
  HECHO: Magnus controla exclusiva firmada sobre 2.139 ha (Cominetti H2)
  HIPÓTESIS: Magnus/XPU podría controlar 4.278 ha si H1 se firma
  BLOQUEADO: 
    timing y precio de firma H1 con García Huidobro
    si García Huidobro firmará con XPU/Magnus o con Andes Iron primero
    si las condiciones del borrador serán aceptadas por el propietario
  
  posición_negociadora_actual:
    H1: SIN exclusiva firmada · cliente externo libre de comprometerse con tercero
    H2: CON exclusiva firmada · solo activo blindado de Magnus
    leverage_sobre_corredor_lineal: REAL solo en H2 · potencial en H1

RIESGO_TACTICO_AGRAVADO_post_correccion_borrador:
  
  Andes_Iron_servidumbre_Garcia_Huidobro_BASTANTE_AVANZADA_no_firmada:
    fuente: declaración Sr. Bugueño (gerente Proyecto Dominga · mesa 5-may-2026)
    riesgo: García Huidobro firma servidumbre Andes Iron primero
    efecto_amplificado_por_borrador_no_firmado:
      Magnus NO tiene preferencia contractual sobre H1
      García Huidobro está libre de aceptar oferta Andes Iron sin pasar por Magnus
      la posición H2 queda como ancla solitaria del corredor
      el escenario "control 2 de 3 hijuelas" es HIPÓTESIS · NO realidad operacional
    mitigacion_priorizada:
      1. firmar exclusiva H1 con García Huidobro lo antes posible (antes que cierre con Andes Iron)
      2. revisar condiciones del borrador del 13-mar-2026 (¿por qué no se firmó?)
      3. preparar alternativa de coordinación H2-solo si H1 cae a Andes Iron
      4. cuantificar el costo de ancla baja sobre H2 si H1 firma primero
    no_celebrar_consolidacion_que_aun_no_existe

PIEZA_FALTANTE_HIJUELA_3:
  si Magnus consolida también H3 (Findel + pendientes 1.600 ha):
    control_de_3_hijuelas_de_3 → bloqueo soberano del corredor lineal
    diligencia_critica: identificar todos los lotes E-N El Romero + Pozos Jarilla + Punta Colorada urbano
```

---

## 7. Lo que falta cerrar (rankeado por valor estratégico)

```yaml
acciones_priorizadas_post_FaseD_v1:
  
  1_consulta_CBR_La_Serena_foja_95_N89_1990:
    objetivo: cerrar cadena dominical Hijuela 3 (Patricio Jarpa → ¿titulares actuales?)
    esfuerzo: 1 semana
    valor: muy alto · puede revelar Findel como adquirente único o constatar fragmentación
  
  2_consulta_CBR_servidumbre_924-644_1994:
    objetivo: identificar titular sirviente y dominante de servidumbre histórica
    esfuerzo: 1 semana
    valor: medio-alto · puede revelar predio dominante relevante (¿CMP? ¿InterChile precursora?)
  
  3_identificacion_predios_que_cruza_Sector_Lineal:
    objetivo: mapear los 26 km del trazado · qué polígonos catastrales toca
    fuente: A-104 Layout Sector Lineal + KMZ-06 + capa QGIS Andes Iron 2025
    esfuerzo: 4-8 hrs procesado QGIS
    valor: muy alto · responde "¿qué propietarios además de H1+H2 son afectados?"
  
  4_geometrizacion_503_ha_brecha_H2:
    objetivo: cuantificar exactamente las 8 expropiaciones MOP + transferencia Velásquez
    fuente: documentos MOP + plano IV-1-1777-SR + RTK Daniel 2026
    esfuerzo: 1 semana
    valor: alto · cierra el modelo dominical H2
  
  5_identificacion_geografica_El_Molle:
    objetivo: ubicar el predio Ugarte/Brito (150 ha · Cía Minera Porvenir) en KMZ-06
    fuente: deslinde sur H2 Lote b + Plano MBN exclusión L
    esfuerzo: 30 min cruce geográfico
    valor: medio · pieza del corredor histórico
  
  6_validacion_macro-fiscales_80-0_79-1_1075-1:
    objetivo: confirmar si son predios fiscales (192.194 ha = 46% comuna)
    fuente: oficio BBNN La Serena
    esfuerzo: 2 semanas
    valor: alto · define si Estado es contraparte clave en corredor
  
  7_RTK_Daniel_5_prioridades:
    objetivo: cerrar canon perímetro H2 + H1 + El Molle + Totoralillo + frontera cat5
    esfuerzo: 1-2 días campo
    valor: muy alto · valida toda la capa física
```

---

## 8. Disciplina HECHO / INFERENCIA / BLOQUEADO

```yaml
HECHOS_OBSERVADOS_canonizables_FaseD_v1:
  1. Estancia La Higuera matriz saneada DL 2.695 · Plano IV-1-1777-S.R. 1988 · 6.918 ha · 3 hijuelas Jarpa
  2. Hijuela 1 (2.139 ha mandato) = Roles 24-42 (566.46 ha) + 24-43 (1.524.90 ha) = 2.091.36 ha catastrales · concordancia 97.8%
  3. Hijuela 2 (2.139 ha canon RTK) = Roles 24-123 (2.301.64 ha) + 24-160 (299.18 ha) catastrales (con expropiaciones excluidas)
  4. Hijuela 3 (2.137 ha matriz) está fragmentada · titular único NO consolidado · Findel atribuido 245 ha
  5. Magnus tiene mandato FIRMADO sobre H2 (Rep 24.327 · 14-abr-2026). El documento H1 (XPU 13-mar-2026) es BORRADOR NO FIRMADO · sin compromiso vinculante de García Huidobro
  6. Sector Lineal Andes Iron: 26 km · 160 ha · 50 m ancho · 14 km paralelo Ruta 5 · 4 capas servidumbre
  7. Andes Iron tiene servidumbre H1 García Huidobro "bastante avanzada" NO firmada (declarado 5-may-2026)
  8. Vacios estructurales EIA Dominga 2013: cero menciones Cominetti · cero acuerdos Art 13 bis · levantamientos incompletos corredor
  9. Choke point regulatorio: PAS Art 96 Reglamento SEIA · cambio uso suelo rural requiere consentimiento propietario
  10. CMP es propietario superficial silencioso del corredor (~968 ha agregadas) · NO en mesa Magnus

INFERENCIAS_validas:
  1. Magnus tiene firmada solo H2 (2.139 ha) · H1 (2.139 ha) es POTENCIAL no consolidado
  2. Cada hijuela es punto de bloqueo soberano del Sector Lineal · sin consentimiento no hay PAS Art 96
  3. La servidumbre H1 "bastante avanzada" es riesgo táctico AGRAVADO por la ausencia de exclusiva Magnus firmada · García Huidobro puede firmar con Andes Iron sin obligación previa con XPU
  4. Sin H1 firmada + sin H3 consolidada, Magnus tiene UN ancla (H2) del corredor · no dos · no tres
  5. CMP es contraparte obligada · su silencio en la mesa es información operacional

BLOQUEADOS:
  1. Titular actual definitivo Hijuela 3 (Findel + 1.600 ha sin atribuir)
  2. Titular sirviente/dominante servidumbre 924-644 (1994)
  3. Trazado exacto del Sector Lineal sobre KMZ-06 (artefacto andes_iron.geojson perdido)
  4. Predios fiscales validados (oficio BBNN pendiente)
  5. El Molle rol SII identificado (cruce geográfico pendiente)
  6. Cadena dominical Heraclio Velásquez Gallardo (Empresa requirente 1990 vs adquirente 2017?)

ACCIONES_DE_DESBLOQUEO_ranked: ver §7 con valor estratégico
```

---

## 9. Frase de cierre canónica

```yaml
Fase_D_v1_resuelve:
  identidad_titulares_3_hijuelas:
    H1: García Huidobro CONFIRMADO_documental_como_titular_SII (2.139 ha) · mandato XPU en BORRADOR sin firmar
    H2: Cominetti CONFIRMADO_canon + mandato Magnus FIRMADO (Rep 24.327 · 2.139 ha)
    H3: parcialmente Findel (245 ha) + 1.600 ha sin atribuir + sin mandato Magnus
  
  mapa_servidumbres_H2:
    924-644 (1994) + InterChile (2014) + Fisco MOP (2011-2017) + Andes Iron (2025)
  
  geometria_Sector_Lineal:
    26 km · 160 ha · 50 m ancho · 4 capas · vida útil 26.5 años
  
  posicion_Magnus_corredor:
    control firmado sobre 1/3 hijuelas históricas (H2 Cominetti)
    control potencial sobre 2/3 si H1 se firma (mandato XPU en borrador)
    leverage soberano sobre PAS Art 96 efectivo SOLO en H2
    riesgo táctico AGRAVADO: servidumbre H1 Andes Iron "bastante avanzada" + mandato Magnus H1 no firmado = García Huidobro puede firmar con Andes Iron sin obligación previa hacia XPU

Fase_D_v1_no_resuelve:
  trazado_exacto_Sector_Lineal_sobre_predios_KMZ_06
  titulares_Hijuela_3 completos
  servidumbre 924-644 (1994) sirviente/dominante
  predios fiscales validados con BBNN
  El Molle rol SII identificado
```

---

**Linkado:**
- [[CANON_HIJUELA2_v2]]
- [[CADENA_REGISTRAL_HIJUELA_2]] (canon)
- [[INVENTARIO_PREDIOS_MAYORES_1HA_v1]]
- [[EXCLUSIVA_ESTANCIA_LA_HIGUERA_HIJUELA1_GARCIA_HUIDOBRO_2026]]
- [[MEMO_EIA_Dominga_Sector_Lineal_Mesa_Andes]]
- [[XPU_Informe_Terratenientes_La_Higuera]]
- [[XPU_Analisis_EIA_Dominga_Sector_Lineal]]
- [[doctrina-rol-sii-no-es-identidad-territorial]]
- [[doctrina-no-derivar-estrategia-sin-capa-ocupacion]]
- [[doctrina-unidad-territorial-estratificada]]
- [[C13-predio-fiscal-vs-rol-24-5]]
- [[proyecto-hijuela-2-cominetti]]
- [[evt-h2-occupation-baseline-20260531]]
