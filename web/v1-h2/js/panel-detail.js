// =============================================================================
// Magnus Radar · ITS v0.3 · panel-detail.js
// 2026-05-31 · Fases 2+3 consolidadas (re-aplicado tras SANDBOX_OVERLAY_LOSS)
//
// Hook de detección unidad + chip "Parte de" + breadcrumb 3-niveles + vista unidad
// + sub-tabs estructurales + URL hash + hash inicial al cargar.
//
// Wrappers REVERSIBLES sobre window.selectPredio y window.updateUrlHash.
// NO destructivo (preserva referencia previa) · NO modifica código v1.
//
// Renderers de sub-tabs reales (Superficies, Autoridades, Conflictos) se conectan
// desde its-renderers.js (Fase 4).
// =============================================================================

import { getUnitForPredio, FIXTURE, countConflictosAbiertos } from './its-data.js';
import { SUB_TAB_RENDERERS, renderArtefactoInspector } from './its-renderers.js';
import {
  showGeometria, hideGeometria, toggleGeometria, isGeometriaVisible,
  listAvailableGeometrias, hideAllGeometrias, fitToVisibleGeometrias
} from './map-geometrias.js';

let _prevSelectPredio = null;
let _prevUpdateUrlHash = null;
let _currentSelection = { type: null, id: null };
let _lastPredioFeature = null;
let _activeSubTab = 'resumen';

function $panel() { return document.getElementById('panel'); }

function removeChipUnidad() {
  document.querySelectorAll('.its-chip-unidad').forEach(el => el.remove());
}
function removeBreadcrumb() {
  document.querySelectorAll('.its-breadcrumb').forEach(el => el.remove());
}

// -----------------------------------------------------------------------------
// BREADCRUMB
// -----------------------------------------------------------------------------

function renderBreadcrumbHTML(parts) {
  return `<nav class="its-breadcrumb" aria-label="breadcrumb">${parts.map((p, i) => {
    const sep = i < parts.length - 1 ? ' <span class="its-breadcrumb__sep">▸</span> ' : '';
    if (p.current) return `<strong class="its-breadcrumb__current">${p.label}</strong>${sep}`;
    return `<a href="#" class="its-breadcrumb__link" data-its-nav="${p.navTo}">${p.label}</a>${sep}`;
  }).join('')}</nav>`;
}

function shortUnidadName(name) {
  if (!name) return '';
  return name.replace(/^Hijuela (\d+).*/i, 'Hijuela $1').slice(0, 40);
}

function buildBreadcrumbParts({ territorio, unidad, predio, currentLevel }) {
  const parts = [];
  if (territorio) parts.push({ label: territorio.nombre || territorio.codigo, navTo: 't:' + territorio.codigo, current: currentLevel === 'territorio' });
  if (unidad) parts.push({ label: shortUnidadName(unidad.nombre || unidad.codigo), navTo: 'u:' + unidad.codigo, current: currentLevel === 'unidad' });
  if (predio) parts.push({ label: 'Rol ' + predio, navTo: 'p:' + predio, current: currentLevel === 'predio' });
  return parts;
}

function insertBreadcrumbInPanel(html) {
  const panel = $panel();
  if (!panel) return false;
  const header = panel.querySelector('.panel-header');
  if (!header) return false;
  removeBreadcrumb();
  header.insertAdjacentHTML('afterbegin', html);
  panel.querySelectorAll('.its-breadcrumb__link').forEach(a => {
    a.addEventListener('click', (e) => {
      e.preventDefault();
      const navTo = a.getAttribute('data-its-nav');
      if (!navTo) return;
      const [type, id] = navTo.split(':');
      navigateTo({ t: 'territorio', u: 'unidad', p: 'predio' }[type], id);
    });
  });
  return true;
}

// -----------------------------------------------------------------------------
// CHIP "Parte de unidad"
// -----------------------------------------------------------------------------

