# D1 · Cruce 23 macro-bloques 0-0 vs capas estatales locales · 2026-05-31

**Tipo:** experimento falsable propuesto por Custodio · read-only · sin canonización
**Disparador:** validar hipótesis B "los 0-0 son bienes nacionales" antes de promover a doctrina
**Método:** intersección geométrica con shapely + reproyección UTM19S↔WGS84 con pyproj

---

## 1 · Cobertura del experimento

| Capa pedida por D1 | Disponible en data room | Origen efectivo |
|---|---|---|
| Catastro Bienes Nacionales (BBNN/MIPAB) | ✗ | no en data room |
| DGA cauces oficiales | ✗ | no en data room (sí derechos de agua en Supabase, no consultable sin runtime) |
| Red vial MOP | ✓ parcial | `R5_BUFFER_*.gpkg` + `EJE_RUTA_5.gpkg` (Ruta 5 La Higuera) |
| Áreas protegidas SNASPE CONAF | ✗ | no en data room |
| Límites comunales SUBDERE/INE | ✗ | no en data room |
| Quebradas oficiales IGM | ✗ vectorial · ✓ toponimia | sólo via campo `sector` del propio catastro |
| **Adicional disponible** | | |
| ESTANCIA_LA_HIGUERA_MATRIZ_2021 | ✓ | predio histórico matriz · 564.132 ha |
| INTERCHILE_SERVIDUMBRE_2014 | ✓ | faja eléctrica · 49 ha |
| PERIMETRO_CBR_RTK_H2 | ✓ | Hijuela 2 Cominetti · 2.165 ha |

**Cobertura D1 completa: 1 de 6 capas oficiales (MOP).** Las otras 5 NO están en el corpus local. El experimento queda parcialmente cumplido respecto al diseño original de Max.

---

## 2 · Resultado del cruce

Universo: 23 macro-bloques 0-0 (>100 ha) · 73.823 ha totales (92.7 % de toda la masa 0-0).

| Capa | Bloques afectados | Superficie explicada | % de masa 0-0 |
|---|---|---|---|
| **ESTANCIA_LA_HIGUERA_MATRIZ_2021** | **18** | **61.597,71 ha** | **83.44 %** |
| TOPONIMIA_QUEBRADAS (sector contiene "Quebrada") | 7 | 2.354,15 ha | 3.19 % |
| R5_BUFFER_120M (MOP Ruta 5 + 120m) | 7 | 262,21 ha | 0.36 % |
| R5_BUFFER_60M (MOP Ruta 5 + 60m) | 7 | 136,04 ha | 0.18 % |
| PERIMETRO_CBR_RTK_H2 (Hijuela 2) | 2 | 14,23 ha | 0.02 % |
| INTERCHILE_SERVIDUMBRE | 0 | 0,00 ha | 0.00 % |

**Bloques con al menos una explicación:** 19 de 23
**Superficie acumulada explicada:** 69.713,75 ha de 73.823,82 ha = **94.43 %**

**Bloques sin explicación local (5.57 %):**

| # | Área (ha) | Sector | Notas |
|---|---|---|---|
| 5 | 2.148,46 | (vacío) | 25 km de Ruta 5 · interior comuna |
| 6 | 1.696,38 | (vacío) | 62 km de Ruta 5 · extremo oriental |
| 21 | 148,03 | (vacío) | |
| 23 | 117,13 | "PASAJE INTERIOR" | |

Suma 4.110 ha. Estos bloques NO caen dentro del polígono Estancia Matriz · no caen en faja Ruta 5 · no nombran quebrada.

---

## 3 · Resultado de la pregunta binaria de Max

```yaml
pregunta_binaria:
  enunciado: "¿qué % de la masa 0-0 se explica por capa estatal conocida?"
  
respuesta_cuantitativa:
  con_capas_disponibles: 94.43%
  
veredicto_de_Max_aplicable:
  umbral_para_NO_categoria_primaria: > 80%
  resultado: SE CUMPLE
  
conclusion_directa:
  los_0_0_son: "manifestación cartográfica de otras entidades"
  no_son: "categoría territorial primaria propia"
```

---

## 4 · Caveat metodológico crítico

El 83.44 % del resultado proviene de **ESTANCIA_LA_HIGUERA_MATRIZ_2021** · esta capa NO es estatal en sentido estricto. Es un **predio histórico matriz** registrado en 2021 cuyo bbox de 119 × 47 km **excede la comuna entera** (564.132 ha vs ~410.000 ha de comuna).

Por lo tanto:

| Si el cruce es geométricamente positivo... | NO necesariamente significa... |
|---|---|
| Los 0-0 caen DENTRO del polígono Estancia Matriz | Que los 0-0 SON la Estancia Matriz |
| El predio matriz cubre la zona | Que el 0-0 pertenezca administrativamente al titular del matriz |

