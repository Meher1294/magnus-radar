# Módulo Magnus Radar/ITS · Caso H2 Tomas y Divergencia Territorial · v1

**Disparador:** Custodio autorizó elevar el caso a módulo del visor con estado `inteligencia_operacional_activa`
**Naturaleza:** NO es verdad catastral final · es síntesis multi-capa de un caso vivo
**Disciplina obligatoria:** mostrar SII / CBR / Daniel RTK sin colapsarlas en una sola afirmación

---

## 0 · Estado canónico del caso

```yaml
caso:
  id: H2_TOMAS_DIVERGENCIA
  nombre: "Caso H2 Tomas y Divergencia Territorial"
  estado: inteligencia_operacional_activa
  fecha_baseline: 2026-05-31
  unidad_territorial: hijuela_2_cominetti
  custodio: Max Medina (Magnus SpA / XPU)
  NO_es: verdad_catastral_final
  SI_es: sintesis_multicapa_para_decision_operacional
```

---

## 1 · Tres capas separadas (regla no negociable)

El módulo **debe mostrar las 3 capas de forma independiente** y **NUNCA colapsarlas en una sola afirmación**.

### 1.1 · Capa SII (catastral)

```yaml
SII:
  representacion: catastral_administrativa
  fuente_canonica: KMZ-06 La_Higuera_UTF8.kmz (catastro municipal vectorial)
  
  para_la_zona_H2:
    rol_24_123:
      denominacion: "Est. La Higuera Hj 2, Lotes A y B"
      superficie_SII: 2.640,93 ha
      titular_SII: "Lidia Rosa Victoria Cominetti In y otros"
      poligono_vectorial: si
    
    rol_24_160:
      denominacion: "Est La Higuera Hj 2 Lt C"
      superficie_SII: 300,00 ha
      poligono_vectorial: si
    
    rol_24_5:
      denominacion: "Estancia La Higuera matriz pre-Agua Grande"
      titular_administrativo: "Andes Iron SpA"
      poligono_vectorial: NO_DISPONIBLE_en_KMZ_06
      observacion: rol_administrativo_vigente_sin_polígono_discreto
    
    rol_0_0:
      poligonos_en_la_zona: 72_fragmentos
      superficie_zona_ortofoto: 89.80 ha
      titular_SII: null
      etiqueta_canonica: sin_individualizar
  
  conflictos_internos_capa_SII:
    C11: rol_historico_24_48_vs_actual_24_123 (pendiente)
    C7: superficie_SII_2940_vs_juridica_2139 (pendiente)
```

### 1.2 · Capa CBR (jurídica · estudio títulos consolidado + due diligence)

