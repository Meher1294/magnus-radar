// =============================================================================
// Magnus Radar · ITS v0.3 · map-geometrias.js
// 2026-05-31 · Fase 7A (geometrías reales · no sintéticas)
//
// G3 y G4: coordenadas REALES extraídas del filesystem:
//   - G3: doc.kml dentro de DataRoom_Cominetti_LaHiguera.kmz · placemark
//         "Polígono Hijuela 2 Cominetti" · 26 vértices · WGS84 directo.
//   - G4: PERIMETRO_CBR_DANIEL_RTK10M_V1_UTM19S_FIX.gpkg · MultiPolygon
//         de 3 polígonos (77 vértices totales) · reproyectado de
//         EPSG:32719 (UTM 19S) a EPSG:4326 (WGS84 lat/lon).
//
// G1 y G2: NO disponibles operacionalmente. Toggle informa la razón.
//   - G1 (Plano MBN 1990): solo fotos HEIC · georreferenciación pendiente.
//   - G2 (Plano N°531/1992): no extraído del CBR todavía.
//
// Hallazgos calculados (Fase 7A):
//   - G3 área calculada 1.671,26 ha vs etiqueta KMZ "2.640 ha" → delta -36,7%
//     (la etiqueta del KMZ era inconsistente con su propio polígono · nuevo
//     conflicto a registrar: KMZ_LABEL_VS_POLY_MISMATCH)
//   - G4 área calculada 2.156,70 ha vs declarada 2.164,97 ha → delta -0,38%
//     (margen aceptable de tolerancia de cálculo Shoelace en proyección
//     equirectangular sobre WGS84)
// =============================================================================

// -----------------------------------------------------------------------------
// Definiciones REALES de geometrías
// -----------------------------------------------------------------------------

