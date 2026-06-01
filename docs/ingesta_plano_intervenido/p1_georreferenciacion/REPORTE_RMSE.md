# REPORTE_RMSE · P1 ITS-CARTO-PLANO-0001

**Estado:** ANDAMIAJE COMPLETO · ejecución pendiente del archivo de imagen del plano
**Fecha:** 2026-05-31

---

## 1. Por qué la georreferenciación no se ejecutó hoy

```yaml
condicion_de_ejecucion:
  archivo_imagen_plano_en_filesystem: NO disponible
  el plano fue entregado por Max via chat (image preview · no upload de archivo binario)
  el ambiente Linux sandbox no tiene acceso a la imagen para extraer pixels

lo_que_SI_se_dejó_listo:
  PUNTOS_CONTROL.geojson · 7 puntos de control con coordenadas UTM 19S
  plano_intervenido.png.points · archivo compatible QGIS Georeferenciador
  SUBLOTES_HISTORICOS_candidatos.geojson · geometrías catastrales actuales (KMZ-06)
  script_georreferenciar.py · script Python listo para ejecutar
  PUNTOS_CONTROL_pixels.csv (plantilla) · se autocrea al primer run del script
```

---

## 2. Cómo ejecutar P1 cuando se tenga el archivo de imagen

### Opción A · QGIS (recomendada · interactiva)

```bash
1. Guardar el plano como PNG/JPG/TIF en una ruta conocida
2. Abrir QGIS → Raster → Georreferenciador
3. Cargar el archivo de imagen del plano
4. Settings → Transformación → Polinomial 2do orden · CRS objetivo EPSG:32719
5. Importar el archivo .points generado:
   /sessions/.../p1_georreferenciacion/plano_intervenido.png.points
6. Para cada punto de control:
   - hacer click sobre el píxel correspondiente en el plano
   - QGIS rellena los pixels automáticamente
7. Iniciar georreferenciación · QGIS reporta RMSE y residuales
8. Exportar como GeoTIFF
```

### Opción B · script Python (no-interactiva)

```bash
1. Guardar el plano en alguna ruta accesible
2. Abrir el plano en algún visor de imagen (no QGIS) y anotar manualmente los pixels (X,Y) de cada PC
3. Llenar PUNTOS_CONTROL_pixels.csv con los pixels
4. Ejecutar:
   python3 script_georreferenciar.py /ruta/al/plano.png /ruta/salida.tif
5. El script genera REPORTE_RMSE.md actualizado + GeoTIFF
```

---

## 3. Puntos de control preparados (7 puntos)

| ID | Nombre | UTM 19S E | UTM 19S N | Confiabilidad |
|---|---|---|---|---|
| PC-01 | Pueblo de La Higuera (centroide) | 286.614 | 6.733.472 | alta |
| PC-02 | Vértice HR.1 plano IV-1-1777-S.R. | 287.008,86 | 6.735.557,19 | muy alta |
| PC-03 | Vértice HR.121 plano IV-1-1777-S.R. | 287.111,42 | 6.733.304,63 | muy alta |
| PC-04 | Estancia Maray (borde E) | 289.500 | 6.734.000 | media |
| PC-05 | Comunidad Quebrada Honda (borde S) | 286.500 | 6.730.500 | media |
| PC-06 | Portezuelo (esquina SO) | 285.500 | 6.729.200 | media |
| PC-07 | Cerro El Carbón (1470 m) | 290.200 | 6.732.600 | media |

```yaml
caveats:
  PC-02 y PC-03: coordenadas en datum PSAD56 según plano original
    transformar a WGS84 antes de georreferenciar (delta típico Coquimbo ~150-200 m E/N)
    si no se hace: residual sistemático ~150-200 m en estos puntos
  
  PC-04, PC-05, PC-06, PC-07: coordenadas aproximadas
    residual esperado: 100-300 m individual
    no usar como únicos puntos de control
```

---

## 4. Métricas de calidad esperadas

