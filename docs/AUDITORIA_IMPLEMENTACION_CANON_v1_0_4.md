# AUDITORÍA IMPLEMENTACIÓN CANON · v1.0.4

**Fecha:** 2026-05-31
**Auditado:** v1.0.3 publicado en https://meher1294.github.io/magnus-radar/v1-h2/
**Disparador:** dictamen Max post-deploy + 6 observaciones de uso
**Disciplina aplicada:** sin codear hasta cerrar BLOQUEANTE + ALTA según auditoría
**Severidad:** BLOQUEANTE (rompe carga/canon/separación comercial) · ALTA (induce interpretación incorrecta) · MEDIA (afecta usabilidad) · BAJA (estética/copy)

---

## TABLA 1 · Producto base

| # | Requisito | Implementado | Evidencia | Brecha | Severidad | Fix |
|---|---|---|---|---|---|---|
| 1.1 | v0 íntegro en `/magnus-radar/` | ✅ SI | URL pública v0 no tocada · cambios solo en `/v1-h2/` | — | — | — |
| 1.2 | v1-h2 = v0 enriquecido (no pelado) | ✅ SI | index.html 292 KB · clonado v0 268 KB + 24 KB inyección H2 | — | — | — |
| 1.3 | MapLibre como motor único | ✅ SI | grep mapbox-gl=0, cesium.com=0, leaflet solo en alert de doctrina como prohibición | — | — | — |
| 1.4 | **Basemap claro por default** | ❌ NO | línea 2007 `class="active" data-basemap="satellite"` · default es Satélite, no claro | basemap default es Satélite (raster oscuro de fondo en zonas sin imagen reciente) | **ALTA** | cambiar default a OSM/Calles · agregar opción "Claro" explícita |

---

## TABLA 2 · Datos

| # | Requisito | Implementado | Evidencia | Brecha | Severidad | Fix |
|---|---|---|---|---|---|---|
| 2.1 | H2 Cominetti cargada | ⚠️ PARCIAL | GeoJSON existe con 4 polígonos | en producción aparece ✗ (no carga) | **BLOQUEANTE** | fix paths + fallback + verificar GET 200 en HTTP |
| 2.2 | Ocupaciones cargadas | ⚠️ PARCIAL | GeoJSON con 19 features · estados `['observado','revisar_en_terreno']` no canónicos | aparece ✗ + estados no normalizados | **BLOQUEANTE** carga · MEDIA estados | igual a 2.1 + normalizar estados a HECHO/INFERENCIA/HIPOTESIS/BLOQUEADO |
| 2.3 | Servidumbres cargadas | ⚠️ PARCIAL | GeoJSON con 4 LineString · estados libres | aparece ✗ + estados no canónicos | **BLOQUEANTE** carga · MEDIA estados | fix paths + normalizar estados |
| 2.4 | Conflictos cargados | ⚠️ PARCIAL | GeoJSON con 3 features · C11/C13 RESUELTO + 24-5 GEOMETRIA_PENDIENTE | aparece ✗ | **BLOQUEANTE** | fix paths |
| 2.5 | H1 contextual OFF default | ✅ SI | línea 5947 `default:false` para `h2_h1_ctx` | — | — | — |
| 2.6 | DATA STATUS muestra 39 features y 0 fallas en HTTP | ❌ NO | en captura producción muestra 7 capas ✗ | el badge funciona pero las capas fallan al cargar | **BLOQUEANTE** | fix Obs 1 |

---

## TABLA 3 · Reglas canónicas

| # | Requisito | Implementado | Evidencia | Brecha | Severidad | Fix |
|---|---|---|---|---|---|---|
| 3.1 | Rol SII nunca como PK | ✅ SI | GeoJSON usa `rol_sii_actual` como atributo + `alias_historicos` array · no como llave única | — | — | — |
| 3.2 | Aliases 24-48→24-123 y 24-4→24-160 visibles | ✅ SI | capa_1: `rol=24-123 aliases=['24-48']` · `rol=24-160 aliases=['24-4']` | — | — | — |
| 3.3 | SII / CBR / Daniel_RTK separados | ✅ SI | 3 capas distintas (catastro SII en v0 + GeoJSON H2 catastral + capa_3_daniel_rtk separada) | render visual separado OK | — | — |
| 3.4 | 0-0 nunca con titular conocido | ✅ SI | capa_1 H2 no incluye polígonos 0-0 · v0 deja 0-0 sin titular en ficha | — | — | — |
| 3.5 | proxy_GPKG ≠ rol 24-5 | ✅ SI | rol 24-5 marcado como `GEOMETRIA_PENDIENTE` en capa_6_conflictos · no se asigna geometría falsa | — | — | — |
| 3.6 | EXP_H2 separado de EXP_DOMINGA_SERVIDUMBRES | ✅ SI | capa_5_servidumbres categoriza Andes Iron como `servidumbre_proyectada` distinta de MOP/InterChile/924-644 | — | — | — |
| 3.7 | **H1 García Huidobro NO operacional NI comercial** | ⚠️ PARCIAL | capa `h2_h1_ctx` default:false con caveat "NO operacional" | en VERSION.md mencionar explícito que NO se ofrece comercialmente; revisar copy en el visor si aparece referencia comercial a H1 | **ALTA** | añadir banner "H1 informativa · sin oferta comercial activa" en ficha H1 |

