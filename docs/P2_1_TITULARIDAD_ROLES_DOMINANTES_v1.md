# P2.1 · Titularidad roles dominantes de la zona ortofoto · 2026-05-31

**Disparador:** Custodio reformuló P2 de "identificar titulares" → "reconstruir identidad territorial"
**Pregunta fundamental:** ¿qué territorio es realmente Hijuela 2 según cada sistema de referencia y dónde empiezan a divergir?
**Disciplina:** hecho_documental / inferencia / hipótesis · sin inventar asociaciones

---

## 0 · Mapa de evidencia documental encontrada

| Rol | Denominación SII | Fuente disponible localmente |
|---|---|---|
| **24-5** | Estancia La Higuera (matriz envolvente) | CANON_HIJUELA2_v1.md (canonizado) |
| **24-42** | Estancia La Higuera Hij 1 Lt A | HousePricing antecedentes (PDF leído) |
| **24-43** | Estancia La Higuera Hij 1 Lt B | HousePricing antecedentes (PDF leído) |
| **24-122** | Quebrada Pelícano (casa urbana del pueblo) | HousePricing antecedentes (PDF leído) |
| **24-123** | Est. La Higuera Hj 2, Lotes A y B | CONSULTA_SII_ROL_24-123_COMINETTI.txt + canon |
| **24-160** | Est La Higuera Hij 2 Lt C | HousePricing antecedentes (PDF leído) + canon |
| **24-30** | NO encontrado en data room local | pendiente · ver §6 |
| **24-154** | NO encontrado en data room local | pendiente · ver §6 |
| **27-0** | NO encontrado en data room local | pendiente · ver §6 |

---

## 1 · Hallazgo central · Estancia La Higuera = Andes Iron (matriz envolvente)

Desde `CANON_HIJUELA2_v1.md` §3 (documento canónico ya consolidado):

```yaml
matriz_envolvente:
  entidad: "Estancia La Higuera"
  rol_sii: "24-5"
  superficie_aprox_ha: 60000
  titular: "Andes Iron SpA"
  rut: "76.097.759-4"
  adquisicion: "Rep FS 313 N°14.461 del 16-ago-2021"
  precio: "UF 273.292,2657"
  observacion: "Hijuela 2 Cominetti es enclave dentro de la matriz Andes Iron"
```

**Esto reescribe directamente la hipótesis errónea que yo había dejado abierta en D1.** En D1 había dicho "los 0-0 caen dentro del polígono Estancia La Higuera Matriz 2021 cuyo titular puede ser X". **Ahora es HECHO_DOCUMENTAL:** el dueño de la matriz Estancia La Higuera (rol 24-5) **es Andes Iron SpA**. Hijuela 2 Cominetti es enclave físico dentro de tierras Andes Iron.

---

## 2 · Hijuela 2 Cominetti · dos roles SII, un solo titular

### 2.1 · Rol 24-123 (Lotes A y B)

```yaml
rol_sii: "24-123"
denominacion_sii: "Est. La Higuera Hj 2, Lotes A y B"
superficie_sii_ha: 2640.93
suelo: "Clase 6 secano no arable"
destino: "Agrícola"
avaluo_total_clp: 480461232
contribuciones_semestrales_clp: 567878
deuda: 0
titulares_actuales:
  - { nombre: "Silvia María Cominetti Infanti", rut: "7.011.575-1", participacion: "18.75%" }
  - { nombre: "Claudia Cecilia Cominetti Infanti", rut: "7.011.576-K", participacion: "18.75%" }
  - { nombre: "Lidia Rosa Victoria Cominetti Infanti", rut: "6.349.740-1", participacion: "18.75%" }
  - { nombre: "Sucesión Bruno G. Cominetti Infanti", participacion: "18.75%", estado: "fallecido_sin_partir" }
  - { nombre: "Agrícola Cantera Limitada", participacion: "25.00%", origen: "dación pago Bruno G. Cominetti 23-ene-2023" }
estado: "comunidad hereditaria NO liquidada"
fuente: CONSULTA_SII_ROL_24-123_COMINETTI.txt + CANON_HIJUELA2_v1.md
```

### 2.2 · Rol 24-160 (Lote C)

```yaml
rol_sii: "24-160"
denominacion_sii: "EST LA HIGUERA HIJ 2 LT C"
superficie_sii_ha: 300.00   # 3.000.000 m²
suelo: "Clase 6 secano no arable"
destino: "Agrícola"
avaluo_total_clp: 54578641
contribuciones_semestrales_clp: 12980
deuda: 0
titular: "LIDIA ROSA VICTORIA COMINETTI IN Y OTROS"
ultima_transaccion_cbr:
  monto_uf: 286
  fecha_sii: "2022-12-28"
  fojas: "S/I"
  numero: "S/I"
  ano: "S/I"
  acto: "S/I"
fuente: HousePricing PDF (3 páginas leídas)
```