```yaml
RMSE_objetivo:
  excelente (promovible a canon estricto): <= 50 m
    razon: resolución del plano original 1:50.000 → 1 mm plano = 50 m terreno
  aceptable (visor operacional): <= 100 m
  marginal (necesita más puntos o ajuste): 100-200 m
  insuficiente: > 200 m

interpretacion_segun_RMSE:
  RMSE_<_50m:
    el plano es promovible a CANON operacional
    los polígonos 2a + 2b + C son comparables directamente con catastro SII 24-123 + 24-160
    se puede afirmar la correspondencia geometrica entre plano historico y estructura actual
  
  RMSE_50-100m:
    el plano es operacional para visor ITS / Magnus Radar como capa de contexto
    NO promovible a canon estricto
    la correspondencia con catastro requiere ajuste local o más puntos
  
  RMSE_>_100m:
    el plano sirve como ilustración historica
    NO sirve para overlay GIS preciso
    revisar: ¿plano deformado? ¿escala variable? ¿anotaciones a mano alzada?
```

---

## 5. Salidas esperadas post-ejecución

```yaml
PLANO_HISTORICO_GEOREF.tif:
  formato: GeoTIFF
  CRS: EPSG:32719 (UTM 19S WGS84)
  uso: overlay en QGIS / Magnus Radar / ITS visor

SUBLOTES_HISTORICOS.geojson (FUTURO · post-georreferenciación):
  polígonos: 1a, 1b, 2a, 2b, 3a, 3b, C
  fuente: vectorización manual sobre plano georreferenciado
  comparacion: superponer con SUBLOTES_HISTORICOS_candidatos.geojson (basado en KMZ-06)
  
  resultado_esperado:
    si superposicion > 90% del area: correspondencia plano↔catastro CONFIRMADA
    si superposicion 60-90%: muy consistente · canon graduado
    si superposicion < 60%: revisar identidad

PUNTOS_CONTROL.geojson:
  ya generado · sin cambios
  
REPORTE_RMSE.md (FUTURO):
  reemplaza este placeholder
  reporta RMSE final + residuales por punto + evaluacion
```

---

## 6. Archivos preparados en `p1_georreferenciacion/`

```yaml
generados_2026-05-31:
  SUBLOTES_HISTORICOS_candidatos.geojson:
    9 polígonos de catastro SII actual (24-42, 24-43, 24-123 ×2, 24-160)
    sirven como referencia de identidad CANDIDATA hasta que se georreferencie el plano
  
  PUNTOS_CONTROL.geojson:
    7 puntos con coordenadas UTM 19S y datum WGS84
    listos para usar como referencia en QGIS o script
  
  plano_intervenido.png.points:
    archivo de texto compatible con QGIS Georeferenciador
    los pixels (px, py) están en 0,0 hasta que el usuario haga click sobre la imagen
  
  script_georreferenciar.py:
    script Python listo para ejecutar (rasterio + numpy + pillow)
    autogenera plantilla PUNTOS_CONTROL_pixels.csv si no existe
    calcula RMSE + residuales + genera GeoTIFF
  
  REPORTE_RMSE.md (este archivo):
    placeholder hasta ejecución real
    contiene andamiaje + instrucciones de ejecución
```

---

## 7. Tabla canónica de correspondencia (estado AHORA · pre-georreferenciación)

| Correspondencia | Estado actual | Estado post-P1 esperado |
|---|---|---|
| 2a → 863 ha | Confirmada geométricamente en plano | sin cambio |
| 2b → 976 ha | Confirmada geométricamente en plano | sin cambio |
| C → 300 ha | Confirmada geométricamente en plano | sin cambio |
| 2a + 2b → Resto A+B Cominetti | Muy consistente | Confirmada si superposición > 90% con 24-123 |
| C → Rol 24-160 | Muy consistente | Confirmada si superposición > 90% con 24-160 |
| 2a + 2b + C → 2.139 ha operativas | Confirmado aritméticamente | sin cambio |
| 2a + 2b + C ↔ estructura jurídica Cominetti vigente | Pendiente georreferenciación | DEMOSTRADO si todas las superposiciones > 90% |

---

**Linkado:**
- [[ITS-CARTO-PLANO-0001_INGESTA]] (artefacto fuente)
- [[HISTORIA_ESTANCIA_HIJUELAS_LA_HIGUERA_v1]]
- [[EVT_H2_MAGNUS_MANDATO_20260414]]
- [[CADENA_REGISTRAL_HIJUELA_2]]
- [[Plano_MBN_IV-1-1777-SR_FICHA_DOCUMENTO]]
