# Auditoría funcional — Servidumbre AIPD-2025 vs A104 vs PAS-85
### 2026-06-10 · ¿Qué obras específicas justifican geométrica y funcionalmente las 181,69 ha solicitadas?
### Sin benchmarking, sin anchos típicos, sin criterios de ingeniería inventados — solo evidencia geométrica y documental disponible.

---

## Resultado principal exigido

| | ha | Clasificación |
|---|---|---|
| **Superficie documentalmente explicada** (con ancho/área declarados en alguna fuente) | **0,0 ha** | **HECHO** — ni el cuadro AIPD, ni el A104, ni el PAS-85 (composición declarada en instrucción) declaran ancho de faja ni superficie por obra. No existe, en la evidencia disponible, documento que asocie hectáreas a obras. |
| Superficie posicionalmente **asociable** a la única obra trazada en el polígono (ramal A104, etiq. "línea eléctrica 66 kV" → Disipadora 1) — aritmética bajo supuestos DECLARADOS y NO documentados | ±30 m: 9,2 · ±60 m: 19,0 · ±100 m: 33,9 · ±200 m: 79,5 | INFERENCIA derivada (supuesto de faja explícito; ningún supuesto tiene respaldo documental) |
| **Superficie no explicada** (sin justificación documental observable) | **181,69 ha en sentido estricto**; incluso concediendo el supuesto más generoso (±200 m), quedan **102,2 ha (56 %)** sin asociación posicional ni documental; con ±60 m quedan 162,7 ha (90 %) | HECHO (derivado de lo anterior) |

**Hecho funcional estructurante:** el corredor troncal de ductos del diseño Dominga (concentraducto + acueducto desalinizada + acueducto recuperada — las obras pesadas del PAS-85) **no utiliza el polígono**: discurre a **2,5–4,6 km** del polígono en H2 y 0,2–2,6 km en H1 (mín. en la zona de bifurcación). De las obras que el PAS-85 describe, la única posicionalmente compatible con el polígono es la **línea eléctrica 66 kV** (y las instalaciones de su ramal: Estación Disipadora de Energía 1 y piscina de emergencia, visibles en A104 en el extremo SO — posición aproximada ±100 m, INFERENCIA).

## E1 · Longitud (HECHO_DERIVADO, ejes OBB+PCA documentados)
24-43 (H1): **2.940 m** · 24-123 (H2): **2.650 m** (extensión de eje con intersección; v1 reportó 2.902/2.456 con criterio de estaciones — diferencia por remates de vértice, ambas declaradas).

## E2 · Anchos (m) — cuerdas perpendiculares (HECHO_DERIVADO)

| Rol | mín | p10 | p50 (mediana) | media | p90 | máx |
|---|---|---|---|---|---|---|
| 24-43 | 2* | 137 | 194 | 190 | 261 | 270 |
| 24-123 | 10* | 184 | 456 | 431 | 653 | 699** |
*remates de vértice. **699 con muestreo cada 250 m; el máximo absoluto con muestreo fino (P1-AUDIT, 400 cuerdas) es 725,5 m.

## E3 · Perfiles transversales cada 250 m (HECHO_DERIVADO)

**Rol 24-43:** 0 m→2 · 250→199 · 500→262 · 750→271 · 1000→246 · 1250→221 · 1500→196 · 1750→185 · 2000→187 · 2250→189 · 2500→191 · 2750→132.
**Rol 24-123:** 0→10 · 250→**699** · 500→**653** · 750→607 · 1000→561 · 1250→514 · 1500→457 · 1750→401 · 2000→352 · 2250→304 · 2500→184.
Lectura: H1 es una faja relativamente estable (~130–270 m); H2 es un **abanico decreciente** de NE (699) a SO (184) — el sobreancho no es local sino estructural del polígono.

## E4 · Mapa de sobreanchos — `E4_mapa_sobreanchos.png`
Clasificación **descriptiva por la distribución del propio polígono** (sin umbral externo): normal ≤p50 · ensanchado p50–p90 · extremo >p90. Extremos del 24-123: estaciones 250–500 m (abanico NE, 653–699 m), inmediatamente después de la bifurcación. Extremos del 24-43: estaciones 500–750 (262–271 m).

