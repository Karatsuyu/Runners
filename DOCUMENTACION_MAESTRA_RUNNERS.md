# DOCUMENTACION MAESTRA DEL PROYECTO RUNNERS

Version consolidada: Abril 2026

## 1. Resumen Ejecutivo del Proyecto

Runners es una plataforma digital para la comunidad de Caicedonia (Valle del Cauca) que integra en una sola solucion:

- Tienda local (comercios y productos).
- Servicios profesionales (prestadores validados).
- Domicilios (asignacion de domiciliarios y control operativo/financiero).
- Directorio de contactos utiles y de emergencia.
- Administracion central con dashboard y reportes.

El proyecto esta implementado con arquitectura cliente-servidor:

- Frontend movil en Flutter/Dart.
- Backend API en Django + Django REST Framework.
- Autenticacion JWT por roles.

## 2. Problema, Justificacion y Contexto

### 2.1 Problema

Antes de Runners, la operacion se soportaba en procesos manuales e informales (llamadas, mensajeria, registros dispersos), lo que generaba:

- Falta de control de pedidos y servicios.
- Baja trazabilidad operativa y financiera.
- Dificultad para coordinar disponibilidad de prestadores y domiciliarios.
- Escasa capacidad de analisis para toma de decisiones.
- Limitaciones de escalabilidad y calidad del servicio.

### 2.2 Justificacion

La solucion centraliza y digitaliza la operacion de Runners para:

- Mejorar experiencia de usuarios y clientes.
- Optimizar procesos internos (asignacion, aprobaciones, registro financiero).
- Aumentar seguridad (JWT, control por roles, almacenamiento seguro de tokens).
- Formalizar la relacion entre cliente, prestador, domiciliario y administracion.
- Habilitar crecimiento futuro (pagos, notificaciones, geolocalizacion, analitica avanzada).

## 3. Objetivos del Proyecto

### 3.1 Objetivo general

Desarrollar una plataforma funcional que integre tienda, servicios, domicilios y contactos, soportada por backend API REST y app movil, con autenticacion segura y gestion por roles.

### 3.2 Objetivos especificos

- Implementar backend modular para usuarios, tienda, servicios, domicilios, contactos y reportes.
- Construir frontend Flutter con navegacion y vistas por rol.
- Implementar JWT (access/refresh) con flujo seguro de sesion.
- Diseñar modelo de datos relacional y procesos de negocio trazables.
- Implementar auto-asignacion de domiciliarios y control financiero asociado.
- Implementar flujo de aprobacion de prestadores por administrador.
- Habilitar tablero administrativo y reportes operativos.
- Documentar arquitectura, casos de uso, requisitos, despliegue y pruebas.

## 4. Alcance

### 4.1 Alcance incluido

- Modulo Tienda:
  - Gestion de comercios por administrador.
  - Catalogo por comercio/categoria.
  - Carrito y creacion de ordenes.
  - Historial de pedidos/ventas.
- Modulo Servicios:
  - Registro de prestadores con revision.
  - Aprobacion/rechazo por administrador.
  - Solicitud y gestion de servicios.
- Modulo Domicilios:
  - Solicitudes generales y de tienda.
  - Auto-asignacion de domiciliarios.
  - Estados de solicitud y cierre.
  - Registro financiero (ingresos/egresos/clasificacion).
  - Tarifas por zona y reglas.
- Modulo Contactos:
  - Directorio filtrable por tipo.
  - Gestion administrativa de contactos.
- Modulo Admin:
  - Dashboard y reportes modulares.
  - Gestion de usuarios y proveedores.
- Modulo Chat:
  - Hilos y mensajes por REST.
  - Tiempo real por WebSocket.

### 4.2 Alcance excluido (fase actual)

- Pasarela de pagos real integrada.
- Geolocalizacion en tiempo real avanzada.
- Notificaciones push completas de produccion.
- Despliegue cloud productivo final (documentado, no completamente operacionalizado en esta fase).

## 5. Actores, Roles y Permisos

Roles principales:

- CLIENTE: compra en tienda, solicita domicilios y servicios, consulta contactos e historial.
- PRESTADOR: gestiona perfil profesional y solicitudes asignadas.
- DOMICILIARIO: atiende domicilios, cambia estados y consulta/gestiona finanzas.
- ADMIN: gestiona plataforma, aprueba prestadores, configura reglas y revisa reportes.

Principio de seguridad: permisos por rol en backend y guardias de rutas en frontend.

## 6. Requisitos Funcionales Consolidados

### 6.1 Requisitos del sistema (REQ)

Se consolidan los requisitos documentados en el proyecto:

- REQ-01 Registro de usuario.
- REQ-02 Login con JWT (access/refresh).
- REQ-03 Listado de comercios/productos por categoria.
- REQ-04 Carrito local (Hive).
- REQ-05 Creacion/seguimiento de ordenes.
- REQ-06 Solicitud de domicilio.
- REQ-07 Asignacion automatica de domiciliario.
- REQ-08 Seguimiento de estado de domicilio.
- REQ-09 Registro de prestador con perfil y documentos.
- REQ-10 Aprobacion/rechazo de prestadores por admin.
- REQ-11 Solicitud de servicio por cliente.
- REQ-12 Directorio de contactos.
- REQ-13 Dashboard administrativo.
- REQ-14 Reportes por modulo.
- REQ-15 Gestion de usuarios/comercios/configuracion.
- REQ-16 Registro y gestion de domiciliarios.
- REQ-17 Registro de ingresos y egresos de domiciliarios.
- REQ-18 Cierre de sesion seguro.
- REQ-19 Control de acceso por rol.
- REQ-20 Busqueda de prestadores por categoria.
- REQ-21 Estado de prestador (disponible/ocupado/inactivo).
- REQ-22 Estado de domiciliario (disponible/ocupado/inactivo).
- REQ-23 Solicitud directa/asignada de domicilio.
- REQ-24 Filtros de contactos.
- REQ-25 Reporte financiero agregado de domiciliarios.
- REQ-26 Uso de variables de entorno.
- REQ-27 PostgreSQL en produccion.
- REQ-28 Configuracion CORS segura.