const GEOM_DEFINITIONS = {
  G1: {
    label: 'G1 plano matriz MBN 1990',
    color: '#ed6c02',
    available: false,
    unavailable_reason: 'Solo fotos HEIC del cuerpo cartográfico (10 imágenes en 01_LEGAL_TITULOS/Plano_MBN_IV-1-1777-SR/). Georreferenciación pendiente Fase 12 según CANON.',
    superficie_declarada_ha: 2642,
    coords: null
  },
  G2: {
    label: 'G2 plano subdivisión N°531/1992',
    color: '#1976d2',
    available: false,
    unavailable_reason: 'Plano no extraído del CBR La Serena todavía. Búsqueda registral pendiente. GAP_PLANO_531_1992.',
    superficie_declarada_ha: 1163,
    coords: null
  },
  G3: {
    label: 'G3 KMZ DataRoom 2026-04 (superseded)',
    color: '#757575',
    available: true,
    geom_type: 'Polygon',
    opacity_fill: 0.15,
    opacity_line: 0.65,
    line_width: 1.8,
    line_dash: [2, 3],
    superficie_declarada_ha_etiqueta_kmz: 2640,
    superficie_calculada_ha: 1671.26,
    // [HARDENING H-B1 · 2026-05-31] Removidos `delta_pct: -36.7` y
    // `vertices_count: 26`. Ambos eran derivables del propio objeto
    // y violaban PRINCIPIO #2 (fuente única) como deuda silenciosa.
    // Ahora se calculan en `_toGeoJSON` vía `deltaPct(g)` y `vertexCount(g)`.
    datum: 'WGS84 (EPSG:4326)',
    nota: 'Etiqueta KMZ dice "2.640 ha" pero polígono cubre 1.671 ha (delta -36,7%). Conflicto: KMZ_LABEL_VS_POLY_MISMATCH.',
    coords: [[[-71.26968257657299, -29.488007399379], [-71.24842611215009, -29.493452832833253], [-71.22712548291443, -29.49880755921335], [-71.22453396102661, -29.499408767268235], [-71.20753476106525, -29.503150323150535], [-71.20795102278733, -29.503733306603568], [-71.20512496901868, -29.504243026349755], [-71.20468838902231, -29.506159028818644], [-71.20485931332696, -29.507771665775454], [-71.20444875332677, -29.513037519260017], [-71.2035147439729, -29.511303478765374], [-71.2146900714274, -29.511143443256895], [-71.14233176295338, -29.524971120595865], [-71.1920716995361, -29.534045038051683], [-71.20198326530931, -29.530881907183804], [-71.19678927857751, -29.514833903022364], [-71.19607152524708, -29.512536362001853], [-71.19783250989525, -29.51241385951235], [-71.19918461042455, -29.513738517860368], [-71.2303323048619, -29.507473215249387], [-71.25318490311298, -29.506162393441134], [-71.24090062165266, -29.521799490854697], [-71.23795411801605, -29.522171688463775], [-71.23645709835577, -29.52341860016646], [-71.26531112495535, -29.516888748496147], [-71.26968257657299, -29.488007399379]]]
  },
  G4: {
    label: 'G4 RTK Daniel 2026-05 (verificado)',
    color: '#2e7d32',
    available: true,
    geom_type: 'MultiPolygon',
    opacity_fill: 0.22,
    opacity_line: 1.0,
    line_width: 2.4,
    line_dash: null,
    // [HARDENING H-B1 · 2026-05-31] Removidos `polygons_count: 3`,
    // `vertices_total: 77` y `delta_pct: -0.38`. Derivables del propio
    // objeto (coords + superficie_calculada vs declarada) · PRINCIPIO #2.
    // Ahora se calculan en `_toGeoJSON` vía helpers puros.
    superficie_declarada_ha: 2164.97,
    superficie_calculada_ha: 2156.70,
    datum_origen: 'WGS84 UTM 19S (EPSG:32719)',
    datum_actual: 'WGS84 lon/lat (EPSG:4326)',
    metadata_gpkg: {
      id_canonico: 'GEO-PERIMETRO-CBR-DANIEL-V1',
      source_truth: 'fuente_primaria_CBR',
      vigencia: 'vigente',
      naturaleza_geo: 'fisico_legal',
      fuente_geometria: 'RTK_10m_Daniel_Martinez_Zurita',
      precision_metros: 10,
      nivel_confianza_operacional: 'alta'
    },
    coords: [[[[-71.24844534840283, -29.493201072955593], [-71.25316292995602, -29.502411068536787], [-71.23101592725173, -29.507182556929056], [-71.2342497624494, -29.52297721076292], [-71.23677626602843, -29.522598007648536], [-71.24121015683941, -29.52158116377151], [-71.26525382790958, -29.516750765974397], [-71.26504864763702, -29.51596485831045], [-71.26640462947101, -29.514253767775546], [-71.26818056315231, -29.51279607813116], [-71.26834257947858, -29.51266309144657], [-71.2706047579817, -29.51092717113291], [-71.27273650491149, -29.509177721910348], [-71.27495893271592, -29.507414708118187], [-71.27503313686027, -29.50741474632381], [-71.27657558959415, -29.50584346739514], [-71.27769880886905, -29.50412296210627], [-71.27838035862878, -29.5023892894123], [-71.27884116372172, -29.500642421479718], [-71.27847405251478, -29.498881952362357], [-71.2772789681424, -29.49703651028432], [-71.27545603412021, -29.4952479231477], [-71.27425007892138, -29.494528430394784], [-71.27331098506545, -29.49409556753735], [-71.27214953674776, -29.493589511800067], [-71.27124397576384, -29.492764692320318], [-71.27041116508411, -29.49211313249855], [-71.26960777139813, -29.49122440799972], [-71.26923558351287, -29.4903777045683], [-71.26908483079077, -29.489336399764305], [-71.2697227078646, -29.487952968835636], [-71.24844534840283, -29.493201072955593]]], [[[-71.22650146852426, -29.498234654389933], [-71.22598295495465, -29.49835351688373], [-71.22304556073199, -29.498969570454737], [-71.2074415459021, -29.502877450298534], [-71.20797637291345, -29.5035011968709], [-71.20511774504668, -29.50404353015097], [-71.20468367925082, -29.506025067338243], [-71.20481743373072, -29.50768055983698], [-71.20350012223516, -29.511179929255285], [-71.19918140948846, -29.51360046800442], [-71.19761205690135, -29.511386334832977], [-71.19634116537743, -29.51161309397506], [-71.19558745721999, -29.511789334757086], [-71.14273336434114, -29.524807955154827], [-71.1430647310965, -29.525770834153597], [-71.14317825385376, -29.528107112870224], [-71.14405701445507, -29.529898768629675], [-71.14564789277243, -29.53188684313491], [-71.1480604035454, -29.532826261558544], [-71.15150722748508, -29.5337640397747], [-71.1530394825947, -29.534076556593742], [-71.15607530597678, -29.534391591512158], [-71.1594269399127, -29.534295106032218], [-71.16276072591411, -29.53192082879912], [-71.16287712673162, -29.531921048957376], [-71.1673856434976, -29.531304539161084], [-71.17110192785904, -29.530998248177795], [-71.17471700895172, -29.53100469779829], [-71.17822105117295, -29.53121956348253], [-71.17857073045037, -29.531220165894073], [-71.18115268137275, -29.532057759498265], [-71.18268592099137, -29.533201264245857], [-71.18528554189926, -29.53679995147805], [-71.19215617646208, -29.534128170677548], [-71.20200460047911, -29.53072771865174], [-71.19673919997946, -29.514727914450734], [-71.21465455358523, -29.511077565693036], [-71.23101531709882, -29.507188949772146], [-71.2259850672573, -29.498354675197483], [-71.22650146852426, -29.498234654389933]]], [[[-71.24844534840283, -29.493201072955593], [-71.24841392996105, -29.49313972900789], [-71.22650146852426, -29.498234654389933], [-71.24837812649271, -29.49321764721341], [-71.24844534840283, -29.493201072955593]]]]
  }
};