## E5 · Tramo × obra identificada (evidencia disponible)

| Tramo (est., rol) | Obra identificada en evidencia | Ancho obs. | Justificación documental del ancho |
|---|---|---|---|
| 24-43 · 0–2.750 m | Traza ramal A104 (etiq. 66 kV) recorre el corredor del polígono (INFERENCIA; offset traza↔centro 117–370 m ≥ semiancho local → en H1 la digitalización ±50–80 m **no permite** afirmar dentro/fuera por tramo) | 132–271 m | **NINGUNA** — sin ancho declarado en fuente alguna |
| 24-123 · 0–500 m (abanico NE) | Bifurcación troncal/ramal (A104) en la punta NE (±51 m) · ramal presente (d. centro 178–449 m, descentrado) | 653–699 m | **NINGUNA** · zona de máximo sobreancho sin obra adicional identificable en A104 |
| 24-123 · 750–2.250 m | Ramal A104 presente (d. centro 163–227 m) | 304–607 m | **NINGUNA** |
| 24-123 · 2.500 m (SO) | Estación Disipadora de Energía 1 + piscina de emergencia (A104, pos. aprox.) | 184 m | NINGUNA cuantitativa; la presencia de instalaciones puntuales es coherente con ALGÚN ensanche local — magnitud no documentada |
| Todos | Concentraducto / acueductos (troncal PAS-85) | — | **NO APLICA: el troncal no pasa por el polígono** (2,5–4,6 km en H2) |

## Clasificación epistemológica consolidada

HECHO: superficies y anchos del polígono (cuadro oficial = GeoJSON, identidad) · troncal fuera del polígono (margen >> error) · ninguna fuente disponible declara ancho/superficie de faja · superficie documentalmente explicada = 0,0 ha.
INFERENCIA: el polígono sigue el ramal 66 kV (adyacencia ≈ error de método) · disipadora/piscina en extremo SO · superficies asociables por buffer (supuestos declarados).
HIPÓTESIS: que el abanico NE responda a necesidades constructivas de la bifurcación (sin documento que lo afirme).
NO DEMOSTRADO: ancho oficial de faja AIPD · justificación de las 181,69 ha.
NO VERIFICADO: contenido íntegro del PAS-85 (composición tomada de la instrucción consolidada; documento no archivado en data room local) · viñeta/notas del plano AIPD (P3) · cuadro 24-43.

## Impacto en Magnus Radar (ejecutado)
Servidumbre AI sigue como capa principal ✓ · A104 contexto histórico gris OFF fuera de reunión ✓ · ficha Servidumbre AI ahora muestra **auditoría funcional** ("superficie documentalmente explicada: 0,0 ha") junto a superficie, plano fuente, estado vinculante y auditoría geométrica ✓ · sin conclusiones comerciales en el visor ✓.

## Pregunta de mesa resultante (del mandato, ahora con sustento triple)
**"Si el corredor troncal descrito en A104 y PAS-85 pasa fuera de H2, ¿qué obra específica justifica la solicitud de 124,145 ha sobre el rol 24-123 y anchos observados de hasta 726 m?"** — La carga de la prueba queda documentalmente del lado de Andes Iron: la evidencia disponible no contiene esa justificación (P3 pendiente: verificar si la viñeta/notas del AIPD declaran ancho de faja o áreas de construcción/temporal/permanente).

---

# ADDENDUM v2 — Corrección metodológica (instrucción consolidada Max, 2026-06-10)

## Reformulación obligatoria del resultado principal

Quedan **eliminadas** de esta auditoría las expresiones "0 ha justificadas/explicadas" (podían confundirse con ausencia total de respaldo para las obras). Formulación vigente:

- **HECHO** — Existe respaldo documental para la **existencia** de obras asociadas al proyecto Dominga (A104 y PAS-85 según composición declarada: línea 66 kV doble circuito, concentraducto, acueductos, camino de servicio, estaciones disipadoras, piscinas de emergencia).
- **HECHO** — Existe un polígono oficialmente solicitado y su geometría está **validada** contra el cuadro oficial de coordenadas (Hausdorff 0,00 m).
- **NO DEMOSTRADO** — Que dichas obras **requieran la superficie específica de 124,145 ha** solicitada sobre H2.
- **NO DEMOSTRADO** — Que los **anchos observados** del polígono (abanico estructural 699→184 m; máx 725,5 m) sean necesarios para ejecutar dichas obras.
- **PENDIENTE DE VERIFICACIÓN** — La documentación que fundamente dicha necesidad.

La regla de carga de la prueba queda asumida: esta auditoría **no intenta demostrar que el ancho sea exagerado**; verifica si existen antecedentes técnicos que expliquen lo solicitado.

## Pregunta principal

> ¿Cuál es el antecedente técnico específico que sustenta la delimitación geométrica del polígono AIPD-01-AI-AIP001 sobre el rol 24-123?

**Estado: SIN RESPUESTA EN LA EVIDENCIA DISPONIBLE** (búsqueda en árbol local 2026-06-10: sin PAS-85, sin RCA/anexos, sin memorias de cálculo archivadas).

## Preguntas secundarias obligatorias — estado

| # | Pregunta | Estado |
|---|---|---|
| 1 | ¿Existe memoria de cálculo asociada al polígono? | NO IDENTIFICADA en evidencia disponible · PENDIENTE DE VERIFICACIÓN |
| 2 | ¿Existe plano de ingeniería que defina el ancho requerido? | NO IDENTIFICADO (A104 no lo declara — HECHO; AIPD: viñeta/notas sin capturar — P3) · PENDIENTE |
| 3 | ¿Existe zona de seguridad normada que explique la geometría? | NO IDENTIFICADA en evidencia disponible · PENDIENTE (prohibido suplir con criterio normativo no citado por AI) |
| 4 | ¿Existe zona de construcción temporal incorporada al cálculo? | NO IDENTIFICADA · PENDIENTE (P3: áreas temporal/permanente en notas AIPD) |
| 5 | ¿Existe servidumbre auxiliar incorporada dentro del mismo polígono? | NO IDENTIFICADA · PENDIENTE |
| 6 | ¿Existe antecedente PAS-85 que indique ocupación superficial equivalente? | NO VERIFICADO — documento PAS-85 no archivado en data room local; su composición declarada (obras lineales) no menciona ocupación equivalente · PENDIENTE |
| 7 | ¿Existe documento que vincule explícitamente las 124,145 ha con una obra determinada? | NO IDENTIFICADO en evidencia disponible · PENDIENTE |

## Matriz de cierre (resultado esperado del mandato)

| Tramo | Obra identificada | Documento fuente | Superficie asociada explícitamente | Estado |
|---|---|---|---|---|
| 24-43 · faja completa (132–271 m) | Ramal 66 kV (traza) | A104 (etiqueta) | Ninguna | NO DEMOSTRADO |
| 24-123 · abanico NE est. 0–500 (653–699 m) | Bifurcación troncal/ramal | A104 | Ninguna | NO DEMOSTRADO |
| 24-123 · est. 750–2.250 (304–607 m) | Ramal 66 kV (traza) | A104 | Ninguna | NO DEMOSTRADO |
| 24-123 · extremo SO est. 2.500 (184 m) | Disipadora 1 + piscina | A104 | Ninguna | NO DEMOSTRADO |
| Todos | Troncal ductos (concentraducto/acueductos) | A104/PAS-85 decl. | No aplica — pasa a 2,5–4,6 km del polígono | HECHO (no lo utiliza) |

**Estado de la auditoría: ABIERTA.** Por regla de cierre del mandato, se cierra únicamente cuando cada sector del polígono tenga obra identificada **y** fuente documental explícita que justifique su ocupación superficial. Insumos de cierre requeridos (en poder de AI o del expediente SEIA): memoria de cálculo, plano de ingeniería del ancho, notas/viñeta AIPD, PAS-85 íntegro, RCA y anexos.
