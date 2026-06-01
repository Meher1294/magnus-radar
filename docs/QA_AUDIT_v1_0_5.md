# QA_AUDIT · Magnus Radar v1.0.5

**Fecha:** 2026-05-31
**Modalidad:** HOTFIX + cierre de pendientes diferidos QA_AUDIT_v1_0_4
**Causa raíz incidente v1.0.4:** `.gitignore` línea 37 (`*.geojson`) excluyó 7 GeoJSON H2 + 2 GeoJSON andamiaje P1 · nunca llegaron a GitHub Pages
**Validación canon:** `build_rejection_si_0_features` (canonizado v1.0.4) cumplió su rol bloqueando publicación rota

---

## Causa raíz del 404

```yaml
incidente_v1_0_4:
  sintoma_observado: visor en producción mostró overlay "VISOR INVÁLIDO · build rechazado" con 7 capas en 404
  causa_real: .gitignore línea 37 `*.geojson` excluye todos los .geojson del repo
  excepcion_existente: solo `!web/data/sample.geojson` (no cubría web/v1-h2/geojson/)
  archivos_afectados:
    - web/v1-h2/geojson/capa_1_h2_cominetti.geojson
    - web/v1-h2/geojson/capa_2_estancia_matriz.geojson
    - web/v1-h2/geojson/capa_3_daniel_rtk.geojson
    - web/v1-h2/geojson/capa_4_ocupaciones.geojson
    - web/v1-h2/geojson/capa_5_servidumbres.geojson
    - web/v1-h2/geojson/capa_6_conflictos.geojson
    - web/v1-h2/geojson/capa_h1_garcia_huidobro_contextual.geojson
    - docs/ingesta_plano_intervenido/p1_georreferenciacion/PUNTOS_CONTROL.geojson
    - docs/ingesta_plano_intervenido/p1_georreferenciacion/SUBLOTES_HISTORICOS_candidatos.geojson

  fix_aplicado:
    .gitignore agregadas 4 excepciones explícitas:
      !web/v1-h2/geojson/
      !web/v1-h2/geojson/*.geojson
      !docs/ingesta_plano_intervenido/p1_georreferenciacion/
      !docs/ingesta_plano_intervenido/p1_georreferenciacion/*.geojson
```

---

## Pendientes v1.0.4 diferidos · CERRADOS en v1.0.5

| # | Pendiente v1.0.4 | v1.0.5 estado | Evidencia |
|---|---|---|---|
| 1 | Normalizar estados a 4 canónicos | ✅ CERRADO | 37 features distribuidos: HECHO 9 · INFERENCIA 24 · HIPÓTESIS 4 · BLOQUEADO 2 |
| 2 | Estado BLOQUEADO sin features | ✅ CERRADO | capa_3 Daniel RTK estado_canonico=BLOQUEADO · conflicto rol_24-5 estado_canonico=BLOQUEADO |
| 3 | Comisión 10% no visible en ficha H2 | ✅ CERRADO | capa_1 features tienen `comision_bruta: '10% (cláusula 6ª mandato Rep 24.327)'` + render en panel atts |
| 4 | Cláusula 5ª no referenciada en H1 | ✅ CERRADO v1.0.4 + reforzado v1.0.5 | banner gris en ficha + propiedad `no_comercial` en GeoJSON con texto explícito |
| 5 | Daniel RTK sin titular | ✅ CERRADO | titular='Daniel Martínez Zurita (C.I. 14.387.985-2)' + autoridad + rol_capa |
| 6 | Fuentes inconsistentes (string vs array) | ✅ CERRADO | normalizado a array en los 7 GeoJSON |
| 7 | Conflictos sin caveats | ✅ CERRADO | C11/C13/rol_24-5 con caveats explícitos referenciando doctrinas |

---

## Distribución estados canónicos post v1.0.5

```yaml
HECHO (9):
  - 4 polígonos H2 Cominetti (rol 24-123 canon + 24-160 canon)
  - Faja Ruta 5 Norte expropiaciones MOP
  - Servidumbre InterChile 2014 (vigente · canon pagado)
  - Servidumbre 924-644 (vigente)
  - C11 RESUELTO mutación catastral
  - C13 RESUELTO Totoralillo Norte distinto

INFERENCIA (24):
  - 19 features de Ocupaciones H2 ortofoto
  - 5 polígonos H1 contextual (titular SII HousePricing)

HIPOTESIS (4):
  - 3 features Estancia matriz (bbox aproximado + 2 vértices HR PSAD56)
  - Sector Lineal Andes Iron (vinculante · firma pendiente · trazado aproximado)

BLOQUEADO (2):
  - Daniel RTK · pendiente levantamiento campo
  - rol 24-5 Andes Iron · geometría pendiente · identidad documental ALTA
```

