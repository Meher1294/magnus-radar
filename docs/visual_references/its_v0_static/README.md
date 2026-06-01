# its_v0_static · Referencia visual histórica

**Estado:** archivado · NO en producción · NO mantener activo
**Fecha de archivado:** 2026-05-31
**Razón:** giro arquitectónico — la ontología ITS se absorbe dentro de Magnus Radar v0.3 en vez de constituir un producto separado.

---

## Por qué este archivo existe

Esta carpeta contiene la implementación inicial de `its.html` v0 — un producto separado unidad-céntrico que se diseñó y construyó el 31-may-2026 antes de cuestionar la arquitectura.

Tras ver el render real, Max Medina tomó la decisión arquitectónica de NO mantener un producto paralelo a Magnus Radar y absorber la ontología ITS dentro del visor existente, manteniendo el mapa como centro de gravedad.

Documentación canónica del giro: `docs/DICTAMEN_ARQUITECTONICO_2026-05-31.md`.

---

## Lo que se preservó

| Activo | Estado |
|---|---|
| Schema PostgreSQL `its.*` (0002 + 0002b) | **vivo** — sin cambios, se ejecuta en staging cuando corresponda |
| CANON_HIJUELA2_v1.2 | **vivo** — doctrina del caso |
| DOSSIERs (Plano MBN, Plano 377) | **vivos** — fichas críticas |
| Vocabulario de 8 estados disciplinados | **vivo** — se integra a Magnus v0.3 |
| Tokens CSS (paleta semántica) | **vivo** — se migra a index.html v0.3 |
| Shape de datos en data.js | **vivo** — es el shape que devolverá Supabase REST |

## Lo que quedó en standby (este archivo)

- `its.html` · shell de la página independiente
- `its/theme.css` · sistema completo de CSS (los tokens se migran, el resto queda como referencia)
- `its/data.js` · fixture de Hijuela 2 (sirve para validar el shape esperado)
- `its/app.js` · renderers de los 7 paneles (algunos serán canibalizados como helpers, no como app)
- `RUN_ITS_V0.md` · instrucciones de cómo abrirlo (referencia histórica)

---

## Cómo abrir esta versión (para referencia visual)

```bash
cd "/Users/maxmedina/Desktop/Master Meher/Magnus Proyectos/MAGNUS RADAR/MVP LA HIGUERA/MVP MAGNUS RADAR LA HIGUERZ/magnus-radar/docs/visual_references/its_v0_static"
python3 -m http.server 8765 &
sleep 1
open http://localhost:8765/its.html
```

Servirá como recordatorio visual de la propuesta unidad-céntrica que NO se adoptó. Útil para comparar contra la implementación v0.3 cuando exista.

---

## NO hacer con esta carpeta

- NO modificar los archivos (es referencia histórica, no código activo)
- NO desplegar en GitHub Pages
- NO importar módulos JS desde otras partes del proyecto
- NO ejecutar tests sobre esta carpeta

## Cuándo borrar definitivamente

Cuando v0.3 esté en producción y validado por >=3 meses de uso operacional, esta carpeta puede borrarse del repo. Su contenido vivirá en el historial git.
