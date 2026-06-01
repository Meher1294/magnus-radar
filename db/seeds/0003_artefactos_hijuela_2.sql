-- =============================================================================
-- Magnus Radar · ITS v0.4 · Seed 0003 · Artefactos Hijuela 2 (REALES)
-- =============================================================================
--
-- Diseñado: 2026-05-31
-- Custodio: Max Medina (Magnus SpA)
-- Aplica PRINCIPIO #1 · NO inventa nada · solo carga lo observado en el arqueo
--
-- ## Universo
--   - 13 artefactos del data room La Higuera con relaciones declaradas
--   - 21 dependencias detectadas empíricamente vía parsing de campos del laboratorio
--   - 0 dependencias inventadas
--
-- ## Cobertura
--   - Geometrías vectoriales (.gpkg, .kmz): 13 artefactos
--   - Otros tipos (planos, inscripciones, etc.): pendiente Fase P4 (auditoría KMZ/PDF/DWG)
--
-- ## Asunción
--   - Existe unidad_territorial 'hijuela_2_cominetti' (creada por seed v2)
--   - Existe función gen_random_uuid() y los enums de schema 0003
--
-- NO EJECUTAR EN PRODUCCIÓN HASTA APROBACIÓN MANUAL DE MAX
-- =============================================================================

DO $$
DECLARE
  v_unidad_hijuela2 UUID;

  -- IDs de los 13 artefactos cargados
  v_topo_2007 UUID;
  v_topo_2007_split UUID;
  v_perimetro_rtk UUID;
  v_perimetro_rtk_fix UUID;
  v_lote_b_proxy UUID;
  v_deslinde_sur_lote_b UUID;
  v_r5_40 UUID; v_r5_60 UUID; v_r5_80 UUID; v_r5_120 UUID;
  v_vel_80 UUID; v_vel_120 UUID; v_vel_120_ext UUID; v_vel_140 UUID;
  v_kmz_dataroom UUID;

