// =============================================================================
// Magnus Radar · ITS v0.3 · its-renderers.js
// 2026-05-31 · Fases 4 + 5 consolidadas
//
// Renderers de sub-tabs con contenido real (todos con fixture Hijuela 2):
//   Fase 4: Superficies, Autoridades, Conflictos
//   Fase 5: Geometrías, Cadena registral, Hipótesis, Evidencia
//
// Funciones puras: data → HTML string. SIN side-effects.
// El toggle "👁 mostrar" en Geometrías es placeholder (no toca MapLibre).
// =============================================================================

import { badge } from './state-badges.js';
import { countConflictosAbiertos } from './its-data.js';
import {
  GRAFO_FIXTURE_HIJUELA_2, getDescendientesDe, getArtefactoByCodigo,
  contarImpactoPropagado, getPadresDirectos, getHijosDirectos,
  getRelacionesDeArtefacto, calcularProfundidadCascada,
  TIPOS_RELACION_CATEGORIAS
} from './its-grafo-data.js';

const fmtHa = (n) => n == null ? '?' : n.toLocaleString('es-CL', {
  minimumFractionDigits: 0, maximumFractionDigits: 2
});
const escape = (s) => String(s ?? '').replace(/[&<>"']/g, c => ({
  '&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;', "'":'&#39;'
}[c]));

// =============================================================================
// FASE 4
// =============================================================================

// -----------------------------------------------------------------------------
// 1 · SUPERFICIES POR CAPA
// -----------------------------------------------------------------------------
function renderSuperficieCard(s) {
  if (s.estado === 'conflicto_documentado') {
    const valores = (s.valores_observados || []).map(v =>
      `${fmtHa(v.valor_ha)} ha <em>(${escape(v.fuente)})</em>`
    ).join(' / ');
    return `
      <div class="its-sup-card its-sup-card--conflict" data-its-conflicto="${escape(s.conflicto_id || '')}">
        <div class="its-sup-card__badge-conflict">⚠ CONFLICTO</div>
        <div class="its-sup-card__values-conflict">${valores}</div>
        <div class="its-sup-card__meta">
          <span class="its-sup-card__capa">${escape(s.capa)}</span> ·
          pendiente <strong>${escape(s.autoridad_resolutiva || 'autoridad')}</strong>
        </div>
        ${s.conflicto_id ? `<div class="its-sup-card__action">→ Ver conflicto ${escape(s.conflicto_id)}</div>` : ''}
      </div>
    `;
  }
  return `
    <div class="its-sup-card" data-its-superficie="${escape(s.codigo)}">
      <div class="its-sup-card__row">
        <div class="its-sup-card__value">${fmtHa(s.valor_ha)} <span class="its-sup-card__unit">ha</span></div>
        ${badge(s.estado || 'verificado')}
      </div>
      <div class="its-sup-card__meta">
        <span class="its-sup-card__capa">${escape(s.capa)}</span> ·
        ${escape(s.año || '?')} ·
        ${escape(s.fuente_short || s.fuente || '—')}
      </div>
      ${s.composicion ? `<div class="its-sup-card__composicion">${escape(s.composicion)}</div>` : ''}
    </div>
  `;
}

export function renderSuperficies(unidad) {
  const sups = unidad.superficies || [];
  if (sups.length === 0) return `<div class="its-empty">Sin superficies registradas.</div>`;
  return `
    <div class="its-subtab-content" data-its-tab-content="superficies">
      <div class="its-subtab-header">
        <div class="its-subtab-title">Superficies por capa</div>
        <div class="its-subtab-subtitle">No existe superficie única. Cada cifra pertenece a una capa con su autoridad.</div>
      </div>
      <div class="its-sup-list">${sups.map(renderSuperficieCard).join('')}</div>
    </div>
  `;
}

