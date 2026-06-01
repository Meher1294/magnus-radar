# P2.3 · Falsar H-1 · cruce 0-0 cat 5 ↔ rol 24-5 Andes Iron · 2026-05-31

**Disparador:** Custodio autorizó P2.3 antes de P2.2 porque H-1 es la hipótesis más valiosa por capacidad de cambiar estrategia
**Hipótesis bajo test:**
```yaml
H-1:
  enunciado: "0-0 categoria 5 podrian corresponder a partes no individualizadas del rol 24-5 Andes Iron"
  estado_de_partida: no_demostrada
  razon_de_partida: matriz_envolvente_documentada (canon) + proximidad_logica
```

---

## 1 · Hallazgo metodológico previo al cruce · rol 24-5 NO está en KMZ-06

```yaml
busqueda_directa_rol_24_5_en_catastro_SII_vectorial:
  archivo: KMZ-06 La_Higuera_UTF8.kmz (catastro canónico)
  resultado: 0 polígonos con ROL_SII = "24-5"
  
roles_de_manzana_24_que_si_existen_en_KMZ_06:
  total_roles_distintos: ~50
  top_por_n_de_poligonos:
    24-156: 6 polígonos  (caso B1 disperso 30km)
    24-0:   5 polígonos  (suma 1.03 ha · "manzana 24, predio 0")
    24-43:  4 polígonos  (García Huidobro)
    24-10:  4 polígonos
    24-4:   3 polígonos
    24-31:  3 polígonos
    24-123: 3 polígonos  (Cominetti Hijuela 2)
    24-30:  3 polígonos
    ...
```

**HECHO_OBSERVADO:** el rol 24-5 (canon: Andes Iron · 60.000 ha) **no existe como placemark en el catastro SII vectorial** que tenemos.

**Implicaciones del hallazgo:**

1. La representación catastral vectorial SII NO incluye al titular más grande del territorio comunal (Andes Iron)
2. Esto es **consistente con el patrón D1**: los 0-0 son "predios sin individualizar catastralmente"
3. La capa SII vectorial podría tener al rol 24-5 representado como **conjunto de 0-0** en lugar de un único polígono · esto sería el caso emblemático de la doctrina B1 "rol_sii no es identificador geográfico único"
4. **No tenemos una representación vectorial directa del rol 24-5 para cruzar.** Para falsar H-1 necesité usar un proxy.

---

## 2 · Proxy utilizado · ESTANCIA_LA_HIGUERA_MATRIZ_2021.gpkg

```yaml
proxy:
  archivo: 00_CORE/ESTANCIA_LA_HIGUERA_MATRIZ_2021.gpkg
  superficie: 564.132 ha
  bbox: (-71.83, -29.73) a (-70.59, -29.29)  # ~119 km E-O × 47 km N-S
  declara_explicitamente_rol_sii_24_5: NO
  asociado_canonicamente_a_Andes_Iron: parcial (nombre incluye "Estancia La Higuera")
  observaciones:
    superficie_vs_canon_rol_24_5: 564.132 vs 60.000 ha (proxy es 9.4× mayor)
    interpretacion_posible_1: "polígono regional histórico que excede el rol SII actual"
    interpretacion_posible_2: "el canon subestima la superficie del rol 24-5"
    interpretacion_posible_3: "representan cosas distintas (matriz histórica vs rol SII actual)"
    estado: 3_interpretaciones_no_decidibles_con_datos_locales
```

**Caveat metodológico fuerte:** el proxy NO es directamente el rol 24-5. Es la **mejor aproximación documental disponible localmente** al concepto "Estancia La Higuera matriz". Si su polígono no representa exactamente el rol 24-5, la prueba de H-1 queda indirecta.

---

## 3 · Cruce geométrico ejecutado

```yaml
poligonos_0_0_que_caen_en_cuadrantes_cat_5: 42
suma_0_0_cat_5_ha: 17.62
suma_0_0_cat_5_dentro_proxy_Estancia_Matriz: 17.65
porcentaje_dentro_proxy: 100.0%  # 0.2% adicional es ajuste de cálculo Shoelace
```

### 3.1 · Detalle por polígono (top por superficie)

| Sector | Área total | En cat 5 | En matriz total | % dentro matriz |
|---|---|---|---|---|
| (vacío) | 6.17 ha | 6.17 ha | 6.17 ha | **100,0 %** |
| (vacío) | 9.61 ha | 2.62 ha | 9.61 ha | **100,0 %** |
| (vacío) | 5.27 ha | 1.32 ha | 5.27 ha | **100,0 %** |
| (vacío) | 7.16 ha | 1.19 ha | 7.16 ha | **100,0 %** |
| (vacío) | 1.43 ha | 1.17 ha | 1.43 ha | **100,0 %** |
| **La Higuera** (sector nombrado) | 0.81 ha | 0.81 ha | 0.81 ha | **100,0 %** |
| (vacío) | 1.36 ha | 0.78 ha | 1.36 ha | **100,0 %** |
| 35 polígonos más, todos al 100 % dentro | ... | ... | ... | **100,0 %** |

