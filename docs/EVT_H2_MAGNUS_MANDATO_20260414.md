# EVT-H2-MAGNUS-MANDATO-20260414 · ingesta + corrección canon

**Fecha:** 2026-05-31 (ingesta) · 2026-04-14 (firma del instrumento)
**Disparador:** Max entrega PDF certificado del instrumento firmado
**Tipo de evento:** ingesta de evidencia primaria de primer nivel + corrección de canon vigente

---

## 1. Identidad documental canónica

```yaml
event_id: EVT-H2-MAGNUS-MANDATO-20260414
type: instrumento_juridico_firmado
subtype: mandato_gestion_representacion_comercializacion_inmobiliaria
estado: firmado_notarializado

documento:
  titulo_oficial: "MANDATO DE GESTIÓN, REPRESENTACIÓN Y COMERCIALIZACIÓN INMOBILIARIA"
  inmueble: "Hijuela número 2 de la Estancia La Higuera · Roles SII 24-123 y 24-160"
  repertorio_notarial: N°24.327 - 2026
  XMC_OT: 1.031.878
  fecha_firma: 14-abr-2026 (catorce de abril de dos mil veintiséis)
  lugar: Santiago, República de Chile
  notario_otorgante: Pedro Ricardo Reveco Hormazábal · Notario Público (19ª Notaría de Santiago)
  notario_certificador_copia_electronica: Javier Ignacio Hormazábal Collao · Notario Interino
  fecha_certificacion_copia: 17-abr-2026 09:38
  oficina: Bandera 341, Of 352, Santiago
  certificado_nro: 123457406433
  CUR: F5351-123457406433
  url_verificacion: http://fojas.cl/d.php?cod=not71jaighoco&ndoc=123457406433
  firma_electronica: avanzada (Ley 19.799 / 2002)
  pginas: 10

minuta_redactada_por: abogado Rodrigo Sánchez
```

---

## 2. Comparecientes

```yaml
mandante (LA MANDANTE · en conjunto):
  
  Silvia_Maria_Cominetti_Infanti:
    profesion: empresaria
    estado_civil: soltera
    rut: 7.011.575-1
    domicilio: Av Los Conquistadores 1790, dpto 72, Providencia, Santiago
    comparece_por_si_y_en_rep_de: AGRÍCOLA CANTERA LIMITADA (RUT 77.645.770-1, mismo domicilio)
    personeria: escritura 29-abr-2019 ante Francisco Lira Teuber (Notario Suplente de Pedro Reveco)
  
  Claudia_Cecilia_Cominetti_Infanti:
    profesion: traductora
    estado_civil: divorciada
    rut: 7.011.576-K
    domicilio: mismo de Silvia
  
  Lidia_Rosa_Victoria_Cominetti_Infanti:
    profesion: médico
    estado_civil: divorciada
    rut: 6.349.740-1
    domicilio: mismo de Silvia

mandatario (EL MANDATARIO):
  Max_Alan_Medina_Hernandez:
    profesion: arquitecto
    estado_civil: casado
    rut: 13.684.845-3
    domicilio: Paseo Huérfanos 1294, Oficina 55, Santiago
    comparece_en_rep_de: INVERSIONES MAGNUS SpA (RUT 77.613.806-1, mismo domicilio)
    personeria: 2-ago-2022, Registro de Empresas y Sociedades, código CRuy1bKx59B
```

---

## 3. Inmueble (cláusula PRIMERO)

```yaml
inmueble_canon:
  denominacion: Hijuela número 2 de la Estancia La Higuera
  
  componente_i_Resto_Lotes_A_B:
    inscripcion_CBR: fojas 1.671 N°1.159 / 2017
    registro: Registro de Propiedad CBR La Serena
    rol_SII: 24-123
  
  componente_ii_Lote_C:
    inscripcion_CBR: fojas 1.729 N°1.197 / 2017
    registro: Registro de Propiedad CBR La Serena
    rol_SII: 24-160
  
  comuna: La Higuera, Región de Coquimbo
```

---

## 4. CORRECCIONES CRÍTICAS DEL CANON PREVIO

### 4.1 · CORRECCIÓN A · No hay "Delta del Estructurador" en el mandato vinculante

