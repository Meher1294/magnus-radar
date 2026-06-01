# Hijuela 2 Cominetti — Caso de Prueba del Schema ITS v2

**Propósito:** demostrar que el schema `its.*` absorbe el caso real de Hijuela 2 sin modificaciones estructurales. Sirve como template para futuros casos (Dominga, Club Ecuestre, Mocito Guapo, Calera Tango).

**Fuente canónica:** `00_CORE/CANON_HIJUELA2_v1.md` (v1.2 · 2026-05-31)
**Schema referenciado:** `db/migrations/0002_its_schema.sql`
**Estado:** SQL de demo · **NO ejecutado**

---

## 1 · Mapeo completo de Hijuela 2 al schema v2

### 1.1 · Territorio + Unidad

```sql
-- Territorio macro
INSERT INTO its.territorios (
  nombre, tipo, comuna, provincia, region,
  rol_sii_matriz, superficie_aprox_ha, notas
) VALUES (
  'Estancia La Higuera', 'estancia', 'La Higuera', 'Elqui', 'Coquimbo',
  '24-5', 60000,
  'Matriz envolvente. Titular Andes Iron SpA RUT 76.097.759-4 desde 16-ago-2021 (Rep FS 313 N°14.461, UF 273.292,2657).'
) RETURNING id;
-- → territorio_id = $TERRITORIO_LA_HIGUERA

-- Titular de la matriz (Andes Iron)
INSERT INTO its.titulares (nombre, rut, tipo, estado, notas) VALUES
  ('Andes Iron SpA', '76.097.759-4', 'persona_juridica', 'vigente', 'Adquirente matriz Estancia La Higuera 2021');

-- Unidad territorial Hijuela 2 Cominetti (enclave dentro de la matriz)
INSERT INTO its.unidades_territoriales (
  territorio_id, codigo, nombre, roles_sii, comuna_codigo,
  superficie_reportada_ha, superficie_reportada_fuente, estado, notas
) VALUES (
  $TERRITORIO_LA_HIGUERA, 'hijuela_2_cominetti', 'Hijuela 2 de la Estancia La Higuera',
  ARRAY['24-123','24-160'], '4102',
  2139.35, 'estudio_titulos_consolidado', 'identificado',
  'Enclave dentro matriz Andes Iron. Composición: Resto Lote A 863 + Resto Lote B 976.35 + Lote C 300 ha.'
) RETURNING id;
-- → unidad_id = $UNIDAD_HIJUELA_2
```

### 1.2 · Titulares actuales (5 partes)

```sql
INSERT INTO its.titulares (nombre, rut, tipo, estado) VALUES
  ('Silvia María Cominetti Infanti',           '7.011.575-1', 'persona_natural', 'vigente'),
  ('Claudia Cecilia Cominetti Infanti',        '7.011.576-K', 'persona_natural', 'vigente'),
  ('Lidia Rosa Victoria Cominetti Infanti',    '6.349.740-1', 'persona_natural', 'vigente'),
  ('Sucesión Bruno Guillermo Cominetti Infanti', NULL,        'sucesion',        'vigente'),
  ('Agrícola Cantera Limitada',                NULL,          'persona_juridica','vigente');

INSERT INTO its.unidades_titulares (unidad_id, titular_id, participacion_pct, vigente_desde, origen_adquisicion) VALUES
  ($UNIDAD_HIJUELA_2, $SILVIA,    18.75, '2017-02-24', 'Rep FS 694 N°26.309/24-feb-2017'),
  ($UNIDAD_HIJUELA_2, $CLAUDIA,   18.75, '2017-02-24', 'Adjudicación particion Cofanti 2017'),
  ($UNIDAD_HIJUELA_2, $LIDIA,     18.75, '2017-02-24', 'Adjudicación particion Cofanti 2017'),
  ($UNIDAD_HIJUELA_2, $SUCESION,  18.75, '2017-02-27', 'Rep FS 695 N°26.316 + post fallecimiento Bruno G.'),
  ($UNIDAD_HIJUELA_2, $CANTERA,   25.00, '2023-01-23', 'Dación pago Bruno Guillermo Cominetti');
```

