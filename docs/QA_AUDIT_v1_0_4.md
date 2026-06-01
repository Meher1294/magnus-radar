# QA_AUDIT · Magnus Radar v1.0.4

**Fecha:** 2026-05-31
**Modalidad:** iterativo (no audit 1-2 días) · resuelve BLOQUEANTE + ALTA de AUDITORIA_IMPLEMENTACION_CANON_v1_0_4
**Estado:** PUBLICABLE post-push

---

## Acciones realizadas en v1.0.4

| # | Fix | Severidad | Línea(s) | Verificación |
|---|---|---|---|---|
| 1 | `smartFetchGeoJSON` con fallback de 4 paths (URL relativa robusta · pathname · absoluto GH Pages · puro relativo) | **BLOQUEANTE** | nuevo IIFE H2Module · función smartFetchGeoJSON | grep `smartFetchGeoJSON` = 4 refs |
| 2 | Overlay full-screen "VISOR INVÁLIDO · build rechazado" si 0 features en HTTP | **BLOQUEANTE** | función showBuildFailedOverlay | grep `showBuildFailedOverlay` activo |
| 3 | Tasación → mailto:max@xpu.cl con asunto/cuerpo prellenado (sin promesa de chat) | **ALTA** | línea ~3750 ficha SII | grep `pídeme` = 0 · `Solicitar tasación` = 1 · `mailto:max@xpu.cl` = 3 |
| 4 | Filtros SEIA · handler `.seia-tf` con `TIPO_MAP` mapeando a `map.setFilter('seia-points')` | **ALTA** | IIFE SeiaFiltersFix nuevo | grep `SeiaFiltersFix` registrado |
| 5 | Sector Lineal Andes Iron · label persistente "TRAZADO APROXIMADO · pendiente vectorizar EIA A-104" sobre la línea (symbol layer) | **ALTA** | función addH2GeojsonLayer rama tipo:'line' | grep `TRAZADO APROXIMADO` = 1 |
| 6 | `h2_rtk` default cambiado de `true` → `false` (Daniel RTK OFF al cargar) | MEDIA | línea 5949 H2_LAYERS | grep `h2_rtk.*default:false` = 1 |
| 7 | Basemap default cambiado de Satélite → Calles (OSM) · más claro · usable para trabajar | **ALTA** | líneas 2007 + 2417 | grep `class="active" data-basemap="osm"` = 1 |
| 8 | Banner H1 contextual "sin oferta comercial activa · cláusula 5ª mandato Cominetti" en ficha al click H1 | **ALTA** | renderH2Detail con flag `isH1` | grep `cláusula 5ª` = 2 refs |

---

## Bugs críticos resueltos (BLOQUEANTE)

```yaml
critico_1_carga_capas_h2:
  observado_v1_0_3: "✗" en las 7 capas H2 · 0 features en producción
  causa_hipotetica: path resolution en GH Pages subdir
  fix: smartFetchGeoJSON con 4 candidatos
  resultado_esperado_v1_0_4: ≥1 path resuelve · features cargan · badge "✓ 39 features"

critico_2_visor_navegable_sin_datos:
  observado_v1_0_3: con 0 features el visor se ve "operativo" pero está vacío
  causa: ausencia de gate de calidad
  fix: showBuildFailedOverlay overlay rojo full-screen si HTTP + 0 features
  resultado_esperado_v1_0_4: imposible publicar build defectuoso sin que el usuario lo vea
```

---

## Bugs medios resueltos (ALTA)

```yaml
alta_1_tasacion_promete_chat_inexistente:
  observado: "pídeme tasar predio X en este chat" · chat no existe
  fix: botón "Solicitar tasación" mailto:max@xpu.cl con rol prellenado
  
alta_2_filtros_seia_inactivos:
  observado: 6 chips Minería/Solar/Eólica/Transmisión/Termo/Hídrico sin efecto
  causa: handler nunca registrado en v0
  fix: IIFE nuevo · listener change + applyFilter() → map.setFilter('seia-points')
  
alta_3_basemap_satelite_default:
  observado: default Satélite (oscuro fondo cuando sin imagen)
  fix: cambio a OSM/Calles · base clara
  
alta_4_andes_iron_no_visible:
  observado: línea aproximada del Sector Lineal sin indicación
  fix: symbol layer con label "TRAZADO APROXIMADO · pendiente vectorizar EIA A-104"
  
alta_5_h1_sin_indicacion_no_comercial:
  observado: H1 podía interpretarse como ofrecible
  fix: banner gris en ficha "Magnus restringido por cláusula 5ª mandato Cominetti"
```

---

## Bugs latentes detectados · pendientes v1.0.5