---

## TABLA 4 · Estados epistemológicos

| # | Requisito | Implementado | Evidencia | Brecha | Severidad | Fix |
|---|---|---|---|---|---|---|
| 4.1 | Estado HECHO visible | ✅ SI | capa_1 cominetti: estados=['HECHO'] · badge verde renderiza correctamente | — | — | — |
| 4.2 | Estado INFERENCIA visible | ✅ SI | capa H1 contextual: ['INFERENCIA'] | — | — | — |
| 4.3 | Estado HIPÓTESIS visible | ⚠️ PARCIAL | conflictos: 'GEOMETRIA_PENDIENTE' renderiza como hipótesis · pero no aparece explícito | renderizado por fallback `includes('PENDIENTE') → hipotesis` · debería ser estado declarado | MEDIA | normalizar a 'HIPOTESIS' literal en GeoJSON |
| 4.4 | Estado BLOQUEADO visible | ❌ NO | ningún feature usa BLOQUEADO en estado actual · solo aparece en leyenda | sin features que demuestren el estado · doctrina-29-9 dice usar BLOQUEADO para residuales no resueltos | MEDIA | agregar al menos 1 feature con estado BLOQUEADO (ej: capa_3_RTK como BLOQUEADO_pendiente_levantamiento) |
| 4.5 | Cada feature muestra fuente | ⚠️ PARCIAL | la mayoría sí · ocupaciones tienen 'fuente' string · servidumbres tienen 'fuente' o array | normalizar todas a `fuentes: []` array | MEDIA | normalizar schema |
| 4.6 | Cada feature muestra caveat | ⚠️ PARCIAL | capa_2 matriz tiene caveat_geometria · ocupaciones tienen observación · sectores lineal tienen estado_geometria | conflictos no tienen caveat declarado · estancia matriz sí | BAJA | agregar caveat a conflictos |
| 4.7 | Cada feature muestra estado | ✅ SI | sí en capa_1, capa_6, h1 contextual · capa_4 ocupaciones usa 'observado'/'revisar' no canónico | obs en 4.3 cubre esto | — | — |

---

## TABLA 5 · Hallazgos canónicos obligatorios

| # | Requisito | Implementado | Evidencia | Brecha | Severidad | Fix |
|---|---|---|---|---|---|---|
| 5.1 | C11 resuelto 24-48→24-123 y 24-4→24-160 | ✅ SI | capa_6 conflicto C11 estado RESUELTO_2026-05-31 + capa_1 aliases visibles | — | — | — |
| 5.2 | C13 resuelto Totoralillo Norte ≠ Estancia La Higuera | ✅ SI | capa_6 conflicto C13 estado RESUELTO_2026-05-31 | — | — | — |
| 5.3 | rol 24-5 geometría pendiente | ✅ SI | capa_6 'rol_24-5_Andes_Iron' estado GEOMETRIA_PENDIENTE | — | — | — |
| 5.4 | H2 mandato Rep 24.327 comisión 10% (no Delta) | ⚠️ PARCIAL | EVT_H2_MAGNUS_MANDATO_20260414.md tiene canon completo · pero capa_1 H2 no expone comisión 10% en metadata visible | la ficha H2 no muestra "comisión 10%" cuando se da click | MEDIA | añadir `comision: '10% bruta'` a properties capa_1 |
| 5.5 | cláusula 5ª no representar colindantes | ⚠️ NO_EN_UI | está documentado en EVT pero no aparece en visor | usuario no ve la regla operacional · es importante para comunicar por qué H1 está off | MEDIA | añadir referencia en ficha H1 contextual: "Magnus restringido por cláusula 5ª mandato Cominetti" |
| 5.6 | Daniel RTK como referente físico | ⚠️ PARCIAL | capa_3 existe pero estados=NO_DECLARADO · descripción genérica | falta declarar autoridad física + "BLOQUEADO_pendiente_levantamiento" | MEDIA | normalizar capa_3 estado a BLOQUEADO + titular 'Daniel Martínez Zurita' |

---

## TABLA 6 · Servidumbres

| # | Requisito | Implementado | Evidencia | Brecha | Severidad | Fix |
|---|---|---|---|---|---|---|
| 6.1 | InterChile | ✅ SI | capa_5 LineString "Servidumbre InterChile Maitencillo-Pan de Azúcar 2x500 kV" | — | — | — |
| 6.2 | Ruta 5 / MOP | ✅ SI | capa_5 LineString "Faja Ruta 5 Norte (expropiaciones MOP 2011-2017)" | — | — | — |
| 6.3 | 924-644 | ✅ SI | capa_5 LineString "Servidumbre histórica 924-644" | — | — | — |
| 6.4 | **Andes Iron Sector Lineal VISIBLE** | ⚠️ PARCIAL | LineString existe en GeoJSON con `estado_geometria: 'TRAZADO_APROXIMADO · pendiente recuperar andes_iron.geojson...'` | en producción aparece ✗ no carga + label aproximado no se ve como cartel evidente | **ALTA** | fix paths (Obs 1) + label persistente sobre la línea: "TRAZADO APROXIMADO · pendiente vectorizar EIA A-104" |