// Estado: códigos visibles actualmente
const _visibles = new Set();

// -----------------------------------------------------------------------------
// Helpers
// -----------------------------------------------------------------------------

function _getMap() { return typeof window !== 'undefined' ? window.map : null; }
function _sourceId(c) { return 'its-geom-' + c.toLowerCase(); }
function _fillId(c)   { return 'its-geom-' + c.toLowerCase() + '-fill'; }
function _lineId(c)   { return 'its-geom-' + c.toLowerCase() + '-line'; }

// [HARDENING H-B1 · 2026-05-31] Helpers puros · una fuente de verdad por métrica
// derivable de coords / superficies (PRINCIPIO #2). Reemplazan los campos
// `vertices_count`, `polygons_count`, `vertices_total`, `delta_pct` que estaban
// persistidos en GEOM_DEFINITIONS en paralelo a sus fuentes.

function vertexCount(g) {
  if (!g || !g.coords) return 0;
  // MultiPolygon: coords = [ [ [ring], [hole], ... ], ... ] · suma vértices de todos los rings
  if (g.geom_type === 'MultiPolygon') {
    return g.coords.reduce(
      (sum, poly) => sum + poly.reduce((s, ring) => s + ring.length, 0),
      0
    );
  }
  // Polygon: coords = [ [ring], [hole], ... ]
  return g.coords.reduce((sum, ring) => sum + ring.length, 0);
}

function polygonCount(g) {
  if (!g || !g.coords) return 0;
  return g.geom_type === 'MultiPolygon' ? g.coords.length : 1;
}

function deltaPct(g) {
  if (!g) return null;
  const calc = g.superficie_calculada_ha;
  const decl = g.superficie_declarada_ha ?? g.superficie_declarada_ha_etiqueta_kmz;
  if (typeof calc !== 'number' || typeof decl !== 'number' || decl === 0) return null;
  // 2 decimales fijos · convención uniforme (G3 y G4 ahora reportan misma precisión)
  return parseFloat((((calc - decl) / decl) * 100).toFixed(2));
}

function _toGeoJSON(codigo) {
  const g = GEOM_DEFINITIONS[codigo];
  if (!g || !g.coords) return null;
  return {
    type: 'Feature',
    properties: {
      codigo,
      label: g.label,
      superficie_declarada_ha: g.superficie_declarada_ha ?? g.superficie_declarada_ha_etiqueta_kmz,
      superficie_calculada_ha: g.superficie_calculada_ha,
      // [HARDENING H-B1] Derivados en render desde coords/superficies · cero persistencia paralela
      delta_pct: deltaPct(g),
      vertices: vertexCount(g),
      polygons: polygonCount(g)
    },
    geometry: { type: g.geom_type || 'Polygon', coordinates: g.coords }
  };
}

// -----------------------------------------------------------------------------
// API pública
// -----------------------------------------------------------------------------

/**
 * Muestra una geometría sobre el mapa real.
 * @returns {object} { shown: bool, reason?: string }
 */
