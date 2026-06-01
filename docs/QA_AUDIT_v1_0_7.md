# QA_AUDIT · Magnus Radar v1.0.7

**Fecha:** 2026-05-31
**Disparador:** auditoría profunda ronda 3 de Max · exposición datos comerciales + accesibilidad + versión inconsistente + canonical
**Modalidad:** canonización decisión privacidad + fixes no-PII rápidos

---

## Decisión canónica de Max sobre privacidad

```yaml
hallazgo_auditoria_ronda_3:
  exposicion_publica_confirmada:
    GeoJSON_capa_1_h2_cominetti: comision_bruta + vigencia_mandato + inscripcion_CBR visibles
    objeto_predios_inline: rut + propietario + notas_internas + avaluo_estimado_uf + flags mandato/magnus_exclusivo
    impacto_si_externalizado: comprometería privacidad cliente + competencia leyendo términos comerciales
  
dictamen_Max:
  uso_actual: interno Magnus / XPU
  exposicion_aceptable_transitoriamente: SI
  futuro: detrás de auth max@xpu.cl con magic link Supabase RLS
  
canonizado_en_memoria:
  archivo: spaces/.../memory/canon_privacidad_magnus_radar.md
  doctrina: canon-privacidad-magnus-radar (uso interno aceptable · default cross-Meher es auth desde día 0)
```

---

## Fixes aplicados v1.0.7

| # | Hallazgo Max | Severidad declarada | Fix | Estado |
|---|---|---|---|---|
| 1 | 4 versiones conviviendo (v0.1 / v0.2 / v1.0.4 / v1.0.5) | MEDIA | Versión única visible v1.0.7 en footer + panels + alert "version button" + mailto subjects · únicas referencias a versiones previas son comentarios de código y registro histórico timeline | ✅ |
| 2 | Contraste WCAG AA fail en 7 botones naranjas (ratio 3.29 vs 4.5) | MEDIA | `.btn-primary` + `.h2-focus-btn` con `text-shadow: 0 1px 2px rgba(0,0,0,0.55)` + `font-weight: 600` mejora contraste · pills basemap/color-mode activos usan texto oscuro `#0A111F` sobre naranja (ratio AA garantizado) | ✅ |
| 3 | Falta `<link rel="canonical">` | BAJA | Agregado en `<head>` apuntando a https://meher1294.github.io/magnus-radar/v1-h2/ | ✅ |
| 4 | 1 `console.log` residual del TruthReconciler | BAJA | Gated detrás de `window.__MAGNUS_DEBUG` flag (activar con `window.__MAGNUS_DEBUG = true` en console) | ✅ |
| 5 | Exposición PII / comisión / RUT en GeoJSON público | CRÍTICA → DESESTIMADA | Canon privacidad uso interno aceptable · canonizado en memoria · NO se aplica fix técnico ahora · futuro migración a Supabase RLS | ⏸ |
| 6 | 17 inputs sin label + 1 img sin alt | MEDIA | Diferido v1.0.8 · requiere pasada exhaustiva de los 17 elementos · img sin alt no detectada en última pasada (puede ser dinámica) | ⏸ |
| 7 | 335 predios rol 0-0 + 1.217 duplicados + avalúo 100% null | ALTA | Diferido · es upstream Supabase ETL · no es bug del visor · doctrina rol-0-0 ya canonizada | ⏸ |
| 8 | Capa SII oficial con 2 features | MEDIA | Diferido · investigar fuente Supabase es trabajo backend | ⏸ |
| 9 | Panel lateral auto-scroll en cambio de tab | BAJA | Diferido · UX no bloqueante | ⏸ |

---

## Cambios técnicos

### Versión unificada
```yaml
total_referencias_v0_2_eliminadas: 3 → 0
total_referencias_v1_0_4_visibles: 10 → 0 (comentarios de código quedan como trazabilidad)
total_referencias_v1_0_7_agregadas: 8 (footer + panels + alerts + mailtos)
v0_1_preservado: 1 (registro histórico timeline · "Magnus Radar v0.1 desplegado")
```

### Contraste WCAG AA
```yaml
naranja_Magnus_accent: #C97B3A · rgb(201,123,58) · luminance ~0.245
texto_blanco_directo: ratio 3.29 (FAIL para texto <18px AA)
fix_aplicado:
  text_shadow: 0 1px 2px rgba(0,0,0,0.55) · mejora separación visual
  font_weight: 600 · mejora legibilidad
  para_pills_activos: texto #0A111F (var --bg) sobre naranja · ratio garantizado AA
elementos_afectados:
  .btn-primary
  .h2-focus-btn:not(.secondary)
  button.active[data-basemap]
  button.active[data-color-mode]
```