**Patrón:** los 42 polígonos están **íntegramente** dentro del proxy Estancia Matriz. No hay parcialidad.

---

## 4 · Matriz de confirmación / refutación

```yaml
hipotesis_H1_original:
  enunciado: "0-0 cat 5 podrian corresponder a partes no individualizadas del rol 24-5 Andes Iron"

hechos_observados:
  rol_24_5_existe_en_KMZ_06_vectorial: NO
  proxy_Estancia_Matriz_existe_localmente: SI
  proxy_declara_rol_24_5_explicitamente: NO
  17.65_ha_de_0_0_cat_5_dentro_de_proxy: HECHO (100% coincidencia)

inferencias_validas:
  - el_0_0_cat_5_es_geometricamente_indistinguible_del_proxy: SI
  - la_superficie_0_0_no_aparece_individualizada_en_SII_vectorial: SI
  - el_proxy_y_el_rol_24_5_apuntan_a_la_misma_entidad_conceptual: PROBABLE_pero_no_demostrada

hipotesis_que_AUN_no_se_pueden_separar:
  H1_a:
    enunciado: "el proxy = polígono real del rol 24-5"
    si_se_confirma: "H-1 queda CONFIRMADA · el 0-0 cat 5 son tierras Andes Iron NO individualizadas"
    validacion_pendiente: "obtener polígono SII oficial del rol 24-5 o escritura Andes Iron con coordenadas"
    
  H1_b:
    enunciado: "el proxy es polígono histórico de Estancia La Higuera (rol matriz pre-2021) · NO el rol 24-5 actual"
    si_se_confirma: "el 0-0 cat 5 cae en territorio histórico de Estancia La Higuera pero NO necesariamente en rol 24-5 actual"
    consecuencia: "el saneamiento depende de quién es titular HOY de cada subdivisión del polígono histórico"
  
  H1_c:
    enunciado: "el proxy es polígono regional (toda la Estancia incluyendo subdivisiones) · 24-5 es un sub-conjunto"
    si_se_confirma: "el cruce 100% es trivial (un sub-conjunto está dentro del super-conjunto) · no resuelve nada"

veredicto_actual:
  status: PARCIAL_PRO_H1
  
  fortalezas_de_H1:
    - 100% coincidencia geométrica (HECHO)
    - matriz envolvente canónica = Andes Iron (HECHO DOCUMENTAL)
    - el rol 24-5 no aparece como vector único · consistente con la hipótesis "se manifiesta como 0-0" (consistente · no probatorio)
  
  debilidades_de_H1:
    - rol 24-5 no existe en KMZ-06 vectorial · no se pudo cruce directo
    - proxy mide 9.4× la superficie del canon · puede ser distinta cosa
    - 100% dentro de proxy se puede explicar también por H1-b o H1-c
  
  estado_final_para_documentacion: 
    H1_no_falsada_ni_confirmada_definitivamente
    sigue_siendo_la_hipotesis_mas_plausible_pero_NO_PROBADA
```

---

## 5 · Lo que SÍ se demostró (HECHO_OBSERVADO)

```yaml
hechos_post_P2_3:
  - el rol 24-5 NO existe como placemark vectorial en KMZ-06 canónico
  - 17.65 ha de polígonos 0-0 que caen en cuadrantes categoría 5 están 100% dentro del polígono Estancia Matriz 2021
  - el polígono Estancia Matriz 2021 mide 564.132 ha (vs 60.000 ha del rol 24-5 según canon)
  - el sector "La Higuera" aparece nombrado en al menos un placemark 0-0 dentro de los cat 5 (los demás están vacíos)
```

---

## 6 · Lo que NO se demostró

```yaml
NO_demostrado:
  - el rol 24-5 es el polígono Estancia Matriz 2021 (proxy no validado)
  - los 0-0 cat 5 son tierras Andes Iron
  - el saneamiento del asentamiento es problema Andes Iron + ocupantes
  
para_demostrarlo_se_requiere:
  - obtener polígono SII oficial del rol 24-5 (consulta SII directa o capa actualizada)
  - revisar escritura inscripción Andes Iron Rep FS 313 N°14.461 (2021-08-16) y comparar deslindes
  - cotejar con plano matriz MBN N°IV-1-1777-S.R. (1988)
  - validación in situ de monolitos del perímetro Andes Iron
```

---

## 7 · Estado de H-1 después de P2.3 (lenguaje epistemológicamente estricto)