// -----------------------------------------------------------------------------
// 2 · AUTORIDADES
// -----------------------------------------------------------------------------
export function renderAutoridades(unidad) {
  const autoridades = unidad.autoridades || [];
  if (autoridades.length === 0) return `<div class="its-empty">Sin matriz de autoridad registrada.</div>`;
  return `
    <div class="its-subtab-content" data-its-tab-content="autoridades">
      <div class="its-subtab-header">
        <div class="its-subtab-title">Matriz de autoridad</div>
        <div class="its-subtab-subtitle">Quién manda en cada dominio · ${autoridades.length} dominios registrados</div>
      </div>
      <table class="its-auth-table">
        <thead><tr><th>Dominio</th><th>Autoridad</th><th class="its-auth-table__state-col">Estado</th></tr></thead>
        <tbody>
          ${autoridades.map(a => `
            <tr data-its-dominio="${escape(a.dominio)}">
              <td class="its-auth-table__dominio">${escape(a.dominio)}</td>
              <td class="its-auth-table__autoridad">${escape(a.autoridad)}</td>
              <td class="its-auth-table__state-col">${badge(a.estado || 'identificado')}</td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    </div>
  `;
}

// -----------------------------------------------------------------------------
// 3 · CONFLICTOS
// -----------------------------------------------------------------------------
const SEVERIDAD_META = {
  alta:  { icon: '⚠', label: 'ALTA',  cls: 'its-conflict-item--alta' },
  media: { icon: '◐', label: 'MEDIA', cls: 'its-conflict-item--media' },
  baja:  { icon: '○', label: 'BAJA',  cls: 'its-conflict-item--baja' }
};

function renderConflictoItem(c) {
  const sev = SEVERIDAD_META[c.severidad] || SEVERIDAD_META.media;
  return `
    <div class="its-conflict-item ${sev.cls}" data-its-conflicto="${escape(c.codigo)}">
      <div class="its-conflict-item__head">
        <span class="its-conflict-item__sev">${sev.icon} ${sev.label}</span>
        <span class="its-conflict-item__codigo">${escape(c.codigo)}</span>
      </div>
      <div class="its-conflict-item__desc">${escape(c.descripcion)}</div>
      <div class="its-conflict-item__meta">
        <div><span class="its-conflict-item__label">autoridad:</span> <strong>${escape(c.autoridad_resolutiva)}</strong></div>
        <div><span class="its-conflict-item__label">acción:</span> ${escape(c.accion)}</div>
      </div>
      <div class="its-conflict-item__state">${badge(c.estado || 'conflicto_documentado')}</div>
    </div>
  `;
}

export function renderConflictos(unidad) {
  // [HARDENING H-A1] Single source: usar countConflictosAbiertos en vez de length crudo
  const abiertosCount = countConflictosAbiertos(unidad);
  const todos = unidad.conflictos || [];
  if (abiertosCount === 0) {
    return `<div class="its-subtab-content" data-its-tab-content="conflictos"><div class="its-empty">✓ Sin conflictos abiertos.</div></div>`;
  }
  const sevOrder = { alta: 0, media: 1, baja: 2 };
  const ordenados = [...todos].sort((a, b) => (sevOrder[a.severidad] ?? 99) - (sevOrder[b.severidad] ?? 99));
  const counts = {
    alta: todos.filter(c => c.severidad === 'alta').length,
    media: todos.filter(c => c.severidad === 'media').length,
    baja: todos.filter(c => c.severidad === 'baja').length
  };
  return `
    <div class="its-subtab-content" data-its-tab-content="conflictos">
      <div class="its-subtab-header">
        <div class="its-subtab-title">Conflictos abiertos</div>
        <div class="its-subtab-subtitle">
          ${abiertosCount} en total · <span class="its-conflict-count its-conflict-count--alta">${counts.alta} alta</span> ·
          <span class="its-conflict-count its-conflict-count--media">${counts.media} media</span> ·
          <span class="its-conflict-count its-conflict-count--baja">${counts.baja} baja</span>
        </div>
      </div>
      <div class="its-conflict-list">${ordenados.map(renderConflictoItem).join('')}</div>
    </div>
  `;
}

// =============================================================================
// FASE 5
// =============================================================================

// -----------------------------------------------------------------------------
// 4 · GEOMETRÍAS (4 cards verticales · toggle mostrar = placeholder)
// -----------------------------------------------------------------------------

// Set hardcodeado de códigos con geometría operacional disponible (Fase 7A).
// Coherente con map-geometrias.js · G3 y G4 disponibles, G1 y G2 no.
const GEOMS_DISPONIBLES = new Set(['G3', 'G4']);
const GEOMS_RAZON_NO_DISPONIBLE = {
  G1: 'Solo fotos HEIC · georreferenciación pendiente Fase 12.',
  G2: 'Plano no extraído del CBR La Serena todavía. GAP_PLANO_531_1992.'
};

function renderGeometriaCard(g) {
  const isSuperseded = g.estado === 'superseded';
  const isPending = g.estado === 'localizado_pendiente_extraccion';
  const isDisponible = GEOMS_DISPONIBLES.has(g.codigo);
  const razonNo = GEOMS_RAZON_NO_DISPONIBLE[g.codigo];
  const classes = ['its-geom-card'];
  if (isSuperseded) classes.push('its-geom-card--superseded');
  if (isPending) classes.push('its-geom-card--pending');
  if (!isDisponible) classes.push('its-geom-card--no-geom');

  const toggleHtml = isDisponible
    ? `<label class="its-geom-card__toggle its-geom-card__toggle--active">
         <input type="checkbox" data-its-geom-toggle="${escape(g.codigo)}">
         <span class="its-geom-card__toggle-label">👁 mostrar en mapa</span>
       </label>`
    : `<span class="its-geom-card__no-geom" title="${escape(razonNo || 'Geometría no disponible')}">
         ⊠ sin geometría operacional
       </span>`;

  return `
    <div class="${classes.join(' ')}" data-its-geometria="${escape(g.codigo)}">
      <div class="its-geom-card__head">
        <span class="its-geom-card__codigo">${escape(g.codigo)}</span>
        ${badge(g.estado || 'identificado')}
        ${toggleHtml}
      </div>
      <div class="its-geom-card__fuente">${escape(g.fuente || '—')}</div>
      <div class="its-geom-card__meta">
        ${escape(g.año || '?')} · ${escape(g.tipo || '?')}${g.superficie_ha != null ? ' · ' + fmtHa(g.superficie_ha) + ' ha' : ''}
      </div>
      ${g.meta ? `<div class="its-geom-card__details">${escape(g.meta)}</div>` : ''}
      ${g.datum ? `<div class="its-geom-card__details mono">datum: ${escape(g.datum)}</div>` : ''}
      ${!isDisponible && razonNo ? `<div class="its-geom-card__no-geom-reason">${escape(razonNo)}</div>` : ''}
    </div>
  `;
}

export function renderGeometrias(unidad) {
  const geoms = unidad.representaciones || [];
  if (geoms.length === 0) return `<div class="its-empty">Sin representaciones geométricas registradas.</div>`;
  const disponibles = geoms.filter(g => GEOMS_DISPONIBLES.has(g.codigo)).length;
  return `
    <div class="its-subtab-content" data-its-tab-content="geometrias">
      <div class="its-subtab-header">
        <div class="its-subtab-title">Representaciones geométricas</div>
        <div class="its-subtab-subtitle">
          ${geoms.length} concurrentes · ${disponibles} con geometría real en mapa · ninguna sobrescribe a otra
        </div>
      </div>
      <div class="its-geom-list">${geoms.map(renderGeometriaCard).join('')}</div>
      <div class="its-geom-actions">
        <button class="its-geom-actions__btn" data-its-geom-show-all>Mostrar disponibles</button>
        <button class="its-geom-actions__btn" data-its-geom-hide-all>Ocultar todas</button>
        <button class="its-geom-actions__btn" data-its-geom-fit>Encuadrar visibles</button>
      </div>
    </div>
  `;
}

// -----------------------------------------------------------------------------
// 5 · CADENA REGISTRAL (timeline vertical)
// -----------------------------------------------------------------------------

function renderCadenaEvento(e) {
  const isBig = e.importancia === 'big';
  const classes = ['its-cadena-evento'];
  if (isBig) classes.push('its-cadena-evento--big');
  if (e.estado === 'localizado_pendiente_extraccion') classes.push('its-cadena-evento--pending');
  if (e.estado === 'verificado') classes.push('its-cadena-evento--verified');

  return `
    <div class="${classes.join(' ')}" data-its-evento="${escape(e.año)}">
      <div class="its-cadena-evento__col-left">
        <div class="its-cadena-evento__year">${escape(e.año)}</div>
        <div class="its-cadena-evento__marker"></div>
      </div>
      <div class="its-cadena-evento__col-body">
        <div class="its-cadena-evento__label">${escape(e.label || e.tipo)}</div>
        <div class="its-cadena-evento__desc">${escape(e.desc || '')}</div>
        <div class="its-cadena-evento__meta">
          ${e.inscripcion ? `<span class="mono">${escape(e.inscripcion)}</span>` : ''}
          ${e.capa ? ` · capa ${escape(e.capa)}` : ''}
          · ${badge(e.estado || 'identificado')}
        </div>
      </div>
    </div>
  `;
}

export function renderCadena(unidad) {
  const eventos = unidad.cadena_registral || [];
  const hipotesis = unidad.hipotesis || [];
  if (eventos.length === 0) return `<div class="its-empty">Sin cadena registral cargada.</div>`;
  return `
    <div class="its-subtab-content" data-its-tab-content="cadena">
      <div class="its-subtab-header">
        <div class="its-subtab-title">Cadena registral</div>
        <div class="its-subtab-subtitle">${eventos.length} eventos verificados/localizados · cronología por capa temporal</div>
      </div>
      <div class="its-cadena-timeline-v">
        ${eventos.map(renderCadenaEvento).join('')}
      </div>
      ${hipotesis.length > 0 ? `
        <div class="its-cadena-hipotesis-link">
          ◇ ${hipotesis.length} hipótesis activa(s) · no son eslabones de la cadena · ver tab Hipótesis
        </div>
      ` : ''}
    </div>
  `;
}

// -----------------------------------------------------------------------------
// 6 · HIPÓTESIS (cards)
// -----------------------------------------------------------------------------

function renderHipotesisCard(h) {
  return `
    <div class="its-hipotesis-card" data-its-hipotesis="${escape(h.codigo)}">
      <div class="its-hipotesis-card__head">
        <span class="its-hipotesis-card__icon">◇</span>
        <span class="its-hipotesis-card__codigo">${escape(h.codigo)}</span>
        ${badge(h.estado || 'hipotesis_de_trabajo')}
      </div>
      <div class="its-hipotesis-card__desc">${escape(h.descripcion || '—')}</div>
      ${h.contexto_temporal ? `
        <div class="its-hipotesis-card__section">
          <div class="its-hipotesis-card__label">Contexto temporal</div>
          <div>${escape(h.contexto_temporal)}</div>
        </div>
      ` : ''}
      ${h.promovible_si ? `
        <div class="its-hipotesis-card__section">
          <div class="its-hipotesis-card__label">Promovible a hecho si</div>
          <div>${escape(h.promovible_si)}</div>
        </div>
      ` : ''}
    </div>
  `;
}

export function renderHipotesis(unidad) {
  const hips = unidad.hipotesis || [];
  if (hips.length === 0) {
    return `<div class="its-subtab-content" data-its-tab-content="hipotesis"><div class="its-empty">Sin hipótesis activas.</div></div>`;
  }
  return `
    <div class="its-subtab-content" data-its-tab-content="hipotesis">
      <div class="its-subtab-header">
        <div class="its-subtab-title">Hipótesis activas</div>
        <div class="its-subtab-subtitle">${hips.length} explicación(es) útil(es) · no son hechos canónicos hasta promoción con evidencia primaria</div>
      </div>
      <div class="its-hipotesis-list">${hips.map(renderHipotesisCard).join('')}</div>
    </div>
  `;
}

// -----------------------------------------------------------------------------
// 7 · EVIDENCIA (lista agregada derivada)
// -----------------------------------------------------------------------------

/**
 * Agrega evidencia documental implícita de la unidad recorriendo:
 *   - superficies (fuente_short, conflicto_id)
 *   - cadena_registral (inscripcion)
 *   - representaciones (fuente)
 *   - conflictos (autoridad_resolutiva referenciada)
 * Devuelve agrupada por tipo de fuente.
 */
function buildEvidenciaAgregada(unidad) {
  const items = [];

  (unidad.superficies || []).forEach(s => {
    if (s.fuente_short) {
      items.push({ tipo: clasificarFuente(s.fuente_short), referencia: s.fuente_short, nodo: 'superficie', origen: s.codigo || s.capa, estado: s.estado || 'verificado' });
    }
  });

  (unidad.cadena_registral || []).forEach(e => {
    if (e.inscripcion) {
      items.push({ tipo: 'CBR / inscripción', referencia: e.inscripcion, nodo: 'cadena_registral', origen: `${e.año} · ${e.label || e.tipo}`, estado: e.estado || 'identificado' });
    }
  });

  (unidad.representaciones || []).forEach(g => {
    if (g.fuente) {
      items.push({ tipo: clasificarFuente(g.fuente), referencia: g.fuente, nodo: 'representacion_geometrica', origen: g.codigo, estado: g.estado || 'identificado' });
    }
  });

  if (unidad.mandato?.repertorio) {
    items.push({ tipo: 'Mandato', referencia: unidad.mandato.repertorio, nodo: 'mandato', origen: unidad.mandato.mandataria || '—', estado: 'verificado' });
  }

  // De-duplicar por (tipo, referencia) preservando primer origen
  const seen = new Set();
  const unique = items.filter(it => {
    const key = it.tipo + '|' + it.referencia;
    if (seen.has(key)) return false;
    seen.add(key);
    return true;
  });

  // Agrupar por tipo
  const grupos = {};
  unique.forEach(it => {
    if (!grupos[it.tipo]) grupos[it.tipo] = [];
    grupos[it.tipo].push(it);
  });
  return grupos;
}

function clasificarFuente(s) {
  const str = String(s).toLowerCase();
  if (str.includes('cbr') || str.includes('fs.') || str.includes('inscripción')) return 'CBR / inscripción';
  if (str.includes('rtk') || str.includes('daniel') || str.includes('magnus')) return 'RTK / medición propia';
  if (str.includes('mbn') || str.includes('plano')) return 'Plano matriz / catastral';
  if (str.includes('kmz') || str.includes('dataroom')) return 'KMZ / data room';
  if (str.includes('títulos') || str.includes('estudio')) return 'Estudio de títulos';
  if (str.includes('repertorio')) return 'Notarial / Mandato';
  if (str.includes('sii')) return 'SII / Fiscal';
  return 'Otra fuente';
}

export function renderEvidencia(unidad) {
  const grupos = buildEvidenciaAgregada(unidad);
  const tipos = Object.keys(grupos);
  const total = tipos.reduce((acc, t) => acc + grupos[t].length, 0);
  if (total === 0) {
    return `<div class="its-subtab-content" data-its-tab-content="evidencia"><div class="its-empty">Sin evidencia documental indexada.</div></div>`;
  }
  return `
    <div class="its-subtab-content" data-its-tab-content="evidencia">
      <div class="its-subtab-header">
        <div class="its-subtab-title">Evidencia documental</div>
        <div class="its-subtab-subtitle">${total} referencias únicas agregadas desde superficies + cadena + geometrías + mandato</div>
      </div>
      <div class="its-evidencia-list">
        ${tipos.map(tipo => `
          <div class="its-evidencia-grupo">
            <div class="its-evidencia-grupo__titulo">${escape(tipo)} <span class="its-evidencia-grupo__count">${grupos[tipo].length}</span></div>
            <div class="its-evidencia-grupo__items">
              ${grupos[tipo].map(it => `
                <div class="its-evidencia-item">
                  <div class="its-evidencia-item__ref mono">${escape(it.referencia)}</div>
                  <div class="its-evidencia-item__origen">${escape(it.origen)} · <span class="its-evidencia-item__nodo">${escape(it.nodo)}</span></div>
                  <div class="its-evidencia-item__state">${badge(it.estado)}</div>
                </div>
              `).join('')}
            </div>
          </div>
        `).join('')}
      </div>
    </div>
  `;
}

// =============================================================================
// REGISTRY
// =============================================================================

// =============================================================================
// FASE P3 · Sub-tab Artefactos · grafo desde fixture local
// =============================================================================

function renderArtefactoNodo(art, viaTipoRelacion, nivel, opts = {}) {
  if (!art) return '';
  const indent = '&nbsp;'.repeat(Math.max(0, nivel * 4));
  const prefix = nivel > 0
    ? `<span class="its-grafo-tree-branch">${indent}└─ <span class="its-grafo-tipo-rel">${escape(viaTipoRelacion || '')}</span> →</span>`
    : '';
  const badgeVigencia = art.vigencia === 'descalificada'
    ? '<span class="its-grafo-degradacion">⊘ descalificada</span>'
    : (art.vigencia === 'vigente' ? '<span class="its-grafo-vigente">✓ vigente</span>' : '');
  const badgeProxy = art.afectado_proxy ? '<span class="its-grafo-proxy">↺ afectado_proxy_corrido</span>' : '';
  const anclaBadge = art.ancla_canonica ? '<span class="its-grafo-ancla">⚓ ancla canónica</span>' : '';
  const supBadge = art.sup_calc ? `<span class="its-grafo-sup">${fmtHa(art.sup_calc)} ha</span>` : '';

  // P3.1.C · confidence_score_ia visible cuando existe
  const confidenceBadge = (typeof art.confidence_ia === 'number')
    ? `<span class="its-grafo-ci" title="Confianza algorítmica (NO confianza operacional humana)">IA ${art.confidence_ia}%</span>`
    : '';

  // P3.1.A · contador de impacto propagado
  const impacto = contarImpactoPropagado(art.codigo);
  const impactoBadge = (impacto > 0)
    ? `<span class="its-grafo-impacto" title="Cuántos artefactos descendientes serían afectados si se descalifica este nodo">↡ impacta ${impacto} artefactos</span>`
    : '';

  // P3.2 · profundidad de cascada (cuántos niveles de descendientes)
  const profundidad = calcularProfundidadCascada(art.codigo);
  const profundidadBadge = (profundidad > 0)
    ? `<span class="its-grafo-profundidad" title="Niveles máximos de cadena · qué tan lejos llega la propagación">↧ profundidad ${profundidad}</span>`
    : '';

  // P3.1.A · "hereda degradación desde X" (solo cuando aplica)
  let herenciaBlock = '';
  if (art.afectado_proxy) {
    const padres = getPadresDirectos(art.codigo);
    if (padres.length > 0) {
      const codigosPadres = padres.map(p => p.padre).join(', ');
      herenciaBlock = `<div class="its-grafo-herencia">↺ Hereda degradación desde: <code>${escape(codigosPadres)}</code></div>`;
    }
  }

  return `
    <div class="its-grafo-nodo its-grafo-nodo--nivel${nivel}" data-its-artefacto="${escape(art.codigo)}" data-its-grafo-nodo="${escape(art.codigo)}">
      ${prefix}
      <code class="its-grafo-codigo">${escape(art.codigo)}</code>
      <span class="its-grafo-nombre">${escape(art.nombre)}</span>
      ${badgeVigencia} ${badgeProxy} ${anclaBadge} ${supBadge} ${confidenceBadge} ${impactoBadge} ${profundidadBadge}
      ${herenciaBlock}
    </div>
  `;
}

// P3.2 · Inspector de artefacto (drawer lateral)
export function renderArtefactoInspector(codigo) {
  const art = getArtefactoByCodigo(codigo);
  if (!art) return `<div class="its-inspector__empty">Artefacto no encontrado: ${escape(codigo)}</div>`;

  const padres = getPadresDirectos(codigo);
  const hijos = getHijosDirectos(codigo);
  const relaciones = getRelacionesDeArtefacto(codigo);
  const impacto = contarImpactoPropagado(codigo);
  const profundidad = calcularProfundidadCascada(codigo);

  const dato = (label, valor, mono = false) => valor
    ? `<div class="its-inspector__row">
        <div class="its-inspector__label">${escape(label)}</div>
        <div class="its-inspector__valor ${mono ? 'mono' : ''}">${escape(String(valor))}</div>
      </div>`
    : '';

  return `
    <div class="its-inspector">
      <div class="its-inspector__header">
        <div class="its-inspector__codigo mono">${escape(art.codigo)}</div>
        <div class="its-inspector__nombre">${escape(art.nombre)}</div>
        <button class="its-inspector__close" data-its-inspector-close>✕</button>
      </div>

      <div class="its-inspector__seccion">
        <div class="its-inspector__seccion-titulo">Estado</div>
        <div class="its-inspector__badges">
          ${art.vigencia === 'vigente' ? '<span class="its-grafo-vigente">✓ vigente</span>' : ''}
          ${art.vigencia === 'descalificada' ? '<span class="its-grafo-degradacion">⊘ descalificada</span>' : ''}
          ${art.vigencia === 'validando' ? '<span class="its-grafo-vigente" style="background:#fff8e1;color:#8a6d3b">⋯ validando</span>' : ''}
          ${art.afectado_proxy ? '<span class="its-grafo-proxy">↺ afectado_proxy_corrido</span>' : ''}
          ${art.ancla_canonica ? '<span class="its-grafo-ancla">⚓ ancla canónica</span>' : ''}
          ${typeof art.confidence_ia === 'number' ? `<span class="its-grafo-ci">IA ${art.confidence_ia}%</span>` : ''}
        </div>
      </div>

      <div class="its-inspector__seccion">
        <div class="its-inspector__seccion-titulo">Identidad</div>
        ${dato('Tipo', art.tipo, true)}
        ${dato('Año', art.anio)}
        ${dato('Naturaleza geo', art.naturaleza_geo, true)}
        ${dato('Jerarquía fuente', art.jerarquia, true)}
        ${dato('Uso', art.uso, true)}
        ${dato('Fuente archivo', art.fuente_archivo, true)}
      </div>

      <div class="its-inspector__seccion">
        <div class="its-inspector__seccion-titulo">Confianza</div>
        ${dato('Nivel operacional', art.nivel_confianza)}
        ${art.precision_metros ? dato('Precisión (m)', art.precision_metros) : ''}
        ${typeof art.confidence_ia === 'number' ? dato('Confianza IA', art.confidence_ia + '%') : ''}
        ${art.tiene_desfase_declarado ? dato('Desfase declarado', 'SÍ · ' + (art.vector_desfase || 'sin cuantificar')) : ''}
      </div>

      ${art.sup_calc ? `
        <div class="its-inspector__seccion">
          <div class="its-inspector__seccion-titulo">Métricas</div>
          ${dato('Superficie calculada (ha)', fmtHa(art.sup_calc))}
        </div>
      ` : ''}

      ${art.observacion_obligatoria ? `
        <div class="its-inspector__seccion its-inspector__seccion--observacion">
          <div class="its-inspector__seccion-titulo">⚠ Observación obligatoria</div>
          <div class="its-inspector__observacion">${escape(art.observacion_obligatoria)}</div>
        </div>
      ` : ''}

      <div class="its-inspector__seccion">
        <div class="its-inspector__seccion-titulo">Impacto en el grafo</div>
        <div class="its-inspector__metrica-row">
          <span class="its-grafo-impacto">↡ impacta ${impacto} artefactos</span>
          <span class="its-grafo-profundidad">↧ profundidad ${profundidad}</span>
        </div>
      </div>

      <div class="its-inspector__seccion">
        <div class="its-inspector__seccion-titulo">Padres directos (${padres.length})</div>
        ${padres.length === 0
          ? '<div class="its-inspector__empty">Sin padres · este es un nodo raíz vía propagación fuerte</div>'
          : '<ul class="its-inspector__rel-lista">' + padres.map(p => `
              <li class="its-inspector__rel-item" data-its-inspector-nav="${escape(p.padre)}">
                <span class="its-grafo-tipo-rel">${escape(p.tipo)}</span> →
                <code>${escape(p.padre)}</code>
                ${p.artefacto?.afectado_proxy ? ' <span class="its-grafo-proxy" style="font-size:9px">↺</span>' : ''}
              </li>`).join('') + '</ul>'}
      </div>

      <div class="its-inspector__seccion">
        <div class="its-inspector__seccion-titulo">Hijos directos (${hijos.length})</div>
        ${hijos.length === 0
          ? '<div class="its-inspector__empty">Sin hijos directos vía propagación fuerte</div>'
          : '<ul class="its-inspector__rel-lista">' + hijos.map(h => `
              <li class="its-inspector__rel-item" data-its-inspector-nav="${escape(h.hijo)}">
                <code>${escape(h.hijo)}</code>
                ← <span class="its-grafo-tipo-rel">${escape(h.tipo)}</span>
              </li>`).join('') + '</ul>'}
      </div>

      ${relaciones.como_origen.length + relaciones.como_destino.length > padres.length + hijos.length ? `
        <div class="its-inspector__seccion its-inspector__seccion--meta">
          <div class="its-inspector__seccion-titulo">Otras relaciones</div>
          <div class="its-inspector__rel-resumen">
            ${relaciones.como_origen.length} como origen · ${relaciones.como_destino.length} como destino
            (incluye comparada_contra y otras relaciones débiles)
          </div>
        </div>
      ` : ''}
    </div>
  `;
}

export function renderArtefactos(unidad) {
  const data = GRAFO_FIXTURE_HIJUELA_2;
  const totalArtefactos = data.artefactos.length;
  const totalRelaciones = data.relaciones.length;
  const afectados = data.artefactos.filter(a => a.afectado_proxy).length;
  const descalificados = data.artefactos.filter(a => a.vigencia === 'descalificada').length;
  const ancla = data.artefactos.find(a => a.ancla_canonica);

  // Cascada desde TOPO 2007 (caso emblemático)
  const root = getArtefactoByCodigo('GEO-TOPO-COMINETTI-2007', data);
  const descendientes = getDescendientesDe('GEO-TOPO-COMINETTI-2007', data);

  // Agrupar descendientes por nivel
  const nivelMax = Math.max(0, ...descendientes.map(d => d.nivel));

  // RTK + 12 artefactos que lo referencian como benchmark
  const queComparanContraRTK = data.relaciones
    .filter(r => r.destino === ancla?.codigo && r.tipo === 'comparada_contra')
    .map(r => getArtefactoByCodigo(r.origen, data))
    .filter(Boolean);

  return `
    <div class="its-subtab-content" data-its-tab-content="artefactos">
      <div class="its-subtab-header">
        <div class="its-subtab-title">Artefactos · grafo causal</div>
        <div class="its-subtab-subtitle">
          ${totalArtefactos} artefactos · ${totalRelaciones} relaciones · ${afectados} afectado_proxy_corrido · ${descalificados} descalificados
        </div>
      </div>

      <div class="its-grafo-aviso-fixture">
        ⚠ <strong>Vista preliminar · grafo cargado desde fixture local</strong>
        <div class="its-grafo-aviso-sub">
          Datos del seed <code>db/seeds/0003_artefactos_hijuela_2.sql</code> · pendiente validación staging Supabase
          (ver <code>db/RUN_STAGING_FASE_P25.md</code>).
        </div>
      </div>

      <div class="its-grafo-bloque">
        <div class="its-grafo-bloque__titulo">Cascada de descalificación · desde TOPO 2007</div>
        <div class="its-grafo-bloque__subtitulo">
          Si TOPO 2007 se descalifica, ${descendientes.length} artefactos se ven afectados vía propagación automática_fuerte.
          Nivel máximo de cadena: ${nivelMax}.
        </div>

        <div class="its-grafo-filtros" data-its-grafo-filtros>
          ${Object.entries(TIPOS_RELACION_CATEGORIAS).map(([key, cat]) => `
            <button class="its-grafo-filtro${key === 'todas' ? ' active' : ''}" data-its-filtro="${key}">${escape(cat.label)}</button>
          `).join('')}
        </div>

        <div class="its-grafo-arbol" data-its-grafo-arbol>
          ${renderArtefactoNodo(root, null, 0)}
          ${descendientes.map(d =>
            `<div data-its-via="${escape(d.via || '')}">${renderArtefactoNodo(getArtefactoByCodigo(d.codigo, data), d.via, d.nivel)}</div>`
          ).join('')}
        </div>
      </div>

      <div class="its-grafo-bloque">
        <div class="its-grafo-bloque__titulo">Ancla canónica · benchmark</div>
        <div class="its-grafo-bloque__subtitulo">
          ${ancla ? `<code>${escape(ancla.codigo)}</code> es referencia de validación para ${queComparanContraRTK.length} artefactos (relación <code>comparada_contra</code>)` : ''}
        </div>
        <div class="its-grafo-arbol">
          ${ancla ? renderArtefactoNodo(ancla, null, 0) : ''}
          ${queComparanContraRTK.map(a => `
            <div class="its-grafo-nodo its-grafo-nodo--bench">
              <span class="its-grafo-tree-branch">&nbsp;&nbsp;&nbsp;&nbsp;← <span class="its-grafo-tipo-rel">comparada_contra</span> ←</span>
              <code class="its-grafo-codigo">${escape(a.codigo)}</code>
              <span class="its-grafo-nombre">${escape(a.nombre)}</span>
            </div>
          `).join('')}
        </div>
      </div>

      <div class="its-grafo-bloque its-grafo-bloque--info">
        <div class="its-grafo-bloque__titulo">Cuando se ejecute staging</div>
        <div class="its-grafo-bloque__subtitulo">
          La consulta canónica:<br>
          <code>SELECT * FROM its.artefactos_afectados_si_descalifico WHERE root = 'GEO-TOPO-COMINETTI-2007';</code><br>
          debería devolver la misma cascada que se ve arriba. Si difiere, indica error en el seed o el CTE.
        </div>
      </div>
    </div>
  `;
}

// =============================================================================
// REGISTRY
// =============================================================================

export const SUB_TAB_RENDERERS = {
  superficies: renderSuperficies,
  autoridades: renderAutoridades,
  conflictos:  renderConflictos,
  geometrias:  renderGeometrias,
  cadena:      renderCadena,
  hipotesis:   renderHipotesis,
  evidencia:   renderEvidencia,
  artefactos:  renderArtefactos
};

export const ITS_RENDERERS_VERSION = '0.3.7B-fixture-grafo';