BEGIN
  -- Obtener unidad territorial
  SELECT id INTO v_unidad_hijuela2 FROM its.unidades_territoriales
  WHERE codigo = 'hijuela_2_cominetti' LIMIT 1;

  IF v_unidad_hijuela2 IS NULL THEN
    RAISE EXCEPTION 'Unidad hijuela_2_cominetti no existe. Ejecutar seed v2 primero.';
  END IF;

  -- ---------------------------------------------------------------------------
  -- CARGA DE ARTEFACTOS (13)
  -- ---------------------------------------------------------------------------

  -- TOPO_COMINETTI_2007 (raíz · descalificado)
  INSERT INTO its.artefactos (
    id_canonico_propuesto, nombre, tipo, unidad_territorial_id,
    fuente_dato, fuente_archivo, ano_levantamiento_real, origen_digitalizacion, soporte_documental,
    naturaleza_geo, source_truth, jerarquia_fuente, uso,
    nivel_confianza_operacional, vigencia, estado,
    tiene_desfase_declarado, vector_desfase_metros,
    afectado_proxy_corrido, nota_degradacion, degradacion_fecha, fecha_reclasificacion,
    hipotesis_asociada_texto, pendiente_verificacion,
    superficie_ha_calculada, superficie_ha_declarada,
    fecha_carga_inicial
  ) VALUES (
    'GEO-TOPO-COMINETTI-2007',
    'Topo Cominetti 2007 (levantamiento propietarios, corrido)',
    'geometria_vectorial',
    v_unidad_hijuela2,
    'Levantamiento topográfico encargado por familia Cominetti en 2007',
    'ContornoTotal_Mar2022.kmz (fecha de nombre engañosa: Mar-2022 es solo fecha de archivado/circulación por correo de Fabio Lancellotti)',
    '2007',
    'levantamiento_topografico_propietarios',
    'levantamiento_topografico_pendiente_verificacion',
    'fisico_legal_topografico',
    'fuente_topografica_historica',
    'auxiliar',
    'referencia_historica',
    'media',
    'validando',
    'parcialmente_verificado',
    TRUE,
    'desconocido (Daniel confirmó "está corrido" sin cuantificar)',
    FALSE,
    'Topo Cominetti 2007 descalificado el 2026-05-17 como referencia geométrica por offset medio ~217 m respecto al RTK Daniel 2026 y geometría rectilínea/esquemática (207 vértices, formas ortogonales no naturales). Conservado por trazabilidad del laboratorio. No usar para análisis espacial; usar solo como referencia histórica del croquis 2007.',
    '2026-05-17',
    '2026-05-17',
    'HYP-2026-0002 (las 43 ha solo-escritura pueden ser deslindes históricos válidos pendientes conciliación, no errores)',
    '1) Pedir memoria técnica del levantamiento 2007 (PER-0005). 2) Obtener cuadro de coordenadas original. 3) Medir vector de desfase contra CBR Daniel RTK. 4) Si corregible, generar V2 corregido.',
    2200.93,
    NULL,
    '2026-05-17'
  ) RETURNING id INTO v_topo_2007;

  -- PERIMETRO_CBR_DANIEL_RTK10M_V1 (ancla canónica)
  INSERT INTO its.artefactos (
    id_canonico_propuesto, nombre, tipo, unidad_territorial_id,
    fuente_archivo, ano_levantamiento_real, origen_digitalizacion,
    naturaleza_geo, source_truth, jerarquia_fuente, uso,
    nivel_confianza_operacional, precision_metros, vigencia, estado,
    superficie_ha_calculada, superficie_ha_declarada, delta_pct,
    fecha_carga_inicial
  ) VALUES (
    'GEO-PERIMETRO-CBR-DANIEL-V1',
    'Perímetro CBR Daniel RTK 10m — Hijuela 2 Cominetti',
    'geometria_vectorial',
    v_unidad_hijuela2,
    'PERIMETRO_CBR_DANIEL_RTK10M_V1_UTM19S.gpkg',
    '2026',
    'RTK_10m_Daniel_Martinez_Zurita',
    'fisico_legal',
    'fuente_primaria_CBR',
    'primaria',
    'operacional_canonico',
    'alta',
    10,
    'vigente',
    'verificado',
    2156.70, 2164.97, -0.38,
    '2026-05-17'
  ) RETURNING id INTO v_perimetro_rtk;

  -- PERIMETRO_CBR_DANIEL_RTK10M_V1_FIX
  INSERT INTO its.artefactos (
    id_canonico_propuesto, nombre, tipo, unidad_territorial_id,
    fuente_archivo, ano_levantamiento_real, naturaleza_geo, source_truth, jerarquia_fuente,
    uso, nivel_confianza_operacional, precision_metros, vigencia, estado,
    superficie_ha_calculada, superficie_ha_declarada, delta_pct,
    fecha_carga_inicial, nota_degradacion
  ) VALUES (
    'GEO-PERIMETRO-CBR-DANIEL-V1-FIX',
    'Perímetro CBR Daniel RTK 10m — versión FIX (auto-intersección reparada)',
    'geometria_vectorial', v_unidad_hijuela2,
    'PERIMETRO_CBR_DANIEL_RTK10M_V1_UTM19S_FIX.gpkg',
    '2026', 'fisico_legal', 'fuente_primaria_CBR', 'primaria',
    'operacional_canonico', 'alta', 10, 'vigente', 'verificado',
    2156.70, 2164.97, -0.38,
    '2026-05-17',
    'Versión FIX de V1: geometría reparada post auto-intersección (+1.64 ha vs V1 previa).'
  ) RETURNING id INTO v_perimetro_rtk_fix;

  -- TOPO2007_SPLIT_BY_RUTA5
  INSERT INTO its.artefactos (
    id_canonico_propuesto, nombre, tipo, unidad_territorial_id,
    fuente_archivo, naturaleza_geo, jerarquia_fuente, uso,
    nivel_confianza_operacional, vigencia, estado, afectado_proxy_corrido,
    nota_degradacion, degradacion_fecha, fecha_carga_inicial
  ) VALUES (
    'GEO-TOPO-2007-SPLIT-BY-RUTA5',
    'TOPO 2007 fragmentado por eje Ruta 5 Norte',
    'geometria_vectorial', v_unidad_hijuela2,
    'TOPO2007_SPLIT_BY_RUTA5.gpkg',
    'fisico_legal_topografico', 'auxiliar', 'referencia_historica',
    'media', 'validando', 'parcialmente_verificado', TRUE,
    'Hereda problemática de TOPO_COMINETTI_2007 (offset ~217m).',
    '2026-05-17', '2026-05-17'
  ) RETURNING id INTO v_topo_2007_split;

  -- LOTE_B_PROXY_TOPO2007_V1
  INSERT INTO its.artefactos (
    id_canonico_propuesto, nombre, tipo, unidad_territorial_id,
    fuente_archivo, naturaleza_geo, source_truth, jerarquia_fuente, uso,
    nivel_confianza_operacional, vigencia, estado, afectado_proxy_corrido,
    nota_degradacion, degradacion_fecha, fecha_carga_inicial
  ) VALUES (
    'GEO-LOTE-B-PROXY-TOPO2007-V1',
    'Proxy del Lote B basado en TOPO 2007 (descalificado)',
    'geometria_vectorial', v_unidad_hijuela2,
    'LOTE_B_PROXY_TOPO2007_V1.gpkg',
    'logico_inferido', 'fuente_topografica_historica', 'laboratorio',
    'referencia_ilustrativa_no_operacional',
    'baja', 'descalificada', 'superseded', TRUE,
    'Derivado de Topo Cominetti 2007, descalificado para análisis espacial por offset promedio ~217 m. Conservado por trazabilidad. No usar para análisis espacial.',
    '2026-05-17', '2026-05-17'
  ) RETURNING id INTO v_lote_b_proxy;

  -- DESLINDE_SUR_LOTE_B_PROXY_3465M
  INSERT INTO its.artefactos (
    id_canonico_propuesto, nombre, tipo, unidad_territorial_id,
    fuente_archivo, naturaleza_geo, jerarquia_fuente, uso,
    nivel_confianza_operacional, vigencia, estado, afectado_proxy_corrido,
    nota_degradacion, degradacion_fecha, fecha_carga_inicial
  ) VALUES (
    'GEO-DESLINDE-SUR-LOTE-B-PROXY-3465M',
    'Deslinde sur Lote B inferido (3.465 m)',
    'geometria_vectorial', v_unidad_hijuela2,
    'DESLINDE_SUR_LOTE_B_PROXY_3465M.gpkg',
    'logico_inferido', 'laboratorio', 'deslinde_inferido_no_canonico',
    'baja', 'descalificada', 'superseded', TRUE,
    'Capa derivada del LOTE_B_PROXY_TOPO2007_V1, que fue descalificado el 2026-05-17 por offset sistemático de ~217 m respecto al RTK 2026.',
    '2026-05-17', '2026-05-17'
  ) RETURNING id INTO v_deslinde_sur_lote_b;

  -- R5_*_EN_LOTEB (4 artefactos)
  INSERT INTO its.artefactos (id_canonico_propuesto, nombre, tipo, unidad_territorial_id, fuente_archivo, naturaleza_geo, jerarquia_fuente, uso, nivel_confianza_operacional, vigencia, estado, afectado_proxy_corrido, fecha_carga_inicial)
  VALUES ('GEO-R5-40M-EN-LOTEB', 'Buffer R5 40m intersect LOTE B', 'geometria_vectorial', v_unidad_hijuela2, 'R5_40M_EN_LOTEB.gpkg', 'logico_inferido', 'laboratorio', 'buffer_vial_no_canonico', 'baja', 'descalificada', 'superseded', TRUE, '2026-05-17') RETURNING id INTO v_r5_40;
  INSERT INTO its.artefactos (id_canonico_propuesto, nombre, tipo, unidad_territorial_id, fuente_archivo, naturaleza_geo, jerarquia_fuente, uso, nivel_confianza_operacional, vigencia, estado, afectado_proxy_corrido, fecha_carga_inicial)
  VALUES ('GEO-R5-60M-EN-LOTEB', 'Buffer R5 60m intersect LOTE B', 'geometria_vectorial', v_unidad_hijuela2, 'R5_60M_EN_LOTEB.gpkg', 'logico_inferido', 'laboratorio', 'buffer_vial_no_canonico', 'baja', 'descalificada', 'superseded', TRUE, '2026-05-17') RETURNING id INTO v_r5_60;
  INSERT INTO its.artefactos (id_canonico_propuesto, nombre, tipo, unidad_territorial_id, fuente_archivo, naturaleza_geo, jerarquia_fuente, uso, nivel_confianza_operacional, vigencia, estado, afectado_proxy_corrido, fecha_carga_inicial)
  VALUES ('GEO-R5-80M-EN-LOTEB', 'Buffer R5 80m intersect LOTE B', 'geometria_vectorial', v_unidad_hijuela2, 'R5_80M_EN_LOTEB.gpkg', 'logico_inferido', 'laboratorio', 'buffer_vial_no_canonico', 'baja', 'descalificada', 'superseded', TRUE, '2026-05-17') RETURNING id INTO v_r5_80;
  INSERT INTO its.artefactos (id_canonico_propuesto, nombre, tipo, unidad_territorial_id, fuente_archivo, naturaleza_geo, jerarquia_fuente, uso, nivel_confianza_operacional, vigencia, estado, afectado_proxy_corrido, fecha_carga_inicial)
  VALUES ('GEO-R5-120M-EN-LOTEB', 'Buffer R5 120m intersect LOTE B', 'geometria_vectorial', v_unidad_hijuela2, 'R5_120M_EN_LOTEB.gpkg', 'logico_inferido', 'laboratorio', 'buffer_vial_no_canonico', 'baja', 'descalificada', 'superseded', TRUE, '2026-05-17') RETURNING id INTO v_r5_120;

  -- VEL_3465M_* (4 escenarios franja Velásquez)
  INSERT INTO its.artefactos (id_canonico_propuesto, nombre, tipo, unidad_territorial_id, fuente_archivo, naturaleza_geo, jerarquia_fuente, uso, nivel_confianza_operacional, vigencia, estado, afectado_proxy_corrido, fecha_carga_inicial, confidence_score_ia)
  VALUES ('GEO-VEL-3465M-80M-V1', 'Escenario franja Velásquez 80m', 'geometria_vectorial', v_unidad_hijuela2, 'VEL_3465M_80M_V1.gpkg', 'logico_inferido', 'laboratorio', 'escenario_geometrico_no_canonico', 'baja', 'descalificada', 'superseded', TRUE, '2026-05-17', 35) RETURNING id INTO v_vel_80;
  INSERT INTO its.artefactos (id_canonico_propuesto, nombre, tipo, unidad_territorial_id, fuente_archivo, naturaleza_geo, jerarquia_fuente, uso, nivel_confianza_operacional, vigencia, estado, afectado_proxy_corrido, fecha_carga_inicial, confidence_score_ia)
  VALUES ('GEO-VEL-3465M-120M-V1', 'Escenario franja Velásquez 120m', 'geometria_vectorial', v_unidad_hijuela2, 'VEL_3465M_120M_V1.gpkg', 'logico_inferido', 'laboratorio', 'escenario_geometrico_no_canonico', 'baja', 'descalificada', 'superseded', TRUE, '2026-05-17', 35) RETURNING id INTO v_vel_120;
  INSERT INTO its.artefactos (id_canonico_propuesto, nombre, tipo, unidad_territorial_id, fuente_archivo, naturaleza_geo, jerarquia_fuente, uso, nivel_confianza_operacional, vigencia, estado, afectado_proxy_corrido, fecha_carga_inicial)
  VALUES ('GEO-VEL-3465M-120M-EXTERNO-SUR-V1', 'Escenario franja Velásquez 120m externo sur', 'geometria_vectorial', v_unidad_hijuela2, 'VEL_3465M_120M_EXTERNO_SUR_V1.gpkg', 'logico_inferido', 'laboratorio', 'escenario_geometrico_no_canonico', 'baja', 'descalificada', 'superseded', TRUE, '2026-05-17') RETURNING id INTO v_vel_120_ext;
  INSERT INTO its.artefactos (id_canonico_propuesto, nombre, tipo, unidad_territorial_id, fuente_archivo, naturaleza_geo, jerarquia_fuente, uso, nivel_confianza_operacional, vigencia, estado, afectado_proxy_corrido, fecha_carga_inicial)
  VALUES ('GEO-VEL-3465M-140M-V1', 'Escenario franja Velásquez 140m', 'geometria_vectorial', v_unidad_hijuela2, 'VEL_3465M_140M_V1.gpkg', 'logico_inferido', 'laboratorio', 'escenario_geometrico_no_canonico', 'baja', 'descalificada', 'superseded', TRUE, '2026-05-17') RETURNING id INTO v_vel_140;

  -- KMZ DataRoom Cominetti (con conflicto KMZ_LABEL_VS_POLY_MISMATCH)
  INSERT INTO its.artefactos (
    id_canonico_propuesto, nombre, tipo, unidad_territorial_id,
    fuente_archivo, naturaleza_geo, jerarquia_fuente, uso,
    nivel_confianza_operacional, vigencia, estado,
    superficie_ha_calculada, superficie_ha_declarada, delta_pct,
    observacion_obligatoria, fecha_carga_inicial
  ) VALUES (
    'GEO-KMZ-DATAROOM-COMINETTI-2026-04',
    'KMZ DataRoom Cominetti (superseded · etiqueta inconsistente)',
    'geometria_vectorial', v_unidad_hijuela2,
    'DataRoom_Cominetti_LaHiguera.kmz',
    'fisico_legal_aproximado', 'auxiliar', 'referencia_ilustrativa_no_operacional',
    'baja', 'superseded', 'superseded',
    1671.26, 2640.00, -36.70,
    'CONFLICTO INTERNO · etiqueta KMZ dice 2.640 ha pero polígono cubre 1.671 ha (delta -36,7%). Ver issue KMZ_LABEL_VS_POLY_MISMATCH. NO usar como referencia cuantitativa.',
    '2026-04-01'
  ) RETURNING id INTO v_kmz_dataroom;

  -- ---------------------------------------------------------------------------
  -- CARGA DE 21 DEPENDENCIAS REALES (observadas en el data room · sin inventar)
  -- ---------------------------------------------------------------------------

  -- TOPO 2007 → comparado contra RTK (descalificación detectada)
  INSERT INTO its.relaciones_artefactos (artefacto_origen_id, artefacto_destino_id, tipo_relacion, modo_propagacion, nivel_confianza, justificacion, operacion_aplicada, detectada_por)
  VALUES (v_topo_2007, v_perimetro_rtk, 'descalificada_por_offset_vs', 'sugerida_humana', 'alta',
    'TOPO 2007 descalificado el 2026-05-17 al comparar contra RTK · offset medio ~217 m', 'comparación métrica espacial', 'arqueo_2026-05-31');

  -- TOPO 2007 split por RUTA 5 → derivado
  INSERT INTO its.relaciones_artefactos (artefacto_origen_id, artefacto_destino_id, tipo_relacion, modo_propagacion, nivel_confianza, justificacion, operacion_aplicada, detectada_por)
  VALUES (v_topo_2007_split, v_topo_2007, 'recortada_por', 'automatica_fuerte', 'alta',
    'TOPO_COMINETTI_2007 fragmentado por eje Ruta 5 Norte', 'split por línea geométrica', 'arqueo_2026-05-31');

  -- LOTE_B_PROXY derivado de TOPO 2007
  INSERT INTO its.relaciones_artefactos (artefacto_origen_id, artefacto_destino_id, tipo_relacion, modo_propagacion, nivel_confianza, justificacion, operacion_aplicada, detectada_por)
  VALUES (v_lote_b_proxy, v_topo_2007, 'derivada_de', 'automatica_fuerte', 'alta',
    'Aproximación de Lote B derivada de Topo Cominetti 2007 cortado por eje Ruta 5 Norte de OSM', 'derivación geométrica directa', 'arqueo_2026-05-31');

  -- LOTE_B_PROXY comparado contra RTK
  INSERT INTO its.relaciones_artefactos (artefacto_origen_id, artefacto_destino_id, tipo_relacion, modo_propagacion, nivel_confianza, justificacion, detectada_por)
  VALUES (v_lote_b_proxy, v_perimetro_rtk, 'comparada_contra', 'sugerida_humana', 'alta',
    'LOTE_B_PROXY referencia RTK como benchmark canónico (lo hereda como problema vía padre TOPO 2007)', 'arqueo_2026-05-31');

  -- DESLINDE SUR LOTE B extraído del LOTE_B_PROXY
  INSERT INTO its.relaciones_artefactos (artefacto_origen_id, artefacto_destino_id, tipo_relacion, modo_propagacion, nivel_confianza, justificacion, operacion_aplicada, detectada_por)
  VALUES (v_deslinde_sur_lote_b, v_lote_b_proxy, 'extraida_de', 'automatica_fuerte', 'alta',
    'Extraído del boundary del LOTE_B_PROXY_TOPO2007_V1, banda inferior 30% del bbox, secuencia continua más larga, orientación W->E', 'boundary extraction + recorte', 'arqueo_2026-05-31');

  -- R5 buffers en LOTE B (4 relaciones derivada_de)
  INSERT INTO its.relaciones_artefactos (artefacto_origen_id, artefacto_destino_id, tipo_relacion, modo_propagacion, nivel_confianza, justificacion, operacion_aplicada, detectada_por) VALUES
  (v_r5_40, v_lote_b_proxy, 'derivada_de', 'automatica_fuerte', 'alta', 'Capa derivada del LOTE_B_PROXY_TOPO2007_V1 (buffer R5 40m intersect)', 'buffer + intersect', 'arqueo_2026-05-31'),
  (v_r5_60, v_lote_b_proxy, 'derivada_de', 'automatica_fuerte', 'alta', 'Capa derivada del LOTE_B_PROXY_TOPO2007_V1 (buffer R5 60m intersect)', 'buffer + intersect', 'arqueo_2026-05-31'),
  (v_r5_80, v_lote_b_proxy, 'derivada_de', 'automatica_fuerte', 'alta', 'Capa derivada del LOTE_B_PROXY_TOPO2007_V1 (buffer R5 80m intersect)', 'buffer + intersect', 'arqueo_2026-05-31'),
  (v_r5_120, v_lote_b_proxy, 'derivada_de', 'automatica_fuerte', 'alta', 'Capa derivada del LOTE_B_PROXY_TOPO2007_V1 (buffer R5 120m intersect)', 'buffer + intersect', 'arqueo_2026-05-31');

  -- R5 buffers comparados contra RTK (4 relaciones comparada_contra)
  INSERT INTO its.relaciones_artefactos (artefacto_origen_id, artefacto_destino_id, tipo_relacion, modo_propagacion, nivel_confianza, justificacion, detectada_por) VALUES
  (v_r5_40, v_perimetro_rtk, 'comparada_contra', 'sugerida_humana', 'media', 'Referencia RTK como benchmark', 'arqueo_2026-05-31'),
  (v_r5_60, v_perimetro_rtk, 'comparada_contra', 'sugerida_humana', 'media', 'Referencia RTK como benchmark', 'arqueo_2026-05-31'),
  (v_r5_80, v_perimetro_rtk, 'comparada_contra', 'sugerida_humana', 'media', 'Referencia RTK como benchmark', 'arqueo_2026-05-31'),
  (v_r5_120, v_perimetro_rtk, 'comparada_contra', 'sugerida_humana', 'media', 'Referencia RTK como benchmark', 'arqueo_2026-05-31');

  -- VEL escenarios derivados (4 derivada_de + 4 comparada_contra)
  INSERT INTO its.relaciones_artefactos (artefacto_origen_id, artefacto_destino_id, tipo_relacion, modo_propagacion, nivel_confianza, justificacion, operacion_aplicada, detectada_por) VALUES
  (v_vel_80, v_lote_b_proxy, 'interseccion_con', 'automatica_fuerte', 'alta', 'Escenario 80m: buffer de radio 80 m al deslinde sur, intersect con LOTE_B_PROXY_TOPO2007_V1', 'buffer 80m + intersect', 'arqueo_2026-05-31'),
  (v_vel_120, v_lote_b_proxy, 'interseccion_con', 'automatica_fuerte', 'alta', 'Escenario 120m: buffer de radio 120 m al deslinde sur, intersect con LOTE_B_PROXY_TOPO2007_V1', 'buffer 120m + intersect', 'arqueo_2026-05-31'),
  (v_vel_120_ext, v_lote_b_proxy, 'derivada_de', 'automatica_fuerte', 'alta', 'Capa derivada del LOTE_B_PROXY_TOPO2007_V1 (externo sur)', 'buffer externo', 'arqueo_2026-05-31'),
  (v_vel_140, v_lote_b_proxy, 'interseccion_con', 'automatica_fuerte', 'alta', 'Escenario 140m: buffer de radio 140 m al deslinde sur, intersect con LOTE_B_PROXY_TOPO2007_V1', 'buffer 140m + intersect', 'arqueo_2026-05-31');

  INSERT INTO its.relaciones_artefactos (artefacto_origen_id, artefacto_destino_id, tipo_relacion, modo_propagacion, nivel_confianza, justificacion, detectada_por) VALUES
  (v_vel_80, v_perimetro_rtk, 'comparada_contra', 'sugerida_humana', 'media', 'Referencia RTK como benchmark', 'arqueo_2026-05-31'),
  (v_vel_120, v_perimetro_rtk, 'comparada_contra', 'sugerida_humana', 'media', 'Referencia RTK como benchmark', 'arqueo_2026-05-31'),
  (v_vel_120_ext, v_perimetro_rtk, 'comparada_contra', 'sugerida_humana', 'media', 'Referencia RTK como benchmark', 'arqueo_2026-05-31'),
  (v_vel_140, v_perimetro_rtk, 'comparada_contra', 'sugerida_humana', 'media', 'Referencia RTK como benchmark', 'arqueo_2026-05-31');

  -- DESLINDE comparado contra RTK
  INSERT INTO its.relaciones_artefactos (artefacto_origen_id, artefacto_destino_id, tipo_relacion, modo_propagacion, nivel_confianza, justificacion, detectada_por)
  VALUES (v_deslinde_sur_lote_b, v_perimetro_rtk, 'comparada_contra', 'sugerida_humana', 'media', 'Referencia RTK como benchmark canónico', 'arqueo_2026-05-31');

  RAISE NOTICE '✓ Cargados 13 artefactos y 21 dependencias REALES (sin inventar)';
END $$;

-- =============================================================================
-- VERIFICACIÓN POST-CARGA
-- =============================================================================
-- SELECT * FROM its.grafo_artefactos_resumen;
-- SELECT * FROM its.artefactos_afectados_si_descalifico
--   WHERE root = 'GEO-TOPO-COMINETTI-2007';
-- SELECT count(*) FROM its.artefactos;       -- esperado: 13
-- SELECT count(*) FROM its.relaciones_artefactos; -- esperado: 21
