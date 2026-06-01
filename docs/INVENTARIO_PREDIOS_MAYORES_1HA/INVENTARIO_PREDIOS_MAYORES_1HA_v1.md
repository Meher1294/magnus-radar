# INVENTARIO PREDIOS MAYORES 1 HA · v1 · La Higuera

**Fecha:** 2026-05-31
**Cambio de fase:** Max autorizó el pivote desde matching individual planilla↔catastro (BLOQUEADO) hacia inventario de objetos territoriales mayores (los que afectan saneamiento, ocupaciones, servidumbres, energéticos, Dominga, Andes Iron, Cominetti, García Huidobro, Fisco, Municipalidad, El Molle y futuros negocios Magnus).
**Pueblo cabecera:** estado `caracterizacion_base_completada` · congelado (TRACK 1 cerrado).
**Fuente primaria:** KMZ-06 catastro SII (`La_Higuera_UTF8.kmz` · 7687 placemarks · canónico verificado por DIFF_KMZ_06_VS_09).

---

## 1. Universo del inventario · HECHO_OBSERVADO

```yaml
catastro_SII_total: 7687 polígonos · 417,542 ha
filtro_aplicado: superficie >= 1 ha
predios_resultantes: 885 polígonos (11.5% del catastro)
superficie_agregada: 415,054 ha (99.4% del territorio comunal)
predios_descartados_<_1ha: 6802 (0.6% del territorio)

distribucion_por_tamaño:
  1-5 ha:        601 predios
  5-10 ha:       47
  10-50 ha:      95
  50-100 ha:     31
  100-500 ha:    55
  500-1k ha:     24
  1k-5k ha:      18
  5k-10k ha:     6
  10k-50k ha:    5
  50k-100k ha:   3  ← los 3 macro-fiscales

regla_canonica:
  11.5% de los polígonos cubren 99.4% del territorio
  la regularización, saneamiento, servidumbres y oferta inmobiliaria de Magnus se decide aquí
```

---

## 2. Schema canónico por predio

```yaml
predio:
  uuid: identificador estable (md5 de rol+centroide · 12 chars)
  rol_sii_actual: rol vigente en KMZ-06 canónico
  alias_historicos[]: roles previos documentados (P2.8 mutación · etc)
  superficie_ha: calculada en UTM 19S (no en grados)
  titular_documental: HECHO documental verificable (escritura · canon · plano MBN)
  estado_titularidad:
    CONFIRMADO_canon
    CANDIDATO_pendiente_validacion
    HIPÓTESIS
    DESCONOCIDO
    AMBIGUO
    NO_INVESTIGADO
    BLOQUEADO
    ANOMALIA_GEOGRAFICA
  tipo:
    fiscal
    privado
    comunidad
    minera
    municipal
    desconocido
  conflictos[]: conflictos abiertos (C13, mutación, dispersión, etc)
  hipotesis[]: hipótesis sobre identidad/tamaño/uso · NO promovibles a hecho
  fuentes[]: documentos primarios que respaldan
  tier: 1 / 2 / 3 (prioridad operacional Magnus)
  centroide_wgs: (lon, lat) para visor
```

---

## 3. Distribución por TIER

| Tier | Predios | Superficie | % del territorio |
|---|---|---|---|
| **Tier 1** | 8 | 196,321 ha | 47.0% |
| **Tier 2** | 49 | 191,734 ha | 45.9% |
| **Tier 3** | 828 | 26,999 ha | 6.5% |
| **TOTAL >= 1 ha** | 885 | 415,054 ha | 99.4% |

**Lectura:** 57 polígonos (Tier 1 + 2) concentran 93% del territorio. Magnus tiene ahí su universo estratégico real.

---

## 4. TIER 1 · 8 predios prioritarios