### 6.1.1 Requisitos funcionales detallados (REQ-01 a REQ-28)

#### REQ-01 — Registro de Usuario

| | | |
|---|---|---|
| **Codigo** | REQ-01 | |
| **Nombre** | Registro de usuario | |
| **Descripcion** | Permite que un nuevo usuario cree una cuenta proporcionando nombre, apellido, correo, telefono y contrasena. El usuario queda registrado por defecto como CLIENTE o como el rol permitido que seleccione, segun la politica de la plataforma. | |
| **Actores** | Usuario nuevo, App (Flutter Movil), API Django | |
| **Precondicion** | El usuario no debe estar registrado previamente con el mismo correo electronico. | |
| **Secuencia normal** | 1. El usuario diligencia el formulario de registro con datos completos. 2. La app valida formato de email y coincidencia de contrasenas. 3. La app envia POST /api/v1/auth/register/. 4. El backend valida unicidad del correo y fortaleza de contrasena. 5. Se crea el usuario con rol CLIENTE por defecto. 6. Se generan tokens JWT access/refresh. 7. La app guarda tokens y redirige a Home. | |
| **Secuencia alterna** | Si el correo ya existe, el backend retorna 400 con mensaje "Este correo ya esta registrado". La app muestra el error en el campo email y mantiene el resto de datos. | |
| **Excepciones** | E1: Error de conexion -> SnackBar "Sin conexion, verifica tu red". E2: Datos malformados -> 400 con detalle de campos invalidos. E3: Error servidor -> 500 con mensaje generico. | |
| **Postcondicion** | Usuario creado con rol CLIENTE, tokens JWT activos y perfil cargado en la app. | |
| **Comentarios** | Contrasena almacenada con hash bcrypt de Django. Email definido como unique=True en el modelo User. | |

---

#### REQ-02 — Inicio de Sesion con JWT

| | | |
|---|---|---|
| **Codigo** | REQ-02 | |
| **Nombre** | Login con JWT access/refresh | |
| **Descripcion** | Permite iniciar sesion con access token de corta duracion y refresh token de 7 dias para mantener sesiones seguras. La app gestiona la renovacion automatica del access token. | |
| **Actores** | Usuario registrado, App (Flutter Movil), API Django | |
| **Precondicion** | Usuario activo con credenciales validas. | |
| **Secuencia normal** | 1. Usuario ingresa correo y contrasena. 2. POST /api/v1/auth/login/. 3. Backend valida y retorna access/refresh. 4. App almacena tokens en SecureStorage. 5. App obtiene perfil (GET /api/v1/auth/profile/). 6. App navega al Home segun rol. | |
| **Secuencia alterna** | Credenciales invalidas: backend retorna 401 con mensaje generico. La app muestra error sin revelar informacion sensible. | |
| **Excepciones** | E1: access expira -> interceptor renueva con refresh. E2: refresh expira -> limpiar storage y redirigir a login. | |
| **Postcondicion** | Sesion iniciada con tokens activos y perfil cargado. | |
| **Comentarios** | Ajustar tiempos de expiracion segun politica de seguridad. | |

---

#### REQ-03 — Listado de comercios y productos por categoria

| | | |
|---|---|---|
| **Codigo** | REQ-03 | |
| **Nombre** | Catalogo por categoria con filtros | |
| **Descripcion** | El cliente explora comercios y productos filtrados por categoria y puede aplicar filtros basicos. La vista prioriza rapidez y claridad en el catalogo. | |
| **Actores** | Cliente, App (Flutter Movil), API Django | |
| **Precondicion** | Existen categorias, comercios y productos activos. | |
| **Secuencia normal** | 1. Cliente abre "Tienda". 2. App consulta categorias y comercios. 3. Cliente selecciona una categoria. 4. App filtra y muestra comercios. 5. Cliente abre detalle y ve productos. | |
| **Secuencia alterna** | Si no hay comercios en la categoria, se muestra estado vacio con mensaje explicativo. | |
| **Excepciones** | E1: Error API -> widget de error con reintentar. E2: Sin internet -> aviso y cache local si existe. | |
| **Postcondicion** | El cliente visualiza catalogo actualizado. | |
| **Comentarios** | Usar imagenes optimizadas y cache local cuando aplique. | |

---

#### REQ-04 — Generacion de domicilio desde tienda (sin carrito)

| | | |
|---|---|---|
| **Codigo** | REQ-04 | |
| **Nombre** | Domicilio generado desde la tienda | |
| **Descripcion** | No existe carrito persistido. El usuario solicita un domicilio directamente desde el comercio, indicando lo que necesita pedir. La tienda actua como punto de inicio del domicilio. | |
| **Actores** | Cliente, App (Flutter Movil), API Django | |
| **Precondicion** | Usuario autenticado y comercio disponible. | |
| **Secuencia normal** | 1. Cliente abre un comercio en la tienda. 2. Indica el pedido o detalle de la solicitud. 3. La app crea la solicitud de domicilio asociada al comercio. 4. Backend registra el domicilio con estado inicial. | |
| **Secuencia alterna** | Si el comercio no esta disponible, la app muestra aviso y no permite crear la solicitud. | |
| **Excepciones** | E1: Error API -> se notifica y permite reintentar. | |
| **Postcondicion** | Domicilio creado y asociado al comercio desde la tienda. | |
| **Comentarios** | Este flujo reemplaza el carrito: la solicitud se genera directamente desde la tienda. | |

