-- =============================================================================
-- Tests de Invariantes · Schema ITS v2 (0002 + 0002b)
-- =============================================================================
--
-- Ejecutar EN STAGING después de aplicar 0001_initial_schema + 0002_its_schema + 0002b_hardening
-- Requiere fixture mínimo: 1 unidad_territorial (Hijuela 2) con sus relaciones
-- Usar psql / Supabase SQL Editor — NO ejecutar en producción
--
-- Cada test imprime PASS/FAIL via RAISE NOTICE
-- =============================================================================

\set ON_ERROR_STOP 0
\timing on

BEGIN;

-- -----------------------------------------------------------------------------
-- TEST 1 · Promoción a 'verificado' sin evidencia debe ser RECHAZADA
-- -----------------------------------------------------------------------------

DO $$
DECLARE
  v_superficie_id UUID;
  v_resultado_ok BOOLEAN := FALSE;
BEGIN
  RAISE NOTICE '--- TEST 1: promoción a verificado sin evidencia primaria ---';

  -- Obtener una superficie existente en estado distinto a verificado
  SELECT id INTO v_superficie_id
  FROM its.superficies
  WHERE estado != 'verificado'
  LIMIT 1;

  IF v_superficie_id IS NULL THEN
    -- Crear una superficie de test
    INSERT INTO its.superficies (
      unidad_id, codigo, naturaleza, valor_ha, estado
    ) VALUES (
      (SELECT id FROM its.unidades_territoriales WHERE codigo = 'hijuela_2_cominetti'),
      'test_superficie_promocion', 'historica_matriz', 100, 'hipotesis_de_trabajo'
    ) RETURNING id INTO v_superficie_id;
  END IF;

  -- Intentar promover sin documento — debe fallar
  BEGIN
    PERFORM its.cambiar_estado(
      'superficies'::TEXT,
      v_superficie_id,
      'verificado'::TEXT,
      NULL,  -- sin documento evidencia
      'Test 1: intento de promoción ilegal'
    );
    v_resultado_ok := FALSE;
    RAISE NOTICE 'FAIL · Promoción sin evidencia NO fue rechazada';
  EXCEPTION
    WHEN OTHERS THEN
      v_resultado_ok := TRUE;
      RAISE NOTICE 'PASS · Promoción rechazada correctamente: %', SQLERRM;
  END;

  -- Cleanup
  DELETE FROM its.superficies WHERE codigo = 'test_superficie_promocion';
END $$;

-- -----------------------------------------------------------------------------
-- TEST 2 · UPDATE directo a columna estado deja huella en audit log
-- -----------------------------------------------------------------------------

DO $$
DECLARE
  v_superficie_id UUID;
  v_log_count_before INT;
  v_log_count_after INT;
BEGIN
  RAISE NOTICE '--- TEST 2: UPDATE directo a estado deja huella en audit log ---';

  -- Crear superficie de test
  INSERT INTO its.superficies (
    unidad_id, codigo, naturaleza, valor_ha, estado
  ) VALUES (
    (SELECT id FROM its.unidades_territoriales WHERE codigo = 'hijuela_2_cominetti'),
    'test_superficie_audit', 'historica_matriz', 200, 'identificado'
  ) RETURNING id INTO v_superficie_id;

  SELECT count(*) INTO v_log_count_before
  FROM its.estado_changes_log
  WHERE tabla = 'superficies' AND registro_id = v_superficie_id;

  -- UPDATE directo (sin función disciplinada)
  UPDATE its.superficies
  SET estado = 'parcialmente_verificado'
  WHERE id = v_superficie_id;

  SELECT count(*) INTO v_log_count_after
  FROM its.estado_changes_log
  WHERE tabla = 'superficies' AND registro_id = v_superficie_id;

  IF v_log_count_after > v_log_count_before THEN
    RAISE NOTICE 'PASS · Audit log capturó el cambio: % → %', v_log_count_before, v_log_count_after;
  ELSE
    RAISE NOTICE 'FAIL · Audit log NO capturó el cambio';
  END IF;

  -- Verificar que el log identifica el cambio como sospechoso si aplica
  IF EXISTS (
    SELECT 1 FROM its.estado_changes_log
    WHERE tabla = 'superficies' AND registro_id = v_superficie_id
      AND estado_anterior = 'identificado' AND estado_nuevo = 'parcialmente_verificado'
      AND via_funcion IS NULL
  ) THEN
    RAISE NOTICE 'PASS · Log identifica cambio sin via_funcion (UPDATE directo)';
  ELSE
    RAISE NOTICE 'FAIL · Log no marca correctamente UPDATE directo';
  END IF;

  -- Cleanup
  DELETE FROM its.estado_changes_log WHERE registro_id = v_superficie_id;
  DELETE FROM its.superficies WHERE id = v_superficie_id;
END $$;

-- -----------------------------------------------------------------------------
-- TEST 3 · Vista superficies_por_unidad NO selecciona winner
-- -----------------------------------------------------------------------------

DO $$
DECLARE
  v_count_superficies INT;
  v_unidad_id UUID;
