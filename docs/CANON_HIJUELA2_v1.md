# CANON HIJUELA 2 — v1

**Versión canónica · 2026-05-31**
**Custodio:** Max Medina (Magnus SpA / XPU)
**Propósito:** documento canónico de referencia que consolida la doctrina, las representaciones geométricas, las superficies por capa, los conflictos abiertos y las autoridades resolutivas para la unidad territorial **Hijuela 2 de la Estancia La Higuera**. Reutilizable como plantilla para Dominga, Club Ecuestre, Mocito Guapo, Calera de Tango y otros expedientes territoriales complejos del grupo Meher.
**Documentos fuente:**
- `00_CORE/CADENA_REGISTRAL_HIJUELA_2.md` (v1.1 · 2026-05-17)
- `15_ESTUDIOS_INFORMES/DUE_DILIGENCE_INTEGRAL_ESTANCIA_LA_HIGUERA_2026.docx` (abril 2026)
- `04_PLANOS_CATASTRO/DataRoom_Cominetti_LaHiguera.kmz` (abril 2026 · superseded)
- `01_LEGAL_TITULOS/Plano_MBN_IV-1-1777-SR_Estancia_La_Higuera/`
- `11_EXPROPIACIONES_MOP/04B_OFFSET_TOPO_RTK/PERIMETRO_CBR_DANIEL_RTK10M_V1_UTM19S_FIX`
**No modifica:** Supabase, Airtable, frontend Magnus Radar. Documento doctrinal puro.

---

## 1 · Doctrina canónica adoptada

| # | Regla | Origen |
|---|---|---|
| 1 | No existe superficie única | Sesión 2026-05-31 |
| 2 | Toda superficie debe estar asociada a una capa | Sesión 2026-05-31 |
| 3 | La conciliación ocurre entre capas, no entre números | Sesión 2026-05-31 |
| 4 | Estudio de títulos consolidado = autoridad jurídica superior a SII para cabida | Sesión 2026-05-31 |
| 5 | SII conserva autoridad para rol, avalúo y contribuciones | Sesión 2026-05-31 |
| 6 | El objeto canónico no es el predio; es la unidad territorial estratificada con representaciones concurrentes | Sesión 2026-05-31 (emergente) |
| 7 | Ningún delta entre fuentes se cierra sin validación CBR / título / acto jurídico primario | `authority_hierarchy.md` v1.0 |
| 8 | No cargar al grupo canónico hasta verificar (mantener borradores en `_LABORATORIO`) | `CADENA_REGISTRAL` v1.1 |

---

## 2 · Jerarquía de autoridad de fuente

| Dominio | Fuente primaria | Fuente secundaria | Notas |
|---|---|---|---|
| **Fiscal** | SII oficial (mapas.sii.cl) | Data Inmobiliaria (proxy) | Rol, avalúo, contribuciones |
| **Jurídico bruto** | CBR La Serena | Notarías | Inscripciones, fojas, repertorios |
| **Jurídico consolidado** | Estudio de títulos consolidado | Informes periciales de deslindes | Cabida y titularidad efectiva |
| **Operacional físico** | RTK Daniel Martínez Zurita | Levantamiento Xpert Urban | Geometría medida en terreno |
| **Histórico** | Plano MBN IV-1-1777-S.R. (1988) | Plano N°531/1992 | Estado dominical histórico |
| **Doctrina del proyecto** | Evidencia canonizada (`13_BUSQUEDA_CBR_1992_1994/02_EVIDENCIA_CANONIZADA/`) | Notas temporales del laboratorio | Síntesis trabajada por equipo |

---

## 3 · Unidad territorial canónica