---

#### REQ-05 — Creacion y seguimiento de ordenes

| | | |
|---|---|---|
| **Codigo** | REQ-05 | |
| **Nombre** | Ordenes con estados | |
| **Descripcion** | El cliente crea pedidos y consulta su estado y detalle. Se muestran estados y un historial de compras. | |
| **Actores** | Cliente, App (Flutter Movil), API Django, Comercio | |
| **Precondicion** | Carrito con items validos. | |
| **Secuencia normal** | 1. Cliente confirma pedido. 2. App envia POST /api/v1/store/orders/create/. 3. Backend crea orden con estado inicial. 4. App muestra confirmacion y permite ver historial. | |
| **Secuencia alterna** | Producto agotado: backend rechaza y app ajusta carrito. | |
| **Excepciones** | E1: Error API -> se conserva carrito y se reintenta. | |
| **Postcondicion** | Orden creada y visible en historial. | |
| **Comentarios** | Estados: PENDIENTE, EN_PROCESO, ENTREGADO, CANCELADO. | |

---

#### REQ-06 — Solicitud de domicilio con direccion origen y destino

| | | |
|---|---|---|
| **Codigo** | REQ-06 | |
| **Nombre** | Solicitud de domicilio general | |
| **Descripcion** | El cliente solicita un domicilio indicando origen y destino con datos basicos, permitiendo trazabilidad del servicio. | |
| **Actores** | Cliente, App (Flutter Movil), API Django | |
| **Precondicion** | Usuario autenticado. | |
| **Secuencia normal** | 1. Cliente diligencia origen/destino. 2. App valida campos obligatorios. 3. POST /api/v1/deliveries/requests/. 4. Backend registra solicitud y retorna identificador. | |
| **Secuencia alterna** | Direcciones incompletas: la app bloquea envio y muestra validaciones. | |
| **Excepciones** | E1: Error API -> reintentar. | |
| **Postcondicion** | Solicitud creada con estado inicial. | |
| **Comentarios** | Incluir telefono de contacto si aplica. | |

---

#### REQ-07 — Asignacion automatica de domiciliario disponible

| | | |
|---|---|---|
| **Codigo** | REQ-07 | |
| **Nombre** | Autoasignacion por menor assigned_number | |
| **Descripcion** | El sistema asigna el domiciliario disponible con menor numero asignado para balancear la carga de trabajo. | |
| **Actores** | Sistema, API Django, Domiciliario | |
| **Precondicion** | Domiciliarios DISPONIBLE registrados. | |
| **Secuencia normal** | 1. Se crea solicitud. 2. Backend selecciona domiciliario con menor assigned_number. 3. Marca solicitud como ASIGNADA y domiciliario como OCUPADO. | |
| **Secuencia alterna** | Sin disponibles: solicitud queda PENDIENTE hasta nueva disponibilidad. | |
| **Excepciones** | E1: Error de asignacion -> registrar y notificar. | |
| **Postcondicion** | Solicitud asignada o pendiente. | |
| **Comentarios** | Registrar trazabilidad de asignacion. | |

---

#### REQ-08 — Seguimiento del estado del domicilio

| | | |
|---|---|---|
| **Codigo** | REQ-08 | |
| **Nombre** | Seguimiento de estados del domicilio | |
| **Descripcion** | Permite a cliente y domiciliario consultar el estado del domicilio y ver avances del servicio. | |
| **Actores** | Cliente, Domiciliario, App (Flutter Movil), API Django | |
| **Precondicion** | Solicitud existente. | |
| **Secuencia normal** | 1. Usuario abre detalle del domicilio. 2. App consulta estado. 3. Se muestra estado y timeline si aplica. | |
| **Secuencia alterna** | Sin datos: estado vacio con mensaje. | |
| **Excepciones** | E1: Error API -> reintentar. | |
| **Postcondicion** | Estado actualizado visible. | |
| **Comentarios** | Estados sugeridos: PENDIENTE, ASIGNADO, EN_CAMINO, ENTREGADO. | |

---

#### REQ-09 — Registro de prestadores con perfil, foto y hoja de vida

| | | |
|---|---|---|
| **Codigo** | REQ-09 | |
| **Nombre** | Registro de prestadores con documentos | |
| **Descripcion** | El usuario se registra como prestador con perfil profesional, foto y hoja de vida en PDF para validacion administrativa. | |
| **Actores** | Prestador, App (Flutter Movil), API Django | |
| **Precondicion** | Usuario autenticado y categorias de servicio disponibles. | |
| **Secuencia normal** | 1. Usuario completa formulario y adjunta PDF/foto. 2. App envia multipart. 3. Backend crea perfil PENDIENTE. | |
| **Secuencia alterna** | Archivo demasiado grande o formato invalido: se bloquea envio. | |
| **Excepciones** | E1: Error de red -> reintentar. | |
| **Postcondicion** | Prestador registrado en estado PENDIENTE. | |
| **Comentarios** | Validar tipos de archivo y tamanos permitidos. | |

---

