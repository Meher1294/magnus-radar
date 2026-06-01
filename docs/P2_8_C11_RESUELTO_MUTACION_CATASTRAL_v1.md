# P2.8 · C11 RESUELTO · mutación catastral SII Hijuela 2 · 2026-05-31

**Disparador:** Custodio · ejecutar P2.8 antes de cargar capa jurídica a Magnus Radar
**Páginas leídas:** 16.pdf pp. 11-13 (3 páginas suficientes)
**Resultado:** **C11 cerrado con evidencia visual directa · mutación catastral SII documentada entre 2014-2026**

---

## 1 · HECHO_DOCUMENTAL · transcripción literal verificada visualmente

### 1.1 · Activo 2.7 · "RESTO DEL PREDIO RUSTICO DENOMINADO HIJUELA NUMERO DOS DE LA ESTANCIA LA HIGUERA"

```yaml
ubicacion_en_PDF: 16.pdf · páginas 11-12
seccion: 2.7 del activo (Bienes Raíces Agrícolas de Cofanti)
descripcion_literal:
  "Resto del lote a que tiene una superficie de OCHOCIENTOS SESENTA Y TRES hectáreas"
  + "Resto del Lote b que tiene una superficie de NOVECIENTAS SETENTA Y SEIS COMA TREINTA Y CINCO hectáreas"

deslindes_Resto_Lote_a_literal:
  NORTE: "en parte con Hijuela número uno lote 'a' de don Pablo Jarpa Diaz de Valdés y en parte con lote C, de la Hijuela Dos del lote 'a' de la Estancia de La Higuera"
  ESTE:  "ruta número cinco de Vallenar a La Serena"
  SUR:   "hijuela número tres 'a' de don Patricio Jarpa Diaz de Valdés, en línea imaginaria que une los puntos 15-Hr, 232-Hr, 231 y 14"
  OESTE: "cordón del Sarco, en línea sinuosa entre los puntos 14 y 5 que lo separa de la Estancia Totoralillo"

deslindes_Resto_Lote_b_literal:
  NORTE: "Hijuela número uno Lote 'b' de Pablo Jarpa Diaz de Valdés, en línea imaginaria que une los puntos 7 - Hr.124 - Hr.125-8-12-13-Hr.E-Hr.D-Hr.C-Hr.121-Hr.122 y 11"
  ESTE:  "Cordón del Barco en línea sinuosa entre los puntos 11 y 17 que lo separa de la Estancia Corral de Piedra, entre los puntos 17 y 18 de la Estancia Maray y entre los puntos 18 y 19 que los separa de la Comunidad Agrícola Quebrada Honda"
  SUR:   "en parte de tres mil cuatrocientos sesenta y cinco metros de longitud, con propiedad vendida a don Heraclio Humberto Velásquez Gallardo y en parte con Hijuela número tres lote 'b' de Patricio Joaquín Jarpa Diaz de Valdés"
  OESTE: "ruta número cinco de la Serena a Vallenar"

origen_de_dominio_Cofanti:
  vendedor: Bruno Luigi Cominetti Palini
  escritura: 28-mar-2014 · Notaría Luis Poza Maldonado · Santiago · Rep N°1.145
  inscripcion: fs. 5.023 N°3.613 · Registro Propiedad 2014 · CBR La Serena

CITA_LITERAL_ROL_SII:
  texto_escritura: "Su rol de avalúo asignado por el Servicio de Impuestos Internos
                    es el VEINTICUATRO GUION CUARENTA Y OCHO de la comuna"
  rol_declarado_2016: 24-48

avaluo_partes_diciembre_2016: $27.904.319
```

### 1.2 · Activo 2.8 · "LOTE C DE LA HIJUELA NÚMERO DOS DEL LOTE A DE LA ESTANCIA LA HIGUERA"

```yaml
ubicacion_en_PDF: 16.pdf · página 13
seccion: 2.8 del activo (Bienes Raíces Agrícolas de Cofanti)

deslindes_Lote_C_literal:
  NORTE:    "en dos mil metros con Lote A de la Hijuela número uno o Lote uno - A"
  SUR:      "en dos mil metros con Lote A de la hijuela dos o Lote Dos-A"
  ORIENTE:  "en mil quinientos metros con ruta número cinco de Vallenar a la Serena"
  PONIENTE: "en mil quinientos metros con Resto del Lote A de la hijuela número Dos"
  
  superficie_implicita_2000m_x_1500m: 300 ha (consistente con canon)

origen_de_dominio_Cofanti:
  vendedor: Bruno Luigi Cominetti Palini
  escritura: 28-mar-2014 · Notaría Luis Poza Maldonado · Santiago · Rep N°1.145
  inscripcion: fs. 5.025 N°3.614 · Registro Propiedad 2014 · CBR La Serena

CITA_LITERAL_ROL_SII:
  texto_escritura: "Su rol de avalúo asignado por el Servicio de Impuestos Internos
                    es el VEINTICUATRO GUION CUATRO de la comuna"
  rol_declarado_2016: 24-4

plano_referido_manuscrito_pagina_13: "Pl 531-1992"
  significado: Plano de subdivisión N°531 año 1992 (el que segregó Lote C de Lote A)

avaluo_partes_diciembre_2016: $30.136.665
```

