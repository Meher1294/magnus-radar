# Ingesta territorial ortofoto Hijuela 2 · ITS v1 · 2026-05-31

**Tipo:** ingesta supervisada por humano · disciplina epistemológica activa
**Fuente:** 6 KMZ super-overlay (`kmz higuera-{0-2}-{0-1}.kmz`) · 2.122 GroundOverlays
**Disparador:** prompt canónico Max + foco Hijuela 2 / saneamiento Daniel
**Control de calidad:** estado_epistémico explícito · rol_sii y propietario quedan null · backlog declarado

---

## FASE 1 · INVENTARIO DE COBERTURA

### 1.1 · Archivos recibidos

| KMZ | Tamaño | md5 | Overlays | Cuadrante geográfico |
|---|---|---|---|---|
| `kmz higuera-0-0.kmz` | 61 MB | `0c09cc1dd6...` | 467 | W=-71.2153, E=-71.2010, N=-29.5031, S=-29.5156 (NW) |
| `kmz higuera-0-1.kmz` | 46 MB | `0627e490c6...` | 335 | W=-71.2153, E=-71.2010, N=-29.5107, S=-29.5232 (SW) |
| `kmz higuera-1-0.kmz` | 43 MB | `cbe09eb72e...` | 408 | W=-71.2066, E=-71.1922, N=-29.5031, S=-29.5156 (NC) |
| `kmz higuera-1-1.kmz` | 63 MB | `15f0ab0f8f...` | 486 | W=-71.2066, E=-71.1922, N=-29.5107, S=-29.5232 (SC) |
| `kmz higuera-2-0.kmz` | 25 MB | `1853c3240d...` | 149 | W=-71.1978, E=-71.1835, N=-29.5031, S=-29.5156 (NE) |
| `kmz higuera-2-1.kmz` | 45 MB | `1dd57b8416...` | 277 | W=-71.1978, E=-71.1835, N=-29.5107, S=-29.5232 (SE) |
| **Total** | **283 MB** | — | **2.122** | grid 3 × 2 cuadrantes |

### 1.2 · Naturaleza del contenido

**HECHO OBSERVADO:** los 6 archivos son ortofotos teseladas tipo super-overlay (raster + LatLonBox). **Cero placemarks vectoriales · cero datos catastrales explícitos.**

### 1.3 · Cobertura geográfica consolidada

| Métrica | Valor |
|---|---|
| BBox global | W=-71.2153, E=-71.1835, S=-29.5232, N=-29.5031 |
| Extensión real | **3.1 km E-O × 2.2 km N-S = ~6.8 km²** |
| Resolución por tile | ~76 m × 76 m por tile en nivel máximo de zoom |
| Resolución por pixel | ~0.3 m/pixel (suficiente para distinguir techumbres, vehículos, animales) |

### 1.4 · Cobertura sobre referencias territoriales

| Referencia | Coordenada | Cubierta por la ortofoto |
|---|---|---|
| Hijuela 2 Cominetti (perímetro RTK G4) | bbox (-71.279, -29.537) a (-71.143, -29.488) | **Sí · 272 ha del predio (12.6 %)** |
| Pueblo La Higuera cabecera comunal | (-71.282, -29.510) | No · queda al oeste |
| Ruta 5 punto medio comuna | (-71.20, -29.45) | No · queda al norte |
| Quebrada Los Choros | (-71.30, -29.31) | No |

**Hallazgo Fase 1:** la ortofoto está focalizada sobre el **extremo oriental de Hijuela 2 Cominetti** · cubre exactamente la zona donde Daniel necesita verificar saneamiento.

---

## FASE 2 · DETECCIÓN DE OCUPACIÓN

### 2.1 · Estrategia

Mosaico de 846 tiles de máxima resolución · subdivisión en grilla 4×4 (16 cuadrantes de ~330×375 m c/u).
**4 cuadrantes leídos directamente** por observador humano (HECHO_OBSERVADO):
- Q00 (NW · cultivo + casas)
- Q11 (centro-norte · núcleo del asentamiento)
- Q22 (centro-sur · transición)
- Q33 (SE · árido sin ocupación)

**12 cuadrantes restantes** observados sólo desde mosaico panorámico (INFERENCIA).

### 2.2 · Hallazgos por estado epistémico

#### HECHO_OBSERVADO (6 observaciones · cuadrantes leídos directamente)

