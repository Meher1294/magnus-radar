# Ontología `unidad_territorial` v2 · Magnus Radar / ITS

**Versión:** 2.0
**Fecha:** 2026-05-31
**Naturaleza:** documento doctrinal · especificación de esquema · NO código todavía
**Disciplina:** integra 5 doctrinas canonizadas durante ciclo P2.x

---

## 0 · Motivación

El ciclo P2.x (P2.1 a P2.9C) produjo evidencia empírica primaria que demostró que **el rol SII es un atributo temporal con vida propia**, **NO una identidad estable**. La entidad persistente del modelo territorial debe ser otra cosa: la `unidad_territorial` con su geometría, su cadena CBR y su lista de alias SII históricos.

Esta ontología endurecida es el activo más valioso emergente de toda la secuencia. Aplica las siguientes doctrinas obligatorias:

1. **PRINCIPIO #1 · Auditoría operacional previa** (Meher OS · cross-sistema)
2. **PRINCIPIO #2 · Una fuente de verdad por métrica visible** (Meher OS · cross-sistema)
3. **Cardinalidad ≠ Estado** (doctrina operacional)
4. **Rol SII ≠ Identidad Territorial** (doctrina operacional · canonizada P2.8)
5. **Homonimia Territorial** · similitud nominal NO implica identidad (canonizada P2.9C)

---

## 1 · Entidad central · `unidad_territorial`

```yaml
unidad_territorial:
  id: UUID                                  # ← clave primaria persistente
  nombre_canonico: string                   # nombre humano legible · NO único · NO clave
  tipo: enum                                # predio_juridico | predio_fiscal | concesion_minera |
                                            # servidumbre | unidad_administrativa | sub_unidad |
                                            # zona_protegida | otro
  
  geometria_actual:                         # ← geometría vigente (puede mutar)
    poligono_vectorial: GEOMETRY            # WGS84 EPSG:4326 (canonizado)
    fuente_geometria: string                # Daniel_RTK | SII_KMZ-06 | CBR_consolidado | proxy_GPKG | etc.
    fecha_geometria: date
    confianza: enum                         # alta | media | baja | desconocida
    autoridad_geometrica: enum              # Daniel_RTK (operacional) | CBR_consolidado (jurídica) | SII (administrativa)
  
  superficie_actual:                        # ← superficie ÚNICA con capa explícita
    valor_ha: numeric
    capa_origen: enum                       # MISMA enum que fuente_geometria
    fecha_medicion: date
    
    historial_superficies:                  # ← múltiples mediciones coexistentes
      - { valor_ha, capa, fecha, fuente_documental }
      # NO se promueve ninguna como "la verdadera" sin doctrina explícita
  
  territorio_padre: UUID                    # ← unidad mayor que la contiene (nullable)
  composicion_sub_unidades:                 # ← composición interna (nullable)
    - UUID
  
  comuna: string                            # 4102_la_higuera (geocodificación canónica)
  provincia: string
  region: string
```

**Reglas obligatorias para `unidad_territorial`:**

```yaml
1. el_id_es_UUID_no_rol_sii (doctrina rol_sii_no_es_identidad_territorial)
2. el_nombre_es_atributo · puede tener duplicados (doctrina homonimia_territorial)
3. la_superficie_NO_se_promueve_a_ÚNICA sin capa + autoridad (regla canónica 1)
4. la_geometría_actual_es_la_más_reciente · historial preservado en relaciones
```

---

## 2 · Tabla `alias_sii_historico` (rol SII como atributo temporal)

```yaml
alias_sii_historico:
  id: UUID
  objeto_id: UUID → unidad_territorial.id     # qué unidad referencia
  rol_sii: string                              # ej. "24-48"
  periodo_inicio: date                         # cuándo se usó
  periodo_fin: date                            # cuándo dejó de usarse (nullable si vigente)
  fuente_documental: string                    # cita: "ESC Cofanti Rep 25.963 / 19-dic-2016"
  evidencia_url: string                        # path al documento canónico
  notas: text
```

**Cardinalidad:** N:N

- Una unidad puede tener N aliases históricos (caso Hijuela 2 Resto: 24-48 → 24-123)
- Un rol_sii puede aparecer asignado a N unidades distintas (caso 24-156: 6 polígonos dispersos)

**Reglas obligatorias:**