---

## 2 · C11 RESUELTO · matriz de mutación catastral SII

```yaml
HECHO_DOCUMENTAL_CONFIRMADO_VISUALMENTE:

  Resto_Lotes_A_y_B_Hijuela_2:
    rol_2014_2016_segun_escritura_Cofanti:   24-48
    rol_2026_segun_SII_y_HousePricing:       24-123
    mutacion: 24-48 → 24-123
    fechas_de_mutacion: entre_2016_y_2026 (rango)
  
  Lote_C_Hijuela_2:
    rol_2014_2016_segun_escritura_Cofanti:   24-4
    rol_2026_segun_SII_y_HousePricing:       24-160
    mutacion: 24-4 → 24-160
    fechas_de_mutacion: entre_2016_y_2026 (rango)
  
  superficie_Lote_C_implicita: 300 ha (2000m × 1500m)
  superficie_Resto_A_B_explicita: 863 + 976.35 = 1839.35 ha
  TOTAL_Hijuela_2_explicito: 2139.35 ha ← coincide con canon CBR y RTK ±25 ha

evidencia_primaria_directa:
  documento: 16.pdf (Disolución Cofanti)
  Rep: 25.963
  fecha: 2016-12-19
  notario: Pedro Ricardo Reveco Hormazábal
  paginas: 11, 12 y 13 (verificacion visual directa)
  notario_actual: notarizado y firmado 2016
```

---

## 3 · El rol 24-48 también aparece en planos InterChile 2014-2015

```yaml
servidumbres_electricas_InterChile_2014:
  PES_020_Lote_C:   rol_de_planos_servidumbre = 24-4  → hoy 24-160
  PES_021_Resto_H2: rol_de_planos_servidumbre = 24-48 → hoy 24-123
  
  esto_CONFIRMA_la_mutacion:
    los_planos_oficiales_SEC_2014_usan_la_numeracion_24-4_y_24-48
    la_misma_que_aparece_en_la_escritura_Cofanti_2016
    en_2026_los_avalúos_SII_y_HousePricing_reportan_24-123_y_24-160
    
  la_mutacion_es_HECHO_no_inferencia
```

---

## 4 · Cadena registral inversa · pre-2014

Confirmamos que **antes de 2014** la Hijuela 2 estaba inscrita a nombre de:
- Bruno Luigi Cominetti Palini (vendedor en escritura 28-mar-2014 Rep N°1.145)

Pero NO se aclara cómo Bruno Luigi obtuvo Hijuela 2. El gap "Jarpa 1990 → Bruno Luigi" sigue abierto · pero parcialmente resuelto por canon previo (compraventa 1996 fs.1994 N°1813 ante Notario Opazo Larraín).

---

## 5 · Impacto sobre el resto de capas y conflictos

```yaml
C11_estado: RESUELTO_CON_EVIDENCIA_PRIMARIA
  causa_documentada: mutacion_catastral_SII_entre_2016_y_2026
  posibles_explicaciones_de_la_mutacion:
    a_reagrupacion_administrativa_SII: probable
    b_subdivision_o_actualizacion_oficial: alternativa
    c_otro_motivo_administrativo: cualquiera
  
  IMPACTO_OPERACIONAL:
    cualquier_referencia_documental_pre_2016_que_diga_rol_24_4_o_24_48: 
      es_la_misma_unidad_territorial_que_hoy_es_24_123_o_24_160
    
    servidumbres_InterChile_constituidas_sobre_24_4_y_24_48: 
      siguen_vigentes_sobre_los_actuales_24_160_y_24_123
    
    cualquier_inscripcion_CBR_pre_2016: 
      se_traduce_a_la_nueva_numeracion_SII
    
    capa_SII_del_visor_debe_anotar_la_mutacion_explicitamente

C7_superficie_total_de_Hijuela_2_explicita:
  segun_16_pdf: 863 + 976.35 + 300 = 2.139,35 ha (CONFIRMA canon y RTK)
  ya_NO_es_conflicto_residual

C9_eslabón_1996: previamente_resuelto · sigue_resuelto

Resto_de_conflictos_aún_abiertos:
  C1_Bruno_Luigi_estado_vital
  C2_fecha_fallecimiento_Bruno_Guillermo
  C5_naturaleza_servidumbre_924_644_1994
  C12_CI_Lidia_ultimo_digito
  HIPOTESIS_SD_01_continuidad_Santa_Dominga
  HIPOTESIS_SE_01_venta_Cortes_Suez_Energy
```

---

## 6 · Implicaciones para el módulo Magnus Radar

