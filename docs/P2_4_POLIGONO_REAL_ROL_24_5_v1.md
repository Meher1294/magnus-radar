# P2.4 · Polígono real del rol 24-5 Andes Iron · 2026-05-31

**Disparador:** Custodio · "el bloqueo no es histórico ni visual; es identidad geométrica de la matriz"
**Orden ejecutada:**
- ~~1. mapas.sii.cl~~ (sin runtime · no disponible en esta sesión)
- 2. búsqueda data room ✓
- 3. escritura Andes Iron 2021 ✓ (parcial)
- 4. comparar proxy vs rol 24-5 real vs 0-0 cat 5 ✓ (con caveat)

---

## 1 · Hallazgo decisivo · TRES representaciones cuantitativamente incompatibles de "Estancia La Higuera"

```yaml
estancia_la_higuera_segun_fuente:
  
  plano_MBN_IV_1_1777_SR_1988:
    superficie_total: 6.918 ha
    fuente: 01_LEGAL_TITULOS/Plano_MBN_IV-1-1777-SR_Estancia_La_Higuera/FICHA_DOCUMENTO.md
    autor: Heraclio Velásquez y Cía. · Ing. Geomensor Juan García V.
    composicion:
      hijuela_1_Pablo_Jarpa: 2.139 ha (Lote a 620 + Lote b 1519)
      hijuela_2_Luis_Emilio_Jarpa: 2.642 ha (Lote a 1163 + Lote b 1479) ← origen Cominetti
      hijuela_3_Patricio_Jarpa: 2.137 ha (Lote a 910 + Lote b 1227)
    exclusiones_documentadas:
      I_limite_urbano_La_Higuera: 115 ha
      L_Cia_Minera_Porvenir_El_Molle: 150 ha
      M_Municipalidad: 18.12 ha
      otros_8_puntos: 13.14 ha
      total_excluido: 296.26 ha
  
  canon_HIJUELA2_v1:
    superficie: ~60.000 ha
    titular: Andes Iron SpA (rol 24-5)
    fuente: CANON_HIJUELA2_v1.md §3 (canonizado)
    observacion: "Hijuela 2 Cominetti es enclave dentro de la matriz Andes Iron"
  
  proxy_GPKG_ESTANCIA_MATRIZ_2021:
    superficie: 564.132 ha
    bbox: (-71.83, -29.73) a (-70.59, -29.29) · ~119 km E-O × 47 km N-S
    fuente: 00_CORE/ESTANCIA_LA_HIGUERA_MATRIZ_2021.gpkg
    declara_rol_sii: NO
    declara_titular: NO
```

**Las tres cifras son incompatibles entre sí. Cada una difiere de la siguiente por un factor ~10×.**

---

## 2 · Lectura honesta de la divergencia

Estas 3 cifras NO son versiones de la misma superficie. Probablemente refieren a **3 conceptos territoriales distintos** que el data room ha consolidado bajo el mismo nombre "Estancia La Higuera":

| Nivel | Concepto | Cifra | Evidencia |
|---|---|---|---|
| Matriz Jarpa 1988 | Las 3 hijuelas saneadas por DL 2695 | 6.918 ha | plano MBN (HECHO_DOCUMENTAL) |
| Estancia jurídica actual | Polígono envolvente rol 24-5 según canon | ~60.000 ha | canon (HECHO_DOCUMENTAL secundario) |
| Polígono regional GPKG | Polígono que excede la comuna · probable representación regional | 564.132 ha | GPKG (HECHO_GEOMÉTRICO sin contexto jurídico) |

**Implicación:** decir "matriz envolvente = 60.000 ha = Andes Iron" puede ser CIERTO jurídicamente · pero la GEOMETRÍA exacta de ese polígono NO se puede derivar del proxy GPKG. El proxy excede 9.4× lo que el canon atribuye al rol 24-5.

---

## 3 · Hallazgo crítico colateral · exclusiones del plano MBN 1988

Sobre el bbox de la ortofoto donde detectamos asentamiento cat 5, **emerge una hipótesis alternativa fuerte a H-1**:

```yaml
plano_MBN_1988_exclusiones_que_podrian_explicar_el_0_0_cat_5:
  
  exclusion_I:
    nombre: "Límite Urbano La Higuera"
    superficie: 115.00 ha
    propietario: VARIOS
    estado_1988: EXCLUIDO del saneamiento Jarpa (NO entró a la matriz)
    implicacion: tierras del pueblo La Higuera tienen titularidad propia distinta a los Jarpa
  
  exclusion_L:
    nombre: "Cía Minera Porvenir · Planta El Molle"
    superficie: 150.00 ha
    propietarios: Jaime Ugarte Lee / Julio Brito Riffo
    estado_1988: EXCLUIDO del saneamiento Jarpa
    nota: "El Molle" es nombre conocido sector La Higuera
  
  exclusion_M:
    nombre: "Municipalidad La Higuera"
    superficie: 18.12 ha
    propietario: Ilustre Municipalidad de La Higuera
    plano_referido: IV-1-881-S.R.
  
  IMPLICACION_PARA_H_1:
    si los 17.65 ha de 0-0 cat 5 estan dentro de exclusiones I/L/M:
      → no son tierras Andes Iron
      → no son tierras Cominetti
      → son tierras de exclusiones formales con titulares DISTINTOS (municipalidad, mineras, urbanos, etc.)
    
    estado_de_esta_hipotesis: NO_DEMOSTRADA · requiere georreferenciar el plano MBN (pendiente Fase 12)
```