```yaml
canon_previo_INCORRECTO:
  fuente: MANDATO_EXCLUSIVA_COMINETTI_HIJUELA2_FINAL.docx (NO firmado · es draft o versión alternativa)
  modelo_descrito: "Delta del Estructurador" · Magnus determina precio base, Mandantes lo aprueban en 15 días hábiles, Mandantes reciben precio base íntegro, Delta = remuneración exclusiva Magnus

canon_vigente_CORREGIDO_por_documento_firmado:
  fuente: Rep 24.327 (este documento) · FIRMADO 14-abr-2026
  modelo_real: "Comisión 10% bruta"
  cita_literal_clausula_SEXTA_REMUNERACION:
    "Como contraprestación por los servicios pactados el Mandatario tendrá derecho a percibir una
     comisión equivalente al diez por ciento del precio total de cada operación de venta, transferencia,
     arriendo, cesión de derechos o constitución de servidumbres que se materialice respecto del Inmueble
     o de porciones del mismo y como resultado directo o indirecto de sus gestiones..."
  
  caracterizacion_remuneracion:
    porcentaje: 10% sobre precio total
    base_calculo: suma de TODAS las contraprestaciones percibidas por el conjunto de propietarios, comuneros y/o adjudicatarios · sin distinción de cuotas
    caracter: "total" o "bruta" · incluye TODOS los impuestos que graven los servicios del Mandatario
    devengo: al momento del pago del precio o de cada cuota
    facturacion: por el Mandatario conforme a normas tributarias vigentes

  aplica_a:
    venta
    transferencia
    arriendo
    cesion_de_derechos
    constitucion_de_servidumbres ← incluye explícitamente servidumbre Andes Iron

re_calculo_economico_H2_post_correccion:
  precio_base_canon (declaración Max): $5.000.000 CLP / hectárea
  superficie: 2.139 ha
  precio_total_si_se_vende_a_base: $10.695.000.000 CLP (~UF 290.000 · ~USD 12M)
  comision_Magnus_si_se_vende_a_base: $1.069.500.000 CLP (~UF 29.000 · ~USD 1.2M)
  Cominetti_recibe_si_se_vende_a_base: $9.625.500.000 CLP (~UF 261.000 · ~USD 10.8M)
  
  comparacion_con_modelo_Delta_incorrecto:
    en_modelo_Delta_inexistente: Magnus se quedaba con (precio_efectivo - precio_base) integro
    en_modelo_10%_real: Magnus se queda con 10% del precio_efectivo · proporcional al precio
    consecuencia: incentivo Magnus al PRECIO MAXIMO + alineado con interés Cominetti
```

### 4.2 · CORRECCIÓN B · La cláusula 1.f "coalición coordinación" NO existe en el mandato firmado