```yaml
unidad_territorial:
  id: hijuela_2_cominetti
  nombre: "Hijuela 2 de la Estancia La Higuera"
  territorio_padre: estancia_la_higuera
  comuna: 4102_la_higuera
  provincia: elqui
  region: coquimbo

  composicion_juridica_2017:
    - sub_unidad: resto_lote_a
      superficie_ha: 863.00
      rol_sii: parte de 24-123
      origen: subdivisión Lote A 1992 (plano N°531)
    - sub_unidad: resto_lote_b
      superficie_ha: 976.35
      rol_sii: parte de 24-123
      origen: resto post-venta Velásquez pre-1996
    - sub_unidad: lote_c
      superficie_ha: 300.00
      rol_sii: 24-160
      origen: subdivisión Lote A 1992 (plano N°531) — autónomo

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

---

## 4 · Representaciones geométricas concurrentes

Cada representación es una **descripción geométrica distinta** de la unidad territorial, NO versiones de una misma geometría. Coexisten todas. Ninguna sobrescribe a otra.

```yaml
representaciones_geometricas:

  - id: g1_plano_matriz_mbn_1988
    tipo: historica
    autoridad: regulatoria_publica
    fuente: "Plano MBN N°IV-1-1777-S.R."
    fecha: "1988-11"
    autor: "Heraclio Velásquez y Cía. / Ing. Geomensor Juan García V."
    escala: "1:50.000"
    datum: "PSAD56"
    desfase_conocido: "~500 m vs WGS84/SIRGAS (validado por monolitos Daniel Martínez)"
    superficie_declarada_ha: 2642
    vigencia: "histórica — referencia capa 1"
    archivo: "01_LEGAL_TITULOS/Plano_MBN_IV-1-1777-SR_Estancia_La_Higuera/"
    estado_extraccion: "georreferenciación pendiente Fase 12"

  - id: g2_plano_subdivision_531_1992
    tipo: juridica
    autoridad: juridica_publica
    fuente: "Plano N°531/1992 CBR La Serena"
    fecha: "1992-04"
    autor: "C.T. de López"
    deriva_de: "Plano MBN IV-1-1777-S.R."
    propietario: "Luis Emilio Jarpa Díaz de Valdés"
    contiene:
      - lote_a_hijuela_2: 1163 ha (subdivisión interna)
        sub:
          - lote_c: 300 ha (2.000 × 1.500 m)
          - resto_lote_a: 863 ha
      - lote_b_hijuela_2: 1479 ha (sin subdividir en este plano)
    vigencia: "jurídica vigente para subdivisión Lote A"
    estado_extraccion: "pendiente — pieza crítica Fase 13"

  - id: g3_kmz_dataroom_xpu_2026_04
    tipo: operacional_intermedia
    autoridad: operacional_privada
    fuente: "DataRoom_Cominetti_LaHiguera.kmz"
    fecha: "2026-04"
    autor: "XPU / Magnus"
    polígono: "25 vértices C-1 a C-26 (sin C-9)"
    extension: "12.4 km E-O × 5.0 km N-S"
    superficie_etiquetada_ha: 2640  # etiqueta sin cualificación de capa
    vigencia: superseded
    razon_supersede: "Anterior a CADENA_REGISTRAL_HIJUELA_2 (17-mayo-2026) y a RTK Daniel (mayo 2026); contiene errores documentales conocidos"
    errores_documentales:
      - propietarias: "dice 'Silvana, Fabiana, Uberlinda' — correcto: Silvia María, Claudia Cecilia, Lidia Rosa Victoria"
      - tipo_societario: "dice 'Agrícola Cantera SpA' — correcto: Agrícola Cantera Ltda."
      - cifra_sin_capa: "etiqueta '2.640 ha' sin distinguir capa fiscal vs operacional"
    conserva_valor:
      - "Evidencia histórica del proyecto"
      - "Capas auxiliares útiles: servidumbre InterChile, 9 concesiones mineras, zona productiva, tomas, infraestructura, riesgos"
    archivo: "04_PLANOS_CATASTRO/DataRoom_Cominetti_LaHiguera.kmz"

  - id: g4_rtk_daniel_2026_05
    tipo: medicion_rtk
    autoridad: operacional_privada
    fuente: "PERIMETRO_CBR_DANIEL_RTK10M_V1_UTM19S_FIX"
    fecha: "2026-05"
    autor: "Daniel Martínez Zurita (CNI 14.387.985-2, Magnus)"
    precision: "10 m"
    datum: "WGS84 UTM Zona 19S (EPSG:32719)"
    superficie_ha: 2164.97
    vertices: 77
    observacion: "Geometría reparada post auto-intersección (+1.64 ha vs 2.163.33 ha previo)"
    delta_vs_juridica_2017: "+25.62 ha (tolerancia medición real)"
    vigencia: "operacional actual"
    archivo: "11_EXPROPIACIONES_MOP/04B_OFFSET_TOPO_RTK/"