| ID | Cuadrante | Tipo | Cat | Conf | Observación |
|---|---|---|---|---|---|
| OCU-Q00-A | Q00 | cultivo_agrícola_organizado | 0 | 0.95 | Plantación en filas regulares · verde oscuro · ~0.5-1.0 ha · compatible con viñedo/frutal de riego |
| OCU-Q00-B | Q00 | agrupación_habitacional | 4 | 0.8 | ~10-15 estructuras con techumbre clara · trama irregular · accesos visibles |
| OCU-Q11-A | Q11 | asentamiento_consolidado | **5** | 0.92 | ~40-60 viviendas en cuadrante · trama de calles definida · vehículos visibles |
| INFRA-Q11-CANCHA | Q11 | infraestructura_comunitaria_cancha | 0 | 0.95 | Rectángulo verde con proporciones de cancha de fútbol |
| OCU-Q22-A | Q22 | estructuras_dispersas | 2 | 0.7 | Conjunto disperso en mitad superior · transición núcleo→árido |
| VACIO-Q33-A | Q33 | terreno_árido_sin_ocupación | 0 | 0.95 | Sin estructuras visibles · vegetación arbustiva dispersa |

#### INFERENCIA (12 observaciones · panorama panorámico)

| ID | Cuadrante | Tipo | Cat | Conf | Observación |
|---|---|---|---|---|---|
| OCU-Q01-A | Q01 | agrupación_habitacional | 4 | 0.7 | Continuación sur del asentamiento Q00/Q11 |
| VACIO-Q02-A | Q02 | árido_aparente | 0 | 0.7 | Sin estructuras visibles en panorama |
| VACIO-Q03-A | Q03 | árido_aparente | 0 | 0.75 | Bordes del vuelo · datos parciales |
| OCU-Q10-A | Q10 | asentamiento_consolidado | 5 | 0.8 | Densidad muy alta · extensión del núcleo Q11 hacia oeste |
| OCU-Q12-A | Q12 | agrupación_habitacional | 4 | 0.7 | Densidad media · transición núcleo→periferia este |
| OCU-Q13-A | Q13 | estructuras_dispersas | 1 | 0.6 | Pocas estructuras visibles · mayoría árido |
| OCU-Q20-A | Q20 | asentamiento_consolidado | 5 | 0.8 | Continuación sur del núcleo |
| OCU-Q21-A | Q21 | asentamiento_consolidado | 5 | 0.8 | Densidad alta · trama urbana continuada |
| GEO-Q22-CAUCE | Q22 | cauce_quebrada_seco | 0 | 0.9 | Línea sinuosa compatible con cauce · potencial riesgo aluvional |
| GEO-Q23-CAUCE | Q23 | cauce_quebrada_seco | 0 | 0.7 | Continuidad del cauce de Q22 |
| OCU-Q30-A | Q30 | agrupación_habitacional | 4 | 0.7 | Extensión SW del asentamiento |
| OCU-Q31-A | Q31 | estructuras_dispersas | 2 | 0.5 | Estructuras dispersas + camino + zona árida |
| VACIO-Q32-A | Q32 | árido_aparente | 0 | 0.65 | Sin ocupación visible · datos parciales |

**Disciplina aplicada:**
- NINGUNA detección marcada como "vivienda confirmada" (categoría 3) · no se distingue con seguridad techumbre + acceso + contexto habitacional unívocos a nivel individual desde ortofoto sin terreno
- Asentamiento_consolidado (categoría 5) sólo donde la densidad y trama urbana son claramente visibles
- Todo lo inferido del panorama marcado `requiere_validacion: true`
- Falsos positivos o cuadrantes con datos parciales marcados `estado: revisar_en_terreno`

---

## FASE 3 · CAPA DE OCUPACIÓN

### 3.1 · Resumen cuantitativo

| Categoría | Definición | N° features |
|---|---|---|
| 0 | no-residencial (cultivo · infraestructura · árido · cauce) | 8 |
| 1 | estructura aislada | 1 |
| 2 | vivienda probable | 2 |
| 3 | vivienda confirmada | **0** (disciplina activa · ninguna confirmada sin validación terreno) |
| 4 | agrupación habitacional | 4 |
| 5 | asentamiento consolidado | 4 |

### 3.2 · Estimación de viviendas (HIPÓTESIS · requiere validación)

Inferencia indirecta basada en densidad observada en Q11 (~40-60 techumbres en ~12 ha):

