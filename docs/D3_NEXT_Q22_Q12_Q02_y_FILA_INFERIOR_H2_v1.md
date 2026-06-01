# D3.next · Cuadrantes orientales bbox H2 + descubrimiento de fila inferior

**Fecha:** 2026-05-31
**Pregunta del usuario (Max):** *"¿están dentro del perímetro RTK Hijuela 2? ¿qué ocupación tienen? ¿qué roles SII? Es pre-requisito para CUALQUIER oferta definitiva a H2."*
**Datos fuente:** cruce_geometria_rol_sii_v1.json (task #7) · ya cubre los 16 cuadrantes del bbox H2

---

## 1. Q02 / Q12 / Q22 · respuesta directa

```yaml
Q02:
  cat_ocupacional: 0  # sin ocupación visible en ortofoto
  dentro_RTK_H2: 0%   # NO está dentro perímetro Hijuela 2
  rol_dominante: 24-43 (88.7% del cuadrante · candidato Hijuela 1)
  ha_en_canon_H2 [24-123, 24-160]: 0.0 ha
  ha_sin_rol_SII: 0.16 ha (1.3%)
  lectura_canonica:
    no_dentro_RTK_H2
    catastralmente_atribuible_a_24-43 (no_a_H2_canon)
    sin_ocupacion_visible
    consecuencia: zona limpia pero fuera del perímetro operacional H2

Q12:
  cat_ocupacional: 4  # ocupación moderada-alta
  dentro_RTK_H2: 0%   # NO dentro perímetro Hijuela 2
  rol_dominante: 0-0 (51.9% · macro-bloque sin individualización)
  ha_en_canon_H2: 0.0 ha
  ha_sin_rol_SII: 4.76 ha (38.4%)
  lectura_canonica:
    no_dentro_RTK_H2
    catastralmente_anómalo (0-0 + alto % sin polígono)
    con_ocupacion_visible_significativa
    consecuencia: zona NO operacional para H2 + ocupada + catastralmente abierta

Q22:
  cat_ocupacional: 2  # ocupación baja-media
  dentro_RTK_H2: 82.3%  # ALTO solape RTK Hijuela 2
  rol_dominante: 0-0 (61.8%) + 27-0 (27.5%) + 24-43 (0.6%)
  ha_en_canon_H2: 0.0 ha
  ha_sin_rol_SII: 1.15 ha (9.3%)
  lectura_canonica:
    SI_dentro_RTK_H2 mayoritariamente
    catastralmente_en_0-0_y_27-0 (no_canon_H2)
    con_ocupacion_visible_baja_media
    consecuencia: zona dentro perímetro físico H2 + con ocupación + sin rol canon
                  replica el problema del cat5 (RTK H2 + ocupación + brecha catastral)
```

---

## 2. Respuesta a las 3 opciones que Max enunció

```yaml
A_si_dentro_H2_sin_ocupacion (zona de desarrollo limpia · estrategia comercial directa):
  Q02: NO cumple (0% RTK H2)
  Q12: NO cumple (0% RTK H2)
  Q22: NO cumple (cat_ocupacional=2 · con ocupación)
  conclusion_para_Q02_Q12_Q22: NINGUNO califica

B_si_dentro_H2_con_ocupacion (replica problema cat5):
  Q22: SI cumple (82.3% RTK H2 + cat=2)
  consecuencia: Q22 replica el patrón del cat5 en zona oriental

C_no_dentro_H2 (bbox H2 mal definido o H2 está en otro lugar):
  Q02: SI cumple (0% RTK H2)
  Q12: SI cumple (0% RTK H2)
  consecuencia: los cuadrantes Q02 y Q12 están fuera del perímetro RTK H2
                el bbox de la ortofoto NO es perímetro H2 · es solo bbox de imagen
```

---

## 3. Descubrimiento adicional · la fila inferior del bbox H2

Al buscar dónde SI aparecen los roles canon H2 [24-123, 24-160] en los 16 cuadrantes, emerge un patrón claro:

```yaml
canon_H2_rol_24_123_solo_aparece_en:
  Q30: 3.57 ha · dentro_RTK_H2=0%   · cat_ocupacional=4  · fuera_RTK_pero_canon
  Q31: 1.80 ha · dentro_RTK_H2=0%   · cat_ocupacional=2  · fuera_RTK_pero_canon
  Q32: 5.65 ha · dentro_RTK_H2=55%  · cat_ocupacional=0  · ZONA_LIMPIA_DENTRO_RTK_PARCIAL
  Q33: 3.58 ha · dentro_RTK_H2=100% · cat_ocupacional=0  · ZONA_LIMPIA_DENTRO_RTK_TOTAL · GOLDEN

canon_H2_rol_24_160:
  NO_aparece_en_ningun_cuadrante_del_bbox_H2
  HIPOTESIS: 24-160 está fuera del bbox de la ortofoto · al norte/sur/este/oeste del bbox H2

resto_de_cuadrantes_con_alto_solape_RTK_H2_pero_sin_canon:
  Q20: 53.6% RTK_H2 · top roles 0-0 + 0-0 + 0-0  → cat5 sin canon
  Q22: 82.3% RTK_H2 · top roles 0-0 + 27-0       → ya analizado
  Q23: 74.3% RTK_H2 · top roles 24-43 (6.85) + 0-0 → H1 candidato + macro 0-0
```

---

## 4. Q33 · DEEP DIVE post-corrección (TRACK 2 ejecutado)

### 4.1 Tabla canónica Q33

```yaml
Q33:
  ubicacion: esquina SE del bbox H2 · UTM E=[287214,287538] N=[6732598,6732978] · 12.31 ha
  
  ocupacion:
    HECHO: en fracción cubierta por ortofoto · sin estructuras visibles · vegetación arbustiva dispersa
    BLOQUEADO: ocupación de la MAYORÍA del cuadrante · "fuera del vuelo" (texto literal del feature VACIO-Q33-A)
    consecuencia: cat_ocupacional=0 es lectura PARCIAL · NO es prueba de ausencia total de ocupación
  
  rol_SII:
    HECHO: 100% del cuadrante con rol SII identificable
      24-43: 8.81 ha (71.6%) · candidato Hijuela 1
      24-123: 3.58 ha (29.1%) · canon Hijuela 2
    sin_anomalia: 0% en 0-0 · 0% sin polígono catastral
    Q33_es_unico_cuadrante_del_bbox_H2_con_100%_SII_identificable_y_sin_0-0
  
  RTK:
    HECHO: 100% dentro perímetro RTK Hijuela 2
  
  zonificacion:
    HECHO_CRITICO_corrige_lectura_previa: Q33 está 100% FUERA del límite urbano PRC La Higuera (0% dentro)
    NO_ES: ZU1, ZU2, ZAV, ZAP, ZIS, ZIP, ZE, ZC, AR1, AR2, AR3, ZNE, ZCH
    ES: suelo_rural por Art. 55 LGUC
    consecuencia_normativa:
      DL 3.516 (parcelas de agrado · mínimo 5.000 m²)
      cambio de uso de suelo Art. 55 ante SEREMI MINVU + SAG + DOM
      NO aplica constructibilidad urbana ZU1/ZAP
      NO aplica densidad urbana
      gradient_norte_sur_fila_inferior_bbox_H2:
        Q22: 75.2% dentro límite urbano
        Q23: 19.1% dentro límite urbano
        Q32: 7.9% dentro límite urbano
        Q33: 0% dentro límite urbano  ← el bbox H2 cruza el límite urbano en su fila inferior
  
  restricciones_visibles:
    catastral: ninguna anomalía (100% rol SII)
    juridica: BLOQUEADA hasta cruce CBR (24-123 == H2 documental? 24-43 == H1?)
    fisica: BLOQUEADA por cobertura ortofoto parcial
    normativa: rural por defecto · sin AR ni ZNE detectado
  
  conclusion_correcta:
    NO_ES_GOLDEN_PARA_DESARROLLO_URBANO_DIRECTO (no está en ZU1 ni ZAP · no aplica PRC)
    NO_ES_CANDIDATO_PARA_EDS_strip_center_galpon urbano sin cambio de uso de suelo
    
    SI_ES_CANDIDATO_PARA:
      proyecto_rural_alineado_al_canon_H2:
        - energético (FV utility scale · línea de transmisión)
        - agroindustrial (silvícola, packing, secador)
        - logístico minero (apoyo a corredor Andes Iron)
        - infraestructura sectorial (recinto, bodegaje rural)
      desarrollo_con_cambio_uso_suelo_Art_55:
        proceso 6-18 meses · SEREMI MINVU + SAG + DOM
        viable solo si proyecto pasa pertinencia ambiental
      cesion_o_oferta_a_Andes_Iron_como_predio_H2_alineado:
        RTK + SII catastral coinciden en 100% RTK + canon parcial
        sin conflicto urbano preexistente (porque no es urbano)
```

### 4.2 Reformulación del "GOLDEN"

```yaml
lectura_previa_incorrecta:
  "Q33 = triple convergencia (RTK + SII canon + sin ocupación) · única zona limpia para estrategia H2"

lectura_correcta_post_deep_dive:
  Q33 = rural-formal con cobertura ortofoto parcial · 100% RTK H2 + canon SII catastral parcial
  
  diferencia_clave_con_cat5:
    cat5 (Q10/Q11/Q20/Q21): urbano-planificado con brechas catastral/jurídica/social · 53% ZU1
    Q33: rural-formal sin ocupación visible (en fracción cubierta) · 0% urbano · Art 55 LGUC
  
  son_dos_objetos_estratégicos_distintos:
    cat5: regularización + estrategia comercial urbana (EDS, strip center, vivienda)
    Q33: proyecto rural alineado a H2 (energético, agroindustrial, logístico)
```

### 4.3 Bloqueos críticos pre-decisión

```yaml
para_promover_Q33_como_objeto_estrategico:
  
  1_cobertura_ortofoto_completa:
    esfuerzo: vuelo de extensión sobre cuadrantes Q30-Q33
    bloqueante_alto: 90% de Q33 NO se ha visto
    sin_esto: no se puede afirmar "sin ocupación" de Q33 completo
  
  2_cruce_CBR_24-123_y_24-43:
    esfuerzo: revisión cadena CBR + matching con KMZ-06
    bloqueante_alto: si 24-43 es H1 (Cominetti otro), Q33 no es 100% H2
                     es ~29% H2 + 72% H1 (otro objeto jurídico)
  
  3_validacion_RTK_Daniel_deslinde_fisico:
    esfuerzo: 0.5 día campo
    bloqueante_medio: el perímetro RTK puede tener desviaciones vs catastro SII
                      verificar deslinde físico en terreno
  
  4_consulta_servidumbres_gravamenes:
    esfuerzo: consulta CBR + ortofoto histórica
    bloqueante_medio: el corredor Andes Iron pasa por la zona · servidumbres mineras pueden existir
```

---

## 5. Q32 · zona limpia parcial · candidato secundario

```yaml
Q32:
  cat_ocupacional: 0  # SIN ocupación
  dentro_RTK_H2: 55.2%  # mitad dentro perímetro RTK H2
  rol_dominante: 24-123 (5.65 ha · 45.6%) + 24-43 (2.79 ha · 22.5%) + 0-0 (1.59 ha · 12.8%)
  ha_en_canon_H2: 5.65 ha (45.6% del cuadrante)
  
  consecuencia:
    zona limpia con 5.65 ha en rol canon 24-123 + 55% en RTK H2
    candidato secundario después de Q33
    aporta_más_ha_canon_H2_pero_menos_solape_RTK
```

---

## 6. Q30 / Q31 · canon H2 sin RTK H2 (el patrón inverso)

```yaml
Q30:
  cat_ocupacional: 4  # con ocupación
  dentro_RTK_H2: 0%   # fuera perímetro RTK
  ha_en_24-123: 3.57 ha (28.8% del cuadrante)
  lectura:
    catastralmente_en_H2 PERO fuera del RTK H2
    refuerza: doctrina-rol-sii-no-es-identidad-territorial
    el rol catastral 24-123 está en zona que RTK H2 NO incluye

Q31:
  cat_ocupacional: 2  # con ocupación baja-media
  dentro_RTK_H2: 0%   # fuera perímetro RTK
  ha_en_24-123: 1.80 ha (14.5% del cuadrante)
  lectura: igual que Q30 · catastralmente_en_H2 pero fuera del RTK H2

implicancia_estructural:
  HAY 5.37 ha de rol catastral 24-123 que están FUERA del perímetro RTK H2
  esto_es_inconsistencia_capas:
    SII dice "esto es H2" pero RTK dice "no, esto no es H2"
  tratamiento: zona_de_verificacion_fina · pendiente cruce CBR para resolver
```

---

## 7. Síntesis con disciplina HECHO / INFERENCIA / BLOQUEADO

```yaml
HECHOS_OBSERVADOS:
  1. Q02 (cat=0, 0% RTK_H2, 88.7% en 24-43): sin ocupación, fuera RTK_H2, atribuible catastralmente a 24-43
  2. Q12 (cat=4, 0% RTK_H2, 51.9% en 0-0): con ocupación, fuera RTK_H2, catastralmente anómalo
  3. Q22 (cat=2, 82.3% RTK_H2, 61.8% en 0-0): con ocupación, dentro RTK_H2, sin canon catastral
  4. Q33 (cat=0, 100% RTK_H2, 28.9% en 24-123): sin ocupación, dentro RTK_H2, con canon catastral parcial
  5. Q32 (cat=0, 55.2% RTK_H2, 45.6% en 24-123): sin ocupación, parcial RTK_H2, con canon catastral
  6. Q30/Q31: catastralmente_en_24-123 pero 0% RTK_H2 (inconsistencia capas)
  7. Rol canon 24-160 NO aparece en ningún cuadrante del bbox H2 ortofoto

INFERENCIAS_validas:
  1. Q33 + Q32 son las zonas más limpias y más alineadas con H2 dentro del bbox observado
  2. Q22 replica el patrón cat5 en zona oriental: dentro RTK H2 + ocupado + sin canon
  3. Q30/Q31 muestran inconsistencia SII vs RTK: el rol 24-123 cubre área que RTK H2 NO incluye
  4. El bbox de la ortofoto cubre principalmente NO-H2 (~70% de los cuadrantes con 0% RTK H2)

BLOQUEADO:
  1. Status jurídico-catastral exacto de las 9.23 ha de rol canon 24-123 dentro del bbox (Q30+Q31+Q32+Q33)
  2. Si el rol 24-43 dentro de Q33 es H1 o H2 (eso depende de cadena CBR)
  3. Si Q33 está libre de ocupante con título declarado (planilla socioeconómica no georreferencia)
  4. Ubicación del rol 24-160 (fuera del bbox observado · necesita ortofoto extendida o consulta directa)
```

---

## 8. Reformulación de la pregunta estructural

```yaml
pregunta_de_Max_original:
  "¿los Q22/Q12/Q02 están en H2? ¿qué ocupación? ¿qué roles?"

respuesta_directa:
  Q02: no (cat=0, fuera RTK, no canon)
  Q12: no (cat=4, fuera RTK, no canon, ocupado)
  Q22: SI parcialmente (cat=2, 82% RTK, no canon, ocupado)

pregunta_nueva_que_emerge:
  el verdadero candidato a "suelo limpio dentro H2" es Q33 + Q32
  ¿podemos ejecutar D4 (ocupación observada vs encuesta) sobre Q33 + Q32 
   ANTES de hacer Q22 RTK + cat5 ocupación?

implicacion_para_orden_operacional:
  Q33 + Q32 son los únicos candidatos a estrategia comercial directa pre-validación social
  si Q33 + Q32 están limpios + en canon + en RTK: 
    se pueden modelar como zona de oferta H2 candidata
    se puede iniciar planificación cabida ZU1 + ZAP
  si Q33 + Q32 tienen problemas no visibles en ortofoto:
    Hijuela 2 NO tiene suelo limpio operacional dentro del bbox observado
```

---

## 9. Acciones rankeadas post-Q22/Q12/Q02

```yaml
1_levantamiento_dirigido_Q33_Q32:
  esfuerzo: 0.5 día campo Daniel RTK
  señal: muy alta · valida si Q33 + Q32 son realmente suelo limpio para H2
  pregunta_específica:
    - ¿hay estructuras menores no visibles en ortofoto?
    - ¿deslinde físico coincide con RTK?
    - ¿hay ocupación reciente?
  
2_cruce_CBR_24_123_planilla_socioeconomica:
  esfuerzo: 30 min
  señal: alta · verifica si alguien declarado en planilla menciona rol 24-123
  resultado_esperado: probablemente NO (planilla está en pueblo cabecera, no en H2 sur)
  
3_oficio_SII_localizar_rol_24_160:
  esfuerzo: 1 semana
  señal: media · 24-160 puede estar en zona observada o fuera
  
4_extension_ortofoto_al_sur_y_este:
  esfuerzo: 1 día procesado
  señal: alta · permite ver si hay más zona H2 fuera del bbox actual
```

---

## 10. Frase de cierre canónica · post-DEEP DIVE Q33

```yaml
TRACK_2_Q33_DEEP_DIVE_resuelve:
  
  hecho_principal:
    la_pregunta_de_orientales_está_cerrada_negativamente:
      Q02: fuera RTK (no califica)
      Q12: fuera RTK + ocupado (no califica)
      Q22: dentro RTK pero replica anomalía cat5 (no califica como limpio)
    no_hay_reserva_limpia_oriental_en_el_bbox_observado
  
  hallazgo_nuevo_revisado:
    Q33 NO es candidato urbano (0% PRC)
    Q33 SI es candidato RURAL alineado a H2:
      100% RTK H2 + 29% canon SII 24-123 + sin ocupación visible (en fracción cubierta)
    
    pero_no_es_GOLDEN_aún:
      cobertura ortofoto parcial (90% del cuadrante "fuera del vuelo")
      24-43 (72% del cuadrante) requiere validar si es H1 o H2 jurídicamente
      servidumbres mineras Andes Iron pendientes de descartar
  
  inconsistencia_capas_canonica_reforzada:
    Q30 + Q31 tienen rol catastral 24-123 (5.37 ha total) PERO 0% dentro RTK H2
    es nuevo caso observacional para doctrina-rol-sii-no-es-identidad-territorial
    (no crea doctrina nueva · enriquece la vigente)
  
  limite_del_alcance_observable:
    rol canon 24-160 NO aparece en ningún cuadrante del bbox · H2 puede extenderse fuera

reformulacion_estrategica:
  cat5: urbano-planificado con brechas catastral/jurídica/social (regularización + estrategia comercial urbana)
  Q33: rural-formal sin ocupación visible (proyecto rural alineado a H2)
  son_dos_objetos_estrategicos_distintos · NO acumular en un solo plan
```

---

**Linkado:**
- [[D3_CRUCE_ROL_SII_VS_ENCUESTA_v1]]
- [[doctrina-rol-sii-no-es-identidad-territorial]]
- [[doctrina-no-derivar-estrategia-sin-capa-ocupacion]]
- [[doctrina-29-9-pct-es-zona-de-verificacion-fina]]
- [[CANON_HIJUELA2_v2]]
- [[evt-h2-occupation-baseline-20260531]]
- [[cruce_geometria_rol_sii_v1]]