#### REQ-10 — Aprobacion/rechazo de prestadores por admin

| | | |
|---|---|---|
| **Codigo** | REQ-10 | |
| **Nombre** | Aprobacion administrativa con motivo | |
| **Descripcion** | El administrador aprueba o rechaza prestadores indicando motivo para garantizar calidad del servicio. | |
| **Actores** | Administrador, App (Flutter Movil), API Django | |
| **Precondicion** | Prestador en estado PENDIENTE. | |
| **Secuencia normal** | 1. Admin revisa perfil. 2. Selecciona aprobar o rechazar. 3. Backend actualiza estado y guarda motivo. | |
| **Secuencia alterna** | Admin cancela la accion sin cambios. | |
| **Excepciones** | E1: Error API -> reintentar. | |
| **Postcondicion** | Prestador actualizado y visible segun estado. | |
| **Comentarios** | Registrar motivo de rechazo para visibilidad del prestador. | |

---

#### REQ-11 — Solicitud de servicio por cliente

| | | |
|---|---|---|
| **Codigo** | REQ-11 | |
| **Nombre** | Solicitud de servicio a prestador aprobado | |
| **Descripcion** | El cliente solicita un servicio a un prestador disponible y aprobado. | |
| **Actores** | Cliente, Prestador, App (Flutter Movil), API Django | |
| **Precondicion** | Prestador aprobado y disponible. | |
| **Secuencia normal** | 1. Cliente selecciona prestador. 2. Describe la solicitud. 3. Backend crea ServiceRequest. | |
| **Secuencia alterna** | Sin prestadores: se muestra aviso. | |
| **Excepciones** | E1: Error API -> se notifica. | |
| **Postcondicion** | Solicitud registrada en estado PENDIENTE. | |
| **Comentarios** | Mostrar datos de contacto del prestador. | |

---

#### REQ-12 — Directorio de contactos de emergencia con filtros

| | | |
|---|---|---|
| **Codigo** | REQ-12 | |
| **Nombre** | Directorio de contactos con filtros | |
| **Descripcion** | Consulta contactos utiles con filtros por tipo y disponibilidad para respuesta rapida. | |
| **Actores** | Usuario, App (Flutter Movil), API Django | |
| **Precondicion** | Contactos activos cargados. | |
| **Secuencia normal** | 1. Usuario abre Contactos. 2. Aplica filtros. 3. App muestra resultados. | |
| **Secuencia alterna** | Sin resultados: se muestra vacio. | |
| **Excepciones** | E1: Error API -> se muestra error. | |
| **Postcondicion** | Contactos filtrados visibles. | |
| **Comentarios** | Permitir busqueda por texto. | |

---

#### REQ-13 — Dashboard con metricas de operacion

| | | |
|---|---|---|
| **Codigo** | REQ-13 | |
| **Nombre** | Dashboard administrativo | |
| **Descripcion** | Muestra metricas clave de usuarios, pedidos, servicios y domicilios para decisiones operativas. | |
| **Actores** | Administrador, App (Flutter Movil), API Django | |
| **Precondicion** | Admin autenticado. | |
| **Secuencia normal** | 1. Admin abre Dashboard. 2. App consulta /reports/dashboard/. 3. Se muestran tarjetas resumen. | |
| **Secuencia alterna** | Sin datos: se muestran ceros. | |
| **Excepciones** | E1: Error API -> reintentar. | |
| **Postcondicion** | Dashboard visible y actualizado. | |
| **Comentarios** | Incluir KPIs minimos acordados. | |

---

#### REQ-14 — Reportes por modulo y periodo

| | | |
|---|---|---|
| **Codigo** | REQ-14 | |
| **Nombre** | Reportes por periodo | |
| **Descripcion** | Reportes de domicilios, servicios y tienda filtrados por fecha para analisis. | |
| **Actores** | Administrador, App (Flutter Movil), API Django | |
| **Precondicion** | Admin autenticado. | |
| **Secuencia normal** | 1. Admin elige periodo. 2. App consulta endpoints de reporte. 3. Muestra tablas o graficos. | |
| **Secuencia alterna** | Sin datos: se muestra vacio. | |
| **Excepciones** | E1: Error API -> se muestra mensaje. | |
| **Postcondicion** | Reportes visualizados. | |
| **Comentarios** | Exportacion futura a CSV/PDF. | |

---

#### REQ-15 — Gestion de usuarios, comercios y configuracion

| | | |
|---|---|---|
| **Codigo** | REQ-15 | |
| **Nombre** | Gestion administrativa integral | |
| **Descripcion** | El admin gestiona usuarios, comercios y parametros de configuracion con acciones de activacion y edicion. | |
| **Actores** | Administrador, App (Flutter Movil), API Django | |
| **Precondicion** | Admin autenticado. | |
| **Secuencia normal** | 1. Admin ingresa a gestion. 2. Lista registros con filtros. 3. Edita o cambia estado. | |
| **Secuencia alterna** | Sin registros: se muestra vacio. | |
| **Excepciones** | E1: Error al actualizar -> revertir cambios. | |
| **Postcondicion** | Cambios guardados en backend. | |
| **Comentarios** | Aplicar permisos estrictos y auditoria. | |

---

#### REQ-16 — Registro y gestion de domiciliarios