```yaml
T1_predios:
  
  80-0:
    superficie: 82,678.85 ha (19.8% comuna · el polígono más grande)
    tipo: fiscal
    titular_documental: BLOQUEADO · presumible Estado/Fisco
    estado_titularidad: HIPÓTESIS
    fuentes: QUALITY_SCAN_CATASTROSII §2
    accion_validacion: consulta BBNN + revisión plano MBN comunal
    
  79-1:
    superficie: 58,350.60 ha (14.0% comuna)
    tipo: fiscal
    titular_documental: BLOQUEADO · presumible Estado/Fisco
    estado_titularidad: HIPÓTESIS
    fuentes: QUALITY_SCAN
    accion_validacion: consulta BBNN

  1075-1:
    superficie: 51,165.36 ha (12.3% comuna)
    tipo: fiscal
    titular_documental: BLOQUEADO · rol con manzana >1000 (presumible costero/fiscal)
    estado_titularidad: HIPÓTESIS
    fuentes: QUALITY_SCAN
    accion_validacion: consulta BBNN + revisión costera DGTM

  24-123_polygon_A:
    superficie: 1,399.93 ha
    tipo: privado
    titular_documental: Cominetti (Resto Lotes A+B Hijuela 2)
    estado_titularidad: CONFIRMADO_canon
    alias_historicos: [24-48]
    fuentes: CANON_HIJUELA2_v2 + Escritura Cofanti Rep 25.963 + P2.8
    conflictos: superficie_catastral_disputada (2,301 ha SII vs 1,839 ha Cofanti)
    accion_validacion: cruce con plano MBN IV-1-1777-SR

  24-43_polygon_A:
    superficie: 1,241.76 ha
    tipo: privado
    titular_documental: candidato Hijuela 1 Jarpa
    estado_titularidad: CANDIDATO_pendiente_validacion
    fuentes: task #7 cruce_geometria_rol_sii_v1
    hipotesis: cadena dominical post-Pablo Jarpa 1988
    accion_validacion: cruce CBR La Serena para titularidad vigente

  24-123_polygon_B:
    superficie: 901.71 ha
    tipo: privado
    titular_documental: Cominetti (Resto Lotes A+B Hijuela 2)
    estado_titularidad: CONFIRMADO_canon
    nota: segunda parte del rol 24-123 (Lote A o Lote B individualizado en catastro)

  24-160:
    superficie: 299.18 ha
    tipo: privado
    titular_documental: Cominetti (Lote C Hijuela 2)
    estado_titularidad: CONFIRMADO_canon
    alias_historicos: [24-4]
    fuentes: CANON_HIJUELA2_v2 + Cofanti + P2.8
    conflictos: ninguno
    nota: superficie 299 ha SII coincide razonablemente con 300 ha Cofanti

  24-43_polygon_B:
    superficie: 283.14 ha
    tipo: privado
    titular_documental: candidato Hijuela 1 Jarpa
    estado_titularidad: CANDIDATO_pendiente_validacion
    accion_validacion: cruce con polygon A para verificar continuidad o separación
```

---

## 5. TIER 1 · IDENTIDADES PENDIENTES (Max nombró · NO identificadas en KMZ-06)

```yaml
identidades_pendientes_Tier_1:
  
  Andes_Iron (rol canon 24-5):
    estado_KMZ_06: 0 polígonos · NO APARECE
    fuentes_documentales: CANON_HIJUELA2_v1 §3 + Rep FS 313 N°14.461 (2021) + cadena 1986-2021
    conflictos: C13 (predio fiscal fs.4856 N°4411/2007 puede coincidir parcial)
    accion: verificar si rol 24-5 está vigente · cruce con escrituras 2021 + reasignación SII post-2021
    impacto_critico: confirma doctrina-rol-sii-no-es-identidad-territorial
  
  Garcia_Huidobro:
    estado_KMZ_06: BLOQUEADO · sin referencia en data room
    fuentes_documentales: NINGUNA accesible localmente
    accion: oficio a Cominetti (cliente) para identificar rol y ubicación
    nota: Max lo nombró como Tier 1 · presumir relevancia alta
  
  Fisco_predio_Totoralillo_Norte (fs.4856 N°4411/2007 CBR La Serena):
    estado_KMZ_06: BLOQUEADO · sin matching directo
    fuentes_documentales: ESC-GT-000011 (Notario Villarino 2025) + C13
    hipotesis: puede coincidir con uno de los macro-bloques 0-0 grandes
        candidato_principal: poligono_0-0 8,375 ha centroide (-71.20, -29.59) o 4,261 ha (-71.25, -29.65)
    accion: cruce documento ESC-GT-000011 deslindes + plano MBN IV-1-5964 CR 2007
```

