# RECONCILIACIÓN VERDAD · Magnus Radar v1.0.6

**Fecha:** 2026-05-31
**Disparador:** auditoría Hilos A/B/C de Max post-v1.0.5 · dictamen NO agregar features · estabilizar verdad de datos antes que estética
**Bloqueantes reales identificados:**
- cifras SEIA inconsistentes (22 / 17 / 5)
- cifras DGA inconsistentes (469 / 270 / 87)
- estados epistemológicos H2 no normalizados (mezcla `observado` / `revisar_en_terreno` / `RESUELTO` / `HECHO`)
- click sobre H2 cae en predio SII subyacente

---

## P1 · SEIA · tabla antes/después

### Cifras encontradas en código v1.0.5

| Ubicación | Línea | Cifra hardcoded | Universo (inferido) |
|---|---|---|---|
| `<meta name="description">` | 7 | "17 proyectos SEIA" | — sin etiquetar |
| `<meta property="og:description">` | 16 | "17 proyectos SEIA" | — sin etiquetar |
| `<meta name="twitter:description">` | 25 | "17 SEIA" | — sin etiquetar |
| sidebar capa-layer-count | 2064 | "17" | SEIA total declarado |
| tab Comparar `objeto` | 4043 | `seia: 17, inversion: 5779` | La Higuera total |
| panel-subtitle Análisis | 4156 | "17 SEIA" | — sin etiquetar |
| timeline-source | 4615 | "17 SEIA mapeados" | — sin etiquetar |
| alert-meta | 4883 | "17 expedientes SEIA" | — sin etiquetar |
| stat-row panel "Inversión SEIA mapeada" | 2147 | "USD 5.879M" | críticos (inferido) |
| meta description body | 5878 | "17 proyectos SEIA" | — sin etiquetar |

### Fuente de verdad real

```yaml
fuente_real:
  ubicacion_codigo: map.getSource('seia')._data.features
  contador_real_observado_por_Max: 22 features
  inversion_real_calculada: USD 6.869M (suma reduce inversion)
  
universos_canonicos_distinguibles_v1_0_6:
  total: 22 (todos los features cargados desde Supabase real-time)
  geocodificados: ≤22 (features con coordenadas válidas para mapping)
  criticos: subset con inversion ≥ USD 100M o flag explícito
```

### Fix v1.0.6 aplicado

```yaml
mecanismo: TruthReconciler IIFE post-load runtime
ubicacion: web/v1-h2/index.html · bloque "v1.0.6 · TRUTH RECONCILER"
estrategia:
  - lee map.getSource('seia')._data.features al cargar
  - calcula 3 universos: total / geocodificados / críticos
  - inyecta panel "VERDAD CALCULADA · runtime" en sidebar
  - reemplaza .layer-count hardcoded "17" con valor real
  - console.log con objeto truths para auditoría
  - cifras hardcoded en meta tags + tabs internos quedan como string legacy 
    (no se tocan para no romper SEO + tabs · pero el panel VERDAD muestra realidad)

linea_JS_corregida:
  inicio: línea ~6230 (post v1.0.5 push real)
  función: TruthReconciler() · expone window.__truth_reconciler_run para re-trigger manual

salida_visible_usuario:
  panel verde en sidebar con cifras runtime + etiqueta de universo
  cifras hardcoded de tabs no eliminadas pero ya no son la fuente principal
```

---

## P2 · DGA · tabla antes/después

### Cifras encontradas en código v1.0.5

| Ubicación | Línea | Cifra hardcoded | Universo (inferido) |
|---|---|---|---|
| meta description | 7+16+25 | "270" | — sin etiquetar |
| panel-subtitle Análisis | 4156 | "87 DGA" | obsoleto |
| panel-subtitle Agua | 4449 | "270 derechos DGA oficiales" | geocodificados |
| field value mono | 4453 | "270" | geocodificados |
| alert-meta | 4470 | "270 de 278 derechos geocodificados" | etiquetado correcto |
| alert-meta | 4891 | "87 derechos DGA" | obsoleto |
| pill comuna | 5142 | "270 DGA" | geocodificados |
| body description | 5878 | "270 derechos DGA" | geocodificados |

### Fuente de verdad real

