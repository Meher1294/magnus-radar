# P2.6 · Síntesis jurídica interna · DUE DILIGENCE + RECONCILIACIÓN · 2026-05-31

**Disparador:** Custodio autorizó P2.6 = leer síntesis jurídica interna antes de buscar escritura primaria CBR externa
**Fuentes leídas:**
- `15_ESTUDIOS_INFORMES/DUE_DILIGENCE_INTEGRAL_ESTANCIA_LA_HIGUERA_2026.docx` (32 KB · 205 párrafos · 10 tablas) ✓ leído completo
- `14_RECONCILIACION_ESTUDIO_TITULOS/PRE_CIERRE_CANON_v1_2.md` ✓ leído
- `14_RECONCILIACION_ESTUDIO_TITULOS/01_RAW_REVIEW/ESTANCIAS_LA_HIGUERA_DOC_resumen.md` ✓ leído
- `14_RECONCILIACION_ESTUDIO_TITULOS/DELTA_ESTUDIO_TITULOS_2026-03_vs_CANON_2026-05.md` ✓ leído

---

## 1 · Hallazgo central · cadena registral del rol 24-5 reconstruida (parcial)

```yaml
rol_24_5_estancia_la_higuera_matriz_pre_Agua_Grande:
  origen_documental: ESTANCIAS DE LA HIGUERA Y SUS INSCRIPCIONES.doc (4-ene-2018)
  
  cadena_de_titularidad_reconstruida:
    1986:
      titular: "Compañía Minera Santa Dominga Limitada"
      inscripcion: fs. 1.475 N°1.391 / 1986 CBR La Serena
      rol_sii: 24-5
      naturaleza: ESTANCIA LA HIGUERA MATRIZ PRE-AGUA GRANDE
    
    ???:
      titular: "Ricardo Aristía De Castro"
      naturaleza: transferencia · "le cambió de nombre"
      inscripcion: PENDIENTE_IDENTIFICAR
    
    ??? (cadena intermedia):
      estado: PENDIENTE_DOCUMENTAR
    
    2007:
      titular: "Agrícola e Inmobiliaria Agua Grande ↔ Agrícola El Tofo Limitada"
      inscripcion: Rep FS 238 N°9.863
    
    ??? (entre 2007 y 2016):
      estado: PENDIENTE_DOCUMENTAR
    
    2016:
      titular: "Barrick Chile Generación → Compañía Minera Nevada SpA"
      precio: USD 9.968.943
    
    2021:
      titular: "Andes Iron SpA"
      precio: UF 273.292,2657
      inscripcion: Rep FS 313 N°14.461 / 16-ago-2021 (canon)
```

**HECHO_DOCUMENTAL:** el rol 24-5 existe como rol histórico-administrativo · su titularidad pasa por la sociedad **Compañía Minera Santa Dominga Limitada** (1986) → Andes Iron (2021).

**HIPOTESIS_SD_01 (registrada por XPU · no demostrada):** "Compañía Minera Santa Dominga Limitada" (1986) podría tener **continuidad histórica** con la actual Minera Dominga / Andes Iron. Es decir, el proyecto Dominga podría tener raíces de 40 años sobre el mismo corredor. **NO confirmar sin verificación.**

---

## 2 · Reconciliación CRÍTICA sobre las 3 representaciones de "Estancia La Higuera"

Las tres cifras incompatibles que P2.4 identificó tienen ahora una interpretación coherente:

```yaml
estancia_la_higuera_segun_fuente:
  
  plano_MBN_1988_DUE_DILIGENCE_INTEGRAL:
    superficie: 6.918 ha
    composicion: 3 hijuelas Jarpa (Pablo, Luis Emilio, Patricio)
    naturaleza: matriz JARPA saneada DL 2695 1990
    fuente: plano MBN IV-1-1777-S.R. + DUE_DILIGENCE_INTEGRAL_2026
    estatus: ACTIVO_PRINCIPAL_del_due_diligence
  
  canon_HIJUELA2_v1:
    superficie_canonizada: ~60.000 ha
    rol_sii: 24-5
    titular: "Andes Iron SpA"
    naturaleza_referida: "matriz envolvente Estancia La Higuera"
    fuente: CANON_HIJUELA2_v1.md §3
    superficie_NO_confirmada_documentalmente
  
  proxy_GPKG_ESTANCIA_MATRIZ_2021:
    superficie: 564.132 ha
    naturaleza: polígono regional sin contexto declarado
    fuente: 00_CORE/ESTANCIA_LA_HIGUERA_MATRIZ_2021.gpkg
    NO_es_referido_explicitamente_por_due_diligence_ni_canon

reconciliacion_emergente:
  
  matriz_JARPA_1988_6918ha:
    es: producto del saneamiento DL 2695 que creó las 3 hijuelas
    NO_es_el_rol_24_5
    relacion_con_rol_24_5: las 3 hijuelas son ENCLAVES dentro del rol 24-5 más amplio
  
  rol_24_5_matriz_pre_Agua_Grande:
    es: el predio histórico mayor que contenía las hijuelas Jarpa + tierras circundantes
    titular_hoy: Andes Iron SpA (documentado en cadena)
    superficie_real: NO_CONFIRMADA
    superficie_canon_60000ha: NO_RESPALDADA_por_due_diligence_integral
  
  proxy_GPKG_564132ha:
    es: polígono regional · probablemente NO_corresponde al rol 24-5
    naturaleza_real: PENDIENTE_IDENTIFICAR
```

**Implicación:** los 60.000 ha del canon NO tienen respaldo en el due diligence integral. La cifra puede provenir de una estimación canon-interna sin fuente documental primaria.

---

## 3 · Hallazgo paralelo decisivo · las "tomas" según el due diligence

**El due diligence integral REVELA que el asentamiento cat 5 que detectamos en P1 corresponde a las "tomas":**

```yaml
tomas_sobre_Hijuela_2_Cominetti:
  cantidad_familias_estimada: 87-120
  superficie_estimada_ha: ~300
  fuente: reunión con Alcaldesa Uberlinda Aquea 20-abr-2026
  estimacion_previa_70_familias: revisada al alza
  
  ubicacion_segun_due_diligence: 
    "sobre Hijuela 2 Cominetti · suelo rural · FUERA del límite urbano"
  
  servicios_existentes:
    - agua por camión aljibe (municipio)
    - paneles solares
    - infraestructura sanitaria estatal_$8072M (sobre terreno Cominetti sin compensación)
  
  origen_administrativo:
    - José Luis Morán manejó "oficina de saneamiento" INFORMAL por 12 años
    - ex_alcalde Yerko Galleguillos autorizaba con cartas simples
    - Morán se llevó documentación municipal · sigue asesorando informalmente
    - Morán es amigo 40 años de Felipe García Huidobro (dueño Hijuela 1, rol 24-43)
  
  proposicion_actual_Magnus:
    "regularizar 7 a 10 ha (no 300 ha) con transferencia formal al municipio,
     liberando el resto del predio"

reconciliacion_con_P1_baseline:
  asentamiento_detectado_en_ortofoto:
    catastralmente: rol 0-0 + roles menores (NO en 24-123)
    geometricamente: parcialmente dentro perímetro RTK Daniel
    juridicamente_segun_due_diligence: SOBRE terreno Cominetti
  
  divergencia_explicada:
    SII no individualizó las tomas en el rol 24-123
    porque administrativamente no son predios formales
    aparecen como 0-0 en el catastro vectorial
    PERO juridicamente la titularidad del suelo es Cominetti
```

**ESTA ES LA RESPUESTA QUE FALTABA**: las "tomas" son ocupaciones físicas sobre suelo cuyo titular jurídico DOCUMENTAL es Cominetti (Hijuela 2), pero el catastro SII vectorial NO las refleja como tales · las representa como 0-0.

---

## 4 · Conflicto crítico C11 emergente · rol histórico 24-48 vs rol actual 24-123

El estudio de títulos consolidado y el due diligence identifican un conflicto registral central:

```yaml
C11_rol_24_48_vs_24_123:
  estudio_titulos_marzo_2026:
    rol_declarado_para_resto_Lote_AyB: 24-48
    fuente: escritura disolución Cofanti 19-dic-2016 (Rep 25.963)
  
  canon_mayo_2026:
    rol_usado_para_Hijuela_2: 24-123
    fuente: consultas SII actuales
  
  interpretaciones_posibles:
    a_mutacion_catastral: el rol pasó de 24-48 a 24-123 entre 2016 y 2026
    b_coexistencia: 24-48 sigue existiendo · 24-123 es un nuevo rol derivado
    c_subdivision: 24-48 fue subdividido en 24-123 + ¿otro?
    d_error_documental: una de las dos fuentes tiene transcripción incorrecta
  
  pendiente_resolver: consulta SII directa + búsqueda histórica rol 24-48
```