```yaml
1. rol_sii NUNCA es clave primaria de unidad_territorial
2. al_consultar_por_rol_sii_se_devuelve_lista_de_objetos_territoriales_candidatos
3. al_consultar_un_objeto_se_devuelve_lista_de_aliases (presentes y pasados)
4. NUNCA inferir identidad por igualdad de rol (B1 demostró 6 polígonos a 30km)
5. NUNCA inferir distinción por desigualdad de rol (P2.8 demostró mutación)
```

**Caso emblemático aplicado a Hijuela 2:**

```yaml
unidad: hijuela_2_resto_lotes_a_y_b
  aliases:
    - { rol: "24-48",  periodo: "2014-2016", fuente: "ESC Cofanti Rep 25.963 pp.12" }
    - { rol: "24-123", periodo: "2017-presente", fuente: "consulta SII + HousePricing 2026" }

unidad: hijuela_2_lote_c
  aliases:
    - { rol: "24-4",   periodo: "2014-2016", fuente: "ESC Cofanti Rep 25.963 pp.13" }
    - { rol: "24-160", periodo: "2017-presente", fuente: "consulta SII + HousePricing 2026" }
```

---

## 3 · Tabla `cadena_cbr` (jurídica)

```yaml
cadena_cbr:
  id: UUID
  objeto_id: UUID → unidad_territorial.id
  
  inscripcion:
    fojas: string                              # "97"
    numero: string                             # "91"
    anio: integer                              # 1990
    conservador: string                        # "CBR La Serena"
    registro: enum                             # propiedad | hipotecas_y_gravamenes | comercio | minas
  
  acto:
    tipo: enum                                 # saneamiento_DL_2695 | compraventa | herencia | dacion_pago |
                                               # adjudicacion | subdivision | servidumbre | otro
    fecha: date
    repertorio: string                         # nullable
    notario: string                            # nullable
  
  titular_origen: UUID → persona_juridica_o_natural
  titular_destino: UUID → persona_juridica_o_natural
  porcentaje_dominio: numeric                  # nullable (p.ej. cuotas hereditarias)
  
  estado: enum                                 # vigente | superado_por_acto_posterior | anulado | en_disputa
  notas: text
```

---

## 4 · Tabla `persona` (jurídica o natural)

```yaml
persona:
  id: UUID
  tipo: enum                                   # natural | juridica
  
  # Si natural:
  nombre_completo: string
  rut: string                                  # nullable
  fecha_nacimiento: date                       # nullable
  fecha_fallecimiento: date                    # nullable · puede ser HIPÓTESIS hasta certificado
  estado_vital_confirmado: enum                # vivo | fallecido | desconocido
  
  # Si jurídica:
  razon_social: string
  rut_juridico: string
  fecha_constitucion: date
  fecha_disolucion: date                       # nullable
  
  # Comunes:
  domicilio_actual: string                     # nullable
  notas: text
```

---

## 5 · Tabla `conflicto` · objetos nativos del modelo

```yaml
conflicto:
  id: string                                   # "C11", "C13", "C-H2-NUEVO-X"
  unidad_id: UUID → unidad_territorial.id      # qué unidad afecta
  enunciado: text                              # cita literal de la pregunta
  estado: enum                                 # abierto | resuelto_tentativamente | RESUELTO | superado
  
  fecha_apertura: date
  fecha_cierre: date                           # nullable
  
  evidencia_dirimente:
    documento_fuente: string                   # path o ID documento
    cita_literal: text
    verificable: enum                          # cita_directa | cruce_geometrico | validacion_terreno
  
  hipotesis_alternativas:                      # otras lecturas que NO se cumplieron
    - { enunciado, refutada_por }
  
  reportes_canonicos:                          # documentos que cierran el conflicto
    - string
  
  notas: text
```

**Caso aplicado: C13**

```yaml
C13:
  unidad_id: hijuela_2_matriz_envolvente_rol_24_5
  enunciado: "¿el predio fiscal fs.4856 N°4411/2007 coincide con el rol 24-5?"
  estado: RESUELTO
  fecha_apertura: 2026-05-31
  fecha_cierre: 2026-05-31
  
  evidencia_dirimente:
    documento_fuente: ESC-GT-000011 (Transacción servidumbre Andes Iron-Fisco)
    cita_literal: "ESTE: Estancia La Higuera, separado por línea de altas cumbres,
                   denominada Cordón Zarco"
    verificable: cita_directa
  
  hipotesis_alternativas:
    - { enunciado: "son el mismo objeto", refutada_por: "deslinde explícito" }
    - { enunciado: "son objetos parcialmente superpuestos", refutada_por: "deslinde excluye superposición" }
  
  reportes_canonicos:
    - magnus-radar/docs/P2_9C... (este reporte)
```

