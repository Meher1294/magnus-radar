// =============================================================================
// Magnus Radar · ITS v2 · Data hardcoded de Hijuela 2 Cominetti
// 2026-05-31 · estructura espejo de schema 0002 + 0002b
// Reemplazable por queries Supabase REST en v0.1
// =============================================================================

export const HIJUELA_2 = {
  unidad: {
    codigo: 'hijuela_2_cominetti',
    nombre: 'Hijuela 2 de la Estancia La Higuera',
    territorio: 'Estancia La Higuera',
    roles_sii: ['24-123', '24-160'],
    comuna: 'La Higuera',
    provincia: 'Elqui',
    region: 'Coquimbo',
    estado: 'identificado',
    mandato: {
      mandataria: 'Inversiones Magnus SpA',
      repertorio: 'Rep. N°24.327',
      fecha: '2026-04-14',
      plazo_meses: 24,
      comision_pct: 10
    },
    ultima_actualizacion: '2026-05-31',
    conflictos_abiertos_count: 13
  },

  superficies: [
    {
      codigo: 's_historica_matriz_jarpa_1990',
      valor_ha: 2642.00,
      capa: 'HISTÓRICA',
      capa_temporal: 1,
      año: 1990,
      fuente_short: 'CBR fs.97 N°91/1990',
      composicion: 'Lote a 1.163 + Lote b 1.479',
      estado: 'verificado'
    },
    {
      codigo: 's_juridica_consolidada_2017',
      valor_ha: 2139.35,
      capa: 'JURÍDICA',
      capa_temporal: 3,
      año: 2017,
      fuente_short: 'Estudio títulos',
      composicion: 'Resto A 863 + Resto B 976,35 + Lote C 300',
      estado: 'verificado'
    },
    {
      codigo: 's_operacional_rtk_2026',
      valor_ha: 2164.97,
      capa: 'RTK',
      capa_temporal: 5,
      año: 2026,
      fuente_short: 'RTK Daniel Magnus',
      composicion: '77 vértices · WGS84 UTM 19S ±10m',
      estado: 'verificado'
    },
    {
      codigo: 's_mandato_declarada_2026',
      valor_ha: 1800,
      capa: 'MANDATO',
      capa_temporal: 6,
      año: 2026,
      fuente_short: 'Repertorio 24.327',
      composicion: 'Cifra declarada con cláusula de excedente',
      estado: 'verificado'
    },
    {
      codigo: 's_fiscal_sii',
      conflicto_id: 'SII_SURFACE_FACTOR_100',
      capa: 'FISCAL · SII',
      capa_temporal: 7,
      año: 2026,
      valores_observados: [
        { fuente: 'Data Inmobiliaria BQ', valor_ha: 26.41 },
        { fuente: 'Due Diligence 2026', valor_ha: 2640.93 }
      ],
      autoridad_resolutiva: 'sii_directo',
      estado: 'conflicto_documentado'
    }
  ],

  autoridades: [
    { dominio: 'Rol SII',                autoridad: 'SII oficial',                  estado: 'verificado',                    capa: 7 },
    { dominio: 'Avalúo fiscal',          autoridad: 'SII oficial',                  estado: 'verificado',                    capa: 7 },
    { dominio: 'Contribuciones',         autoridad: 'SII oficial',                  estado: 'verificado',                    capa: 7 },
    { dominio: 'Superficie fiscal SII',  autoridad: 'SII directo (pendiente)',      estado: 'conflict',                      capa: 7 },
    { dominio: 'Cabida jurídica',        autoridad: 'Estudio de títulos consolidado', estado: 'verificado',                  capa: 3 },
    { dominio: 'Geom. jurídica vigente', autoridad: 'Plano N°377-2006 + cadena',    estado: 'pending',                       capa: 4 },
    { dominio: 'Geom. operacional',      autoridad: 'RTK Daniel Martínez 2026',     estado: 'verificado',                    capa: 5 },
    { dominio: 'Geom. histórica',        autoridad: 'Plano MBN IV-1-1777-S.R.',     estado: 'identified',                    capa: 1 },
    { dominio: 'Infraestructura',        autoridad: 'KMZ DataRoom 2026-04 (aux)',   estado: 'verificado',                    capa: 4 },
    { dominio: 'Contexto envolvente',    autoridad: 'Andes Iron · Rol 24-5 60K ha', estado: 'verificado',                    capa: 6 },
    { dominio: 'Servidumbres',           autoridad: 'CBR La Serena',                estado: 'partial',                       capa: 2 },
    { dominio: 'Conflictos abiertos',    autoridad: 'CANON §7',                     estado: 'verificado',                    capa: null },
    { dominio: 'Mandato',                autoridad: 'Repertorio N°24.327',          estado: 'verificado',                    capa: 6 }
  ],

  conflictos: [
    {
      codigo: 'SII_SURFACE_FACTOR_100',
      severidad: 'alta',
      tipo: 'divergencia_superficie',
      descripcion: 'Factor 100 entre DI BQ (26,41 ha) y DD (2.640,93 ha)',
      autoridad_resolutiva: 'SII directo',
      accion: 'Consulta presencial mapas.sii.cl rol 4102-24-123'
    },
    {
      codigo: 'GAP_PLANO_22_1990',
      severidad: 'media',
      tipo: 'gap_documental',
      descripcion: 'Plano N°22/1990 localizado como anexo CBR, pendiente extracción',
      autoridad_resolutiva: 'CBR La Serena',
      accion: 'Solicitud copia certificada anexo N°22/1990'
    },
    {
      codigo: 'GAP_VENTA_VELASQUEZ_PRE_1996',
      severidad: 'media',
      tipo: 'gap_documental',
      descripcion: 'Venta franja sur Lote B ~502 ha a Velásquez · hipotesis_de_trabajo',
      autoridad_resolutiva: 'CBR La Serena',
      accion: 'Búsqueda registral inscripción específica 1990-1996'
    },
    {
      codigo: 'GAP_CAJETIN_PLANO_MBN',
      severidad: 'media',
      tipo: 'gap_documental',
      descripcion: 'Falta cajetín, autor, escala, datum, fecha exacta del plano MBN',
      autoridad_resolutiva: 'CBR La Serena',
      accion: 'Foto adicional o copia certificada CBR'
    },
    {
      codigo: 'GAP_MUTACION_CATASTRAL_24_4_A_24_123_24_160',
      severidad: 'media',
      tipo: 'rol_no_equivalente',
      descripcion: 'Cuándo y bajo qué resolución cambia 24-4 a 24-123 + 24-160',
      autoridad_resolutiva: 'SII directo',
      accion: 'Certificado SII historial cambios de rol'
    },
    {
      codigo: 'GAP_DESLINDE_EL_MOLLE',
      severidad: 'baja',
      tipo: 'deslinde_no_definido',
      descripcion: 'Predio aledaño sur Lote b (Jaime Ugarte Lee + Julio Brito Riffo) no caracterizado',
      autoridad_resolutiva: 'CBR + SII propio',
      accion: 'Identificar rol SII actual + dominio actual'
    }
  ],

  representaciones: [
    {
      codigo: 'G1',
      tipo: 'historica',
      fuente: 'MBN IV-1-1777-S.R.',
      año: 1990,
      estado: 'identified',
      superficie_ha: 2642.00,
      meta: 'cuerpo extraído · cajetín pendiente',
      datum: 'PSAD56 (atribución previa)',
      thumb_desc: '6 hijuelas · vértices A-M'
    },
    {
      codigo: 'G2',
      tipo: 'jurídica',
      fuente: 'Plano N°531/1992',
      año: 1992,
      estado: 'pending',
      superficie_ha: 1163,
      meta: 'subdivisión Lote A: Lote C 300 + Resto A 863',
      thumb_desc: 'planim. 21 láminas · pendiente'
    },
    {
      codigo: 'G3',
      tipo: 'operacional intermedia',
      fuente: 'DataRoom_Cominetti.kmz',
      año: 2026,
      estado: 'superseded',
      superficie_ha: 2640,
      meta: '2.640 ha sin capa · errores documentales conocidos',
      thumb_desc: 'KMZ XPU 25 vértices'
    },
    {
      codigo: 'G4',
      tipo: 'medición RTK',
      fuente: 'PERIMETRO_CBR_DANIEL_RTK10M_V1',
      año: 2026,
      estado: 'verificado',
      superficie_ha: 2164.97,
      meta: '77 vértices · WGS84 UTM 19S · ±10m',
      thumb_desc: 'RTK polígono completo'
    }
  ],

  cadena_registral: [
    { año: 1990, capa: 1, tipo: 'saneamiento_dl_2695', label: 'Saneamiento\nDL 2.695',         estado: 'verificado', importancia: 'big', inscripcion: 'fs.97 N°91/1990', desc: 'Saneamiento Jarpa · 2.642 ha · plano MBN IV-1-1777-S.R.' },
    { año: 1992, capa: 2, tipo: 'subdivision',         label: 'Subdiv. Lote A\nPlano N°531',   estado: 'pending',    importancia: 'med', inscripcion: 'fs.4.531/1992', desc: 'Lote C 300 ha + Resto A 863 ha · pendiente extracción' },
    { año: 1996, capa: 2, tipo: 'compraventa',         label: 'CV Bruno +\nVirginia',           estado: 'verificado', importancia: 'big', inscripcion: 'fs.1.994 N°1.813/1996', desc: 'Jarpa → Bruno Luigi Cominetti (85%) + Virginia Castillo (15%)' },
    { año: 2000, capa: 3, tipo: 'cesion_derechos',     label: 'Cesión Virginia\n→ Bruno',       estado: 'verificado', importancia: 'med', inscripcion: 'fs.838 N°754/2000', desc: 'Virginia Castillo cede 15% a Bruno · CLP 13M' },
    { año: 2006, capa: 3, tipo: 'plano_registrado',    label: 'Planos\n377-397',                estado: 'pending',    importancia: 'big', inscripcion: '21 láminas coordinadas', desc: 'Paquete coordinado de planos · motor geométrico probable · pendiente extracción' },
    { año: 2014, capa: 4, tipo: 'compraventa',         label: 'Cofanti\ncompra',                estado: 'verificado', importancia: 'med', inscripcion: 'Rep FS 209 N°7.711', desc: 'Bruno → Inversiones Cofanti Ltda. · CLP 25M' },
    { año: 2017, capa: 4, tipo: 'adjudicacion_particion', label: 'Adjudic. 4\nherman. C.I.',    estado: 'verificado', importancia: 'big', inscripcion: 'Rep FS 694 N°26.309', desc: 'Disolución Cofanti + adjudicación a 4 hermanos Cominetti Infanti' },
    { año: 2023, capa: 4, tipo: 'dacion_pago',         label: 'Dación pago\n→ Cantera',         estado: 'verificado', importancia: 'med', inscripcion: '23-ene-2023', desc: 'Bruno Guillermo → Agrícola Cantera Ltda. · 25%' },
    { año: 2026, capa: 6, tipo: 'mandato',             label: 'Mandato\nMagnus',                estado: 'verificado', importancia: 'big', inscripcion: 'Rep. N°24.327', desc: 'Mandato exclusivo 24 meses · comisión 10% · 1.800 ha declaradas' }
  ],

  titulares: [
    { nombre: 'Silvia María Cominetti Infanti',        rut: '7.011.575-1', pct: 18.75, tipo: 'persona_natural' },
    { nombre: 'Claudia Cecilia Cominetti Infanti',     rut: '7.011.576-K', pct: 18.75, tipo: 'persona_natural' },
    { nombre: 'Lidia Rosa V. Cominetti Infanti',       rut: '6.349.740-1', pct: 18.75, tipo: 'persona_natural' },
    { nombre: 'Sucesión Bruno G. Cominetti Infanti',   rut: null,          pct: 18.75, tipo: 'sucesion' },
    { nombre: 'Agrícola Cantera Limitada',             rut: null,          pct: 25.00, tipo: 'persona_juridica' }
  ],

  hipotesis: [
    {
      codigo: 'HIP_VELASQUEZ_PRE_1996',
      descripcion: 'Venta franja sur Lote B ~502 ha a Heriberto H. Velásquez Gallardo pre-1996 como pago en especie por agrimensura plano MBN',
      estado: 'hipotesis_de_trabajo',
      promovible_si: 'Localizar inscripción CBR específica 1990-1996',
      contexto_temporal: 'entre 1992 y 1996'
    },
    {
      codigo: 'HIP_MOTOR_GEOMETRICO_2006',
      descripcion: 'Planos 377-397/2006 son reescritura espacial coordinada (motor geométrico, no solo registro)',
      estado: 'hipotesis_de_trabajo',
      promovible_si: 'Extraer Plano General N°377-2006 y verificar contenido',
      contexto_temporal: 'entre 2006 y 2014'
    }
  ],

  contexto_envolvente: {
    territorio_matriz: 'Estancia La Higuera',
    rol_matriz: '24-5',
    superficie_aprox_ha: 60000,
    titular_matriz: 'Andes Iron SpA',
    rut_matriz: '76.097.759-4',
    fecha_adquisicion: '2021-08-16',
    precio_uf: 273292.2657,
    nota: 'Hijuela 2 Cominetti es enclave dentro de la matriz Andes Iron.'
  }
};
