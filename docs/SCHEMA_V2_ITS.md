# Schema ITS v2 — Doctrina Técnica

**Diseñado:** 2026-05-31
**Custodio:** Max Medina (Magnus SpA)
**Migration:** `db/migrations/0002_its_schema.sql`
**Doctrina base:** `CANON_HIJUELA2_v1.2` + ranking ITS Meher OS
**Estado:** **diseño · NO ejecutado en producción**

---

## 1 · Propósito

Materializar en infraestructura la ontología territorial estratificada validada en el caso Hijuela 2 Cominetti. La ontología sobrevivió una prueba hostil (superficies contradictorias, fuentes incompatibles, KMZ desactualizado, RTK moderno, estudio de títulos, SII, CBR). Ahora se vuelve esquema de base de datos.

**No es un experimento.** Es la consolidación de un patrón que sirvió, expresada en SQL.

---

## 2 · Principios arquitectónicos

### 2.1 · Separación v1 / v2 estricta

| Aspecto | v1 actual | v2 nuevo |
|---|---|---|
| Schema PostgreSQL | `public.*` | `its.*` |
| Tablas | `predios`, `predios_sii_oficial`, `reconciliacion_catastral`, `comunas`, etc. | `territorios`, `unidades_territoriales`, `representaciones_geometricas`, `superficies`, etc. |
| Frontend que consume | `web/index.html` actual | Pendiente — frontend v2 |
| Migración v1 → v2 | NO se hace automática | Manual, predio por predio, cuando hay valor de promoción |

**Coexisten sin conflicto.** El visor público sigue funcionando con `public.*`. El nuevo modelo opera en paralelo en `its.*`.

### 2.2 · Vocabulario de estados disciplinado

Implementado como enum PostgreSQL (`its.estado_evidencia`). Valores:

- `verificado` — respaldado por autoridad primaria (CBR, SII directo, título original, plano matriz)
- `identificado` — existe y se sabe cuál es; falta extracción completa
- `localizado_pendiente_extraccion` — se sabe dónde está y cómo conseguirlo; aún no se tiene
- `parcialmente_verificado` — un elemento confirmado, otro pendiente
- `hipotesis_de_trabajo` — explicación útil, evidencia indirecta, no promovida
- `conflicto_documentado` — divergencia entre fuentes registrada
- `superseded` — superado por evidencia/versión posterior, conservado
- `descalificado` — descartado por evidencia contraria firme

**Promoción de estado bloqueada por función SQL.** Una superficie solo sube a `verificado` con evidencia de autoridad primaria (función `its.promote_superficie_to_verified`). Una superficie no se promueve por presión operacional, query directa ni UPDATE manual sin pasar por la función.

### 2.3 · Múltiples es la norma

- Múltiples representaciones geométricas por unidad (Hijuela 2 tiene 4: G1, G2, G3, G4)
- Múltiples superficies por unidad (Hijuela 2 tiene 5: histórica, jurídica, RTK, mandato, fiscal)
- Múltiples titulares con participación (Hijuela 2 tiene 5: 3 hermanas + sucesión + Cantera Ltda.)
- Múltiples conflictos abiertos simultáneamente

Ninguna fuente sobrescribe a otra. Todas coexisten. La conciliación ocurre **entre capas, no entre números**.

### 2.4 · Append-only para cadena registral

`its.cadena_registral` no tiene UPDATE en flujo normal. Cada evento (compraventa, cesión, expropiación, mandato) es una fila inmutable con `capa_temporal` y `fecha`. La cadena se reconstruye por SELECT ordenado, no por mutación del estado.

### 2.5 · Evidencia primaria como ciudadano de primer nivel

`its.documentos_evidencia` es referenciada por casi todas las tablas. Cada hallazgo importante (una foto, una escritura, un plano, un oficio) tiene su fila, su hash, su ubicación física y digital. **La evidencia no vive solo en el data room: vive también en la base de datos**.

---

## 3 · Mapeo CANON → Schema

| CANON §X | Tabla v2 |
|---|---|
| §3 Unidad territorial | `its.territorios` + `its.unidades_territoriales` + `its.unidades_titulares` |
| §4 Representaciones geométricas G1-G4 | `its.representaciones_geometricas` |
| §5 Superficies declaradas | `its.superficies` |
| §6 Cadena registral esqueleto | `its.cadena_registral` |
| §7 Conflictos abiertos (13) | `its.conflictos` |
| §8.5 Matriz de autoridad explícita | `its.autoridades` |
| §8.6 Ranking canónico fuentes ITS | `its.fuentes_ranking` + `its.fuentes` |
| Hipótesis (regla 11 doctrina) | `its.hipotesis` |

---

## 4 · Decisiones arquitectónicas explícitas

### D1 · Por qué un schema separado en lugar de columnas nuevas en `public.predios`