### 1.3 · Representaciones geométricas G1-G4

```sql
-- G1 · Plano matriz MBN 1988 (identificado por hallazgo 2026-05-31)
INSERT INTO its.representaciones_geometricas (
  unidad_id, codigo, tipo, fuente_descripcion, fecha_documento, fecha_levantamiento,
  autor, escala, datum, superficie_declarada_ha, vigencia, estado, desfase_conocido, notas
) VALUES (
  $UNIDAD_HIJUELA_2, 'g1_plano_matriz_mbn_1988', 'historica',
  'Plano MBN N°IV-1-1777-S.R.',
  '1990-01-10', NULL,
  'PENDIENTE cajetín', 'PENDIENTE cajetín', 'PSAD56 (atribución previa)',
  2642.00, 'vigente', 'identificado',
  '~500 m vs WGS84/SIRGAS validado por monolitos Daniel Martínez',
  'Cuerpo cartográfico extraído de PHOTO-2026-05-17-18-19-39 5.jpg. Cajetín pendiente.'
);

-- G2 · Plano subdivisión N°531/1992 (pendiente extracción)
INSERT INTO its.representaciones_geometricas (
  unidad_id, codigo, tipo, fuente_descripcion, fecha_documento,
  autor, vigencia, estado, notas
) VALUES (
  $UNIDAD_HIJUELA_2, 'g2_plano_subdivision_531_1992', 'juridica',
  'Plano N°531/1992 CBR La Serena', '1992-04',
  'C.T. de López', 'vigente', 'localizado_pendiente_extraccion',
  'Subdivisión Lote A: Lote C 300 ha + Resto A 863 ha. Pieza crítica Fase 13.'
);

-- G3 · KMZ DataRoom XPU 2026-04 (superseded)
INSERT INTO its.representaciones_geometricas (
  unidad_id, codigo, tipo, fuente_descripcion, fecha_documento,
  autor, superficie_declarada_ha, vigencia, estado, notas
) VALUES (
  $UNIDAD_HIJUELA_2, 'g3_kmz_dataroom_xpu_2026_04', 'operacional_intermedia',
  'DataRoom_Cominetti_LaHiguera.kmz', '2026-04',
  'XPU / Magnus', 2640, 'superseded', 'superseded',
  'Anterior a CADENA_REGISTRAL 17-may-2026 y RTK Daniel. Errores documentales conocidos: nombres propietarias incorrectas, Cantera SpA en vez de Ltda.'
);

-- G4 · RTK Daniel 2026-05 (verificado)
INSERT INTO its.representaciones_geometricas (
  unidad_id, codigo, tipo, fuente_descripcion, fecha_documento,
  autor, datum, proyeccion, precision_m, superficie_declarada_ha, vigencia, estado, notas
) VALUES (
  $UNIDAD_HIJUELA_2, 'g4_rtk_daniel_2026_05', 'medicion_rtk',
  'PERIMETRO_CBR_DANIEL_RTK10M_V1_UTM19S_FIX', '2026-05',
  'Daniel Martínez Zurita (CNI 14.387.985-2, Magnus)',
  'WGS84', 'UTM 19S', 10, 2164.97, 'vigente', 'verificado',
  '77 vértices. Geometría reparada post auto-intersección (+1.64 ha vs 2.163.33 previa). +25.62 ha vs jurídica 2017 (tolerancia medición real).'
);
```

### 1.4 · Superficies declaradas (5 con autoridad explícita)

