# CANON HIJUELA 2 — v2

**Versión canónica · 2026-05-31 (cierre ciclo P2.x)**
**Custodio:** Max Medina (Magnus SpA / XPU)
**Estado:** PROMOVIBLE · con caveat geométrico explícito (rol 24-5 sin polígono)
**Relación con v1:** evolución · NO sustituye · v1 queda como antecedente histórico
**Disciplina activa:** 5 doctrinas canonizadas durante el ciclo P2.x (todas obligatorias)

---

## 0 · Cambios v1 → v2

| Aspecto | v1 (17-may-2026) | v2 (31-may-2026) |
|---|---|---|
| Rol 24-5 = Andes Iron · ~60.000 ha | afirmado como matriz envolvente | **identidad jurídica ALTA · superficie y geometría DESCONOCIDAS · caveat explícito** |
| Mutación SII rol histórico ↔ actual | no documentada | **HECHO DOCUMENTAL primario · 24-48→24-123 · 24-4→24-160 (P2.8)** |
| Predio fiscal "Totoralillo Norte" | no identificado | **objeto autónomo separado · C13 cerrado (P2.9C)** |
| Doctrina rol_sii como atributo temporal | implícita | **canonizada · prohíbe rol_sii como clave primaria** |
| Doctrina homonimia territorial | no formalizada | **canonizada · prohíbe identidad por nombre** |
| Riesgo contaminación "Estancia La Higuera" | mencionado | **canonizado · 3 objetos distintos · nunca usar sin calificar** |
| Diagnóstico 4 dimensiones identidad | parcial | **explícito · jurídico ALTO · catastral ALTO · geométrico INCOMPLETO · físico PENDIENTE Daniel RTK** |
| Desacoplamiento expedientes | no existía | **EXP_H2 vs EXP_DOMINGA_SERVIDUMBRES** |

---

## 1 · Doctrina canónica adoptada (5 + 8 reglas)

| # | Regla | Origen | Estado |
|---|---|---|---|
| 1 | No existe superficie única | sesión 2026-05-31 | ✓ vigente |
| 2 | Toda superficie debe estar asociada a una capa | sesión 2026-05-31 | ✓ vigente |
| 3 | La conciliación ocurre entre capas, no entre números | sesión 2026-05-31 | ✓ vigente |
| 4 | Estudio de títulos consolidado = autoridad jurídica superior a SII para cabida | sesión 2026-05-31 | ✓ vigente |
| 5 | SII conserva autoridad para rol, avalúo y contribuciones | sesión 2026-05-31 | ✓ vigente |
| 6 | El objeto canónico es la unidad territorial estratificada con representaciones concurrentes | sesión 2026-05-31 | ✓ vigente |
| 7 | Ningún delta entre fuentes se cierra sin validación CBR / título / acto jurídico primario | authority_hierarchy.md v1.0 | ✓ vigente |
| 8 | No cargar al grupo canónico hasta verificar | CADENA_REGISTRAL v1.1 | ✓ vigente |

**Doctrinas Meher OS aplicables (canonizadas durante P2.x):**

| Doctrina | Estado | Origen |
|---|---|---|
| **PRINCIPIO #1** · Auditoría operacional previa antes de extender schema | canonizada cross-Meher | descubrimiento_its_no_invento_formalizo |
| **PRINCIPIO #2** · Una fuente de verdad por métrica visible | canonizada cross-Meher | SPRINT_HARDENING_01 |
| **Cardinalidad ≠ Estado** · igual N de registros NO implica equivalencia | canonizada | diff KMZ-06 vs KMZ-09 (2026-05-31) |
| **Rol SII ≠ Identidad Territorial** | canonizada (P2.8 ascendió desde pendiente) | B1 dispersión + P2.8 mutación |
| **Homonimia Territorial** · similitud nominal NO implica identidad | canonizada (P2.9C) | C13 Totoralillo Norte ≠ Estancia La Higuera |

---

## 2 · Jerarquía de autoridad de fuente · nomenclatura canónica