```

---

## 5 · Superficies declaradas — múltiples vigencias concurrentes

```yaml
superficies:

  s_historica_matriz_jarpa_1990:
    valor_ha: 2642.00
    autoridad: regulatoria_publica
    fuente: "Plano MBN IV-1-1777-S.R. (1988) + Res. SEREMI ST-102 (10-ene-1990)"
    composicion: "Lote A 1163 + Lote B 1479"
    estado: verificado
    capa_temporal: 1
    notas: "Cifra nominal del saneamiento DL 2.695. Base de cálculo histórica."

  s_juridica_consolidada_2017:
    valor_ha: 2139.35
    autoridad: juridica_consolidada
    fuente: "Adjudicaciones 2017 (Rep FS 694 N°26.309 + Rep FS 695 N°26.316)"
    composicion: "Resto A 863 + Resto B 976.35 + Lote C 300"
    estado: verificado
    capa_temporal: "1-4 acumuladas"
    notas: "Reduce 502.65 ha respecto a 1990 — explicado mayoritariamente por venta Velásquez pre-1996"

  s_operacional_rtk_2026:
    valor_ha: 2164.97
    autoridad: operacional_medicion_directa
    fuente: "RTK Daniel Martínez Zurita PERIMETRO_CBR_DANIEL_RTK10M_V1_UTM19S_FIX"
    estado: verificado
    capa_temporal: 5
    delta_vs_juridica: "+25.62 ha"
    notas: "Tolerancia de medición real vs cifra nominal escriturada"

  s_mandato_declarada_2026:
    valor_ha: 1800
    autoridad: contractual
    fuente: "Repertorio N°24.327, mandato Cominetti-Magnus, 14-abr-2026"
    estado: verificado
    notas: "Cifra declarada conservadoramente. Cláusula contempla incorporación automática del excedente si estudios determinan mayor extensión."

  s_fiscal_sii:
    estado: conflicto_documentado
    conflicto_id: SII_SURFACE_FACTOR_100
    valores_observados:
      - fuente: data_inmobiliaria_bq
        consultado_at: "2026-05-31"
        rol: "4102-24-123"
        campo: "superficie_total_terreno"
        valor_raw: 264093
        interpretacion_si_m2_valor_ha: 26.41
      - fuente: due_diligence_integral_2026
        rol: "24-123"
        valor_declarado_ha: 2640.93
        equivalente_m2_declarado: 26409300
    diferencia: "Factor exacto 100"
    hipotesis_abiertas:
      - "Bug ETL Data Inmobiliaria (divide /100 al cargar predios agrícolas)"
      - "Diferencia de unidad reportada (m² vs deci-m² vs ha)"
      - "Consulta a objetos distintos dentro del universo SII"
      - "Campo distinto leído por cada fuente"
    autoridad_resolutiva: sii_directo
    accion_requerida: "Consulta presencial / login mapas.sii.cl con RUT/Clave del titular"
    notas: "Hasta validar contra SII directo, NO declarar valor único."