```sql
-- s1 · Histórica matriz Jarpa 1990 (verificada por CBR primario v1.2)
INSERT INTO its.superficies (
  unidad_id, codigo, naturaleza, valor_ha, fuente_descripcion,
  capa_temporal, estado, composicion, notas
) VALUES (
  $UNIDAD_HIJUELA_2, 's_historica_matriz_jarpa_1990', 'historica_matriz',
  2642.00, 'Inscripción primaria CBR La Serena fs. 97 N°91/1990',
  1, 'verificado',
  '{"lote_a": 1163, "lote_b": 1479, "suma": 2642}'::jsonb,
  'Cifra del saneamiento DL 2.695. Base de cálculo histórica. Verificado por CBR primario hallazgo 2026-05-31.'
);

-- s2 · Jurídica consolidada 2017
INSERT INTO its.superficies (
  unidad_id, codigo, naturaleza, valor_ha, fuente_descripcion,
  capa_temporal, estado, composicion, notas
) VALUES (
  $UNIDAD_HIJUELA_2, 's_juridica_consolidada_2017', 'juridica_consolidada',
  2139.35, 'Adjudicaciones 2017: Rep FS 694 N°26.309 + Rep FS 695 N°26.316',
  3, 'verificado',
  '{"resto_a": 863, "resto_b": 976.35, "lote_c": 300, "suma": 2139.35}'::jsonb,
  'Reduce 502.65 ha vs 1990 — explicado por hipótesis Velásquez pre-1996 (HIP_VELASQUEZ_PRE_1996).'
);

-- s3 · Operacional RTK 2026
INSERT INTO its.superficies (
  unidad_id, codigo, naturaleza, valor_ha,
  representacion_geometrica_id,
  capa_temporal, estado, notas
) VALUES (
  $UNIDAD_HIJUELA_2, 's_operacional_rtk_2026', 'operacional_rtk',
  2164.97,
  $REPR_G4_RTK,
  5, 'verificado',
  '+25.62 ha vs jurídica 2017 (tolerancia medición real).'
);

-- s4 · Mandato declarada 2026
INSERT INTO its.superficies (
  unidad_id, codigo, naturaleza, valor_ha, fuente_descripcion,
  capa_temporal, estado, notas
) VALUES (
  $UNIDAD_HIJUELA_2, 's_mandato_declarada_2026', 'mandato_declarada',
  1800, 'Repertorio N°24.327, mandato Cominetti-Magnus, 14-abr-2026',
  6, 'verificado',
  'Cifra declarada conservadoramente. Cláusula contempla incorporación automática del excedente si estudios determinan mayor extensión.'
);

-- s5 · Fiscal SII (conflicto documentado · NO se promueve)
-- (Conflicto se inserta primero, luego se enlaza)
```

### 1.5 · Autoridades — Matriz de atribución

```sql
INSERT INTO its.autoridades (unidad_id, dominio, autoridad_actual, estado, notas) VALUES
  ($UNIDAD_HIJUELA_2, 'rol_sii',                'SII oficial',                              'verificado', '24-123 + 24-160'),
  ($UNIDAD_HIJUELA_2, 'avaluo_fiscal',          'SII oficial',                              'verificado', 'Consultable mapas.sii.cl'),
  ($UNIDAD_HIJUELA_2, 'contribuciones',         'SII oficial',                              'verificado', NULL),
  ($UNIDAD_HIJUELA_2, 'superficie_fiscal_sii',  'SII oficial (mapas.sii.cl directo)',       'conflicto_documentado', 'SII_SURFACE_FACTOR_100'),
  ($UNIDAD_HIJUELA_2, 'cabida_juridica',        'Estudio de títulos consolidado',           'verificado', '2.139,35 ha'),
  ($UNIDAD_HIJUELA_2, 'geometria_juridica',     'Plano N°377-2006 + cadena registral',      'localizado_pendiente_extraccion', 'Pieza crítica clase A'),
  ($UNIDAD_HIJUELA_2, 'geometria_operacional',  'RTK Daniel Martínez Zurita 2026-05',       'verificado', '2.164,97 ha · WGS84 UTM 19S · 10 m'),
  ($UNIDAD_HIJUELA_2, 'geometria_historica',    'Plano MBN IV-1-1777-S.R. (1988)',          'identificado', 'Cuerpo extraído; cajetín pendiente'),
  ($UNIDAD_HIJUELA_2, 'infraestructura',        'KMZ DataRoom 2026-04 (capas auxiliares)',  'verificado', 'Servidumbre InterChile, concesiones, tomas'),
  ($UNIDAD_HIJUELA_2, 'contexto_envolvente',    'Matriz Estancia La Higuera Rol 24-5 Andes Iron', 'verificado', '~60.000 ha · UF 273.292,2657'),
  ($UNIDAD_HIJUELA_2, 'servidumbres',           'CBR La Serena (inscripciones)',            'parcialmente_verificado', 'InterChile OK; histórica 924-644/1994 pendiente identificar dominante'),
  ($UNIDAD_HIJUELA_2, 'conflictos_abiertos',    'CANON_HIJUELA2_v1.md §7',                  'verificado', '13 conflictos registrados'),
  ($UNIDAD_HIJUELA_2, 'mandato',                'Repertorio N°24.327 + adjudicaciones 2017','verificado', 'Magnus SpA mandatario 24 meses 10%');
```

