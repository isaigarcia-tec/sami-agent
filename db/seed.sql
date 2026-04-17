-- ============================================================
-- SEED — Conocimiento inicial de SAMI
-- Campos Salesforce · Oportunidad EE a la Medida
-- Fuente: informe_salesforce_completo.html
-- ============================================================

-- ── TAB 1: Información Básica ─────────────────────────────────

INSERT INTO knowledge (categoria, subcategoria, titulo, contenido, api_name, tags) VALUES
('Campo Salesforce','Información Básica','Nombre de la Oportunidad',
 'Campo de texto obligatorio. Identifica de forma única la oportunidad dentro de Salesforce. Convención recomendada: [Empresa] - [Programa] - [Año]. Aparece en reportes, vistas de lista y en el pipeline del gestor.',
 'Name','oportunidad, nombre, identificador, titulo'),

('Campo Salesforce','Información Básica','Número de Oportunidad',
 'Campo autoincremental generado por Salesforce. Solo lectura. Se usa como referencia interna para rastrear la oportunidad en correos, tickets y comunicaciones con el cliente.',
 'OpportunityNumber__c','numero, folio, referencia, id'),

('Campo Salesforce','Información Básica','Cuenta (Empresa)',
 'Lookup obligatorio a la cuenta empresarial asociada. Representa la empresa cliente que solicita el programa EE a la Medida. Debe existir previamente en el CRM como registro de Cuenta.',
 'AccountId','cuenta, empresa, cliente, corporativo, organizacion'),

('Campo Salesforce','Información Básica','Nombre del Contacto Principal',
 'Lookup al contacto principal dentro de la empresa cliente. Es el interlocutor primario para comunicaciones, negociaciones y firma de contratos del programa educativo.',
 'ContactId','contacto, interlocutor, representante, persona'),

('Campo Salesforce','Información Básica','Etapa de la Oportunidad',
 'Picklist obligatoria que define el estado del proceso de venta. Valores: Prospecto, Diagnóstico, Propuesta, Negociación, Contrato, Ganada, Perdida, Cancelada. Determina la fase en el pipeline y activa automations de Power Automate.',
 'StageName','etapa, fase, estado, pipeline, proceso, embudo'),

('Campo Salesforce','Información Básica','Fecha de Cierre',
 'Fecha esperada de firma del contrato o cierre de la oportunidad. Campo obligatorio para Salesforce. Se usa en reportes de forecast y pipeline por mes/trimestre.',
 'CloseDate','fecha, cierre, firma, contrato, plazo'),

('Campo Salesforce','Información Básica','Probabilidad de Cierre',
 'Porcentaje (0-100%) de probabilidad de ganar la oportunidad. Se calcula automáticamente según la Etapa, pero puede editarse manualmente. Afecta directamente el forecast ponderado del gestor.',
 'Probability','probabilidad, forecast, porcentaje, ponderado'),

('Campo Salesforce','Información Básica','Importe Estimado',
 'Valor económico total estimado del programa EE a la Medida en pesos MXN. Se usa en reportes de revenue, dashboards de gestores y para calcular el importe gestionado del portafolio.',
 'Amount','importe, monto, valor, precio, revenue, ingresos'),

('Campo Salesforce','Información Básica','Tipo de Oportunidad',
 'Picklist que clasifica la naturaleza de la oportunidad. Valores comunes: Programa Nuevo, Renovación, Ampliación, Cross-sell, Up-sell. Afecta métricas de retención de clientes.',
 'Type','tipo, clasificacion, categoria, renovacion, nuevo'),

('Campo Salesforce','Información Básica','Propietario / Gestor',
 'Lookup al usuario de Salesforce responsable de la oportunidad. Es el gestor comercial o ejecutivo de cuenta asignado. Determina quién ve la oportunidad en vistas personales y quién recibe notificaciones.',
 'OwnerId','propietario, gestor, ejecutivo, responsable, dueno'),

