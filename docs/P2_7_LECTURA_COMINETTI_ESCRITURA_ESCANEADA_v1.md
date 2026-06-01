# P2.7 · Lectura PDFs Cominetti_Escritura_Escaneada · 2026-05-31

**Disparador:** Custodio · resolver C11 (rol 24-48 vs 24-123) antes de polígono 24-5
**Inventario:** 13 PDFs (no 16) en `/01_LEGAL_TITULOS/Cominetti_Escritura_Escaneada/`
**Lectura ejecutada:** 16.pdf (parcial · páginas 1-10 + 14-18) + 36.pdf (páginas 1-3)
**Disciplina aplicada:** todo el resto del PDF 16.pdf (62 páginas totales) NO LEÍDO individualmente · se confía en el `PRE_CIERRE_CANON_v1_2.md` que ya extrajo los datos clave

---

## 1 · Inventario · 13 PDFs reales (no 16)

```yaml
Cominetti_Escritura_Escaneada:
  La Higuera DV Lote C derechos BCI.pdf      # adjudicación Bruno → Cantera Lote C
  La Higuera DV Lote C derechos SCI.pdf      # adjudicación Silvia Lote C  
  La Higuera DV Lote C derechos CCI.pdf      # adjudicación Claudia Lote C
  La Higuera DV Lote C derechos LCI.pdf      # adjudicación Lidia Lote C
  La Higuera Cantera Copia Inscripción 25% Lote C.pdf
  La Higuera DV Resto Lotes A y B derechos SCI.pdf
  La Higuera DV resto Lotes A y B derechos BCI.pdf
  La Higuera DV restos Lotes A y B derecgos CCI.pdf
  La Higuera DV resto Lotes A y B derechos LCI.pdf
  La Higuera Cantera Copia inscripción Resto Hijuela 2.pdf
  16.pdf                                      # ESCRITURA MATRIZ Disolución Cofanti
  36.pdf                                      # promesa CANTERA → BRUNO en COLINA
  Venta parcela 6 a BCI.pdf                   # NO LEÍDO

abreviaturas:
  SCI: Silvia María Cominetti Infanti
  CCI: Claudia Cecilia Cominetti Infanti
  LCI: Lidia Rosa Victoria Cominetti Infanti
  BCI: Bruno Guillermo Cominetti Infanti
  DV: "División" (de la sociedad)
```

---

## 2 · HALLAZGO confirmado de 16.pdf (10 páginas leídas)

```yaml
16.pdf_escritura_matriz:
  tipo: ESCRITURA DE DISOLUCION, LIQUIDACION Y ADJUDICACION
  sociedad_disuelta: INVERSIONES COFANTI LIMITADA
  rut_sociedad: 76.335.793-7
  fecha: 19 de diciembre de 2016
  notario: Pedro Ricardo Reveco Hormazábal · 19ª Notaría de Santiago
  repertorio: N° 25.963
  total_paginas_pdf: 62
  
  comparecientes_4_socios_al_25_pct:
    SCI:  Silvia María Cominetti Infanti · soltera · empresaria · 7.011.575-1
    CCI:  Claudia Cecilia Cominetti Infanti · divorciada · traductora · 7.011.576-K
    LCI:  Lidia Rosa Victoria Cominetti Infanti · casada · médico · 6.349.740-1
    BCI:  Bruno Guillermo Cominetti Infanti · divorciado · empresario · 7.011.574-3
    domicilio_comun: Matías Cousiño 82, of. 1207, Santiago RM
  
  constitucion_sociedad_Cofanti:
    fecha: 30-ago-2013 ante Notario Luis Poza Maldonado
    inscripcion: fs. 68.783 N°45.288 Reg. Comercio Santiago 2013
    publicacion_DO: 6-sep-2013
    
  modificaciones:
    13-mar-2014 ante Luis Poza Maldonado
    30-may-2014 saneamiento
  
  activos_de_Cofanti_segun_secciones_2_a_6:
    bienes_raices_agricolas:
      2.1: Parcela 13 Predio 22B Taqueral · LAMPA RM
      2.2: Parcela 1 sub Parcela 15 ex Fundo Lo Pinto · LAMPA RM
      2.3: Lote 1B Fundo Cuchi · CONSTITUCIÓN VII Región
      2.4: Lote 1A2 Fundo Cuchi · CONSTITUCIÓN
      2.5: Lote 1A3 Fundo Cuchi · CONSTITUCIÓN
      2.6: El Litral · Putú · CONSTITUCIÓN (30 cuadras)
      ... más predios (NO LEÍDOS individualmente)
      ... Hijuela 2 La Higuera está en alguna sección NO LEÍDA
    
    inmuebles_urbanos:
      3.x: Los Caracoles esq Las Machas · CALDERA · Atacama
      3.2: Sitio en Caldera
    
    pertenencias_mineras:
      4.1: SILVIA 3, 4, 5, 6, 7, 8 (Lampa · Chacabuco RM)
      4.2: LAMPA UNO 1-24 y LUIGI UNO 1-20 (Lampa)
    
    acciones_en_subsidiarias:
      5.1: 1.000 acc · AGRICOLA Y FORESTAL COFANTI NORTE SpA
      5.2: 1.000 acc · AGRICOLA Y FORESTAL COFANTI CENTRO SpA
      5.3: 1.000 acc · AGRICOLA Y FORESTAL COFANTI SUR SpA
    
  activos_total: $906.650.784
  
  contexto_canonico_previo: La Hijuela 2 La Higuera está entre los activos · pero
                            su sección específica con declaración del rol SII NO
                            se leyó en este pase (estaría entre pp. 11-13 o pp. 19+)
```

