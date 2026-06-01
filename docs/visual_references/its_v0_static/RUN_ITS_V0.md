# Cómo abrir ITS v0 (Hijuela 2 estático)

**Archivo principal:** `web/its.html`
**Versión:** v0 estático · datos hardcoded · sin Supabase

---

## Importante

`its.html` usa **módulos ES nativos** (`import` / `export`). Esto requiere servidor HTTP. **NO funciona con doble-click (`file://`)** porque los navegadores bloquean import de módulos desde file://.

---

## Opción 1 · Servidor local Python (más simple)

Desde Terminal en la carpeta `magnus-radar/web/`:

```bash
cd "/Users/maxmedina/Desktop/Master Meher/Magnus Proyectos/MAGNUS RADAR/MVP LA HIGUERA/MVP MAGNUS RADAR LA HIGUERZ/magnus-radar/web"
python3 -m http.server 8765
```

Luego abrir en navegador: http://localhost:8765/its.html

Ctrl+C en Terminal para detener.

---

## Opción 2 · Live Server (VS Code)

Si usás VS Code: instalar extensión "Live Server" → click derecho sobre `its.html` → "Open with Live Server".

---

## Opción 3 · GitHub Pages (cuando subas)

Ya desplegado vía GitHub Pages workflow, accesible en `https://meher1294.github.io/magnus-radar/its.html` (asumiendo que pushiaste a main).

---

## Lo que vas a ver

- Header sticky con logo + chip amarillo "modo lectura · sin escritura" + buscador
- Identidad de Hijuela 2 con título grande + chip de estado
- Las 5 superficies en cards, una de ellas la de conflicto SII en rojo con dos cifras
- Tabla matriz de autoridad con 13 dominios + iconos de estado
- Lista de 6 conflictos abiertos ordenados por severidad
- 4 cards de representaciones geométricas (G1-G4), G3 con opacidad reducida + label SUPERSEDED
- Timeline horizontal de 9 eventos verificados/localizados + banda separada con 2 hipótesis abajo
- Bloque de contexto envolvente Andes Iron al final
- Columna lateral derecha: placeholder de mapa (v0 no tiene MapLibre conectado) + lista de 9 capas (G3 OFF por defecto con label rojo) + lista de 5 titulares

---

## Test de los 60 segundos

Abrir en navegador, cronometrar, intentar responder las 7 preguntas del test ácido:

1. ¿Qué activo y dónde? → header de identidad
2. ¿Cuánto mide? → 5 cards de superficie
3. ¿Quién manda? → tabla matriz autoridad
4. ¿Qué está roto? → lista conflictos abiertos
5. ¿Cuántas versiones del activo? → 4 cards representaciones
6. ¿Cómo llegamos acá? → timeline horizontal
7. ¿Dónde está? → placeholder mapa columna derecha

Si alguna respuesta requiere más de 10 segundos, anotar y refinar.

---

## Limitaciones conocidas v0

- **Mapa es placeholder.** El polígono real de Hijuela 2 + capas MapLibre se conectan en v0.1.
- **Click en cards solo loguea en consola.** Drawers/modales de detalle se construyen en v0.2.
- **Datos hardcoded en `its/data.js`.** Reemplazo por queries Supabase se hace cuando staging esté ejecutado.
- **Buscador del header no funciona.** Es solo input visual hasta que conectemos backend.
- **No hay navegación a otras unidades.** Solo Hijuela 2 hasta que haya otras unidades cargadas.

---

## Próximos pasos

1. **Tú validás el test de 60 segundos** abriendo en tu navegador
2. **Reportás** lo que se entiende vs lo que no
3. **Iteramos** sobre el wireframe + código según hallazgos
4. **Cuando ejecutes staging** (RUN_STAGING.md), reemplazamos data.js hardcoded por queries Supabase
5. **Después**: drawers, mapa real con MapLibre, conectar capa polígono RTK Daniel

---

## Estructura de archivos

```
magnus-radar/web/
├── index.html              ← v1 mapa-céntrico (sin cambios)
├── its.html                ← v2 unidad-céntrico (NUEVO)
├── its/
│   ├── theme.css           ← Sistema color/tipo · 690 líneas
│   ├── data.js             ← Fixture Hijuela 2 hardcoded · 242 líneas
│   └── app.js              ← Renderers + bootstrap · 363 líneas
└── RUN_ITS_V0.md           ← Este archivo
```

**Total ITS v0:** ~1.319 líneas (sin contar v1 que sigue intacto).
