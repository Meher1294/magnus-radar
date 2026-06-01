# P2.5 · Lectura dirigida escritura Andes Iron · 2026-05-31

**Disparador:** Custodio autorizó P2.5 para buscar deslindes, cabida, planos referidos y predios incluidos de la compra Estancia La Higuera 2021 (Rep. FS 313 N°14.461)
**Resultado breve:** los 6 PDFs de `01_LEGAL_TITULOS/Andes_Iron_Personeria/` son **personería societaria** (constitución + modificaciones + poderes + certificados), **NO la escritura de compra Estancia La Higuera**. P2.5 no resolvió la pregunta central. Identificado dónde seguir buscando.

---

## 1 · Inventario inspeccionado

| Archivo | Tamaño | Páginas | Contenido confirmado |
|---|---|---|---|
| ADM-CER-LE-00006 | 218 KB | 14 | Certificado Reg. Comercio Stgo · sociedad Andes Iron SpA vigente al 11-jul-2025 (fs. 22578 N°15392 / 2010) |
| ADM-ESC-LE-000046 | 7.7 MB | 43 | **Constitución de "Minera Andes Iron Limitada"** · Rep. 7.175 · 15-mar-2010 · Notario Acharán Toledo · socios originales: Minería Activa Uno SpA + Minería Activa S.A. |
| ADM-ESC-LE-000048 | 4.8 MB | 26 | Escaneo sin OCR · probable escritura modificación societaria · NO leído individualmente en este pase |
| ADM-ESC-LE-000049 | 1.3 MB | 8 | Escaneo sin OCR · probable acta directorio o modificación menor · NO leído |
| ADM-ESC-LE-000050 | 165 KB | 1 | Certificado vigencia poder de Pedro Ducci Cornú al 10-jul-2025 (fs. 66699 N°28810 / 2023) |
| ADM-ESC-LE-000051 | 3.7 MB | 9 | PODER ESPECIAL Andes Iron SpA inscrito 1-ago-2023 (fs. 66699 N°28810 Reg. Comercio Stgo) |

**Conclusión inventario:** los 6 PDFs constituyen el **paquete de personería societaria** que respalda quién puede firmar en nombre de Andes Iron SpA. Es el dossier que la sociedad entrega al notario/CBR para acreditar representación en cualquier acto futuro. **No contiene la escritura de compra de la Estancia La Higuera.**

---

## 2 · Lo que P2.5 SÍ confirmó (HECHO_DOCUMENTAL)

```yaml
andes_iron_sociedad:
  fecha_constitucion: "2010-03-15"
  notario_constitucion: "María Gloria Acharán Toledo (Notaría 42ª Santiago)"
  repertorio_constitucion: "N° 7.175"
  razon_social_original: "Minera Andes Iron Limitada"
  socios_constituyentes:
    - "MINERÍA ACTIVA UNO SpA · RUT 76.150.054-K"
    - "MINERÍA ACTIVA S.A. · RUT 76.135.978-4"
  personas_que_los_representaron:
    - "Iván Patricio Garrido de la Barra · RUT 7.385.111-1 · geólogo"
    - "Pedro Ducci Cornú · RUT 12.345.678-? · ingeniero civil"
    - "José Antonio Jiménez Martínez · RUT 7.346.564-? · ingeniero comercial"
    - "Juan Paulo Bambach Salvatore · RUT 10.572.165-? · abogado"
  capital_inicial: "CLP 576.789.000"
  giro: "inversión y participación en derechos mineros · todas las fases (exploración, explotación, beneficio)"
  fuente: ADM-ESC-LE-000046.pdf (páginas 1-3 leídas)

complemento_con_ficha_societaria_ya_canonizada:
  transformacion_a_SpA: "2011-12-22"
  cambio_de_nombre: "Minera Andes Iron Limitada → Andes Iron SpA"
  control_actual: "Fondo Rucapangui + Andes Iron Ltd."
  capital_actual: "CLP 224.326.546.484 (~USD 240M)"
  rut: "76.097.759-4"
  inscripcion_reg_comercio: "fs. 22578 N°15392 / 2010"
```

---

## 3 · Lo que P2.5 NO resolvió (sigue abierto)

```yaml
preguntas_pendientes_post_P2_5:
  - escritura_de_compra_Estancia_La_Higuera_Rep_FS_313_N_14_461_2021_08_16:
      ubicacion_en_data_room: NO encontrada en Andes_Iron_Personeria
      probables_ubicaciones_alternativas:
        - 13_BUSQUEDA_CBR_1992_1994/00_RAW_RESTRINGIDO_CBRLS_2026-05-17/ (~17 fotos JPG)
        - 14_RECONCILIACION_ESTUDIO_TITULOS/ (mencionada en grep previo)
        - 15_ESTUDIOS_INFORMES/DUE_DILIGENCE_INTEGRAL_ESTANCIA_LA_HIGUERA_2026.docx
        - 02_MANDATOS_CONTRATOS/
        - no_estar_en_data_room: posible (CBR La Serena no descargado completo)
  
  - poligono_real_rol_24_5: NO obtenido
  - deslindes_compra_2021: NO leídos
  - cabida_compra_2021: NO leída
  - planos_referidos_en_escritura: NO identificados
  - predios_incluidos_en_la_compra: NO inventariados

la_pregunta_central_de_P2_4_sigue_abierta:
  ¿qué_polígono_real_representa_el_rol_24_5?
```

