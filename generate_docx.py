from docx import Document
from docx.shared import Pt, RGBColor, Cm
from docx.enum.text import WD_ALIGN_PARAGRAPH

doc = Document()

style_normal = doc.styles["Normal"]
style_normal.font.name = "Calibri"
style_normal.font.size = Pt(11)


def h(level, text):
    heading = doc.add_heading(text, level=level)
    for run in heading.runs:
        run.font.name = "Calibri"
    return heading


def p(text="", bold=False, italic=False, indent=False):
    para = doc.add_paragraph()
    if indent:
        para.paragraph_format.left_indent = Cm(1)
    if text:
        run = para.add_run(text)
        run.bold = bold
        run.italic = italic
        run.font.name = "Calibri"
        run.font.size = Pt(11)
    return para


def code(text):
    para = doc.add_paragraph()
    para.paragraph_format.left_indent = Cm(1)
    run = para.add_run(text)
    run.font.name = "Courier New"
    run.font.size = Pt(9)
    return para


# ===================== PORTADA =====================
title_p = doc.add_paragraph()
title_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
r = title_p.add_run("RUNNERS – PLATAFORMA MÓVIL DE SERVICIOS, DOMICILIOS Y TIENDA LOCAL")
r.bold = True
r.font.size = Pt(16)
r.font.name = "Calibri"
r.font.color.rgb = RGBColor(0x1F, 0x49, 0x7D)

doc.add_paragraph()
sub = doc.add_paragraph()
sub.alignment = WD_ALIGN_PARAGRAPH.CENTER
r2 = sub.add_run(
    "Trabajo académico presentado como parte del desarrollo de un proyecto de software"
)
r2.font.size = Pt(12)
r2.font.name = "Calibri"

doc.add_paragraph()
pres = doc.add_paragraph()
pres.alignment = WD_ALIGN_PARAGRAPH.CENTER
r3 = pres.add_run(
    "Presentado por:\nEquipo de Desarrollo – Runners\n\nUniversidad del Valle\n2025"
)
r3.font.size = Pt(12)
r3.font.name = "Calibri"

doc.add_page_break()

# ===================== 1. RUNNERS =====================
h(1, "1. Runners")
p(
    "Plataforma Móvil Integral para la Gestión de Servicios Locales, Domicilios y Tienda Comunitaria",
    bold=True,
)
p()
p(
    "Runners es una aplicación móvil desarrollada en Flutter que conecta a usuarios de una comunidad con tres servicios clave: una tienda local (comercios y productos), un módulo de domicilios (envíos con asignación automática de repartidores) y un directorio de servicios profesionales (prestadores del hogar, técnicos, profesionales independientes). Además, cuenta con un directorio de contactos de emergencia y utilidad, así como un panel de administración para la gestión global de la plataforma."
)