```

---

## 6 · Cadena registral (resumen — detalle completo en CADENA_REGISTRAL_HIJUELA_2.md)

```yaml
cadena_dominical_esqueleto:
  - capa_temporal: 1
    año: 1990
    evento: "Saneamiento DL 2.695 a favor Luis Emilio Jarpa Díaz de Valdés"
    inscripcion: "fs. 97 N°91/1990 CBR La Serena"
    superficie_ha: 2642

  - capa_temporal: 2
    año: 1992
    evento: "Subdivisión interna Lote A (Lote C 300 + Resto A 863)"
    inscripcion: "Plano N°531/1992 + nota marginal fs. 4.531/1992"
    cierre_matematico: "1163 = 863 + 300 ✓"

  - capa_temporal: "pre-1996"
    evento: "Venta franja sur Lote B a Heriberto Humberto Velásquez Gallardo"
    superficie_estimada_ha: 502.65
    naturaleza: "pago en especie por servicios de agrimensura plano MBN 1988"
    estado: "explicación canónica del delta histórico"
    pendiente: "extraer escritura específica"

  - capa_temporal: 2
    año: 1996
    evento: "Compraventa Jarpa → Bruno Luigi Cominetti Palini (85%) + Virginia Castillo Iturriaga (15%)"
    inscripcion: "fs. 1.994 N°1.813/1996 (Rep FS 179 N°5.850)"
    notario: "Fernando Opazo Larraín (Santiago)"
    precio: "CLP 19.500.000"
    superficie_ha: 1839.35  # Resto A 863 + Resto B 976.35

  - capa_temporal: 3
    año: 2000
    evento: "Cesión Virginia Castillo → Bruno Luigi (15%)"
    inscripcion: "fs. 838 N°754/2000 (Rep FS 88 N°2.395)"
    precio: "CLP 13.000.000"

  - capa_temporal: 3
    año: 2006
    evento: "Paquete coordinado 21 planos (Plano General + 20 láminas)"
    inscripcion: "N°377-397/2006"
    relevancia: "probable motor geométrico vigente — pendiente extracción"

  - capa_temporal: 4
    años: "2011-2017"
    evento: "Expropiaciones MOP concesión Ruta 5 Norte"
    lotes: [319, 320, 331-1, 331-3, 333, 334, 335, 338-1]
    ministro_firmante: "Lawrence Golborne Riveros"
    magnitud: "decenas de hectáreas agregadas sobre 3 hijuelas (no centenares)"

  - capa_temporal: 2
    año: 2014
    evento: "Compraventa Bruno Luigi → Inversiones Cofanti Ltda."
    inscripcion: "Rep FS 209 N°7.711 + fs. 5.023 N°3.613 (Resto) + fs. 5.025 N°3.614 (Lote C)"
    notario: "Luis Poza Maldonado (Santiago)"
    precio: "CLP 25.000.000"
    rut_cofanti: "76.335.793-7"

  - capa_temporal: 2
    año: 2016-2017
    evento: "Disolución Cofanti + 4 adjudicaciones hermanos Cominetti Infanti"
    inscripciones:
      - "Silvia María (Resto, Rol 24-123): Rep FS 694 N°26.309/24-feb-2017"
      - "Bruno Guillermo (Lote C, Rol 24-160): Rep FS 695 N°26.316/27-feb-2017"
      - "Lidia Rosa Victoria: fs/N° pendiente cotejar"
      - "Claudia Cecilia: fs/N° pendiente cotejar"
    notarios: ["Pedro Reveco Hormazábal (Santiago)", "Valeria Ronchera Flores (Santiago, rectificación)"]
    publicacion: "Diario Oficial N°41.651 del 6-ene-2017"

  - capa_temporal: 6
    año: 2025
    evento: "Andes Iron compra sitio urbano Lote 32A pueblo La Higuera"
    inscripcion: "Rep FS 188 N°9.691/11-jun-2025"
    relevancia: "patrón penetración territorial fina post-RCA firme"

  - capa_temporal: 5
    año: 2026
    evento: "Mandato exclusivo Cominetti → Magnus"
    inscripcion: "Repertorio N°24.327/14-abr-2026"
    plazo: "24 meses"
    comision: "10% bruto"