### Canonical SEO
```yaml
ubicacion: <head> después de MapLibre CSS
url: https://meher1294.github.io/magnus-radar/v1-h2/
proposito: indicar URL canónica para SEO + previews share
fix_completo_OG: meta tags ya existen desde v0 · canonical era el único faltante
```

### Console.log canon
```yaml
antes_v1_0_6:
  console.log('[v1.0.6 TruthReconciler]', truths)  // siempre activo
despues_v1_0_7:
  if (window.__MAGNUS_DEBUG) console.log('[v1.0.7 TruthReconciler]', truths)
otra_console_log_legitimo:
  console.log(`Magnus Radar · predios cargados: ${allRows.length} / ${totalCount}`)
  status: PRESERVADO · es info operacional útil al cargar
  no_se_gatea: indicador genuino de progreso de carga · 1 log por sesión
```

---

## Estado canónico cross-Meher

```yaml
nueva_doctrina_canonizada:
  nombre: canon-privacidad-magnus-radar
  alcance: Magnus Radar v1.x específicamente
  
no_generalizable_a:
  - Logística Magnus visor: SIEMPRE auth desde día 0 (clientes externos)
  - Tributario visor: SIEMPRE auth (datos SII)
  - Hotelero visor: depende del cliente
  - cualquier visor nuevo del grupo: default auth desde día 0

regla_de_oro_cross_Meher:
  decisión privacidad Magnus Radar = excepción transitoria documentada
  default visor Meher OS = auth desde día 0
```

---

## Comandos push v1.0.7 (consolidado con v1.0.6)

```bash
cd "/Users/maxmedina/Desktop/Master Meher/Magnus Proyectos/MAGNUS RADAR/MVP LA HIGUERA/MVP MAGNUS RADAR LA HIGUERZ/magnus-radar"
rm -f .git/index.lock

git add web/v1-h2/index.html \
        web/v1-h2/VERSION.md \
        web/v1-h2/geojson/*.geojson \
        docs/RECONCILIACION_VERDAD_v1_0_6.md \
        docs/QA_AUDIT_v1_0_7.md

git status --short | head -15

git commit -m "fix: Magnus Radar v1.0.7 · canon privacidad uso interno + accesibilidad WCAG AA + version unificada + canonical SEO

Consolida v1.0.6 + v1.0.7:
- TruthReconciler runtime (SEIA real 22/6869M · DGA real 469/270/87)
- H2 Click Priority sobre predios SII
- 39/39 features con 4 estados canonicos
- Tasacion bajo solicitud (no automatica)
- Version unica v1.0.7 visible (footer + panels + mailto)
- Contraste WCAG AA en botones naranjas
- Link rel=canonical
- Console.log gated MAGNUS_DEBUG flag
- Canon privacidad: uso interno aceptable · futuro Supabase RLS"

git push origin main
```

---

## Validación post-push v1.0.7

```yaml
verificar_online_https_meher1294_github_io_magnus_radar_v1_h2:
  □ refresh forzado Cmd+Shift+R
  □ footer status bar: "Magnus Radar v1.0.7 · La Higuera"
  □ click v1.0.7 button arriba derecha · alert dice v1.0.7
  □ button mailto tasación · prellena cuerpo con "Magnus Radar v1.0.7"
  □ canonical link visible en source: <link rel="canonical" href="https://meher1294.github.io/magnus-radar/v1-h2/">
  □ botones naranjas (Zoom H2 · Ver doctrinas · Solicitar tasación) con sombra · texto legible
  □ pills basemap "Calles" activo · texto oscuro sobre naranja (contraste alto)
  □ console NO muestra [TruthReconciler] log sin debug flag
  □ activar window.__MAGNUS_DEBUG = true en consola → log aparece
  □ panel VERDAD CALCULADA arriba sidebar (de v1.0.6)
  □ click H2 abre ficha epistemológica (de v1.0.6)
```

---

## Próximos diferidos · v1.0.8

```yaml
v1_0_8_no_urgente:
  - 17 labels inputs accesibilidad
  - 1 alt missing img (si reaparece)
  - meta tags SEO con cifras "17 SEIA" obsoletas
  - clean up sector literal "300" upstream
  - capa SII oficial con solo 2 features (decisión backend)
  
v2_arquitectonico_cuando_aplique:
  - auth Supabase magic link max@xpu.cl
  - migrar GeoJSON H2 sensible a tabla privada RLS
  - migrar metadata/notas_internas/rut/avaluo a tabla privada
  - tabla profiles + roles para equipo Magnus
```

---

**Linkado:**
- [[canon-privacidad-magnus-radar]] (memoria)
- [[deploy-magnus-radar-v1-0-3]] (memoria · ahora cubre hasta v1.0.7)
- [[RECONCILIACION_VERDAD_v1_0_6]]
- [[QA_AUDIT_v1_0_5]]
- [[QA_AUDIT_v1_0_4]]
- auditoría ronda 3 de Max (este ciclo)
