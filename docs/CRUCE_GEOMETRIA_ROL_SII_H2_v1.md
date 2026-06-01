# Cruce geometría↔rol SII · zona ortofoto Hijuela 2 · 2026-05-31

**Disparador:** Prioridad 1 establecida por Custodio · responder pregunta crítica antes de cualquier otra tarea
**EVT asociado:** EVT-H2-OCCUPATION-BASELINE-20260531
**Disciplina:** hecho/inferencia/hipótesis · sin afirmar dominio · sin asumir asociaciones

---

## 0 · Pregunta crítica original

> ¿Las zonas con patrón de ocupación están efectivamente dentro de los roles que forman la unidad territorial Hijuela 2, o están en predios vecinos?

---

## 1 · Respuesta directa (HECHO_OBSERVADO)

**De la superficie total clasificada como categoría 5 (asentamiento consolidado) en la zona ortofoto:**

| Bucket | Superficie | % |
|---|---|---|
| Roles canónicos Hijuela 2 (`24-123`, `24-160`) | **0,00 ha** | **0,0 %** |
| Rol candidato Hijuela 1 (`24-43`) | 1,14 ha | 5,0 % |
| **Rol `0-0` (predios SII sin individualizar)** | **15,59 ha** | **68,9 %** |
| Otros roles menores (24-30, 24-154, 24-0, 27-0, 27-2, 25-19, 25-1, 26-147) | 5,90 ha | 26,1 % |
| **TOTAL cat 5** | **22,63 ha** | 100 % |

**El asentamiento consolidado NO está físicamente cubierto por los roles canónicos 24-123 y 24-160.**

---

## 2 · Resultado por cuadrante

```
cuad  cat  %dentro_perímetro_RTK_H2  top_rol_que_lo_cubre  %_del_cuadrante  segundo_rol
─────────────────────────────────────────────────────────────────────────────────────
Q00   4    25,7 %                    24-30       33,7 %   24-43 13% · 0-0 10%
Q01   4     0,0 %                    24-43       49,1 %   0-0 7%
Q02   0     0,0 %                    24-43       88,7 %   0-0 7%
Q03   0     0,0 %                    24-43      100,0 %
Q10   5    47,2 %                    0-0         26,3 %   24-43 9% · 24-30 8%
Q11   5     0,0 %                    0-0         23,5 %   0-0 6% · 24-154 5%
Q12   4     0,0 %                    0-0         15,5 %   varios 0-0
Q13   1     0,0 %                    0-0         45,3 %   24-43 21%
Q20   5    53,6 %                    0-0         21,2 %   varios 0-0
Q21   5    34,1 %                    0-0         10,6 %   27-0 3%
Q22   2    82,3 %                    0-0         39,4 %   27-0 28% · 0-0 11%
Q23   0    74,3 %                    24-43       55,2 %   0-0 45%
Q30   4     0,0 %                    0-0         35,1 %   24-123 29% · 0-0 20%
Q31   2     0,0 %                    0-0         55,3 %   24-123 15%
Q32   0    55,2 %                    24-123      45,6 %   24-43 23% · 0-0 13%
Q33   0   100,0 %                    24-43       71,1 %   24-123 29%
```

---

## 3 · Patrón estructural detectado (INFERENCIA)

Hay **divergencia entre dos definiciones de "Hijuela 2"**:

| Definición | Qué es | Superficie en zona ortofoto | Cobertura del asentamiento |
|---|---|---|---|
| **Hijuela 2 perímetro RTK G4** (lo que Cominetti reclama / posee) | Polígono geométrico medido en terreno | varios cuadrantes con 25-100 % dentro | **Q10 (47%) · Q20 (54%) · Q21 (34%)** SÍ están físicamente dentro |
| **Hijuela 2 rol SII canónico** (24-123, 24-160) | Identificación administrativa SII | 14,6 ha en la zona ortofoto · principalmente categoría 0 | **El núcleo del asentamiento cat 5 NO cae sobre 24-123** |

Es la manifestación local de la **hipótesis A** ya registrada (`rol-sii-no-implica-unidad-geografica`): el rol no marca el territorio físicamente reclamado por el RTK.

---

## 4 · ¿Dónde está el asentamiento entonces?