```

---

## 7 · Conflictos abiertos · evidencia incompleta

Todos requieren resolución por autoridad superior. Ninguno se cierra unilateralmente.

```yaml
conflictos_abiertos:

  - id: SII_SURFACE_FACTOR_100
    descripcion: "DI BQ reporta 264.093 (=26.41 ha si m²) vs DD reporta 2.640,93 ha. Factor exacto 100."
    estado: conflicto_documentado
    autoridad_resolutiva: sii_directo
    accion: "Consulta presencial mapas.sii.cl rol 4102-24-123"
    impacto: "Define superficie fiscal canónica"

  - id: GAP_VENTA_VELASQUEZ_PRE_1996
    descripcion: "Venta franja sur Lote B (~502 ha) a Heriberto Humberto Velásquez Gallardo. Pago en especie por agrimensura plano MBN 1988."
    estado: conflicto_documentado
    autoridad_resolutiva: cbr_la_serena
    accion: "Búsqueda registral inscripción específica venta Velásquez pre-1996"
    impacto: "Cierra explicación del delta histórico 503 ha"

  - id: GAP_PLANO_22_1990
    descripcion: "Plano N°22 de 1990 CBR La Serena referenciado en anotación manuscrita plano MBN, no localizado físicamente en data room"
    estado: conflicto_documentado
    autoridad_resolutiva: cbr_la_serena
    accion: "Solicitud de copia certificada"
    impacto: "Detalle de subdivisión interna lotes"

  - id: GAP_EQUIVALENCIA_ROLES_24_4_24_123
    descripcion: "Planos servidumbre InterChile referencian roles antiguos 24-4 y 24-48. Equivalencia con actuales 24-123 y 24-160 no confirmada formalmente."
    estado: conflicto_documentado
    autoridad_resolutiva: sii_directo
    accion: "Certificado SII de historial de cambios de rol"
    impacto: "Continuidad de gravámenes InterChile sobre roles actuales"

  - id: GAP_FS_4531_1992
    descripcion: "Inscripción fs. 4.531/1992 mencionada como nota marginal — naturaleza exacta del registro (subdivisión vs transferencia) pendiente extracción"
    estado: conflicto_documentado
    autoridad_resolutiva: cbr_la_serena
    accion: "Extracción canónica de la inscripción"

  - id: GAP_FS_924_644_1994
    descripcion: "Servidumbre 924-644/1994 — titular del predio dominante pendiente identificar"
    estado: conflicto_documentado
    autoridad_resolutiva: cbr_la_serena

  - id: GAP_NOMBRE_VELASQUEZ
    descripcion: "Discrepancia textual: 'Heraclio Humberto' (adjudicación 2017) vs 'Heriberto Humberto' (compraventa 1996). Posible discrepancia documental o error de lectura."
    estado: conflicto_documentado
    autoridad_resolutiva: cbr_la_serena
    accion: "Cotejo de las dos inscripciones originales"

  - id: KMZ_IDENTIDAD_PROPIETARIAS
    descripcion: "KMZ G3 lista 'Silvana, Fabiana, Uberlinda Cominetti Palini'. Correcto según CADENA: Silvia María, Claudia Cecilia, Lidia Rosa Victoria Cominetti Infanti."
    estado: superseded_por_cadena_registral
    autoridad_resolutiva: cadena_registral_v1_1
    accion: "Regenerar KMZ canónico cuando se actualice data room visual"

  - id: KMZ_TIPO_SOCIETARIO
    descripcion: "KMZ G3 lista 'Agrícola Cantera SpA'. Correcto: Agrícola Cantera Ltda."
    estado: superseded_por_cadena_registral
    autoridad_resolutiva: cadena_registral_v1_1

  - id: DD_VS_CADENA_TRANSFERENCIA_JARPA
    descripcion: "DD declara 'transferencia Jarpa → Bruno Cominetti Palini DESCONOCIDA (gap documental)'. CADENA_REGISTRAL la documenta como compraventa 1996 a Bruno + Virginia."
    estado: superseded_por_cadena_registral
    autoridad_resolutiva: cadena_registral_v1_1

  - id: NOTARIO_NAME_ACHURRA_VS_ACHARAN
    descripcion: "DD escribe 'María Gloria Achurra Toledo'. CADENA escribe 'María Gloria Acharán Toledo'."
    estado: conflicto_documentado
    autoridad_resolutiva: notaria_directa
    accion: "Verificación nombre exacto vía registro de notarías"

  - id: GAP_PLANOS_377_397_2006
    descripcion: "Paquete coordinado de 21 planos (N°377-397/2006) — probable motor geométrico real vigente, contenido no extraído"
    estado: conflicto_documentado
    autoridad_resolutiva: cbr_la_serena
    accion: "Extracción Plano General N°377-2006 (1/21) + serie completa"
    impacto: "Define geometría escriturada vigente"

  - id: DD_VS_CADENA_FOJAS_5613_VS_5023
    descripcion: "DD cita 'Escritura N°5.613/2014' para compraventa Cofanti. CADENA cita 'fs. 5.023 N°3.613/2014 (Resto) + fs. 5.025 N°3.614/2014 (Lote C)' con Rep FS 209 N°7.711/2014."
    estado: conflicto_documentado
    autoridad_resolutiva: cbr_la_serena
    accion: "Verificación de inscripción real"