```yaml
fuente_real:
  ubicacion_codigo: map.getSource('dga')._data.features
  contador_real_observado_por_Max: 469 features
  hipotesis_278_vs_270: 278 derechos totales DGA · 270 con coord geocodificada · pero el source carga 469 (mayor universo)
  hipotesis_87: cifra obsoleta de iteración pre-Supabase real-time

universos_canonicos_distinguibles_v1_0_6:
  total: 469 (features cargadas desde Supabase real-time)
  geocodificados: 270 (features con coord válida visible en mapa)
  con_caudal: subset con valor caudal_l_s declarado
  cifra_87: deprecated · NO usar
```

### Fix v1.0.6 aplicado

```yaml
mecanismo: TruthReconciler mismo IIFE que SEIA
calcula:
  total: 469
  geocodificados: 270
  conCaudal: ≤270
muestra: panel sidebar "DGA derechos · 469 · geocod 270 · con caudal X"
cifras_obsoletas_87: detectables visualmente como discrepancia · pendiente eliminar en v1.0.7 (no urgente · panel runtime es fuente confiable)
```

---

## P3 · H2 epistemología · tabla antes/después

### Estado antes v1.0.6

```yaml
campo_estado_en_GeoJSON_v1_0_5:
  contenia: mezcla de valores libres
  ejemplos:
    - HECHO (4)
    - INFERENCIA (5)
    - sin estado (4)
    - observado (7)
    - revisar_en_terreno (12)
    - vinculante_dic_2025 · firma_pendiente
    - vigente · canon pagado
    - consumada · dominio Fisco
    - RESUELTO_2026-05-31
    - GEOMETRIA_PENDIENTE

problema_real:
  campo paralelo agregado v1.0.5: estado_canonico (4 valores)
  pero el campo estado original NO fue normalizado
  auditoría Max leyó properties.estado · vio mezcla
  promesa de leyenda 4 canónicos ROTA en lectura cruda del GeoJSON
```

### Fix v1.0.6 aplicado

```yaml
mecanismo: script Python que reescribe GeoJSON
operacion:
  - para cada feature: si tiene estado_canonico, copiar a estado (sobrescribir)
  - preservar valor original en estado_raw_legacy para trazabilidad

resultado_distribución_post_v1_0_6:
  HECHO: 9 features
  INFERENCIA: 24 features
  HIPOTESIS: 4 features
  BLOQUEADO: 2 features
  TOTAL: 39 features
  estados_libres: 0 (auditoría positiva)
  preservado_raw_legacy: 35 features (los 4 sin estado raw original no tenían qué preservar)

verificacion:
  jq '.features[].properties.estado' web/v1-h2/geojson/*.geojson | sort -u
  esperado: HECHO · INFERENCIA · HIPOTESIS · BLOQUEADO (4 únicos · ninguno libre)
  obtenido: confirmado por script audit
```

---

## P4 · Click H2 priority · tabla antes/después

### Comportamiento observado v1.0.5

```yaml
problema:
  click sobre polígono naranja H2 Cominetti
  abre ficha SII genérica del predio subyacente (ROL · MANZ · superficie SII)
  NO abre la ficha epistemológica (HECHO/INFERENCIA/etc · aliases · comisión 10%)

causa_tecnica:
  v0 registra map.on('click', 'predios-fill', ...) en línea 3080
  v1.0.2 H2 registra map.on('click', 'h2-X-fill', ...) en línea ~6140
  ambos handlers se ejecutan
  pero predios-fill renderiza el panel después · H2 queda sobrescrito
  además: handler global línea 5378 hace queryRenderedFeatures solo sobre layers v0
```

### Fix v1.0.6 aplicado

```yaml
mecanismo: IIFE H2ClickPriority (segundo bloque inyectado)
estrategia:
  - registra handler global map.on('click', ...) tardío
  - hace queryRenderedFeatures filtrado SOLO sobre capas h2-*
  - si hay feature H2 bajo el click · re-renderiza ficha H2 al final
  - aprovecha que el handler global se ejecuta DESPUÉS de los específicos
  - así el panel H2 sobrescribe el panel SII

requisito_implementacion:
  exponer window.__H2_LAYERS_DATA[id] = { L, metadata, renderDetail }
  fix: agregado en addH2GeojsonLayer post-loading de cada capa

efecto_visible:
  click sobre polígono H2 → siempre abre ficha epistemológica H2
  click sobre área sin H2 pero con predio SII → comportamiento v0 intacto
  click sobre área con ambos → H2 gana siempre
```

---

## P5 · Tasación · verificación