**Esto refuerza la hipótesis A del bloque PENDIENTE registrado:** "rol SII no implica unidad geográfica única". También las planos servidumbre InterChile 2014-2015 refieren a **rol 24-4 y 24-48**, NO 24-123/24-160. Hay claramente una **renumeración catastral SII** entre 2014-2016 (rol histórico) y 2026 (rol actual).

---

## 5 · Estado de las 4 hipótesis post-P2.6

```yaml
H_1_0_0_es_rol_24_5_Andes_Iron:
  estado_post_P2_6: NO_CONFIRMADA_DEFINITIVAMENTE_pero_MUY_PROBABLE
  evidencia_nueva: 
    - rol 24-5 existe como rol histórico-administrativo SII (confirmado fs. 1475 N°1391/1986)
    - cadena titularidad llega a Andes Iron (HECHO_DOCUMENTAL)
    - asentamiento en cat 5 cae en 0-0 que probablemente forma parte del rol 24-5
  caveat:
    - polígono vectorial exacto del rol 24-5 sigue sin obtener
    - superficie del rol 24-5 (60.000 ha del canon) no respaldada por due diligence

H_2_0_0_es_exclusion_urbana_1988:
  estado_post_P2_6: PARCIALMENTE_VIVA
  evidencia_nueva:
    - el due diligence confirma 296.26 ha de exclusiones del plano 1988
    - 115 ha "Límite Urbano La Higuera" (Lote I) está documentado
  caveat:
    - el bbox de la ortofoto está al ESTE de Hijuela 2 RTK, fuera del pueblo cabecera
    - es poco probable que el asentamiento detectado sea el límite urbano del pueblo

H_3_0_0_es_exclusion_minera_El_Molle:
  estado_post_P2_6: NO_DEMOSTRADA
  evidencia_nueva:
    - El Molle = Lote L = 150 ha = Jaime Ugarte Lee / Julio Brito Riffo (Cía Minera Porvenir)
    - es activo en evaluación INDEPENDIENTE por Magnus
    - frente a Ruta 5: 1.500 m

H_4_0_0_es_subdivision_no_individualizada_de_Hijuela_2:
  estado_post_P2_6: REVALORIZADA_AL_ALZA
  evidencia_nueva:
    - el due diligence afirma que las tomas (~300 ha) están SOBRE terreno Cominetti
    - el catastro SII vectorial NO las individualiza
    - aparecen como 0-0 en el catastro vectorial
    - esto sería precisamente "subdivisión no individualizada por SII"
```

**Lectura final:** H-1 y H-4 son ambas plausibles · pueden coexistir (las tomas serían simultáneamente dentro del rol 24-5 histórico y dentro del perímetro RTK Cominetti porque las hijuelas Jarpa son enclaves dentro del rol 24-5).

---

## 6 · Síntesis territorial reformulada post-P2.6

```yaml
hipotesis_canon_reformulada_para_la_zona_ortofoto:
  
  capa_SII_catastral:
    polígonos_principales:
      rol_24_123: Resto Lote A+B Hijuela 2 Cominetti (parcial · 1.404 ha en bbox)
      rol_24_43: Hijuela 1 Lote B (García Huidobro · 53.95 ha en bbox)
      rol_24_5: matriz pre-Agua Grande (Andes Iron) · polígono vectorial NO_DISPONIBLE
      0-0: predios sin individualizar (89.80 ha en bbox · partes plausibles de rol 24-5 o subdivisiones de hijuelas)
  
  capa_CBR_juridica:
    titulares_actuales:
      Hijuela_1_Lt_A_B: García Huidobro Sanfuentes Felipe (2001-)
      Hijuela_2_Resto_A_B: Comunidad Cominetti (5 cuotas no liquidadas)
      Hijuela_2_Lt_C: Comunidad Cominetti (misma)
      matriz_pre_Agua_Grande_rol_24_5: Andes Iron SpA (2021-)
  
  capa_Daniel_RTK_fisica_operacional:
    perimetro_Hijuela_2_RTK: 2.164.97 ha
    abarca: territorio físicamente reclamado por Cominetti
    incluye_parcialmente: cuadrantes Q10 (47%), Q20 (54%), Q21 (34%) del asentamiento detectado

asentamiento_observado_cat_5:
  superficie_aprox: 22.63 ha (subconjunto del total ~300 ha estimadas tomas)
  estatus_catastral_SII: en rol 0-0 mayoritariamente
  estatus_juridico_CBR: SEGUN_DUE_DILIGENCE_INTEGRAL_es_terreno_Cominetti
  estatus_fisico_RTK: parcialmente_dentro_perimetro_RTK_Daniel
  
  la_divergencia_entre_capas_es_estructural_y_PRINCIPAL_PROBLEMA_DEL_VISOR
```

