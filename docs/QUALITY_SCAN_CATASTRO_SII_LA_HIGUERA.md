# Quality scan masivo · catastro SII La Higuera · 2026-05-31

**Tipo:** read-only · análisis de calidad estructural
**Fuente:** KMZ-06 canónico (`La_Higuera_UTF8.kmz`) · 7.687 polígonos
**Adaptación:** el catastro SII no contiene etiqueta de superficie declarada → patrón `KMZ_LABEL_VS_POLY_MISMATCH` exacto no aplica → se ejecutaron 6 chequeos análogos en espíritu

---

## 1 · Hallazgos con impacto operacional alto

### 1.1 · `ROL_0_0_FALLBACK` es MUCHO más grave de lo registrado

| Métrica | Valor |
|---|---|
| Roles `0-0` totales | **335** |
| Superficie acumulada | **75.787 ha** |
| **% del territorio catastrado** | **18.1 %** |
| Polígono `0-0` más grande | 30.766 ha (1.287 vértices) |
| Polígono `0-0` más pequeño | 0 ha (degenerado) |

**Implicación:** la política actual de la fixture Magnus Radar (`getUnitForPredio('0-0') → null`) **oculta efectivamente 18% del territorio comunal**. Esto es inaceptable para un visor territorial · el dato existe en el catastro, está georreferenciado, pero el render lo descarta como "fantasma".

**Recomendación (post-PASS runtime):** revisar el `ROL_0_0_FALLBACK` registrado en `ISSUES_OPERACIONALES.md`. El comportamiento correcto NO es retornar null, es retornar una unidad agregada `UN-PREDIOS-SIN-INDIVIDUALIZAR-COMUNA-4102` que represente este bucket masivo (que SÍ es información territorial, sólo que sin asignación predial individual).

### 1.2 · Concentración extrema · 95 % del territorio en 56 macro-predios

| Bucket | # Predios | Superficie | % Cobertura |
|---|---|---|---|
| Predios ≥500 ha | **56** | 398.911 ha | **95.2 %** |
| Predios <500 ha | 7.631 | 20.069 ha | 4.8 % |
| **Total catastrado** | **7.687** | **418.980 ha** | **102.2 %** vs comuna ~410.000 ha |

El catastro está **fuertemente sesgado**: poquísimos macro-predios rurales/comunales/fiscales + miles de mini-predios urbanos. Cualquier dashboard que muestre "promedio de superficie por predio" será engañoso (mediana muy distinta de media).

### 1.3 · Sobrecobertura territorial (+2.2 %)

La suma de polígonos catastrados **supera la superficie real de la comuna** en ~9.000 ha. Significa que **existe overlap entre predios** (predios solapados parcialmente) o errores de proyección/cálculo. Patrón estructural · no investigado en este pase · pendiente.

---

## 2 · Macro-predios top (potenciales errores o megalotes)

| Rol SII | Superficie (ha) | Vértices | Nota |
|---|---|---|---|
| **80-0** | **82.944,67** | 1.225 | 1/5 de la comuna en un solo polígono · sospechoso |
| **79-1** | 58.591,82 | 1.960 | 14 % de la comuna |
| **1075-1** | 51.367,13 | 2.034 | rol con manzana >1000 (probable predio fiscal) |
| 49-13 | 34.424,34 | 1.300 | aparece 2×: este registro + otro de 8.699 ha (consolidación incompleta) |
| 0-0 | 30.766,04 | 1.287 | bucket sin asignar más grande |
| 80-1 | 20.382,98 | 995 | |
| 0-0 | 19.269,36 | 1.886 | segundo bucket grande |
| 78-2 | 10.262,68 | 1.812 | |
| 49-13 | 8.699,00 | 950 | duplicado del rol 49-13 |
| 0-0 | 8.401,09 | 543 | tercer bucket grande |

Los 3 primeros (80-0, 79-1, 1075-1) suman **192.903 ha = 46 % de la comuna**. Imposible que sean propiedades privadas individuales · probable: predios fiscales del Estado, áreas costeras protegidas, o agrupaciones técnicas del catastro.

---

## 3 · Calidad geométrica