---

## 3 · HALLAZGO sobre 36.pdf · **CORRECCIÓN al reporte previo**

El reporte `PRE_CIERRE_CANON_v1_2.md` mencionaba:
> "Dación en pago 25% Bruno Guillermo → Agrícola Cantera Limitada · Rep. 68.661, 28-dic-2022"

**Pero 36.pdf NO corresponde a esa dación.** El 36.pdf es:

```yaml
36.pdf:
  tipo: PROMESA DE COMPRAVENTA
  partes:
    promitente_vendedora: AGRICOLA CANTERA LIMITADA · RUT 77.645.770-1
    representada_por: Silvia María Cominetti Infanti + Claudia Cecilia Cominetti Infanti
    promitente_compradora: BRUNO GUILLERMO COMINETTI INFANTI · RUT 7.011.574-3
  
  fecha: 26 de enero de 2017
  notario: Pedro Ricardo Reveco Hormazábal · 19ª Notaría Santiago
  repertorio: N° 1.845
  
  objeto:
    ubicacion: Comuna de Colina, Región Metropolitana
    proyecto: parcelación "La Cantera"
    parcelas: parcela 6 del plano · subdividida en 17 parcelas (1 a 17)
    superficie: NO_DETERMINADA_AUN_(pendiente_lectura_resto_PDF)
  
  hallazgo_clave:
    Bruno_Guillermo_estaba_vivo: SI · firmó esta promesa el 26-ene-2017
    Bruno_Guillermo_domicilio_al_2017: Camino La Vara 03600 · San Bernardo · RM
  
  IMPLICACION_para_canon:
    nombre_archivo_36_pdf_no_corresponde_a_dacion_Hijuela_2: confirmado
    es: una operación PARALELA · Cantera vende a Bruno parcelas en Colina (NO La Higuera)
```

**Es decir, hay al menos DOS operaciones distintas entre Cantera y Bruno:**

1. **2017-01-26 (36.pdf)**: Cantera vende a Bruno parcelas en La Cantera, Colina · NO Higuera
2. **2023-01-23**: Bruno (dación en pago) → Cantera del 25% Hijuela 2 La Higuera (Rep 68.661/2022 según PRE_CIERRE)

Esto sugiere relaciones cruzadas entre Bruno y Cantera (la sociedad que terminó adquiriendo su cuota de Hijuela 2 vía dación post-mortem o pre-mortem).

---

## 4 · Estado de los conflictos críticos C11, C1, C2 post-P2.7