Esto refuerza la disciplina del Custodio: **NO afirmar "tierras Andes Iron"** porque hay al menos otra hipótesis equivalentemente plausible (tierras de exclusiones formales).

---

## 4 · Andes Iron · evidencia documental disponible localmente

```yaml
andes_iron_spa:
  rut: 76.097.759-4
  razon_social_actual: "Andes Iron SpA"
  inscripcion_CBR_Santiago: fs. 22578 N°15392 / 2010 Reg. Comercio
  estado_al_11_jul_2025: VIGENTE
  capital_actual: CLP 224.326.546.484 (~USD 240M)
  acciones: 2.352.869
  socios_controladores_finales:
    - Fondo de Inversion Privado Rucapangui
    - Andes Iron Ltd. (extranjera)
  fuente_CBR: AIPD-CIS0002-IE-012000-ADM-CER-LE-00006_inscripcion_andes_iron_spa_2025-07-14.pdf

adquisicion_Estancia_La_Higuera_segun_canon:
  fecha: 2021-08-16
  instrumento: Rep FS 313 N°14.461
  precio: UF 273.292,2657
  fuente: CANON_HIJUELA2_v1.md (citado en canon · escritura no leída individualmente en este pase)

polígono_de_la_compra_Andes_Iron:
  buscado_en_data_room: SI
  encontrado_explicitamente: NO
  proxy_disponible: ESTANCIA_LA_HIGUERA_MATRIZ_2021.gpkg
  el_proxy_es_la_compra_andes_iron: NO_DEMOSTRADO
  observacion: "el polígono GPKG es regional · cubre 564.132 ha que excede 9.4× lo declarado por canon (60.000 ha)"
```

---

## 5 · Comparación de los 3 polígonos territoriales

| # | Polígono | Superficie | Origen | Vinculo con rol 24-5 |
|---|---|---|---|---|
| A | Plano MBN 1988 (3 hijuelas Jarpa) | 6.918 ha | DL 2695 saneamiento 1990 | NO directo · es la matriz histórica subdividida luego |
| B | Polígono canónico rol 24-5 | ~60.000 ha | canon HIJUELA2_v1 §3 | SI · es la afirmación a verificar |
| C | Proxy GPKG ESTANCIA_MATRIZ_2021 | 564.132 ha | dato territorial regional | NO se sabe |
| D | Perímetro RTK Hijuela 2 | 2.165 ha | levantamiento Daniel 2026 | NO · es Hijuela 2 enclave |
| E | Bbox ortofoto | 687 ha | super-overlay subido | NO · región de interés acotada |

**Geometrías comparadas anteriormente:**
- 0-0 cat 5 ⊂ C al 100% (P2.3)
- C ⊃⊃ B (proxy es 9.4× canónico)
- A ⊃ D (parcialmente · Hijuela 2 RTK ⊆ Hijuela 2 1988)
- B ⊂ C (relación supuesta · canónico debería estar dentro de regional)

**NO se puede afirmar:**
- B = C (proxy ≠ rol 24-5)
- A ⊂ B (no probado · el rol 24-5 podría haber crecido más allá del plano 1988)

---

## 6 · Matriz de confirmación final de H-1

```yaml
H_1:
  enunciado_original: "0-0 cat 5 podrian corresponder a partes no individualizadas del rol 24-5 Andes Iron"
  estado_post_P2_3: NO_DEMOSTRADA_pero_consistente
  estado_post_P2_4: NO_DEMOSTRADA · MULTIPLES_HIPOTESIS_ALTERNATIVAS_PLAUSIBLES

hipotesis_alternativas_emergentes_en_P2_4:
  
  H_2_exclusion_urbana:
    enunciado: "0-0 cat 5 pertenece a Límite Urbano La Higuera (exclusión I plano 1988, 115 ha)"
    plausibilidad: media
    test: georreferenciar plano MBN 1988 y cruzar con bbox ortofoto
    estado: pendiente
  
  H_3_exclusion_minera:
    enunciado: "0-0 cat 5 pertenece a Cía Minera Porvenir / Planta El Molle (exclusión L, 150 ha)"
    plausibilidad: media (el sector se llama 'El Molle' y aparece en toponimia local)
    test: cruzar polígono El Molle con bbox ortofoto
    estado: pendiente
  
  H_4_subdivisiones_intermedias_no_individualizadas:
    enunciado: "0-0 cat 5 son subdivisiones del Lote A o Lote B de Hijuela 2 que no recibieron rol propio"
    plausibilidad: baja-media
    test: revisar planos 1992 y 1996 (notas marginales fs. 4.531 y fs. 1.813)
    estado: pendiente

veredicto_global_de_H_1:
  NO_se_puede_falsar_ni_confirmar_definitivamente_con_datos_locales
  
  el_bloqueo_es: identidad_geometrica_del_rol_24_5
  
  vias_para_resolverlo:
    1. obtener_poligono_oficial_SII_rol_24_5: requiere consulta mapas.sii.cl (sin runtime)
    2. leer_escritura_inscripcion_Andes_Iron_2021_Rep_FS_313_N_14461: requiere PDF disponible en 01_LEGAL_TITULOS/Andes_Iron_Personeria (6 PDFs · no leídos individualmente)
    3. georreferenciar_plano_MBN_1988: trabajo QGIS pendiente Fase 12
    4. validacion_in_situ_con_Daniel: única vía con autoridad final
```