| Chequeo | Resultado |
|---|---|
| Polígonos con área = 0 | **2** (a investigar individualmente) |
| Vertices < 4 | 0 |
| Polígonos <0.001 ha (microscópicos) | **3** · rolse 27-0, 33-459, 224-2 |
| Duplicados geométricos exactos (mismo hash coords, distinto rol) | **0** ← **catastro limpio** en este aspecto |

**Veredicto calidad geométrica:** **sano**. El catastro SII no tiene polígonos repetidos copia-pega entre roles distintos. Sólo 5 anomalías individuales menores.

---

## 4 · Roles repetidos · patrón estructural detectado

| Métrica | Valor |
|---|---|
| Roles repetidos (excl. `0-0`) | **160** |
| Con geometrías **DISTINTAS** | **160** (100 %) |
| Con geometría idéntica replicada | 0 |

**Hallazgo:** los 160 roles repetidos son **fragmentaciones reales**, no duplicación de registro. Mismo rol SII se asigna a varios polígonos físicamente distintos.

**Top 10 roles más fragmentados:**

| Rol | Instancias | Suma (ha) | Patrón |
|---|---|---|---|
| 66-0 | **92** | 45,33 | manzana 66 con `predio=0` · cada fragmento ~0.3 ha |
| 67-0 | 65 | 51,02 | manzana 67 con `predio=0` · cada fragmento ~0.5 ha |
| 49-24 | 62 | 59,07 | predio 24 manzana 49 fragmentado · áreas similares |
| 33-469 | 52 | 92,04 | áreas muy variables (0.009 a varios) · sospechoso |
| 29-0 | 45 | 2,64 | mini-fragmentos manzana 29 sin predio |
| 33-7 | 29 | 15,28 | |
| 27-0 | 25 | 5,23 | |
| 1490-0 | 23 | 24,65 | |
| 25-0 | 23 | 2,25 | |
| 49-333 | 20 | 13,35 | |

**Interpretación:**

El patrón `MANZ-0` (predio = 0) es **convención SII para "manzana sin individualización predial completa"**. Funciona como bucket: todos los polígonos sub-prediales dentro de una manzana que no fueron asignados a un predio específico se agrupan bajo el mismo `MANZ-0`.

**Implicación para Magnus Radar:** cualquier consulta por rol del catastro debe asumir que **puede retornar N polígonos**, no 1. El frontend actual asume 1:1 rol→geometría · validar comportamiento cuando llegue runtime.

---

## 5 · Resumen accionable

```yaml
quality_scan_catastro_SII_LH:
  fuente: KMZ-06 (canónico) · 7687 polígonos
  
  hallazgos_alto_impacto:
    - ROL_0_0_FALLBACK_GRAVE:
        ocultos: 75787 ha
        porcentaje_territorio: 18.1
        accion_recomendada: revisar política null · agregar UN-PREDIOS-SIN-INDIVIDUALIZAR
    - CONCENTRACION_EXTREMA:
        56_predios_concentran: 95.2 % cobertura
        implicacion: cualquier promedio engañoso · usar mediana
    - SOBRECOBERTURA_TERRITORIAL:
        excedente: 9000 ha (+2.2 %)
        causa_probable: overlap entre predios o error proyección
    - PATRON_MANZ_0:
        roles_-0: 160 con fragmentación
        66-0_caso_extremo: 92 fragmentos en mismo rol
        implicacion: rol → N polígonos · NO asumir 1:1
  
  calidad_geometrica:
    degenerados: 2
    microscopicos: 3
    duplicados_exactos: 0
    veredicto: limpio
  
  para_Magnus_Radar (post-PASS):
    backlog_nuevo:
      - revisar política 0-0 fallback (oculta 18%)
      - validar render multi-polígono para rol fragmentado
      - investigar overlap +2.2%
      - investigar 80-0 (82.944 ha en 1 polígono)
```

---

## 6 · Bloque siguiente (Carril B+C)

**Bloque 2 (este reporte) cerrado.** Sin tocar Magnus Radar.

Pendientes del orden establecido por Max:
- **Bloque 3 · Triage DWG/DXF (70 archivos)** ← siguiente · arranco ya con la misma disciplina
- Bloque 4 · Filtro PDF "altos" en 1.826 PDF

Si quieres re-priorizar (ej. profundizar uno de los hallazgos de este bloque · 80-0 o overlap +2.2 %), redirige.
