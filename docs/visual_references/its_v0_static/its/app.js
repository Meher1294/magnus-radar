// =============================================================================
// Magnus Radar · ITS v2 · App bootstrap + renderers
// 2026-05-31 · v0 estático con datos hardcoded
// Sin Supabase. Sin edición. Solo lectura.
// =============================================================================

import { HIJUELA_2 } from './data.js';

// -----------------------------------------------------------------------------
// Helpers
// -----------------------------------------------------------------------------
const $ = (sel, ctx = document) => ctx.querySelector(sel);
const $$ = (sel, ctx = document) => [...ctx.querySelectorAll(sel)];

const fmtHa = (n) => {
  if (n == null) return '?';
  return n.toLocaleString('es-CL', { minimumFractionDigits: 0, maximumFractionDigits: 2 });
};

const escape = (s) => String(s ?? '').replace(/[&<>"']/g, c => ({
  '&':'&amp;', '<':'&lt;', '>':'&gt;', '"':'&quot;', "'":'&#39;'
}[c]));

// -----------------------------------------------------------------------------
// Render: Identidad
// -----------------------------------------------------------------------------
function renderIdentity(u) {
  return `
    <section class="its-identity">
      <div>
        <h1 class="its-identity__title">${escape(u.nombre)}</h1>
        <div class="its-identity__sub">
          Roles SII ${u.roles_sii.join(' + ')} · Comuna ${escape(u.comuna)} · ${escape(u.region)}
        </div>
        <div class="its-identity__tertiary">
          Mandato vigente ${escape(u.mandato.mandataria)} · ${escape(u.mandato.repertorio)} ·
          ${u.mandato.plazo_meses} meses · ${u.mandato.comision_pct}%
        </div>
      </div>
      <div class="its-identity__status">
        <div class="its-identity__status-label">Estado</div>
        <div class="its-identity__status-value">${escape(u.estado)}</div>
        <div class="its-identity__status-meta">
          ${u.conflictos_abiertos_count} conflictos abiertos · actualizado ${escape(u.ultima_actualizacion)}
        </div>
      </div>
    </section>
  `;
}

// -----------------------------------------------------------------------------
// Render: Superficies (5 cards, una de ellas conflicto)
// -----------------------------------------------------------------------------
function renderSuperficies(superficies) {
  return `
    <section class="panel">
      <div class="panel__header">
        <div>
          <h2 class="panel__title">Superficies por capa</h2>
          <div class="panel__subtitle">
            No existe superficie única. Cada cifra pertenece a una capa con su autoridad.
          </div>
        </div>
        <div class="panel__meta">${superficies.length} capas</div>
      </div>
      <div class="superficies-grid">
        ${superficies.map(renderSuperficieCard).join('')}
      </div>
    </section>
  `;
}

function renderSuperficieCard(s) {
  if (s.estado === 'conflicto_documentado') {
    const valores = s.valores_observados
      .map(v => fmtHa(v.valor_ha))
      .join(' / ');
    return `
      <div class="superficie-card superficie-card--conflict" data-conflicto="${s.conflicto_id}">
        <div class="superficie-card__badge">conflicto</div>
        <div class="superficie-card__value">${valores}</div>
        <div class="superficie-card__unit">ha</div>
        <div class="superficie-card__source">${escape(s.capa)}</div>
        <div class="superficie-card__status">
          <span class="status status--conflict">pendiente ${escape(s.autoridad_resolutiva)}</span>
        </div>
      </div>
    `;
  }
  return `
    <div class="superficie-card" data-codigo="${s.codigo}">
      <div class="superficie-card__value">${fmtHa(s.valor_ha)}</div>
      <div class="superficie-card__unit">ha</div>
      <div class="superficie-card__badge">${escape(s.capa)}</div>
      <div class="superficie-card__source">${s.año} · ${escape(s.fuente_short)}</div>
      <div class="superficie-card__status">
        <span class="status status--verificado">${escape(s.estado)}</span>
      </div>
    </div>
  `;
}

// -----------------------------------------------------------------------------
// Render: Autoridades
// -----------------------------------------------------------------------------
const STATUS_MAP = {
  verificado: 'status--verificado',
  pending: 'status--pending',
  identified: 'status--identified',
  partial: 'status--partial',
  conflict: 'status--conflict',
  superseded: 'status--superseded'
};
const STATUS_LABEL = {
  verificado: 'verificado',
  pending: 'localizado',
  identified: 'identificado',
  partial: 'parcial',
  conflict: 'conflicto',
  superseded: 'superseded'
};