```yaml
inferencia_previa_INCORRECTA:
  fuente: lectura de MANDATO_EXCLUSIVA_COMINETTI_HIJUELA2_FINAL.docx (draft no firmado)
  cita_cita_que_yo_use: "f) Coordinar con otros propietarios de la Estancia La Higuera para conformar coaliciones de negociación conjunta"

realidad_documento_firmado_Rep_24.327:
  facultades_clausula_TERCERA: (a) a (f) listadas
    (a) Representar ante Municipalidad LH, SEREMI MINVU Coquimbo, DOM, DGA, SEA, SERNAGEOMIN, MOP/Vialidad · cambio uso suelo, regularización ocupaciones, modificaciones PRC, permisos
    (b) Representar ante empresas privadas, corporaciones, fondos de inversión, operadores comerciales/industriales · negociación preliminar, confidencialidad, cartas intención NO vinculantes
    (c) Representar ante comités de pobladores, juntas de vecinos, comunidades, organizaciones que ocupen el inmueble · regularización, reubicación, compensación
    (d) Encargar y supervisar estudios técnicos, topográficos, cabida, ambientales, legales, factibilidad, mercado · COSTOS A CARGO DEL MANDATARIO
    (e) Elaborar propuestas de desarrollo, planes maestros, estudios cabida, layouts
    (f) Solicitar certificados, informes previos, certificados avalúo fiscal, dominio vigente, copias inscripciones · ante CBR, SII, organismos competentes
  
  NO_existe_facultad_de_coordinar_coaliciones_con_colindantes

  en_su_lugar_clausula_QUINTA_EXCLUSIVIDAD_dice_lo_OPUESTO:
    cita_literal_relevante:
      "el Mandatario se obliga a NO PRESTAR SUS SERVICIOS en los rubros que abarca el presente contrato,
       NI EN FORMA DIRECTA O INDIRECTA, A LOS PROPIETARIOS O ADMINISTRADORES DE LOS PREDIOS COLINDANTES
       con el inmueble. La prohibición referida también se aplicará para el caso de otros titulares de
       derechos de cualquier tipo que sea en los predios colindantes con el inmueble."
    
    excepciones_taxativas:
      (i) participacion_en_mesas_territoriales_multilaterales / instancias_publicas / iniciativas_planificacion comuna La Higuera
          condicion: "el Mandatario actúa en interés del propio Inmueble (H2) y NO en representación de colindantes"
      (ii) mandatos o encargos profesionales PREEXISTENTES del Mandatario a la fecha de suscripción (14-abr-2026)
           podrán continuar ejecutándose normalmente

consecuencia_para_H1_Garcia_Huidobro:
  García_Huidobro_es_propietario_de_predio_COLINDANTE (Hijuela 1 vecina H2)
  por_tanto_Magnus_NO_PUEDE_legalmente_representar_a_García_Huidobro_durante_vigencia_mandato_Cominetti
  
  ¿XPU_está_cubierto_por_excepcion_ii_mandatos_preexistentes?
    borrador_XPU_fecha: 13-mar-2026
    mandato_Cominetti_fecha: 14-abr-2026
    el_borrador_es_PREEXISTENTE_documentalmente
    PERO: borrador NO firmado · ¿constituye "mandato profesional preexistente"?
    interpretacion_pro_Cominetti: documento no firmado no es mandato
    interpretacion_pro_Magnus_XPU: existe encargo en gestión preexistente · cubre excepción
    estado_juridico: ZONA_GRIS · interpretable
  
  riesgo:
    si Magnus o XPU firma H1 con García Huidobro durante vigencia del mandato Cominetti,
    Cominetti puede invocar la cláusula 5ª y reclamar incumplimiento
    arbitraje (cláusula 15ª) ante CAM Santiago resolvería
```

### 4.3 · CORRECCIÓN C · La política H2→H1 es jurídicamente exigida, no solo política acordada

```yaml
canonización_previa_INCORRECTA:
  documento: politica_secuencia_H2_H1_la_higuera.md (memoria)
  hipotesis_dominante_que_yo_uso: "el bloqueo es operacional voluntario · no contractual"
  cita_mia_incorrecta: "NO hay prohibición contractual Cominetti de negociar con García Huidobro"

correcta_lectura_post_Rep_24.327:
  bloqueo_es_CONTRACTUAL · cláusula 5ª prohíbe servicios a colindantes
  García_Huidobro_es_colindante (H1 limita con H2)
  
  por_tanto_la_secuencia_H2→H1_que_Max_describió_como_"acordada"_es_en_realidad:
    consecuencia_natural_de_la_cláusula_quinta_exclusividad
    Cominetti_instruyó_la_secuencia_porque_ASÍ_LO_PACTÓ_CONTRACTUALMENTE
    García_Huidobro_aceptó_porque_es_la_realidad_jurídica_vigente
    no_es_voluntad_negociable · es_obligación_contractual_de_Magnus

implicancia_para_estrategia:
  para_que_Magnus_pueda_representar_a_García_Huidobro:
    a) termina_vigencia_mandato_Cominetti (24 meses desde 14-abr-2026 = hasta 14-abr-2028)
    b) o Cominetti revoca el mandato (90 días anticipación)
    c) o Cominetti AUTORIZA EXPRESAMENTE por escrito que Magnus represente a García Huidobro
    d) o se vende H2 y se entiende cumplido el objeto del mandato

  caso_d_es_lo_que_Max_describió_como_"venta_H2_primero":
    cerrar la venta H2 = cumplir el objeto del mandato = liberar Magnus de la cláusula 5ª

  caso_c_es_alternativa_de_emergencia:
    pedir autorización expresa Cominetti para representar García Huidobro
    Cominetti puede aceptar si el acuerdo H2→H1 ya existía
    pero podría rechazar si percibe conflicto de interés táctico

NO_es_doctrina_voluntaria:
  ES doctrina contractual con base notarial Rep 24.327
```

---

## 5. Otras cláusulas relevantes del mandato firmado

