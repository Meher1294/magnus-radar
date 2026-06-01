# Despliegue Schema ITS v2 en Staging

**Objetivo:** ejecutar `0002 + 0002b` en proyecto Supabase staging (NO producción), cargar Hijuela 2 como fixture único, correr tests de invariantes, validar resultados.

**Custodio:** Max Medina
**Última actualización:** 2026-05-31

---

## Pre-requisitos

- Cuenta Supabase con permisos para crear proyectos nuevos
- Acceso SQL Editor del proyecto staging
- Plan free es suficiente (Hijuela 2 + tests = < 100 MB)

---

## Paso 1 · Crear proyecto Supabase staging

1. Ir a https://supabase.com/dashboard
2. New project → nombre: `magnus-radar-its-staging`
3. Región: South America (São Paulo) — misma latencia que producción
4. Generar database password (anotar en gestor de contraseñas)
5. Esperar provisión (~2 min)

**Lo que NO toca este proyecto:**
- Proyecto producción Magnus Radar
- Tablas `public.*` actuales
- Frontend desplegado

---

## Paso 2 · Aplicar schema base 0001

Ejecutar en SQL Editor (en orden):

```sql
-- 1) Extensiones base
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```

Luego copiar/pegar todo el contenido de `db/migrations/0001_initial_schema.sql` y ejecutar.

Verificar:
```sql
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public' ORDER BY table_name;
-- Esperado: predios, comunas, proyectos_seia, derechos_agua, etc.
```

---

## Paso 3 · Aplicar schema ITS v2 (0002)

Copiar/pegar todo el contenido de `db/migrations/0002_its_schema.sql` y ejecutar.

**Importante:** ejecutar como UN solo bloque. PostgreSQL aplica todas las sentencias en una transacción.

Verificar:
```sql
-- Schema its existe
SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'its';

-- Tablas creadas (esperar 11)
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'its' ORDER BY table_name;
-- Esperado: autoridades, cadena_registral, conflictos, documentos_evidencia,
-- fuentes, fuentes_ranking, hipotesis, representaciones_geometricas,
-- superficies, territorios, titulares, unidades_titulares, unidades_territoriales

-- Enums creados
SELECT typname FROM pg_type WHERE typname LIKE '%its%' OR typname IN
  ('estado_evidencia','tipo_representacion','naturaleza_superficie',
   'tipo_evento_registral','tipo_conflicto','naturaleza_fuente');

-- Vistas creadas
SELECT viewname FROM pg_views WHERE schemaname = 'its';
-- Esperado: unidad_canonica, superficies_por_unidad, conflictos_abiertos

-- Ranking ITS precargado
SELECT * FROM its.fuentes_ranking ORDER BY prioridad;
-- Esperado: 8 filas, prio 1 = IDE Chile, prio 8 = SEIA/SMA/DGA
```

---

## Paso 4 · Aplicar hardening 0002b

**IMPORTANTE: ejecutar en bloques separados por commits implícitos del SQL Editor de Supabase.**

Razón técnica: `ALTER TYPE ... ADD VALUE` no puede usarse en la misma transacción donde se crea. En el SQL Editor de Supabase, cada "Run" es una transacción.

### Paso 4.1 · Hardening principal (todo excepto ALTER TYPE)

Copiar de `0002b_hardening.sql` desde el inicio hasta justo antes de la sección "FIX 5 · Extender tipo_evento_registral". Ejecutar como un solo bloque.

Verificar:
```sql
-- Audit log creado
SELECT count(*) FROM its.estado_changes_log;  -- esperado: 0

-- Vista sospechosos
SELECT * FROM its.estado_cambios_sospechosos;  -- esperado: vacío

-- Función cambiar_estado existe
SELECT proname FROM pg_proc WHERE proname = 'cambiar_estado' AND pronamespace = 'its'::regnamespace;

-- autoridades tiene capa_temporal
SELECT column_name FROM information_schema.columns
WHERE table_schema='its' AND table_name='autoridades' AND column_name='capa_temporal';
```

### Paso 4.2 · Extensión de enums (FIX 5)