('Campo Salesforce','Información Básica','Fuente del Lead',
 'Picklist que indica cómo llegó esta oportunidad. Valores: Referido, Evento, Redes Sociales, Portal Web, Llamada en frío, Cliente existente, Alumni, Otro. Importante para métricas de marketing.',
 'LeadSource','fuente, origen, como llego, marketing, canal'),

('Campo Salesforce','Información Básica','Descripción',
 'Campo de texto largo (notas). Permite al gestor capturar contexto sobre la oportunidad: necesidades del cliente, antecedentes, acuerdos verbales, próximos pasos. No es campo de búsqueda principal.',
 'Description','descripcion, notas, comentarios, contexto, observaciones');

-- ── TAB 2: EE a la Medida ─────────────────────────────────────

INSERT INTO knowledge (categoria, subcategoria, titulo, contenido, api_name, tags) VALUES
('Campo Salesforce','EE a la Medida','Modalidad del Programa',
 'Picklist que define cómo se imparte el programa. Valores: Presencial, En línea (síncrono), En línea (asíncrono), Híbrido, Mixto. Afecta la logística, costos y disponibilidad de profesores.',
 'Modalidad__c','modalidad, presencial, online, hibrido, sincrono, asincrono'),

('Campo Salesforce','EE a la Medida','Duración Total (horas)',
 'Número de horas totales del programa educativo acordado con el cliente. Se usa para calcular el costo por hora, diseñar el cronograma y dimensionar el esfuerzo docente.',
 'DuracionHoras__c','duracion, horas, longitud, extension'),

('Campo Salesforce','EE a la Medida','Número de Participantes',
 'Cantidad de personas de la empresa cliente que tomarán el programa. Es determinante para el precio total, el tamaño del grupo, disponibilidad de aulas/plataforma y materiales.',
 'NumParticipantes__c','participantes, personas, grupo, alumnos, colaboradores'),

('Campo Salesforce','EE a la Medida','Área Temática',
 'Picklist que clasifica el campo de conocimiento del programa. Valores: Liderazgo, Tecnología, Innovación, Finanzas, Operaciones, Marketing, Recursos Humanos, Sostenibilidad, Legal, Otro.',
 'AreaTematica__c','area, tema, disciplina, campo, conocimiento, materia'),

('Campo Salesforce','EE a la Medida','Nivel del Programa',
 'Picklist que indica el perfil del participante objetivo. Valores: Operativo, Mandos Medios, Alta Dirección, Mixto. Determina el nivel de los profesores asignados y el diseño curricular.',
 'NivelPrograma__c','nivel, perfil, directivo, gerencial, operativo, mandos'),

('Campo Salesforce','EE a la Medida','Idioma de Impartición',
 'Picklist del idioma principal del programa. Valores: Español, Inglés, Bilingüe (ES/EN), Portugués. Afecta asignación de profesores y costos adicionales por traducción o materiales.',
 'IdiomaPrograma__c','idioma, español, ingles, bilingue, lenguaje'),

('Campo Salesforce','EE a la Medida','Sede / Ciudad de Impartición',
 'Ciudad y/o instalación donde se impartirá el programa presencial o híbrido. Relevante para coordinar logística, viáticos de profesores y disponibilidad de espacios del Tec.',
 'SedeImparticion__c','sede, ciudad, lugar, instalacion, campus, locacion'),

('Campo Salesforce','EE a la Medida','Fechas Propuestas de Inicio',
 'Rango de fechas sugeridas por el cliente para iniciar el programa. El gestor captura esto para coordinar disponibilidad de profesores y agendar el diagnóstico de necesidades.',
 'FechasPropiestasInicio__c','fecha, inicio, arranque, cuando, calendario'),

('Campo Salesforce','EE a la Medida','Necesidades Específicas del Cliente',
 'Texto libre donde el gestor documenta los pain points, objetivos de aprendizaje y retos que el cliente quiere resolver con el programa. Es la base para el diseño curricular.',
 'NecesidadesCliente__c','necesidades, objetivos, retos, pain points, problemas, expectativas'),