```yaml
estimacion_total_viviendas_zona_ortofoto:
  metodo: extrapolacion_por_densidad_en_cuadrantes_categoria_5
  cuadrantes_categoria_5: 4 (Q11, Q10, Q20, Q21)
  densidad_estimada_por_cuadrante: 40-60 techumbres
  total_estimado_nucleo: 160-240 estructuras
  
  cuadrantes_categoria_4: 4 (Q00, Q01, Q12, Q30)
  densidad_estimada_por_cuadrante: 10-30 techumbres
  total_estimado_agrupaciones: 40-120 estructuras
  
  GRAN_TOTAL_ESTIMADO_HIPOTESIS: 200-360 estructuras habitacionales
  estado: HIPOTESIS · requiere validacion terreno + conteo individual
  caveat: incluye estructuras no-habitacionales (galpones, comercios, bodegas)
```

**ESTADO EPISTÉMICO de la estimación:** HIPÓTESIS. Sólo Daniel + terreno puede validar el conteo real.

---

## FASE 4 · PREPARACIÓN PARA CRUCE CATASTRAL

### 4.1 · Geometrías exportadas

| Archivo | Formato | Features | Uso |
|---|---|---|---|
| `ocupaciones_h2_v1.geojson` | GeoJSON | 19 | software GIS (QGIS, ArcGIS, MapLibre, Leaflet) |
| `ocupaciones_h2_v1.kml` | KML | 19 | Google Earth, importable a Magnus Radar |
| `ocupaciones_h2_v1.csv` | CSV | 19 | hoja de cálculo, base de datos |

### 4.2 · Schema aplicado al GeoJSON

```json
{
  "id": "OCU-Q11-A",
  "tipo_observado": "asentamiento_consolidado",
  "categoria_ocupacional": 5,
  "confianza": 0.92,
  "estado_epistemico": "HECHO_OBSERVADO",
  "requiere_validacion": false,
  "fuente": "ORTOFOTO_KMZ_SUPEROVERLAY",
  "kmz_origen": "kmz higuera-{0-2}-{0-1}.kmz (6 archivos)",
  "cuadrante": "Q11",
  "observacion": "~40-60 viviendas...",
  "rol_sii": null,
  "propietario": null
}
```

**rol_sii y propietario están EXPLÍCITAMENTE null** · no se infieren · esperan cruce documental.

### 4.3 · Cruce preparatorio (info disponible, NO se afirma asociación)

Datos del catastro SII KMZ-06 ya conocidos para esta misma zona:

| Métrica | Valor |
|---|---|
| Roles SII presentes en el bbox ortofoto | 701 polígonos en 537 roles únicos |
| Único sector nombrado | "La Higuera" |
| Rol 24-123 (Hijuela 2 Cominetti) | 1.404 ha (18 % del rol) presente en la zona |
| Rol 24-43 (probable vecino) | 1.530 ha presentes |
| Roles 0-0 | 72 fragmentos · 88.7 ha |
| Roles repetidos con geometrías distintas | varios (B1 ya documentó 24-156, 180-1, etc.) |

**Pregunta abierta:** ¿qué rol(es) cubre(n) específicamente el asentamiento consolidado de Q10/Q11/Q20/Q21? Requiere cruce GeoJSON ↔ polígonos catastrales · NO ejecutado en este pase para preservar disciplina (rol_sii queda null).

---

## FASE 5 · MODELO DE TITULARIDAD FUTURA

### 5.1 · Estructura propuesta (vacía · sólo schema)

```yaml
geometria_observada:
  id: OCU-Q11-A
  tipo: asentamiento_consolidado
  evidencia_observacional: ortofoto_kmz_2026_05
  
catastro:
  rol_sii: null              # ← pendiente cruce
  cardinalidad: null         # 1, 1..n, no asignado
  sector_sii: null
  
titularidad:
  propietario: null          # ← pendiente CBR + estudio títulos
  fuente_documental: null    # repertorio, fojas, año
  fecha_inscripcion: null
  porcentaje_dominio: null
  
ocupacion:
  observada: si
  categoria: 5
  confianza: 0.92
  
riesgos:
  saneamiento: null          # ← pendiente cruce con rol + titular
  ocupacion_irregular: null  # ← pendiente determinar relación ocupante/titular
  conflicto_territorial: null
  
fuente:
  ortofoto: kmz_super_overlay_2026
  fecha_observacion: 2026-05-31
```

### 5.2 · Reglas de llenado

- `titularidad.propietario` **sólo se llena con fuente CBR / estudio de títulos** · NO con catastro SII
- `riesgos.saneamiento` **sólo se evalúa cuando rol_sii + propietario están confirmados** · si ocupación ≥ 4 y propietario ≠ ocupante → flag saneamiento_potencial
- `fuente.fecha_observacion` debe registrarse en cada ingesta para permitir cálculo de **delta territorial**

---

## FASE 6 · SALIDA MAGNUS RADAR