```yaml
asentamiento_consolidado_cat_5:
  total_ha_observada: 22.63
  
  catastralmente_cae_en:
    rol_0_0:             15.59 ha  (68.9%)   # predios SII sin individualizar
    rol_24_30:            2.05 ha  ( 9.1%)
    rol_24_154:           1.34 ha  ( 5.9%)
    rol_24_43:            1.14 ha  ( 5.0%)   # vecino · Hijuela 1 candidato
    otros_pequenos:       2.51 ha  (11.1%)
    rol_24_123_H2:        0.00 ha  ( 0.0%)   ← CERO en rol Hijuela 2
  
  geometricamente_cae_en:
    perimetro_RTK_H2:     varios cuadrantes 34%-54% dentro (Q10, Q20, Q21)
    fuera_perimetro_RTK:  Q11 (0%), Q12 (0%)
```

**Lectura inferencial:** una parte del asentamiento (Q10, Q20, Q21 · cat 5) está **físicamente dentro del perímetro RTK que Cominetti mide como suyo · PERO catastralmente está en rol 0-0 + roles vecinos menores · NO en 24-123**.

Esto coincide con el hallazgo D1: los roles 0-0 son residuos catastrales del predio matriz Estancia La Higuera que el SII no individualizó. Lo que Cominetti tiene como "Hijuela 2 RTK" cubre más que el rol 24-123 que el SII reconoce.

---

## 5 · Tres hipótesis sobre la naturaleza del conflicto (NO demostradas)

| Hipótesis | Enunciado | Cómo validar |
|---|---|---|
| **H-a** | El perímetro RTK está bien medido · el rol 24-123 está mal demarcado en el SII | Cruce con planos CBR + escritura Cominetti vs polígono SII 24-123 |
| **H-b** | El perímetro RTK abarca terreno que no es de Cominetti (incluye 0-0 que sería bien nacional o de terceros) | Estudio de títulos + revisión CBR · revisión BBNN |
| **H-c** | El asentamiento ocupa una zona que históricamente fue parte de Estancia La Higuera Matriz, y la titularidad sobre ese sector está en disputa entre Cominetti, Estancia Matriz, BBNN, ocupantes (DL 2.695) y otros | Estudio de títulos completo + verificación posesorios DL 2.695 |

**NO se puede determinar cuál es correcta sin cruce documental adicional.**

---

## 6 · Lectura por categoría agregada

### Cat 5 · asentamiento consolidado (22,63 ha)
Mayoritariamente en **rol 0-0** · cero superficie en 24-123. **El núcleo está catastralmente "huérfano".**

### Cat 4 · agrupación habitacional (35,35 ha)
- 0-0: 18,21 ha (51 %)
- 24-43: 7,86 ha (22 %)
- 24-30: 4,18 ha (12 %)
- **24-123 (Hijuela 2 canónico): 3,56 ha (10 %)** ← primera aparición no nula
- 26-130, 25-0, 26-129, 25-87, 227-x: 1,84 ha residual

### Cat 2 · viviendas probables (23,46 ha)
- 0-0: 18,01 ha (77 %)
- 27-0: 3,41 ha
- **24-123: 1,80 ha (8 %)**

### Cat 1 · estructura aislada (11,69 ha)
- 0-0: 8,22 ha
- 24-43: 3,05 ha
- 25-44: 0,42 ha

### Cat 0 · no-ocupacional (61,73 ha)
- 24-43: 41,83 ha (68 %) ← gran parte de la zona no-ocupada del cuadrante
- 0-0: 10,48 ha
- **24-123: 9,23 ha (15 %)** ← la mayor parte de Hijuela 2 SII en zona ortofoto es sin ocupación

**Patrón:** los roles canónicos 24-123 y 24-43 cubren mayoritariamente zonas SIN ocupación visible en esta cobertura.

---

## 7 · Schema exportado para Magnus Radar

Cada cuadrante tiene ya el formato pedido por el Custodio:

```yaml
ocupacion:
  feature_id: cuadrante_Q10
  area_m2: 124000   # ~12.4 ha
  categoria: 5
  
  dentro_perimetro_RTK_H2:
    area_pct: 47.2
    
  intersecta_rol:
    - rol_sii: "0-0"
      area_intersectada_ha: 32.74
      pct_del_cuadrante: 26.3
      pct_del_rol_total: 52.8
    - rol_sii: "24-43"
      area_intersectada_ha: 5.59
      pct_del_cuadrante: 4.5
      pct_del_rol_total: 0.4
    - rol_sii: "24-30"
      area_intersectada_ha: 4.97
      pct_del_cuadrante: 4.0
      pct_del_rol_total: 8.0
    # ...
```