```

---

## 8 · Doctrina superior emergente — para Meher OS / ITS

```yaml
doctrina_emergente_its:

  ontologia_propuesta:
    territorio:
      ejemplo: "Estancia La Higuera"
      contiene: [unidades_territoriales]

    unidad_territorial:
      ejemplo: "Hijuela 2 Cominetti"
      contiene: [representaciones_geometricas, superficies, cadena_registral, conflictos_abiertos]

    representacion_geometrica:
      tipo: [historica, juridica, operacional_intermedia, medicion_rtk]
      autoridad: source_authority_enum
      vigencia: [vigente, superseded, en_construccion, descalificada]

    superficie:
      asociada_a: capa_temporal
      autoridad: source_authority_enum
      estado: [verificado, conflicto_documentado, declarada_sin_verificar, superseded]
      conflicto_id: opcional

    conflicto_abierto:
      estado: conflicto_documentado
      autoridad_resolutiva: enum
      accion_requerida: text
      impacto: text
      nunca_se_cierra_sin: ["cbr_validation", "titulo_primario", "acto_juridico_resolutivo"]

  reglas_no_negociables:
    - "El objeto canónico no es el predio; es la unidad territorial estratificada con representaciones concurrentes"
    - "Ninguna fuente sobrescribe a otra"
    - "Ningún delta se cierra sin validación CBR/título/acto jurídico primario"
    - "No cargar al grupo canónico hasta verificar (mantener borradores en _LABORATORIO)"
    - "Toda cifra debe explicitar capa y autoridad"

  reutilizable_en:
    - dominga_andes_iron
    - club_ecuestre
    - mocito_guapo
    - calera_de_tango
    - cualquier_expediente_territorial_complejo
```

---

## 9 · Próximas acciones (fuera de este documento)

1. **NO modificar Supabase / Magnus Radar todavía**. El frontend mantiene capa XU + capa SII como está. Cualquier referencia a Hijuela 2 debe cualificar capa.

2. **Resolver `SII_SURFACE_FACTOR_100` primero**. Una consulta presencial en mapas.sii.cl con tu RUT/Clave zanja el conflicto en minutos.

3. **Extraer Plano General N°377-2006** (1/21) — pieza con mayor potencial explicativo del estado geométrico vigente.

4. **Búsqueda registral CBR** de inscripción venta Velásquez pre-1996 (cierra el delta histórico de 503 ha definitivamente).

5. **Recién después de los pasos 2-4**, evaluar si conviene migrar el modelo de Supabase a la ontología `territorio → unidad_territorial → representaciones_geometricas + superficies + conflictos_abiertos`. Ese cambio es estructural y aplica a múltiples proyectos del grupo, no solo La Higuera.

6. **Registrar esta doctrina en Meher OS / ITS** como pieza canónica reutilizable.

---

## 10 · Notas de versión

- **v1.0** · 2026-05-31 · Build inicial Max Medina + asistente IA. Consolida CADENA_REGISTRAL_HIJUELA_2 (v1.1) + DUE_DILIGENCE_INTEGRAL_2026 + KMZ DataRoom (superseded) + RTK Daniel + sesión de diseño 2026-05-31. Adopta modelo de múltiples geometrías + múltiples superficies. Declara SII_SURFACE_FACTOR_100 como conflicto abierto. Marca KMZ G3 como superseded sin eliminar. Propone ontología `territorio → unidad → capas` como doctrina emergente para Meher OS / ITS.