function renderAutoridades(autoridades) {
  return `
    <section class="panel">
      <div class="panel__header">
        <div>
          <h2 class="panel__title">Matriz de autoridad</h2>
          <div class="panel__subtitle">Quién manda en cada dominio · separa cabida de rol, geometría de avalúo</div>
        </div>
        <div class="panel__meta">${autoridades.length} dominios</div>
      </div>
      <table class="autoridades-table">
        <thead>
          <tr><th>Dominio</th><th>Autoridad</th><th>Estado</th><th>Capa</th></tr>
        </thead>
        <tbody>
          ${autoridades.map(a => `
            <tr>
              <td class="autoridades-table__dominio">${escape(a.dominio)}</td>
              <td class="autoridades-table__autoridad">${escape(a.autoridad)}</td>
              <td><span class="status ${STATUS_MAP[a.estado] || ''}">${STATUS_LABEL[a.estado] || a.estado}</span></td>
              <td class="mono">${a.capa ?? '—'}</td>
            </tr>
          `).join('')}
        </tbody>
      </table>
    </section>
  `;
}

// -----------------------------------------------------------------------------
// Render: Conflictos abiertos
// -----------------------------------------------------------------------------
function renderConflictos(conflictos) {
  return `
    <section class="panel">
      <div class="panel__header">
        <div>
          <h2 class="panel__title">Conflictos abiertos</h2>
          <div class="panel__subtitle">Divergencias documentadas con autoridad resolutiva asignada</div>
        </div>
        <div class="panel__meta">${conflictos.length} abiertos</div>
      </div>
      <div class="conflictos-list">
        ${conflictos.map(c => `
          <div class="conflicto-item conflicto-item--${c.severidad}">
            <div class="conflicto-item__head">
              <span class="conflicto-item__codigo">${escape(c.codigo)}</span>
              <span class="conflicto-item__desc">${escape(c.descripcion)}</span>
            </div>
            <div class="conflicto-item__meta">
              autoridad: <strong>${escape(c.autoridad_resolutiva)}</strong> · acción: ${escape(c.accion)}
            </div>
          </div>
        `).join('')}
      </div>
    </section>
  `;
}

// -----------------------------------------------------------------------------
// Render: Representaciones geométricas (4 cards)
// -----------------------------------------------------------------------------
function renderRepresentaciones(reps) {
  return `
    <section class="panel">
      <div class="panel__header">
        <div>
          <h2 class="panel__title">Representaciones geométricas</h2>
          <div class="panel__subtitle">${reps.length} concurrentes · ninguna sobrescribe a otra</div>
        </div>
      </div>
      <div class="representaciones-grid">
        ${reps.map(r => `
          <div class="rep-card rep-card--${r.estado}">
            <div class="rep-card__thumb">${escape(r.thumb_desc)}</div>
            <div class="rep-card__codigo">${escape(r.codigo)}</div>
            <div class="rep-card__fuente">${escape(r.fuente)}</div>
            <div class="rep-card__meta">${r.año} · ${escape(r.tipo)}</div>
            <span class="status ${STATUS_MAP[r.estado] || ''}">${STATUS_LABEL[r.estado] || r.estado}</span>
            <div class="rep-card__superficie">${r.superficie_ha ? fmtHa(r.superficie_ha) + ' ha' : '—'}</div>
            <div class="rep-card__meta">${escape(r.meta)}</div>
          </div>
        `).join('')}
      </div>
    </section>
  `;
}

// -----------------------------------------------------------------------------
// Render: Cadena registral (timeline horizontal + hipótesis separadas)
// -----------------------------------------------------------------------------
function renderCadena(eventos, hipotesis) {
  return `
    <section class="panel">
      <div class="panel__header">
        <div>
          <h2 class="panel__title">Cadena registral</h2>
          <div class="panel__subtitle">
            ${eventos.length} eventos verificados/localizados · ${hipotesis.length} hipótesis separadas (no son eslabones)
          </div>
        </div>
      </div>
      <div class="timeline">
        <div class="timeline__principal">
          ${eventos.map(e => `
            <div class="timeline-event timeline-event--${e.estado === 'pending' ? 'pending' : ''} ${e.importancia === 'big' ? 'timeline-event--big' : ''}"
                 title="${escape(e.desc)}">
              <div class="timeline-event__marker"></div>
              <div class="timeline-event__year">${e.año}</div>
              <div class="timeline-event__label">${escape(e.label)}</div>
            </div>
          `).join('')}
        </div>
        <div class="timeline__hipotesis">
          <div class="timeline__hipotesis-title">
            ◇ Hipótesis · no son eslabones verificados de la cadena
          </div>
          ${hipotesis.map(h => `
            <div class="hipotesis-item">
              <span class="hipotesis-item__code">${escape(h.codigo)}</span>
              <span>${escape(h.descripcion)}</span>
            </div>
          `).join('')}
        </div>
      </div>
    </section>
  `;
}