BEGIN
  RAISE NOTICE '--- TEST 3: vista superficies_por_unidad devuelve TODAS las superficies ---';

  SELECT id INTO v_unidad_id
  FROM its.unidades_territoriales
  WHERE codigo = 'hijuela_2_cominetti';

  -- Hijuela 2 debe tener 5 superficies según fixture
  SELECT count(*) INTO v_count_superficies
  FROM its.superficies_por_unidad
  WHERE unidad_codigo = 'hijuela_2_cominetti';

  IF v_count_superficies = 5 THEN
    RAISE NOTICE 'PASS · Vista devuelve las 5 superficies de Hijuela 2 (sin winner)';
  ELSE
    RAISE NOTICE 'FAIL · Vista devuelve % superficies, esperadas 5', v_count_superficies;
  END IF;

  -- Verificar que NO existe columna "is_canonical" o similar
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'its'
      AND table_name = 'superficies'
      AND column_name IN ('is_canonical','is_winner','is_default','is_primary')
  ) THEN
    RAISE NOTICE 'PASS · No hay columna de "winner" implícito en superficies';
  ELSE
    RAISE NOTICE 'FAIL · Detectada columna implícita de winner — viola doctrina';
  END IF;
END $$;

-- -----------------------------------------------------------------------------
-- TEST 4 · Vista conflictos_abiertos funciona con 0 y N conflictos
-- -----------------------------------------------------------------------------

DO $$
DECLARE
  v_n_conflictos INT;
BEGIN
  RAISE NOTICE '--- TEST 4: vista conflictos_abiertos no rompe con N conflictos ---';

  -- Hijuela 2 debe tener varios conflictos abiertos en fixture
  SELECT count(*) INTO v_n_conflictos
  FROM its.conflictos_abiertos
  WHERE unidad = 'hijuela_2_cominetti';

  IF v_n_conflictos >= 5 THEN
    RAISE NOTICE 'PASS · Vista devuelve % conflictos abiertos (>=5 esperados)', v_n_conflictos;
  ELSE
    RAISE NOTICE 'WARN · Solo % conflictos abiertos, esperaba más', v_n_conflictos;
  END IF;

  -- Resolver TODOS los conflictos temporalmente
  UPDATE its.conflictos SET estado = 'verificado'
  WHERE unidad_id = (SELECT id FROM its.unidades_territoriales WHERE codigo = 'hijuela_2_cominetti');

  SELECT count(*) INTO v_n_conflictos
  FROM its.conflictos_abiertos
  WHERE unidad = 'hijuela_2_cominetti';

  IF v_n_conflictos = 0 THEN
    RAISE NOTICE 'PASS · Vista devuelve 0 conflictos sin error';
  ELSE
    RAISE NOTICE 'FAIL · Vista no filtra correctamente: % filas con 0 conflictos abiertos esperados', v_n_conflictos;
  END IF;

  -- ROLLBACK al estado original
  -- (las modificaciones quedan en transacción, ROLLBACK al final del archivo)
END $$;

-- -----------------------------------------------------------------------------
-- TEST 5 · Enum tipo_evento_registral incluye eventos municipales
-- -----------------------------------------------------------------------------

DO $$
DECLARE
  v_existe BOOLEAN;
BEGIN
  RAISE NOTICE '--- TEST 5: enum tipo_evento_registral con eventos municipales ---';

  SELECT EXISTS(
    SELECT 1 FROM pg_enum e
    JOIN pg_type t ON e.enumtypid = t.oid
    WHERE t.typname = 'tipo_evento_registral' AND e.enumlabel = 'permiso_edificacion'
  ) INTO v_existe;

  IF v_existe THEN
    RAISE NOTICE 'PASS · permiso_edificacion existe en enum';
  ELSE
    RAISE NOTICE 'FAIL · permiso_edificacion NO está en enum';
  END IF;

  SELECT EXISTS(
    SELECT 1 FROM pg_enum e
    JOIN pg_type t ON e.enumtypid = t.oid
    WHERE t.typname = 'tipo_evento_registral' AND e.enumlabel = 'imiv_aprobado'
  ) INTO v_existe;

  IF v_existe THEN
    RAISE NOTICE 'PASS · imiv_aprobado existe en enum';
  ELSE
    RAISE NOTICE 'FAIL · imiv_aprobado NO está en enum';
  END IF;
END $$;

-- -----------------------------------------------------------------------------
-- TEST 6 · documentos_evidencia · hash obligatorio para tipos digitales
-- -----------------------------------------------------------------------------

DO $$
DECLARE
  v_resultado_ok BOOLEAN := FALSE;