| | | |
|---|---|---|
| **Codigo** | REQ-16 | |
| **Nombre** | Registro de domiciliarios con numero asignado | |
| **Descripcion** | El admin crea domiciliarios, asigna numero unico y gestiona su estado operativo. | |
| **Actores** | Administrador, App (Flutter Movil), API Django | |
| **Precondicion** | Admin autenticado. | |
| **Secuencia normal** | 1. Admin crea domiciliario. 2. Backend valida numero unico. 3. Domiciliario aparece en listados. | |
| **Secuencia alterna** | Numero duplicado: se rechaza. | |
| **Excepciones** | E1: Error API -> se notifica. | |
| **Postcondicion** | Domiciliario registrado. | |
| **Comentarios** | assigned_number es identificador operativo. | |

---

#### REQ-17 — Registro de ingresos y egresos con comision

| | | |
|---|---|---|
| **Codigo** | REQ-17 | |
| **Nombre** | Registro financiero del domiciliario | |
| **Descripcion** | Registra ingresos/egresos y calcula comision automatica para balance y trazabilidad. | |
| **Actores** | Domiciliario, Administrador, App (Flutter Movil), API Django | |
| **Precondicion** | Domiciliario autenticado. | |
| **Secuencia normal** | 1. Domiciliario registra monto. 2. Backend calcula comision y balance. 3. App actualiza panel financiero. | |
| **Secuencia alterna** | Monto invalido: se bloquea envio. | |
| **Excepciones** | E1: Error API -> se notifica. | |
| **Postcondicion** | Registro financiero guardado. | |
| **Comentarios** | Comision configurable desde SystemConfig. | |

---

#### REQ-18 — Cierre de sesion seguro

| | | |
|---|---|---|
| **Codigo** | REQ-18 | |
| **Nombre** | Logout con invalidacion de tokens | |
| **Descripcion** | Cierra sesion e invalida tokens en backend y storage local para evitar reuso. | |
| **Actores** | Usuario, App (Flutter Movil), API Django | |
| **Precondicion** | Usuario autenticado. | |
| **Secuencia normal** | 1. Usuario pulsa "Salir". 2. App llama /auth/logout/. 3. Backend invalida token. 4. App limpia storage y redirige a login. | |
| **Secuencia alterna** | Si falla el endpoint, se limpia sesion local. | |
| **Excepciones** | E1: Error de red -> reintentar. | |
| **Postcondicion** | Sesion cerrada e invalida. | |
| **Comentarios** | Evitar reuso de refresh token. | |

---

#### REQ-19 — Control de acceso por rol

| | | |
|---|---|---|
| **Codigo** | REQ-19 | |
| **Nombre** | Roles y control de acceso | |
| **Descripcion** | Restringe funciones por rol en backend y frontend, asegurando que cada usuario vea solo lo permitido. | |
| **Actores** | Sistema, App (Flutter Movil), API Django | |
| **Precondicion** | Usuario autenticado con rol. | |
| **Secuencia normal** | 1. Usuario intenta acceder a un modulo. 2. Backend valida permisos. 3. Frontend aplica guard y redirige si no corresponde. | |
| **Secuencia alterna** | Acceso denegado: se muestra mensaje de permiso. | |
| **Excepciones** | E1: Token invalido -> redirige a login. | |
| **Postcondicion** | Acceso restringido por rol. | |
| **Comentarios** | Alinear permisos backend y rutas frontend. | |

---

#### REQ-20 — Busqueda de prestadores por categoria

| | | |
|---|---|---|
| **Codigo** | REQ-20 | |
| **Nombre** | Busqueda de prestadores por categoria | |
| **Descripcion** | Permite filtrar prestadores por categoria de servicio y mostrar solo aprobados y disponibles. | |
| **Actores** | Cliente, App (Flutter Movil), API Django | |
| **Precondicion** | Prestadores aprobados y categorias activas. | |
| **Secuencia normal** | 1. Cliente selecciona categoria. 2. App consulta /services/providers/?category=. 3. Lista prestadores disponibles. | |
| **Secuencia alterna** | Sin prestadores: estado vacio. | |
| **Excepciones** | E1: Error API -> se notifica. | |
| **Postcondicion** | Prestadores visibles segun categoria. | |
| **Comentarios** | Mostrar solo aprobados y DISPONIBLE. | |

---

#### REQ-21 — Cambio de estado del prestador

| | | |
|---|---|---|
| **Codigo** | REQ-21 | |
| **Nombre** | Estado DISPONIBLE/OCUPADO/INACTIVO | |
| **Descripcion** | El prestador actualiza su estado para controlar visibilidad y disponibilidad en la plataforma. | |
| **Actores** | Prestador, App (Flutter Movil), API Django | |
| **Precondicion** | Prestador aprobado. | |
| **Secuencia normal** | 1. Prestador cambia estado. 2. App envia PATCH /services/providers/status/. 3. Backend actualiza estado. | |
| **Secuencia alterna** | Si tiene solicitudes activas, se pide confirmacion. | |
| **Excepciones** | E1: Error API -> revertir UI. | |
| **Postcondicion** | Estado actualizado y visible. | |
| **Comentarios** | Aplicar actualizacion optimista. | |

---

#### REQ-22 — Cambio de estado del domiciliario

| | | |
|---|---|---|
| **Codigo** | REQ-22 | |
| **Nombre** | Estado DISPONIBLE/OCUPADO/INACTIVO | |
| **Descripcion** | El domiciliario cambia su estado operativo para aceptar o pausar solicitudes. | |
| **Actores** | Domiciliario, App (Flutter Movil), API Django | |
| **Precondicion** | Domiciliario autenticado. | |
| **Secuencia normal** | 1. Domiciliario cambia estado. 2. App envia PATCH /deliveries/deliverers/status/. 3. Backend actualiza estado. | |
| **Secuencia alterna** | Si tiene domicilios activos, se pide confirmacion. | |
| **Excepciones** | E1: Error API -> revertir UI. | |
| **Postcondicion** | Estado actualizado y visible. | |
| **Comentarios** | Evitar inactivar con entregas activas. | |