// -----------------------------------------------------------------------------
// Render: Mapa (placeholder estático para v0)
// -----------------------------------------------------------------------------
function renderMapa(reps) {
  return `
    <div class="its-map-wrapper">
      <div class="its-map">
        <div class="its-map__placeholder">
          🗺️<br>
          <strong>Mapa contextual</strong><br>
          <small>v0: placeholder · v0.1 conecta MapLibre</small>
        </div>
      </div>
      <div class="its-map__layers">
        <label class="its-map__layer"><input type="checkbox" checked> G4 RTK Daniel · verificada</label>
        <label class="its-map__layer"><input type="checkbox"> G1 plano matriz MBN · histórica</label>
        <label class="its-map__layer"><input type="checkbox"> G2 plano N°531/1992 · pendiente</label>
        <label class="its-map__layer its-map__layer--superseded">
          <input type="checkbox"> ⊘ G3 KMZ XPU · SUPERSEDED
        </label>
        <label class="its-map__layer"><input type="checkbox"> G5 plano N°377-2006 · ⏳ pendiente</label>
        <label class="its-map__layer"><input type="checkbox" checked> Tomas · contexto</label>
        <label class="its-map__layer"><input type="checkbox" checked> InterChile · gravamen</label>
        <label class="its-map__layer"><input type="checkbox"> Andes Iron · envolvente</label>
      </div>
      <div class="its-map__actions">
        <button>Pantalla completa</button>
        <button>Exportar PNG</button>
      </div>
    </div>
  `;
}

// -----------------------------------------------------------------------------
// Render: Titulares
// -----------------------------------------------------------------------------
function renderTitulares(titulares) {
  return `
    <section class="panel">
      <div class="panel__header">
        <div>
          <h2 class="panel__title">Titulares</h2>
          <div class="panel__subtitle">${titulares.length} partes · suma 100%</div>
        </div>
      </div>
      <div class="titulares-list">
        ${titulares.map(t => `
          <div class="titular-row">
            <div class="titular-row__name">${escape(t.nombre)}</div>
            <div class="titular-row__pct">${t.pct.toFixed(2)}%</div>
          </div>
        `).join('')}
      </div>
    </section>
  `;
}

// -----------------------------------------------------------------------------
// Render: Contexto envolvente
// -----------------------------------------------------------------------------
function renderContexto(ctx) {
  return `
    <div class="context-block">
      <strong>Contexto envolvente:</strong> ${escape(ctx.territorio_matriz)}
      (Rol ${escape(ctx.rol_matriz)}) · ${fmtHa(ctx.superficie_aprox_ha)} ha ·
      <strong>${escape(ctx.titular_matriz)}</strong> RUT ${escape(ctx.rut_matriz)} ·
      adq. ${escape(ctx.fecha_adquisicion)} · UF ${fmtHa(ctx.precio_uf)}.<br>
      <em>${escape(ctx.nota)}</em>
    </div>
  `;
}

// -----------------------------------------------------------------------------
// Bootstrap
// -----------------------------------------------------------------------------
function mount() {
  const D = HIJUELA_2;

  $('#its-app').innerHTML = `
    ${renderIdentity(D.unidad)}
    <div class="its-main">
      <div class="its-col-main">
        ${renderSuperficies(D.superficies)}
        ${renderAutoridades(D.autoridades)}
        ${renderConflictos(D.conflictos)}
        ${renderRepresentaciones(D.representaciones)}
        ${renderCadena(D.cadena_registral, D.hipotesis)}
        ${renderContexto(D.contexto_envolvente)}
      </div>
      <div class="its-col-side">
        ${renderMapa(D.representaciones)}
        ${renderTitulares(D.titulares)}
      </div>
    </div>
  `;

  // Interacciones mínimas v0
  $$('.superficie-card, .conflicto-item, .rep-card, .timeline-event, .hipotesis-item').forEach(el => {
    el.addEventListener('click', (e) => {
      console.log('[ITS v0] click ->', el.dataset, el.querySelector('.conflicto-item__codigo, .rep-card__codigo, .hipotesis-item__code, .superficie-card__badge')?.textContent);
    });
  });

  console.log('[ITS v0] Hijuela 2 mounted ·', D.superficies.length, 'superficies ·',
    D.autoridades.length, 'autoridades ·',
    D.conflictos.length, 'conflictos abiertos ·',
    D.representaciones.length, 'representaciones ·',
    D.cadena_registral.length, 'eventos cadena ·',
    D.hipotesis.length, 'hipótesis');
}

document.addEventListener('DOMContentLoaded', mount);