---

## 6. TIER 2 · 49 predios · macro-bloques + canon ya identificados

```yaml
Tier_2_no_0_0_top_15:
  49-13:    34,321.44 ha   (no identificado · macro rural)
  80-1:     20,318.44 ha   (vecino 80-0 fiscal · presumible misma matriz)
  78-2:     10,227.65 ha   (macro-bloque rural)
  49-13:    8,671.27 ha    (duplicado · CONSOLIDACIÓN_INCOMPLETA del rol 49-13)
  28-5:     6,684.21 ha
  79-13:    5,301.22 ha    (vecindad 79-1 fiscal · serie 79-x relacionada)
  79-12:    5,112.81 ha    (idem)
  79-11:    5,032.87 ha    (idem)
  28-3:     3,878.50 ha
  33-1:     2,605.62 ha
  51-21:    2,075.98 ha
  28-3:     2,048.10 ha    (duplicado · CONSOLIDACIÓN_INCOMPLETA)
  79-16:    1,611.99 ha
  79-10:    1,470.85 ha
  79-8:     1,400.55 ha

Tier_2_polígonos_0_0_grandes (23 polígonos · ≥100 ha · 70.000 ha agregados):
  0-0:     30,672.32 ha   centroide (-71.13, -29.49)  ← gigante de los 0-0
  0-0:     19,192.74 ha   centroide (-70.62, -29.53)
  0-0:     8,375.53 ha    centroide (-71.20, -29.59)
  0-0:     4,261.01 ha    centroide (-71.26, -29.65)
  0-0:     2,148.51 ha    centroide (-70.96, -29.18)
  0-0:     1,696.43 ha    centroide (-70.56, -29.47)
  0-0:     1,444.77 ha    centroide (-71.24, -29.47)
  0-0:     824.94 ha      centroide (-71.13, -29.34)
  0-0:     732.94 ha      centroide (-71.18, -29.33)
  0-0:     664.61 ha      centroide (-71.24, -29.58)
  (+ 13 más entre 100-700 ha)

identidades_pendientes_Tier_2:
  El_Molle (Compañía Minera Porvenir · Ugarte/Brito):
    fuente: Plano MBN IV-1-1777-SR exclusión L · 150 ha
    deslinde: sur Lote b Hijuela 2 Jarpa
    pista_geografica: UTM 287000 E, 6733000 N aprox (sur centroide H2 Lote b)
    accion: cruce geográfico con KMZ-06 en esa zona · identificar rol
  
  CMP (Cía Minera del Pacífico):
    fuente: intel Dominga + Corporativo Andes Iron (referencias dispersas)
    accion: oficio CMP o consulta SERNAGEOMIN
  
  Municipalidad_La_Higuera:
    fuente: Plano MBN IV-1-1777-SR exclusiones E (cementerio 1.19 ha) + M (18.12 ha plano IV-1-881-SR)
    accion: oficio DOM Municipal + consulta plano IV-1-881-SR
```

---

## 7. Hipótesis estructural del territorio comunal

```yaml
si_se_acepta_macro_fiscal_hipotesis:
  3 polígonos (80-0 + 79-1 + 1075-1) = 192,194 ha = 46% comuna
  son hipotéticamente Estado/Fisco
  validación: oficio BBNN + revisión SNASPE/SAG
  
si_se_acepta_serie_79_relacionada_fiscal:
  79-1 + 79-8/10/11/12/13/16 + 80-0 + 80-1 = ~213,000 ha = 51% comuna
  serie de manzanas 79-80 ESTADO probable
  validación: cruce con BBNN + plano comunal

si_se_acepta_0_0_grandes_son_fiscales:
  23 polígonos 0-0 ≥ 100 ha = 70,000 ha = 16.7% comuna
  posibilidades: BNUP rural · zonas no individualizadas catastralmente · cauces · cumbres
  validación: cruce con BBNN + DGA (cauces) + SNASPE

agregado_hipotetico_de_fiscalidad_no_validada:
  47% (macro Tier 1) + 16.7% (0-0 grandes) + serie 79-80 adicional ≈ 60-65% de la comuna fiscal/Estado
  esto es CONSISTENTE con el patrón de comunas costeras de Atacama / Coquimbo
  pero requiere validación documental específica

no_promover_como_hecho_sin_consulta_BBNN
```