```yaml
SII:
  representacion: catastral_administrativa
  autoridad_para: rol, avalúo, contribuciones, denominación predio
  fuente_canonica: KMZ-06 (La_Higuera_UTF8.kmz)
  limitaciones_conocidas:
    - rol_sii_no_es_identidad_geográfica_unica (doctrina canonizada)
    - mutación catastral 2014-2016 ↔ 2026 documentada
    - 18% de la comuna no individualizada (rol 0-0)
    - rol 24-5 sin polígono vectorial en catastro local

CBR:
  representacion: juridica
  autoridad_para: dominio, inscripciones, cadena registral, titularidad
  fuente_canonica: CBR La Serena + estudios títulos consolidados
  estado_Hijuela_2: ~92% reconstruida

Daniel_RTK:
  representacion: fisica_operacional
  autoridad_para: perímetro físico, geometría real
  custodio: Daniel Martínez Zurita · C.I. 14.387.985-2 · precision 10m
  fuente_canonica: PERIMETRO_CBR_DANIEL_RTK10M_V1_UTM19S_FIX.gpkg
  superficie_medida_Hijuela_2: 2.164,97 ha

NINGUNA_capa_tiene_autoridad_unica_sobre_las_otras (regla canonizada)
```

---

## 3 · Unidad territorial canónica (v2 endurecida)

```yaml
unidad_territorial:
  id: hijuela_2_cominetti
  uuid: H2-COMINETTI-CANON-V2
  nombre_canonico: "Hijuela 2 de la Estancia La Higuera"
  territorio_padre: estancia_la_higuera_jarpa_1988
  comuna: 4102_la_higuera
  provincia: elqui
  region: coquimbo

  composicion_juridica_canonizada:
    - sub_unidad: resto_lote_a
      superficie_ha: 863.00
      origen: subdivisión Lote A 1992 (plano N°531)
    - sub_unidad: resto_lote_b
      superficie_ha: 976.35
      origen: resto post-venta Velásquez pre-1996
    - sub_unidad: lote_c
      superficie_ha: 300.00
      origen: subdivisión Lote A 1992 (plano N°531) — autónomo
    TOTAL: 2.139,35 ha (CBR consolidado)

  aliases_SII_historicos:  # ← NUEVO en v2 · aplica doctrina rol_sii como atributo temporal
    Resto_Lotes_A_y_B:
      - { rol: "24-48", periodo: "2014-2016", fuente: "ESC Cofanti Rep 25.963" }
      - { rol: "24-123", periodo: "2017-presente", fuente: "consulta SII + HousePricing 2026" }
    Lote_C:
      - { rol: "24-4", periodo: "2014-2016", fuente: "ESC Cofanti Rep 25.963" }
      - { rol: "24-160", periodo: "2017-presente", fuente: "consulta SII + HousePricing 2026" }
    mutacion_documentada_en: P2_8_C11_RESUELTO_MUTACION_CATASTRAL_v1.md

  titulares_actuales:
    - { nombre: "Silvia María Cominetti Infanti", rut: "7.011.575-1", participacion: "18.75%" }
    - { nombre: "Claudia Cecilia Cominetti Infanti", rut: "7.011.576-K", participacion: "18.75%" }
    - { nombre: "Lidia Rosa Victoria Cominetti Infanti", rut: "6.349.740-1", participacion: "18.75%" }
    - { nombre: "Sucesión Bruno G. Cominetti Infanti", participacion: "18.75%", estado: "fallecido" }
    - { nombre: "Agrícola Cantera Limitada", participacion: "25.00%", origen: "dación pago Bruno G. Cominetti 23-ene-2023" }

  mandatario:
    nombre: "Inversiones Magnus SpA"
    rut: "77.613.806-1"
    representante: "Max Alan Medina Hernández (RUT 13.684.845-3)"
    instrumento: "Repertorio N°24.327, 14-abr-2026"
    plazo: "24 meses"
    comision: "10% bruto"
    superficie_declarada_ha: 1800
    clausula_excedente: "incorporación automática si estudios determinan mayor extensión"

  matriz_envolvente:  # ← MODIFICADO en v2 · NO afirmar superficie
    entidad: "Estancia La Higuera"
    rol_sii_atribuido: "24-5"
    titular_dominical_segun_canon: "Andes Iron SpA"
    inscripcion_referida: "Rep FS 313 N°14.461 del 16-ago-2021"
    precio_atribuido: "UF 273.292,2657"
    
    # CAVEATS POST-P2.x:
    geometria_real: PENDIENTE (P2.9A · búsqueda exhaustiva data room local · negativa)
    superficie_real: DESCONOCIDA (canon previo decía ~60.000 ha · NO respaldado por due diligence)
    poligono_vectorial: AUSENTE en data room local
    
    observacion_canonica:
      "Hijuela 2 Cominetti es enclave conceptual dentro de la matriz Andes Iron,
       pero la geometría exacta del rol 24-5 NO está disponible localmente.
       NO confundir con polígono proxy GPKG ESTANCIA_LA_HIGUERA_MATRIZ_2021
       (564.132 ha · regional · sin atribución oficial)
       ni con Sector Estancia Totoralillo Norte (Fiscal · objeto distinto)"
```