export function showGeometria(codigo) {
  const g = GEOM_DEFINITIONS[codigo];
  if (!g) {
    console.warn('[ITS map] codigo desconocido:', codigo);
    return { shown: false, reason: 'codigo desconocido' };
  }
  if (!g.available) {
    console.info('[ITS map] ' + codigo + ' sin geometría operacional · ' + g.unavailable_reason);
    return { shown: false, reason: g.unavailable_reason };
  }
  const map = _getMap();
  if (!map) {
    console.warn('[ITS map] window.map no disponible');
    return { shown: false, reason: 'mapa no disponible' };
  }
  const srcId = _sourceId(codigo);
  const fillId = _fillId(codigo);
  const lineId = _lineId(codigo);

  if (!map.getSource(srcId)) {
    map.addSource(srcId, { type: 'geojson', data: _toGeoJSON(codigo) });
  }
  if (!map.getLayer(fillId)) {
    map.addLayer({
      id: fillId, type: 'fill', source: srcId,
      paint: { 'fill-color': g.color, 'fill-opacity': g.opacity_fill }
    });
  }
  if (!map.getLayer(lineId)) {
    const paint = {
      'line-color': g.color,
      'line-opacity': g.opacity_line,
      'line-width': g.line_width
    };
    if (g.line_dash) paint['line-dasharray'] = g.line_dash;
    map.addLayer({ id: lineId, type: 'line', source: srcId, paint });
  }
  _visibles.add(codigo);
  console.info('[ITS map] visible:', codigo, '·', g.label);
  return { shown: true };
}

export function hideGeometria(codigo) {
  const map = _getMap();
  if (!map) return false;
  const fillId = _fillId(codigo);
  const lineId = _lineId(codigo);
  const srcId = _sourceId(codigo);
  if (map.getLayer(lineId)) map.removeLayer(lineId);
  if (map.getLayer(fillId)) map.removeLayer(fillId);
  if (map.getSource(srcId)) map.removeSource(srcId);
  _visibles.delete(codigo);
  console.info('[ITS map] oculto:', codigo);
  return true;
}

export function toggleGeometria(codigo, force) {
  const g = GEOM_DEFINITIONS[codigo];
  if (!g) return { shown: false, reason: 'codigo desconocido' };
  if (!g.available) return { shown: false, reason: g.unavailable_reason };
  const shouldShow = force !== undefined ? force : !_visibles.has(codigo);
  return shouldShow ? showGeometria(codigo) : (hideGeometria(codigo), { shown: false });
}

export function isGeometriaVisible(codigo) { return _visibles.has(codigo); }

export function isGeometriaAvailable(codigo) {
  const g = GEOM_DEFINITIONS[codigo];
  return !!(g && g.available);
}

export function getGeometriaInfo(codigo) {
  const g = GEOM_DEFINITIONS[codigo];
  if (!g) return null;
  // Devolver shallow clone sin coords (puede ser grande)
  const { coords, ...info } = g;
  return info;
}

export function listAvailableGeometrias() {
  return Object.keys(GEOM_DEFINITIONS).filter(c => GEOM_DEFINITIONS[c].available);
}

export function listAllGeometrias() {
  return Object.keys(GEOM_DEFINITIONS);
}

/**
 * Encuadra el mapa a las geometrías visibles. Solo procesa available + visibles.
 */
export function fitToVisibleGeometrias() {
  const map = _getMap();
  if (!map || _visibles.size === 0) return false;
  let minLng = Infinity, maxLng = -Infinity, minLat = Infinity, maxLat = -Infinity;
  for (const codigo of _visibles) {
    const g = GEOM_DEFINITIONS[codigo];
    if (!g || !g.coords) continue;
    // Soportar Polygon y MultiPolygon
    const polys = g.geom_type === 'MultiPolygon' ? g.coords : [g.coords];
    polys.forEach(poly => poly.forEach(ring => ring.forEach(([lng, lat]) => {
      if (lng < minLng) minLng = lng;
      if (lng > maxLng) maxLng = lng;
      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
    })));
  }
  if (minLng === Infinity) return false;
  map.fitBounds([[minLng, minLat], [maxLng, maxLat]], { padding: 60, duration: 800 });
  return true;
}

export function hideAllGeometrias() {
  Array.from(_visibles).forEach(c => hideGeometria(c));
}

// [HARDENING H-B1] Exports puros expuestos por completitud (uso interno o test).
// Si en el futuro algún consumer necesita estos valores fuera del GeoJSON,
// debe importar y llamar la función, NO releer un campo persistido.
export { vertexCount, polygonCount, deltaPct };

export const MAP_GEOMETRIAS_VERSION = '0.3.7A-real-geoms-h02';