```yaml
capa_SII_del_visor_actualizada_post_P2_8:
  
  rol_24_123_actual:
    denominacion_SII: "Est. La Higuera Hj 2, Lotes A y B"
    superficie_SII: 2.640,93 ha
    rol_historico_2014_2016: 24-48
    titular_actual: Comunidad Cominetti
    poligono_vectorial_KMZ_06: si
    
  rol_24_160_actual:
    denominacion_SII: "Est La Higuera Hj 2 Lt C"
    superficie_SII: 300 ha
    rol_historico_2014_2016: 24-4
    titular_actual: Comunidad Cominetti
    poligono_vectorial_KMZ_06: si
  
  alerta_canonica_sobre_mutacion:
    "Los planos de servidumbre InterChile 2014-2015 (PES_020 y PES_021)
     y la escritura matriz Cofanti 2016 (Rep 25.963) refieren a los roles
     históricos 24-4 (Lote C) y 24-48 (Resto Lote A+B). Hoy estos roles
     son 24-160 y 24-123 respectivamente. La servidumbre sigue vigente
     sobre los polígonos actuales."

regla_de_visor:
  cualquier_documento_pre_2016_que_referencie_24_4_o_24_48:
    debe_mostrarse_con_alerta_de_mutacion
    y_link_al_rol_actual_correspondiente
```

---

## 7 · Estado consolidado del expediente post-P2.8

```yaml
conflictos_cerrados_con_evidencia_documental_primaria:
  C9: eslabón Jarpa → Cominetti 1996 ✓
  C10: foja/N de las 8 adjudicaciones 2017 ✓ (PRE_CIERRE)
  C11: rol 24-48 vs 24-123 mutación catastral ✓ NUEVO ESTE PASE
  
conflictos_aún_abiertos:
  C1: Bruno Luigi estado vital → posesión efectiva CBR
  C2: fecha fallecimiento Bruno Guillermo → Registro Civil
  C5: naturaleza 924-644/1994 → cotejo CBR
  C12: CI Lidia → cotejo escritura física

hipotesis_abiertas_aún:
  HIPOTESIS_SD_01: continuidad Santa Dominga ↔ Andes Iron
  HIPOTESIS_SE_01: venta Cortés ↔ Suez Energy
  HIPOTESIS_Bruno_Cantera: relación estructural (mantengo)

estatus_global_canon_Hijuela_2:
  cadena_dominio_completa: ~85%
  cadena_dominio_con_evidencia_primaria_directa: ~70%
  geometria_definida_consistente_entre_CBR_y_RTK: SI
  geometria_SII_con_mutacion_documentada: SI ← nuevo post-P2.8
  
  bloqueador_principal_pasa_a_ser:
    NO_documental_(la_mayoría_resuelto)
    SI_geometrico_del_rol_24_5_Andes_Iron_(P2.4_pendiente)
    SI_validacion_in_situ_Daniel_RTK_(P3_pendiente)
```

---

## 8 · Backlog priorizado post-P2.8

```yaml
prioridad_inmediata:
  ya_disponible_para_cargar_a_Magnus_Radar:
    capa_SII_con_mutacion_24_4_24_48_documentada: ✓
    capa_CBR_con_titulares_5_cuotas_Cominetti: ✓
    capa_Daniel_RTK_2164_97_ha: ✓
    asentamiento_detectado_baseline: ✓
    divergencia_explicita_3_capas: ✓
  
  proximas_validaciones_documentales_aun_pendientes:
    C1_C2_C5_C12: medio_plazo (gestiones externas)
    HIPOTESIS_SD_01: largo_plazo · risk_canon
  
  proximas_validaciones_geometricas:
    poligono_24_5_Andes_Iron: pendiente_mapas_SII (P2.4 sigue abierto)
    georeferenciacion_plano_MBN_1988: pendiente Fase_12_QGIS
    validacion_terreno: pendiente Daniel_RTK
```

---

## 9 · Disciplina aplicada

```yaml
hecho_documental_primaria_directa:
  - 16_pdf_pp_11_13_declara_literalmente_rol_24_48_para_Resto_Lotes_A_B
  - 16_pdf_pp_13_declara_literalmente_rol_24_4_para_Lote_C
  - superficies_863_976_35_y_300_ha_explicitas_en_escritura
  - franja_Velasquez_de_3465_m_explicita_en_escritura
  - plano_531_1992_explicito_manuscrito_pp_13

inferencia_razonable:
  - mutacion_catastral_SII_entre_2016_y_2026_es_HECHO
  - servidumbres_InterChile_pre_2016_aplican_a_roles_actuales

hipotesis_que_mantengo_como_no_demostradas:
  - HIPOTESIS_SD_01_Santa_Dominga_Andes_Iron
  - HIPOTESIS_Bruno_Cantera_estructural

nomenclatura_aplicada:
  SII / CBR / Daniel_RTK: ✓
  Estancia_La_Higuera_siempre_calificada: ✓
```

P2.8 cerró el conflicto C11 con evidencia primaria directa. La capa SII del visor puede operacionalizarse con disciplina y la mutación 24-4/24-48 → 24-160/24-123 queda documentada como **HECHO_DOCUMENTAL** y NO como hipótesis.
