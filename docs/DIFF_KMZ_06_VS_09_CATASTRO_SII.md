# Diff catastros SII · KMZ-06 vs KMZ-09 · 2026-05-31

**Tipo:** read-only · auditoría comparativa estructurada
**Disparador:** sospecha de versiones distintas del catastro municipal (Carril B+C · Max approved order: A primero)
**Método:** parsing semántico + hash canónico ordenado + clasificación por buckets
**Resolución:** decisiva · ambos archivos son semánticamente idénticos

---

## 1 · Hipótesis abiertas (resueltas)

| Hipótesis | Estado | Evidencia |
|---|---|---|
| H1 · KMZ-09 es revisión real del catastro | **FALSA** | Cero placemarks modificados · cero solo_en_X |
| **H2 · KMZ-09 es reexport sin cambios sustantivos** | **CONFIRMADA** | 7.687 placemarks idénticos coordenada-por-coordenada |
| H3 · KMZ-06 y KMZ-09 son cortes temporales distintos | FALSA | Hash global de contenido coincide exacto |
| H4 · Uno derivado manualmente del otro | Plausible y compatible con H2 | indistinguible empíricamente · ambas dan el mismo resultado operacional |

---

## 2 · Buckets de comparación

| Bucket | Conteo | Detalle |
|---|---|---|
| **Idénticos** (geometría + atributos exactos) | **7.687** | TODOS · sin excepción |
| Modificados | 0 | — |
| Solo en KMZ-06 | 0 | — |
| Solo en KMZ-09 | 0 | — |

```yaml
catastro_canonico:
  ambiguo: false              # ← resuelto definitivamente
  fuente_unica_acreditada: true
  diferencia_md5: ruido_de_serialización  # no semántica
```

---

## 3 · Métricas del diff

| Métrica | KMZ-06 | KMZ-09 |
|---|---|---|
| Polígonos parseados | 7.687 | 7.687 |
| Claves únicas (rol_sii + centroide) | 7.687 | 7.687 |
| Atributos por placemark | COMUNA, MANZ_SII, PREDIO, ROL_SII, SECTOR, ESTADO | idem |
| Atributos exclusivos | ninguno | ninguno |
| Hash global ordenado | `de0c603698d16f61a0bf637125eb6877` | **`de0c603698d16f61a0bf637125eb6877`** ✓ |

---

## 4 · ¿Por qué difieren los md5 si el contenido es igual?

Inspección del header XML y de los primeros bytes revela la fuente del ruido:

```xml
<!-- KMZ-06 (cabecera) -->
<?xml version="1.0" encoding="utf-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
  <Style id="area1">
    <IconStyle><scale>0</scale><Icon><href></href></Icon></IconStyle>
    <LabelStyle><scale>0</scale></LabelStyle>
    <LineStyle>...

<!-- KMZ-09 (cabecera) -->
<?xml version="1.0" encoding="iso-8859-1"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
  <Style id="area1">
    <LineStyle>
      <color>FF000000</color>
      <width>1</width>
      ...
```

**Diferencias detectadas:**

1. **Encoding declarado:** `utf-8` (KMZ-06) vs `iso-8859-1` (KMZ-09)
2. **Ordering de sub-elementos `<Style>`:** distinto orden (IconStyle/LabelStyle/LineStyle vs LineStyle expandido primero)
3. **Verbosidad XML:** KMZ-09 pesa 10.69 MB descomprimido vs 10.45 MB de KMZ-06 (**+245 KB de overhead**), probablemente por más indentación o atributos Style explícitos
4. **Cero diferencias en `<Placemark>`:** los 7.687 polígonos son idénticos byte a byte en sus coordenadas y atributos

**Conclusión:** la diferencia md5 es **ruido de serialización**, no señal semántica. Ambos archivos representan el mismo estado territorial.

---

## 5 · Recomendación de versión canónica

**Versión canónica recomendada: KMZ-06**
(`/17_MESA_ANDES_IRON_2026/17.4_Documentos_Andes_Iron/La_Higuera_UTF8.kmz`)

Criterios:

| Criterio | KMZ-06 | KMZ-09 |
|---|---|---|
| Tamaño | 1.37 MB · 10.45 MB descomprimido (más compacto) | 1.37 MB · 10.69 MB descomprimido |
| Encoding declarado | `utf-8` (estándar moderno) | `iso-8859-1` (legacy) |
| Contexto carpeta | `17_MESA_ANDES_IRON_2026/17.4_Documentos_Andes_Iron/` · trazable a mesa formal con Andes Iron | `La Higuera2/` · mount adyacente sin contexto curado |
| Naming | `La_Higuera_UTF8.kmz` · sugiere versión sanitizada | `La Higuera (1).KMZ` · sugiere descarga duplicada del navegador |
| Información preservada | 100 % | 100 % (idéntico) |