El modelo v1 trata cada predio como una fila con atributos. El modelo v2 trata cada unidad territorial como un agregado de entidades relacionadas. Forzar el modelo v2 en la tabla `predios` produciría JSONB anidado infinito o joins de 7 tablas.

Solución: schema separado, ontología limpia. La migración de datos v1 → v2 se hace cuando hay valor de promoción, no por compulsión arquitectónica.

### D2 · Por qué `roles_sii` es array en lugar de tabla separada

Una unidad territorial puede tener 1 o N roles SII (Hijuela 2 tiene 2). Crear una tabla `its.unidades_roles_sii` es correcto académicamente, pero introduce un join adicional en cada consulta. PostgreSQL maneja arrays con índice GIN igual de rápido para esta cardinalidad.

Reversible: si en el futuro los roles necesitan atributos propios (fecha de cambio, motivo), se migra a tabla separada.

### D3 · Por qué `metadata JSONB` en varias tablas

Cada caso territorial tiene particularidades. Hijuela 2 tiene `mandato Magnus`. Dominga tendrá `RCA 028/2017`. Club Ecuestre tendrá `concesión municipal`. Forzar columnas dedicadas para cada particularidad infla el schema.

`metadata JSONB` con índice GIN permite extensibilidad sin migraciones. Cuando un campo del JSONB se vuelve transversal a múltiples casos, se promueve a columna dedicada.

### D4 · Por qué funciones SQL en lugar de validación a nivel aplicación

La disciplina epistemológica no puede depender de que cada cliente (frontend, scraper, MCP, script manual) recuerde no promover estados sin evidencia. La validación vive en la base de datos.

`its.promote_superficie_to_verified()` rechaza la promoción si la fuente del documento no es autoridad primaria. Esto es invariante por contrato, no por convención.

### D5 · Por qué RLS habilitada desde el inicio (no después)

Magnus Radar es uso interno hoy. Pero el patrón ITS es candidato a producto multi-tenant futuro (Tremen Combustible ya tiene 764 predios, otros activos del grupo Meher pueden incorporarse). Activar RLS desde el inicio elimina el riesgo de migración traumática posterior.

Política inicial: `service_role` full access, usuarios autenticados solo SELECT.

### D6 · Por qué `cadena_registral` es append-only

Una cadena dominical no se "edita". Si un evento se reinterpreta, se crea un evento nuevo de tipo `rectificacion` que lo supersede. Mantener history es valor jurídico, no overhead técnico.

### D7 · Por qué los conflictos viven en su propia tabla y no como columna de superficies

Un conflicto puede involucrar múltiples entidades (superficie + geometría + rol). Forzarlo a vivir como columna de una sola entidad mutila su naturaleza. Tabla propia con FK opcionales a varios elementos.

### D8 · Por qué hipótesis y conflictos son tablas distintas

Una hipótesis es una explicación posible que aún no se ha probado ni descartado. Un conflicto es una divergencia documentada entre fuentes. Categóricamente distintos. Mezclarlos diluye la disciplina.

`HIP_VELASQUEZ_PRE_1996` es hipótesis (puede ser cierto o falso). `SII_SURFACE_FACTOR_100` es conflicto (los números divergen, hay que ver cuál es correcto).

---

## 5 · Reutilización cross-proyecto

El schema NO menciona Hijuela 2, Cominetti, La Higuera ni Magnus en ninguna columna obligatoria. Todo lo específico vive en datos, no en estructura.

Para incorporar **Dominga**: insertar territorio Estancia La Higuera (si no existe), unidad territorial `dominga_sector_lineal`, sus representaciones geométricas del EIA, sus superficies declaradas en RCA 228/2017, sus conflictos abiertos (judicialización Corte Suprema), sus hipótesis (ampliaciones futuras). El schema lo absorbe sin modificación.

Para incorporar **Club Ecuestre**, **Mocito Guapo**, **Calera Tango**: mismo patrón.

Para incorporar predios urbanos simples sin conflicto: tendrán 1 representación geométrica, 1 superficie verificada, 0 conflictos, 0 hipótesis. El schema no penaliza la simplicidad.

---

## 6 · Plan de despliegue propuesto (NO ejecutado)

**Fase 0 · Validación humana**
- Max revisa el SQL completo
- Decisión: aprueba / pide ajustes / descarta

**Fase 1 · Despliegue en staging**
- Crear proyecto Supabase staging (independiente de producción)
- Ejecutar migration 0002_its_schema.sql
- Cargar Hijuela 2 como primer caso (caso de prueba referenciado en `HIJUELA_2_COMO_CASO_DE_PRUEBA.md`)
- Validar queries comunes: vista canónica, conflictos abiertos, superficies por capa

