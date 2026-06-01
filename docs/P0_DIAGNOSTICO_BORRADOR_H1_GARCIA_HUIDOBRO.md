# P0 · Diagnóstico borrador H1 García Huidobro + plan firma 48h

**Fecha:** 2026-05-31
**Disparador:** Max corrige · "el borrador no se firmó por exclusividad con Cominetti" + instrucción P0 cerrar H1 antes que Andes Iron.
**Reglas:** disciplina HECHO / HIPÓTESIS · sin inferir motivaciones sin evidencia.

---

## 1. HECHO contradice parcialmente la hipótesis de exclusividad

**El mandato Cominetti firmado (Rep 24.327 · 14-abr-2026) contiene cláusula 1.f literal:**

> *"f) Coordinar con otros propietarios de la Estancia La Higuera para conformar coaliciones de negociación conjunta."*

```yaml
implicancia:
  NO_hay_prohibicion_contractual_Cominetti de negociar con García Huidobro
  el mandato AUTORIZA expresamente coordinar con otros propietarios estancia
  la "exclusividad" del mandato Cominetti opera sobre H2 únicamente
  no_bloquea_H1 como activo Magnus/XPU

por_tanto:
  la razón real del no-firmado NO es prohibición contractual
  es algo más operacional o estructural
```

---

## 2. HIPÓTESIS reales del no-firmado (rankeadas por verosimilitud)

### H1 · Modelo de remuneración incompatible entre vehículos

```yaml
H2_Cominetti_FIRMADO_modelo:
  vehiculo: Inversiones Magnus SpA (RUT 77.613.806-1)
  modelo: "Delta del Estructurador" (cláusulas 2.1-2.5)
  estructura:
    Magnus arma precio base con estudios propios (avalúo + comparables + uso suelo + cercanía a minería + etc)
    Mandantes aprueban precio base en 15 días hábiles (silencio = aprobación)
    Mandantes reciben precio base íntegro a perfeccionamiento
    Delta (precio efectivo - precio base) = remuneración EXCLUSIVA Magnus
    Sin costo para Mandantes (Magnus asume todo gasto · dron, RTK, abogados, certificados)

H1_Garcia_Huidobro_BORRADOR_modelo:
  vehiculo: Xpert Urban SpA (XPU)
  modelo: "asesoría inmobiliaria" tradicional
  estructura: §6 vacío · condiciones NO definidas (plazo, precio, comisión, autorización, indemnidad)

dilema:
  si H1 también se firma bajo Delta del Estructurador (modelo Magnus):
    XPU/Magnus deja a García Huidobro con precio base "controlado" + delta para Magnus
    poco atractivo para García Huidobro si percibe que el mercado está en alza
  si H1 se firma bajo comisión tradicional (modelo XPU):
    se rompe coherencia con modelo aplicado a Cominetti
    se introduce asimetría: H2 paga 0% comisión y H1 paga % sobre venta
    García Huidobro descubrirá la asimetría al coordinar coalición

reconciliacion_necesaria:
  decidir modelo único para corredor (Delta para todos o comisión para todos)
  o estructurar híbrido: Delta para H2 + comisión variable XPU para H1 con cláusula de equidad
```

### H2 · Dual representation Max Medina (riesgo conflicto interno)

```yaml
realidad_operacional:
  Max representa Inversiones Magnus SpA (mandatario H2)
  Max representa Xpert Urban SpA (asesor H1)
  mismo Max · dos sombreros
  
en_la_coalicion_negociadora_con_Andes_Iron:
  Magnus defiende precio H2 al alza
  XPU defiende precio H1 al alza
  pero Andes Iron tiene presupuesto finito para el corredor
  
  si presupuesto Andes_Iron < (precio_H1 + precio_H2):
    Max debe decidir cómo se reparte el presupuesto
    quien define a cuál mandante "le toca" la diferencia
    
fiduciario_riesgo:
  Max está en posición de favorecer a uno de los dos
  García Huidobro podría desconfiar de la representación XPU si sabe que Magnus tiene mandato H2
  Cominetti podría desconfiar de Magnus si descubre que Max también representa H1
  
mitigacion:
  declarar la representación dual explícitamente en ambos mandatos
  cláusula de equidad en distribución del valor coalición
  asesor independiente como árbitro de la asignación si hay overlap
```

