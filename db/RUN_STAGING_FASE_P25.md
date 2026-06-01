# RUN STAGING · Fase P2.5 · Validación de Schema 0003

**Objetivo:** Crear proyecto Supabase staging exclusivo, aplicar `0002 + 0002b + 0003`, cargar fixture Hijuela 2 y validar las 5 dimensiones críticas antes de habilitar UI o producción.

**Custodio:** Max Medina
**Versión runbook:** 2026-05-31 v1
**Tiempo estimado:** 60-90 minutos de trabajo manual + validación

---

## Pre-requisitos

- Cuenta Supabase con permiso para crear proyectos nuevos
- Acceso a SQL Editor del proyecto staging que se creará
- Plan free es suficiente (Hijuela 2 + tests = < 50 MB)

---

## Criterio de salida (5 condiciones obligatorias)

P3 (UI del grafo) NO se autoriza hasta cumplir:

```yaml
artefactos:        cargados: true
relaciones:        cargadas: true
cte_recursivo:     validado: true
propagacion:       validada: true
audit_log:         validado: true
```

Si CUALQUIERA falla, el problema es del modelo, NO de la interfaz. Reportar y corregir el schema antes de seguir.

---

## Paso 1 · Crear proyecto Supabase staging exclusivo

1. Ir a https://supabase.com/dashboard
2. **New project**:
   - **Nombre:** `magnus-its-staging`
   - **Región:** South America (São Paulo) — coincide con producción
   - **Database password:** generar nuevo · anotar en gestor de contraseñas
3. Esperar provisión (~2 minutos)

**Lo que NO toca este proyecto:**
- Magnus Radar producción (`curqkgujgtimlutinhgu.supabase.co`)
- Frontend desplegado en GitHub Pages
- Datos catastrales v1 actuales

---

## Paso 2 · Habilitar extensiones base

Abrir SQL Editor → New query → pegar y ejecutar:

```sql
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```

**Verificación:**
```sql
SELECT extname, extversion FROM pg_extension WHERE extname IN ('postgis','uuid-ossp','pgcrypto');
```
Esperado: 3 filas.

---

## Paso 3 · Aplicar schema 0002 (ITS v2 base)

Copiar contenido completo de `db/migrations/0002_its_schema.sql` y ejecutar como UN solo bloque.

**Verificación:**
```sql
-- Schema its existe
SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'its';

-- 13 tablas its.* (esperadas: territorios, unidades_territoriales, representaciones_geometricas,
-- superficies, autoridades, hipotesis, conflictos, cadena_registral, fuentes, fuentes_ranking,
-- titulares, unidades_titulares, documentos_evidencia)
SELECT table_name FROM information_schema.tables WHERE table_schema = 'its' ORDER BY table_name;

-- Ranking ITS precargado (esperado: 8 filas, prio 1 = IDE Chile)
SELECT * FROM its.fuentes_ranking ORDER BY prioridad;
```

**Si algún paso falla → STOP. No avanzar.**

---

## Paso 4 · Aplicar hardening 0002b

**Paso 4.1** · Hardening principal (todo excepto enum ALTER TYPE):

Copiar de `db/migrations/0002b_hardening.sql` desde el inicio hasta justo antes de la sección "FIX 5". Ejecutar como un solo bloque.

**Verificación:**
```sql
SELECT count(*) FROM its.estado_changes_log;  -- esperado: 0
SELECT proname FROM pg_proc WHERE proname IN ('cambiar_estado', 'log_estado_change');
```

**Paso 4.2** · Extensión enums (FIX 5 del 0002b):

```sql
ALTER TYPE its.tipo_evento_registral ADD VALUE IF NOT EXISTS 'permiso_anteproyecto';
ALTER TYPE its.tipo_evento_registral ADD VALUE IF NOT EXISTS 'permiso_edificacion';
ALTER TYPE its.tipo_evento_registral ADD VALUE IF NOT EXISTS 'permiso_loteo';
ALTER TYPE its.tipo_evento_registral ADD VALUE IF NOT EXISTS 'recepcion_definitiva';
ALTER TYPE its.tipo_evento_registral ADD VALUE IF NOT EXISTS 'cambio_uso_suelo';
ALTER TYPE its.tipo_evento_registral ADD VALUE IF NOT EXISTS 'imiv_aprobado';
ALTER TYPE its.tipo_evento_registral ADD VALUE IF NOT EXISTS 'aporte_espacio_publico';
ALTER TYPE its.naturaleza_fuente ADD VALUE IF NOT EXISTS 'municipalidad';
```

---

## Paso 5 · Aplicar schema 0003 (grafo de artefactos)

Copiar contenido completo de `db/migrations/0003_artefactos_grafo.sql` y ejecutar como UN solo bloque.

**Verificación:**
```sql
-- 3 tablas nuevas
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'its'
  AND table_name IN ('artefactos','relaciones_artefactos','eventos_validacion');

-- 8 enums nuevos
SELECT typname FROM pg_type WHERE typname IN (
  'tipo_artefacto','naturaleza_geo_v2','source_truth_v2','jerarquia_fuente_v2',
  'tipo_relacion','modo_propagacion','uso_artefacto','tipo_evento_validacion'
);

-- 3 vistas nuevas
SELECT viewname FROM pg_views WHERE schemaname = 'its'
  AND viewname IN ('artefactos_afectados_si_descalifico','grafo_artefactos_resumen','eventos_sospechosos');

-- Función propagar_degradacion
SELECT proname FROM pg_proc WHERE proname = 'propagar_degradacion';
```

Esperado: 3 tablas, 8 enums, 3 vistas, 1 función.

---

## Paso 6 · Cargar fixture unidad territorial Hijuela 2