# ===================== 2. PLANTEAMIENTO =====================
h(1, "2. Planteamiento del problema")
p("Las comunidades locales enfrentan dificultades para:")
for item in [
    "Conectar a sus habitantes con comercios, productos y servicios locales de forma digitalizada.",
    "Gestionar y asignar repartidores de forma eficiente y transparente para servicios de domicilio.",
    "Centralizar en un único canal la oferta de prestadores de servicios profesionales.",
    "Mantener un directorio de contactos de emergencia y utilidad actualizado y accesible.",
    "Ofrecer a los administradores visibilidad sobre operaciones financieras, de servicio y de reparto.",
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(item).font.name = "Calibri"
p()
p(
    "Sin una solución unificada, la experiencia del usuario se fragmenta: se depende de llamadas telefónicas, grupos de mensajería informal y procesos manuales que generan errores, retrasos e informalidad en las transacciones locales."
)

# ===================== 3. JUSTIFICACIÓN =====================
h(1, "3. Justificación")
p(
    "Este proyecto busca digitalizar la economía local a través de una plataforma móvil integral. Con ello, se busca:"
)
for item in [
    "Mejorar la experiencia del cliente, brindando acceso rápido a tiendas, servicios y domicilios.",
    "Incrementar la competitividad de los prestadores y comercios locales.",
    "Optimizar los procesos de asignación de domicilios mediante un sistema automático.",
    "Formalizar la oferta de servicios profesionales con validación administrativa.",
    "Centralizar la información operativa en un panel administrativo con reportes en tiempo real.",
    "Reducir errores humanos al automatizar flujos de solicitud, aprobación y seguimiento.",
    "Fomentar la confianza entre usuarios mediante perfiles verificados y seguimiento transparente.",
    "Escalar y extender la plataforma fácilmente gracias a Clean Architecture.",
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(item).font.name = "Calibri"

# ===================== 4. OBJETIVO GENERAL =====================
h(1, "4. Objetivo general")
p(
    "Desarrollar una aplicación móvil integral para comunidades locales que proporcione una experiencia interactiva, moderna y eficiente, permitiendo a los usuarios acceder a servicios de tienda, domicilios y prestadores profesionales desde una única plataforma, con autenticación segura basada en roles, gestión de estado en tiempo real y panel administrativo completo."
)
p()
p(
    "El sistema incorpora autenticación JWT con roles diferenciados (CLIENTE, PRESTADOR, DOMICILIARIO, ADMIN), módulo de tienda con carrito Hive, módulo de domicilios con asignación automática de repartidores, módulo de servicios con validación de prestadores, directorio de contactos y dashboard de administración con reportes."
)
p()
p(
    "Arquitectura técnica: backend Django REST Framework + JWT; frontend Flutter con Clean Architecture, Riverpod, GoRouter y Dio."
)

h(2, "4.1. Objetivos específicos")
for item in [
    "Diseñar y desarrollar un backend robusto con Django y DRF para los módulos de usuarios, tienda, domicilios, servicios, contactos y reportes.",
    "Implementar un frontend móvil en Flutter que consuma los endpoints del backend mediante Dio con interceptores JWT.",
    "Desarrollar autenticación con JWT, soporte para roles múltiples y refresco automático de tokens.",
    "Diseñar un modelo de base de datos relacional optimizado para el dominio de servicios locales.",
    "Implementar asignación automática de domiciliarios disponibles a solicitudes entrantes.",
    "Desarrollar flujo completo de compra en tienda con carrito Hive y seguimiento de órdenes.",
    "Implementar validación y aprobación de prestadores de servicios por el administrador.",
    "Desarrollar panel de administración con dashboard, reportes y gestión global.",
    "Aplicar metodología ágil con historias de usuario, sprints y control de versiones en GitHub.",
    "Realizar pruebas integrales en backend (Postman) y frontend (flujos completos).",
    "Documentar exhaustivamente arquitectura, modelo relacional, diagramas y guías de instalación.",
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(item).font.name = "Calibri"

# ===================== 5. ANTECEDENTES =====================
h(1, "5. Antecedentes")
p("Plataformas de servicios locales y domicilios (Rappi, Domicilios.com, TaskRabbit) muestran que:")
for item in [
    "La digitalización de servicios locales reduce intermediación y mejora la transparencia.",
    "Los sistemas de asignación automática de repartidores reducen tiempos de espera.",
    "Los directorios de prestadores verificados generan mayor confianza y uso recurrente.",
    "Flutter/Dart y Django/DRF son stacks reconocidos por productividad y escalabilidad.",
    "JWT es el estándar para autenticación sin estado en APIs REST.",
    "Clean Architecture en Flutter permite mantenimiento ágil y pruebas efectivas.",
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(item).font.name = "Calibri"

# ===================== 6. MARCO LEGAL =====================
h(1, "6. Marco legal")
for item in [
    "Protección de datos personales: Ley 1581 de 2012 (Habeas Data, Colombia). Minimización y consentimiento.",
    "Políticas y Términos: textos legales de uso del servicio y privacidad antes del despliegue público.",
    "Derechos de autor: imágenes propias o con licencia libre. Documentos de prestadores son su responsabilidad.",
    "Seguridad: contraseñas con hash bcrypt (Django), tokens en FlutterSecureStorage, sin datos bancarios.",
    "Nota: el módulo de pagos es simulado en la fase actual. Integración real requiere evaluación legal adicional.",
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(item).font.name = "Calibri"

# ===================== 7. MARCO TEÓRICO =====================
h(1, "7. Marco teórico")
for item in [
    "Arquitectura cliente/servidor: el frontend Flutter consume el backend RESTful Django/DRF.",
    "REST & JSON: diseño de endpoints con recursos y verbos HTTP estándar (GET, POST, PUT, PATCH, DELETE).",
    "JWT: flujo access/refresh para autenticación stateless; interceptor Dio renueva tokens automáticamente ante 401.",
    "Clean Architecture (Flutter): capas domain (entidades, casos de uso), data (repositorios, datasources, modelos) y presentation (providers, pantallas, widgets).",
    "Riverpod: gestión de estado reactiva con StateNotifierProvider y FutureProvider.",
    "GoRouter: enrutamiento declarativo con guardias de rol.",
    "Hive: persistencia local offline del carrito de compras.",
    "Modelo relacional: tablas normalizadas, relaciones 1:N y N:M con tablas intermedias en Django ORM.",
    "MVC en Django: modelos (ORM), ViewSets (DRF), serializadores, URLs.",
    "UX centrado en el usuario: loading states, empty states, error messages, navegación por roles.",
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(item).font.name = "Calibri"

# ===================== 8. REQUERIMIENTOS =====================
h(1, "8. Requerimientos funcionales y no funcionales")
h(2, "8.1 Introducción")
p(
    "En esta sección se describe el desarrollo del sistema Runners, una plataforma móvil diseñada para conectar a usuarios de una comunidad con servicios de tienda, domicilios y profesionales independientes. El sistema gestiona cuatro tipos de usuarios (CLIENTE, PRESTADOR, DOMICILIARIO, ADMIN) con flujos diferenciados por rol."
)

h(2, "8.2 Requisitos Funcionales a Nivel del Sistema")
tbl = doc.add_table(rows=1, cols=3)
tbl.style = "Table Grid"
hdr = tbl.rows[0].cells
hdr[0].text = "ID"
hdr[1].text = "Módulo"
hdr[2].text = "Requisito"
reqs = [
    ("REQ-01", "Autenticación", "Registro de usuario con nombre, correo, contraseña y rol"),
    ("REQ-02", "Autenticación", "Inicio de sesión con JWT (access + refresh token)"),
    ("REQ-03", "Tienda", "Listado de comercios y productos por categoría"),
    ("REQ-04", "Tienda", "Carrito de compras persistido localmente (Hive)"),
    ("REQ-05", "Tienda", "Creación y seguimiento de órdenes de compra"),
    ("REQ-06", "Domicilios", "Solicitud de domicilio con dirección origen y destino"),
    ("REQ-07", "Domicilios", "Asignación automática de domiciliario disponible"),
    ("REQ-08", "Domicilios", "Seguimiento del estado del domicilio"),
    ("REQ-09", "Servicios", "Registro de prestadores con perfil, foto y hoja de vida"),
    ("REQ-10", "Servicios", "Aprobación/rechazo de prestadores por el administrador"),
    ("REQ-11", "Servicios", "Solicitud de servicio por parte del cliente"),
    ("REQ-12", "Contactos", "Directorio de contactos de emergencia y utilidad"),
    ("REQ-13", "Admin", "Dashboard con métricas de operación"),
    ("REQ-14", "Admin", "Reportes de domicilios, servicios y tienda"),
    ("REQ-15", "Admin", "Gestión de usuarios, comercios y configuración"),
]
for r in reqs:
    row = tbl.add_row().cells
    row[0].text = r[0]
    row[1].text = r[1]
    row[2].text = r[2]
doc.add_paragraph()

for num, title_req, desc in [
    (
        "8.3",
        "Registro de usuario (REQ-01)",
        "El sistema permitirá a un nuevo usuario registrarse con nombre, apellido, correo y contraseña. El correo debe ser único (unique=True en modelo User).",
    ),
    (
        "8.4",
        "Inicio de sesión (REQ-02)",
        "El sistema permitirá iniciar sesión con correo y contraseña, retornando par de tokens JWT. El interceptor Dio renovará automáticamente el token ante respuestas 401.",
    ),
    (
        "8.5",
        "Visualización de tienda (REQ-03)",
        "El cliente podrá visualizar comercios activos, filtrar por categoría, ver productos con nombre, descripción, precio e imagen.",
    ),
    (
        "8.6",
        "Carrito y orden de compra (REQ-04/05)",
        "El cliente podrá agregar productos al carrito (Hive), modificar cantidades y confirmar la compra creando una Orden con estado PENDIENTE.",
    ),
    (
        "8.7",
        "Solicitud de domicilio (REQ-06/07)",
        "El cliente creará una solicitud indicando dirección de recogida y entrega. El sistema asignará automáticamente el domiciliario DISPONIBLE de menor número asignado.",
    ),
    (
        "8.8",
        "Seguimiento de domicilio (REQ-08)",
        "El cliente y domiciliario podrán consultar y actualizar el estado de la solicitud (PENDIENTE, ACEPTADO, EN_CAMINO, ENTREGADO, CANCELADO).",
    ),
    (
        "8.9",
        "Perfil de prestador (REQ-09)",
        "Un PRESTADOR podrá completar su perfil con foto, descripción, categoría y hoja de vida. El perfil iniciará con approval_status = PENDIENTE.",
    ),
    (
        "8.10",
        "Aprobación de prestadores (REQ-10)",
        "El administrador podrá revisar prestadores PENDIENTES y aprobar o rechazar con motivo de rechazo.",
    ),
    (
        "8.11",
        "Solicitud de servicio (REQ-11)",
        "El cliente podrá solicitar un servicio a un prestador APROBADO con descripción y fecha programada.",
    ),
    (
        "8.12",
        "Directorio de contactos (REQ-12)",
        "Todos los usuarios podrán consultar el directorio. Solo el ADMIN puede crear, editar y desactivar contactos.",
    ),
    (
        "8.13",
        "Dashboard administrativo (REQ-13)",
        "El administrador tendrá métricas clave: usuarios por rol, órdenes activas, domicilios del día, servicios en curso.",
    ),
    (
        "8.14",
        "Reportes (REQ-14)",
        "El sistema generará reportes de domicilios, servicios y ventas de tienda filtrados por período.",
    ),
    (
        "8.15",
        "Gestión administrativa (REQ-15)",
        "El administrador podrá gestionar usuarios, comercios, SystemConfig y registros financieros de domiciliarios.",
    ),
]:
    h(2, f"{num} {title_req}")
    p(desc)

h(2, "8.16 Requerimientos no funcionales")
tbl2 = doc.add_table(rows=1, cols=3)
tbl2.style = "Table Grid"
hdr2 = tbl2.rows[0].cells
hdr2[0].text = "ID"
hdr2[1].text = "Categoría"
hdr2[2].text = "Descripción"
rnfs = [
    (
        "RNF-01",
        "Seguridad",
        "Contraseñas hash bcrypt, JWT para sesiones, FlutterSecureStorage para tokens",
    ),
    ("RNF-02", "Rendimiento", "Latencia < 500ms; paginación en listados extensos"),
    ("RNF-03", "Escalabilidad", "Clean Architecture; compatible con Docker"),
    (
        "RNF-04",
        "Mantenibilidad",
        "Apps Django por dominio; features Flutter por módulo",
    ),
    (
        "RNF-05",
        "Observabilidad",
        "Logs backend; manejo de errores estructurado en frontend",
    ),
    (
        "RNF-06",
        "Compatibilidad",
        "Android 5.0+ / iOS 12+; PostgreSQL en producción",
    ),
    (
        "RNF-07",
        "Disponibilidad",
        "Backend 24/7 en producción con gunicorn/supervisor",
    ),
]
for r in rnfs:
    row = tbl2.add_row().cells
    row[0].text = r[0]
    row[1].text = r[1]
    row[2].text = r[2]
doc.add_paragraph()

# ===================== 9. CUALIDADES =====================
h(1, "9. Cualidades del Sistema")
h(2, "9.1 Usabilidad y Accesibilidad")
p(
    "Navegación por roles (GoRouter), estados visuales (AppLoading, AppError, AppEmptyState), widgets compartidos (AppButton, AppTextField, AppCard), formularios con validación en tiempo real y mensajes de error descriptivos."
)
h(3, "9.2 Confiabilidad")
p(
    "Reintentos automáticos con interceptor Dio, persistencia del carrito en Hive ante desconexiones, renovación automática de tokens JWT."
)
h(4, "9.3 Rendimiento")
p(
    "ORM con select_related/prefetch_related; paginación en listados; CachedNetworkImage en Flutter; Hive sin latencia de red para carrito."
)
h(5, "9.4 Soportabilidad")
p(
    "Clean Architecture modular: cada feature Flutter y cada app Django es independiente. Nuevos módulos se agregan sin modificar los existentes."
)

# ===================== 10. INTERFACES =====================
h(1, "10. Interfaces del Sistema")
h(2, "10.1 Interfaces de Usuario")
h(3, "10.1.1 Aspecto y Sensación")
p(
    "Diseño moderno y coherente con tema definido en core/theme/. Iconos Material Design. Paleta de colores unificada."
)
h(4, "10.1.2 Diseño y Navegación")
p(
    "BottomNavigationBar o NavigationDrawer con accesos según rol. Pantalla Splash gestiona redirección inicial basada en token almacenado."
)
h(5, "10.1.3 Consistencia")
p(
    "ThemeData centralizado en core/theme/app_theme.dart. AppButton y AppTextField garantizan homogeneidad."
)
h(6, "10.1.4 Personalización por Rol")
for rol, accesos in [
    ("CLIENTE", "tienda, carrito, órdenes, domicilios, servicios (solicitar), contactos, perfil"),
    ("PRESTADOR", "perfil, mis solicitudes de servicio, disponibilidad"),
    (
        "DOMICILIARIO",
        "solicitudes asignadas, cambio de estado, historial financiero",
    ),
    ("ADMIN", "dashboard, usuarios, prestadores, reportes, contactos, configuración"),
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(f"{rol}: {accesos}").font.name = "Calibri"

h(2, "10.2 Interfaces con Sistemas Externos")
h(3, "10.2.1 Interfaces de Software")
p(
    "Flutter/Dart (SDK 3.9+) — API REST Django/DRF (Python 3.12, Django 5.2.6). Comunicación JSON sobre HTTP/HTTPS."
)
p("10.2.2 Interfaces de Hardware")
p(
    "Sin hardware especializado. Android 5.0+ / iOS 12+. Servidor: Linux/Windows con Python 3.12+."
)
h(5, "10.2.3 Interfaces de Comunicaciones")
p(
    "HTTPS en producción. Authorization: Bearer <token> en cada petición protegida. HTTP sobre localhost:8000 en desarrollo."
)

# ===================== 11. REGLAS DE NEGOCIO =====================
h(1, "11. Reglas de Negocio")
h(2, "11.1 Usuarios y Autenticación")
h(3, "11.1.1 RN-01 – Roles Exclusivos")
p(
    "Si un usuario se registra con rol CLIENTE, no podrá acceder a funciones de DOMICILIARIO, PRESTADOR ni ADMIN. Guardias de rol en GoRouter y permisos en backend."
)
h(4, "11.1.2 RN-02 – Validación de Registro")
p(
    "Si el correo ya existe, el sistema notifica el conflicto e impide duplicados. email es unique=True en modelo User."
)
h(5, "11.1.3 RN-03 – Inicio de Sesión Seguro")
p(
    "Validación con hash bcrypt. Token de acceso expira en 5 minutos; refresh en 1 día."
)
h(2, "11.2 Tienda y Carrito")
h(3, "11.2.1 RN-04 – Validación del Carrito")
p(
    "Si no hay ítems con cantidad > 0, el sistema no permite confirmar la compra."
)
h(4, "11.2.2 RN-05 – Disponibilidad de Productos")
p(
    "Si is_available = False, el producto no aparece en listado ni puede agregarse al carrito."
)
h(5, "11.2.3 RN-06 – Generación de Orden")
p(
    "Al confirmar el carrito, se crea una Orden con estado PENDIENTE y OrderItems con precio histórico."
)
h(2, "11.3 Domicilios")
h(3, "11.3.1 RN-07 – Asignación Automática")
p(
    "Al crear solicitud, el sistema asigna el domiciliario DISPONIBLE de menor assigned_number. Si no hay disponibles, deliverer = null."
)
h(4, "11.3.2 RN-08 – Cambio de Estado a ENTREGADO")
p(
    "Se registra completed_at, se libera al domiciliario (DISPONIBLE) y se genera FinancialRecord."
)
h(5, "11.3.3 RN-09 – Registro Financiero")
p(
    "runners_commission = delivery_fee x commission_rate (de SystemConfig)."
)
h(2, "11.4 Servicios")
h(3, "11.4.1 RN-10 – Validación de Prestador")
p(
    "Si approval_status != APROBADO, el prestador no aparece en el directorio de servicios."
)
h(4, "11.4.2 RN-11 – Solicitud Única")
p(
    "Si hay solicitud PENDIENTE o APROBADA con el mismo prestador, el sistema impide duplicados."
)
h(5, "11.4.3 RN-12 – Cálculo de Tarifas")
p(
    "client_total = provider_fee + runners_fee (runners_fee según SystemConfig)."
)
h(2, "11.5 Contactos")
h(3, "11.5.1 RN-13 – Visibilidad")
p(
    "Solo contactos con is_active = True son visibles en el directorio público."
)
h(4, "11.5.2 RN-14 – Gestión Exclusiva")
p(
    "Solo ADMIN puede crear, editar o desactivar contactos."
)

# ===================== 12. RESTRICCIONES =====================
h(1, "12. Restricciones del Sistema")
h(2, "12.1 Lenguaje de Implementación")
p(
    "Backend: Django (Python 3.12) con DRF. Frontend: Flutter (Dart 3.9+) con Clean Architecture y Riverpod."
)
h(3, "12.2 Base de Datos")
p(
    "Desarrollo: SQLite. Producción: PostgreSQL con psycopg2-binary 2.9.10."
)
h(4, "12.3 Herramientas de Desarrollo")
herramientas = [
    "Python 3.12, Dart 3.9+ / Flutter 3.9+",
    "Django 5.2.6, Django REST Framework 3.16.1",
    "djangorestframework-simplejwt 5.5.1, django-cors-headers 4.8.0, Pillow 11.3.0",
    "flutter_riverpod 2.x, go_router 13.x, dio 5.x, hive 2.x, flutter_secure_storage 9.x",
    "Git + GitHub (https://github.com/Karatsuyu/Runners.git)",
    "Postman – coleccion runners_api_postman.json (30+ endpoints)",
    "VS Code con extensiones Flutter y Python",
]
for item in herramientas:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(item).font.name = "Calibri"
h(4, "12.4 Límites de Recursos")
p(
    "Dispositivo movil: minimo 2 GB RAM. Servidor desarrollo: minimo 1 GB RAM, 1 nucleo. Produccion recomendada: 2 GB RAM, 2 nucleos."
)

# ===================== 13. DOCUMENTACIÓN =====================
h(1, "13. Documentación del Sistema")
h(2, "13.1 Sistema de Ayuda")
p(
    "Mensajes contextuales, indicadores de estado (cargando, error, vacío) y errores del API en lenguaje natural."
)
h(3, "13.2 Documentación Técnica")
for item in [
    "Diagrama ER del modelo relacional (Mermaid).",
    "Diagrama de arquitectura del sistema.",
    "Coleccion Postman con 30+ endpoints (runners_api_postman.json).",
    "README.md, QUICKSTART.md con instrucciones de instalacion.",
    "Guias de implementacion Flutter y web.",
    "CONTRIBUTING.md y PR template en español.",
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(item).font.name = "Calibri"
h(4, "13.3 Responsabilidad")
p(
    "El equipo de desarrollo es responsable de la creacion y mantenimiento de la documentacion, actualizandola con cada cambio significativo."
)

# ===================== 14. MARCO METODOLÓGICO =====================
h(1, "14. Marco metodológico")
h(2, "14.1 Metodología de proyecto")
p(
    "Metodologia agil (Scrum/Kanban): sprints de 1-2 semanas, historias de usuario organizadas por modulo, commits semanticos (feat:, fix:, docs:, chore:)."
)
h(3, "14.2 Técnica de elicitación")
for item in [
    "Analisis de dominio: observacion de Rappi, Domicilios.com, TaskRabbit, apps municipales.",
    "Modulos diferenciadores: asignacion automatica, aprobacion de prestadores, directorio de emergencias.",
    "Analisis de roles: cuatro perfiles con necesidades distintas.",
    "Adopcion de Clean Architecture y Riverpod para mantenibilidad y escalabilidad.",
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(item).font.name = "Calibri"

h(4, "14.3 Historias de usuario")
modulos_hu = {
    "MÓDULO 1: Autenticación y Usuarios": [
        (
            "HU-01",
            "Registro",
            "usuario nuevo",
            "registrarme con nombre, apellido, correo y contrasena",
            "crear una cuenta y acceder a funciones segun mi rol",
        ),
        (
            "HU-02",
            "Login",
            "usuario registrado",
            "iniciar sesion con mi correo y contrasena",
            "acceder a mi perfil y funciones segun mi rol",
        ),
        (
            "HU-03",
            "Logout",
            "usuario autenticado",
            "cerrar sesion de forma segura",
            "mis tokens no queden activos en el dispositivo",
        ),
    ],
    "MÓDULO 2: Tienda": [
        (
            "HU-04",
            "Ver tienda",
            "cliente",
            "ver los comercios disponibles y sus productos",
            "elegir que comprar",
        ),
        (
            "HU-05",
            "Carrito",
            "cliente",
            "agregar productos al carrito y modificar cantidades",
            "preparar mi compra antes de confirmarla",
        ),
        (
            "HU-06",
            "Confirmar orden",
            "cliente",
            "confirmar mi carrito y crear una orden",
            "el comercio reciba mi pedido",
        ),
        (
            "HU-07",
            "Historial ordenes",
            "cliente",
            "ver el historial de mis ordenes con sus estados",
            "hacer seguimiento de mis compras",
        ),
    ],
    "MÓDULO 3: Domicilios": [
        (
            "HU-08",
            "Solicitar domicilio",
            "cliente",
            "crear una solicitud de domicilio con direccion de recogida y entrega",
            "que me envien lo que necesito",
        ),
        (
            "HU-09",
            "Estado domicilio",
            "cliente",
            "consultar el estado de mi solicitud en tiempo real",
            "saber cuando llega mi entrega",
        ),
        (
            "HU-10",
            "Gestionar domicilios",
            "domiciliario",
            "ver las solicitudes asignadas y actualizar su estado",
            "gestionar mis entregas",
        ),
        (
            "HU-11",
            "Historial financiero",
            "domiciliario",
            "ver mis ingresos y la comision de Runners",
            "llevar control de mis ganancias",
        ),
    ],
    "MÓDULO 4: Servicios": [
        (
            "HU-12",
            "Ver prestadores",
            "cliente",
            "ver el directorio de prestadores aprobados",
            "contactar al mas adecuado",
        ),
        (
            "HU-13",
            "Solicitar servicio",
            "cliente",
            "enviar una solicitud de servicio con fecha y descripcion",
            "el prestador pueda aceptarla o rechazarla",
        ),
        (
            "HU-14",
            "Perfil prestador",
            "prestador",
            "completar mi perfil con foto, categoria y hoja de vida",
            "el administrador pueda aprobarlo",
        ),
        (
            "HU-15",
            "Gestionar solicitudes",
            "prestador",
            "ver y aprobar/rechazar solicitudes de clientes",
            "gestionar mi agenda de trabajo",
        ),
    ],
    "MÓDULO 5: Contactos": [
        (
            "HU-16",
            "Ver contactos",
            "usuario",
            "ver el directorio de contactos de emergencia y utilidad",
            "encontrar un contacto rapidamente",
        ),
        (
            "HU-17",
            "Filtrar contactos",
            "usuario",
            "filtrar el directorio por tipo de contacto",
            "encontrar mas rapido lo que busco",
        ),
    ],
    "MÓDULO 6: Administración": [
        (
            "HU-18",
            "Dashboard",
            "administrador",
            "ver un panel con metricas de la plataforma",
            "monitorear el estado del sistema",
        ),
        (
            "HU-19",
            "Aprobar prestadores",
            "administrador",
            "revisar perfiles pendientes y aprobar/rechazar",
            "mantener la calidad de los servicios",
        ),
        (
            "HU-20",
            "Gestionar contactos",
            "administrador",
            "crear, editar y desactivar contactos",
            "mantener la informacion publica actualizada",
        ),
        (
            "HU-21",
            "Reportes",
            "administrador",
            "consultar reportes por periodo",
            "tomar decisiones operativas basadas en datos",
        ),
    ],
}
for modulo, hus in modulos_hu.items():
    p(modulo, bold=True)
    for hu_id, nombre, rol, quiero, para in hus:
        bp = doc.add_paragraph(style="List Bullet")
        bp.add_run(
            f"{hu_id} - {nombre}: Como {rol}, quiero {quiero}, para {para}."
        ).font.name = "Calibri"
    doc.add_paragraph()

h(5, "14.4 Diseño relacional")
p("Figura 1. Diseño relacional del sistema Runners. Elaboracion propia (2025).")
p()
entidades = [
    "User: id (PK), email (UK), password, first_name, last_name, role [CLIENTE|PRESTADOR|DOMICILIARIO|ADMIN], is_active, date_joined",
    "StoreCategory: id (PK), name, description",
    "Commerce: id (PK), name, description, city, address, phone, logo, category_id (FK), owner_id (FK), is_active",
    "ProductCategory: id (PK), name",
    "Product: id (PK), name, description, price, commerce_id (FK), category_id (FK), image, is_available",
    "Order: id (PK), client_id (FK), commerce_id (FK), status [PENDIENTE|CONFIRMADO|ENTREGADO|CANCELADO], total_price, notes, created_at",
    "OrderItem: id (PK), order_id (FK), product_id (FK), quantity, unit_price",
    "Deliverer: id (PK), user_id (FK, OneToOne), status [DISPONIBLE|OCUPADO], assigned_number, is_active",
    "DeliveryRequest: id (PK), client_id (FK), deliverer_id (FK, nullable), pickup_address, delivery_address, delivery_fee, status, completed_at, created_at",
    "FinancialRecord: id (PK), deliverer_id (FK), record_type [INGRESO|GASTO], amount, runners_commission, description, created_at",
    "SystemConfig: id (PK), key (UK), value, description",
    "ServiceCategory: id (PK), name, description",
    "ServiceProvider: id (PK), user_id (FK, OneToOne), category_id (FK), description, photo, resume, terms_accepted, status [ACTIVO|INACTIVO], approval_status [PENDIENTE|APROBADO|RECHAZADO], rejection_reason, approved_by_id (FK), approved_at",
    "ServiceRequest: id (PK), client_id (FK), provider_id (FK), category_id (FK), description, scheduled_date, provider_fee, runners_fee, client_total, status [PENDIENTE|APROBADO|RECHAZADO|COMPLETADO], notes, created_at",
    "Contact: id (PK), name, phone, description, contact_type [EMERGENCIA|PROFESIONAL|COMERCIO|OTRO], is_active, created_at, updated_at",
]
for ent in entidades:
    bp = doc.add_paragraph(style="List Bullet")
    run_e = bp.add_run(ent)
    run_e.font.name = "Courier New"
    run_e.font.size = Pt(9)
p()
p(
    "Ver diagrama Mermaid ER completo en Documento_Desarrollo_Runners.md, seccion 14.4.5.",
    italic=True,
)

h(6, "14.5 Prototipado")
p(
    "Prototipo funcional en Flutter que incluye pantallas de login/registro, home por modulos segun rol, tienda con carrito, flujo de domicilios, directorio de servicios y contactos, y panel de administracion."
)

# ===================== 15. CASOS DE USO =====================
h(1, "15. Casos de uso (detallados)")
p("Actores: Cliente, Prestador, Domiciliario, Administrador, Sistema (API Django).")
casos = [
    (
        "UC-01",
        "Registrarse",
        "Usuario no registrado",
        "POST /api/auth/register/ - valida correo unico - crea usuario - retorna tokens JWT",
        "Email ya registrado, contrasena muy corta, rol invalido",
    ),
    (
        "UC-02",
        "Iniciar sesion",
        "Cuenta existente",
        "POST /api/auth/login/ - valida credenciales - retorna tokens - GoRouter redirige segun rol",
        "Credenciales invalidas, cuenta inactiva",
    ),
    (
        "UC-03",
        "Consultar tienda",
        "-",
        "GET /api/store/commerces/ - GET /api/store/products/?commerce_id=X",
        "-",
    ),
    (
        "UC-04",
        "Gestionar carrito",
        "-",
        "CartNotifier actualiza Hive - POST /api/store/orders/ al confirmar",
        "Carrito vacio",
    ),
    (
        "UC-05",
        "Solicitar domicilio",
        "-",
        "POST /api/deliveries/requests/ - asignacion automatica de domiciliario disponible",
        "Sin domiciliarios disponibles",
    ),
    (
        "UC-06",
        "Actualizar estado domicilio",
        "-",
        "PATCH /api/deliveries/requests/{id}/ - si ENTREGADO: completed_at + FinancialRecord",
        "-",
    ),
    (
        "UC-07",
        "Completar perfil prestador",
        "-",
        "POST /api/services/providers/ con foto, descripcion, categoria, HV - approval_status = PENDIENTE",
        "-",
    ),
    (
        "UC-08",
        "Aprobar/rechazar prestador",
        "Admin",
        "PATCH /api/services/providers/{id}/ con approval_status = APROBADO o RECHAZADO",
        "-",
    ),
    (
        "UC-09",
        "Solicitar servicio",
        "Cliente",
        "POST /api/services/requests/ - sistema calcula client_total - prestador recibe solicitud",
        "Prestador no aprobado, solicitud duplicada",
    ),
    (
        "UC-10",
        "Gestionar solicitudes servicio",
        "Prestador",
        "GET /api/services/requests/ - PATCH /{id}/ con status APROBADO o RECHAZADO",
        "-",
    ),
    (
        "UC-11",
        "Consultar contactos",
        "-",
        "GET /api/contacts/?contact_type=X - Flutter muestra directorio",
        "-",
    ),
    (
        "UC-12",
        "Administrar plataforma",
        "Admin",
        "Endpoints de usuarios, comercios, configuracion y contactos",
        "-",
    ),
    (
        "UC-13",
        "Ver reportes",
        "Admin",
        "GET /api/reports/deliveries/ + /services/ + /store/ con filtros de periodo",
        "-",
    ),
]
for uc_id, nombre, pre, flujo, exc in casos:
    h(2, f"{uc_id}: {nombre}")
    if pre and pre != "-":
        p(f"Precondicion: {pre}")
    p(f"Flujo: {flujo}")
    if exc and exc != "-":
        p(f"Excepciones: {exc}")

h(3, "15.1 Diagrama de casos de uso")
p(
    "Ver diagrama Mermaid en Documento_Desarrollo_Runners.md, seccion 15.1.",
    italic=True,
)

# ===================== 16. ESTRUCTURA =====================
h(1, "16. Estructura de carpetas")
h(3, "16.1 Backend (Django)")
codigo_backend = """backend/
+-- manage.py
+-- requirements.txt
+-- .env / .env.example
+-- runners_project/
|   +-- settings.py
|   +-- urls.py
|   +-- wsgi.py
+-- apps/
|   +-- users/
|   +-- store/
|   +-- deliveries/
|   +-- services/
|   +-- contacts/
|   +-- reports/
+-- media/"""
code(codigo_backend)

h(3, "16.2 Frontend (Flutter + Clean Architecture)")
codigo_flutter = """frontend/
+-- pubspec.yaml
+-- lib/
|   +-- main.dart
|   +-- app.dart
|   +-- core/
|   |   +-- network/    # Dio + interceptores JWT
|   |   +-- router/     # GoRouter con guardias de rol
|   |   +-- storage/    # Hive + SecureStorage
|   |   +-- theme/      # AppTheme
|   +-- features/
|   |   +-- auth/
|   |   +-- store/
|   |   +-- deliveries/
|   |   +-- services/
|   |   +-- contacts/
|   |   +-- admin/
|   +-- shared/
|       +-- widgets/    # AppButton, AppTextField, AppCard
+-- test/"""
code(codigo_flutter)

# ===================== 17-22. RIESGOS =====================
h(1, "17. Plan de Gestión de Riesgos")
h(2, "17.1 Introduccion")
p(
    "Esta seccion establece estrategias, procedimientos y responsabilidades para identificar, analizar, mitigar y controlar los riesgos del proyecto Runners a lo largo de su ciclo de vida."
)
h(3, "17.1.1 Proposito")
p(
    "Definir la metodologia y acciones para gestionar los riesgos del proyecto Runners, garantizando la entrega a tiempo de una plataforma funcional, segura y documentada."
)
h(4, "17.1.2 Alcance")
p(
    "Abarca todas las fases: analisis, diseno, desarrollo, pruebas y despliegue. Aplica a todo el equipo, herramientas y procesos de gestion interna."
)
h(5, "17.1.3 Definiciones y Acronimos")
for item in [
    "DRF: Django REST Framework",
    "JWT: JSON Web Token",
    "HU: Historia de Usuario",
    "RN: Regla de Negocio",
    "UC: Caso de Uso",
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(item).font.name = "Calibri"
h(6, "17.1.5 Descripcion General")
for item in [
    "Resumen de riesgos: lista priorizada.",
    "Tareas de gestion: identificacion, analisis y mitigacion.",
    "Responsabilidades: roles del equipo.",
    "Presupuesto: tiempo para contingencias.",
    "Herramientas: Git, GitHub Issues, documentacion colaborativa.",
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(item).font.name = "Calibri"

h(1, "18. Tareas de Gestión de Riesgos")
for item in [
    "Identificacion: analisis con el equipo revisando cada modulo.",
    "Analisis: Matriz de probabilidad/impacto (escala 1-5).",
    "Priorizacion: Riesgos con puntuacion >= 8 se gestionan primero.",
    "Seguimiento: revision semanal durante el sprint activo.",
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(item).font.name = "Calibri"

h(1, "19. Organización y Responsabilidades")
for item in [
    "Lider del Proyecto: coordina actividades, gestiona comunicacion y toma decisiones de alcance.",
    "Gestor de Riesgos: identifica, documenta y hace seguimiento a riesgos.",
    "Equipo Tecnico (todos): deteccion temprana de riesgos tecnicos.",
    "Comite de Revision: revisiones periodicas para evaluar riesgos e implementar medidas correctivas.",
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(item).font.name = "Calibri"

h(1, "20. Presupuesto")
tbl3 = doc.add_table(rows=1, cols=2)
tbl3.style = "Table Grid"
tbl3.rows[0].cells[0].text = "Recurso"
tbl3.rows[0].cells[1].text = "Costo"
for recurso, costo in [
    ("Servidor de desarrollo (local)", "$0"),
    ("Repositorio GitHub (publico)", "$0"),
    ("Herramientas (VS Code, Postman)", "$0"),
    ("Flutter SDK, Django, librerias open source", "$0"),
    ("Servidor de produccion (estimado futuro)", "Variable"),
    ("Contingencia de tiempo (15% del sprint)", "4-6 horas por sprint"),
]:
    row = tbl3.add_row().cells
    row[0].text = recurso
    row[1].text = costo
doc.add_paragraph()

h(1, "21. Herramientas y Técnicas")
for item in [
    "Control de versiones: Git + GitHub (ramas feature, commits semanticos, Pull Requests).",
    "Gestion de tareas: GitHub Issues / tablero Kanban.",
    "Documentacion: Markdown en el repositorio (README, QUICKSTART, CONTRIBUTING).",
    "Pruebas de API: Postman con coleccion runners_api_postman.json (30+ endpoints).",
    "Pruebas de Frontend: flujos manuales completos por modulo.",
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(item).font.name = "Calibri"

h(1, "22. Elementos de Riesgo Por Gestionar")
riesgos = [
    (
        "Riesgo 1 – Perdida/ausencia de integrante",
        "Documentacion en GitHub, arquitectura modular, roles redundantes.",
    ),
    (
        "Riesgo 2 – Perdida o dano de archivos",
        "Todo versionado en GitHub; push frecuente; clone en cualquier equipo.",
    ),
    (
        "Riesgo 3 – Falta de comunicacion",
        "Reglas de branches, commits semanticos, PR con descripcion, reuniones periodicas.",
    ),
    (
        "Riesgo 4 – Incumplimiento de plazos",
        "Buffer 15% por sprint, reducir alcance si es necesario.",
    ),
    (
        "Riesgo 5 – Problemas con dependencias",
        "Versiones fijas en pubspec.yaml y requirements.txt; entorno virtual Python aislado.",
    ),
    (
        "Riesgo 6 – Falta de experiencia con el stack",
        "Documentacion de arquitectura, revision entre pares, guias de implementacion en el repo.",
    ),
    (
        "Riesgo 7 – Cambios en los requisitos",
        "Arquitectura modular; migraciones Django para cambios en el modelo.",
    ),
    (
        "Riesgo 8 – Fallas en despliegue a produccion",
        "Variables de entorno en .env; documentacion en QUICKSTART.md.",
    ),
]
for titulo, control in riesgos:
    p(titulo, bold=True)
    p(control, indent=True)
    doc.add_paragraph()

p("Niveles de riesgo: Bajo (1-4) | Medio (5-9) | Alto (10-14) | Muy alto (15-25)")

# ===================== 23. DIAGRAMA DE PAQUETES =====================
h(1, "23. Diagrama de paquetes")
p(
    "Ver diagrama Mermaid en Documento_Desarrollo_Runners.md, seccion 23.",
    italic=True,
)

# ===================== 24. CRONOGRAMA =====================
h(1, "24. Cronograma")
h(2, "Planificacion del tiempo")
p("Duracion del Sprint: 2 semanas (10 dias habiles)")
p(
    "Capacidad: 3 desarrolladores x 40 hr/semana x 2 semanas = 232 hr efectivas = 29 puntos de historia"
)
p()
p("Sprint 1 – Autenticacion + Tienda (21 puntos)", bold=True)
tbl4 = doc.add_table(rows=1, cols=3)
tbl4.style = "Table Grid"
tbl4.rows[0].cells[0].text = "Historia"
tbl4.rows[0].cells[1].text = "Tareas"
tbl4.rows[0].cells[2].text = "Pts"
for historia, tareas, pts in [
    ("HU-01 Registro", "Pantalla registro, validacion correo unico, serializer", "2"),
    ("HU-02 Login", "Pantalla login, endpoint JWT, interceptor Dio, SecureStorage", "3"),
    ("HU-03 Logout", "Limpiar tokens, redirigir a Login", "1"),
    ("HU-04 Ver tienda", "Endpoint comercios/productos, pantalla listado", "4"),
    ("HU-05 Carrito", "CartNotifier Riverpod, persistencia Hive, pantalla carrito", "4"),
    ("HU-06 Confirmar orden", "Endpoint crear orden con items, pantalla confirmacion", "4"),
    ("HU-07 Historial", "Endpoint ordenes del cliente, pantalla historial", "3"),
]:
    row = tbl4.add_row().cells
    row[0].text = historia
    row[1].text = tareas
    row[2].text = pts
doc.add_paragraph()

p("Sprint 2 – Domicilios + Servicios (23 puntos)", bold=True)
tbl5 = doc.add_table(rows=1, cols=3)
tbl5.style = "Table Grid"
tbl5.rows[0].cells[0].text = "Historia"
tbl5.rows[0].cells[1].text = "Tareas"
tbl5.rows[0].cells[2].text = "Pts"
for historia, tareas, pts in [
    ("HU-08 Solicitar domicilio", "Endpoint + asignacion automatica domiciliario", "4"),
    ("HU-09 Estado domicilio", "Pantalla seguimiento, endpoint detalle", "2"),
    ("HU-10 Gestionar domicilios", "Pantalla domiciliario, PATCH estado, FinancialRecord", "4"),
    ("HU-11 Historial financiero", "Endpoint registros financieros, pantalla", "2"),
    ("HU-12 Ver prestadores", "Endpoint prestadores aprobados, pantalla directorio", "3"),
    ("HU-13 Solicitar servicio", "Endpoint solicitud, calculo tarifas", "3"),
    ("HU-14 Perfil prestador", "Endpoint perfil, subida foto y HV", "3"),
    ("HU-15 Gestionar solicitudes", "Aprobar/rechazar solicitudes, pantalla prestador", "2"),
]:
    row = tbl5.add_row().cells
    row[0].text = historia
    row[1].text = tareas
    row[2].text = pts
doc.add_paragraph()

p("Sprint 3 – Contactos + Admin + Refinamiento (21 puntos)", bold=True)
tbl6 = doc.add_table(rows=1, cols=3)
tbl6.style = "Table Grid"
tbl6.rows[0].cells[0].text = "Historia"
tbl6.rows[0].cells[1].text = "Tareas"
tbl6.rows[0].cells[2].text = "Pts"
for historia, tareas, pts in [
    ("HU-16 Ver contactos", "Endpoint directorio, pantalla listado filtrable", "2"),
    ("HU-17 Filtrar contactos", "Filtros por tipo en endpoint y UI", "1"),
    ("HU-18 Dashboard", "Endpoint metricas, pantalla con cards", "4"),
    ("HU-19 Aprobar prestadores", "Endpoint PATCH approval, pantalla gestion", "3"),
    ("HU-20 Gestionar contactos", "CRUD contactos para admin, pantalla gestion", "3"),
    ("HU-21 Reportes", "Endpoints reportes, pantallas de consulta", "4"),
    ("Buffer / pruebas", "Pruebas Postman, flujos completos, ajustes UX", "4"),
]:
    row = tbl6.add_row().cells
    row[0].text = historia
    row[1].text = tareas
    row[2].text = pts
doc.add_paragraph()

# ===================== 25. RESULTADOS ESPERADOS =====================
h(1, "25. Resultados Esperados de la Aplicacion")
for item in [
    "Digitalizacion de la economia local: conectar clientes con comercios y prestadores en un canal unico.",
    "Eficiencia en la asignacion de domicilios: asignacion automatica por disponibilidad.",
    "Validacion de prestadores: calidad garantizada mediante aprobacion administrativa previa.",
    "Centralizacion de informacion: visibilidad completa para el administrador en tiempo real.",
    "Reduccion de errores: flujos automatizados minimizan la intervencion manual.",
    "Arquitectura escalable: Clean Architecture + DRF permite agregar modulos sin reestructurar.",
    "Experiencia de usuario fluida: Riverpod, Hive y manejo de errores garantizan confiabilidad.",
    "Documentacion completa: README, QUICKSTART, guias, Postman y este documento.",
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(item).font.name = "Calibri"

# ===================== 26. RECOMENDACIONES =====================
h(1, "26. Recomendaciones y Sugerencias a Futuro")
for titulo, desc in [
    (
        "1. Pagos en linea reales",
        "Integrar PayPal, Stripe o MercadoPago. Requiere adecuarse a normativa de pagos electronicos.",
    ),
    (
        "2. Notificaciones push",
        "Firebase Cloud Messaging (FCM) para cambios de estado en domicilios y nuevas solicitudes.",
    ),
    (
        "3. Chat integrado",
        "Django Channels + WebSockets en Flutter para comunicacion cliente-prestador/domiciliario.",
    ),
    (
        "4. Sistema de calificaciones",
        "Rating para domiciliarios y prestadores despues de completar un servicio.",
    ),
    (
        "5. Geolocalizacion",
        "GPS para seguimiento de domicilios en mapa (Google Maps SDK para Flutter).",
    ),
    (
        "6. Analytics avanzado",
        "Graficos de ventas, servicios mas solicitados, domiciliarios mas activos.",
    ),
    (
        "7. Aplicacion web",
        "Con la API ya desarrollada, construir PWA o React para administradores y comercios.",
    ),
    (
        "8. Docker y produccion",
        "Docker Compose con Django, PostgreSQL, Nginx, SSL y gunicorn para despliegue robusto.",
    ),
    (
        "9. IA y recomendaciones",
        "Recomendar prestadores/productos basados en historial usando filtrado colaborativo.",
    ),
    (
        "10. Auditoria y trazabilidad",
        "Log de acciones administrativas para mejorar seguridad y control.",
    ),
]:
    h(3, titulo)
    p(desc)

# ===================== 27. CONCLUSIONES =====================
h(1, "27. Conclusiones")
for item in [
    "La arquitectura propuesta (Flutter + Clean Architecture + Riverpod; Django + DRF + JWT) ofrece una base solida, productiva y mantenible.",
    "El modelo relacional disenado soporta correctamente los cuatro modulos con sus relaciones entre entidades.",
    "La asignacion automatica de domiciliarios simplifica el flujo operativo sin intervencion manual.",
    "El sistema de aprobacion de prestadores garantiza calidad en el directorio de servicios.",
    "Clean Architecture en Flutter asegura que cambios en la capa de datos no afecten la presentacion.",
    "Para produccion: PostgreSQL, almacenamiento S3, HTTPS, Docker y CI/CD en GitHub Actions.",
    "Se recomienda implementar notificaciones push (FCM) y geolocalizacion como proximas funcionalidades.",
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(item).font.name = "Calibri"

# ===================== 28. BIBLIOGRAFÍA =====================
h(1, "28. Bibliografia")
for ref in [
    "Sommerville, I. (2016). Ingenieria del Software. Pearson.",
    "Pressman, R. (2015). Ingenieria del Software: Un enfoque practico. McGraw-Hill.",
    "Django Software Foundation. Django Documentation. https://docs.djangoproject.com/",
    "Django REST Framework. DRF Documentation. https://www.django-rest-framework.org/",
    "JWT.io. JSON Web Tokens Introduction. https://jwt.io/introduction",
    "Flutter Team. Flutter Documentation. https://docs.flutter.dev/",
    "Riverpod. Riverpod Documentation. https://riverpod.dev/",
    "GoRouter. go_router package. https://pub.dev/packages/go_router",
    "Hive. Hive Documentation. https://docs.hivedb.dev/",
    "Simple JWT. djangorestframework-simplejwt Docs. https://django-rest-framework-simplejwt.readthedocs.io/",
    "Mermaid. Diagramming Tool. https://mermaid.js.org/",
]:
    bp = doc.add_paragraph(style="List Bullet")
    bp.add_run(ref).font.name = "Calibri"

doc.save("Documento_Desarrollo_Runners.docx")
print("DOCX generado exitosamente: Documento_Desarrollo_Runners.docx")