---

## 8. PAUTA DANIEL RTK · reformulada (1 día campo)

```yaml
mision_anterior_OBSOLETA:
  validar 70 viviendas sin CBR + 70 polígonos 0-0 pueblo (matching planilla↔catastro)

mision_nueva_AUTORIZADA_Max:
  validar perímetros de predios mayores · 5 prioridades · 1 día

PRIORIDAD_RTK_1 · Hijuela 2 Cominetti (24-123 + 24-160):
  objetivo: cerrar deslinde norte/sur/este/oeste del polígono catastral
  superficie_a_recorrer: 2,600 ha (3 polígonos)
  puntos_RTK_minimos: 12-20 vértices del polígono catastral
  pregunta_critica:
    el polígono catastral 24-123 (2,301 ha) ¿coincide con plano MBN 1988 (2,642 ha Lote a+b Jarpa H2)?
    diferencia de 341 ha · ¿es derivada o catastral?
  output: poligono_RTK_H2_canonico.geojson · usable para canon definitivo

PRIORIDAD_RTK_2 · Hijuela 1 candidato (24-43):
  objetivo: validar identidad H1
  superficie: 1,525 ha (2 polígonos)
  puntos_RTK: 10-15 vértices + cruce con H2 (vecino)
  pregunta_critica: ¿es continuo o separado? ¿coincide con 2,139 ha Pablo Jarpa H1?

PRIORIDAD_RTK_3 · Sector El Molle:
  objetivo: identificar geográficamente el predio Cía Minera Porvenir (Ugarte/Brito · 150 ha)
  puntos_RTK: deslinde sur H2 + vertices visibles del predio El Molle
  output: rol SII identificado + perímetro RTK + cruce con plano MBN IV-1-1777-SR exclusión L
  desbloquea: GAP_DESLINDE_EL_MOLLE del canon vigente

PRIORIDAD_RTK_4 · Sector Totoralillo Norte fiscal (C13):
  objetivo: validar predio fiscal fs.4856 N°4411/2007 + servidumbre Andes Iron 223.35 ha
  puntos_RTK: deslindes según ESC-GT-000011 + verificación con plano MBN IV-1-5964 CR 2007
  output: resolver C13 · confirmar si es 0-0 grande o tiene rol asignado

PRIORIDAD_RTK_5 · frontera cat5 con perímetro RTK H2:
  objetivo: validar dónde termina el asentamiento urbano y dónde empieza H2 rural
  puntos_RTK: 5-10 puntos en la transición (entre Q11 y Q20/Q21)
  pregunta_critica: las viviendas del cat5 están dentro o fuera del polígono RTK H2?
  desbloquea: estrategia regularización (PMB urbano vs Art 55 LGUC rural)

reordenamiento_segun_logistica_terreno:
  RTK_1 (H2) + RTK_5 (frontera cat5) son adyacentes · día 1 mañana
  RTK_2 (H1) + RTK_3 (El Molle) son adyacentes · día 1 tarde
  RTK_4 (Totoralillo Norte) requiere desplazamiento norte · día 2 dedicado

valor_estimado:
  1 día RTK cierra: canon H2 + canon H1 + identidad El Molle + frontera cat5
  retorno_señal/esfuerzo: extremadamente alto
  costo: 1 día Daniel + procesado
```

---

## 9. Síntesis con disciplina HECHO / INFERENCIA / BLOQUEADO

