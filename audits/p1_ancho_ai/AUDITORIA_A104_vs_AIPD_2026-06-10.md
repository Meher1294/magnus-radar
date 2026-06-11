# AUDITORIA_A104_vs_AIPD
### 2026-06-10 · ¿La servidumbre AIPD-2025 deriva del corredor A104-2013?
### Artefacto: `A-104_Layout_SECTOR_Lineal_Rev_0_07082013_AI.pdf` (A0, Andes Iron/SRK, EIA Dominga, metadata PDF: elaborado ago-2013, "Enviado a JIA") — incorporado a `docs/planos/`

---

## Clasificación del artefacto (conforme instrucción)

HECHO_DOCUMENTAL · plano histórico de DISEÑO (layout EIA) · contexto territorial. NO ES: plano de servidumbre 2025, plano catastral, plano CBR ni cuadro oficial AIPD-2025. Peso probatorio: secundario frente al AIPD-2025 (primario). Viñeta leída: **Proyecto Dominga · SRK Consulting · Lámina A104 "Layout Sector Lineal" · Rev. 0 · UTM Huso 19 SUR · Datum WGS84 · escala indicada** (derivada de grilla: **1:40.000**; grilla 2.000 m = 393,7 px @200 dpi, paso 5,080 m/px). Serie de láminas A101–A111 listada (mina, planta, Totoralillo, filtros, acopio, muelle, relaves, relaveducto, zona de recarga).

## Georreferenciación usada (método declarado)

Afín por grilla del propio plano: anclas leídas **E 274000→x2367 px · N 6732000→y4844 px** (labels confirmados: E 274–282k cada 2 km; N 6732–6748k cada 2 km), residuo de lattice <5 m. Digitalización de trazas: manual sobre superposición, **precisión ±50–80 m** — las conclusiones se sostienen por orden de magnitud, no al metro.

## Las 7 preguntas

**1. ¿Qué instalaciones conecta el A104?** (HECHO, etiquetas del plano) Desde Dominga Sur (rajo/área mina, ref. A102) hacia Sector Totoralillo (ref. A105–108): **línea eléctrica 66 kV · ducto de agua desalinizada · concentraducto · ducto de agua recuperada**, más camino de servicio implícito, almacenamiento de tuberías, 3 estaciones disipadoras de energía y piscinas de emergencia en el descenso a la costa; cruza Ruta 5 y se relaciona con una "línea eléctrica existente". Coincide con las 4 instalaciones que la capa 5 (hipótesis interna) registraba.

**2. ¿Qué trazado muestra?** (HECHO visual) Un corredor esencialmente **recto NE→SO** desde la mina, paralelo conjunto de trazas; en la zona del corredor H2 se **bifurca**: el paquete principal de ductos continúa hacia el sur-poniente (hacia las disipadoras 2/3 y Totoralillo), y un **ramal** (etiqueta del plano con flecha: "LÍNEA ELÉCTRICA 66 kV") se desvía hacia la **Estación Disipadora de Energía 1**.

**3. ¿Qué ancho declara?** **NO_DEMOSTRADO** — en la lámina no se observó cota de ancho de faja en la zona auditada: el A104 dibuja **trazas de instalaciones, no una faja de servidumbre acotada**. (La revisión exhaustiva de cotas en los 26 km queda anotada como pendiente menor.)

**4. ¿Qué superficie declara?** **NINGUNA** — no hay cuadro de superficies de servidumbre en el A104 (es layout de diseño, no instrumento de gravamen).

**5. ¿Coincide espacialmente con la servidumbre 2025?** **PARCIALMENTE — y este es el hallazgo central:**
- El **corredor principal de ductos** del A104 queda **0 % dentro** del polígono AIPD-2025 (distancia media ~1,2 km, máx ~2,8 km — robusto a ±80 m de método). El polígono 2025 NO envuelve el paquete principal del diseño 2013.
- El **ramal a Disipadora 1** discurre **dentro o inmediatamente adyacente** al polígono 2025 a lo largo de éste (distancia media 79 m ≈ error de método); la **punta NE del polígono coincide con la bifurcación** (51 m).
- Conclusión: **el polígono AIPD-2025 sigue el RAMAL del diseño 2013, no el corredor principal** (que en la zona H2 transcurre por la matriz AI, fuera del enclave).

**6. ¿La servidumbre 2025 amplía la huella prevista en 2013?** **SÍ, drásticamente en ancho** (INFERENCIA derivada con supuestos declarados): el A104 muestra una traza lineal; el polígono 2025 tiene ancho medio 505 m / máx 726 m sobre H2 (P1-AUDIT). Un buffer de ±200 m sobre el ramal digitalizado solo explica **44 %** del polígono 2025 (±60 m → 10 %): la huella 2025 **excede cualquier faja razonable** sobre la traza 2013.

**7. ¿El A104 respalda o contradice la ocupación de 181,69 ha?** **No la respalda ni la contradice formalmente** (instrumentos de naturaleza distinta: diseño EIA vs plano de servidumbre minera). Materialmente: respalda la EXISTENCIA histórica de un corredor por la zona y la lógica de la bifurcación; **no provee sustento de ancho ni de superficie** para las 181,69 ha — el fundamento de esa magnitud debe buscarse en el AIPD-2025 y sus antecedentes, no en el A104.

## Matriz epistemológica

| Dato | Clasificación |
|---|---|
| Existencia, autoría, fecha, datum (WGS84/19S), escala 1:40.000 | HECHO_DOCUMENTAL |
| Instalaciones y etiquetas del corredor | HECHO (lectura directa) |
| Georreferenciación por grilla (residuo <5 m) | HECHO_DERIVADO |
| Trazas digitalizadas (±50–80 m) | INFERENCIA_DERIVADA |
| Corredor principal FUERA del polígono 2025 | HECHO_DERIVADO (margen >> error) |
| Polígono 2025 sigue el ramal | INFERENCIA fuerte (adyacencia ≈ error de método) |
| Identidad exacta de la instalación del ramal (66 kV vs ductos a disipadora) | NO RESUELTO desde este plano (zona densa de etiquetas; la flecha apunta al ramal) |
| Ancho/superficie declarados por A104 | NO_DEMOSTRADO / INEXISTENTE |
| Derivación documental AIPD←A104 | PARCIAL: geometría del ramal sí; magnitud de la faja NO |

## Incorporación ejecutada

PDF → `docs/planos/` ✓ · capa `a104_corredor_2013.geojson` (2 trazas, ventana corredor H2, metadatos mínimos del mandato: fuente AI, Rev 0, 2013-08-07, incorporado, antecedente_historico, relacion_con_AIPD=AUDITADA) ✓ · visor: "A104 · Corredor Dominga 2013 · contexto histórico", **default OFF, fuera del preset reunión**, color gris contexto ✓ · capa 5 f0: `artefacto_perdido → RECUPERADO` ✓ · regla de representación cumplida (nunca "servidumbre vigente"). Sin tocar geometrías 2025 (hash capa 5 invariante `9e1e12ca`).

## Pendientes que abre esta auditoría

1. Digitalización del trazado completo mina–Totoralillo (hoy solo ventana H2) — baja prioridad, contexto.
2. Revisión de cotas de ancho en los 26 km del A104 (cerrar formalmente la pregunta 3).
3. La pregunta de fondo para la mesa, ahora con base documental doble: **¿qué justifica un polígono de 181,69 ha y hasta 726 m de ancho para envolver un RAMAL cuyo corredor principal pasa fuera de H2?** — insumo directo de negociación.