**Decisión operacional:** tratar KMZ-06 como fuente canónica · KMZ-09 puede archivarse o eliminarse sin pérdida de información (con anotación explícita "duplicado semántico de KMZ-06 con encoding distinto").

---

## 6 · Implicaciones para Magnus Radar (cero touch al codebase)

| Pregunta | Respuesta |
|---|---|
| ¿Cuál KMZ alimentó los 7.686 predios de Supabase? | Indistinguible empíricamente (ambos producirían el mismo resultado) · sin embargo el path `17.4_Documentos_Andes_Iron/` sugiere KMZ-06 como entrada del scraper |
| ¿Por qué 7.686 en Supabase vs 7.687 en los KMZ? | Diferencia de 1 placemark · NO causada por divergencia entre catastros (son idénticos) · explicación más probable: 1 placemark rechazado en carga (geometría inválida, atributos faltantes, o registro duplicado deduplicado) |
| ¿Hay riesgo de cargar 'la versión equivocada'? | NO · ambas versiones son equivalentes a nivel de datos |
| ¿Hay datos olvidados en KMZ-09 que no están en KMZ-06? | NO · cero atributos exclusivos · cero placemarks exclusivos |

---

## 7 · Nuevo principio operativo canonizado

**Origen del principio:** la sospecha que disparó este diff era válida y necesaria · resultó ser falsa en este caso particular, pero el riesgo estructural sigue siendo real para futuras comparaciones de fuentes en el ecosistema Meher.

### Doctrina operacional cross-Meher

```
DOCTRINA · CARDINALIDAD ≠ ESTADO

No asumir que dos fuentes con igual cardinalidad representan
el mismo estado territorial, contable, jurídico o documental.

La cardinalidad coincide cuando dos archivos tienen el mismo
número de registros, pero NO garantiza:
  - mismos atributos por registro
  - mismas coordenadas
  - mismos identificadores
  - mismo orden temporal de actualización
  - misma resolución de duplicados

Antes de tratar dos fuentes como intercambiables, EJECUTAR
un diff estructurado (hash semántico por registro · clasificación
en buckets idénticos / modificados / exclusivos) y documentar
explícitamente la equivalencia o la divergencia.

La diferencia md5 / SHA / size de archivo NO basta como evidencia
en ninguna dirección · puede ser señal semántica o sólo ruido de
serialización (encoding, ordering, pretty-print, BOM).
```

**Aplicable a:**
- Catastros (SII vs municipal vs propio · arqueado hoy)
- Estados financieros (cierre vs proforma · cierre vs auditado)
- Versiones de mandato / escritura (original vs copia notarial vs cesión)
- Bases de clientes / partners (CRM vs Odoo vs Airtable)
- Cualquier corpus duplicado en el ecosistema Meher

**Frecuencia esperada del falso positivo:** baja. La mayoría de pares con igual cardinalidad ESTARÁN semánticamente idénticos (como este caso). Pero el costo del falso negativo (asumir equivalencia y operar sobre versión equivocada) es alto. La doctrina exige el chequeo.

---

## 8 · Conclusión

```yaml
diff_kmz_06_vs_09:
  estado: resuelto
  veredicto: catastros_semanticamente_identicos
  versiones:
    canonica: KMZ-06
    descartable: KMZ-09 (anotar como "duplicado por reexport")
  
catastro_municipal_la_higuera:
  fuente_unica: KMZ-06
  registros: 7687 placemarks
  duplicados_por_nombre: 1058 (incluye 335 del rol 0-0 · patrón ROL_0_0_FALLBACK)
  cobertura_Supabase: ~99.99% (7686 / 7687)
  
doctrina_emergente:
  nombre: cardinalidad_distinta_de_estado
  canonizada: true
  aplicable_a: todo Meher OS
  proxima_aplicacion: cualquier comparación futura de fuentes presuntamente equivalentes

siguiente_carril_B+C:
  prioridad_1: procesamiento masivo de los 7687 placemarks buscando KMZ_LABEL_VS_POLY_MISMATCH
  prioridad_2: triage DWG/DXF (70 archivos)
  prioridad_3: filtro PDF "altos"
```

**Sin tocar Magnus Radar · sin esperar runtime · listo para siguiente bloque.**