```yaml
C11_rol_historico_24_48_vs_actual_24_123:
  estado_pre_P2_7: declarado_en_PRE_CIERRE pero no verificado_visualmente
  estado_post_P2_7: SIGUE_PENDIENTE_DE_VERIFICACION_VISUAL_DIRECTA
  razon: la seccion de Hijuela 2 dentro de 16.pdf NO fue leida individualmente
         (PDF de 62 paginas · solo lei 10 paginas)
  hechos_confirmados_indirectos:
    - PRE_CIERRE_CANON afirma que 16.pdf declara rol 24-48
    - El estudio de titulos marzo 2026 usa rol 24-48
    - Planos InterChile 2014-2015 usan rol 24-4 y 24-48
    - SII actual usa rol 24-123 y 24-160
  conclusion: mutacion_catastral_entre_2014_2016_y_2026_es_probable_pero_no_verificada_visualmente
  proxima_accion: 
    - leer paginas 11-13 + 19-30 de 16.pdf para localizar la seccion Hijuela 2
    - O cotejo directo en CBR La Serena

C1_Bruno_Luigi_Cominetti_Palini_estado_vital:
  estado_pre_P2_7: declarado fallecido por estudio + canon trataba como vivo
  estado_post_P2_7: SIGUE_SIN_VERIFICACION_DIRECTA
  hecho_documental_disponible: posesion_efectiva_inscrita_28_dic_2022_en_CBR
  conclusion: el escaneo Cominetti no contiene certificado defuncion · esta en CBR
  
C2_Bruno_Guillermo_Cominetti_Infanti_estado_vital:
  estado_pre_P2_7: declarado fallecido por estudio · canon trataba como firmante 2023
  estado_post_P2_7: AVANCE_PARCIAL
  hechos_confirmados:
    - 26-ene-2017: Bruno_Guillermo_VIVO_firmando_36_pdf_promesa_Cantera
    - 19-dic-2016: Bruno_Guillermo_VIVO_firmando_disolucion_Cofanti
    - 23-ene-2023: dacion_pago_a_Cantera_(segun_reporte_previo)
  hipotesis_emergente: 
    si_la_dacion_2023_fue_otorgada_post_mortem_inscrita_despues:
      explicaria_aparente_inconsistencia: el_estudio_dice_fallecido_pero_la_dacion_es_2023
    fecha_de_fallecimiento_exacta: PENDIENTE
  conclusion: Bruno_Guillermo_vivio_hasta_al_menos_2017 · fecha_exacta_de_muerte_pendiente
```

---

## 5 · Disciplina honesta · lo que P2.7 NO resolvió

```yaml
P2_7_resultados_concretos:
  paginas_leidas_de_16_pdf: 10 de 62 (16%)
  paginas_leidas_de_36_pdf: 3 de 6
  paginas_leidas_de_Venta_parcela_6: 0
  paginas_leidas_DVs_individuales: 0
  
NO_resuelto_definitivamente:
  C11 verificacion_visual_directa
  C1  estado_vital_Bruno_Luigi
  C2  fecha_exacta_de_fallecimiento
  ubicacion_seccion_Hijuela_2_dentro_de_16_pdf
  contenido_de_Venta_parcela_6_a_BCI
  superficie_y_precio_de_la_promesa_36_pdf
  
resuelto_o_avanzado:
  Bruno_Guillermo_vivo_al_26_ene_2017: HECHO_DOCUMENTAL
  el_36_pdf_no_es_la_dacion_de_2023_a_Cantera: HECHO_DOCUMENTAL
  16_pdf_es_la_escritura_matriz_de_disolucion_Cofanti: CONFIRMADO
  Cofanti_tenia_activos_en_5_regiones_chilenas: CONFIRMADO
```

---

## 6 · Hipótesis emergente post-P2.7 · operación cruzada Bruno ↔ Cantera

```yaml
HIPOTESIS_cruz_Bruno_Cantera:
  
  hecho_1: 26-ene-2017 · Cantera promete vender parcelas Colina a Bruno (36.pdf)
  hecho_2: 23-ene-2023 · Bruno da en pago a Cantera el 25% Hijuela 2 (Rep 68.661, según PRE_CIERRE)
  
  inferencia_razonable:
    entre_Bruno_y_Cantera_existe_relacion_comercial_continuada
    posibles_explicaciones:
      a_deuda_de_Bruno_a_Cantera_compensada_con_su_cuota_Hijuela_2
      b_estructura_familiar_donde_Cantera_es_vehiculo_Cominetti_para_consolidar_patrimonio
      c_operacion_de_proteccion_patrimonial_post_mortem_Bruno
  
  estatus: NO_DEMOSTRADA · requiere leer 36.pdf completo + dación 2023
  
  implicacion_para_Hijuela_2:
    Cantera_es_uno_de_los_5_titulares_Hijuela_2_con_25_pct
    Cantera_es_persona_juridica_no_un_heredero_individual
    la_relacion_Cantera_Bruno_Cantera_Cominetti_Infanti_es_estructural · no incidental
```