```yaml
CUARTO_ALCANCE_DEL_MANDATO:
  NO_es_poder_especial: para vender, prometer vender, arrendar
  NI_para: actos de DISPOSICIÓN, GRAVAMEN O ENAJENACIÓN
  Mandante_se_reserva: APROBACIÓN FINAL POR ESCRITO de todas las condiciones que el Mandatario negocie

SEPTIMO_OBLIGACION_DE_MEJOR_PRECIO:
  Mandatario se compromete a obtener y proponer mejor precio por m2 según márgenes del mercado de la zona
  considerando: ubicación específica, accesibilidad, factibilidad servicios, uso potencial

OCTAVO_OBLIGACIONES_INFORMACION:
  Mandatario informa TRIMESTRALMENTE sobre:
    avance de gestiones
    negociaciones con terceros
    ofertas recibidas
    estado de trámites
  proporciona copia de antecedentes que respalden gestiones

NOVENO_GASTOS:
  TODOS los gastos de cargo del Mandatario · sin reembolso
  incluye: estudios técnicos, levantamientos topográficos, vuelos dron, certificados, viajes terreno, gastos representación
  excepción: caso revocación sin causa imputable (Art 11)
  posibilidad acordada: gastos extraordinarios indispensables con tratamiento distinto por escrito

DECIMO_VIGENCIA:
  duración: 24 meses desde firma (14-abr-2026 → 14-abr-2028)
  renovación: automática por períodos sucesivos de 12 meses
  término: carta certificada con 90 días anticipación
  efecto sobre negociaciones pendientes: mandato se prorroga respecto de esas negociaciones específicas hasta su conclusión · subsistiendo remuneración

DECIMO_PRIMERO_TERMINO_ANTICIPADO:
  Mandante puede revocar por carta certificada con 90 días anticipación
  caso revocación SIN CAUSA imputable al Mandatario:
    Mandante PAGA gastos efectivamente incurridos y debidamente documentados
    PLAZO DE COLA del Art 12 se EXTIENDE A 12 MESES

DECIMO_SEGUNDO_COLA_POST_VIGENCIA:
  dentro de 15 días post-término: Mandatario entrega LISTA IMPRESA de interesados (nombre, encargado, contactos teléfono y email)
  con quienes pudo haber negociado adquisición, arrendamiento, concesión, servidumbre
  si dentro de 180 DÍAS post-término (12 meses si revocación sin causa) alguno de esos interesados firma con Mandante:
    SUBSISTE LA REMUNERACIÓN del Art 6° (10% comisión)

DECIMO_TERCERO_CONFIDENCIALIDAD:
  reserva absoluta · no divulgar sin autorización previa por escrito
  salvo cumplimiento del objeto o requerida por autoridad competente

DECIMO_CUARTO_NOTIFICACIONES:
  domicilios:
    Mandante: Av Los Conquistadores 1790, dpto 72, Providencia, Santiago
    Mandatario: Paseo Huérfanos 1294, Oficina 55, Santiago
  correos electrónicos (para comunicaciones distintas a avisos de término):
    Lipangue@gmail.com
    fabiolancellotti.cofanti@gmail.com
    max@xpu.cl ← NOTABLE · el correo de Max XPU está en el mandato de Magnus
  
  observación_critica:
    el correo max@xpu.cl figura en el mandato Cominetti firmado
    esto DOCUMENTA que Cominetti conoce la existencia y rol de XPU
    refuerza la lectura de "Cominetti consciente del paralelo XPU"

DECIMO_QUINTO_JURISDICCION:
  ARBITRAJE conforme Reglamento Procesal del CAM Santiago (Cámara de Comercio Santiago AG)
  árbitro arbitrador (procedimiento) y de derecho (fallo)
  sin recurso contra resoluciones del árbitro
```

---

## 6. Hallazgos operacionales que el documento confirma