```yaml
H_1:
  enunciado: "0-0 categoria 5 podrian corresponder a partes no individualizadas del rol 24-5 Andes Iron"
  estado_post_P2_3: NO_DEMOSTRADA_pero_consistente_con_evidencia
  
  evidencia_que_apoya:
    - matriz envolvente canónica documentada como Andes Iron (HECHO)
    - 100% del 0-0 cat 5 dentro del proxy Estancia Matriz (HECHO)
    - rol 24-5 no aparece individualizado en KMZ-06 vectorial (HECHO consistente con "se manifiesta como 0-0")
  
  evidencia_que_no_la_apoya_pero_la_complica:
    - proxy mide 9.4× lo que el canon atribuye al rol 24-5
    - el GPKG proxy es regional · no declara rol_sii
    - el 100% de coincidencia se explica también con hipótesis alternativas H1-b y H1-c
  
  decision_operacional_inmediata:
    NO_afirmar_que: "los 0-0 cat 5 SON tierras Andes Iron"
    SI_afirmar_que: "los 0-0 cat 5 estan dentro del area geografica historica de Estancia La Higuera · el titular HOY de esa superficie especifica requiere validacion"
    
  proxima_validacion_decisiva:
    obtener_poligono_sii_oficial_actualizado_del_rol_24_5: bloqueante para confirmación
    via:
      - consulta directa mapas.sii.cl
      - sii-mcp si está disponible
      - revisión de capas vectoriales más recientes del data room
```

---

## 8 · Impacto en la estrategia (lectura honesta)

Aunque H-1 no quedó confirmada definitivamente, el dato territorial sí cambió. Lo que **antes** se afirmaba implícitamente:

```yaml
antes_P2_3:
  asentamiento_consolidado: dentro_perimetro_RTK_H2 (parcial)
  implicacion_naive: "ocupacion sobre Hijuela 2 Cominetti"

despues_P2_3:
  asentamiento_consolidado:
    geometricamente_dentro_RTK_Cominetti: parcial (Q10 47%, Q20 54%, Q21 34%)
    catastralmente_en_rol_24_123_Cominetti: 0%
    geometricamente_dentro_proxy_Estancia_Matriz_historica: 100% del 0-0 cat 5
    catastralmente_en_rol_24_5_Andes_Iron: HIPOTESIS_NO_DEMOSTRADA
  
  implicacion_honesta:
    "el asentamiento esta sobre territorio cuya titularidad
     juridica ACTUAL es objeto de divergencia entre 3 fuentes:
     RTK_Cominetti + catastro_SII + matriz_historica_Estancia_LaHiguera ·
     ninguna de las 3 tiene autoridad final sin estudio de titulos resolutivo"
```

---

## 9 · Backlog actualizado

```yaml
prioritarios_inmediatos:
  - obtener_poligono_sii_oficial_rol_24_5:
      bloqueante: para_confirmar_o_refutar_definitivamente_H1
      metodos:
        - consulta_directa_mapas_sii
        - revisar_si_existe_KMZ_alternativo_con_rol_24_5
        - solicitar_capa_actualizada_a_Andes_Iron_(via_mesa_negociacion)
  
  - revisar_escritura_inscripcion_Andes_Iron_2021:
      archivo: 01_LEGAL_TITULOS/Andes_Iron_Personeria/
      objetivo: comparar deslindes inscritos con polígono Estancia Matriz GPKG
  
  - explorar_capa_cabida_anterior_del_data_room:
      objetivo: ver si existe GPKG/SHP con el polígono del rol 24-5 efectivo

secundarios:
  - P2_2: reconstruccion historica (Jarpa → Cominetti · pre-2001 García Huidobro)
  - P3: lectura individual 12 cuadrantes pendientes
  - P4: validacion terreno con Daniel
```

---

## 10 · Resumen para tablero

```yaml
EVT-H2-OCCUPATION-BASELINE-20260531:
  estado: P1_completada + P2_1_completada + P2_3_completada_parcial
  
P2_3_H1_estado_final:
  veredicto: NO_DEMOSTRADA_pero_consistente
  coincidencia_geometrica: 100% con proxy
  caveat_metodologico_fuerte: proxy_no_es_demostrablemente_rol_24_5
  
nueva_pregunta_critica_emergente:
  ¿cuál_es_realmente_el_polígono_vectorial_del_rol_24_5_Andes_Iron?
  bloquea_confirmación_definitiva_de_H1
```

---

## Documentos asociados

- `magnus-radar/docs/CRUCE_GEOMETRIA_ROL_SII_H2_v1.md` · P1
- `magnus-radar/docs/P2_1_TITULARIDAD_ROLES_DOMINANTES_v1.md` · P2.1
- `magnus-radar/docs/P2_3_FALSAR_H1_CRUCE_00_VS_MATRIZ_v1.md` · este reporte
- `magnus-radar/docs/D1_CRUCE_MACRO_0_0_VS_CAPAS_LOCALES.md` · D1 (ya tenía el 83% de masa 0-0 en proxy · ahora especificamos cat 5)
- `magnus-radar/docs/CANON_HIJUELA2_v1.md` · canon doctrinal
- `magnus-radar/docs/ingesta_ortofoto_h2/P2_3_cruce_0_0_vs_matriz_v1.json` · datos del cruce