```yaml
CBR_juridica:
  representacion: dominio_inscripciones_titulares
  fuente_canonica:
    - CADENA_REGISTRAL_HIJUELA_2.md (canon)
    - DUE_DILIGENCE_INTEGRAL_ESTANCIA_LA_HIGUERA_2026.docx
    - ESTUDIO_TITULOS_HIJUELA2_ESTANCIA_LA_HIGUERA.docx (marzo 2026)
  
  para_la_zona_H2:
    
    titulares_actuales_Hijuela_2:
      cuotas:
        - Silvia María Cominetti Infanti · 18.75% · RUT 7.011.575-1
        - Claudia Cecilia Cominetti Infanti · 18.75% · RUT 7.011.576-K
        - Lidia Rosa Victoria Cominetti Infanti · 18.75% · RUT 6.349.740-1
        - Sucesión Bruno G. Cominetti Infanti · 18.75% · fallecido (a verificar C2)
        - Agrícola Cantera Limitada · 25.00% · dación en pago 23-ene-2023
      estado_comunidad: NO_LIQUIDADA
    
    cadena_dominio_canonizada:
      1990: Luis Emilio Jarpa Díaz de Valdés (saneamiento DL 2695 · fs.97 N°91/1990)
      ???: Bruno Luigi Cominetti Palini (transferencia · gap documental)
      1996: Bruno Luigi + Virginia Castillo 85/15 (compraventa madre fs.1994 N°1813)
      2014: Inversiones Cofanti Limitada (fs.5023 N°3613)
      2017: Adjudicación 4 hermanas/sucesión Cominetti Infanti
      2022: Posesión efectiva Bruno Luigi (28-dic-2022)
      2023: Dación pago a Cantera (23-ene)
      2026: Mandato exclusivo Magnus (Rep 24.327 · 14-abr-2026)
    
    tomas_segun_due_diligence:
      ubicacion_juridica: "SOBRE terreno Cominetti"
      familias_estimadas: 87-120
      superficie_aproximada: ~300 ha
      origen_administrativo: "oficina_saneamiento_informal_Moran_2010_2022"
      fuente: reunion_Alcaldesa_Uberlinda_Aquea_20_abr_2026
    
    matriz_envolvente_segun_canon:
      rol_24_5: "Estancia La Higuera matriz · Andes Iron SpA"
      adquisicion: Rep FS 313 N°14.461 / 16-ago-2021
      precio: UF 273.292,2657
      superficie_canon: ~60.000 ha (NO_respaldada_por_due_diligence)
      observacion: hijuelas_son_enclaves_dentro_del_rol_24_5

  conflictos_internos_capa_CBR:
    C1: Bruno Luigi Cominetti · estado vital (CRITICO)
    C2: Bruno Guillermo Cominetti Infanti · estado vital (CRITICO)
    C5: Naturaleza 924-644/1994 (servidumbre vs transferencia)
    C9_resuelto: Eslabón 1996 ✓
```

### 1.3 · Capa Daniel RTK (física operacional)

```yaml
Daniel_RTK:
  representacion: fisica_operacional
  fuente_canonica: PERIMETRO_CBR_DANIEL_RTK10M_V1_UTM19S_FIX.gpkg
  custodio_fisico: Daniel Martínez Zurita · C.I. 14.387.985-2
  precision_metros: 10
  
  para_la_zona_H2:
    superficie_RTK_medida: 2.164,97 ha
    polígono_vectorial: si
    bbox_WGS84: (-71.279, -29.537) a (-71.143, -29.488)
    monolitos_en_terreno: validados
    
    overlap_con_bbox_ortofoto_2026_05:
      superficie: 272 ha (12.6% del predio RTK)
      cuadrantes_categoria_5_dentro:
        Q10: 47.2% dentro
        Q20: 53.6% dentro
        Q21: 34.1% dentro
        Q11: 0.0% dentro (fuera)
```

---

## 2 · Divergencia entre las 3 capas (lo que el módulo debe mostrar EXPLÍCITAMENTE)

```yaml
divergencia_dimensional_total:
  SII:        2.940,93 ha (24-123 + 24-160)
  CBR:        2.139,35 ha (estudio títulos consolidado 2017)
  Mandato:    1.800 ha    (declaración Magnus · con cláusula excedente)
  Daniel_RTK: 2.164,97 ha (medición física)
  rango_de_incertidumbre: 1.140,93 ha

divergencia_posicional_del_asentamiento_observado_cat_5:
  superficie_total_observada: 22,63 ha
  
  cae_en_SII_24_123_canonico: 0,00 ha  (0%)
  cae_en_SII_24_160_canonico: 0,00 ha  (0%)
  cae_en_SII_24_5_Andes_Iron: NO_MEDIBLE_sin_polígono_vectorial
  cae_en_SII_0_0_no_individualizado: 15,59 ha (68.9%)
  cae_en_otros_roles_SII_menores: 7,04 ha (31.1%)
  
  cae_juridicamente_en_terreno_Cominetti_segun_due_diligence: HIPOTESIS_DUE_DILIGENCE (~300 ha total tomas)
  
  cae_fisicamente_en_perimetro_Daniel_RTK_Cominetti: parcialmente
    Q10: 47.2%
    Q20: 53.6%
    Q21: 34.1%
    Q11: 0%
```