Ejecutar solo el bloque "FIX 5" del `0002b_hardening.sql`:

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

Verificar:
```sql
SELECT unnest(enum_range(NULL::its.tipo_evento_registral));
-- Esperado: lista con permiso_edificacion, imiv_aprobado, etc.
```

---

## Paso 5 · Cargar fixture Hijuela 2

Usar el SQL del archivo `docs/HIJUELA_2_COMO_CASO_DE_PRUEBA.md` sección 1 — adaptar para reemplazar los placeholders `$TERRITORIO_LA_HIGUERA`, `$UNIDAD_HIJUELA_2`, etc. con los UUIDs reales devueltos por los INSERTs anteriores.

**Patrón de ejecución (para evitar manejo manual de UUIDs):**

```sql
DO $$
DECLARE
  v_territorio_id UUID;
  v_unidad_id UUID;
  v_silvia_id UUID;
  v_claudia_id UUID;
  -- ... etc
BEGIN
  -- Territorio matriz
  INSERT INTO its.territorios (nombre, tipo, comuna, provincia, region, rol_sii_matriz, superficie_aprox_ha, notas)
  VALUES ('Estancia La Higuera', 'estancia', 'La Higuera', 'Elqui', 'Coquimbo', '24-5', 60000,
          'Matriz envolvente. Titular Andes Iron SpA RUT 76.097.759-4 desde 16-ago-2021.')
  RETURNING id INTO v_territorio_id;

  -- Unidad Hijuela 2
  INSERT INTO its.unidades_territoriales (territorio_id, codigo, nombre, roles_sii, comuna_codigo, superficie_reportada_ha, superficie_reportada_fuente, estado, notas)
  VALUES (v_territorio_id, 'hijuela_2_cominetti', 'Hijuela 2 de la Estancia La Higuera',
          ARRAY['24-123','24-160'], '4102', 2139.35, 'estudio_titulos_consolidado', 'identificado',
          'Enclave dentro matriz Andes Iron')
  RETURNING id INTO v_unidad_id;

  -- Resto del fixture: titulares, geometrías, superficies, etc.
  -- (copiar bloques de docs/HIJUELA_2_COMO_CASO_DE_PRUEBA.md)
END $$;
```

Verificar:
```sql
SELECT * FROM its.unidad_canonica WHERE unidad_codigo = 'hijuela_2_cominetti';
-- Esperado:
--   unidad_codigo: hijuela_2_cominetti
--   territorio: Estancia La Higuera
--   roles_sii: {24-123,24-160}
--   n_geometrias: 4 (G1, G2, G3, G4)
--   n_superficies: 5
--   n_autoridades: 13
--   n_titulares: 5
```

---

## Paso 6 · Correr tests de invariantes

Copiar `db/tests/0002_invariantes.sql` completo al SQL Editor. Ejecutar.

**El archivo está envuelto en `BEGIN ... ROLLBACK`**, así que ninguna modificación se persiste. Lo que sí queda es el output de RAISE NOTICE.

**Resultados esperados:**

```
--- TEST 1: promoción a verificado sin evidencia primaria ---
PASS · Promoción rechazada correctamente: ...

--- TEST 2: UPDATE directo a estado deja huella en audit log ---
PASS · Audit log capturó el cambio: 0 → 1
PASS · Log identifica cambio sin via_funcion (UPDATE directo)

--- TEST 3: vista superficies_por_unidad devuelve TODAS las superficies ---
PASS · Vista devuelve las 5 superficies de Hijuela 2 (sin winner)
PASS · No hay columna de "winner" implícito en superficies

--- TEST 4: vista conflictos_abiertos no rompe con N conflictos ---
PASS · Vista devuelve N conflictos abiertos
PASS · Vista devuelve 0 conflictos sin error

--- TEST 5: enum tipo_evento_registral con eventos municipales ---
PASS · permiso_edificacion existe en enum
PASS · imiv_aprobado existe en enum

--- TEST 6: documentos_evidencia tipo digital sin hash es rechazado ---
PASS · Constraint chk_hash_digital rechazó PDF sin hash
PASS · Insert de PDF con hash aceptado

--- TEST 7: autoridades permite mismo dominio en distintas capas ---
PASS · 2 autoridades coexisten para mismo dominio en distintas capas

--- TEST 8: cambiar_estado disciplinado registra via_funcion ---
PASS · Log capturó via_funcion + documento + motivo
```