---

## TABLA 7 · UI funcional

| # | Requisito | Implementado | Evidencia | Brecha | Severidad | Fix |
|---|---|---|---|---|---|---|
| 7.1 | **Capas NO aparecen como cargadas si fallaron** | ✅ SI | badge muestra ✗ por capa cuando hay error · contador no sube si fall | — | — | — |
| 7.2 | **Si 0 features: build rechazado** | ❌ NO | el visor publica con 0 features y el badge dice "0 features · 7/7 fallaron" pero sigue navegable | falta: bloqueo visible que diga "VISOR INVÁLIDO · contactar soporte" si 0 features en HTTP | **BLOQUEANTE** | agregar splash de error fullscreen si protocolo=http: y 0 features post-load |
| 7.3 | fetch funciona por HTTP | ❌ NO | en producción aparece ✗ todas las capas H2 | causa real desconocida hasta inspección Network · hipótesis: paths/timing/CORS | **BLOQUEANTE** | fix paths con fallback absoluto + logging visible |
| 7.4 | file:// muestra advertencia clara | ✅ SI | badge warning con comando `python3 -m http.server` ya implementado v1.0.1 | — | — | — |
| 7.5 | **Botón tasación NO promete chat inexistente** | ❌ NO | línea 3750-3751: "Para tasar: en este chat pídeme `tasar predio ${rol}`" | promete chat que no existe en visor publicado | **ALTA** | reemplazar por botón "Solicitar tasación" → mailto:max@xpu.cl con asunto y cuerpo |
| 7.6 | **Filtros SEIA funcionan o marcados deshabilitados** | ❌ NO | HTML existe (línea 2122-2129) con `class="seia-tf"` pero grep handler `seia-tf` retorna 0 resultados | NO hay event listener registrado para esos checkboxes · click no produce efecto | **ALTA** | agregar handler: filtra map.setFilter('seia-points', expression) según tipos checked |
| 7.7 | Capas defaults ajustadas | ❌ NO | h2_rtk: default:true (debe ser OFF según dictamen) | h2_rtk pasa a OFF · resto correcto | MEDIA | cambiar 1 línea |

---

## SCORECARD

```yaml
total_requisitos: 35
implementados_OK: 17 (49%)
parciales: 12 (34%)
no_implementados: 6 (17%)

severidad:
  BLOQUEANTE: 5 issues (todos del bloque carga de datos)
  ALTA: 4 issues (basemap claro · H1 banner · Andes Iron visible · tasación · filtros SEIA)
  MEDIA: 6 issues (normalizar estados · agregar BLOQUEADO · comisión 10% en ficha · cláusula 5ª · capa default · normalizar fuentes)
  BAJA: 1 issue (caveat conflictos)
```

---

## DICTAMEN AUDITORÍA

```yaml
v1_0_3_publicable: NO
razon: 5 BLOQUEANTE + 4 ALTA abiertos

v1_0_4_alcance_minimo_publicable:
  obligatorio_cerrar_BLOQUEANTE:
    - 2.1, 2.2, 2.3, 2.4, 2.6, 7.2, 7.3 (todos = fix Obs 1 carga capas)
  
  obligatorio_cerrar_ALTA:
    - 1.4 basemap default claro
    - 3.7 H1 banner "no comercial"
    - 6.4 Andes Iron visible con label
    - 7.5 tasación → mailto
    - 7.6 filtros SEIA funcionan
  
  opcional_v1_0_4_si_alcanza_tiempo:
    - 5.4 comisión 10% en ficha H2
    - 5.5 referencia cláusula 5ª en H1
    - 5.6 Daniel RTK BLOQUEADO + titular
    - 7.7 h2_rtk default:false
    - normalizar estados a 4 canónicos

diferido_v1_0_5:
  - vectorizar A-104 Layout Sector Lineal Andes Iron real
  - recuperar artefacto andes_iron.geojson perdido
  - normalizar schema fuentes a array
  - añadir caveats a conflictos
```

---

## ORDEN DE EJECUCIÓN

```yaml
1: fix carga capas (BLOQUEANTE 2.1-2.6, 7.2, 7.3) — Obs 1
2: tasación mailto (ALTA 7.5) — Obs 2
3: filtros SEIA handler (ALTA 7.6) — Obs 3
4: Andes Iron label visible (ALTA 6.4) — Obs 4 v1.0.4
5: capas defaults + h2_rtk OFF (Obs 5)
6: basemap claro default (ALTA 1.4)
7: H1 banner no comercial (ALTA 3.7)
8: QA pass iterativo · docs/QA_AUDIT_v1_0_4.md
9: push v1.0.4
```

---

**Próximo paso:** ejecutar FASE B con los 7 fixes prioritarios en este orden · sin pausa entre items · entrega QA_AUDIT_v1_0_4.md al cierre.
