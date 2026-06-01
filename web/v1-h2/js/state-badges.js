// =============================================================================
// Magnus Radar · ITS v0.3 · state-badges.js
// 2026-05-31 · Fase 1.1 (re-aplicado tras SANDBOX_OVERLAY_LOSS)
// Vocabulario universal de estados disciplinados
// SIN side-effects. Solo exports puros.
// =============================================================================

export const STATES = {
  verificado: {
    icon: '✓',
    label: 'verificado',
    cls: 'state--verified',
    tooltip: 'Verificado: respaldado por autoridad primaria (CBR / SII directo / título original / plano matriz)'
  },
  identificado: {
    icon: '◉',
    label: 'identificado',
    cls: 'state--identified',
    tooltip: 'Identificado: existe y se sabe cuál es; falta extracción completa'
  },
  localizado_pendiente_extraccion: {
    icon: '⏳',
    label: 'localizado',
    cls: 'state--pending',
    tooltip: 'Localizado pendiente extracción: se sabe dónde está y cómo conseguirlo, aún no se tiene'
  },
  parcialmente_verificado: {
    icon: '◐',
    label: 'parcial',
    cls: 'state--partial',
    tooltip: 'Parcialmente verificado: un elemento confirmado, otro pendiente'
  },
  hipotesis_de_trabajo: {
    icon: '◇',
    label: 'hipótesis',
    cls: 'state--hypothesis',
    tooltip: 'Hipótesis de trabajo: explicación útil, evidencia indirecta, no promovida a hecho'
  },
  conflicto_documentado: {
    icon: '⚠',
    label: 'conflicto',
    cls: 'state--conflict',
    tooltip: 'Conflicto documentado: divergencia entre fuentes registrada con autoridad resolutiva asignada'
  },
  superseded: {
    icon: '⊘',
    label: 'superseded',
    cls: 'state--superseded',
    tooltip: 'Superseded: superado por evidencia/versión posterior, conservado como referencia'
  },
  descalificado: {
    icon: '✗',
    label: 'descalificado',
    cls: 'state--disqualified',
    tooltip: 'Descalificado: descartado por evidencia contraria firme'
  }
};

export const STATE_ALIASES = {
  verified: 'verificado',
  pending: 'localizado_pendiente_extraccion',
  identified: 'identificado',
  partial: 'parcialmente_verificado',
  hypothesis: 'hipotesis_de_trabajo',
  conflict: 'conflicto_documentado'
};

export function badge(estado) {
  const key = STATE_ALIASES[estado] || estado;
  const s = STATES[key];
  if (!s) return `<span class="state state--unknown" title="estado desconocido: ${estado}">? ${estado}</span>`;
  return `<span class="state ${s.cls}" title="${s.tooltip}">${s.icon} ${s.label}</span>`;
}

export function getState(estado) {
  const key = STATE_ALIASES[estado] || estado;
  return STATES[key] || null;
}

export const STATE_BADGES_VERSION = '0.3.1-recovered';