function renderChipUnidad(rol, unitId) {
  const panel = $panel();
  if (!panel) return false;
  const header = panel.querySelector('.panel-header');
  if (!header) return false;
  removeChipUnidad();
  const unidad = FIXTURE.unidades[unitId];
  if (!unidad) return false;
  const chip = document.createElement('div');
  chip.className = 'its-chip-unidad';
  chip.setAttribute('data-its-unidad', unitId);
  chip.innerHTML = `
    <span class="its-chip-unidad__icon">📍</span>
    <span class="its-chip-unidad__text">Parte de <strong>${unidad.nombre}</strong></span>
    <a class="its-chip-unidad__action" href="#" role="button">Ver unidad →</a>
  `;
  chip.querySelector('.its-chip-unidad__action').addEventListener('click', (e) => {
    e.preventDefault();
    navigateTo('unidad', unitId);
  });
  header.appendChild(chip);
  return true;
}

// -----------------------------------------------------------------------------
// VISTA UNIDAD
// -----------------------------------------------------------------------------

const SUB_TABS = [
  { id: 'resumen',     label: 'Resumen' },
  { id: 'superficies', label: 'Superficies', badge: (u) => u.superficies?.length },
  { id: 'autoridades', label: 'Autoridades' },
  { id: 'conflictos',  label: 'Conflictos',  badge: (u) => countConflictosAbiertos(u), warn: true },
  { id: 'geometrias',  label: 'Geometrías' },
  { id: 'cadena',      label: 'Cadena' },
  { id: 'hipotesis',   label: 'Hipótesis',   badge: (u) => u.hipotesis?.length },
  { id: 'evidencia',   label: 'Evidencia' },
  { id: 'artefactos',  label: 'Artefactos · grafo', fixture: true }   // P3 · fixture local
];

function renderSubTabsHTML(unidad) {
  return `<div class="its-subtabs" role="tablist">
    ${SUB_TABS.map(t => {
      const n = t.badge ? t.badge(unidad) : null;
      const badge = n ? `<span class="its-subtab__badge${t.warn ? ' its-subtab__badge--warn' : ''}">${n}${t.warn ? ' ⚠' : ''}</span>` : '';
      const fixtureBadge = t.fixture ? '<span class="its-subtab__fixture" title="Datos desde fixture local · pendiente validación staging">fixture</span>' : '';
      const active = t.id === _activeSubTab ? ' active' : '';
      return `<button class="its-subtab${active}" role="tab" data-its-tab="${t.id}">${t.label}${badge}${fixtureBadge}</button>`;
    }).join('')}
  </div>`;
}

function renderResumenUnidad(unidad) {
  const territorio = FIXTURE.territorios[unidad.territorio];
  return `
    <div class="its-subtab-content" data-its-tab-content="resumen">
      <div class="its-section">
        <div class="its-section__title">Mandato vigente</div>
        <div class="its-section__body">
          <strong>${unidad.mandato?.mandataria || '—'}</strong> ·
          ${unidad.mandato?.repertorio || '—'} ·
          ${unidad.mandato?.plazo_meses || '?'} meses ·
          ${unidad.mandato?.comision_pct || '?'}%
        </div>
      </div>
      <div class="its-section">
        <div class="its-section__title">Titulares (${unidad.titulares?.length || 0})</div>
        <div class="its-section__body">
          ${(unidad.titulares || []).map(t => `
            <div class="its-titular-row">
              <span>${t.nombre}</span>
              <span class="mono">${t.pct.toFixed(2)}%</span>
            </div>
          `).join('')}
        </div>
      </div>
      ${territorio ? `
        <div class="its-section">
          <div class="its-section__title">Contexto envolvente</div>
          <div class="its-section__body">
            <strong>${territorio.nombre}</strong> · Rol ${territorio.rol_sii_matriz} ·
            ${(territorio.superficie_aprox_ha || 0).toLocaleString('es-CL')} ha ·
            <strong>${territorio.titular_matriz}</strong> desde ${territorio.fecha_adquisicion}.
            <br><em>${unidad.nombre} es enclave dentro de la matriz.</em>
          </div>
        </div>
      ` : ''}
      <div class="its-section its-section--meta">
        <div class="its-section__title">Estado epistemológico</div>
        <div class="its-section__body">
          ${unidad.estado || 'identificado'} ·
          <a href="#" class="its-link" data-its-tab="conflictos">${countConflictosAbiertos(unidad)} conflictos abiertos ⚠</a>
        </div>
      </div>
    </div>
  `;
}