```yaml
servicios_remunerados_explicitamente_o_implicitamente_por_clausulas_3era_y_9na:
  - estudios técnicos
  - levantamientos topográficos
  - GNSS y deslindes
  - vuelos de dron
  - ortofoto
  - catastro de ocupaciones
  - obtención de certificados (CBR, SII, avalúo fiscal, dominio vigente)
  - estudios PRC (modificaciones)
  - plan maestro territorial (cláusula 3.e propuestas, planes maestros, layouts)
  - negociación con Municipalidad La Higuera, SEREMI MINVU, DOM, DGA, SEA, SERNAGEOMIN, MOP
  - comercialización ante terceros (empresas privadas, fondos, operadores)
  - representación ante comunidades para regularización
  - estructuración financiera y legal de la operación
  - viajes a terreno
  - gastos de representación

coincidencia:
  esta_lista_coincide_EXACTAMENTE con la cartera de actividades ejecutadas durante 2026
  el_documento_legitima_retroactiva_y_prospectivamente_la_inversión_Magnus_en_estudios

estrategia_servidumbres_Andes_Iron_está_contemplada:
  cláusula_6°_remuneración_aplica_a_constitución_de_servidumbres
  por_tanto: si se constituye servidumbre Andes Iron sobre H2, Magnus tiene derecho a 10% del precio
  proyección: si Andes Iron paga UF X por servidumbre 4 capas H2, Magnus recibe 10% · independiente de la magnitud
```

---

## 7. Síntesis con disciplina

```yaml
HECHOS_OBSERVADOS_canonizables_post_lectura_documento_firmado:
  1. Existe instrumento firmado y notarializado Rep 24.327 · 14-abr-2026 · Notario Pedro Reveco
  2. El instrumento se titula "MANDATO DE GESTIÓN, REPRESENTACIÓN Y COMERCIALIZACIÓN INMOBILIARIA"
  3. Mandantes: Silvia + Claudia + Lidia Cominetti Infanti + Agrícola Cantera Ltda (Silvia como rep)
  4. Mandatario: Max Medina por Inversiones Magnus SpA
  5. Inmueble: Hijuela 2 Estancia La Higuera · Roles 24-123 (fs 1671 N°1159/2017) y 24-160 (fs 1729 N°1197/2017)
  6. Remuneración: 10% comisión bruta sobre precio total de venta/transferencia/arriendo/cesión/servidumbre
  7. Exclusividad recíproca · cláusula 5ª PROHÍBE servicios a propietarios colindantes con excepción de mesas territoriales multilaterales en interés H2
  8. Mandatos preexistentes pueden continuar (excepción ii cláusula 5ª)
  9. Vigencia 24 meses (hasta 14-abr-2028) renovación automática 12 meses
  10. Cola 180 días post-término · 12 meses si revocación sin causa
  11. Costos de cargo del Mandatario · todos los gastos sin reembolso (salvo causa Art 11)
  12. Mandante se reserva aprobación final por escrito de todas las condiciones negociadas
  13. Arbitraje CAM Santiago como jurisdicción

CORRECCIONES_A_CANON_PREVIO_que_yo_había_promovido_incorrectamente:
  A. NO existe "Delta del Estructurador" en el mandato vinculante (era de un draft no firmado)
  B. NO existe cláusula "coordinar coaliciones con otros propietarios" (al contrario · hay prohibición de servicios a colindantes)
  C. La política H2→H1 NO es voluntaria · es CONSECUENCIA CONTRACTUAL de cláusula 5ª exclusividad
  D. Magnus recibirá 10% bruto · Cominetti 90% bruto · Magnus NO se queda con todo el delta sobre precio base

INFERENCIAS_validas_post_correccion:
  1. La razón por la que el borrador H1 NO se firmó es CONTRACTUAL · cláusula 5ª prohíbe representar colindantes
  2. Para activar H1, Magnus necesita: (a) cerrar venta H2 (cumple objeto · libera obligación) · (b) o autorización expresa Cominetti · (c) o argumentar excepción mandato preexistente XPU 13-mar (zona gris)
  3. La estrategia "vender H2 primero" es EL CAMINO COMPATIBLE con el mandato firmado
  4. El modelo 10% comisión alinea incentivos Magnus con maximización precio Cominetti (a diferencia de mi error Delta)
  5. La servidumbre Andes Iron sobre H2 generaría 10% comisión Magnus sobre el precio de la servidumbre

BLOQUEADOS:
  1. Existencia de un documento "Acuerdo de Comisión" SEPARADO al mandato (Max lo nombró así pero el PDF muestra que es un único instrumento integrado)
  2. Estatus jurídico de XPU como "mandato preexistente" (cláusula 5ª excepción ii zona gris)
  3. Lista de interesados que Magnus ha contactado (información que se materializa al término según Art 12)
  4. Estado actual de gastos incurridos por Magnus (relevante si hay revocación sin causa)
```