**Si algún PASS sale como FAIL:** documentar exactamente cuál, screenshot del error, ROLLBACK no requiere acción (los tests son transaccionales), y revisar.

---

## Paso 7 · Validación visual mínima

Conectarse al staging desde `psql` o cliente DB:

```bash
psql "postgresql://postgres:[PASSWORD]@db.[PROJECT_REF].supabase.co:5432/postgres"
```

Queries de validación visual:

```sql
-- Ficha completa de Hijuela 2
SELECT
  u.nombre,
  u.roles_sii,
  array_agg(DISTINCT r.codigo) AS representaciones,
  array_agg(DISTINCT s.codigo) AS superficies,
  count(DISTINCT c.id) AS n_conflictos_abiertos
FROM its.unidades_territoriales u
LEFT JOIN its.representaciones_geometricas r ON r.unidad_id = u.id
LEFT JOIN its.superficies s ON s.unidad_id = u.id
LEFT JOIN its.conflictos c ON c.unidad_id = u.id AND c.estado = 'conflicto_documentado'
WHERE u.codigo = 'hijuela_2_cominetti'
GROUP BY u.id, u.nombre, u.roles_sii;

-- Matriz de autoridad Hijuela 2 (debe verse como el §8.5 del CANON)
SELECT dominio, autoridad_actual, estado, capa_temporal
FROM its.autoridades a
WHERE a.unidad_id = (SELECT id FROM its.unidades_territoriales WHERE codigo = 'hijuela_2_cominetti')
ORDER BY capa_temporal NULLS LAST, dominio;

-- Cadena registral cronológica
SELECT capa_temporal, fecha, tipo_evento, inscripcion, descripcion
FROM its.cadena_registral
WHERE unidad_id = (SELECT id FROM its.unidades_territoriales WHERE codigo = 'hijuela_2_cominetti')
ORDER BY capa_temporal, fecha;
```

---

## Paso 8 · Si todo PASS

**Opciones:**

A. **Mantener staging activo** para experimentación visual v2 (`web/its.html`). Bajo costo (proyecto free).

B. **Replicar en producción** ejecutando 0001 + 0002 + 0002b en proyecto principal. NO toca `public.*` actual. El visor sigue funcionando.

C. **Esperar a tener wireframe v2** antes de replicar en producción. Más seguro.

**Recomendación:** opción C. Materializar el frontend v2 contra staging primero. Si v2 prueba valor → replicar schema en producción + redirigir tráfico interno a v2.

---

## Paso 9 · Si algo FAIL

- ROLLBACK ya aplicado por los tests transaccionales (nada se persiste)
- Documentar el FAIL específico
- Volver al archivo SQL correspondiente, corregir, re-ejecutar staging
- NO replicar en producción hasta que todos los tests pasen

---

## Glosario rápido para SQL Editor de Supabase

- `RUN` ejecuta el contenido del editor como una transacción
- `\set ON_ERROR_STOP 0` no funciona en SQL Editor (es de psql) — solo en psql CLI
- `RAISE NOTICE` aparece en el panel "Notices" del SQL Editor
- Tablas de schema `its.*` aparecen en Table Editor → filtrar por schema `its`

---

## Costo monetario y de tiempo estimado

- Proyecto Supabase staging: **gratis** (plan free)
- Tiempo ejecución Pasos 2-6: **30-45 minutos** (mayormente lectura crítica + verificación)
- Tiempo de troubleshooting si hay FAIL: variable

---

## Lo que NO se hace en este despliegue

- NO se carga Dominga PE (track lento, indexar después)
- NO se carga otra unidad territorial (solo Hijuela 2 como fixture único)
- NO se modifica producción
- NO se construye frontend v2 (siguiente etapa)