**Fase 2 · Despliegue en producción Supabase actual**
- Ejecutar migration en proyecto principal (no toca tablas v1)
- Cargar Hijuela 2 + opcional 1-2 casos adicionales (Dominga sector lineal?)
- No tocar `public.*`
- Backend v1 sigue sirviendo el frontend público

**Fase 3 · Frontend v2 piloto**
- Vista experimental en `magnus-radar/web/its.html` (ruta separada)
- Consume tablas `its.*`
- Demuestra: dashboard de conflictos abiertos, capa de superficies por autoridad, timeline de cadena registral
- Audiencia inicial: Max solamente

**Fase 4 · Decisión estratégica**
- Si v2 prueba valor → empezar migración progresiva de casos
- Si v2 no prueba valor → mantener en standby, retroalimenta v1 con aprendizajes

**Fase 5 · Producto?**
- Solo si Fase 3-4 muestran que el patrón vale la pena para otros usuarios

---

## 7 · Lo que NO está en este diseño (decisiones explícitas)

- **Versionado bitemporal** (sistema_time vs valid_time). Posible en v3 si emerge necesidad. Hoy sería overhead.
- **Workflow de aprobación de cambios** (PR-style review en datos). Posible vía Airtable + sync, fuera del schema.
- **Audit log automático** (quién cambió qué y cuándo). Posible con triggers + tabla `its.audit_log` si emerge necesidad.
- **Soft deletes universales**. El schema usa hard delete con CASCADE. La cadena_registral es append-only por contrato, no se borra.
- **Internacionalización** (textos en múltiples idiomas). Magnus Radar es operación Chile.

---

## 8 · Próximos pasos concretos

1. Max revisa el SQL completo (`db/migrations/0002_its_schema.sql`) — 30 minutos lectura crítica
2. Ajustes finos antes de ejecutar
3. Crear proyecto Supabase staging O ejecutar en producción (decisión Max — staging es más seguro pero requiere setup)
4. Cargar Hijuela 2 con el mapeo de `HIJUELA_2_COMO_CASO_DE_PRUEBA.md`
5. Validar que la vista `its.unidad_canonica` devuelve el cuadro esperado
6. Decidir si Hijuela 2 sola justifica el v2 o si conviene cargar 1-2 casos más antes de evaluar valor

---

## 9 · Lo que cambia este diseño respecto del v1

| Aspecto | v1 | v2 |
|---|---|---|
| Modelo conceptual | Predio = fila | Unidad territorial = agregado de entidades |
| Superficie | Atributo simple del predio | Múltiples por unidad, cada una con capa + autoridad |
| Geometría | Una por predio | Múltiples concurrentes, ninguna sobreescribe |
| Conflictos | Tabla aparte (reconciliacion_catastral) | Categoría de primer nivel con tipo, autoridad resolutiva, estado |
| Hipótesis | No existe el concepto | Tabla dedicada con estados de promoción |
| Autoridades | Implícita en código de aplicación | Matriz explícita por unidad x dominio |
| Promoción de estado | Posible por cualquier UPDATE | Bloqueada por función SQL con validación de fuente |
| Cadena registral | No existe | Append-only con capa temporal |
| Reutilización | Específico La Higuera | Reutilizable cualquier expediente complejo del grupo |

---

## 10 · Crítica honesta del diseño

**Lo que puede salir mal:**

- **Overfitting a Hijuela 2.** El esquema fue diseñado mirando un caso. Es posible que Dominga revele necesidades nuevas (p.ej. RCA, expedientes ambientales como categoría propia). Mitigación: `metadata JSONB` absorbe particularidades hasta que se promuevan a estructura.

- **Complejidad cognitiva.** 11 tablas es mucho para un equipo pequeño. Mitigación: vistas operacionales (`its.unidad_canonica`, `its.superficies_por_unidad`) ocultan complejidad para usuarios cotidianos.

- **Migración futura desde v1.** No hay script automático. Cuando se decida migrar, será trabajo manual caso por caso. Esto es intencional: la migración debe ser oportunidad de revisión, no operación batch.

- **Performance bajo escala.** El diseño asume cientos de unidades territoriales, no millones. Si Tremen Combustible (764 predios) entra al modelo, está dentro de rango. Si entran 100.000 predios fiscales, hay que re-evaluar índices.

- **Disciplina depende de discipline.** Las funciones SQL bloquean promoción sin evidencia primaria, pero alguien con `service_role` puede hacer UPDATE directo saltándose la función. La disciplina es contrato de equipo, no garantía técnica absoluta.

**Lo que claramente sale bien:**

- Cualquier caso puede convivir con su complejidad real
- La doctrina del CANON ya no vive solo en Markdown — vive también en restricciones de base de datos
- Hijuela 2 deja de ser "el caso especial complicado" y se vuelve "el primer caso bien modelado"
- Trabajos futuros pueden empezar con un template, no con cero