### 2.3 · Cadena de dominio Hijuela 2 (rol 24-123)

```yaml
cadena_dominio:
  1_saneamiento_DL_2695:
    titular: "Luis Emilio Jarpa Díaz de Valdés"
    inscripcion: "Fjs. 97 / Nº 91 / 1990"
    CBR: "La Serena"
    periodo: "1989-1990"
  2_transferencia_Jarpa_a_Cominetti:
    titular_origen: "Luis Emilio Jarpa Díaz de Valdés"
    titular_destino: "Bruno Luigi Cominetti Palini (RUT 3.157.372-6, fallecido)"
    naturaleza_acto: "DESCONOCIDA · ¿compraventa? ¿cesión derechos?"
    fecha: "DESCONOCIDA"
    fojas_numero_ano: "DESCONOCIDOS"
  3_herencia_2022:
    titular_origen: "Bruno Luigi Cominetti Palini (†)"
    titular_destino: "Lidia Rosa Victoria Cominetti Infanti Y OTROS"
    inscripcion_pose_efectiva: "2022-12-28"
    monto_uf: 265
    fojas_numero_ano_cbr: "S/I en HousePricing"
```

---

## 3 · Hijuela 1 · dos roles SII, un solo titular · NO Cominetti

### 3.1 · Rol 24-42 (Lote A)

```yaml
rol_sii: "24-42"
denominacion_sii: "ESTANCIA LA HIGUERA HIJ 1 LT A"
superficie_sii_ha: 620.00   # 6.200.000 m²
suelo: "Clase 6 + Clase 7 secano no arable"
destino: "Agrícola"
avaluo_total_clp: 78886813
contribuciones_semestrales_clp: 31300
deuda_actual_clp: 91822
propietario: "GARCIA HUIDOBRO SANFUENTES FELIP[E]"
ultima_transaccion_cbr:
  monto_uf: 1384
  fecha_sii: "2001-11-26"
  fojas_numero_ano: "S/I en HousePricing"
fuente: HousePricing PDF (3 páginas leídas)
```

### 3.2 · Rol 24-43 (Lote B)

```yaml
rol_sii: "24-43"
denominacion_sii: "ESTANCIA LA HIGUERA HIJ 1 LT B"
superficie_sii_ha: 1519.00   # 15.190.000 m²
suelo: "Clase 6 + Clase 7 secano no arable"
destino: "Agrícola"
avaluo_total_clp: 197282309
contribuciones_semestrales_clp: 151440
deuda_actual_clp: 77811
propietario: "GARCIA HUIDOBRO SANFUENTES FELIP[E]"   # mismo que 24-42
ultima_transaccion_cbr:
  monto_uf: 1384         # mismo precio que 24-42
  fecha_sii: "2001-11-26" # misma fecha
  fojas_numero_ano: "S/I"
fuente: HousePricing PDF (3 páginas leídas)
```

**Inferencia razonable** (no demostrada documentalmente aún): la coincidencia exacta de precio (UF 1.384) y fecha (26-11-2001) en los dos lotes de Hijuela 1 sugiere **única operación que transfirió ambos lotes a García Huidobro Sanfuentes en 2001**.

---

## 4 · Rol 24-122 · NO es rol rural mayor

```yaml
rol_sii: "24-122"
denominacion_sii: "QUEBRADA PELICANO PL 4410"
tipo: "Casa"
destino: "Habitacional"
m2_construccion: 36
m2_terreno: 7200
material: "Madera"
ano_construccion: 2000
propietario: "TRUJILLO PAEZ ALEJANDRO"
ubicacion_visual: "pueblo La Higuera (junto a Escuela Pedro Pablo Muñoz · CESFAM)"
avaluo_total_clp: 25202094
avaluo_exento_clp: 25202094  # totalmente exento (DFL-2)
fuente: HousePricing PDF (3 páginas leídas)
```

**Alerta de naming engañoso:** "Quebrada Pelícano" en el nombre del rol NO se refiere al cauce/territorio rural. Es la dirección/sitio de una casa habitacional en el pueblo cabecera. No confundir con la quebrada física.

---

## 5 · Síntesis cartográfica · 4 representaciones de "Hijuela 2"

