# DEPLOY · pasos manuales desde Mac (actualizado v1.0.1)

> **v1.0.1 incluye:** DATA STATUS badge visible · contador features por capa · warning file:// con comando · reestructura `data/` → `geojson/` + `tiles/` + `styles/`



**Por qué manual:** el sandbox de Claude no puede ejecutar `git push` (lock `.git/index.lock` con permisos restringidos + sin SSH key para `git@github.com:Meher1294/magnus-radar.git`).

**Estado actual:** archivos staged + commit preparado · pendiente solo `commit` final + `push` desde tu Mac.

---

## 1. Comandos exactos (copiar y pegar en terminal del Mac)

```bash
cd "/Users/maxmedina/Desktop/Master Meher/Magnus Proyectos/MAGNUS RADAR/MVP LA HIGUERA/MVP MAGNUS RADAR LA HIGUERZ/magnus-radar"

# Limpiar lock huérfano del sandbox
rm -f .git/index.lock

# Verificar staged
git status --short

# Commit
git commit -m "feat: Magnus Radar Web V1 H2

- Visor MVP H2 La Higuera · 6 capas mínimas + H1 contextual
- MapLibre GL JS 4.7.1 canonizado (prohibido mezclar Mapbox/Leaflet/Cesium)
- Estados epistemológicos visibles: HECHO / INFERENCIA / HIPOTESIS / BLOQUEADO
- Reglas canónicas: SII/CBR/RTK separadas · aliases visibles · fuente obligatoria
- 39 features GeoJSON estáticos · backend ninguno · 124KB total

Magnus Radar visualiza territorio, evidencia y relaciones documentales.
No ejecuta corretaje, negociación ni gestión comercial."

# Push
git push origin main
```

## 2. Habilitar GitHub Pages

```yaml
ir_a: https://github.com/Meher1294/magnus-radar/settings/pages
configurar:
  Source: Deploy from a branch
  Branch: main
  Folder: /web
guardar:
  GitHub Pages generará la URL en 1-2 minutos
```

## 3. URL esperada

```text
https://meher1294.github.io/magnus-radar/v1-h2/
```

---

## 4. Validación post-deploy · checklist Max

Una vez en línea, verificar en navegador desktop + móvil:

```yaml
desktop:
  [ ] carga inicial < 3 segundos
  [ ] MapLibre renderiza basemap Carto Dark
  [ ] 6 capas se cargan automáticamente (status bar muestra "X features")
  [ ] click sobre H2 (rectángulo naranja) abre ficha en panel derecho
  [ ] ficha muestra estado HECHO en verde · aliases [24-48] como chip morado
  [ ] panel izquierdo toggle on/off cada capa
  [ ] H1 capa OFF por defecto (gris · regla: no operacional)
  [ ] panel ocupaciones (capa 4 · puntos amarillos) abre ficha con caveat
  [ ] conflicto C11 (capa 6 · punto rojo) abre ficha con doctrina canonizada

mobile:
  [ ] viewport adapta (header colapsa · panel lateral overlay)
  [ ] pinch-to-zoom funciona
  [ ] tap sobre features abre ficha
  [ ] basemap se mantiene fluido

performance:
  [ ] payload propio 99 KB (verificable en DevTools Network)
  [ ] MapLibre JS desde CDN ~ 1.2 MB (cacheado en segunda visita)
  [ ] basemap tiles Carto < 50 KB cada uno
```

---

## 5. Auditoría técnica pre-push (ya validada por sandbox)

```yaml
peso_bundle:
  index.html: 25.3 KB
  GeoJSON total: 73.6 KB
  payload propio: 98.8 KB
  CDN externos: MapLibre + fonts (cacheados)

reglas_canónicas_visibles_en_código:
  separación SII/CBR/RTK: 13 referencias
  estados epistemológicos: 8 referencias
  aliases históricos: 7 referencias  
  fuentes obligatorias: 9 referencias
  doctrinas canonizadas: 8 referencias

servidor_local:
  todos los GET retornan 200
  index.html: 6 ms
  7 GeoJSON: cargan limpiamente

dependencias_externas:
  ✓ MapLibre CDN unpkg: HTTP/2 200
  ✓ Carto basemap: HTTP/2 200
  ✓ Google Fonts: disponible

canon_MapLibre_respetado:
  ✓ sin leaflet
  ✓ sin mapbox-gl.js
  ✓ sin cesium
  ✓ sin openlayers
```

---

## 6. Después del push exitoso

```yaml
registrar_URL_publica_en:
  - este_archivo (sección URL)
  - magnus-radar/web/v1-h2/VERSION.md (changelog v1.0.0)
  - memoria_persistente_Magnus_Radar
  
siguiente_paso_v1.1:
  P1_georreferenciar_plano_historico (alto valor inmediato)
  RTK_Daniel_real
  recuperar_andes_iron_geojson
```

---

## Troubleshooting

```yaml
si_git_push_falla_por_credenciales_SSH:
  verificar: ssh -T git@github.com
  si rechaza: cargar key con ssh-add ~/.ssh/id_ed25519

si_GitHub_Pages_no_publica:
  verificar: Settings → Pages → branch main · folder /web
  esperar: 1-2 min después de configurar
  verificar: Actions tab muestra deploy completado

si_MapLibre_no_carga:
  abrir DevTools → Console
  verificar HTTPS (basemap Carto requiere)
  verificar CDN unpkg.com accesible
```