---

## 7 · La pregunta crítica se ha REFINADO

**Antes de P2.6:**
> ¿Qué polígono real representa el rol 24-5 y qué relación tiene con las capas SII, CBR y Daniel RTK?

**Después de P2.6:**
> El rol 24-5 = Estancia La Higuera matriz pre-Agua Grande = Andes Iron SpA (cadena documental confirmada). Lo que sigue sin polígono vectorial es su geometría exacta · pero ya no hay incertidumbre sobre su identidad jurídica.

**La nueva pregunta crítica que emerge:**
> ¿Por qué el catastro SII vectorial NO representa el rol 24-5 como polígono propio · y por qué las tomas que físicamente están sobre Hijuela 2 Cominetti aparecen catastralmente como 0-0?

**Lectura más probable:**
- SII NO individualizó administrativamente las tomas como predios formales (porque legalmente no lo son)
- SII NO individualizó el rol 24-5 como polígono vectorial (porque cubre todo lo NO asignado a hijuelas, y el catastro vectorial sólo cubre predios individualizados)
- El rol 24-5 vive **administrativamente** en el SII (tiene avalúo, contribuciones, titular Andes Iron) pero **NO tiene polígono vectorial discreto**

---

## 8 · Regla de diseño del visor · actualizada post-P2.6

```yaml
para_polígonos_catastrales_individualizados:
  rol_24_123: { titular: "Comunidad Cominetti", estado: "no_partida" }
  rol_24_160: { titular: "Comunidad Cominetti", estado: "no_partida" }
  rol_24_43:  { titular: "García Huidobro Sanfuentes Felipe" }
  rol_24_42:  { titular: "García Huidobro Sanfuentes Felipe" }
  rol_24_122: { titular: "Trujillo Paez Alejandro · casa urbana 36m²" }
  rol_24_5:   { titular: "Andes Iron SpA", estado_geometrico: "sin_polígono_vectorial_individualizado · administrativamente_vigente" }

para_polígonos_0_0:
  etiqueta_visible: "sin individualizar"
  titular_SII: null
  titular_juridico_CBR_segun_due_diligence: 
    si_dentro_RTK_Hijuela_2: "probablemente Cominetti (debe validarse)"
    si_fuera_RTK_pero_dentro_proxy_ESTANCIA_MATRIZ_2021: "probablemente Andes Iron rol 24-5 (debe validarse)"
    si_fuera_de_ambos: "DESCONOCIDO"
  alerta: "titularidad actual no resuelta · requiere validación CBR"

para_tomas_detectadas_en_ortofoto:
  etiqueta_visible: "ocupación · sin título individual"
  titular_juridico_del_suelo: "Cominetti según due diligence integral · NO ocupante"
  estatus_administrativo: "informal · gestionada por oficina_saneamiento_Moran_2010_2022"
  estatus_sanitario: "infraestructura_estatal_8072M_sin_compensación"
  proposicion_Magnus: "regularizar 7-10 ha al municipio"
```

---

## 9 · Lo que P2.6 cerró

| Pregunta | Estado pre-P2.6 | Estado post-P2.6 |
|---|---|---|
| Identidad jurídica del rol 24-5 | HIPOTESIS canónica · 60.000 ha | HECHO_DOCUMENTAL · cadena titularidad reconstruida hasta Andes Iron |
| Naturaleza del rol 24-5 vs hijuelas Jarpa | Confuso · "matriz envolvente" sin definición | Clara: rol 24-5 = predio mayor histórico · hijuelas son enclaves saneados DL 2695 1990 dentro de él |
| Las "tomas" del asentamiento detectado | Catastralmente en 0-0 (incierto jurídicamente) | DUE DILIGENCE las afirma SOBRE terreno Cominetti · catastro SII no las refleja |
| Continuidad Santa Dominga ↔ Minera Dominga | NO_PLANTEADA | HIPOTESIS_SD_01 abierta · risk = HIGH NARRATIVE VALUE |
| Conflicto rol histórico 24-48 vs actual 24-123 | NO_PLANTEADO | C11 elevado a CRÍTICO · pendiente consulta SII |