---

## Nuevas garantías canónicas v1.0.5

```yaml
gate_pre_push_canon (nuevo):
  test_obligatorio_antes_push:
    git ls-files web/v1-h2/geojson/ | wc -l
  esperado: 7 archivos tracked (capa_1 a capa_6 + h1_contextual)
  si_falla: HALT antes de push · revisar .gitignore + git check-ignore
  
distribución_estados_canonicos:
  obligatorio: las 4 categorías (HECHO/INFERENCIA/HIPÓTESIS/BLOQUEADO) deben tener ≥1 feature representativa
  v1.0.5 cumple: 9/24/4/2 = todos representados
  
caveats_como_array:
  schema: `caveats: string[]` (no string único)
  feature debe tener caveats[] aunque sea vacío
  v1.0.5 cumple: todos los GeoJSON normalizados
  
fuentes_como_array:
  schema: `fuentes: string[]`
  v1.0.5 cumple: todas las capas normalizadas
```

---

## Comandos push v1.0.5

```bash
cd "/Users/maxmedina/Desktop/Master Meher/Magnus Proyectos/MAGNUS RADAR/MVP LA HIGUERA/MVP MAGNUS RADAR LA HIGUERZ/magnus-radar"
rm -f .git/index.lock

# Verificar que los GeoJSON ya NO están ignorados (gate canon)
git ls-files --others --exclude-standard | grep -c geojson
# debe retornar ≥7

git add .gitignore \
        web/v1-h2/geojson/ \
        web/v1-h2/index.html \
        web/v1-h2/VERSION.md \
        docs/ingesta_plano_intervenido/p1_georreferenciacion/*.geojson \
        docs/QA_AUDIT_v1_0_5.md

git status --short | head -20

git commit -m "fix: Magnus Radar v1.0.5 HOTFIX · publicar GeoJSON (excepción .gitignore) + normalizar 4 estados canónicos + comisión 10% + BLOQUEADO RTK"
git push origin main
```

---

## Checklist post-push v1.0.5

```yaml
verificar_online_después_de_push:
  □ https://meher1294.github.io/magnus-radar/v1-h2/geojson/capa_1_h2_cominetti.geojson → 200 OK con JSON
  □ Recargar https://meher1294.github.io/magnus-radar/v1-h2/ → overlay rojo DESAPARECE
  □ Badge "H2 DATA · ✓ 39 features · 7/7 capas H2" en verde
  □ Click H2 Cominetti → ficha muestra "comisión: 10% (cláusula 6ª mandato Rep 24.327)" + "vigencia mandato: 24 meses (hasta 14-abr-2028)"
  □ Click Daniel RTK → ficha muestra "BLOQUEADO" en rojo + titular "Daniel Martínez Zurita" + caveats listados
  □ Click H1 contextual → banner gris explícito "Magnus restringido por cláusula 5ª"
  □ Click conflicto C11 → caveat "Doctrina rol_sii_no_es_identidad" visible
```

---

## Lección epistémica (memoria persistente)

```yaml
incidente_v1_0_4_no_solo_resuelto · canonizado_como_aprendizaje:
  
  doctrina_nueva: gate_pre_push_obligatorio
  enunciado: "Antes de declarar publicable cualquier build de Magnus Radar,
              verificar con git ls-files que TODOS los assets referenciados en código existen tracked en git.
              No basta con que existan en filesystem · el sandbox de deploy solo ve lo que git push entregó."
  
  test_minimo:
    grep_assets_en_index_html → extraer rutas relativas
    git ls-files → comparar contra rutas extraídas
    si gap > 0: HALT
  
  por_que_no_se_detectó_en_v1_0_4:
    auditoría reviso filesystem (los archivos existían)
    no_revisó: git ls-files (los archivos no estaban tracked)
    .gitignore línea 37 silenciosamente bloqueaba commit
    git status no mostraba "??" porque estaban ignorados
  
  por_que_build_rejection_funcionó:
    showBuildFailedOverlay diseñado en v1.0.4 detectó 0 features post-fetch HTTP
    overlay full-screen rojo evitó publicación visualmente operativa pero vacía
    la doctrina cumplió su rol exacto
```

---

**Próximo:** push v1.0.5 desde Mac · verificación online en ~2 min · si OK declarar ciclo deploy estable.