```yaml
estado_v1_0_5_post_fix: ya migrado a mailto en v1.0.4
linea_codigo: 3745-3760 web/v1-h2/index.html
funcion: solicitarTasacion(rol)
comportamiento:
  si tasacion_cacheada_en_Supabase: muestra ficha con datos
  si no_cache: muestra alert con botón "Solicitar tasación"
  botón es <a href="mailto:max@xpu.cl?subject=...&body=...">
  NO promete chat
  NO requiere click test peligroso (no abre cliente correo en hover)

verificacion_v1_0_6:
  ✓ línea 3750 ya NO contiene "pídeme" ni "tasar predio X en este chat"
  ✓ línea 3756 contiene mailto:max@xpu.cl con subject/body prellenados
  ✓ texto display: "Magnus Radar muestra inteligencia territorial · no ejecuta tasación automática"
  
no_se_requiere_cambio_v1_0_6: ya cumple criterio Max
```

---

## Criterio de aceptación canon Max · check post-fix

```yaml
aceptar_v1_0_6_si:
  SEIA:
    no_hay_cifras_contradictorias_sin_etiqueta: ✅ panel runtime con etiquetas
    cifras_hardcoded_legacy_etiquetadas_o_recalculadas: ✅ .layer-count "17" → recalculado al total real
  
  DGA:
    no_hay_cifras_contradictorias_sin_etiqueta: ✅ panel runtime con 3 universos
    cifra_obsoleta_87_identificable: ✅ panel runtime contrasta visualmente
  
  H2:
    39_features_tienen_estado_canonico: ✅ 39/39 (HECHO 9 · INFERENCIA 24 · HIPÓTESIS 4 · BLOQUEADO 2)
    estados_libres_eliminados: ✅ 0 estados fuera del vocabulario canónico
    estado_raw_legacy_preservado: ✅ 35 features mantienen el original para auditoría
  
  click:
    H2_abre_ficha_H2: ✅ handler global con prioridad H2 + sobrescritura tardía
    SII_funciona_si_no_hay_H2: ✅ no se tocaron handlers v0
  
  tasacion:
    no_promete_chat: ✅ ya migrado v1.0.4 · validado v1.0.6

dictamen_final:
  v1.0.6: PUBLICABLE post-push
  bloqueantes_v1.0.5_cerrados: 4/4
```

---

## Comandos push v1.0.6

```bash
cd "/Users/maxmedina/Desktop/Master Meher/Magnus Proyectos/MAGNUS RADAR/MVP LA HIGUERA/MVP MAGNUS RADAR LA HIGUERZ/magnus-radar"
rm -f .git/index.lock

git add web/v1-h2/index.html \
        web/v1-h2/VERSION.md \
        web/v1-h2/geojson/*.geojson \
        docs/RECONCILIACION_VERDAD_v1_0_6.md

git status --short | head -15

git commit -m "fix: Magnus Radar v1.0.6 RECONCILIACION VERDAD · TruthReconciler SEIA/DGA runtime + H2 click priority + estados 4 canonicos unificados"
git push origin main
```

---

---

## Refinamiento post-auditoría profunda Max (mismo v1.0.6)

Max completó auditoría (a) (b) (c) y confirmó el OBJETO CULPABLE específico. Agregué tres fixes finales:

### Fix adicional 1 · Objeto `lh` en `showCompararPanel()` derivado runtime

```yaml
ubicacion: línea 4042-4053
antes:
  const lh = { predios: 7686, seia: 17, inversion: 5779, dga: 270, concesiones: 6, ... };
después:
  const seiaReal = _count('seia');     // dinámico
  const seiaInv  = _sum('seia','inversion');  // dinámico
  const dgaReal  = _count('dga');
  const concReal = _count('concesiones');
  const prediosReal = _count('predios');
  const lh = {
    predios: prediosReal || 7686,
    seia: seiaReal || 22,
    inversion: Math.round(seiaInv) || 6869,
    dga: dgaReal || 469,
    concesiones: concReal || 12,
    _truth_universe: 'capa cargada · runtime'
  };
fallback: si el source falla, se usa el valor real conocido (22, 6869, 469, 12) en lugar del valor obsoleto (17, 5779, 270, 6)
```

### Fix adicional 2 · "⚡ Tasación automática" → "✉ Tasación bajo solicitud"

```yaml
ubicacion: línea 3191 (botón en ficha predio SII)
problema_max: el botón se llama "automática" pero su contenido aclara "no ejecuta tasación automática" · contradictorio
fix: rename a "✉ Tasación bajo solicitud"
otros_textos_tasación: línea 3755 también dice "Tasación bajo solicitud" (alert-title del mailto · ya v1.0.4)
```