### H3 · Estudio títulos H1 ausente

```yaml
borrador_H1_§5_dice_literalmente:
  "Los datos de inscripción CBR (Foja, Número, Año y Acto) figuran como Sin Información (S/I) en ambos roles, 
   lo que constituye un vacío documental que debe subsanarse mediante certificado de dominio vigente ante el CBR de La Serena."
  "Se recomienda solicitar estudio de títulos (20 años) para verificar la cadena de transferencias y descartar gravámenes."

implicancia:
  sin certificado de dominio vigente no se puede individualizar correctamente el inmueble
  sin estudio títulos no se sabe si hay gravámenes / litigios / prohibiciones
  precio base es indefinible sin la información dominical completa
  
bloqueo_real_pre_firma:
  estudio_titulos_H1: PENDIENTE
  certificado_dominio_vigente_CBR_La_Serena: PENDIENTE
  
costo_estimado:
  estudio títulos 20 años + certificado: 1-2 semanas + ~UF 30-50
  PERO bajo modelo Delta del Estructurador, XPU/Magnus asume el costo
```

### H4 · §6 condiciones específicas vacías

```yaml
borrador_H1_§6_dice_literalmente:
  "Las condiciones específicas del encargo de exclusiva serán definidas de común acuerdo entre las partes, debiendo contemplar al menos:
   - Plazo de vigencia de la exclusiva
   - Precio de venta o rango de negociación
   - Comisión de intermediación
   - Autorización para gestión ante organismos públicos
   - Cláusula de indemnidad por gastos de gestión"

implicancia:
  el borrador es un MARCO sin contenido operativo
  García Huidobro no firmaría un marco sin condiciones específicas
  es un Memorando de Entendimiento · no contrato vinculante
```

### H5 · Precio base H2 aún sin determinar (efecto secuencial)

```yaml
mandato_Cominetti_2.1:
  Magnus debe realizar estudios técnicos para determinar Precio Base H2
  Mandantes Cominetti aprueban en 15 días hábiles

estado_actual_H2_precio_base:
  ¿determinado y aprobado? PENDIENTE_VERIFICACION_OPERACIONAL
  si NO está determinado: difícil establecer precio base H1 sin asimetría
  si YA está aprobado: se puede usar como referencia para H1
  
si_no_está_determinado_H2_precio_base:
  cerrar H1 antes que H2 puede generar:
    bench de precio H1 que constriñe negociación H2
    asimetría operacional difícil de revertir
```

---

## 3. Lectura combinada · por qué NO se firmó

```yaml
hipotesis_dominante (HD1):
  combinacion_de_H1_+_H4_+_H3:
    falta_modelo_remuneracion_definido (H1)
    §6_vacio_sin_condiciones (H4)
    estudio_titulos_H1_pendiente (H3)
  
  resultado:
    el borrador es un placeholder estructurado
    no llegó a contrato operativo por trabajo pendiente Magnus/XPU
    García Huidobro NO firmaría algo sin §6 completo

NO_es_dominante (descarte):
  prohibición Cominetti (H?): NO opera · cláusula 1.f autoriza coordinación
  desinterés García Huidobro: SIN evidencia · titular reconoce Magnus mediante borrador

resultado_diagnostico:
  el_bloqueo_es_INTERNO Magnus/XPU
  el trabajo pendiente está del lado de Max:
    completar §6 con condiciones específicas
    encargar estudio títulos H1
    decidir modelo único o híbrido coherente con H2
    declarar representación dual explícita
```

---