---

## 6 · Tabla `hipotesis` · objetos nativos del modelo

```yaml
hipotesis:
  id: string                                   # "H1", "H5", "HIPOTESIS_SD_01", etc.
  unidad_id: UUID → unidad_territorial.id      # qué unidad afecta (nullable si transversal)
  enunciado: text
  estado: enum                                 # abierta | demostrada | refutada | sin_cambio_material
  
  evidencia_que_la_sostiene: text
  evidencia_que_la_contradice: text
  
  vias_de_validacion_pendientes:
    - string                                   # "consulta CBR fs.X N°Y", "validación Daniel RTK", etc.
  
  riesgo_si_se_promueve_indebidamente: enum    # bajo | medio | alto | high_narrative_value
  
  fecha_apertura: date
  fecha_estado_actual: date
  notas: text
```

**Casos aplicados:**

```yaml
H1:
  estado: sin_cambio_material (corrección Custodio post-P2.9C)
  enunciado: "0-0 cat 5 podría corresponder a partes no individualizadas del rol 24-5 Andes Iron"
  vias_validacion_pendientes:
    - obtener polígono SII rol 24-5
    - validación Daniel RTK
    - cruce geométrico

H5:
  estado: confirmada
  enunciado: "Existe un gran predio fiscal relevante dentro del corredor"
  evidencia_que_la_sostiene: ESC-GT-000011 (Sector Totoralillo Norte · Fisco)
  ya_no_es_hipótesis_propiamente · es objeto_territorial autónomo

HIPOTESIS_SD_01:
  estado: abierta
  enunciado: "Compañía Minera Santa Dominga 1986 podría tener continuidad histórica con Minera Dominga / Andes Iron 2026"
  riesgo_si_se_promueve_indebidamente: high_narrative_value
  NO_incorporar_al_canon_sin_verificación
```

---

## 7 · Tabla `evento` · eventos territoriales en el tiempo

```yaml
evento:
  id: string                                   # "EVT-H2-OCCUPATION-BASELINE-20260531"
  unidad_id: UUID → unidad_territorial.id
  tipo: enum                                   # baseline | mutacion | conflicto_abierto | conflicto_cerrado |
                                               # cambio_titular | servidumbre_constituida | demanda |
                                               # validacion_terreno | otro
  fecha: timestamp
  descripcion: text
  fuente: string                               # documento o evidencia
  estado_pre: text                             # qué se afirmaba antes
  estado_post: text                            # qué se afirma ahora
  reversible: boolean                          # algunos eventos sí, otros no
  notas: text
```

**Casos aplicados:**

```yaml
EVT-H2-OCCUPATION-BASELINE-20260531:
  tipo: baseline
  fecha: 2026-05-31
  descripcion: "Patrón de ocupación detectado en 272 ha bbox H2"
  fuente: INGESTA_ORTOFOTO_H2_ITS_v1.md
  estado_pre: sin baseline
  estado_post: baseline registrado
  reversible: false (es punto en el tiempo)

EVT-MUTACION-CATASTRAL-24_48_24_123:
  tipo: mutacion
  fecha: entre_2016_y_2026
  descripcion: "Rol catastral SII pasó de 24-48 a 24-123 sin cambio de identidad territorial"
  fuente: P2_8_C11_RESUELTO_MUTACION_CATASTRAL_v1.md
  estado_pre: rol_24_48
  estado_post: rol_24_123
  reversible: depende decisión administrativa SII
```

---

## 8 · Vista canónica para visor (lectura)

```yaml
vista_unidad_territorial:
  
  panel_principal:
    nombre_canonico
    tipo
    geometria_actual + autoridad_origen
    superficie_actual + capa_origen
    titulares_actuales (vía cadena_cbr filtrada por vigente)
  
  panel_aliases_sii:
    lista_aliases_historicos_ordenados_por_periodo
    alerta_visible_si_documento_pre_2016_referencia_alias_obsoleto
  
  panel_capas_separadas:
    SII:        rol_actual + denominacion + superficie + titular_SII
    CBR:        titulares + cadena + inscripciones + estudio_titulos
    Daniel_RTK: perimetro_fisico + monolitos + fecha_medicion
    
    cuando_divergen:
      mostrar_divergencia_explicita
      NO_colapsar_en_una_sola_afirmacion
      etiquetar_la_que_se_está_mostrando
  
  panel_conflictos:
    lista_conflictos_abiertos
    lista_conflictos_cerrados (con cita evidencia dirimente)
  
  panel_hipotesis:
    lista_hipotesis_activas
    estado_evidencial_de_cada_una
    NO_promover_a_HECHO_sin_marca_explicita
  
  panel_eventos:
    timeline_de_eventos_canonizados
  
  panel_caveats:
    lista_canonizada_de_prohibiciones (del canon v2)
    visible_obligatorio
```

