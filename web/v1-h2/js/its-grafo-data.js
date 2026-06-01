// =============================================================================
// Magnus Radar · ITS v0.3 · its-grafo-data.js
// 2026-05-31 · P3 + P3.1 fixture local
//
// ATENCIÓN: estos datos son FIXTURE LOCAL · NO han sido validados contra
// runtime Supabase real. Subset del seed db/seeds/0003_artefactos_hijuela_2.sql.
//
// Hasta que se ejecute el runbook db/RUN_STAGING_FASE_P25.md y se valide
// con db/tests/0003_validation.sql, este fixture es solo doctrina visible.
//
// 14 artefactos · 22 relaciones · detectados empíricamente vía arqueo 2026-05-31.
// =============================================================================

export const GRAFO_FIXTURE_HIJUELA_2 = {

  metadata: {
    estado_validacion: 'fixture_local',
    pendiente: 'ejecucion_staging_supabase',
    fuente: 'db/seeds/0003_artefactos_hijuela_2.sql',
    fecha_carga: '2026-05-31'
  },

  artefactos: [
    { codigo: 'GEO-TOPO-COMINETTI-2007', nombre: 'Topo Cominetti 2007 (corrido)', tipo: 'geometria_vectorial',
      jerarquia: 'auxiliar', vigencia: 'validando', estado: 'parcialmente_verificado',
      afectado_proxy: false, anio: 2007, sup_calc: 2200.93,
      naturaleza_geo: 'fisico_legal_topografico', uso: 'referencia_historica',
      nivel_confianza: 'media', tiene_desfase_declarado: true,
      vector_desfase: '~217 m (desconocido cuantitativamente)',
      fuente_archivo: 'ContornoTotal_Mar2022.kmz (fecha de nombre engañosa)',
      observacion_obligatoria: 'Topo Cominetti 2007 descalificado el 2026-05-17 como referencia geométrica por offset medio ~217 m respecto al RTK Daniel 2026 y geometría rectilínea/esquemática (207 vértices, formas ortogonales no naturales). Conservado por trazabilidad. No usar para análisis espacial.' },

    { codigo: 'GEO-PERIMETRO-CBR-DANIEL-V1', nombre: 'Perímetro CBR Daniel RTK 10m', tipo: 'geometria_vectorial',
      jerarquia: 'primaria', vigencia: 'vigente', estado: 'verificado',
      afectado_proxy: false, anio: 2026, sup_calc: 2156.70, ancla_canonica: true,
      naturaleza_geo: 'fisico_legal', uso: 'operacional_canonico',
      nivel_confianza: 'alta', precision_metros: 10,
      fuente_archivo: 'PERIMETRO_CBR_DANIEL_RTK10M_V1_UTM19S.gpkg' },

    { codigo: 'GEO-PERIMETRO-CBR-DANIEL-V1-FIX', nombre: 'Perímetro CBR Daniel RTK 10m FIX', tipo: 'geometria_vectorial',
      jerarquia: 'primaria', vigencia: 'vigente', estado: 'verificado',
      afectado_proxy: false, anio: 2026, sup_calc: 2156.70,
      naturaleza_geo: 'fisico_legal', uso: 'operacional_canonico',
      nivel_confianza: 'alta', precision_metros: 10,
      fuente_archivo: 'PERIMETRO_CBR_DANIEL_RTK10M_V1_UTM19S_FIX.gpkg',
      observacion_obligatoria: 'Versión FIX de V1: geometría reparada post auto-intersección (+1.64 ha vs V1 previa).' },

    { codigo: 'GEO-TOPO-2007-SPLIT-BY-RUTA5', nombre: 'TOPO 2007 fragmentado por Ruta 5', tipo: 'geometria_vectorial',
      jerarquia: 'auxiliar', vigencia: 'validando', estado: 'parcialmente_verificado',
      afectado_proxy: true, anio: 2007,
      naturaleza_geo: 'fisico_legal_topografico', uso: 'referencia_historica',
      nivel_confianza: 'media',
      observacion_obligatoria: 'Hereda problemática de TOPO_COMINETTI_2007 (offset ~217m).' },

    { codigo: 'GEO-LOTE-B-PROXY-TOPO2007-V1', nombre: 'Proxy Lote B basado en TOPO 2007', tipo: 'geometria_vectorial',
      jerarquia: 'laboratorio', vigencia: 'descalificada', estado: 'superseded',
      afectado_proxy: true, anio: 2026,
      naturaleza_geo: 'logico_inferido', uso: 'referencia_ilustrativa_no_operacional',
      nivel_confianza: 'baja',
      observacion_obligatoria: 'Derivado de Topo Cominetti 2007, descalificado para análisis espacial por offset promedio ~217 m. Conservado por trazabilidad. No usar para análisis espacial.' },

    { codigo: 'GEO-DESLINDE-SUR-LOTE-B-PROXY-3465M', nombre: 'Deslinde sur Lote B inferido', tipo: 'geometria_vectorial',
      jerarquia: 'laboratorio', vigencia: 'descalificada', estado: 'superseded',
      afectado_proxy: true, anio: 2026,
      naturaleza_geo: 'logico_inferido', uso: 'deslinde_inferido_no_canonico',
      nivel_confianza: 'baja',
      observacion_obligatoria: 'Capa derivada del LOTE_B_PROXY_TOPO2007_V1 (descalificado).' },

    { codigo: 'GEO-R5-40M-EN-LOTEB', nombre: 'Buffer R5 40m intersect LOTE B', tipo: 'geometria_vectorial',
      jerarquia: 'laboratorio', vigencia: 'descalificada', estado: 'superseded',
      afectado_proxy: true, anio: 2026,
      naturaleza_geo: 'logico_inferido', uso: 'buffer_vial_no_canonico', nivel_confianza: 'baja' },
    { codigo: 'GEO-R5-60M-EN-LOTEB', nombre: 'Buffer R5 60m intersect LOTE B', tipo: 'geometria_vectorial',
      jerarquia: 'laboratorio', vigencia: 'descalificada', estado: 'superseded',
      afectado_proxy: true, anio: 2026,
      naturaleza_geo: 'logico_inferido', uso: 'buffer_vial_no_canonico', nivel_confianza: 'baja' },
    { codigo: 'GEO-R5-80M-EN-LOTEB', nombre: 'Buffer R5 80m intersect LOTE B', tipo: 'geometria_vectorial',
      jerarquia: 'laboratorio', vigencia: 'descalificada', estado: 'superseded',
      afectado_proxy: true, anio: 2026,
      naturaleza_geo: 'logico_inferido', uso: 'buffer_vial_no_canonico', nivel_confianza: 'baja' },
    { codigo: 'GEO-R5-120M-EN-LOTEB', nombre: 'Buffer R5 120m intersect LOTE B', tipo: 'geometria_vectorial',
      jerarquia: 'laboratorio', vigencia: 'descalificada', estado: 'superseded',
      afectado_proxy: true, anio: 2026,
      naturaleza_geo: 'logico_inferido', uso: 'buffer_vial_no_canonico', nivel_confianza: 'baja' },

    { codigo: 'GEO-VEL-3465M-80M-V1', nombre: 'Escenario Velásquez 80m', tipo: 'geometria_vectorial',
      jerarquia: 'laboratorio', vigencia: 'descalificada', estado: 'superseded',
      afectado_proxy: true, anio: 2026, confidence_ia: 35,
      naturaleza_geo: 'logico_inferido', uso: 'escenario_geometrico_no_canonico', nivel_confianza: 'baja' },
    { codigo: 'GEO-VEL-3465M-120M-V1', nombre: 'Escenario Velásquez 120m', tipo: 'geometria_vectorial',
      jerarquia: 'laboratorio', vigencia: 'descalificada', estado: 'superseded',
      afectado_proxy: true, anio: 2026, confidence_ia: 35,
      naturaleza_geo: 'logico_inferido', uso: 'escenario_geometrico_no_canonico', nivel_confianza: 'baja' },
    { codigo: 'GEO-VEL-3465M-120M-EXTERNO-SUR-V1', nombre: 'Escenario Velásquez 120m externo sur', tipo: 'geometria_vectorial',
      jerarquia: 'laboratorio', vigencia: 'descalificada', estado: 'superseded',
      afectado_proxy: true, anio: 2026,
      naturaleza_geo: 'logico_inferido', uso: 'escenario_geometrico_no_canonico', nivel_confianza: 'baja' },
    { codigo: 'GEO-VEL-3465M-140M-V1', nombre: 'Escenario Velásquez 140m', tipo: 'geometria_vectorial',
      jerarquia: 'laboratorio', vigencia: 'descalificada', estado: 'superseded',
      afectado_proxy: true, anio: 2026,
      naturaleza_geo: 'logico_inferido', uso: 'escenario_geometrico_no_canonico', nivel_confianza: 'baja' }
  ],

  relaciones: [
    { origen: 'GEO-TOPO-COMINETTI-2007', destino: 'GEO-PERIMETRO-CBR-DANIEL-V1',
      tipo: 'descalificada_por_offset_vs', propagacion: 'sugerida_humana', confianza: 'alta',
      justificacion: 'TOPO 2007 descalificado al comparar contra RTK · offset medio ~217 m' },

    { origen: 'GEO-TOPO-2007-SPLIT-BY-RUTA5', destino: 'GEO-TOPO-COMINETTI-2007',
      tipo: 'recortada_por', propagacion: 'automatica_fuerte', confianza: 'alta',
      justificacion: 'TOPO_COMINETTI_2007 fragmentado por eje Ruta 5 Norte' },

    { origen: 'GEO-LOTE-B-PROXY-TOPO2007-V1', destino: 'GEO-TOPO-COMINETTI-2007',
      tipo: 'derivada_de', propagacion: 'automatica_fuerte', confianza: 'alta',
      justificacion: 'Aproximación de Lote B derivada de Topo Cominetti 2007 cortado por eje Ruta 5 Norte de OSM' },
    { origen: 'GEO-LOTE-B-PROXY-TOPO2007-V1', destino: 'GEO-PERIMETRO-CBR-DANIEL-V1',
      tipo: 'comparada_contra', propagacion: 'sugerida_humana', confianza: 'alta',
      justificacion: 'Benchmark vs RTK · hereda problemática del padre TOPO 2007' },

    { origen: 'GEO-DESLINDE-SUR-LOTE-B-PROXY-3465M', destino: 'GEO-LOTE-B-PROXY-TOPO2007-V1',
      tipo: 'extraida_de', propagacion: 'automatica_fuerte', confianza: 'alta',
      justificacion: 'Extraído del boundary del LOTE_B_PROXY (banda inferior 30% del bbox)' },

    { origen: 'GEO-R5-40M-EN-LOTEB', destino: 'GEO-LOTE-B-PROXY-TOPO2007-V1',
      tipo: 'derivada_de', propagacion: 'automatica_fuerte', confianza: 'alta',
      justificacion: 'Buffer R5 40m intersect con LOTE_B_PROXY' },
    { origen: 'GEO-R5-60M-EN-LOTEB', destino: 'GEO-LOTE-B-PROXY-TOPO2007-V1',
      tipo: 'derivada_de', propagacion: 'automatica_fuerte', confianza: 'alta',
      justificacion: 'Buffer R5 60m intersect con LOTE_B_PROXY' },
    { origen: 'GEO-R5-80M-EN-LOTEB', destino: 'GEO-LOTE-B-PROXY-TOPO2007-V1',
      tipo: 'derivada_de', propagacion: 'automatica_fuerte', confianza: 'alta',
      justificacion: 'Buffer R5 80m intersect con LOTE_B_PROXY' },
    { origen: 'GEO-R5-120M-EN-LOTEB', destino: 'GEO-LOTE-B-PROXY-TOPO2007-V1',
      tipo: 'derivada_de', propagacion: 'automatica_fuerte', confianza: 'alta',
      justificacion: 'Buffer R5 120m intersect con LOTE_B_PROXY' },

    { origen: 'GEO-R5-40M-EN-LOTEB', destino: 'GEO-PERIMETRO-CBR-DANIEL-V1',
      tipo: 'comparada_contra', propagacion: 'sugerida_humana', confianza: 'media',
      justificacion: 'Referencia RTK como benchmark' },
    { origen: 'GEO-R5-60M-EN-LOTEB', destino: 'GEO-PERIMETRO-CBR-DANIEL-V1',
      tipo: 'comparada_contra', propagacion: 'sugerida_humana', confianza: 'media',
      justificacion: 'Referencia RTK como benchmark' },
    { origen: 'GEO-R5-80M-EN-LOTEB', destino: 'GEO-PERIMETRO-CBR-DANIEL-V1',
      tipo: 'comparada_contra', propagacion: 'sugerida_humana', confianza: 'media',
      justificacion: 'Referencia RTK como benchmark' },
    { origen: 'GEO-R5-120M-EN-LOTEB', destino: 'GEO-PERIMETRO-CBR-DANIEL-V1',
      tipo: 'comparada_contra', propagacion: 'sugerida_humana', confianza: 'media',
      justificacion: 'Referencia RTK como benchmark' },

    { origen: 'GEO-VEL-3465M-80M-V1', destino: 'GEO-LOTE-B-PROXY-TOPO2007-V1',
      tipo: 'interseccion_con', propagacion: 'automatica_fuerte', confianza: 'alta',
      justificacion: 'Escenario 80m: buffer al deslinde sur · intersect con LOTE_B_PROXY' },
    { origen: 'GEO-VEL-3465M-120M-V1', destino: 'GEO-LOTE-B-PROXY-TOPO2007-V1',
      tipo: 'interseccion_con', propagacion: 'automatica_fuerte', confianza: 'alta',
      justificacion: 'Escenario 120m: buffer al deslinde sur · intersect con LOTE_B_PROXY' },
    { origen: 'GEO-VEL-3465M-120M-EXTERNO-SUR-V1', destino: 'GEO-LOTE-B-PROXY-TOPO2007-V1',
      tipo: 'derivada_de', propagacion: 'automatica_fuerte', confianza: 'alta',
      justificacion: 'Derivado del LOTE_B_PROXY · externo sur' },
    { origen: 'GEO-VEL-3465M-140M-V1', destino: 'GEO-LOTE-B-PROXY-TOPO2007-V1',
      tipo: 'interseccion_con', propagacion: 'automatica_fuerte', confianza: 'alta',
      justificacion: 'Escenario 140m: buffer al deslinde sur · intersect con LOTE_B_PROXY' },

    { origen: 'GEO-VEL-3465M-80M-V1', destino: 'GEO-PERIMETRO-CBR-DANIEL-V1',
      tipo: 'comparada_contra', propagacion: 'sugerida_humana', confianza: 'media',
      justificacion: 'Referencia RTK como benchmark' },
    { origen: 'GEO-VEL-3465M-120M-V1', destino: 'GEO-PERIMETRO-CBR-DANIEL-V1',
      tipo: 'comparada_contra', propagacion: 'sugerida_humana', confianza: 'media',
      justificacion: 'Referencia RTK como benchmark' },
    { origen: 'GEO-VEL-3465M-120M-EXTERNO-SUR-V1', destino: 'GEO-PERIMETRO-CBR-DANIEL-V1',
      tipo: 'comparada_contra', propagacion: 'sugerida_humana', confianza: 'media',
      justificacion: 'Referencia RTK como benchmark' },
    { origen: 'GEO-VEL-3465M-140M-V1', destino: 'GEO-PERIMETRO-CBR-DANIEL-V1',
      tipo: 'comparada_contra', propagacion: 'sugerida_humana', confianza: 'media',
      justificacion: 'Referencia RTK como benchmark' },

    { origen: 'GEO-DESLINDE-SUR-LOTE-B-PROXY-3465M', destino: 'GEO-PERIMETRO-CBR-DANIEL-V1',
      tipo: 'comparada_contra', propagacion: 'sugerida_humana', confianza: 'media',
      justificacion: 'Referencia RTK como benchmark canónico' }
  ]
};