## 4. Plan firma H1 en 48 horas

### 4.1 · Versión firmable 48h · estructura propuesta

```yaml
documento_firmable_v1:
  
  §1_Identificacion:
    propietario: Felipe García Huidobro Sanfuentes
    mandatario: Xpert Urban SpA · representada por Max Medina Salinas
    declaracion_de_representacion_dual:
      "El Mandatario declara expresamente que también representa, en calidad de Estructurador,
       a Inversiones Magnus SpA respecto del mandato exclusivo otorgado por las hermanas Cominetti
       Infanti sobre Hijuela 2 de la Estancia La Higuera (Rep. 24.327 ante Notario X · 14-abr-2026).
       Las partes aceptan que esta representación dual es necesaria para la conformación de una
       coalición de negociación conjunta con Andes Iron SpA respecto del Sector Lineal del Proyecto
       Dominga, y se acuerdan las cláusulas de equidad y transparencia previstas en §7."
  
  §2_Inmuebles: (tomar tabla actual del borrador · ya está completa)
  
  §3_Antecedentes_pre_firma:
    El Mandatario se compromete a:
      a) Solicitar certificado de dominio vigente ante CBR La Serena dentro de 5 días hábiles
      b) Estudio títulos 20 años en plazo no superior a 30 días
      c) Asumir todos los costos asociados (modelo "sin costo para Mandante")
  
  §4_Modelo_remuneracion (la cláusula clave):
    opcion_A_Delta_del_Estructurador:
      Mandatario realiza estudios y determina Precio Base
      Mandante aprueba en 15 días hábiles (silencio = aprobación)
      Mandante recibe Precio Base íntegro a perfeccionamiento
      Delta = remuneración exclusiva Mandatario
      Sin costo para Mandante
    
    opcion_B_Comision_porcentaje:
      Mandante recibe precio efectivo de venta
      Mandatario recibe X% de comisión a perfeccionamiento
      Costos a cargo Mandatario
    
    opcion_recomendada: A_Delta_si_García_Huidobro_es_compatible
      ventaja: coherencia con modelo H2
      argumento_a_García_Huidobro:
        "el precio base será defendido al máximo + sin riesgo financiero para usted"
  
  §5_Plazo:
    6 meses prorrogables 3 meses por mutuo acuerdo
    coordinación con mesa Andes Iron (plazo crítico: antes que firme servidumbre H1 directa)
  
  §6_Autorizaciones:
    gestión ante DOM, SEREMI MINVU, SEC, SAG, BBNN, CBR, SII, Andes Iron, otros
    representación en mesa Andes Iron
    facultad de constituir coalición H1+H2 con XPU como vocero único
  
  §7_Coordinacion_con_H2_Cominetti:
    cláusula_de_equidad:
      "Las partes reconocen que el Mandatario también representa el mandato exclusivo
       de Inversiones Magnus SpA sobre Hijuela 2. En la coalición de negociación con Andes Iron,
       el Mandatario se compromete a:
         a) Defender precio base H1 con igual diligencia que precio base H2
         b) Asignar valor económico a H1 sin priorizar H2
         c) Si el presupuesto Andes Iron es insuficiente para ambas hijuelas, presentar
            propuesta de distribución proporcional por hectárea y características al Mandante
         d) Mantener al Mandante informado de avances y propuestas en mesa Andes Iron"
    
  §8_Cláusula_indemnidad:
    Mandatario indemniza al Mandante por costos de gestión asumidos por mandante (no aplica con modelo A)
    
  §9_Resolucion:
    incumplimiento grave + notificación 15 días para subsanar
    sin penalidad de salida sin justa causa
    
  §10_Firmas:
    Felipe García Huidobro Sanfuentes
    Max Medina Salinas p.p. Xpert Urban SpA
```

### 4.2 · Cronograma 48h