---

## 8. Actualizaciones canónicas que se desprenden

```yaml
documentos_que_requieren_corrección:
  
  1. P0_DIAGNOSTICO_BORRADOR_H1_GARCIA_HUIDOBRO.md:
     corregir hipótesis H1 (modelo remuneración):
       de: "H2 firmado bajo Delta del Estructurador"
       a: "H2 firmado bajo 10% comisión bruta (Rep 24.327 cláusula 6ª)"
     corregir lectura sobre cláusula "1.f coalición":
       de: "el mandato Cominetti autoriza coordinar coaliciones"
       a: "el mandato Cominetti PROHÍBE servicios a colindantes (cláusula 5ª) · con excepción mesas territoriales en interés H2"
  
  2. HISTORIA_ESTANCIA_HIJUELAS_LA_HIGUERA_v1.md:
     actualizar §6 estructura Magnus en el corredor:
       remuneración: 10% comisión bruta (NO Delta)
       vigencia: 24 meses + renovación automática (hasta 14-abr-2028)
       cola post-término: 180 días (12 meses si revocación sin causa)
       reservas Mandante: aprobación final por escrito
     actualizar §8 INFERENCIAS y §9 frase de cierre con base contractual correcta

  3. politica_secuencia_H2_H1_la_higuera.md (memoria):
     reescribir desde "política operacional voluntaria" → "consecuencia contractual cláusula 5ª"
     mantener vigente el dictamen Max (H2→H1) pero anclarlo en base jurídica correcta

memorias_NUEVAS_a_crear:
  
  evt_h2_magnus_mandato_20260414.md (memoria):
    estructura canónica del instrumento firmado
    referencia Rep 24.327
    cláusulas 5ª y 6ª como pilares operacionales
    cola 180 días como activo económico vigente
  
  no_crear_nueva_doctrina_aún:
    la doctrina relevante (no-derivar-estrategia-sin-capa-ocupacion) ya cubre el principio
    correccion_doctrinal_unidad_territorial_historica ya cubre la perspectiva
    suficiente con actualizar las memorias existentes y este EVT
```

---

## 9. Acciones inmediatas post-ingesta

```yaml
prioridad_INMEDIATA:
  1. preguntar Max si existe documento ADICIONAL "Acuerdo de Comisión" separado al mandato
     (porque su descripción inicial mencionaba "acuerdo notarialado complementario" pero el PDF es un único instrumento integrado)
  
  2. confirmar interpretación de cláusula 5ª excepción ii:
     ¿XPU 13-mar-2026 borrador no firmado constituye "mandato profesional preexistente"?
     riesgo: si Cominetti lo cuestiona, arbitraje CAM resolvería
  
prioridad_OPERACIONAL:
  3. revisar P0_DIAGNOSTICO_BORRADOR_H1 con las correcciones
  4. revisar HISTORIA_ESTANCIA_HIJUELAS con remuneración 10% y vigencia 24 meses
  5. mantener focus en VENTA H2 (P0 real cumple objeto mandato · libera cláusula 5ª)
  6. lista de interesados Andes Iron + otros · empezar a documentar para Art 12 cola

prioridad_INFORMATIVA:
  7. validar que el correo max@xpu.cl en cláusula 14ª es deliberado (probable: sí · Cominetti consciente de XPU)
```

---

**Linkado:**
- [[HISTORIA_ESTANCIA_HIJUELAS_LA_HIGUERA_v1]] (a corregir)
- [[P0_DIAGNOSTICO_BORRADOR_H1_GARCIA_HUIDOBRO]] (a corregir)
- [[politica_secuencia_H2_H1_la_higuera]] (memoria · a corregir)
- [[CANON_HIJUELA2_v2]]
- [[doctrina-no-derivar-estrategia-sin-capa-ocupacion]]
- [[correccion-doctrinal-unidad-territorial-historica]]
- borrador H1: `02_MANDATOS_CONTRATOS/EXCLUSIVA_ESTANCIA_LA_HIGUERA_HIJUELA1_GARCIA_HUIDOBRO_2026.docx`
- mandato Cominetti FIRMADO Rep 24.327 (este documento · evidencia primaria de primer nivel)