// -----------------------------------------------------------------------------
// Helpers · réplicas conceptuales de queries SQL del schema 0003
// -----------------------------------------------------------------------------

export function getDescendientesDe(rootCodigo, data = GRAFO_FIXTURE_HIJUELA_2) {
  const adyacencia = new Map();
  data.relaciones.forEach(r => {
    if (r.propagacion === 'automatica_fuerte') {
      if (!adyacencia.has(r.destino)) adyacencia.set(r.destino, []);
      adyacencia.get(r.destino).push({ hijo: r.origen, tipo: r.tipo });
    }
  });
  const resultado = [];
  const visitados = new Set();
  const stack = [{ codigo: rootCodigo, nivel: 0, via: null, cadena: [] }];
  while (stack.length) {
    const { codigo, nivel, via, cadena } = stack.shift();
    if (nivel > 0) {
      resultado.push({ codigo, nivel, via, cadena: [...cadena] });
    }
    if (visitados.has(codigo) || nivel > 10) continue;
    visitados.add(codigo);
    const hijos = adyacencia.get(codigo) || [];
    hijos.forEach(({ hijo, tipo }) => {
      stack.push({ codigo: hijo, nivel: nivel + 1, via: tipo, cadena: [...cadena, codigo] });
    });
  }
  return resultado;
}