Lo que sí queda razonablemente demostrado:

```yaml
hipótesis_emergente:
  enunciado: |
    Los macro-bloques 0-0 son residuos catastrales del predio matriz
    Estancia La Higuera, aún no individualizados como roles propios
    por el SII.
  
  evidencia_directa:
    - 83% de la masa 0-0 cae geométricamente dentro del polígono matriz
    - Faja vial MOP explica sólo 0.36% (no es la respuesta)
    - InterChile faja eléctrica explica 0%
  
  implicación:
    - Los 0-0 NO son bienes nacionales en su mayoría
    - Son artefactos de un proceso administrativo SII incompleto
    - "0-0" significa "predio aún no individualizado del matriz" en La Higuera
  
  confianza: alta para el caso La Higuera · NO generalizable sin estudios análogos en otras comunas
```

---

## 5 · Hipótesis B revisada

| Antes de D1 | Después de D1 |
|---|---|
| "Los 0-0 son bienes nacionales" (sospecha) | **Rechazada parcialmente** · sólo 5.57 % podría ser BBNN (los 4 bloques sin explicación local) |
| "Los 0-0 son cauces de quebrada" | Confirmada para 3.19 % por toponimia |
| "Los 0-0 son faja vial" | Confirmada para 0.36 % · marginal |
| Sin hipótesis previa: "predio matriz no fragmentado" | **NUEVA · respaldada en 83.44 %** |

La hipótesis ganadora del experimento NO estaba en la lista original de Max. Emergió del dato.

---

## 6 · Lo que NO se pudo falsar sin capas faltantes

Sin BBNN / DGA cauces / SNASPE / IGM hidrografía, NO se puede:
- Confirmar/negar si los 4 bloques sin explicación local (4.110 ha) son bienes nacionales
- Confirmar/negar si la coincidencia con Estancia Matriz refleja titularidad real o sólo overlap geométrico
- Determinar si los polígonos 0-0 que mencionan "Quebrada" en toponimia coinciden con cauces oficialmente reconocidos por DGA

**Gap operacional registrado:** estas 5 capas siguen pendientes. La respuesta D1 con corpus local **es suficiente para descartar B en su versión inicial**, pero **no para canonizar la hipótesis emergente** "predio matriz no fragmentado".

---

## 7 · Implicaciones para Magnus Radar (sin tocar nada)

Cuando llegue runtime PASS + decisión de rediseño:

**Para política `rol 0-0 → null` actual:**
- 5.57 % de la masa (4.110 ha) podría ser bien nacional real · merece display explícito
- 83.44 % es matriz no individualizada · merece display como "Estancia matriz · residuo catastral"
- 3.19 % es quebradas toponímicas · merece display como "geografía natural · cauce"

**Para política `rol → 1 predio` actual (hallazgo B1):**
- Sigue vigente · el modelo conjunto `rol → 1..n geometrias` no se modificó con D1
- La evidencia de B1 (24-156, 180-1) es independiente de D1

---

## 8 · Conclusión epistemológica honesta

```yaml
hipótesis_B_original:
  estado: rechazada parcialmente
  porcentaje_explicable_como_BBNN: ≤ 5.57% (4 bloques sin explicación local)
  
hipótesis_emergente_predio_matriz:
  estado: respaldada por evidencia geométrica
  confianza_para_canonización: insuficiente
  razón: requiere validación con capas oficiales (DGA, BBNN) que están fuera del corpus local
  acción_de_validación_pendiente: obtener capas IDE Chile o portal estatal
  
hipótesis_A_rol_SII_etiqueta_administrativa:
  estado: independiente de D1 · sigue respaldada por B1 (casos extremos 24-156, 180-1)
  acción_de_validación_pendiente: arqueo comparativo con otra comuna rural
  
veredicto_global_de_D1:
  cumple_umbral_max_para_no_categoria_primaria: SÍ (94.43% > 80%)
  PERO: explicación dominante NO es estatal-funcional sino estructural-administrativa
  recomendación: NO promover a schema sin completar las capas faltantes
```

---

## 9 · Estado de la memoria persistente

El registro pendiente de canonización (`conocimiento_pendiente_rol_sii_no_es_unidad_geografica.md`) sigue vigente · este reporte D1 lo refina pero NO lo cierra. Las dos hipótesis abiertas necesarias para cerrar:

1. ¿Es el rol SII una etiqueta administrativa sistémica del catastro chileno? · pendiente arqueo otra comuna
2. ¿Cuál es la naturaleza jurídica real de la Estancia La Higuera Matriz 2021? · pendiente revisión del .gpkg + cruce con BCN/CBR

Sin estos, NO promover. Quedo a disposición para arquear cualquiera de las dos cuando autorices.