function renderPlaceholderSubTab(tabId, unidad) {
  const tabMeta = SUB_TABS.find(t => t.id === tabId);
  const count = tabMeta?.badge ? tabMeta.badge(unidad) : null;
  return `
    <div class="its-subtab-content" data-its-tab-content="${tabId}">
      <div class="its-placeholder">
        <div class="its-placeholder__title">${tabMeta?.label || tabId}</div>
        <div class="its-placeholder__body">
          ${count ? `${count} elemento(s) registrado(s) en la ontología ITS.<br>` : ''}
          Render completo en Fase 5+.
        </div>
      </div>
    </div>
  `;
}

function pickSubTabContent(tabId, unidad) {
  if (tabId === 'resumen') return renderResumenUnidad(unidad);
  if (SUB_TAB_RENDERERS[tabId]) return SUB_TAB_RENDERERS[tabId](unidad);
  return renderPlaceholderSubTab(tabId, unidad);
}

/**
 * P3.2 · Inspector de artefacto (drawer lateral).
 * Idempotente: maneja apertura, cierre, navegación entre nodos relacionados.
 */
function openInspector(codigo) {
  let backdrop = document.getElementById('its-inspector-backdrop');
  let drawer = document.getElementById('its-inspector-drawer');

  if (!backdrop) {
    backdrop = document.createElement('div');
    backdrop.id = 'its-inspector-backdrop';
    backdrop.className = 'its-inspector-backdrop';
    document.body.appendChild(backdrop);
  }
  if (!drawer) {
    drawer = document.createElement('div');
    drawer.id = 'its-inspector-drawer';
    drawer.className = 'its-inspector-drawer';
    document.body.appendChild(drawer);
  }

  drawer.innerHTML = renderArtefactoInspector(codigo);
  backdrop.classList.add('its-inspector-backdrop--open');
  drawer.classList.add('its-inspector-drawer--open');

  // Cerrar al click backdrop
  backdrop.onclick = closeInspector;

  // Cerrar al click X
  drawer.querySelector('[data-its-inspector-close]')?.addEventListener('click', closeInspector);

  // [HARDENING H-A2] Navegación interna del drawer usa data-its-inspector-nav
  // (distinto de data-its-grafo-nodo del grafo principal · evita doble listener)
  drawer.querySelectorAll('[data-its-inspector-nav]').forEach(el => {
    el.addEventListener('click', (e) => {
      e.stopPropagation();
      const code = el.getAttribute('data-its-inspector-nav');
      if (code) openInspector(code);
    });
  });

  // ESC cierra
  const escHandler = (e) => {
    if (e.key === 'Escape') {
      closeInspector();
      document.removeEventListener('keydown', escHandler);
    }
  };
  document.addEventListener('keydown', escHandler);
}

function closeInspector() {
  const backdrop = document.getElementById('its-inspector-backdrop');
  const drawer = document.getElementById('its-inspector-drawer');
  backdrop?.classList.remove('its-inspector-backdrop--open');
  drawer?.classList.remove('its-inspector-drawer--open');
}

/**
 * P3.1.B · Filtros del sub-tab Artefactos por tipo de relación.
 * Mapeo simple: tipo de relación canónica → categoría. Oculta los nodos del árbol
 * cuyas aristas no pertenezcan a la categoría seleccionada.
 */