BEGIN
  RAISE NOTICE '--- TEST 6: documentos_evidencia tipo digital sin hash es rechazado ---';

  -- Intentar insertar un PDF sin hash — debe fallar
  BEGIN
    INSERT INTO its.documentos_evidencia (
      tipo, identificador
    ) VALUES (
      'pdf', 'test_pdf_sin_hash'
    );
    v_resultado_ok := FALSE;
    RAISE NOTICE 'FAIL · Insert de PDF sin hash NO fue rechazado';
  EXCEPTION
    WHEN check_violation THEN
      v_resultado_ok := TRUE;
      RAISE NOTICE 'PASS · Constraint chk_hash_digital rechazó PDF sin hash';
    WHEN OTHERS THEN
      RAISE NOTICE 'WARN · Insert falló por otra razón: %', SQLERRM;
  END;

  -- Insertar PDF CON hash → debe funcionar
  BEGIN
    INSERT INTO its.documentos_evidencia (
      tipo, identificador, hash_archivo
    ) VALUES (
      'pdf', 'test_pdf_con_hash', 'sha256:abcdef1234567890'
    );
    RAISE NOTICE 'PASS · Insert de PDF con hash aceptado';
    DELETE FROM its.documentos_evidencia WHERE identificador = 'test_pdf_con_hash';
  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'FAIL · Insert de PDF con hash falló: %', SQLERRM;
  END;
END $$;

-- -----------------------------------------------------------------------------
-- TEST 7 · autoridades con capa_temporal funcional
-- -----------------------------------------------------------------------------

DO $$
DECLARE
  v_n INT;
BEGIN
  RAISE NOTICE '--- TEST 7: autoridades permite mismo dominio en distintas capas ---';

  -- Verificar que la columna existe
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'its' AND table_name = 'autoridades' AND column_name = 'capa_temporal'
  ) THEN
    RAISE NOTICE 'FAIL · Columna capa_temporal NO existe en autoridades';
    RETURN;
  END IF;

  -- Intentar insertar dos autoridades para el mismo (unidad, dominio) en capas distintas
  -- (Hijuela 2 dominio "superficie" con capa histórica y capa operacional)
  INSERT INTO its.autoridades (unidad_id, dominio, autoridad_actual, capa_temporal, estado)
  VALUES
    ((SELECT id FROM its.unidades_territoriales WHERE codigo = 'hijuela_2_cominetti'),
     'test_dominio_capa', 'Autoridad capa 1', 1, 'identificado'),
    ((SELECT id FROM its.unidades_territoriales WHERE codigo = 'hijuela_2_cominetti'),
     'test_dominio_capa', 'Autoridad capa 5', 5, 'identificado')
  ON CONFLICT DO NOTHING;

  SELECT count(*) INTO v_n
  FROM its.autoridades
  WHERE dominio = 'test_dominio_capa';

  IF v_n = 2 THEN
    RAISE NOTICE 'PASS · 2 autoridades coexisten para mismo dominio en distintas capas';
  ELSE
    RAISE NOTICE 'FAIL · Solo % autoridades insertadas (esperaba 2)', v_n;
  END IF;

  DELETE FROM its.autoridades WHERE dominio = 'test_dominio_capa';
END $$;

-- -----------------------------------------------------------------------------
-- TEST 8 · Función disciplinada cambiar_estado registra via_funcion
-- -----------------------------------------------------------------------------

DO $$
DECLARE
  v_unidad_id UUID;
  v_documento_id UUID;
  v_log_count INT;
BEGIN
  RAISE NOTICE '--- TEST 8: cambiar_estado disciplinado registra via_funcion ---';

  -- Crear evidencia primaria mock
  INSERT INTO its.documentos_evidencia (tipo, identificador, hash_archivo)
  VALUES ('inscripcion', 'test_inscripcion_disciplinada', 'sha256:test')
  RETURNING id INTO v_documento_id;

  -- Crear unidad de test
  INSERT INTO its.unidades_territoriales (codigo, nombre, estado)
  VALUES ('test_unidad_disciplina', 'Test', 'identificado')
  RETURNING id INTO v_unidad_id;

  -- Promover a verificado vía función con evidencia
  PERFORM its.cambiar_estado(
    'unidades_territoriales'::TEXT,
    v_unidad_id,
    'verificado'::TEXT,
    v_documento_id,
    'Test 8: promoción disciplinada',
    'test_runner'
  );

  SELECT count(*) INTO v_log_count
  FROM its.estado_changes_log
  WHERE tabla = 'unidades_territoriales'
    AND registro_id = v_unidad_id
    AND via_funcion = 'its.cambiar_estado'
    AND documento_evidencia_id = v_documento_id;

  IF v_log_count >= 1 THEN
    RAISE NOTICE 'PASS · Log capturó via_funcion + documento + motivo';
  ELSE
    RAISE NOTICE 'FAIL · Log no enriquecido por función disciplinada';
  END IF;

  -- Cleanup
  DELETE FROM its.estado_changes_log WHERE registro_id = v_unidad_id;
  DELETE FROM its.unidades_territoriales WHERE id = v_unidad_id;
  DELETE FROM its.documentos_evidencia WHERE id = v_documento_id;
END $$;

-- -----------------------------------------------------------------------------
-- ROLLBACK · todos los tests ejecutados en transacción, nada se persiste
-- -----------------------------------------------------------------------------

ROLLBACK;

\echo ''
\echo '=== TESTS COMPLETADOS — revisar PASS/FAIL en output arriba ==='
\echo '=== Rollback aplicado: ninguna modificación persistida ==='