---

## 4 · Lectura del resultado

**P2.5 no resolvió la pregunta crítica.** Lo que sí entregó:

1. **Confirmación adicional** de la identidad jurídica de Andes Iron SpA (matriz societaria · representantes con facultades).
2. **Descarte** de una ubicación · `Andes_Iron_Personeria/` NO es donde está la escritura de compra Estancia La Higuera.
3. **Lista corta de ubicaciones probables** donde sí podría estar (carpetas 13, 14, 15, 02 del data room).
4. **Posibilidad real:** la escritura de compra Estancia La Higuera 2021 puede no estar digitalizada en el data room actual · habría que solicitarla a CBR La Serena (Rep. FS 313 N°14.461 / 2021).

---

## 5 · Estado de las hipótesis post-P2.5

```yaml
H1_0_0_es_rol_24_5_Andes_Iron:                     NO_DEMOSTRADA · sin cambio post-P2.5
H2_0_0_es_exclusion_urbana_1988:                   NO_DEMOSTRADA · sin cambio
H3_0_0_es_exclusion_minera_El_Molle:               NO_DEMOSTRADA · sin cambio
H4_0_0_es_subdivision_no_individualizada:          NO_DEMOSTRADA · sin cambio

ninguna_hipotesis_domina_post_P2_5
```

---

## 6 · Decisión de continuar o detener

```yaml
opciones_siguientes:

  A_continuar_busqueda_escritura_compra_Estancia_La_Higuera:
    objetivo: encontrar Rep. FS 313 N°14.461 en otras carpetas
    esfuerzo: medio (4 carpetas a explorar + posibles escaneos sin OCR)
    valor_si_se_encuentra: ALTO (resolvería H1 definitivamente con deslindes primarios)
    valor_si_NO_se_encuentra: medio (descarta ubicaciones)
  
  B_leer_DUE_DILIGENCE_INTEGRAL_ESTANCIA_LA_HIGUERA_2026:
    archivo: 15_ESTUDIOS_INFORMES/DUE_DILIGENCE_INTEGRAL_ESTANCIA_LA_HIGUERA_2026.docx
    objetivo: extraer síntesis ya realizada por XPU
    esfuerzo: bajo
    valor: alto · puede contener deslindes ya extraídos + referencia a la escritura
  
  C_leer_RECONCILIACION_ESTUDIO_TITULOS:
    archivo: 14_RECONCILIACION_ESTUDIO_TITULOS/ (múltiples MD)
    objetivo: extraer cabida y deslindes según estudio de títulos consolidado
    esfuerzo: medio
    valor: alto · es la fuente de autoridad jurídica intermedia
  
  D_parar_P2_y_pasar_a_validacion_terreno_con_Daniel_RTK:
    objetivo: única vía de autoridad final sobre identidad geométrica
    esfuerzo: requiere coordinación con Daniel · no ejecutable desde escritorio
  
  E_consultar_directamente_CBR_La_Serena:
    objetivo: obtener la escritura primaria de la compra
    esfuerzo: alto (gestión externa)
    valor: ALTO (autoridad jurídica primaria)
```

**Mi recomendación operacional para no quemar esfuerzo mal asignado:**

Opción **B + C** combinadas. Antes de seguir buscando la escritura primaria, leer el DUE DILIGENCE INTEGRAL y la RECONCILIACION ESTUDIO TITULOS · es muy probable que el equipo XPU ya haya extraído los deslindes y la cabida desde el estudio de títulos. Si están consolidados ahí, P2.4 se cierra parcialmente sin necesidad de leer la escritura primaria.

---

## 7 · Backlog actualizado

```yaml
prioritario_corto_plazo:
  - leer_DUE_DILIGENCE_INTEGRAL_2026 (opción B)
  - leer_RECONCILIACION_ESTUDIO_TITULOS (opción C)

medio_plazo:
  - buscar_Rep_FS_313_N_14461_en_carpetas_residuales (opción A si B y C no resuelven)
  - solicitar_CBR_La_Serena (opción E si todo lo anterior falla)

largo_plazo:
  - validacion_terreno_Daniel_RTK (opción D · única autoridad final)

mantener_regla_diseño_visor:
  rol_0_0:
    etiqueta: "sin individualizar"
    titular: null
    alerta: "titularidad actual no resuelta"
  Estancia_La_Higuera:
    SIEMPRE_calificar_la_fuente: matriz_Jarpa_1988 | canon_60000ha | proxy_GPKG | otro
```

---

## 8 · Reglas de nomenclatura aplicadas

Aplico la nomenclatura canonizada el 2026-05-31 por Custodio:

```yaml
referencias_en_este_reporte:
  SII: catastral (KMZ-06)
  CBR: jurídica (escrituras / fojas / repertorios / estudios consolidados)
  Daniel_RTK: física operacional (referente físico Daniel Martínez Zurita)
```