---

## 7 · Regla de diseño para Magnus Radar (sugerida por Custodio)

```yaml
hasta_que_P2_4_se_complete_con_poligono_real_rol_24_5:
  
  rol_0_0:
    titular: null
    naturaleza_juridica: null
    origen_cartografico: null
    etiqueta_visor: "sin individualizar"
    alerta_visor: "dentro de proxy Estancia La Higuera; titularidad actual no resuelta"
    
  caveat_visible_en_panel:
    el_0_0_categoria_5_podria_corresponder_a:
      - rol 24-5 Andes Iron (no demostrado)
      - exclusion I plano MBN 1988 · Límite Urbano La Higuera (no demostrado)
      - exclusion L plano MBN 1988 · Cía Minera Porvenir El Molle (no demostrado)
      - subdivisiones no individualizadas (no demostrado)
    estado: hipotesis_multiples_no_decidibles
```

---

## 8 · Reformulación del problema

**Antes de P2.4:**
> ¿El asentamiento detectado está sobre Hijuela 2 Cominetti?

P1 lo respondió: **NO catastralmente** (24-123 = 0 ha del cat 5)
P2.3 lo refinó: **NO afirmable como Andes Iron tampoco**

**Después de P2.4:**
> ¿Quién es realmente el titular jurídico actual del polígono donde está el asentamiento?

Y la respuesta más honesta posible con datos locales:

```yaml
respuesta_post_P2_4:
  no_es_Cominetti: HECHO (cero superficie en 24-123)
  no_es_Garcia_Huidobro: HECHO (poco overlap con 24-43)
  no_es_demostrablemente_Andes_Iron: HIPOTESIS_NO_RESUELTA
  podría_ser_exclusión_urbana_1988: HIPOTESIS_NUEVA_POST_P2_4
  podría_ser_exclusión_minera_El_Molle: HIPOTESIS_NUEVA_POST_P2_4
  podría_ser_subdivisión_no_individualizada: HIPOTESIS
  
  unica_certeza_documental:
    "el_polígono_está_dentro_del_área_geográfica_histórica_de_la_Estancia_La_Higuera"
  
  titular_actual_HOY: DESCONOCIDO
```

---

## 9 · Backlog post-P2.4 (priorizado)

```yaml
prioritario_inmediato:
  - leer_individualmente_6_PDFs_Andes_Iron_Personeria:
      objetivo: extraer deslindes inscripción 2021 (Rep FS 313 N°14.461)
      probabilidad_alta_de_resolver_H1: SI (es la escritura primaria de la compra)
      bloqueante: NO

medio_plazo:
  - georeferenciar_plano_MBN_1988:
      objetivo: ubicar exclusiones I, L, M sobre coordenadas WGS84
      utilidad: falsar H2 y H3
      bloqueante: NO · requiere trabajo QGIS (Fase 12 ya planificada)
  
  - consultar_mapas_SII_rol_24_5:
      objetivo: obtener polígono oficial vectorial
      bloqueante: requiere runtime con conexión SII

largo_plazo:
  - terreno_con_Daniel:
      objetivo: validacion in situ titularidad
      autoridad_resolutiva: maxima

mientras_tanto:
  - actualizar_regla_diseno_visor:
      rol_0_0_etiqueta: "sin individualizar"
      rol_0_0_alerta: "titularidad actual no resuelta"
      caveat_visible: lista_de_hipotesis_alternativas
```

---

## 10 · Resumen tablero

```yaml
EVT-H2-OCCUPATION-BASELINE-20260531:
  estado: P1+P2_1+P2_3+P2_4_completadas
  
P2_4_resultado:
  poligono_real_rol_24_5: NO_OBTENIDO
  evidencia_local_disponible: insuficiente para confirmar identidad geometrica
  hipotesis_emergentes_validas: 3 (H2 urbana · H3 El Molle · H4 subdivisiones)
  
nueva_dimension_del_problema:
  antes: rol_24_5_es_el_unico_candidato_para_los_0_0_cat_5
  ahora: hay_al_menos_3_candidatos_validos_no_decidibles_con_datos_locales

decision_pendiente_Custodio:
  - leer_6_PDFs_Andes_Iron_Personeria? (alta probabilidad de resolver via deslindes)
  - parar_acá_y_pasar_a_P2_2_reconstrucción_histórica?
  - validar_en_terreno_con_Daniel?
```