### 1.6 · Hipótesis

```sql
INSERT INTO its.hipotesis (
  unidad_id, codigo, descripcion, estado, promovible_si, notas
) VALUES (
  $UNIDAD_HIJUELA_2, 'HIP_VELASQUEZ_PRE_1996',
  'Venta franja sur Lote B (~502 ha) a Heriberto Humberto Velásquez Gallardo pre-1996. Pago en especie por agrimensura plano MBN 1988.',
  'hipotesis_de_trabajo',
  'Localizar inscripción CBR específica entre 1990 y 1996 que documente venta/transferencia Jarpa → Velásquez',
  'Hallazgo nuevo 2026-05-31: Heraclio Velásquez aparece como REQUIRENTE del trámite registral 1990, no como comprador. Hipótesis revisada: pudo ser agrimensor/gestor de Jarpa.'
), (
  $UNIDAD_HIJUELA_2, 'HIP_MOTOR_GEOMETRICO_2006',
  'Los planos 377-397/2006 son reescritura espacial coordinada (motor geométrico, no solo registro). 21 planos numerados consecutivos sugieren proyecto único de re-loteo.',
  'hipotesis_de_trabajo',
  'Extraer Plano General N°377-2006 y verificar si redefine geometrías o solo registra estado existente',
  'CADENA_REGISTRAL §664-666. Ventana propietario único 2000-2014.'
);
```

### 1.7 · Conflictos abiertos (13)

```sql
INSERT INTO its.conflictos (
  unidad_id, codigo, tipo, descripcion, estado,
  autoridad_resolutiva, accion_requerida, impacto, valores_observados
) VALUES (
  $UNIDAD_HIJUELA_2, 'SII_SURFACE_FACTOR_100', 'divergencia_superficie',
  'Factor 100 entre Data Inmobiliaria BQ (26,41 ha si interpretado como m²) vs Due Diligence (2.640,93 ha)',
  'conflicto_documentado',
  'sii_directo',
  'Consulta presencial mapas.sii.cl rol 4102-24-123',
  'Define superficie fiscal canónica',
  '[{"fuente":"data_inmobiliaria_bq","valor_raw":264093,"interpretacion_si_m2_ha":26.41},{"fuente":"due_diligence_2026","valor_ha":2640.93}]'::jsonb
), (
  $UNIDAD_HIJUELA_2, 'GAP_VENTA_VELASQUEZ_PRE_1996', 'gap_documental',
  'Venta franja sur Lote B ~502 ha a Velásquez pre-1996. Estado revisado a hipotesis_de_trabajo tras hallazgo 2026-05-31.',
  'hipotesis_de_trabajo',
  'cbr_la_serena',
  'Búsqueda registral inscripción específica 1990-1996',
  'Cierra explicación delta histórico 503 ha',
  NULL
), (
  $UNIDAD_HIJUELA_2, 'GAP_PLANO_22_1990', 'gap_documental',
  'Plano N°22/1990 CBR La Serena, anexo al final del Registro de inscripción fs. 97 N°91/1990. Diferente del plano matriz MBN — probablemente plano específico Hijuela 2.',
  'localizado_pendiente_extraccion',
  'cbr_la_serena',
  'Solicitud copia certificada anexo N°22/1990',
  'Detalle subdivisión interna lotes',
  NULL
), (
  $UNIDAD_HIJUELA_2, 'GAP_EQUIVALENCIA_ROLES_24_4_24_123', 'rol_no_equivalente',
  'Rol antiguo 24-4(R) confirmado en CBR primario. Falta reconstruir mutación catastral hacia 24-123 + 24-160.',
  'parcialmente_verificado',
  'sii_directo',
  'Certificado SII historial cambios de rol',
  'Continuidad gravámenes InterChile + trazabilidad fiscal',
  NULL
), (
  $UNIDAD_HIJUELA_2, 'GAP_MUTACION_CATASTRAL_24_4_A_24_123_24_160', 'rol_no_equivalente',
  'Cuándo y bajo qué resolución cambia 24-4 a 24-123 + 24-160',
  'conflicto_documentado',
  'sii_directo',
  'Certificado SII historial o consulta Dirección Avalúos regional',
  'Cierra GAP_EQUIVALENCIA segundo elemento',
  NULL
), (
  $UNIDAD_HIJUELA_2, 'GAP_DESLINDE_EL_MOLLE', 'deslinde_no_definido',
  'Predio aledaño sur Lote b: Jaime Ugarte Lee + Julio Brito Riffo (Planta El Molle) - no caracterizado',
  'conflicto_documentado',
  'cbr_la_serena',
  'Identificar rol SII actual + dominio actual',
  'Contexto territorial deslinde sur',
  NULL
), (
  $UNIDAD_HIJUELA_2, 'GAP_CAJETIN_PLANO_MBN', 'gap_documental',
  'Falta cajetín, autor, escala, datum, fecha exacta del plano MBN IV-1-1777-S.R.',
  'conflicto_documentado',
  'cbr_la_serena',
  'Foto adicional o copia certificada CBR',
  'Completa identificación G1',
  NULL
);
-- (resto de conflictos: GAP_FS_4531_1992, GAP_FS_924_644_1994, GAP_NOMBRE_VELASQUEZ,
--  KMZ_IDENTIDAD_PROPIETARIAS, KMZ_TIPO_SOCIETARIO, etc — patrón similar)
```