```yaml
hijuela_2_segun_4_sistemas_de_referencia:
  
  catastral_SII:
    rol_24_123_LotesAyB:
      superficie_ha: 2640.93
      destino: agricola
    rol_24_160_LoteC:
      superficie_ha: 300.00
      destino: agricola
    TOTAL_catastral_SII: 2940.93 ha
    titular: "Comunidad Cominetti (5 cuotas)"
    estado: "comunidad hereditaria NO liquidada"
  
  juridico_consolidado_2017:
    resto_lote_A_ha: 863.00       # parte de rol 24-123
    resto_lote_B_ha: 976.35       # parte de rol 24-123
    lote_C_ha:        300.00       # rol 24-160
    TOTAL_juridico_consolidado: 2139.35 ha
    fuente: estudio_de_titulos_consolidado_2017
  
  mandato_Magnus_2026:
    superficie_declarada_ha: 1800
    clausula_excedente: "incorporación automática si estudios determinan mayor extensión"
    instrumento: "Repertorio N°24.327, 14-abr-2026"
    fuente: mandato_canonico_v1
  
  fisico_RTK_2026:
    superficie_calculada_ha: 2164.97
    fuente: PERIMETRO_CBR_DANIEL_RTK10M_V1_UTM19S_FIX.gpkg
    metodo: levantamiento_terreno_Daniel_Martinez
  
  divergencias:
    SII_vs_juridico_consolidado:    +801.58 ha (SII excede al jurídico)
    SII_vs_mandato:                 +1140.93 ha (SII excede mandato declarado)
    SII_vs_RTK:                     +775.96 ha (SII excede RTK físico)
    juridico_vs_RTK:                 -25.62 ha (jurídico menor que RTK por 1.2%)
    juridico_vs_mandato:            +339.35 ha (jurídico excede al mandato)
```

**Hallazgo metodológico (HECHO):** ya teníamos en el canon 4 representaciones de superficie. Lo que cambia con P1+P2.1 es que ahora también tenemos 4 representaciones del **perímetro** de Hijuela 2, con sus respectivos titulares cuando aplica.

---

## 6 · Lo que NO se pudo resolver en P2.1

### 6.1 · Roles dominantes sin ficha documental encontrada en data room

| Rol | Apareció en | Superficie agregada en zona ortofoto | Estado |
|---|---|---|---|
| 24-30 | Q00 cat 4 (33.7% del cuadrante) | 6.23 ha | propietario DESCONOCIDO |
| 24-154 | Q11 cat 5 | 1.34 ha | propietario DESCONOCIDO |
| 27-0 | Q22 cat 2 | 4.17 ha | propietario DESCONOCIDO · es rol con `predio = 0` patrón ya identificado en B1 |

### 6.2 · Rol 0-0 · DESCONOCIDO POR DISEÑO

Aplicando regla del Custodio: **no inferir naturaleza del 0-0 sin trazabilidad documental.**

```yaml
rol_0_0:
  superficie_en_zona_ortofoto: 89.80 ha (de 158.34 ha totales = 56.7%)
  superficie_en_categoria_5: 15.59 ha (de 22.63 ha = 68.9%)
  propietario: DESCONOCIDO
  naturaleza_juridica: DESCONOCIDA
  origen_cartografico: DESCONOCIDO
  
  hipotesis_NO_demostradas:
    H1_estancia_matriz_andes_iron: "el 0-0 corresponde a partes no individualizadas del rol 24-5 Andes Iron"
    H2_bienes_nacionales: "el 0-0 son tierras fiscales"
    H3_remanentes_no_individualizados: "subdivisiones SII pendientes"
    H4_artefacto_digitalizacion: "vacíos cartográficos de la capa vectorial"
  
  metodo_de_validacion_pendiente:
    - cruce_geometrico_polígono_24_5_Andes_Iron vs los 0-0 del bbox ortofoto
    - búsqueda_de_inscripción_BBNN o tierras_fiscales
    - revisión_de_los_22_GPKG_arqueados_para_capa_no_vista
```

---

## 7 · Respuesta a la pregunta fundamental del Custodio

> ¿Qué territorio es realmente Hijuela 2 según cada sistema de referencia y dónde empiezan a divergir?