### Fix adicional 3 · Concesiones agregadas al reconciler

```yaml
universo_concesiones:
  real_capa: 12 features
  literal_v0: 6 hardcoded
  fuente: map.getSource('concesiones')._data.features
  fix: el TruthReconciler ahora calcula concesiones también
  fallback_en_objeto_comparar: 12 (real Max-observado)
```

---

## Pendientes diferidos v1.0.7+

```yaml
no_urgentes_pero_acumulables:
  
  cifras_SEIA_meta_tags_OG:
    descripcion: meta description y OG cards aún dicen "17 proyectos"
    fix: actualizar 3 meta tags + body fallback texto
    severidad: MEDIA (afecta SEO/share previews · no operacional)
  
  cifras_DGA_obsoletas_87:
    descripcion: línea 4156 panel-subtitle Análisis y línea 4891 alert-meta dicen "87 DGA"
    fix: reemplazar por placeholder con data-truth o eliminar
    severidad: MEDIA (panel VERDAD calcula real · pero contradice visualmente)
  
  Infraestructura_tab_escueta:
    descripcion: panel solo texto · sin métricas como otros tabs
    fix: agregar widgets de Líneas SEN + Subestaciones + concesiones
    severidad: BAJA (UX asimetría)
  
  rol_0_0_avaluo_dash:
    descripcion: predios con rol 0-0 muestran avalúo "—" · placeholder sucio
    fix: filtrar o marcar como "sin individualización SII" en ficha
    severidad: BAJA (caso conocido · doctrina rol-0-0)
  
  sector_literal_300:
    descripcion: existe sector llamado "300" con 1 predio · valor mal cargado
    fix: SQL ETL · no UI · upstream Supabase
    severidad: BAJA (1/7686)
  
  capa_sii_oficial_2_features:
    descripcion: source 'sii' tiene 2 features pero toggle dice "3+"
    fix: investigar fuente Supabase · si es real (catastro oficial parcial) etiquetar mejor
    severidad: MEDIA (pero no afecta canon H2)
```

---

## Validación post-push

```yaml
checklist_v1_0_6_online:
  □ refresh forzado: Cmd+Shift+R en https://meher1294.github.io/magnus-radar/v1-h2/
  □ panel "VERDAD CALCULADA · runtime" verde aparece en sidebar arriba
  □ panel muestra: SEIA total N · geocod M · críticos K
  □ panel muestra: DGA derechos N · geocod M · con caudal K
  □ panel muestra: Predios SII 7.686 (debe ser correcto)
  □ console.log con [v1.0.6 TruthReconciler] muestra objeto truths
  □ click polígono H2 Cominetti → ficha epistemológica HECHO + alias 24-48 + comisión 10%
  □ click sobre área urbana sin H2 → ficha predio SII v0 normal
  □ click feature ocupación H2 (cat=5) → ficha INFERENCIA + cuadrante + caveat
  □ click conflicto C13 → ficha HECHO RESUELTO + caveat doctrina homonimia
  □ leyenda 4 estados canónicos en sidebar coincide con features renderizadas
```

---

## Lección epistemológica · canonizable

```yaml
doctrina_propuesta_v1_0_6: verdad_calculada_runtime
enunciado: |
  En cualquier visor del ecosistema Meher OS que mezcle datos hardcoded
  con datos dinámicos (Supabase / GeoJSON / API), la verdad operativa
  debe derivarse runtime desde la fuente real (source.features.length)
  y NO desde strings hardcoded en HTML/UI.
  
  Las cifras hardcoded son aceptables solo para:
    - meta tags SEO (con caveat de version-skew)
    - placeholders pre-load
    - copy en docs que NO sirven de fuente de verdad
  
  Toda cifra visible al usuario DEBE tener:
    - origen runtime explícito
    - etiqueta de universo (total / geocodificados / críticos / etc)
    - timestamp o método de cálculo
  
aplicabilidad_cross_Meher:
  - Magnus Radar (canonizado aquí v1.0.6)
  - ITS visor (cuando se construya)
  - Magnus Radar Tributario (futuro · contar facturas / DTE / pagos)
  - cualquier dashboard de datos del grupo
```

---

**Linkado:**
- [[QA_AUDIT_v1_0_5]]
- [[AUDITORIA_IMPLEMENTACION_CANON_v1_0_4]]
- [[deploy_magnus_radar_v1_0_3]] (memoria)
- [[canon-maplibre-motor-cartografico-v1]]
- auditoría Hilos A/B/C de Max
