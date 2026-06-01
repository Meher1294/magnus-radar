-- =============================================================================
-- TESTS DE VALIDACIÓN · Schema 0003 + Seed 0003 (Hijuela 2)
-- =============================================================================
--
-- Ejecutar en Supabase staging DESPUÉS de:
--   1. Aplicar 0002_its_schema.sql
--   2. Aplicar 0002b_hardening.sql (en 2 partes)
--   3. Aplicar 0003_artefactos_grafo.sql
--   4. Crear unidad hijuela_2_cominetti (Paso 6 del runbook)
--   5. Aplicar seed 0003_artefactos_hijuela_2.sql
--
-- Cumple los 5 criterios del Paso 8 del RUN_STAGING_FASE_P25.md
-- =============================================================================

\set ON_ERROR_STOP 0

-- -----------------------------------------------------------------------------
-- DIMENSIÓN 1 · ARTEFACTOS CARGADOS
-- -----------------------------------------------------------------------------

DO $$
DECLARE
  v_total INT;
  v_afectados INT;
  v_descalificados INT;
BEGIN
  RAISE NOTICE '=== DIMENSIÓN 1 · ARTEFACTOS ===';

  SELECT count(*) INTO v_total FROM its.artefactos;
  IF v_total = 13 THEN
    RAISE NOTICE 'PASS · artefactos: % (esperado 13)', v_total;
  ELSE
    RAISE NOTICE 'FAIL · artefactos: % (esperado 13)', v_total;
  END IF;

  SELECT count(*) INTO v_afectados FROM its.artefactos WHERE afectado_proxy_corrido = TRUE;
  IF v_afectados = 11 THEN
    RAISE NOTICE 'PASS · afectado_proxy_corrido = TRUE: % (esperado 11)', v_afectados;
  ELSE
    RAISE NOTICE 'FAIL · afectado_proxy_corrido = TRUE: % (esperado 11)', v_afectados;
  END IF;

  SELECT count(*) INTO v_descalificados FROM its.artefactos WHERE vigencia = 'descalificada';
  IF v_descalificados >= 8 THEN
    RAISE NOTICE 'PASS · vigencia=descalificada: % (esperado >= 8)', v_descalificados;
  ELSE
    RAISE NOTICE 'FAIL · vigencia=descalificada: % (esperado >= 8)', v_descalificados;
  END IF;

  -- Listar los artefactos por tipo
  RAISE NOTICE '---';
  FOR v_total IN
    SELECT count(*) FROM its.artefactos GROUP BY tipo
  LOOP
    NULL;
  END LOOP;
END $$;

-- Detalle visual de los artefactos por jerarquía
SELECT jerarquia_fuente, count(*) AS n,
       count(*) FILTER (WHERE afectado_proxy_corrido) AS afectados
FROM its.artefactos
GROUP BY jerarquia_fuente
ORDER BY n DESC;

-- -----------------------------------------------------------------------------
-- DIMENSIÓN 2 · RELACIONES CARGADAS
-- -----------------------------------------------------------------------------

DO $$
DECLARE
  v_total INT;
  v_auto INT;
  v_sugerida INT;
BEGIN
  RAISE NOTICE '=== DIMENSIÓN 2 · RELACIONES ===';

  SELECT count(*) INTO v_total FROM its.relaciones_artefactos;
  IF v_total = 21 THEN
    RAISE NOTICE 'PASS · relaciones totales: % (esperado 21)', v_total;
  ELSE
    RAISE NOTICE 'FAIL · relaciones totales: % (esperado 21)', v_total;
  END IF;

  SELECT count(*) INTO v_auto FROM its.relaciones_artefactos WHERE modo_propagacion = 'automatica_fuerte';
  IF v_auto >= 12 THEN
    RAISE NOTICE 'PASS · automatica_fuerte: % (esperado >= 12)', v_auto;
  ELSE
    RAISE NOTICE 'FAIL · automatica_fuerte: % (esperado >= 12)', v_auto;
  END IF;

  SELECT count(*) INTO v_sugerida FROM its.relaciones_artefactos WHERE modo_propagacion = 'sugerida_humana';
  IF v_sugerida >= 8 THEN
    RAISE NOTICE 'PASS · sugerida_humana: % (esperado >= 8)', v_sugerida;
  ELSE
    RAISE NOTICE 'FAIL · sugerida_humana: % (esperado >= 8)', v_sugerida;
  END IF;
END $$;

-- Detalle por tipo de relación
SELECT tipo_relacion, count(*) AS n
FROM its.relaciones_artefactos
GROUP BY tipo_relacion
ORDER BY n DESC;

-- -----------------------------------------------------------------------------
-- DIMENSIÓN 3 · CTE RECURSIVO
-- -----------------------------------------------------------------------------

DO $$
DECLARE
  v_descendientes INT;
  v_nivel_max INT;