```yaml
respuesta_consolidada:

  segun_SII_oficial:
    es: "los 2.940,93 ha catastralmente atribuidos a Comunidad Cominetti (24-123 + 24-160)"
    geometría: "polígonos del catastro KMZ-06 para ambos roles"
    titular: "5 herederos en comunidad NO liquidada"
  
  segun_estudio_titulos_2017_consolidado:
    es: "los 2.139,35 ha verificados por estudio de títulos"
    geometría: "posiblemente parcial · no perimetrado explícitamente en el data room"
    diferencia_vs_SII: "-801,58 ha (jurídico menor que SII)"
  
  segun_mandato_Magnus_2026:
    es: "1.800 ha declaradas · con cláusula de excedente"
    geometría: "no perimetrada por mandato · refiere al activo"
    diferencia_vs_juridico: "-339,35 ha (mandato menor que jurídico)"
  
  segun_perimetro_RTK_Daniel:
    es: "2.164,97 ha · perímetro físico medido en terreno"
    geometría: "polígono GPKG conocido"
    diferencia_vs_SII: "-775,96 ha (RTK menor que SII)"
    diferencia_vs_juridico: "+25,62 ha (RTK ligeramente mayor que jurídico)"

DONDE_DIVERGE:

  divergencia_1_dimensional:
    descripcion: "SII reporta 2.941 ha, jurídico 2.139 ha, mandato 1.800 ha, RTK 2.165 ha"
    rango: 1.141 ha de incertidumbre dimensional total
    implicacion: "no hay UN solo 'tamaño de Hijuela 2'"
  
  divergencia_2_perimetral:
    descripcion: "el RTK físico de Cominetti incluye 22,63 ha de asentamiento consolidado que catastralmente NO está en 24-123 ni 24-160 · está en 0-0 + roles menores"
    evidencia: P1 cruce 2026-05-31
    implicacion: "el perímetro que Cominetti reclama por terreno NO coincide con sus roles SII"
  
  divergencia_3_de_identidad_titular:
    descripcion: "el rol 24-43 (Hijuela 1 LtB) está físicamente vecino al RTK de Hijuela 2 y cubre Q01-Q03 con 53,95 ha en la zona ortofoto · pero su titular es GARCÍA HUIDOBRO SANFUENTES (no Cominetti)"
    implicacion: "una porción del territorio que el visor podría representar como zona Cominetti es jurídicamente de otra familia"

ESCENARIOS_NO_REDUCIBLES_HOY:
  
  escenario_A:
    enunciado: "RTK correcto · catastro SII incompleto"
    consecuencia: "el 0-0 son partes de Hijuela 2 Cominetti aún no individualizadas catastralmente"
    validacion_requerida: "estudio de títulos resolutivo sobre los 22,63 ha del 0-0 que caen en RTK"
  
  escenario_B:
    enunciado: "Catastro SII correcto · RTK excedió el predio Cominetti"
    consecuencia: "el RTK incluyó territorio que NO es de Cominetti (sería Andes Iron por 24-5 o García Huidobro por 24-43)"
    validacion_requerida: "verificación in situ de monolitos + comparación contra plano MBN 1988"
  
  escenario_C:
    enunciado: "Ambos parcialmente correctos · fragmentación histórica no resuelta"
    consecuencia: "el saneamiento integral requiere reconciliar capas SII/CBR/RTK/MBN_1988 en conjunto"
    validacion_requerida: "estudio multicapa orientado por la doctrina canónica del CANON v1"
```

---

## 8 · Implicación operacional para Magnus Radar / ITS

```yaml
visor_capa_titularidad:
  
  para_polígonos_catastrales:
    rol_24_123: { titular: "Comunidad Cominetti", participaciones: 5_cuotas, estado: "no_partida" }
    rol_24_160: { titular: "Comunidad Cominetti", participaciones: 5_cuotas, estado: "no_partida" }
    rol_24_42:  { titular: "García Huidobro Sanfuentes Felipe", participacion: 100%, fecha_adq: "2001-11-26" }
    rol_24_43:  { titular: "García Huidobro Sanfuentes Felipe", participacion: 100%, fecha_adq: "2001-11-26" }
    rol_24_122: { titular: "Trujillo Paez Alejandro", tipo: "vivienda_urbana_36m2_madera" }
    rol_24_5:   { titular: "Andes Iron SpA", rut: "76.097.759-4", fecha_adq: "2021-08-16", precio: "UF 273.292" }
    rol_24_30:  { titular: null, fuente_pendiente: "consulta_SII_o_HousePricing" }
    rol_24_154: { titular: null, fuente_pendiente: "consulta_SII_o_HousePricing" }
    rol_0_0:    { titular: null, naturaleza: null, origen: null }
  
  alerta_de_diseño:
    el_panel_lateral_NO_debe_mostrar:
      - "rol 0-0 → propietario X" (no se sabe)
      - "rol 24-43 → Cominetti" (es García Huidobro)
      - "RTK Cominetti = rol 24-123" (no coinciden geométricamente)
    
    el_panel_lateral_SI_debe_mostrar:
      - capa SII separada de capa RTK separada de capa jurídica
      - cuando coincidan, marcar coincidencia
      - cuando difieran, marcar divergencia + magnitud
      - permitir ver cada capa por sí sola
```