---

#### REQ-23 — Solicitud directa de domicilio a domiciliario especifico

| | | |
|---|---|---|
| **Codigo** | REQ-23 | |
| **Nombre** | Solicitud directa de domicilio | |
| **Descripcion** | El cliente solicita un domiciliario disponible especifico, evitando la autoasignacion. | |
| **Actores** | Cliente, Domiciliario, App (Flutter Movil), API Django | |
| **Precondicion** | Domiciliario DISPONIBLE. | |
| **Secuencia normal** | 1. Cliente selecciona domiciliario. 2. App crea solicitud directa. 3. Backend asigna el domiciliario seleccionado. | |
| **Secuencia alterna** | Si el domiciliario cambia a OCUPADO, se informa al cliente. | |
| **Excepciones** | E1: Error API -> se notifica. | |
| **Postcondicion** | Solicitud asignada al domiciliario elegido. | |
| **Comentarios** | Validar disponibilidad al confirmar. | |

---

#### REQ-24 — Filtrado de contactos por tipo y disponibilidad

| | | |
|---|---|---|
| **Codigo** | REQ-24 | |
| **Nombre** | Filtros de contactos | |
| **Descripcion** | Filtra contactos por tipo y estado de disponibilidad para encontrar rapidamente opciones relevantes. | |
| **Actores** | Usuario, App (Flutter Movil), API Django | |
| **Precondicion** | Contactos con tipo y disponibilidad definidos. | |
| **Secuencia normal** | 1. Usuario aplica filtros. 2. App consulta con query params. 3. Muestra resultados. | |
| **Secuencia alterna** | Sin resultados: muestra vacio. | |
| **Excepciones** | E1: Error API -> se muestra error. | |
| **Postcondicion** | Contactos filtrados visibles. | |
| **Comentarios** | Incluir busqueda por texto. | |

---

#### REQ-25 — Reporte financiero agregado de domiciliarios

| | | |
|---|---|---|
| **Codigo** | REQ-25 | |
| **Nombre** | Reporte financiero agregado | |
| **Descripcion** | Reporte de ingresos, egresos y comisiones por domiciliario para control financiero. | |
| **Actores** | Administrador, App (Flutter Movil), API Django | |
| **Precondicion** | Admin autenticado. | |
| **Secuencia normal** | 1. Admin selecciona periodo. 2. App consulta /reports/deliverers/. 3. Se muestran totales y balance. | |
| **Secuencia alterna** | Sin datos: se muestra vacio. | |
| **Excepciones** | E1: Error API -> se notifica. | |
| **Postcondicion** | Reporte financiero visible. | |
| **Comentarios** | Incluir totales y balance neto. | |

---

#### REQ-26 — Uso de variables de entorno

| | | |
|---|---|---|
| **Codigo** | REQ-26 | |
| **Nombre** | Variables .env para configuracion sensible | |
| **Descripcion** | Configuracion sensible se maneja con variables de entorno para separar secretos del codigo. | |
| **Actores** | Equipo tecnico, Backend, Frontend | |
| **Precondicion** | Archivos .env definidos. | |
| **Secuencia normal** | 1. Entorno carga variables. 2. Backend/Frontend usan valores sin exponer secretos. | |
| **Secuencia alterna** | Falta variable: usar valor por defecto seguro. | |
| **Excepciones** | E1: Variable critica ausente -> aborta inicio. | |
| **Postcondicion** | Configuracion sensible aislada. | |
| **Comentarios** | Mantener .env.example actualizado. | |

---

#### REQ-27 — PostgreSQL como base de datos de produccion

| | | |
|---|---|---|
| **Codigo** | REQ-27 | |
| **Nombre** | PostgreSQL en produccion | |
| **Descripcion** | El entorno productivo usa PostgreSQL como base principal por estabilidad y escalabilidad. | |
| **Actores** | Equipo tecnico, Backend | |
| **Precondicion** | Instancia PostgreSQL disponible. | |
| **Secuencia normal** | 1. Configurar credenciales/URL. 2. Ejecutar migraciones. 3. Verificar conexion y operaciones. | |
| **Secuencia alterna** | Si falla migracion, revisar compatibilidad. | |
| **Excepciones** | E1: Conexion fallida -> detener despliegue. | |
| **Postcondicion** | BD productiva operativa. | |
| **Comentarios** | Usar psycopg2-binary en requirements. | |

---

#### REQ-28 — Configuracion CORS segura

| | | |
|---|---|---|
| **Codigo** | REQ-28 | |
| **Nombre** | CORS seguro para API | |
| **Descripcion** | El backend permite solo origenes autorizados para proteger la API. | |
| **Actores** | Backend, Frontend | |
| **Precondicion** | Lista de dominios permitidos definida. | |
| **Secuencia normal** | 1. Configurar allowed origins. 2. Requests validos son aceptados. | |
| **Secuencia alterna** | Origen no permitido: se rechaza con error. | |
| **Excepciones** | E1: Configuracion incorrecta -> ajustar settings. | |
| **Postcondicion** | CORS restringido y funcional. | |
| **Comentarios** | No usar wildcard en produccion. | |

### 6.2 Historias de usuario (backlog)