('Campo Salesforce','EE a la Medida','Personalización Requerida',
 'Picklist de nivel de personalización. Valores: Estándar (catálogo), Adaptado (ajustes menores), A medida completa (diseño desde cero), Co-creado con cliente. Determina el esfuerzo de diseño instruccional.',
 'NivelPersonalizacion__c','personalizacion, customizacion, ajuste, diseno, instruccional'),

('Campo Salesforce','EE a la Medida','Certificación Incluida',
 'Checkbox + Tipo. Indica si el programa incluye una certificación al finalizar. Puede ser: Constancia Tec, Diplomado, Certificación internacional (e.g. PMP, Scrum), Badge digital.',
 'CertificacionIncluida__c','certificacion, diploma, constancia, badge, reconocimiento'),

('Campo Salesforce','EE a la Medida','Incluye Diagnóstico Inicial',
 'Checkbox. Si está activo, el programa incluye una fase de diagnóstico de competencias o necesidades antes de arrancar. Agrega costo y tiempo al proyecto pero mejora la personalización.',
 'IncluyeDiagnostico__c','diagnostico, evaluacion, assessment, inicial, competencias');

-- ── TAB 3: Datos del Programa ─────────────────────────────────

INSERT INTO knowledge (categoria, subcategoria, titulo, contenido, api_name, tags) VALUES
('Campo Salesforce','Datos del Programa','Nombre Oficial del Programa',
 'Nombre formal que aparecerá en constancias, contratos y materiales de difusión. Acordado con el cliente. Ejemplo: "Programa de Liderazgo Transformacional para Directivos de FEMSA".',
 'NombreOficialPrograma__c','nombre, oficial, titulo, programa, constancia'),

('Campo Salesforce','Datos del Programa','Código del Programa',
 'Código interno del Tec para identificar el programa en sistemas académicos, facturación y reportes. Se genera una vez confirmada la oportunidad. Formato: EAM-[AÑO]-[CONSECUTIVO].',
 'CodigoPrograma__c','codigo, clave, folio, interno'),

('Campo Salesforce','Datos del Programa','Unidad Académica Responsable',
 'Escuela o departamento del Tec que diseña e imparte el programa. Ejemplo: EGADE Business School, Escuela de Ingeniería, Escuela de Gobierno. Define el pool de profesores disponibles.',
 'UnidadAcademica__c','unidad, escuela, departamento, facultad, egade, ingenieria'),

('Campo Salesforce','Datos del Programa','Director del Programa',
 'Profesor o académico del Tec que lidera el diseño curricular y es el contacto académico para el cliente. No necesariamente imparte todas las sesiones.',
 'DirectorPrograma__c','director, academico, lider, coordinador'),

('Campo Salesforce','Datos del Programa','Número de Módulos',
 'Cantidad de módulos o bloques temáticos en que se divide el programa. Cada módulo puede tener su propio profesor, evaluación y materiales. Impacta el costo de coordinación.',
 'NumModulos__c','modulos, bloques, sesiones, partes, division'),

('Campo Salesforce','Datos del Programa','Formato de Evaluación',
 'Picklist. Cómo se evaluará a los participantes. Valores: Sin evaluación, Participación, Proyecto final, Examen, Portfolio, Mixto. Determina si se emite calificación o solo constancia de asistencia.',
 'FormatoEvaluacion__c','evaluacion, calificacion, examen, proyecto, asistencia'),

('Campo Salesforce','Datos del Programa','Materiales Incluidos',
 'Picklist múltiple de materiales que se entregan al participante. Opciones: Lecturas digitales, Libro de texto, Acceso a plataforma LMS, Kit físico, Licencias de software, Casos de estudio.',
 'MaterialesIncluidos__c','materiales, libros, recursos, plataforma, lms, kit'),

('Campo Salesforce','Datos del Programa','Plataforma Tecnológica',
 'Picklist. Sistema o herramienta principal para impartir el programa en línea o gestionar materiales. Valores: Canvas, Brightspace (D2L), Teams, Zoom, Plataforma propia del cliente, Sin plataforma.',
 'PlataformaTecnologica__c','plataforma, tecnologia, canvas, teams, zoom, lms, herramienta'),