export function getArtefactoByCodigo(codigo, data = GRAFO_FIXTURE_HIJUELA_2) {
  return data.artefactos.find(a => a.codigo === codigo);
}

/**
 * P3.1.A · Cuenta cuántos artefactos descendientes serían afectados
 * si se descalifica el nodo dado. "Impacta: N artefactos".
 */
export function contarImpactoPropagado(rootCodigo, data = GRAFO_FIXTURE_HIJUELA_2) {
  return getDescendientesDe(rootCodigo, data).length;
}

/**
 * P3.1.A · Devuelve los padres directos vía propagación fuerte.
 * "Hereda degradación desde: X".
 */
export function getPadresDirectos(codigo, data = GRAFO_FIXTURE_HIJUELA_2) {
  return data.relaciones
    .filter(r => r.origen === codigo && r.propagacion === 'automatica_fuerte')
    .map(r => ({
      padre: r.destino,
      tipo: r.tipo,
      artefacto: getArtefactoByCodigo(r.destino, data)
    }));
}

/**
 * P3.2 · Hijos directos vía propagación fuerte (un escalón).
 * Para "Qué artefactos heredan directamente de este nodo".
 */
export function getHijosDirectos(codigo, data = GRAFO_FIXTURE_HIJUELA_2) {
  return data.relaciones
    .filter(r => r.destino === codigo && r.propagacion === 'automatica_fuerte')
    .map(r => ({
      hijo: r.origen,
      tipo: r.tipo,
      artefacto: getArtefactoByCodigo(r.origen, data)
    }));
}