**Pre-requisito:** el seed 0003 asume que `its.unidades_territoriales` tiene `codigo = 'hijuela_2_cominetti'`.

Si NO existe, cargar primero con bloque mínimo:

```sql
DO $$
DECLARE
  v_terr UUID;
BEGIN
  INSERT INTO its.territorios (nombre, tipo, comuna, provincia, region, rol_sii_matriz, superficie_aprox_ha)
  VALUES ('Estancia La Higuera', 'estancia', 'La Higuera', 'Elqui', 'Coquimbo', '24-5', 60000)
  RETURNING id INTO v_terr;

  INSERT INTO its.unidades_territoriales (territorio_id, codigo, nombre, roles_sii, comuna_codigo, estado)
  VALUES (v_terr, 'hijuela_2_cominetti', 'Hijuela 2 de la Estancia La Higuera',
          ARRAY['24-123','24-160'], '4102', 'identificado');
END $$;

-- Verificar:
SELECT id, codigo, nombre FROM its.unidades_territoriales WHERE codigo = 'hijuela_2_cominetti';
```

Esperado: 1 fila.

---

## Paso 7 · Cargar seed 0003 (13 artefactos + 21 relaciones)

Copiar contenido completo de `db/seeds/0003_artefactos_hijuela_2.sql` y ejecutar.

Al final debe aparecer en el panel "Messages":

```
NOTICE: ✓ Cargados 13 artefactos y 21 dependencias REALES (sin inventar)
```

---

## Paso 8 · Validación · 5 dimensiones críticas

Ejecutar `db/tests/0003_validation.sql` completo. Esperado output:

```
=== ARTEFACTOS ===
artefactos: 13 (esperado 13) → PASS
artefactos con afectado_proxy_corrido = TRUE: 11 (esperado 11) → PASS
artefactos vigencia = descalificada: 9 (esperado 9) → PASS

=== RELACIONES ===
relaciones totales: 21 (esperado 21) → PASS
modo_propagacion = automatica_fuerte: 13 → PASS
modo_propagacion = sugerida_humana: 8 → PASS

=== CTE RECURSIVO ===
descendientes de GEO-TOPO-COMINETTI-2007: 10 → PASS
nivel máximo alcanzado: 3 → PASS

=== PROPAGACION ===
ejecución de propagar_degradacion() ejecuta sin error → PASS
artefactos marcados nuevos: 0 (ya estaban marcados desde seed) → INFO
eventos_validacion generados: 10 → PASS

=== AUDIT LOG ===
eventos totales: ≥ 10 → PASS
eventos tipo propagacion_recibida: 10 → PASS
eventos sospechosos: 0 → PASS
```

Cada PASS confirma una dimensión del criterio de salida. **Si TODOS son PASS, el modelo soporta la realidad.**

---

## Paso 9 · Decisión post-validación

Caso 1 · **Todos PASS:**
- Schema 0003 está validado contra realidad operacional
- Autorización para abrir P3 (UI del grafo) o pasar a P4 (auditoría KMZ/PDF/DWG)
- Reportar a Max para decisión sobre siguiente fase

Caso 2 · **Algún FAIL:**
- DOCUMENTAR exactamente qué dimensión falló y qué devolvió
- NO ejecutar más SQL en staging
- Reportar a Max
- Diagnóstico: el problema está en `0003_artefactos_grafo.sql` o `0003_artefactos_hijuela_2.sql`
- Corregir SQL → re-aplicar en staging → re-validar

---

## Paso 10 · Limpieza post-validación

Si todo PASS, el proyecto staging puede:

A. **Mantenerse activo** para futuras pruebas (gratuito si free tier)
B. **Pausarse** desde Supabase dashboard
C. **Eliminarse** una vez que la doctrina + schema se hayan replicado en producción real

Recomendación: **A** durante la fase de desarrollo activo (próximas 4-6 semanas).

---

## Reporte de vuelta esperado

Cuando ejecutes este runbook, devuelve por chat:

```text
=== RUN_STAGING_FASE_P25 ejecutado ===

Paso 1 · proyecto creado: sí/no · región
Paso 2 · extensiones OK: sí/no
Paso 3 · schema 0002 aplicado: sí/no · errores observados
Paso 4 · hardening 0002b aplicado: sí/no
Paso 5 · schema 0003 aplicado: sí/no
Paso 6 · unidad Hijuela 2 cargada: sí/no
Paso 7 · seed cargado: NOTICE recibida sí/no
Paso 8 · validación: pegar output completo de los 5 bloques

Decisión propuesta: avanzar a P3 / corregir / otro
```

Con eso podemos decidir el siguiente paso con evidencia, no con suposición.

---

## Lo que este runbook NO automatiza (intencionalmente)

- Crear el proyecto Supabase (decisión humana de credenciales)
- Modificar URL de Supabase en frontend (todavía no, P3 lo decidirá)
- Cargar más unidades territoriales (solo Hijuela 2 por ahora)
- Conectar frontend Magnus al staging (eso es decisión de Fase P3+)

---

## Riesgos conocidos

| Riesgo | Probabilidad | Mitigación |
|---|---|---|
| ALTER TYPE no se puede usar en misma transacción que lo crea | media | Paso 4 se divide en 4.1 y 4.2 separados |
| Función `propagar_degradacion` requiere CTE recursivo PostgreSQL ≥ 12 | baja | Supabase usa PG 15+ por defecto |
| Seed asume unidad Hijuela 2 existe | alta si saltás Paso 6 | Paso 6 obligatorio |
| Triggers de audit log en 0002b pueden hacer ruido en seed | baja | Tests SQL filtran eventos relevantes |
| pgcrypto faltante hace fallar `gen_random_uuid()` | media | Paso 2 lo asegura |