El backlog oficial consolida 25 historias (HU-01 a HU-25) agrupadas en 7 epicas:

- Core y configuracion.
- Autenticacion y navegacion.
- Tienda y compras.
- Servicios profesionales.
- Domicilios y finanzas.
- Contactos/directorio/llamadas.
- Administracion.

## 7. Requisitos No Funcionales Consolidados

RNF documentados:

- RNF-01 Seguridad: hash de contrasenas, JWT, almacenamiento seguro de tokens.
- RNF-02 Rendimiento: objetivo de latencia en endpoints principales y paginacion.
- RNF-03 Escalabilidad: arquitectura modular separada frontend/backend.
- RNF-04 Mantenibilidad: estructura por modulos (apps/features) y clean architecture.
- RNF-05 Observabilidad: logs backend + manejo estructurado de errores frontend.
- RNF-06 Compatibilidad: app movil Android/iOS y backend portable a PostgreSQL.
- RNF-07 Disponibilidad: operacion esperada 24/7 en entorno productivo.

Complementarios:

- Usabilidad: navegacion por rol, estados de carga/error/vacio.
- Confiabilidad: renovacion automatica de token y resiliencia de red.
- Portabilidad: ejecucion local en Windows/Linux/macOS con stack estandar.

## 8. Reglas de Negocio Principales

Consolidacion de reglas relevantes:

- RN-01 Acceso exclusivo por rol.
- RN-02 Email unico por usuario.
- RN-03 Login seguro con JWT y expiracion.
- RN-04 Carrito no puede confirmarse vacio/invalido.
- RN-05 Productos no disponibles no se venden.
- RN-06 Orden se crea con estado inicial y precios historicos.
- RN-07 Domicilio se auto-asigna a domiciliario disponible (o queda pendiente sin asignar).
- RN-08 Cierre de domicilio libera domiciliario y registra trazabilidad.
- RN-09 Registro financiero de domicilio incluye comision y neto.
- RN-10 Prestador no aprobado no aparece para clientes.
- RN-11 Evitar duplicidad de solicitudes de servicio activas.
- RN-12 Calculo de total de servicio segun configuracion.
- RN-13 Solo contactos activos visibles publicamente.
- RN-14 Gestion de contactos restringida a admin.

Reglas adicionales en entregas/finanzas:

- Tarifas por zona, tipo de solicitud, items y puntos.
- Recargo por transferencia segun umbral de configuracion.
- Clasificaciones financieras: NEGRO, ROJO, AZUL.

## 9. Arquitectura y Tecnologias

### 9.1 Arquitectura

- Estilo general: cliente-servidor.
- Frontend: Flutter con enfoque de Clean Architecture (presentation/domain/data).
- Backend: Django + DRF (modelos, serializadores, vistas, urls).
- Integracion: API REST JSON + JWT Bearer.
- Tiempo real: WebSocket para chat por hilos.

### 9.2 Stack tecnologico consolidado

Frontend:

- Flutter 3.x
- Dart 3.x
- Riverpod
- GoRouter
- Dio
- Hive / Hive Flutter
- Flutter Secure Storage
- Cached Network Image

Backend:

- Python 3.12
- Django 5.2.x
- Django REST Framework 3.16.x
- SimpleJWT
- django-cors-headers
- Pillow
- python-dotenv
- SQLite (desarrollo)
- PostgreSQL + psycopg2-binary (produccion)

Herramientas:

- Git + GitHub
- Postman (coleccion de API)
- VS Code

## 10. Estructura del Proyecto

Estructura consolidada (alto nivel):

```text
runners/
├── frontend/
│   ├── lib/
│   │   ├── features/ (auth, store, services, deliveries, contacts, admin)
│   │   ├── core/ (api, auth, providers, storage, services)
│   │   └── shared/ (widgets, theme, extensions)
│   ├── android/
│   ├── ios/
│   ├── web/
│   └── pubspec.yaml
├── backend/
│   ├── apps/ (users, store, services, deliveries, contacts, reports, chat)
│   ├── runners_project/ (settings, urls, asgi, wsgi)
│   ├── manage.py
│   ├── requirements.txt
│   └── runners_api_postman.json
└── documentacion/*.md
```

## 11. Flujos Funcionales Clave

### 11.1 Autenticacion

- Registro/login.
- Almacenamiento de tokens.
- Renovacion de access token con refresh.
- Redireccion por rol.

### 11.2 Tienda

- Listado de comercios y productos.
- Carrito y confirmacion de orden.
- Historial de pedidos.

### 11.3 Servicios

- Registro de prestador con evidencia.
- Aprobacion/rechazo admin.
- Solicitud de servicio por cliente.
- Gestion de solicitudes por prestador/admin.

### 11.4 Domicilios

- Creacion de solicitud (general o desde tienda).
- Auto-asignacion (si hay disponibilidad).
- Cambio de estados hasta cierre/cancelacion.
- Registro financiero vinculado.

### 11.5 Contactos

- Consulta y filtros de directorio.
- Gestion administrativa de entradas.

### 11.6 Administracion y reportes

- Dashboard general.
- Reportes de ventas, domicilios, servicios, finanzas, contactos y domiciliarios.

### 11.7 Chat interno

- Apertura de hilo por contexto (domicilio o servicio).
- Mensajeria por REST y WebSocket.

## 12. API y Protocolos

### 12.1 Base y autenticacion

- Base REST: /api/v1
- Auth: Authorization: Bearer <access_token>

### 12.2 Endpoints principales por modulo