/**
 * P3.2 · Devuelve todas las relaciones (cualquier propagación) en las que
 * este artefacto participa, agrupadas por dirección.
 * Útil para el inspector (mostrar todas las conexiones, no solo propagación).
 */
export function getRelacionesDeArtefacto(codigo, data = GRAFO_FIXTURE_HIJUELA_2) {
  return {
    como_origen: data.relaciones.filter(r => r.origen === codigo),
    como_destino: data.relaciones.filter(r => r.destino === codigo)
  };
}

/**
 * P3.2 · Profundidad máxima de la cascada de descendientes.
 * "↧ profundidad N" · cuántos niveles de cadena se generan.
 */
export function calcularProfundidadCascada(rootCodigo, data = GRAFO_FIXTURE_HIJUELA_2) {
  const desc = getDescendientesDe(rootCodigo, data);
  return desc.length === 0 ? 0 : Math.max(...desc.map(d => d.nivel));
}

/**
 * P3.1.B · Categorías de relación para filtros UI.
 */
export const TIPOS_RELACION_CATEGORIAS = {
  todas:        { label: 'Todas', tipos: null },
  derivacion:   { label: 'Derivación', tipos: ['derivada_de', 'extraida_de'] },
  recorte:      { label: 'Recorte', tipos: ['recortada_por'] },
  interseccion: { label: 'Intersección', tipos: ['interseccion_con', 'buffer_de'] },
  comparacion:  { label: 'Comparación', tipos: ['comparada_contra', 'descalificada_por_offset_vs'] },
  referencia:   { label: 'Referencia', tipos: ['referenciada_por', 'respaldada_por', 'hipotesis_apoyada_en'] }
};

export const ITS_GRAFO_DATA_VERSION = '0.3.7B-fixture-local-r2';