**El visor debe permitir al usuario VER LAS 3 RESPUESTAS al mismo tiempo.** Cualquier intento de "una sola verdad" sería contaminación.

---

## 3 · Diseño funcional del módulo (especificación · NO código)

### 3.1 · Ubicación en Magnus Radar

```yaml
ubicacion_propuesta:
  panel_lateral: pestaña_dedicada
  posicion: tras_pestañas_Resumen_Geometrias_Superficies_Conflictos
  nombre_pestaña: "Caso H2 · Tomas y Divergencia"
  badge_advertencia: "inteligencia operacional activa · NO verdad catastral"
```

### 3.2 · Contenido visible

```yaml
seccion_1_resumen_estado:
  banner: "Caso activo · 87-120 familias · ~300 ha · divergencia documentada"
  estado_epistemico: inteligencia_operacional_activa
  
seccion_2_las_3_capas_separadas:
  tres_tabs_internos:
    - SII (catastral)
    - CBR (jurídica · estudio títulos + due diligence)
    - Daniel RTK (física operacional)
  
  cada_tab_muestra:
    - polígonos vectoriales (cuando disponibles)
    - lista de titulares declarados
    - superficie según la capa
    - conflictos internos de la capa
    - última fecha de actualización
    
seccion_3_divergencia_explicita:
  tabla_comparativa: 
    columnas: [SII, CBR, Daniel_RTK]
    filas: [superficie_total, titular_principal, polígono_disponible, conflictos_internos]
  
  alerta_canonica: "Ninguna capa tiene autoridad final sobre las otras"
  
seccion_4_asentamiento_observado:
  baseline: EVT-H2-OCCUPATION-BASELINE-20260531
  resumen: "22.63 ha detectadas como asentamiento consolidado dentro del bbox ortofoto"
  link_al_geojson: ocupaciones_h2_v1.geojson
  link_al_mosaico: 05_mosaico_asentamiento_amplio.png
  
seccion_5_hipotesis_activas:
  lista_4_hipotesis_H1_H2_H3_H4:
    cada_una:
      enunciado
      estado: NO_DEMOSTRADA
      evidencia_actual
      via_de_validacion
      
seccion_6_backlog_visible:
  P2_7: 16_PDFs_Cominetti_Escritura_Escaneada
  P2_8: georreferenciar_plano_MBN_1988
  P2_9: consulta_SII_polígono_rol_24_5
  P3: validacion_terreno_Daniel_RTK
  
seccion_7_caveat_obligatorio:
  texto_visible:
    "Este módulo es síntesis multicapa para inteligencia operacional.
     NO sustituye estudios de títulos definitivos ni levantamiento RTK final.
     Ninguna afirmación de titularidad debe operacionalizarse sin
     validación CBR primaria + estudio de títulos resolutivo."
```

### 3.3 · Reglas de etiquetado

```yaml
para_rol_0_0_en_la_zona:
  etiqueta_visible: "sin individualizar"
  titular: null
  alerta: "titularidad actual no resuelta"
  caveat_adicional_si_dentro_RTK_Cominetti:
    "Due diligence integral sugiere titularidad Cominetti · pendiente CBR"
  caveat_adicional_si_fuera_RTK_pero_dentro_proxy_matriz:
    "Posiblemente rol 24-5 Andes Iron · pendiente confirmación geométrica"

para_rol_24_5:
  etiqueta_visible: "Estancia La Higuera matriz · Andes Iron SpA"
  caveat_obligatorio: "rol administrativo · sin polígono vectorial discreto"
  
para_nombre_Estancia_La_Higuera_a_secas:
  PROHIBIDO_USAR_SIN_CALIFICAR
  alerta: "este nombre refiere a 3 objetos territoriales distintos"
  exigir_indicar_cual:
    - matriz_Jarpa_1988_6918ha
    - rol_24_5_Andes_Iron_canon_60000ha
    - proxy_GPKG_564132ha
```

---