('Campo Salesforce','Datos del Programa','Requiere Visita a Instalaciones del Cliente',
 'Checkbox. Si el diseño instruccional implica que el equipo del Tec visite las instalaciones del cliente para hacer un diagnóstico in situ, levantamiento de información o talleres presenciales.',
 'RequiereVisita__c','visita, instalaciones, cliente, presencial, levantamiento'),

('Campo Salesforce','Datos del Programa','Campus Tec Involucrados',
 'Picklist múltiple. Cuando el programa se imparte en más de un campus del Tec o involucra profesores de distintas sedes. Relevante para programas nacionales o multi-sede.',
 'CampusInvolucrados__c','campus, sedes, nacional, regional, monterrey, cdmx');

-- ── TAB 4: Ejecución ─────────────────────────────────────────

INSERT INTO knowledge (categoria, subcategoria, titulo, contenido, api_name, tags) VALUES
('Campo Salesforce','Ejecución','Fecha de Inicio Real',
 'Fecha en que arrancó efectivamente el programa (puede diferir de la propuesta). Se captura una vez confirmada la primera sesión. Clave para medir puntualidad y adherencia al calendario.',
 'FechaInicioReal__c','inicio real, arranque, primera sesion, inicio efectivo'),

('Campo Salesforce','Ejecución','Fecha de Cierre Real',
 'Fecha en que terminó el programa. Junto con la fecha de inicio real, permite calcular la duración total real y comparar con lo planificado. Requisito para cerrar la oportunidad como Ganada.',
 'FechaCierreReal__c','cierre real, termino, fin, finalizacion'),

('Campo Salesforce','Ejecución','Estatus de Ejecución',
 'Picklist que refleja el estado operativo del programa en curso. Valores: Por iniciar, En curso, En pausa, Finalizado, Cancelado. Diferente a la Etapa (que es la fase de venta).',
 'EstatusEjecucion__c','estatus, estado, ejecucion, operativo, curso, finalizado'),

('Campo Salesforce','Ejecución','Porcentaje de Avance',
 'Número de 0 a 100 que el gestor o el director del programa actualiza periódicamente para reflejar el avance real. Se usa en dashboards de seguimiento de programas en curso.',
 'PorcentajeAvance__c','avance, progreso, porcentaje, completado'),

('Campo Salesforce','Ejecución','Satisfacción del Cliente (NPS)',
 'Puntuación Net Promoter Score capturada al finalizar el programa mediante encuesta al cliente corporativo (no a los participantes individuales). Escala 0-10.',
 'NPSCliente__c','nps, satisfaccion, encuesta, calificacion, opinion, feedback'),

('Campo Salesforce','Ejecución','Asistencia Promedio (%)',
 'Porcentaje promedio de asistencia de los participantes a lo largo del programa. Se calcula con los datos del LMS o registro físico. Bajo porcentaje puede indicar problemas de engagement.',
 'AsistenciaPromedio__c','asistencia, participacion, engagement, presencia'),

('Campo Salesforce','Ejecución','Incidencias Registradas',
 'Texto libre o número. Documenta problemas ocurridos durante la ejecución: cancelaciones de sesiones, cambios de profesor, problemas técnicos, insatisfacción del cliente. Insumo para mejora continua.',
 'IncidenciasRegistradas__c','incidencias, problemas, cancelaciones, errores, retrasos'),

('Campo Salesforce','Ejecución','Facturación Emitida',
 'Monto total facturado al cliente hasta la fecha. Puede diferir del importe estimado si hubo ajustes, addendas o cancelaciones parciales. Se reconcilia con el área de finanzas.',
 'FacturacionEmitida__c','facturacion, factura, cobro, monto, pagado, importe real'),

('Campo Salesforce','Ejecución','Fecha de Último Contacto',
 'Fecha de la última interacción registrada con el cliente (llamada, correo, reunión). Actualizable desde Activity Timeline de Salesforce. Alerta si lleva más de X días sin contacto.',
 'UltimoContacto__c','contacto, seguimiento, ultimo, comunicacion, actividad'),