- Auth: /auth/login, /auth/register, /auth/profile, refresh token.
- Store: /store/commerces, /store/products, /store/orders.
- Deliveries: /deliveries/requests, /deliveries/deliverers, /deliveries/records, /deliveries/zones, /deliveries/pricing-rules.
- Services: /services/providers, /services/requests.
- Contacts: /contacts.
- Reports: /reports/dashboard, /reports/deliveries, /reports/finance, /reports/services, /reports/sales, /reports/contacts.
- Chat REST: /chat/threads/open, /chat/threads, /chat/threads/{id}/messages.

### 12.3 WebSocket

- Ruta: /ws/chat/threads/{thread_id}/?token=<access_token>
- Uso: mensajes de chat en tiempo real.

## 13. Datos, Configuracion y Operacion

### 13.1 Entornos y variables

Frontend (.env):

- API_BASE_URL
- APP_NAME

Backend (.env):

- DEBUG
- ALLOWED_HOSTS
- CORS
- JWT_ACCESS_TOKEN_LIFETIME_MINUTES
- JWT_REFRESH_TOKEN_LIFETIME_DAYS

### 13.2 URLs relevantes

- Backend local: http://localhost:8000
- API local: http://localhost:8000/api/v1
- API emulador Android: http://10.0.2.2:8000/api/v1
- Admin: http://localhost:8000/admin/

### 13.3 Credenciales de prueba

- Admin: admin@runners.co / Admin2024!
- Cliente: cliente1@runners.co / Runners2024!
- Domiciliario: domi1@runners.co / Runners2024!
- Prestador: prest1@runners.co / Runners2024!

### 13.4 Datos semilla y estado verificado

Se reporta en documentacion de verificacion:

- Apps backend activas.
- Endpoints principales respondiendo.
- Migraciones aplicadas.
- Integracion frontend-backend operativa.

## 14. Instalacion, Ejecucion y Verificacion

### 14.1 Backend

- Instalar dependencias.
- Ejecutar migraciones.
- Cargar seed data.
- Levantar servidor Django.

### 14.2 Frontend

- flutter pub get.
- flutter run en emulador/dispositivo.

### 14.3 Verificaciones recomendadas

- Backend: check, migrate, seed_data.
- Frontend: flutter analyze, flutter test.
- API: pruebas con Postman/curl de login y endpoints principales.

## 15. Gestion del Proyecto

### 15.1 Metodologia

- Enfoque agil (Scrum/Kanban).
- Historias de usuario por modulo.
- Iteraciones por sprint.
- Control de versiones y PR.

### 15.2 Calidad y colaboracion

- Estrategia de ramas: feature/fix/refactor/docs/chore/hotfix.
- Convencion de commits semanticos.
- PR con revision y checks (frontend/backend).

### 15.3 Riesgos y mitigacion

Riesgos priorizados:

- Retrasos de cronograma.
- Cambios de requisitos.
- Problemas de dependencias/entorno.
- Fallas de despliegue y migracion a produccion.
- Riesgos de coordinacion de equipo.

Mitigaciones:

- Documentacion centralizada.
- Control de cambios por PR.
- Entornos reproducibles.
- Buffer de contingencia en sprint.

### 15.4 Presupuesto y recursos

- Proyecto de base academica con herramientas open-source.
- Costos operativos directos actuales: bajos o nulos en entorno local.

### 15.5 Stakeholders

- Internos: equipo de desarrollo, docentes/jurados.
- Externos: empresa Runners, comercios, prestadores, domiciliarios, clientes.

## 16. Inconsistencias Detectadas y Criterio de Canon

Durante la consolidacion se encontraron diferencias entre documentos en algunos detalles (ejemplo: tiempos de expiracion de tokens, alcance iOS en ciertos textos, endpoints historicos vs actuales).

Criterio recomendado para mantener consistencia:

- Tomar como referencia operativa principal: README.md, QUICKSTART.md, VERIFICACION.md y backend/GUIA_API_FRONTEND_BACKEND.md.
- Mantener este archivo como documento maestro y actualizarlo cuando cambie API, reglas o arquitectura.
- Sincronizar cualquier cambio funcional en:
  - README.md
  - QUICKSTART.md
  - backend/runners_api_postman.json
  - CLICKUP_HISTORIAS_USUARIO.md (si afecta backlog)

## 17. Mapa de Fuentes Documentales Consolidadas

Documentos base usados para esta consolidacion:

- CARTA_DE_INICIO.md
- Documento_Desarrollo_Runners.md
- README.md
- RESUMEN_EJECUTIVO.md
- QUICKSTART.md
- PROYECTO_ESTRUCTURA.md
- VERIFICACION.md
- INDICE.md
- START_HERE.md
- CLICKUP_HISTORIAS_USUARIO.md
- runners_flutter_implementacion.md
- runners_guia_implementacion_web.md
- Flutter_Auth_Screens.md
- SITEMAP.md
- backend/GUIA_API_FRONTEND_BACKEND.md

## 18. Estado General del Proyecto

Estado consolidado reportado: funcional y organizado, con backend y frontend integrados, documentacion extensa y base lista para refinamiento, optimizacion y fortalecimiento de pruebas.

## 19. Proximos Pasos Recomendados

- Definir una sola fuente de verdad para configuraciones criticas (JWT, entornos, endpoints).
- Aumentar cobertura de pruebas automatizadas (backend y frontend).
- Fortalecer estrategia de despliegue productivo (CI/CD, monitoreo, backup, hardening).
- Planificar roadmap de mejoras (pagos, notificaciones, geolocalizacion, observabilidad avanzada).