function wireGrafoInteractions(panel) {
  const CATEGORIAS = {
    todas:        null,
    derivacion:   ['derivada_de', 'extraida_de'],
    recorte:      ['recortada_por'],
    interseccion: ['interseccion_con', 'buffer_de'],
    comparacion:  ['comparada_contra', 'descalificada_por_offset_vs'],
    referencia:   ['referenciada_por', 'respaldada_por', 'hipotesis_apoyada_en']
  };

  panel.querySelectorAll('[data-its-filtro]').forEach(btn => {
    btn.addEventListener('click', () => {
      const key = btn.getAttribute('data-its-filtro');
      const tipos = CATEGORIAS[key];
      panel.querySelectorAll('[data-its-filtro]').forEach(b => b.classList.toggle('active', b === btn));

      // Mostrar/ocultar nodos por tipo de via
      panel.querySelectorAll('[data-its-via]').forEach(node => {
        const via = node.getAttribute('data-its-via');
        if (!tipos) {
          node.style.display = ''; // 'todas'
        } else if (via && tipos.includes(via)) {
          node.style.display = '';
        } else {
          node.style.display = 'none';
        }
      });

      console.info('[ITS grafo] filtro aplicado:', key, tipos);
    });
  });

  // [HARDENING H-A2] Click en nodo del grafo principal usa data-its-grafo-nodo
  // (distinto de data-its-inspector-nav del drawer interno · sin doble listener)
  panel.querySelectorAll('[data-its-grafo-nodo]').forEach(node => {
    node.addEventListener('click', (e) => {
      const codigo = node.getAttribute('data-its-grafo-nodo');
      if (codigo) {
        e.preventDefault();
        e.stopPropagation();
        openInspector(codigo);
      }
    });
  });
}

/**
 * Conecta los toggles y botones del sub-tab Geometrías al módulo map-geometrias.
 * Idempotente: se llama después de cada re-render del sub-tab Geometrías.
 */
function wireGeometriasInteractions(panel) {
  // Sincronizar checkboxes con estado actual del mapa
  panel.querySelectorAll('[data-its-geom-toggle]').forEach(input => {
    const codigo = input.getAttribute('data-its-geom-toggle');
    input.checked = isGeometriaVisible(codigo);
    input.addEventListener('change', () => {
      const ok = toggleGeometria(codigo, input.checked);
      if (!ok) {
        // Si el mapa no estaba disponible, revertir
        input.checked = !input.checked;
        console.warn('[ITS] toggle geometria fallido para', codigo, '· mapa no disponible');
      }
    });
  });

  const btnShowAll = panel.querySelector('[data-its-geom-show-all]');
  if (btnShowAll) {
    btnShowAll.addEventListener('click', () => {
      listAvailableGeometrias().forEach(c => showGeometria(c));
      panel.querySelectorAll('[data-its-geom-toggle]').forEach(i => {
        i.checked = isGeometriaVisible(i.getAttribute('data-its-geom-toggle'));
      });
    });
  }
  const btnHideAll = panel.querySelector('[data-its-geom-hide-all]');
  if (btnHideAll) {
    btnHideAll.addEventListener('click', () => {
      hideAllGeometrias();
      panel.querySelectorAll('[data-its-geom-toggle]').forEach(i => { i.checked = false; });
    });
  }
  const btnFit = panel.querySelector('[data-its-geom-fit]');
  if (btnFit) {
    btnFit.addEventListener('click', () => {
      const ok = fitToVisibleGeometrias();
      if (!ok) console.info('[ITS] fit: no hay geometrias visibles · activá al menos una');
    });
  }
}

