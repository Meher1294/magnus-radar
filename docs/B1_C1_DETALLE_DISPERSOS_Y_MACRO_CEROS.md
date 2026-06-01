# B1 + C1 · Detalle dispersos y macro-bloques 0-0 · 2026-05-31

**Tipo:** read-only · inventario detallado para decisión arquitectónica
**Disparador:** Max redirigió a B1+C1 antes de DWG/PDF · cuello de botella conceptual (predio/rol/geometría), no documental
**Estado:** sin canonizar nada · evidencia para evaluación

---

## B1 · Los 87 roles dispersos · clasificación

### Criterios

| Patrón | Definición |
|---|---|
| **legítima** | dist_max < 1.5 km · CV áreas < 0.5 · suma > 5 ha |
| **ambigua** | distancia 1.5–3 km o CV moderado |
| **altamente_anómala** | dist_max > 3 km o CV > 1.5 |

### Distribución

| Patrón | N° roles | Superficie | % superficie dispersos |
|---|---|---|---|
| legítima | 2 | 65.64 ha | 2.2 % |
| ambigua | 65 | 307.20 ha | 10.1 % |
| **altamente_anómala** | **20** | **2.667.99 ha** | **87.7 %** |
| Total | 87 | 3.040.83 ha | 100 % |

### Top 20 por superficie

| Rol | N° | suma_ha | CV | dist_med | dist_max | extensión | patrón |
|---|---|---|---|---|---|---|---|
| 180-121 | 4 | 1.243.25 | 1.22 | 4.419 m | 7.532 m | 9.6 × 10.5 km | altamente_anomala |
| 24-156 | 6 | 966.91 | 0.87 | 20.408 m | 30.123 m | 21.9 × 24.3 km | altamente_anomala |
| 53-401 | 2 | 199.90 | 1.41 | 2.583 m | 2.583 m | 2.2 × 3.5 km | ambigua |
| 24-4 | 3 | 186.88 | 1.55 | 6.091 m | 6.164 m | 7.3 × 2.3 km | altamente_anomala |
| 49-24 | 62 | 59.07 | 1.63 | 759 m | 2.590 m | 1.4 × 2.8 km | altamente_anomala |
| 67-0 | 65 | 51.02 | 2.27 | 729 m | 2.334 m | 1.9 × 1.9 km | altamente_anomala |
| 66-0 | 92 | 45.33 | 0.19 | 458 m | 1.457 m | 1.0 × 1.6 km | **legítima** |
| 49-348 | 2 | 44.14 | 1.39 | 1.247 m | 1.247 m | 1.6 × 1.5 km | ambigua |
| 180-1 | 2 | 35.57 | 1.37 | 36.788 m | 36.788 m | 35.2 × 13.1 km | altamente_anomala |
| 43-0 | 12 | 26.99 | 2.93 | 440 m | 1.250 m | 1.8 × 0.7 km | altamente_anomala |
| 1490-0 | 23 | 24.65 | 2.30 | 321 m | 1.519 m | 1.3 × 1.7 km | altamente_anomala |
| 100-0 | 19 | 20.31 | 0.06 | 309 m | 889 m | 0.8 × 0.9 km | **legítima** |
| 49-344 | 7 | 18.45 | 2.15 | 368 m | 1.133 m | 1.5 × 1.5 km | altamente_anomala |
| 49-0 | 6 | 15.77 | 0.76 | 7.693 m | 7.831 m | 8.0 × 2.0 km | altamente_anomala |
| 33-7 | 29 | 15.28 | 4.32 | 220 m | 668 m | 0.8 × 0.6 km | altamente_anomala |
| 49-333 | 20 | 13.35 | 0.64 | 220 m | 668 m | 0.7 × 0.6 km | ambigua |
| 181-0 | 7 | 10.86 | 1.97 | 730 m | 1.594 m | 1.6 × 1.4 km | altamente_anomala |
| 27-0 | 25 | 5.23 | 3.49 | 167 m | 475 m | 0.6 × 0.4 km | altamente_anomala |
| 33-3 | 9 | 3.69 | 2.12 | 446 m | 768 m | 0.9 × 0.5 km | altamente_anomala |
| 165-1 | 7 | 2.89 | 0.11 | 224 m | 569 m | 0.7 × 0.2 km | ambigua |