---

## 4 · Capas activas del visor (post-P2.x)

### Capa SII (catastral)

```yaml
roles_individualizados_canonicos:
  24-123: Resto Lotes A+B Hijuela 2 · 2640.93 ha SII · Comunidad Cominetti
  24-160: Lote C Hijuela 2 · 300 ha SII · Comunidad Cominetti
  24-42: Hijuela 1 Lt A · 620 ha · García Huidobro Sanfuentes Felipe
  24-43: Hijuela 1 Lt B · 1519 ha · García Huidobro Sanfuentes Felipe
  24-5: matriz Estancia La Higuera · titular Andes Iron · SIN POLÍGONO LOCAL

roles_anteriores_que_alias_a_los_actuales:
  24-48 → 24-123 (mutación documentada P2.8)
  24-4 → 24-160 (mutación documentada P2.8)
  
visor_debe_anotar_mutacion_si_aparece_documento_pre_2016
```

### Capa CBR (jurídica)

```yaml
fuente: GPKG TITULARIDAD_ACTUAL_COMINETTI_2023.gpkg (8 filas · ya operacionalizada)
titulares_5_cuotas_no_liquidadas (Comunidad Cominetti)
cadena_dominio_1990_2023_canonizada en CADENA_REGISTRAL_HIJUELA_2.md
conflictos_aun_abiertos: C1 (Bruno Luigi), C2 (Bruno Guillermo fecha), C5 (924-644), C12 (CI Lidia)
```

### Capa Daniel RTK (física operacional)

```yaml
fuente: PERIMETRO_CBR_DANIEL_RTK10M_V1_UTM19S_FIX.gpkg
superficie: 2.164,97 ha
precision: 10 m
estado: validado_in_situ_2026_05
```

### Capa de ocupación (baseline)

```yaml
fuente: EVT-H2-OCCUPATION-BASELINE-20260531
asentamiento_consolidado: 22.63 ha en zona ortofoto
tomas_segun_due_diligence: 87-120 familias · ~300 ha
estado_catastral_SII: 0-0 (sin individualizar)
estado_juridico_segun_due_diligence: SOBRE terreno Cominetti
estado_geometrico_RTK: parcialmente dentro perímetro Daniel RTK
divergencia_explicita_3_capas: obligatoria mostrar separadas
```

### Capa "Caso H2 · Tomas y Divergencia Territorial"

```yaml
estatus: módulo_diseñado_v1 (sin código aún)
naturaleza: inteligencia_operacional_activa · NO verdad catastral
fuente: MODULO_CASO_H2_TOMAS_Y_DIVERGENCIA_TERRITORIAL_v1.md
```

---