---

## 9 · Backlog actualizado tras P2.1

```yaml
P2_1_completada: con_evidencia_documental_local_disponible

pendientes_inmediatos_P2_2:
  - reconstruccion_historica_24_123: "saneamiento DL 2695 → Jarpa → ??? → Cominetti · falta la transferencia Jarpa→Cominetti"
  - buscar_fecha_y_acto_transferencia_Jarpa_Cominetti: ver carpeta 13_BUSQUEDA_CBR_1992_1994
  - reconstruir_24_43_y_24_42_pre_Garcia_Huidobro_2001: "¿de quién compró García Huidobro?"
  - identificar_titulares_24_30__24_154__27_0: consulta SII directa pendiente
  - verificar_rol_24_5_Andes_Iron_en_polígono_KMZ_06: ¿qué polígono físico corresponde al rol 24-5?

P2_3_falsable_propuesto:
  hipotesis_H_1_del_0_0:
    enunciado: "el 0-0 que cae en categoría 5 son partes del rol 24-5 Estancia Andes Iron NO individualizadas catastralmente"
    test: cruce geométrico polígono SII 24-5 vs los 15,59 ha de 0-0 categoría 5
    si_se_confirma: "saneamiento del asentamiento es problema Andes Iron + ocupantes · NO Cominetti directamente"
    si_se_refuta: "0-0 es otro origen · revisar BBNN o vacíos cartográficos"
  
  decisión_pendiente_Custodio:
    - ejecutar_P2_3_ahora?
    - o_ir_a_P3_lectura_individual_12_cuadrantes?
    - o_volver_a_terreno_con_Daniel_para_validar_perimetro_RTK?
```

---

## 10 · Disciplina aplicada · resumen control de calidad

```yaml
hecho_documental_extraido:
  - rol_24_123_titulares_5_cuotas_Cominetti: CANON + CONSULTA_SII
  - rol_24_160_titular_Cominetti_misma_lista: CANON + HousePricing
  - rol_24_43_titular_GarciaHuidobro: HousePricing
  - rol_24_42_titular_GarciaHuidobro: HousePricing  
  - rol_24_122_titular_TrujilloPaez_casa_36m2: HousePricing
  - rol_24_5_matriz_envolvente_AndesIron_60000ha: CANON
  - saneamiento_DL_2695_origen_Jarpa_1990: CANON + CONSULTA_SII

inferencia_razonable:
  - 24_42_y_24_43_misma_operacion_2001_UF1384: coincidencia exacta precio+fecha
  - 24_42_y_24_43_son_Hijuela_1_completa_2139ha: deriva de suma de superficies + denominación SII
  - hijuela_1_NO_es_Cominetti: deriva de propietario distinto en 24-42 y 24-43

hipotesis_abiertas:
  - naturaleza_juridica_del_0_0: no_demostrada
  - cardinalidad_real_24_123_vs_RTK: no_resuelta
  - composicion_real_del_perimetro_RTK_Cominetti: no_validada_in_situ

ningun_campo_de_titular_inventado: ✓
toda_evidencia_cita_fuente: ✓
divergencias_documentadas_explícitamente: ✓
nuevas_preguntas_emergentes_listadas: ✓
```

---

## Documentos canónicos asociados

| Archivo | Tipo | Estado |
|---|---|---|
| `magnus-radar/docs/CANON_HIJUELA2_v1.md` | doctrina canonizada | ✓ existente |
| `magnus-radar/docs/CRUCE_GEOMETRIA_ROL_SII_H2_v1.md` | reporte P1 | ✓ existente |
| `magnus-radar/docs/P2_1_TITULARIDAD_ROLES_DOMINANTES_v1.md` | este reporte | nuevo |
| `magnus-radar/docs/D1_CRUCE_MACRO_0_0_VS_CAPAS_LOCALES.md` | reporte D1 con HIPÓTESIS sobre 0-0 ahora REFINADA | requiere nota: matriz envolvente es Andes Iron rol 24-5 (no Estancia La Higuera Matriz 2021 como inferí) |
| `XPU/La Higuera/08_TASACIONES_AVALUOS/HOUSEPRICING_*.pdf` | fichas catastrales | 4 leídos · 6 disponibles · resto sin leer |
| `XPU/La Higuera/08_TASACIONES_AVALUOS/CONSULTA_SII_ROL_24-123_COMINETTI.txt` | consulta SII directa | ✓ leído completo |