BEGIN
  RAISE NOTICE '=== DIMENSIÓN 3 · CTE RECURSIVO ===';

  SELECT count(*), max(nivel) INTO v_descendientes, v_nivel_max
  FROM its.artefactos_afectados_si_descalifico
  WHERE root = 'GEO-TOPO-COMINETTI-2007';

  IF v_descendientes >= 9 THEN
    RAISE NOTICE 'PASS · descendientes de TOPO 2007: % (esperado >= 9)', v_descendientes;
  ELSE
    RAISE NOTICE 'FAIL · descendientes de TOPO 2007: % (esperado >= 9)', v_descendientes;
  END IF;

  IF v_nivel_max >= 2 THEN
    RAISE NOTICE 'PASS · nivel máximo cadena: % (esperado >= 2)', v_nivel_max;
  ELSE
    RAISE NOTICE 'FAIL · nivel máximo cadena: % (esperado >= 2)', v_nivel_max;
  END IF;
END $$;

-- Detalle: cadena completa de descendientes de TOPO 2007
SELECT root, afectado, nivel, cadena
FROM its.artefactos_afectados_si_descalifico
WHERE root = 'GEO-TOPO-COMINETTI-2007'
ORDER BY nivel, afectado;

-- -----------------------------------------------------------------------------
-- DIMENSIÓN 4 · FUNCIÓN PROPAGAR_DEGRADACION
-- -----------------------------------------------------------------------------

DO $$
DECLARE
  v_topo_id UUID;
  v_propagados INT := 0;
  v_eventos_antes INT;
  v_eventos_despues INT;
BEGIN
  RAISE NOTICE '=== DIMENSIÓN 4 · PROPAGACIÓN ===';

  SELECT id INTO v_topo_id FROM its.artefactos WHERE id_canonico_propuesto = 'GEO-TOPO-COMINETTI-2007';
  IF v_topo_id IS NULL THEN
    RAISE NOTICE 'FAIL · GEO-TOPO-COMINETTI-2007 no existe en BD';
    RETURN;
  END IF;

  SELECT count(*) INTO v_eventos_antes FROM its.eventos_validacion;

  -- Ejecutar propagación
  BEGIN
    SELECT count(*) INTO v_propagados FROM its.propagar_degradacion(
      v_topo_id,
      'test_validacion_2026-05-31 · offset_217m_vs_rtk',
      'test_runner'
    );
    RAISE NOTICE 'PASS · propagar_degradacion() ejecutó sin error · % artefactos propagados', v_propagados;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'FAIL · propagar_degradacion(): %', SQLERRM;
      RETURN;
  END;

  SELECT count(*) INTO v_eventos_despues FROM its.eventos_validacion;
  IF v_eventos_despues > v_eventos_antes THEN
    RAISE NOTICE 'PASS · audit log creció: % → % (delta %)', v_eventos_antes, v_eventos_despues, v_eventos_despues - v_eventos_antes;
  ELSE
    RAISE NOTICE 'FAIL · audit log no creció · esperado al menos 1 evento por descendiente';
  END IF;
END $$;

-- -----------------------------------------------------------------------------
-- DIMENSIÓN 5 · AUDIT LOG VALIDADO
-- -----------------------------------------------------------------------------

DO $$
DECLARE
  v_total INT;
  v_propagacion INT;
  v_sospechosos INT;
BEGIN
  RAISE NOTICE '=== DIMENSIÓN 5 · AUDIT LOG ===';

  SELECT count(*) INTO v_total FROM its.eventos_validacion;
  IF v_total >= 9 THEN
    RAISE NOTICE 'PASS · eventos totales: % (esperado >= 9 · uno por descendiente propagado)', v_total;
  ELSE
    RAISE NOTICE 'FAIL · eventos totales: % (esperado >= 9)', v_total;
  END IF;

  SELECT count(*) INTO v_propagacion FROM its.eventos_validacion WHERE tipo_evento = 'propagacion_recibida';
  IF v_propagacion >= 9 THEN
    RAISE NOTICE 'PASS · eventos propagacion_recibida: % (esperado >= 9)', v_propagacion;
  ELSE
    RAISE NOTICE 'FAIL · eventos propagacion_recibida: % (esperado >= 9)', v_propagacion;
  END IF;

  SELECT count(*) INTO v_sospechosos FROM its.eventos_sospechosos;
  IF v_sospechosos = 0 THEN
    RAISE NOTICE 'PASS · eventos_sospechosos: 0';
  ELSE
    RAISE NOTICE 'WARN · eventos_sospechosos: % · revisar manualmente', v_sospechosos;
  END IF;
END $$;

-- Detalle del audit log generado
SELECT
  e.fecha_evento,
  e.tipo_evento,
  e.actor,
  a.id_canonico_propuesto AS artefacto,
  e.motivo
FROM its.eventos_validacion e
JOIN its.artefactos a ON a.id = e.artefacto_id
ORDER BY e.fecha_evento DESC, e.id DESC;

-- -----------------------------------------------------------------------------
-- RESUMEN GLOBAL
-- -----------------------------------------------------------------------------

DO $$
BEGIN
  RAISE NOTICE '';
  RAISE NOTICE '=== RESUMEN GLOBAL ===';
  RAISE NOTICE 'Revisar output anterior · todos los PASS confirman criterio de salida P2.5';
  RAISE NOTICE 'Si TODOS los PASS pasan → autorizar avance a P3 o P4';
  RAISE NOTICE 'Si algún FAIL → diagnosticar SQL antes de continuar · NO tocar más staging';
END $$;

-- Vista del grafo resumen (informativa)
SELECT * FROM its.grafo_artefactos_resumen;