## 10 · Lo que P2.6 NO cerró

```yaml
sigue_pendiente:
  - polígono_vectorial_real_del_rol_24_5: solo cadena de titulares · sin geometría
  - superficie_exacta_del_rol_24_5: cifra 60.000 ha NO respaldada documentalmente
  - cadena_intermedia_Aristía_a_AguaGrande_2007: gaps registrales
  - cadena_intermedia_AguaGrande_2007_a_Barrick_2016: gap
  - confirmacion_HIPOTESIS_SD_01: continuidad Santa Dominga ↔ Andes Iron
  - resolucion_C11: mutación 24-48 → 24-123
  - estado_vital_Bruno_Luigi_y_Bruno_Guillermo_Cominetti: 2 conflictos críticos pendientes (C1 + C2)

vias_para_resolverlos:
  - consulta_CBR_La_Serena: certificados primarios para los gaps
  - consulta_directa_mapas_sii: polígono vectorial rol 24-5
  - lectura_completa_de_los_16_pdf_Cominetti_Escritura_Escaneada: cierre conflictos C1-C12
  - validacion_terreno_Daniel_RTK: única autoridad final geométrica
```

---

## 11 · Backlog priorizado post-P2.6

```yaml
P1_completada
P2_1_completada
P2_3_ejecutada_NO_DEMOSTRADA
P2_4_ejecutada_BUSQUEDA_FALLIDA
P2_5_completada_DESCARTE_carpeta_personeria
P2_6_completada_AVANCE_MAYOR_pero_sin_polígono_rol_24_5

proximos_movimientos_candidatos:

  P2_7_lectura_16_pdf_Cominetti_Escritura_Escaneada:
    objetivo: cerrar conflictos C1-C12 críticos
    valor: ALTO (resuelve titularidad real Hijuela 2 + identifica rol 24-48 vs 24-123)
    esfuerzo: medio (15+ PDFs)
  
  P2_8_geolocalizar_plano_MBN_1988:
    objetivo: tener polígono vectorial Hijuela 2 + exclusiones 1988 (I, L, M)
    valor: ALTO (resuelve H2 y H3 definitivamente)
    esfuerzo: medio (trabajo QGIS · Fase 12 planificada)
  
  P2_9_consultar_SII_polígono_rol_24_5:
    objetivo: obtener polígono vectorial oficial del rol 24-5
    valor: ALTO (resolvería H1 definitivamente)
    esfuerzo: bajo (mapas.sii.cl) · requiere runtime
  
  P2_10_solicitar_CBR_La_Serena:
    objetivo: certificados de dominio vigente y cadena completa
    valor: ALTO (cierre formal de todos los gaps registrales)
    esfuerzo: alto (gestión externa)
  
  P3_validacion_terreno_Daniel_RTK:
    objetivo: autoridad final operacional
    valor: MAXIMO
    esfuerzo: coordinación logística
```

---

## 12 · Disciplina aplicada

```yaml
hecho_documental_consolidado:
  - rol_24_5_existe_administrativamente_y_es_Andes_Iron_via_cadena_documentada
  - Estancia_La_Higuera_Jarpa_es_6918ha_por_plano_MBN_1988
  - tomas_estan_sobre_terreno_Cominetti_segun_due_diligence_integral
  - SII_no_individualizó_geometricamente_el_rol_24_5_ni_las_tomas

inferencia_razonable:
  - el_polígono_vectorial_proxy_564132ha_no_corresponde_estrictamente_al_rol_24_5
  - rol_24_5_es_administrativo_pero_geométricamente_no_discreto
  - las_hijuelas_Jarpa_son_enclaves_dentro_del_rol_24_5_histórico

hipotesis_no_demostradas_que_se_mantienen:
  - HIPOTESIS_SD_01_Santa_Dominga_a_Minera_Dominga
  - H1_0_0_cat_5_es_rol_24_5_Andes_Iron
  - conjunto_de_4_hipotesis_alternativas

nomenclatura_aplicada:
  SII / CBR / Daniel_RTK: ✓
  Estancia_La_Higuera: SIEMPRE_calificada_la_fuente_y_superficie: ✓ 
```

Aplicada disciplina **null por ausencia, no por diseño** + nomenclatura canonizada Daniel RTK + jerarquía SII/CBR/Daniel_RTK + alerta `contaminacion_de_identidad_territorial` activa en cada mención de "Estancia La Higuera".