```yaml
HECHOS_OBSERVADOS_canonizables:
  1. 885 predios catastrales >= 1 ha cubren 99.4% del territorio comunal
  2. 8 predios Tier 1 + 49 Tier 2 = 93% del territorio en 57 polígonos
  3. 4 polígonos identificados como Cominetti H2 confirmado canon: 24-123 (2 polígonos = 2,301 ha) + 24-160 (299 ha)
  4. 2 polígonos identificados como H1 candidato: 24-43 (1,242 + 283 = 1,525 ha)
  5. 3 macro-fiscales hipotéticos: 80-0, 79-1, 1075-1 = 192,194 ha (46% comuna · presumible Estado)
  6. 23 polígonos 0-0 >= 100 ha = 70,000 ha (16.7% comuna · sin individualización)
  7. Rol canon Andes Iron 24-5 NO aparece en KMZ-06 · refuerza doctrina-rol-sii-no-es-identidad-territorial

INFERENCIAS_validas:
  1. Magnus opera estratégicamente sobre 57 polígonos · NO sobre 7687
  2. Cominetti H2 catastralmente está plenamente representado (2,301+299 = 2,600 ha · canon 2,642 ha plano MBN)
  3. La concentración 93% en 57 polígonos confirma estructura de pocas matrices + macro-fiscales
  4. La serie 79-80 (manzanas adyacentes) es probable matriz fiscal Estado

BLOQUEADOS:
  1. Identidad de los 49 predios Tier 2 sin canon (incluye 49-13, 80-1, 28-5, serie 79-x)
  2. Identidad de los 23 polígonos 0-0 grandes
  3. Rol SII de García Huidobro (Max nombró · sin referencia en data room)
  4. Rol SII de El Molle (Cía Minera Porvenir · 150 ha · deslinde sur H2)
  5. Rol SII de CMP (Compañía Minera Pacífico)
  6. Identificación geográfica del predio fiscal Totoralillo Norte (C13)
  7. Validación de hipótesis macro-fiscal (80-0 + 79-1 + 1075-1) sin oficio BBNN

ACCIONES_DE_DESBLOQUEO_ranked:
  A1. RTK Daniel · 5 prioridades · 1-2 días campo (output: canon H2 + H1 + El Molle + Totoralillo Norte + frontera cat5)
  A2. Oficio BBNN · solicitar listado de predios fiscales en comuna La Higuera (1-2 semanas)
  A3. Consulta CBR La Serena · titularidad vigente de los 4 polígonos Cominetti + 2 H1 candidato (1 semana)
  A4. Oficio Cominetti · identificar rol SII de García Huidobro
  A5. Oficio SERNAGEOMIN · identificar concesiones mineras vigentes en serie 79-80 y macro-fiscales
```

---

## 10. Estado de cierre y siguiente fase

```yaml
TRACK_1 (CBR planilla × KMZ-06): CERRADO
PUEBLO_CABECERA: congelado en caracterizacion_base_completada
FASE_VIGENTE: INVENTARIO_PREDIOS_MAYORES_1HA · v1

next_phase_options:
  
  opcion_A · RTK Daniel campo (operacional):
    coordinar agenda Daniel · pauta de 5 prioridades lista
    output esperado: canon H2 + H1 cerrado
    
  opcion_B · oficio BBNN (administrativo):
    redactar carta solicitud listado predios fiscales La Higuera
    output esperado: validar hipótesis macro-fiscal 80-0/79-1/1075-1
    
  opcion_C · D4 ocupación visual + cruce predios mayores (analítico):
    cruzar las 19 ocupaciones ortofoto vs los 8 predios Tier 1
    output esperado: mapa de "qué Tier 1 está ocupado · qué está limpio"
    
  opcion_D · investigación García Huidobro (documental):
    oficio Cominetti + búsqueda CBR + cruce escrituras vecinas
    output esperado: identificar rol SII García Huidobro
```

---

**Datos derivados:**
- `predios_1ha_inventario_v1.json` (885 predios con schema completo)
- `predios_1ha_inventario_v1.csv` (tabla plana navegable)
- `predios_1ha_raw.json` (raw del parse · sin enriquecimiento)

**Linkado:**
- [[CANON_HIJUELA2_v2]]
- [[QUALITY_SCAN_CATASTRO_SII_LA_HIGUERA]]
- [[DIFF_KMZ_06_VS_09_CATASTRO_SII]]
- [[D3_TRACK1_CBR_PLANILLA_VS_KMZ06_v1]] (predecesora · cerrada)
- [[D3_NEXT_Q22_Q12_Q02_y_FILA_INFERIOR_H2_v1]]
- [[doctrina-rol-sii-no-es-identidad-territorial]] (refuerza con Andes Iron 24-5 no presente en KMZ-06)
- [[doctrina-no-derivar-estrategia-sin-capa-ocupacion]]
- [[doctrina-unidad-territorial-estratificada]]
- [[proyecto-hijuela-2-cominetti]]
- [[proyecto-magnus-radar]]