('Campo Salesforce','Ejecución','Próxima Acción',
 'Texto libre o tarea vinculada que describe el siguiente paso concreto del gestor. Ejemplo: "Enviar propuesta económica el viernes", "Agendar call de kick-off". Clave para el seguimiento comercial.',
 'ProximaAccion__c','proxima accion, siguiente paso, tarea, seguimiento, compromiso');

-- ── TAB 5: Colaboradores ──────────────────────────────────────

INSERT INTO knowledge (categoria, subcategoria, titulo, contenido, api_name, tags) VALUES
('Campo Salesforce','Colaboradores','Profesores Asignados',
 'Lista de profesores o facilitadores del Tec asignados al programa. Puede ser un lookup múltiple a la tabla de Contactos (perfil Profesor) o texto libre con nombres. Coordinados por el Director del Programa.',
 'ProfesoresAsignados__c','profesores, facilitadores, instructores, academia, maestros'),

('Campo Salesforce','Colaboradores','Coordinador Operativo',
 'Persona del área de operaciones del Tec responsable de la logística: reserva de aulas, envío de materiales, comunicaciones administrativas con el cliente. Diferente al gestor comercial.',
 'CoordinadorOperativo__c','coordinador, operativo, logistica, administracion, soporte'),

('Campo Salesforce','Colaboradores','Equipo de Diseño Instruccional',
 'Diseñadores instruccionales que desarrollan el material del curso, los recursos digitales y las actividades de aprendizaje. Pueden ser internos del Tec o externos contratados para el proyecto.',
 'DisenoInstruccional__c','diseno instruccional, contenido, curriculum, materiales, pedagogia'),

('Campo Salesforce','Colaboradores','Área de Ventas Involucrada',
 'Picklist o texto que indica qué área o región de ventas del Tec tiene ownership de la cuenta. Importante para correcta asignación de cuotas, comisiones y reportes territoriales.',
 'AreaVentas__c','ventas, region, territorio, cuota, comision'),

('Campo Salesforce','Colaboradores','Patrocinador Ejecutivo del Tec',
 'Directivo del Tec (decano, rector regional, VP) que avala o patrocina el programa ante el cliente. Mencionado en propuestas y contratos de programas de alta dirección.',
 'PatrocinadorEjecutivo__c','patrocinador, directivo, decano, rector, aval, sponsor'),

('Campo Salesforce','Colaboradores','Contacto Financiero del Cliente',
 'Persona en la empresa cliente responsable del proceso de facturación, órdenes de compra y pagos. Diferente al contacto académico o al tomador de decisión del programa.',
 'ContactoFinancieroCliente__c','contacto financiero, facturacion, pagos, compras, tesoreria'),

('Campo Salesforce','Colaboradores','Tomador de Decisión (Cliente)',
 'El ejecutivo en la empresa cliente con autoridad final para aprobar y firmar el contrato del programa. Puede ser diferente al contacto principal operativo. Clave para las últimas etapas del ciclo de venta.',
 'TomadorDecision__c','tomador decision, aprobador, autoriza, firma, ceo, director');

-- ── Conocimiento General del Agente ──────────────────────────

INSERT INTO knowledge (categoria, subcategoria, titulo, contenido, api_name, tags) VALUES
('Proceso','Ciclo de Venta','Proceso completo EE a la Medida — del prospecto al cierre',
 'El ciclo de una oportunidad EE a la Medida tiene 7 etapas: 1) Prospecto — primer contacto, se captura la oportunidad en Salesforce con datos básicos. 2) Diagnóstico — reunión de levantamiento de necesidades, se completan los campos del Tab EE a la Medida. 3) Propuesta — se elabora la propuesta académica y económica, se actualiza Importe Estimado. 4) Negociación — ajustes a propuesta, fechas, precio. 5) Contrato — firma del convenio o carta compromiso. 6) Ganada — programa confirmado, inicia ejecución. 7) Perdida/Cancelada — se documenta la razón en campo Descripción.',
 NULL,'proceso, etapas, ciclo, venta, pipeline, como funciona'),