## 5 · Conflictos del expediente (estado consolidado post-P2.x)

| ID | Tema | Estado | Cierre · evidencia |
|---|---|---|---|
| C1 | Bruno Luigi Cominetti estado vital | ABIERTO | requiere posesión efectiva CBR |
| C2 | Bruno Guillermo Cominetti fecha defunción | PARCIAL · vivo al 26-ene-2017 confirmado (P2.7) | requiere Registro Civil |
| C3 | Bruno Luigi italiano | informativo | sin acción |
| C4 | 1813 vs 1843 | pendiente cotejo visual | sin acción crítica |
| C5 | Naturaleza acto 924-644/1994 | ABIERTO | requiere CBR |
| C6 | Distribución titularidad | dependiente C1+C2 | — |
| **C7** | **Superficie SII vs jurídica** | **CERRADO** post-P2.8 (escritura confirma 2139.35 ha total) | escritura Cofanti pp.11-13 |
| C8 | Superficie mandato 1800 ha | resuelto · cláusula excedente | sin acción |
| **C9** | **Eslabón 1996 Jarpa→Cominetti** | **CERRADO** | foto CBR Pase 7 |
| **C10** | **Foja/N adjudicaciones 2017** | **CERRADO** | 16.pdf escritura matriz |
| **C11** | **Rol 24-48 vs 24-123 · mutación catastral** | **CERRADO** post-P2.8 | cita literal 16.pdf pp.12-13 |
| C12 | CI Lidia último dígito | pendiente cotejo físico | sin acción crítica |
| **C13** | **Predio fiscal 2007 vs rol 24-5** | **CERRADO** post-P2.9C | ESC-GT-000011 deslinde explícito |

**Cierres post-P2.x: C7, C11, C13.** Más C9 y C10 que ya estaban cerrados pre-P2.x.

---

## 6 · Hipótesis activas

| ID | Hipótesis | Estado | Observación |
|---|---|---|---|
| H1 | 0-0 cat 5 = rol 24-5 Andes Iron | **SIN CAMBIO MATERIAL post-P2.9C** | Custodio corrigió: no degradar |
| H5 | Existe gran predio fiscal relevante en el corredor | **CONFIRMADA** post-P2.9C | Sector Totoralillo Norte (NO es 24-5) |
| HIPOTESIS_SD_01 | Continuidad Santa Dominga 1986 ↔ Andes Iron 2026 | abierta · risk_high_narrative_value | NO incorporar al canon |
| HIPOTESIS_SE_01 | Cortés → Suez Energy termoeléctrica | abierta | secundaria · no afecta H2 |
| HIPOTESIS_Bruno_Cantera | relación estructural | abierta | emergente post-P2.7 |

---

## 7 · Diagnóstico canonizable 4 dimensiones (Custodio)

```yaml
identidad_juridica:    ALTA_CONFIANZA
identidad_catastral:   ALTA_CONFIANZA (post-P2.8 mutación documentada)
identidad_historica:   MEDIA_ALTA
identidad_geometrica:  INCOMPLETA (rol 24-5 sin polígono)
identidad_fisica:      PENDIENTE_VALIDACION_Daniel_RTK
```

---

## 8 · Prohibiciones canonizadas explícitas

```yaml
NUNCA_promover_como_HECHO:
  - rol_24_5.superficie == 60.000 ha  # canon v1 lo afirmaba · v2 lo retira
  - poligono_proxy_GPKG_es_el_rol_24_5
  - 0_0_cat_5 == propiedad Andes Iron  # H1 sigue abierta · no demostrada
  - Sector_Estancia_Totoralillo_Norte == Estancia La Higuera  # C13 cerrado · son distintos
  - Compañía Minera Santa Dominga 1986 == Minera Dominga Andes Iron 2026  # HIPOTESIS_SD_01 · no confirmada
  - rol_sii como clave primaria  # doctrina rol SII ≠ identidad
  - identidad territorial por nombre  # doctrina homonimia territorial

NUNCA_decir_"Estancia La Higuera"_sin_calificar_cuál:
  - matriz Jarpa 1988 (6.918 ha · 3 hijuelas)
  - rol 24-5 atribuido a Andes Iron (geometría desconocida)
  - proxy GPKG regional (564.132 ha · sin contexto jurídico declarado)

NUNCA_colapsar_3_capas_SII/CBR/Daniel_RTK:
  - mostrar siempre separadas
  - declarar capa de origen al afirmar superficie/perímetro
  - ninguna capa tiene autoridad única sobre las otras
```

