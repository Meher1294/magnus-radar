// =============================================================================
// Magnus Radar · ITS v0.3 · its-bootstrap.js
// 2026-05-31 · Fase 1.3 (re-aplicado tras SANDBOX_OVERLAY_LOSS)
// Bootstrap NO INVASIVO. Importa módulos y los expone en window.its
// Importa panel-detail e inicia después de DOMContentLoaded
// =============================================================================

import { STATES, STATE_ALIASES, badge, getState, STATE_BADGES_VERSION } from './state-badges.js';
import { FIXTURE, getEntity, getUnitForPredio, listUnidades, ITS_DATA_VERSION } from './its-data.js';
import { init as initPanelDetail, PANEL_DETAIL_VERSION } from './panel-detail.js';

// Exposición global controlada (namespace único, NO frozen porque Fases 2+ mutan fase/active)
window.its = {
  version: '0.3.4-skeleton-fase4-recovered',
  states: STATES,
  stateAliases: STATE_ALIASES,
  badge,
  getState,
  fixture: FIXTURE,
  getEntity,
  getUnitForPredio,
  listUnidades,
  versions: {
    bootstrap: '0.3.4-recovered',
    stateBadges: STATE_BADGES_VERSION,
    itsData: ITS_DATA_VERSION,
    panelDetail: PANEL_DETAIL_VERSION
  },
  fase: 1,
  active: false
};

function startPanelDetail() {
  try {
    initPanelDetail();
  } catch (err) {
    console.error('[ITS] init panel-detail falló (v1 NO afectado):', err);
  }
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => setTimeout(startPanelDetail, 0));
} else {
  setTimeout(startPanelDetail, 0);
}

console.info(
  '%c[ITS]%c v' + window.its.version + ' bootstrap cargado · ' +
  Object.keys(FIXTURE.unidades).length + ' unidad(es) · ' +
  Object.keys(STATES).length + ' estados',
  'background:#1976d2; color:white; padding:2px 6px; border-radius:3px; font-weight:bold;',
  'color:#5a5a5a'
);