---

## 7 · Estado consolidado del expediente Hijuela 2 post-P2.7

```yaml
documentos_disponibles_y_leidos:
  CANON_HIJUELA2_v1: ✓ leído canonizado
  CADENA_REGISTRAL_HIJUELA_2: ✓ leído §1
  DUE_DILIGENCE_INTEGRAL_2026: ✓ leído completo
  PRE_CIERRE_CANON_v1_2: ✓ leído
  ESTANCIAS_LA_HIGUERA_DOC_resumen: ✓ leído
  DELTA_ESTUDIO_TITULOS: ✓ leído
  ESTUDIO_TITULOS_HIJUELA2_ESTANCIA_LA_HIGUERA.docx: NO LEÍDO directamente
  6_PDFs_Andes_Iron_Personeria: 1 muestra leída · NO contiene escritura compra
  16_pdf_Disolucion_Cofanti: parcial (10/62 pp)
  36_pdf_Promesa_Cantera_Bruno: parcial (3/6 pp)
  Cominetti_DV_individuales (10 PDFs): NO LEÍDOS
  Venta_parcela_6_a_BCI: NO LEÍDO

conflictos_estructurales_aun_abiertos:
  C1: estado_vital_Bruno_Luigi_padre
  C2: fecha_fallecimiento_Bruno_Guillermo_hijo
  C5: naturaleza_924_644_1994
  C7: superficie_SII_vs_juridica
  C8: superficie_mandato_1800ha
  C11: rol_24_48_vs_24_123_mutacion_catastral
  C12: CI_Lidia_ultimo_digito
  HIPOTESIS_SD_01: continuidad_Santa_Dominga_Andes_Iron
  HIPOTESIS_SE_01: venta_Cortes_Suez_Energy

conflictos_resueltos:
  C9_eslabon_1996: CERRADO (canon resuelve compraventa madre)
  C3_Bruno_Luigi_italiano: informacion_complementaria
  C4_1813_vs_1843: pendiente_cotejo_visual
  estado_Bruno_Guillermo_pre_2017: VIVO (HECHO_DOCUMENTAL post-P2.7)
```

---

## 8 · Backlog priorizado post-P2.7

```yaml
P2_8_alta_prioridad:
  objetivo: resolver_C11_definitivamente
  metodo: leer paginas 11-30 de 16.pdf donde está la sección Hijuela 2
  alternativa: solicitar al CBR La Serena copia literal inscripción 24-48 y 24-123
  esfuerzo: bajo-medio (15 páginas más de 16.pdf)
  
P2_9_alta_prioridad:
  objetivo: cerrar_C2_fecha_fallecimiento_Bruno_Guillermo
  metodo: solicitar Registro Civil certificado defunción
  esfuerzo: bajo (gestión externa)

P2_10_medio:
  objetivo: leer_los_10_DV_individuales_para_confirmar_FS_y_N_de_cada_adjudicación
  metodo: lectura sistemática
  esfuerzo: alto (10 PDFs)

P3_validacion_terreno_Daniel_RTK:
  prioridad: pendiente_resolución_C11_y_C2_documental
```

---

## 9 · Conclusión

P2.7 cerró ruta · NO resolvió C11 visualmente · pero avanzó:

| Logro | Detalle |
|---|---|
| Inventario completo | 13 PDFs reales (no 16) categorizados |
| Identificación correcta del 16.pdf | Escritura matriz disolución Cofanti · 62 pp · activos en 5 regiones |
| Corrección de canon previo | 36.pdf NO es la dación 2023 · es promesa Colina 2017 |
| Bruno Guillermo vivo al 2017 | HECHO_DOCUMENTAL confirmado |
| Sospecha de operación Bruno↔Cantera estructural | hipótesis emergente |

La pregunta central sigue abierta y el bloqueo es **leer más páginas de 16.pdf** (operación viable) o **consulta directa CBR** (operación externa).