### Casos críticos · evidencia incompatible con "fragmentación cartográfica"

- **24-156**: 6 fragmentos a hasta 30 km entre sí · extensión 22 × 24 km · cubre prácticamente toda la comuna en 6 polígonos físicamente separados con el mismo rol SII
- **180-1**: 2 fragmentos a 36.8 km · están en extremos opuestos del catastro · imposible que sean el mismo predio
- **180-121**: 4 fragmentos en bbox de 9.6 × 10.5 km · CV 1.22 · áreas dispares

Estos 3 roles solos suman 2.245 ha (74 % de la superficie anómala). Imposible explicarlos como fragmentación: son **distintos predios físicos con número de rol reutilizado**.

### Veredicto B1

**El rol SII en La Higuera NO es identificador geográfico único.** Es etiqueta administrativa que el catastro reutiliza para predios físicamente separados. El cambio de modelo propuesto:

```yaml
de:    rol_sii → 1 geometría
hacia: rol_sii → conjunto_de_geometrias  (potencialmente disperso)
```

El fenómeno NO es marginal en términos de peso territorial (88 % de la superficie en dispersos) pese a que la mayoría de casos individuales son ambiguos (no extremos).

---

## C1 · 23 macro-bloques 0-0 (>100 ha) · 74.070 ha = 92.7 % de la masa 0-0

### Inventario detallado

| # | Área (ha) | Vertices | Sector nombrado | Dist a R5 | Centroide lng,lat |
|---|---|---|---|---|---|
| 1 | 30.766.04 | 1.287 | (vacío) | 13.5 km | -71.0607, -29.5367 |
| 2 | 19.269.36 | 1.886 | (vacío) | 53.7 km | -70.6456, -29.4865 |
| 3 | 8.401.09 | 543 | (vacío) | 0.3 km | -71.1969, -29.6056 |
| 4 | 4.274.03 | 458 | (vacío) | 6.4 km | -71.2659, -29.6504 |
| 5 | 2.155.82 | 121 | (vacío) | 24.8 km | -70.9452, -29.1866 |
| 6 | 1.702.65 | 372 | (vacío) | 62.6 km | -70.5544, -29.4754 |
| 7 | 1.449.32 | 77 | (vacío) | 3.9 km | -71.2399, -29.4649 |
| 8 | 827.61 | 135 | (vacío) | 6.6 km | -71.1324, -29.3417 |
| 9 | 735.29 | 527 | (vacío) | 1.2 km | -71.1874, -29.3331 |
| 10 | 666.70 | 348 | (vacío) | 4.5 km | -71.2464, -29.5734 |
| 11 | 643.47 | 806 | **Quebrada Los Choros** | 9.8 km | -71.3006, -29.3066 |
| 12 | 612.53 | 148 | (vacío) | 9.3 km | -71.1046, -29.3536 |
| 13 | 413.11 | 1.070 | **Quebrada El Pelicano** | 34.1 km | -70.8493, -29.2352 |
| 14 | 315.70 | 524 | **Quebrada Choros Altos** | 1.6 km | -71.1840, -29.3909 |
| 15 | 296.38 | 748 | **Quebrada Agua Grande** | 13.7 km | -71.0588, -29.4077 |
| 16 | 290.56 | 767 | **Quebrada Los Choros** | 29.4 km | -70.8971, -29.3867 |
| 17 | 288.71 | 187 | (vacío) | 57.2 km | -70.6104, -29.4615 |
| 18 | 242.19 | 329 | **Quebrada Los Choros** | 19.3 km | -71.0012, -29.3676 |
| 19 | 160.54 | 745 | **Quebrada Los Choros** | 45.7 km | -70.7290, -29.4646 |
| 20 | 159.57 | 21 | (vacío) | 11.1 km | -71.3139, -29.3115 |
| 21 | 148.48 | 113 | (vacío) | 13.7 km | -71.3405, -29.2508 |
| 22 | 133.89 | 12 | (vacío) | 3.1 km | -71.2324, -29.5231 |
| 23 | 117.46 | 388 | **PASAJE INTERIOR** | 15.6 km | -71.3601, -29.2590 |

### Patrón estructural en C1