Archivo completo: `cruce_geometria_rol_sii_v1.json`

---

## 8 · Riesgo metodológico residual

```yaml
HECHO:
  cuadrantes_Q10_Q20_Q21_dentro_perimetro_RTK_H2: parcial (34-54%)
  cuadrantes_Q10_Q11_Q20_Q21_no_caen_en_rol_24_123: confirmado
  
INFERENCIA:
  divergencia_entre_RTK_y_SII_24_123: probable patrón estructural
  asentamiento_huerfano_catastralmente: SI (cae en 0-0 mayoritariamente)
  
HIPOTESIS_no_demostrada:
  ocupacion_efectiva_del_suelo: pendiente
  identidad_juridica_del_asentamiento: pendiente
  cardinalidad_dueno_efectivo_24_123: pendiente
  validez_polígono_24_123_vs_RTK: pendiente
```

---

## 9 · Próximos movimientos según prioridades del Custodio

```yaml
P1_completada: cruce_geometria_rol_sii  # este reporte
P2_pendiente: cruce_rol_titularidad
  proximo_movimiento:
    para_roles_dominantes_24_30__24_154__24_43__24_123__27_0:
      buscar_inscripcion_CBR_y_titular_actual
    para_rol_0_0_no_aplica:
      no_tiene_rol_individualizado · requiere consulta especifica BBNN o Estancia Matriz
P3_pendiente: lectura_individual_12_cuadrantes  # disminuye prioridad porque pregunta crítica ya respondida
P4_pendiente: validacion_terreno_Daniel
```

---

## 10 · Nuevas preguntas que emergen del cruce

1. **¿Cuál es la cardinalidad del rol 24-123?** B1 mostró que muchos roles tienen N polígonos. Verificar si 24-123 tiene un solo polígono o varios.

2. **El rol 24-30 (top en Q00 con 33,7 %)** aparece persistentemente sobre cuadrantes ocupados. ¿Quién es el titular? ¿Hay relación con Cominetti?

3. **El rol 24-43** está estructuralmente cerca de 24-123 · cubre zonas grandes sin ocupación. ¿Es Hijuela 1? ¿Hijuela 3? ¿Otro vecino?

4. **Los rol 0-0 que cubren el asentamiento:** ¿son los mismos que D1 identificó como "residuos del predio matriz Estancia La Higuera"? Si sí, **el asentamiento estaría físicamente sobre tierra de Estancia Matriz no individualizada · NO sobre Hijuela 2 Cominetti**.

5. **Hipótesis emergente:** la Estancia La Higuera Matriz 2021 podría ser quien tiene título formal sobre la tierra donde está el asentamiento (al menos los 15,59 ha en rol 0-0). Esto exige revisar el .gpkg de Estancia Matriz y compararlo con los 0-0 que cubren el asentamiento.

---

## 11 · Resumen para tablero / dashboard

```yaml
EVT-H2-OCCUPATION-BASELINE-20260531:
  estado_post_P1: cruce_geometria_rol_sii_COMPLETADO
  
respuesta_pregunta_critica:
  ocupacion_consolidada_en_rol_24_123_H2: 0.00 ha
  ocupacion_consolidada_en_rol_0_0: 15.59 ha (68.9% del cat 5)
  ocupacion_consolidada_en_otros_roles: 7.04 ha
  
hallazgo_principal:
  el asentamiento detectado NO esta catastralmente en Hijuela 2 (24-123)
  esta en roles 0-0 (sin individualizar) + roles menores
  
pero_geometricamente:
  3 cuadrantes cat 5 (Q10, Q20, Q21) caen 34-54% dentro del perimetro RTK H2

implicacion_para_proceso_de_saneamiento:
  el saneamiento debe operar simultaneamente sobre:
    1. ocupacion fisica (terceros)
    2. individualizacion catastral SII (0-0 → rol formal)
    3. eventual conflicto Cominetti vs Estancia Matriz vs ocupantes
```