### 1.8 · Cadena registral

```sql
-- Capa 1 · Saneamiento 1990
INSERT INTO its.cadena_registral (
  unidad_id, capa_temporal, fecha, tipo_evento, inscripcion, cbr,
  superficie_involucrada_ha, descripcion, estado
) VALUES (
  $UNIDAD_HIJUELA_2, 1, '1990-01-10', 'saneamiento_dl_2695',
  'fs. 97 N°91/1990', 'La Serena',
  2642.00,
  'Saneamiento DL 2.695 a favor Luis Emilio Jarpa Díaz de Valdés. Res. SEREMI BBNN ST-102. Plano IV-1-1777-S.R. Rol antiguo 24-4(R).',
  'verificado'
);

-- Capa 2 · Subdivisión 1992
INSERT INTO its.cadena_registral (
  unidad_id, capa_temporal, fecha, tipo_evento, inscripcion, cbr,
  descripcion, estado
) VALUES (
  $UNIDAD_HIJUELA_2, 2, '1992-04-01', 'plano_registrado',
  'Plano N°531/1992 + nota marginal fs. 4.531/1992', 'La Serena',
  'Subdivisión interna Lote A: Lote C 300 ha + Resto A 863 ha. Cierre matemático 1163 = 863 + 300.',
  'identificado'
);

-- Capa 2 · Compraventa Jarpa → Cominetti + Castillo 1996
INSERT INTO its.cadena_registral (
  unidad_id, capa_temporal, fecha, tipo_evento, inscripcion, repertorio, notaria, cbr,
  monto_clp, superficie_involucrada_ha, descripcion, estado
) VALUES (
  $UNIDAD_HIJUELA_2, 2, '1996-01-01', 'compraventa',
  'fs. 1.994 N°1.813/1996', 'Rep FS 179 N°5.850',
  'Fernando Opazo Larraín (Santiago)', 'La Serena',
  19500000, 1839.35,
  'Compraventa Jarpa → Bruno Luigi Cominetti Palini (85%) + Virginia Castillo Iturriaga (15%)',
  'verificado'
);

-- (capas 3-6 similar pattern: cesión 2000, planos 2006, expropiaciones, Cofanti 2014, adjudicaciones 2017, dación 2023, mandato 2026)
```