1. **7 de los 23 nombran quebradas explícitamente** (1.821 ha). El catastro incluye cauces de quebrada como predios "0-0". NO son propiedad privada individualizable. Son geografía natural.

2. **4 quebradas son `Quebrada Los Choros`** (#11, #16, #18, #19 · suma 1.336 ha) · **zona territorial del proyecto Dominga**. Cruce directo con inteligencia Andes Iron.

3. **15 de los 23 (77 % de la masa = 57.267 ha) están a >8 km de Ruta 5** · interior profundo / cordillera / costa lejana. Probable: áreas fiscales / bienes nacionales / no edificables.

4. **3 bloques (#3, #14, #22) están a <2 km de Ruta 5** (9.452 ha) · más sospechosos como faja vial o predios urbanos sin asignar.

5. **4 pares con centroides a <5 km** sugieren contigüidad entre bloques (no son polígonos sueltos · forman zonas):
   - #11 + #20 a 1.4 km · Quebrada Los Choros + (vacío)
   - #21 + #23 a 2.1 km · (vacío) + PASAJE INTERIOR
   - #8 + #12 a 3.0 km · ambos (vacío)
   - #2 + #17 a 4.4 km · ambos (vacío) extremo oriental

### Veredicto C1

Los 75.000 ha de 0-0 NO son ruido. Son categoría territorial real con **al menos 3 tipos distinguibles**:

| Tipo emergente | Polígonos | Superficie | Características |
|---|---|---|---|
| **(a) cauces de quebrada** | 7 | 2.146 ha | sector nombrado · cerca de Quebrada Los Choros (zona Dominga) |
| **(b) bienes nacionales lejanos** | 15 | 57.267 ha | >8 km de Ruta 5 · sector vacío · masas grandes |
| **(c) faja vial / urbano sin asignar** | 3 | 9.452 ha | <2 km de Ruta 5 |

---

## Lectura conjunta · cambio de modelo propuesto

**Antes** (modelo Magnus actual implícito):

```yaml
predio:
  identidad: rol_sii
  geometria: 1 polígono
  asunción: rol_sii ↔ unidad geográfica única

rol_0_0:
  tratamiento: fallback null
  significado_asumido: fantasma sin geometría
```

**Después** (evidencia empírica de B1+C1):

```yaml
predio:
  identidad_administrativa: rol_sii
  geometrias: n polígonos (potencialmente dispersos a >30 km)
  realidad: rol_sii NO es identificador geográfico único
  caso_emblematico: 24-156 con 6 fragmentos en 30 km
  caso_extremo: 180-1 con 2 fragmentos a 36.8 km

rol_0_0:
  no_es_fantasma
  superficie: 75.787 ha (18.1% del territorio)
  categorías_distinguibles:
    - cauces_quebrada: 2.146 ha (Quebrada Los Choros → zona Dominga)
    - bienes_nacionales_lejanos: 57.267 ha
    - faja_vial_o_urbano_sin_asignar: 9.452 ha
  tratamiento_actual_magnus: null fallback
  tratamiento_apropiado_propuesto: categorización explícita
```

---

## Lo que NO se hizo (instrucción explícita)

- ✗ No canonizar nuevo principio
- ✗ No abrir EPIC
- ✗ No proponer schema 0004
- ✗ No tocar Magnus Radar
- ✗ No avanzar a DWG/PDF

## Output operacional

Backlog informado (sin acción):

1. Cuando llegue runtime PASS de Magnus Radar v0.3, revisar:
   - política actual `rol_sii → 1 predio` debe rediseñarse a `rol_sii → conjunto`
   - política actual `rol 0-0 → null` debe rediseñarse para discriminar las 3 sub-categorías
2. Para el grafo ITS: 4 polígonos Quebrada Los Choros candidatos a relacionar con Dominga
3. Para `agente-territorial` y `agente-inmobiliario` Meher OS: confirmación de que el rol SII no es PK geográfica
4. Para próxima iteración del catastro Supabase: validar que el cargador no perdió la multiplicidad rol → polígonos (los 7.686 cargados podrían estar deduplicados perdiendo geometrías)

Pendiente del Custodio: decidir si esta evidencia es suficiente para abrir el rediseño de la ontología predial, o si se requieren más casos para confirmar.