```yaml
día_1_mañana:
  completar §4 modelo remuneración (decisión: Delta o comisión)
  preparar texto firmable consensuado con asesor legal Magnus
  decidir si Inversiones Magnus SpA reemplaza a XPU como mandatario para coherencia con H2
  
día_1_tarde:
  contacto telefónico Felipe García Huidobro
  apertura conversacional: "Sr. García Huidobro, retomamos el documento de marzo. Hay novedades en mesa Andes Iron que ameritan firmar antes de fin de semana."
  agendar reunión zoom o presencial 24h
  
día_2_mañana:
  reunión con García Huidobro
  presentar versión final + discutir §4 + §7
  ajustes finales en sala
  
día_2_tarde:
  firma documento (presencial o digital)
  notificación a Cominetti de la coordinación coalición (transparencia)
  comunicación a mesa Andes Iron: "ahora representamos H1+H2 en coalición"
```

### 4.3 · Plan B · H2-solo si no se logra firma en 48h

```yaml
escenario_fracaso_firma_H1:
  H1_firma_servidumbre_Andes_Iron_directa: pérdida de leverage
  H2_queda_como_ancla_solitaria

plan_B_H2_solo:
  preparar estrategia H2 que asume H1 caído:
    
    1_renegociar_precio_base_H2_al_alza:
      argumento: si H1 firma servidumbre directa Andes Iron a precio X
                 H2 puede argumentar que el corredor no pasa sin su consentimiento
                 H2 tiene mejor capacidad de bloqueo PAS Art 96 que H1
                 H2 vale individualmente más que H1 prorrateado
    
    2_oferta_alternativa_a_Andes_Iron:
      cesión completa H2 (no solo servidumbre)
      relocalización del trazado en H2 más conveniente para Magnus
      desarrollo conjunto con Andes Iron sobre H2 post-servidumbre
    
    3_estrategia_judicial_si_H1_servidumbre_es_legalmente_atacable:
      Art 13 bis Ley 19.300 · acuerdos vinculantes
      EIA Dominga 2013 · vacíos estructurales
      PAS Art 96 · choke point regulatorio
```

---

## 5. Acción inmediata

```yaml
HOY (2026-05-31):
  1. validar diagnóstico con Max
  2. decidir vehículo: XPU sigue siendo mandatario H1 o Magnus consolida ambos?
  3. decidir modelo remuneración H1 (Delta vs comisión)
  4. asignar quién prepara versión firmable 48h (Max + asesor legal)
  5. contactar García Huidobro mañana

24h: versión firmable lista + contacto abierto
48h: firma o plan B activado
```

---

## 6. Lo que NO se diagnostica aquí (BLOQUEADO)

```yaml
BLOQUEADO_pendiente_validacion_humana:
  motivacion_real_de_Max_para_no_firmar_en_marzo (la afirmación "exclusividad Cominetti" requiere precisión)
  estado_actual_del_precio_base_H2 (¿determinado? ¿aprobado? ¿pendiente?)
  expectativa_economica_real_de_García_Huidobro
  oferta_concreta_de_Andes_Iron_para_servidumbre_H1
  estado_de_la_relacion_personal_Max-García_Huidobro
  capacidad_de_Magnus_o_XPU_para_financiar_estudios_y_gestiones_(modelo_Delta_requiere_capital_de_trabajo)
```

---

**Linkado:**
- [[HISTORIA_ESTANCIA_HIJUELAS_LA_HIGUERA_v1]]
- [[CANON_HIJUELA2_v2]]
- mandato firmado: `02_MANDATOS_CONTRATOS/MANDATO_EXCLUSIVA_COMINETTI_HIJUELA2_FINAL.docx`
- borrador no firmado: `02_MANDATOS_CONTRATOS/EXCLUSIVA_ESTANCIA_LA_HIGUERA_HIJUELA1_GARCIA_HUIDOBRO_2026.docx`
- [[doctrina-no-derivar-estrategia-sin-capa-ocupacion]] (alineado · primero firmar luego operar)