---

## 9 · Aplicación a otros casos del ecosistema Meher OS

Esta ontología es genérica · debe aplicar a:

- **Dominga / Andes Iron** (ya emerge como caso · EXP_DOMINGA_SERVIDUMBRES)
- **Hijuela 1** (García Huidobro · 2 roles dominante)
- **Hijuela 3** (Patricio Jarpa · sin canonizar todavía)
- **Sector Estancia Totoralillo Norte** (Fisco · objeto autónomo post-P2.9C)
- **Concesiones mineras TEMBLADOR** (Andes Iron)
- **Concesiones GABY, PALA, BENJA, MINA SOL, HOGAR** (otros titulares)
- **Servidumbre InterChile 2014-2015**
- **Servidumbre Andes Iron Dic-2025**
- **Cualquier predio futuro** del corredor o de otros expedientes Meher

---

## 10 · Migración recomendada desde Magnus Radar actual (v0.3 / v2)

```yaml
fase_1_documental:
  status_actual: ✓ completada (este documento + CANON_v2)
  
fase_2_modelar_en_schema_supabase:
  bloqueada_por: PASS_runtime_HARDENING_01_y_02 + autorización Custodio
  cambios_propuestos:
    - crear_tabla_unidad_territorial (UUID + atributos canónicos)
    - crear_tabla_alias_sii_historico
    - crear_tabla_cadena_cbr
    - crear_tabla_persona
    - crear_tabla_conflicto
    - crear_tabla_hipotesis
    - crear_tabla_evento
    - MIGRAR datos existentes preservando inscripciones canónicas
    - NO usar rol_sii como clave primaria (regla canónica)

fase_3_visor:
  vista_unidad_territorial con 5 paneles separados
  NO colapsar capas
  alertas canónicas visibles

fase_4_agentes_meher:
  agente-territorial debe consumir la ontología v2
  agente-inmobiliario debe respetar alias_sii_historicos
  agente-corporativo cuando aparezca persona jurídica con nombre similar a otra
```

---

## 11 · Disciplina obligatoria al implementar

```yaml
antes_de_cualquier_CREATE_TABLE:
  aplicar_PRINCIPIO_1_auditoria_operacional_previa:
    revisar_artefactos_históricos_del_data_room
    identificar_nombres_y_campos_que_el_laboratorio_ya_usa
    formalizar_no_sustituir

antes_de_persistir_cualquier_metrica_derivada:
  aplicar_PRINCIPIO_2_fuente_unica:
    derivar_en_render_desde_el_conjunto
    NO_persistir_paralelo_a_la_lista_fuente

al_comparar_dos_fuentes:
  aplicar_doctrina_cardinalidad_estado:
    diff_estructurado_por_hash_semantico
    NO_asumir_equivalencia_por_md5

al_consultar_por_rol_sii:
  aplicar_doctrina_rol_sii_no_es_identidad:
    devolver_lista_de_candidatos
    incluir_aliases_históricos
    NUNCA_asumir_unicidad

al_consultar_por_nombre_territorial:
  aplicar_doctrina_homonimia:
    alertar_si_nombre_refiere_a_multiples_objetos
    requerir_calificacion_de_cual
```

---

## 12 · Estatus de canonización

```yaml
documento_doctrinal: ACTIVO_post_2026-05-31
schema_SQL_implementado_en_Supabase: PENDIENTE (requiere autorización + runtime)
visor_implementado: PENDIENTE (PASS HARDENING_01/02 pendiente)
agentes_Meher_actualizados: PENDIENTE
documento_padre: CANON_HIJUELA2_v2.md
doctrinas_aplicadas_obligatorias:
  - PRINCIPIO_1
  - PRINCIPIO_2
  - cardinalidad_distinta_de_estado
  - rol_sii_no_es_identidad_territorial
  - homonimia_territorial
quien_puede_modificar: Max Medina
quien_debe_aplicar: cualquier diseñador / asistente IA / colaborador en sistemas Meher OS
```
