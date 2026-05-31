# Regla canónica · Jerarquía de autoridad territorial

**Versión**: 1.0
**Vigente desde**: 2026-05-31
**Aplicable a**: Magnus Radar · futuras integraciones Meher OS / ITS

---

## Principio madre

> SII manda para avalúo fiscal, contribuciones y rol.
> Xpert Urban manda para lectura territorial-operacional.
> CBR / títulos mandan para cerrar dominio jurídico.
> Ninguna fuente sobreescribe a otra. Ninguna se considera "verdad absoluta".
> El delta entre fuentes es **información**, no error.

---

## Tabla de autoridad por campo

| Campo | Fuente autoritativa | Fuente secundaria | Notas |
|---|---|---|---|
| **rol** | SII oficial | — | Identificador fiscal único |
| **avalúo fiscal** | SII oficial | — | CLP, periodo anual |
| **contribuciones** | SII oficial | — | Cuotas trimestrales |
| **cod_destino fiscal** | SII oficial | — | H/A/B/C/O/W |
| **superficie física real** | Xpert Urban (operacional) | CBR (escritura) | XU mide en terreno; CBR fija lo legal |
| **superficie fiscal individualizada** | SII oficial | — | Solo lo catastrado activamente |
| **propietario titular** | CBR / escritura | SII (registrado) | CBR prevalece para dominio jurídico |
| **geometría polígono completo** | Xpert Urban | — | SII solo expone centroide |
| **centroide oficial** | SII oficial | XU calculado | SII para identificación cruzada |
| **derechos servidumbres** | CBR | — | Inscripciones de gravámenes |
| **avalúo comercial estimado** | Tasación profesional | Modelos automáticos (Data Inmobiliaria) | Solo aplica habitacional para automática |

---

## Tipos de fuente

### `source_type` (enum)

| Valor | Descripción |
|---|---|
| `levantamiento_xpert_urban` | Levantamiento territorial-operacional propio (KMZ, RTK, drone, planos catastrales) |
| `sii_oficial` | Catastro fiscal SII vía Data Inmobiliaria / SII Mapas |
| `cbr_inscripcion` | Inscripciones del Conservador de Bienes Raíces |
| `titulo_escritura` | Escrituras públicas notariales |
| `cnr_dga` | Derechos de aprovechamiento de aguas (DGA) |
| `sernageomin` | Concesiones mineras |
| `manual` | Carga manual con respaldo documental específico |

### `source_authority` (enum)

| Valor | Descripción |
|---|---|
| `fiscal_publica` | Autoridad fiscal del Estado (SII) |
| `juridica_publica` | Autoridad jurídica del Estado (CBR, notarías, registros públicos) |
| `regulatoria_publica` | Reguladores sectoriales (DGA, Sernageomin, SEA, SMA) |
| `comercial_publica` | Publicaciones comerciales públicas (portales inmobiliarios) |
| `operacional_privada` | Levantamiento propio o de terceros sin respaldo regulatorio |

### `evidence_status` (enum)

| Valor | Descripción |
|---|---|
| `vigente_conciliado` | Dato vigente, conciliado entre fuentes |
| `pendiente_conciliacion_titulo_sii_cbr` | Requiere conciliación con título/SII/CBR |
| `discrepancia_documentada` | Hay delta conocido y documentado entre fuentes |
| `obsoleto_superado` | Dato superado por una versión más reciente del mismo titular |

---

## Reconciliación entre fuentes

### Tabla `reconciliacion_catastral`

Toda discrepancia detectada entre fuentes se registra como una fila con `reconciliation_status` inicial `open_delta`. **Ningún delta se considera cerrado sin validación CBR.**

### `reconciliation_status` (enum)

| Valor | Significado | Confianza típica |
|---|---|---|
| `open_delta` | Delta detectado, sin conciliación | `preliminar` |
| `conciliado_cbr` | Resuelto con respaldo CBR | `definitiva` |
| `conciliado_titulo` | Resuelto con escritura/título | `alta` |
| `discrepancia_justificada` | Delta explicable y aceptado (ej: XU > SII porque SII no individualiza eriazos) | `media` |
| `error_levantamiento` | Confirmado error en XU; SII prevalece | `alta` |
| `sin_match` | Rol existe solo en una fuente, no en la otra | `preliminar` |

### `confidence_level` (enum)

| Valor | Cuándo |
|---|---|
| `preliminar` | Default. Detectado por sistema, sin revisión humana |
| `media` | Revisado por operador, sin cierre formal |
| `alta` | Conciliado con título o documento formal |
| `definitiva` | Conciliado con CBR y reconocido por mandante |

### Regla absoluta

```
NUNCA cerrar un delta basado solo en comparar SII vs XU.
SIEMPRE requiere al menos uno de:
  - Inscripción CBR
  - Escritura pública con plano
  - Acta de mensura aprobada por SII
```

Esta regla se aplica mediante `requires_cbr_validation = true` por default en la tabla `reconciliacion_catastral`.

---

## Aplicación por comuna

El campo `comunas.authority_rules` (JSONB) permite override por comuna:

```json
{
  "authority_hierarchy": {
    "fiscal": "sii_oficial",
    "operacional": "levantamiento_xpert_urban",
    "juridico": "cbr_titulos"
  },
  "default_priority_per_field": { ... },
  "reconciliation_default": "open_delta",
  "requires_cbr_to_close": true,
  "version": "1.0"
}
```

Comunas sin `tiene_levantamiento_xpert = true` operan únicamente con SII oficial (no requieren conciliación).

---

## Para futuros sistemas Meher OS / ITS

Esta regla canónica debe replicarse en cualquier sistema del grupo que mezcle fuentes catastrales públicas y privadas:

1. **Nunca borrar ni sobreescribir** datos de una fuente con otra
2. **Separar tablas por fuente**, con metadata explícita (`source_type`, `source_authority`)
3. **Registrar deltas** en tabla de reconciliación
4. **Marcar todo delta** como `open_delta` con `confidence_level = preliminar` por default
5. **Requerir validación CBR** para cerrar deltas significativos
6. **Cualificar siempre** los reportes — nunca "X ha reales", sí "X ha según fuente Y"

---

## Ejemplo concreto · Hijuela 2 Cominetti

| Atributo | Xpert Urban | SII oficial | Delta |
|---|---|---|---|
| Dominio | Operacional | Fiscal | — |
| Autoridad | privada | pública | — |
| Superficie (rol 24-123) | 1.402 ha | 26,4 ha | ×53 |
| Superficie (rol 24-160) | 299 ha | 3,0 ha | ×100 |
| Superficie (rol 24-47) | sin match | 5,0 ha | rol solo en SII |
| Total reconciliable | 1.701 ha | 34,4 ha | ×49 |
| Avalúo fiscal | n/a | UF 15.200 | — |
| Estado | `open_delta` · `preliminar` · requiere CBR | | |

**Interpretación**: La diferencia 49× es estructural — SII no individualiza fiscalmente los cerros/quebradas/eriazos que conforman la mayor parte del predio histórico. No es error de XU ni de SII: son dos mediciones de dimensiones distintas del mismo objeto.

**Acción**: requiere revisión de **escritura del mandato + plano del CBR La Serena** para confirmar la superficie legal vigente y conciliar.

---

## Mantenedor

Max Medina · max@xpu.cl · Magnus SpA
Modificaciones de esta regla requieren acuerdo del operador principal.