## 4 · Lo que NO debe hacer el módulo

```yaml
prohibido:
  - colapsar_3_capas_en_una_sola_afirmacion
  - afirmar_titularidad_de_los_0_0_sin_validacion
  - presentar_60000ha_como_HECHO_DOCUMENTAL (es canon · no respaldado por due diligence)
  - usar_proxy_GPKG_como_si_fuera_rol_24_5
  - decir_Estancia_La_Higuera_sin_calificar_la_fuente
  - presentar_HIPOTESIS_SD_01_Santa_Dominga_como_HECHO
  - inferir_que_el_asentamiento_es_problema_Andes_Iron_o_problema_Cominetti_unilateralmente
  - sustituir_estudio_titulos_resolutivo
```

---

## 5 · Estatus de implementación

```yaml
fase_actual: diseño_documental_only
codigo_modificado: NO
visor_runtime: PASS_pendiente (HARDENING_01+02 sin validar)
proxima_iteracion_codigo: requiere autorizacion_explícita_Custodio + PASS_runtime

bloqueadores_para_implementar:
  - PASS_runtime_HARDENING_01_y_02
  - autorización_Custodio_para_modificar_codigo
  - decisión_arquitectónica: ¿módulo o pestaña? ¿qué relación con Schema 0003 ITS?

backlog_intermedio_documental (no requiere código):
  - especificación_visual_mockup_textual: ✓ este documento
  - regla_etiquetado_rol_0_0: ✓ canonizada
  - regla_nomenclatura_Estancia_La_Higuera: ✓ canonizada en memoria
  - jerarquía_SII_CBR_Daniel_RTK: ✓ canonizada en memoria
```

---

## 6 · Relación con otros documentos canónicos

| Documento | Relación |
|---|---|
| CANON_HIJUELA2_v1.md | doctrina padre del caso |
| EVT-H2-OCCUPATION-BASELINE-20260531 | evento baseline del módulo |
| CRUCE_GEOMETRIA_ROL_SII_H2_v1.md | P1 · capa SII parcial |
| P2_1_TITULARIDAD_ROLES_DOMINANTES_v1.md | P2.1 · capa CBR parcial |
| P2_3_FALSAR_H1_CRUCE_00_VS_MATRIZ_v1.md | P2.3 · falsable matriz |
| P2_4_POLIGONO_REAL_ROL_24_5_v1.md | P2.4 · busqueda polígono |
| P2_5_LECTURA_ANDES_IRON_PERSONERIA_v1.md | P2.5 · descarte personería |
| P2_6_SINTESIS_JURIDICA_INTERNA_v1.md | P2.6 · cadena rol 24-5 reconstruida |
| INGESTA_ORTOFOTO_H2_ITS_v1.md | datos del asentamiento detectado |
| INGESTA_PLANILLA_SOCIOECONOMICA_LA_HIGUERA_ITS_v1.md | capa social complementaria |

---

## 7 · Resumen ejecutivo para tablero

```yaml
modulo_Caso_H2_Tomas_y_Divergencia_Territorial:
  estado_actual: diseño_documental_v1
  proximo_paso_codigo: bloqueado_por_PASS_runtime
  proximo_paso_documental: P2_7_lectura_16_PDFs_Cominetti
  
  inteligencia_operacional_disponible:
    - 4_hipotesis_activas_no_demostradas
    - cadena_dominio_Hijuela_2_completa_con_2_gaps
    - cadena_dominio_rol_24_5_reconstruida_con_2_gaps
    - 22.63_ha_asentamiento_detectado_consolidado_baseline
    - 87_120_familias_segun_municipio (estimación reciente · revisable)
    - infraestructura_estatal_8072M_documentada_sin_compensación
  
  divergencias_activas_explicitas:
    - SII vs CBR: ~800 ha
    - SII vs RTK:  ~776 ha
    - CBR vs RTK:    ~25 ha
    - asentamiento_físico_vs_catastro: 22.63 ha en 0-0
```