### 6.1 · Resumen ejecutivo · 10 hallazgos relevantes

1. **Existe asentamiento humano consolidado dentro del bbox de Hijuela 2 Cominetti.** Densidad alta · trama urbana · cancha de fútbol comunitaria. Estimado HIPÓTESIS: 160-240 estructuras en el núcleo Q10/Q11/Q20/Q21.

2. **La ortofoto cubre 12.6 % del perímetro Hijuela 2 (272 ha de 2.165 ha).** Está focalizada precisamente sobre el lado oriental donde el saneamiento es operacionalmente más urgente.

3. **Existe cultivo agrícola organizado (probable viñedo/frutal) en Q00** · ~0.5-1.0 ha · con sistema de riego implícito (filas verde oscuro contra fondo árido). HECHO_OBSERVADO.

4. **Cancha de fútbol comunitaria en Q11** · indicador fuerte de asentamiento con vida social institucionalizada (no transitoria). HECHO_OBSERVADO.

5. **Cauce de quebrada seco atraviesa Q22-Q23** · potencial riesgo aluvional · zona árida circundante. INFERENCIA · confianza media.

6. **Los 12 cuadrantes no leídos individualmente concentran 13/19 detecciones**. Requieren observación dirigida cuadrante por cuadrante para elevarlos de INFERENCIA a HECHO_OBSERVADO.

7. **NINGUNA vivienda marcada como "confirmada" (categoría 3)** · disciplina activa · sólo terreno con Daniel valida casa por casa.

8. **Cobertura ortofoto NO incluye el pueblo cabecera La Higuera** · el asentamiento detectado es un sub-sector distinto · su identificación toponímica formal requiere cruce con catastro o consulta a Daniel.

9. **Catastro SII tiene 701 polígonos en la zona ortofoto** (537 roles únicos · 72 fragmentos `0-0`). Densidad catastral alta consistente con asentamiento urbano-rural. Cruce NO ejecutado: `rol_sii` queda null.

10. **Sin DGA / BBNN / SNASPE locales** · el cruce contra capas estatales sigue parcial (heredado del experimento D1). El gap operacional persiste para validar naturaleza jurídica del territorio.

### 6.2 · Inventario de ocupaciones detectadas

```yaml
asentamientos_consolidados (cat 5): 4 cuadrantes  (Q10, Q11, Q20, Q21)
agrupaciones_habitacionales (cat 4): 4 cuadrantes (Q00, Q01, Q12, Q30)
viviendas_probables (cat 2): 2 cuadrantes         (Q22, Q31)
estructuras_aisladas (cat 1): 1 cuadrante         (Q13)
sin_ocupacion_aparente (cat 0): 5 cuadrantes      (Q02, Q03, Q23, Q32, Q33)

estimacion_total_estructuras_HIPOTESIS: 200-360
estimacion_terrenos_despejados: NO catalogada explicitamente
                                requiere lectura individual de cuadrantes airdos
infraestructura_comunitaria: 1 cancha de futbol (Q11)
infraestructura_productiva:  1 cultivo organizado ~0.5-1.0 ha (Q00)
```

### 6.3 · Zonas prioritarias de saneamiento

| Prioridad | Zona | Por qué | Acción sugerida |
|---|---|---|---|
| **1** | Núcleo Q10-Q11-Q20-Q21 | Mayor densidad observada · estructuras consolidadas · cancha = vida comunitaria | Cruce catastral urgente · ¿cae sobre rol 24-123 Hijuela 2 o sobre roles vecinos? |
| 2 | Q00 (cultivo) | Inversión productiva activa · indica titularidad o tenencia consolidada | Verificar quién es el agricultor · cruce con rol y propietario |
| 3 | Q22-Q23 (cauce) | Riesgo aluvional + ocupación dispersa adyacente | Verificar si hay viviendas en el cauce · zona de no construcción |
| 4 | 12 cuadrantes inferenciales | Validación pendiente · pueden esconder estructuras no detectadas | Lectura cuadrante por cuadrante en próxima iteración |

### 6.4 · Backlog explícito de integración