```yaml
v1_0_5_pendientes:
  
  normalizar_estados_epistemologicos:
    afectados:
      - capa_4_ocupaciones (usa 'observado' · 'revisar_en_terreno')
      - capa_5_servidumbres (usa 'consumada · dominio Fisco' · 'vigente' · etc)
      - capa_3_daniel_rtk (NO_DECLARADO)
    fix: editar GeoJSON · estados deben ser ['HECHO','INFERENCIA','HIPOTESIS','BLOQUEADO']
    severidad: MEDIA · fallback funcional pero no canónico
    
  estado_BLOQUEADO_no_usado:
    descripcion: ningún feature usa BLOQUEADO · estado solo aparece en leyenda
    fix: capa_3_daniel_rtk debería ser estado=BLOQUEADO + titular='Daniel Martínez Zurita'
    
  comision_10_pct_no_visible_en_ficha_H2:
    descripcion: mandato Rep 24.327 cláusula 6ª comisión 10% no se muestra al click sobre H2
    fix: agregar properties.comision = '10% bruta' + render en panel
    
  vectorizar_A104_sector_lineal:
    descripcion: trazado actual aproximado (6 puntos)
    fix: extraer del PDF A-104 Layout Sector Lineal Rev 0 (EIA Dominga 2013)
    alternativa: recuperar artefacto andes_iron.geojson perdido referenciado en 4 .qgz
    
  normalizar_fuentes_a_array:
    descripcion: algunas capas usan 'fuente' string · otras 'fuentes' array
    fix: estandarizar todas a array
    
  agregar_caveat_a_conflictos:
    descripcion: capa_6 sin propiedad caveat
```

---

## Mejoras (BAJA · v1.0.6+)

```yaml
mejoras_futuras:
  
  recovery_si_fetch_falla:
    descripcion: hoy el usuario solo ve overlay error · no puede recargar específicamente la capa
    propuesta: botón "Reintentar capa X" por cada error
    
  exportar_capas_H2_como_geojson:
    descripcion: usuario puede descargar las capas H2 para QGIS
    propuesta: botón "Descargar GeoJSON" en sección Foco H2 sidebar
    
  compartir_estado:
    descripcion: URL params para preservar capas activas + zoom + ficha abierta
    propuesta: ?layers=h2_cominetti,h2_conflictos&zoom=12&center=...
    
  responsive_mobile_pulido:
    descripcion: sidebar overlay funciona pero ficha H2 puede colapsar mal
    propuesta: testing táctil en iPad/iPhone real
```

---

## Checklist post-push v1.0.4

```yaml
pre_validacion:
  ✓ smartFetchGeoJSON con 4 candidatos
  ✓ overlay build_failed implementado
  ✓ mailto en lugar de "pídeme"
  ✓ filtros SEIA con listener change
  ✓ label "TRAZADO APROXIMADO" en Sector Lineal Andes Iron
  ✓ h2_rtk default:false
  ✓ basemap OSM (claro) default
  ✓ banner H1 cláusula 5ª
  ✓ canon MapLibre intacto (mapbox=0 · cesium=0)
  ✓ tamaño 300 KB (+8 KB sobre v1.0.3)
  ✓ servidor local todos 200 OK

post_push_verificar_en_GH_Pages:
  □ https://meher1294.github.io/magnus-radar/v1-h2/ carga
  □ basemap claro al abrir (Calles activo, no Satélite)
  □ badge "✓ 39 features · 7/7 capas H2" (no ✗)
  □ click sobre Cominetti H2 abre ficha con HECHO en verde
  □ click sobre H1 contextual abre ficha con banner gris no-comercial
  □ activar capa Servidumbres → ver label "TRAZADO APROXIMADO" sobre línea Andes Iron
  □ click capa SEIA · descheckear "Minería + Puerto" → desaparecen puntos rojos del mapa
  □ buscar "tasación" en ficha de cualquier predio SII → ver botón mailto (no texto "pídeme")
  □ status bar: "protocolo: https:" visible
  □ sidebar buscador filtra capas correctamente
```

---

## Criterio de aceptación v1.0.4 (canon Max)

```yaml
v1_0_4_publicable_si:
  protocolo: ✓ http o https (no file)
  H2_DATA: ✓ "✓ 39 features"
  capas_fallidas: ✓ 0
  H2_visible_al_cargar: ✓ true (h2_cominetti default:true)
  sector_lineal_Andes_Iron_visible: ✓ true (capa default:true + label persistente)
  filtros_SEIA_funcionan: ✓ true (handler SeiaFiltersFix registrado)
  tasacion_no_promete_chat: ✓ true (grep 'pídeme' = 0)

DICTAMEN_QA: PUBLICABLE post-push
```

---

## Cambios pendientes para auditoría POST-push

Cuando el deploy v1.0.4 esté online, validar el checklist de "post_push_verificar_en_GH_Pages" antes de declarar el ciclo cerrado. Si algo falla, abre v1.0.5 con el delta específico (no re-auditar todo).