('Proceso','Facturación','Proceso de facturación y pagos',
 'La facturación de programas EE a la Medida generalmente se estructura en hitos: 30% al firma del contrato, 30% al inicio del programa, 40% al cierre. El gestor captura en Salesforce la Facturación Emitida en el Tab de Ejecución. El área de Finanzas emite la factura contra la Orden de Compra del cliente. El Contacto Financiero del Cliente es quien autoriza el pago.',
 NULL,'facturacion, pagos, hitos, cobro, orden de compra'),

('Proceso','Reportes','KPIs y métricas del portafolio EE a la Medida',
 'Los reportes principales del portafolio incluyen: Pipeline por etapa (forecast ponderado), Importe Gestionado por gestor y región, Tasa de conversión por etapa, NPS promedio de programas cerrados, Horas de formación impartidas, Número de participantes atendidos, Revenue real vs. estimado. Estos reportes se construyen desde la vista de Oportunidades en Salesforce filtrando por Tipo = EE a la Medida.',
 NULL,'kpis, metricas, reportes, pipeline, importe, revenue, gestor'),

('FAQ','Uso Salesforce','¿Cómo creo una nueva oportunidad EE a la Medida?',
 'Pasos: 1) Ve a la pestaña Oportunidades en Salesforce. 2) Clic en "Nueva". 3) Selecciona el Tipo "EE a la Medida". 4) Llena los campos obligatorios: Nombre, Cuenta, Etapa (Prospecto), Fecha de Cierre estimada, Importe estimado. 5) Guarda. 6) Luego completa los tabs: EE a la Medida y Datos del Programa con la información del diagnóstico. 7) Actualiza la Etapa conforme avanza el proceso.',
 NULL,'como crear, nueva oportunidad, pasos, tutorial, guia'),

('FAQ','Uso Salesforce','¿Qué campos son obligatorios?',
 'Los campos obligatorios en Salesforce para una oportunidad EE a la Medida son: Nombre de la Oportunidad, Cuenta, Etapa, Fecha de Cierre, Importe Estimado y Propietario. Los demás campos se van completando conforme avanza el ciclo de venta. Se recomienda también completar Fuente del Lead, Modalidad, Número de Participantes y Área Temática desde el inicio.',
 NULL,'obligatorios, requeridos, campos, minimo'),

('FAQ','Uso Salesforce','¿Cómo funciona el forecast y la probabilidad?',
 'Salesforce asigna automáticamente una probabilidad según la Etapa: Prospecto=10%, Diagnóstico=20%, Propuesta=40%, Negociación=60%, Contrato=80%, Ganada=100%, Perdida=0%. El Importe Ponderado del forecast se calcula como Importe x Probabilidad. El gestor puede ajustar la probabilidad manualmente si tiene información que la Etapa no refleja. Los reportes de forecast usan el importe ponderado para proyectar el revenue esperado.',
 NULL,'forecast, probabilidad, ponderado, proyeccion, revenue'),

('Agente','SAMI','¿Quién eres? ¿Qué haces?',
 'Soy SAMI, el Asistente de Salesforce para Educación a la Medida del Tec de Monterrey. Estoy aquí para ayudarte con cualquier duda sobre los campos de Salesforce, el proceso de venta de programas EE a la Medida, cómo usar el CRM, qué significa cada etapa, cómo interpretar métricas, o cualquier otra pregunta que tengas. Si algo no lo sé con certeza, te lo digo con claridad y te oriento hacia la persona correcta.',
 NULL,'quien eres, sami, asistente, ayuda, que haces'),

('Agente','SAMI','Capacidades y alcance de SAMI',
 'SAMI puede ayudarte con: Explicar cualquier campo de Salesforce (Tab Información Básica, EE a la Medida, Datos del Programa, Ejecución, Colaboradores), describir el ciclo de venta EE a la Medida, explicar procesos de facturación y pagos, orientarte sobre KPIs y reportes, responder preguntas sobre el Tec de Monterrey y sus programas corporativos, y dar respuestas generales sobre cualquier tema educativo o de negocios. Mi conocimiento principal es Salesforce EE a la Medida, pero puedo ayudarte con otras preguntas también.',
 NULL,'capacidades, alcance, que puede, funciones, ayuda');