---

## 2 · Queries de validación (lo que debería verse después)

```sql
-- 2.1 · Vista canónica de Hijuela 2
SELECT * FROM its.unidad_canonica WHERE unidad_codigo = 'hijuela_2_cominetti';
-- Esperado:
-- unidad_codigo: hijuela_2_cominetti
-- territorio: Estancia La Higuera
-- roles_sii: {24-123, 24-160}
-- estado_unidad: identificado
-- n_geometrias: 4
-- n_superficies: 5
-- n_autoridades: 13
-- n_hipotesis: 2
-- n_conflictos_abiertos: ~10
-- n_eventos_registrales: ~10
-- n_titulares: 5

-- 2.2 · Superficies por unidad (todas con capa + autoridad)
SELECT * FROM its.superficies_por_unidad WHERE unidad_codigo = 'hijuela_2_cominetti'
ORDER BY capa_temporal;

-- 2.3 · Conflictos abiertos dashboard
SELECT * FROM its.conflictos_abiertos WHERE unidad = 'hijuela_2_cominetti';

-- 2.4 · Cadena registral cronológica
SELECT capa_temporal, fecha, tipo_evento, inscripcion, descripcion, estado
FROM its.cadena_registral
WHERE unidad_id = (SELECT id FROM its.unidades_territoriales WHERE codigo = 'hijuela_2_cominetti')
ORDER BY capa_temporal, fecha;

-- 2.5 · Matriz de autoridad Hijuela 2
SELECT dominio, autoridad_actual, estado, notas
FROM its.autoridades
WHERE unidad_id = (SELECT id FROM its.unidades_territoriales WHERE codigo = 'hijuela_2_cominetti')
ORDER BY dominio;
```

---

## 3 · Lo que este caso prueba

El schema absorbe sin modificación:

1. ✅ **Múltiples geometrías concurrentes** (G1, G2, G3, G4 distintos tipos)
2. ✅ **Múltiples superficies con autoridad** (5 superficies, ninguna sobrescribe)
3. ✅ **Conflictos con autoridad resolutiva** (13 conflictos diferentes tipos)
4. ✅ **Hipótesis no contrabandeadas como hechos** (HIP_VELASQUEZ visible como tal)
5. ✅ **Cadena registral con capas temporales** (capa 1-6 representadas)
6. ✅ **Matriz de autoridad explícita** (14 dominios, autoridades distintas, estados distintos)
7. ✅ **Titulares múltiples con participación** (5 titulares con %, fechas, orígenes)
8. ✅ **Evidencia primaria como referencia** (CBR fs. 97 N°91/1990, RTK Daniel, plano MBN)
9. ✅ **Estados disciplinados** (verificado, identificado, localizado_pendiente_extraccion, parcialmente_verificado, hipotesis_de_trabajo, superseded)
10. ✅ **Vocabulario que sobrevive** sin necesidad de añadir tipos nuevos para este caso

---

## 4 · Próximos casos de prueba sugeridos

Antes de declarar el schema "validado", aplicarlo a 1-2 casos más para detectar overfitting:

| Caso | Por qué | Esperado revelar |
|---|---|---|
| **Dominga Sector Lineal** | Tiene RCA, expedientes ambientales, judicialización | Posible necesidad: tabla `expedientes_regulatorios` |
| **Predio Hijuela 1 Cominetti** (si existe) | Misma matriz, otra hijuela | Validar que se modela como otra unidad_territorial del mismo territorio |
| **Club Ecuestre** | Activo urbano simple del grupo | Validar que el schema no penaliza la simplicidad |

---

## 5 · Lo que NO está en este mapeo (pendiente)

- Servidumbres específicas (InterChile T281-T288, histórica 924-644/1994) — pueden necesitar tabla propia `its.servidumbres`
- Concesiones mineras superpuestas — posible tabla propia o categoría especial de gravamen
- Tomas y ocupaciones — categoría propia o JSONB en notas
- Expropiaciones MOP — tipo de evento ya soportado en cadena_registral

Decisión: incorporar incrementalmente según necesidad de queries reales del frontend v2.