function renderViewUnidad(unidad) {
  const territorio = FIXTURE.territorios[unidad.territorio];
  const breadcrumb = renderBreadcrumbHTML(
    buildBreadcrumbParts({ territorio, unidad, currentLevel: 'unidad' })
  );
  const panel = $panel();
  if (!panel) return false;

  panel.innerHTML = `
    <div class="panel-header" data-its-view="unidad">
      ${breadcrumb}
      <div class="panel-type-row">
        <span class="panel-type">Unidad territorial</span>
        <span class="its-view-badge">vista unidad</span>
      </div>
      <div class="panel-title">${unidad.nombre}</div>
      <div class="panel-subtitle">${territorio ? territorio.nombre + ' · ' : ''}Roles SII ${unidad.roles_sii.join(' + ')}</div>
      <div class="its-view-toggle">
        <button class="its-view-toggle__btn" data-its-go-predio>Vista predio (Rol ${unidad.roles_sii[0]})</button>
      </div>
    </div>
    ${renderSubTabsHTML(unidad)}
    <div class="its-subtab-body">${pickSubTabContent(_activeSubTab, unidad)}</div>
  `;

  panel.querySelectorAll('.its-breadcrumb__link').forEach(a => {
    a.addEventListener('click', (e) => {
      e.preventDefault();
      const [type, id] = a.getAttribute('data-its-nav').split(':');
      navigateTo({ t: 'territorio', u: 'unidad', p: 'predio' }[type], id);
    });
  });
  panel.querySelectorAll('.its-subtab').forEach(btn => {
    btn.addEventListener('click', () => {
      const tabId = btn.getAttribute('data-its-tab');
      _activeSubTab = tabId;
      const body = panel.querySelector('.its-subtab-body');
      if (body) {
        body.innerHTML = pickSubTabContent(tabId, unidad);
        if (tabId === 'geometrias') wireGeometriasInteractions(panel);
      }
      panel.querySelectorAll('.its-subtab').forEach(b => b.classList.toggle('active', b === btn));
    });
  });

  // Wire inicial de Geometrías si es el sub-tab activo desde el inicio
  if (_activeSubTab === 'geometrias') wireGeometriasInteractions(panel);
  if (_activeSubTab === 'artefactos') wireGrafoInteractions(panel);
  panel.querySelectorAll('.its-link[data-its-tab]').forEach(a => {
    a.addEventListener('click', (e) => {
      e.preventDefault();
      const tabId = a.getAttribute('data-its-tab');
      const btn = panel.querySelector(`.its-subtab[data-its-tab="${tabId}"]`);
      if (btn) btn.click();
    });
  });
  const btnPredio = panel.querySelector('[data-its-go-predio]');
  if (btnPredio) {
    btnPredio.addEventListener('click', () => navigateTo('predio', unidad.roles_sii[0]));
  }
  if (panel.classList && !panel.classList.contains('open') && window.innerWidth <= 900) {
    panel.classList.add('open');
  }
  return true;
}

// -----------------------------------------------------------------------------
// NAVEGACIÓN
// -----------------------------------------------------------------------------

function navigateTo(type, id) {
  if (!type || !id) return;
  _currentSelection = { type, id };
  updateHashForSelection(_currentSelection);

  if (type === 'unidad') {
    const unidad = FIXTURE.unidades[id];
    if (!unidad) { console.warn('[ITS] navigateTo unidad: no encontrada:', id); return; }
    _activeSubTab = 'resumen';
    renderViewUnidad(unidad);
    console.info('[ITS] vista unidad activa · u=' + id);
    return;
  }
  if (type === 'territorio') {
    console.info('[ITS] navigateTo territorio · placeholder post-v0.3 · t=' + id);
    return;
  }
  if (type === 'predio') {
    if (_lastPredioFeature && _lastPredioFeature?.properties?.rol === id) {
      if (typeof window.selectPredio === 'function') window.selectPredio(_lastPredioFeature);
      return;
    }
    console.info('[ITS] navigateTo predio sin cache · p=' + id);
  }
}

// -----------------------------------------------------------------------------
// URL HASH
// -----------------------------------------------------------------------------

function updateHashForSelection(sel) {
  _currentSelection = sel || { type: null, id: null };
  const h = location.hash.slice(1);
  const parts = h ? h.split('&').filter(Boolean) : [];
  const filtered = parts.filter(p => !p.startsWith('p=') && !p.startsWith('u=') && !p.startsWith('t='));
  if (sel && sel.type === 'predio' && sel.id) filtered.push('p=' + encodeURIComponent(sel.id));
  if (sel && sel.type === 'unidad' && sel.id) filtered.push('u=' + encodeURIComponent(sel.id));
  if (sel && sel.type === 'territorio' && sel.id) filtered.push('t=' + encodeURIComponent(sel.id));
  history.replaceState(null, '', '#' + filtered.join('&'));
}