```yaml
backlog_critico:
  - cruzar_geojson_con_roles_sii_vectoriales:
      fuente: KMZ-06 catastro_municipal (ya disponible)
      objetivo: completar campo rol_sii por cada detección
      bloqueante: false (se puede ejecutar ya)
  
  - cruzar_con_titularidad_CBR_estudio_titulos:
      fuente: CBR Coquimbo + estudios de títulos del data room
      objetivo: completar campo propietario por cada rol
      caveat: rol_sii != propietario (B1 ya demostró)
      bloqueante: false (se puede ejecutar con docs ya disponibles)
  
  - validar_en_terreno_con_Daniel:
      objetivo: 
        1. confirmar conteo de viviendas por cuadrante
        2. distinguir vivienda vs galpón vs comercio
        3. identificar techumbre + acceso + contexto habitacional individual
        4. detectar estructuras NO visibles desde ortofoto (chozas pequeñas, ramadas)
      bloqueante: para promover features de cat 4-5 a cat 3 (vivienda confirmada)
  
  - comparar_contra_ortofoto_futura_para_delta_territorial:
      requisitos:
        - guardar la ortofoto actual como baseline 2026-05-31
        - re-volar el dron en X meses (sugerencia: cada 6 meses)
        - re-ejecutar este mismo pipeline con disciplina identica
      objetivo: detectar 
        - nuevas estructuras (delta_crecimiento)
        - estructuras demolidas (delta_baja)
        - cambios de uso (delta_uso)
        - presion de saneamiento expandida
  
  - completar_lectura_individual_de_12_cuadrantes_INFERENCIA:
      objetivo: promover INFERENCIA → HECHO_OBSERVADO
      bloqueante: false (puede hacerlo el agente con prompt explicito)

backlog_complementario:
  - obtener_capas_estatales_no_disponibles_localmente: 
      BBNN, DGA cauces, SNASPE, INE limites comunales, IGM hidrografia
  - arquear_comuna_comparativa_para_hipotesis_A:
      ¿el rol SII como etiqueta administrativa es sistémico o local?
  - definir_doctrina_separacion_ocupacion_vs_titularidad:
      operacionalmente necesaria para todo Meher OS (Daniel · Lex Meher · agente-territorial)
```

### 6.5 · Información faltante para producto final del visor

Para el caso de uso final (clic en geometría → ver rol + propietario + ocupación + evidencia + alertas):

| Componente | Estado | Falta |
|---|---|---|
| Geometría base (ortofoto) | ✓ disponible | guardarse como baseline |
| Detección de ocupación | ✓ v1 entregada | promover los 12 INFERENCIA a HECHO_OBSERVADO |
| Rol SII | ✗ | cruce geojson ↔ catastro KMZ-06 |
| Propietario | ✗ | cruce con CBR + estudios de títulos |
| Evidencia documental | parcial | requiere consolidación data room por rol |
| Alertas ITS | ✗ | depende de los 4 anteriores |

---

## Control de calidad final

```yaml
disciplina_aplicada:
  hecho_observado: 6   # cuadrantes leídos directamente
  inferencia: 13       # deducido de panorama
  hipotesis: 0         # ninguna afirmación que requiera cruce externo se trato como hecho
  
ningun_feature_marcado_como:
  vivienda_confirmada_categoria_3: 0   # disciplina explicita

falsos_positivos_o_dudas:
  marcados_como_revisar_en_terreno: 12

rol_sii_null_en_todas_las_features: 19/19  ✓
propietario_null_en_todas_las_features: 19/19  ✓
fuente_explicita_en_todas_las_features: 19/19  ✓
```

---

## Anexos (archivos generados)

| Archivo | Tipo |
|---|---|
| `INGESTA_ORTOFOTO_H2_ITS_v1.md` | este reporte |
| `ocupaciones_h2_v1.geojson` | 19 features con schema completo |
| `ocupaciones_h2_v1.kml` | 19 placemarks · importable a Google Earth / Magnus Radar |
| `ocupaciones_h2_v1.csv` | 19 filas · hoja de cálculo |
| `01_mosaico_general_3x2.png` | vista global 6 cuadrantes ortofoto · 1536×1024 |
| `02_mosaico_detalle_centro.png` | zoom núcleo asentamiento · 1371×1600 |
| `03_mosaico_detalle_norte.png` | zoom zona norte · 1200×1600 |
| `04_mosaico_detalle_sur.png` | zoom zona sur (árida) · 1600×1244 |
| `05_mosaico_asentamiento_amplio.png` | mosaico 31×35 tiles · 2125×2400 |
| `05b_mosaico_amplio_con_grilla.png` | con grilla 4×4 sobre cuadrantes |
| `cuadrante_QXY.png × 16` | imágenes individuales por cuadrante |
| `sub_tiles_meta.json` | metadata geográfica de los 16 cuadrantes |
| `mosaico_amplio_meta.json` | bbox + dimensiones del mosaico amplio |
| `tiles_inventory.json` (en /tmp/) | inventario completo 2.122 overlays |