---

## 9 · Backlog priorizado post-canon v2 (según Custodio)

```yaml
prioridad_1_modelado_Magnus_Radar:
  unidad_territorial_v2: especificada en ONTOLOGIA_UNIDAD_TERRITORIAL_v2.md
  esquema_endurecido: doctrina rol_sii_atributo_temporal aplicada

prioridad_2_integrar_alias_sii_historicos:
  tabla relacional alias_sii_historico (objeto_id, rol, periodo, fuente)
  no_rol_como_clave

prioridad_3_integrar_conflictos_e_hipotesis_como_objetos_nativos:
  tablas conflicto y hipotesis con estado, evidencia, vías de cierre

prioridad_4_mapas_sii_rol_24_5:
  bloqueador: runtime
  valor: alto

prioridad_5_validacion_Daniel_RTK:
  bloqueador: coordinación
  valor: máximo
```

---

## 10 · Caveat geométrico final canonizable

```yaml
caveat_oficial_v2:
  geometria_rol_24_5: NO_DISPONIBLE_LOCALMENTE
  
  esto_NO_invalida_el_canon · sólo declara_un_borde_explícito
  
  el_caso_Hijuela_2_está_documentado_jurídicamente
  el_caso_Hijuela_2_está_documentado_catastralmente
  el_caso_Hijuela_2_está_medido_físicamente_por_Daniel_RTK
  
  lo_único_que_falta_es_el_polígono_oficial_del_rol_24_5_de_la_matriz_envolvente
  
  ese_polígono_no_afecta_la_operación_de_Hijuela_2_propiamente
  afecta_solo_la_caracterización_geográfica_de_la_matriz_envolvente
  
  consecuencia_operacional:
    el_expediente_está_promovible_para_Magnus_Radar_y_mesa_de_negociación
    con_advertencia_visible: "geometría matriz pendiente"
```

---

## 11 · Documentos asociados

| Documento | Función |
|---|---|
| `CANON_HIJUELA2_v1.md` | versión previa · queda como antecedente histórico |
| `ONTOLOGIA_UNIDAD_TERRITORIAL_v2.md` | schema endurecido derivado de este canon |
| `CADENA_REGISTRAL_HIJUELA_2.md` | cadena dominical canonizada |
| `MODULO_CASO_H2_TOMAS_Y_DIVERGENCIA_TERRITORIAL_v1.md` | módulo del visor |
| `EVT-H2-OCCUPATION-BASELINE-20260531` (memoria) | baseline territorial |
| `P2_8_C11_RESUELTO_MUTACION_CATASTRAL_v1.md` | cierre C11 |
| `P2_9_*` (varios) | cierre línea documental |
| memoria persistente: 5 doctrinas canonizadas durante P2.x |

---

## 12 · Versión, custodia y modificación

```yaml
version: 2.0
fecha_promocion: 2026-05-31
autor: Max Medina · Custodio (post-ciclo P2.x con asistente IA · revisión humana obligatoria)
estado: PROMOVIBLE_con_caveat_geometrico_explicito
sustituye: NO sustituye a v1 · v1 permanece como antecedente
proxima_revision_obligatoria: tras obtener polígono SII rol 24-5 (mapas.sii.cl o equivalente)
condicion_para_v3: integración con validación Daniel RTK in situ post-2026-Q3
quien_puede_modificar: Max Medina
quien_puede_aplicar: cualquier diseñador / asistente IA / colaborador en sistemas Meher OS
```