function wrapUpdateUrlHash() {
  if (typeof window.updateUrlHash !== 'function') {
    console.warn('[ITS] updateUrlHash no encontrada · skip wrapper');
    return;
  }
  _prevUpdateUrlHash = window.updateUrlHash;
  window.updateUrlHash = function() {
    _prevUpdateUrlHash.apply(this, arguments);
    if (_currentSelection.type && _currentSelection.id) updateHashForSelection(_currentSelection);
  };
}

// -----------------------------------------------------------------------------
// WRAPPER selectPredio
// -----------------------------------------------------------------------------

function wrapSelectPredio() {
  if (typeof window.selectPredio !== 'function') {
    console.warn('[ITS] window.selectPredio no encontrada · skip wrapper');
    return false;
  }
  _prevSelectPredio = window.selectPredio;
  window.selectPredio = function(feature) {
    _prevSelectPredio.apply(this, arguments);
    try {
      const rol = feature?.properties?.rol;
      _lastPredioFeature = feature;
      if (!rol) { removeChipUnidad(); removeBreadcrumb(); return; }
      const unitId = getUnitForPredio(rol);
      if (unitId) {
        renderChipUnidad(rol, unitId);
        const unidad = FIXTURE.unidades[unitId];
        const territorio = FIXTURE.territorios[unidad?.territorio];
        insertBreadcrumbInPanel(renderBreadcrumbHTML(
          buildBreadcrumbParts({ territorio, unidad, predio: rol, currentLevel: 'predio' })
        ));
        updateHashForSelection({ type: 'predio', id: rol });
      } else {
        removeChipUnidad();
        removeBreadcrumb();
        updateHashForSelection({ type: 'predio', id: rol });
      }
    } catch (err) {
      console.error('[ITS] hook selectPredio falló (v1 NO afectado):', err);
    }
  };
  return true;
}

// -----------------------------------------------------------------------------
// HASH INICIAL
// -----------------------------------------------------------------------------

function parseInitialHash() {
  const h = location.hash.slice(1);
  if (!h) return null;
  const params = Object.fromEntries(h.split('&').map(p => {
    const [k, v] = p.split('=');
    return [k, v ? decodeURIComponent(v) : ''];
  }));
  if (params.u) return { type: 'unidad', id: params.u };
  if (params.p) return { type: 'predio', id: params.p };
  if (params.t) return { type: 'territorio', id: params.t };
  return null;
}

function applyInitialHash() {
  const initial = parseInitialHash();
  if (!initial) return;
  if (initial.type === 'unidad') {
    if (window.map && typeof window.map.once === 'function') {
      window.map.once('idle', () => navigateTo('unidad', initial.id));
    } else {
      setTimeout(() => navigateTo('unidad', initial.id), 500);
    }
    console.info('[ITS] hash inicial u=' + initial.id);
  } else if (initial.type === 'predio') {
    console.info('[ITS] hash inicial p=' + initial.id);
    _currentSelection = initial;
  }
}

// -----------------------------------------------------------------------------
// INIT
// -----------------------------------------------------------------------------

export function init() {
  const wrappedSelect = wrapSelectPredio();
  wrapUpdateUrlHash();
  applyInitialHash();

  if (window.its) {
    window.its.fase = 4;
    window.its.active = true;
    window.its.navigateTo = navigateTo;
    window.its._rollback = function() {
      if (_prevSelectPredio) window.selectPredio = _prevSelectPredio;
      if (_prevUpdateUrlHash) window.updateUrlHash = _prevUpdateUrlHash;
      removeChipUnidad();
      removeBreadcrumb();
      window.its.active = false;
      window.its.fase = 1;
      console.info('[ITS] rollback runtime · v1 restaurado');
    };
  }

  console.info(
    '%c[ITS]%c panel-detail activo · fase=4 · selectPredio=' + wrappedSelect +
    ' · hash hook=' + (_prevUpdateUrlHash !== null),
    'background:#2e7d32; color:white; padding:2px 6px; border-radius:3px; font-weight:bold;',
    'color:#5a5a5a'
  );
  return { active: true, wrappedSelect, wrappedHash: _prevUpdateUrlHash !== null };
}

export const PANEL_DETAIL_VERSION = '0.3.4-fase4-recovered';
