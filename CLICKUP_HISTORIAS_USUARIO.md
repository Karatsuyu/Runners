# Backlog Oficial de Historias de Usuario - Runners (100% Fiel al Proyecto)

Este documento contiene las **25 Historias de Usuario** originales e íntegras definidas en el archivo maestro de implementación del proyecto (`runners_flutter_implementacion.md`), mapeadas a través de sus **7 Épicas**. 
Listas para importar directamente como tareas en **ClickUp**. Cada una con 5 a 6 Criterios de Aceptación (CA) detallados y su rigurosa Definition of Done (DoD).

---

## 🏗️ ÉPICA 01: Core & Configuración

### HU-01: Registro de Usuario (Cliente)
**Descripción:** Como prospecto cliente, necesito registrarme en la app con mis datos para crear una cuenta y acceder al sistema.
**Puntos:** 2 | **Prioridad:** Urgente
**Criterios de Aceptación:**
*   [ ] CA1: El formulario de registro solicita email, contraseña, confirmación de contraseña, nombre, apellido y teléfono (6 campos).
*   [ ] CA2: Las validaciones verifican que el email no esté registrado, las contraseñas coincidan y cumplan con requisitos mínimos.
*   [ ] CA3: Un registro exitoso crea el usuario en la BD con rol CLIENTE por defecto y redirige a Login.
*   [ ] CA4: Los errores del backend (email duplicado, etc.) se muestran al usuario de forma clara.
*   [ ] CA5: La página es responsive y funciona en móvil, tablet y desktop.

**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de registro con múltiples casos realizadas.
*   [ ] Validaciones de formulario implementadas correctamente.
*   [ ] Usuario persistido correctamente en BD (Django Admin verificado).
*   [ ] Roles y reglas de negocio aplicadas (rol CLIENTE asignado automáticamente).
*   [ ] Evidencia adjunta: capturas de pantalla y video del flujo.
*   [ ] Documentación mínima actualizada en README.

---

### HU-02: Login de Usuario
**Descripción:** Como usuario registrado, necesito iniciar sesión con mis credenciales (email y contraseña) para acceder a mi módulo correspondiente según mi rol.
**Puntos:** 2 | **Prioridad:** Urgente
**Criterios de Aceptación:**
*   [ ] CA1: El formulario de login solicita email y contraseña con validación de campos vacíos.
*   [ ] CA2: El sistema consulta el endpoint `/api/v1/auth/login/` y retorna `access_token` + `refresh_token` si las credenciales son válidas.
*   [ ] CA3: Los tokens se guardan de forma segura en `SecureStorage` tras un login exitoso.
*   [ ] CA4: Un login exitoso redirige al usuario al dashboard correspondiente según su rol (ADMIN → AdminDashboard, CLIENTE → StorePage, etc.).
*   [ ] CA5: Credenciales inválidas muestran un error claro sin exponer detalles del backend.

**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de login exitoso y fallido realizadas.
*   [ ] Almacenamiento seguro de tokens verificado.
*   [ ] Redirección por rol funcional en los 4 roles (Admin, Cliente, Prestador, Domiciliario).
*   [ ] AuthContext implementado y compartido entre componentes.
*   [ ] Evidencia adjunta: capturas de pantalla y video del flujo.
*   [ ] Documentación mínima actualizada en README.

---

### HU-03: Logout de Usuario
### HU-03: Logout de Usuario
**Descripción:** Como usuario autenticado, necesito poder cerrar sesión para salir de la app de forma segura y completa.
**Puntos:** 0.5 | **Prioridad:** Urgente
**Criterios de Aceptación:**
*   [ ] CA1: El botón "Salir" en Navbar ejecuta el endpoint `/api/v1/auth/logout/` para añadir el token a una blacklist.
*   [ ] CA2: Tras el logout, los tokens se eliminan completamente del `SecureStorage`.
*   [ ] CA3: El usuario es redirigido inmediatamente a la pantalla de Login.
*   [ ] CA4: Una vez deslogueado, el token anterior no puede ser reutilizado aunque tenga validez técnica.
*   [ ] CA5: El cierre de sesión es visible al usuario (mensaje de confirmación o redirección limpia).

**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de logout e invalidación de token realizadas.
*   [ ] Limpieza completa de sesión verificada en SecureStorage.
*   [ ] Tokens en blacklist no permiten acceso a recursos protegidos.
*   [ ] Redirección a Login funcional y sin errores.
*   [ ] Evidencia adjunta: capturas de pantalla y video del flujo.
*   [ ] Documentación mínima actualizada en README.

---

### HU-04: Gestión de Roles y Control de Acceso
**Descripción:** Como sistema, debo implementar un control de acceso basado en roles para proteger recursos y funcionalidades según el perfil del usuario (Admin, Cliente, Prestador, Domiciliario).
**Puntos:** 1 | **Prioridad:** Urgente
**Criterios de Aceptación:**
*   [ ] CA1: El backend define 6 clases de permisos (IsAdmin, IsClient, IsProvider, IsDeliverer, IsAuthenticated, IsPublic).
*   [ ] CA2: Cada vista protegida valida el rol del usuario antes de permitir acceso o modificación.
*   [ ] CA3: El frontend implementa ProtectedRoute.jsx que verifica el rol antes de renderizar cada componente.
*   [ ] CA4: AppRouter.jsx genera rutas protegidas dinámicamente basadas en los roles permitidos.
*   [ ] CA5: Un usuario sin rol apropiado recibe error 403 en backend y redirección a acceso denegado en frontend.

**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de acceso por rol realizadas para los 4 roles.
*   [ ] Validaciones en backend + frontend sincronizadas.
*   [ ] Rutas protegidas funcionan correctamente según rol.
*   [ ] Accesos no autorizados retornan errores controlados.
*   [ ] Evidencia adjunta: capturas de pantalla probando los 4 roles y accesos denegados.
*   [ ] Documentación mínima actualizada en README.

---

## 🔐 ÉPICA 02: Autenticación y Navegación

### HU-05: Pantalla Login
**Descripción:** Como usuario, requiero una interfaz atractiva para autenticar mi cuenta usando mis credenciales (email y clave) previas.
**Puntos:** 3 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: Dos inputs principales con controladores Form State que marcan error en rojo por campos en vacío o correo de formato fallido (@ missing).
*   [ ] CA2: Botón de "ver" (Ojito) en el TextField contraseña permite oscurecer O checar el texto introducido con `obscureText`.
*   [ ] CA3: Respuesta 401 del Backend notifica a interfaz mostrando "Credenciales Equivocadas" usando SnackBar.
*   [ ] CA4: Al encontrarse cargando intermitentemente (Estado Future Pending), el botón login muta a un CircularProgressIndicator no clocable previniendo spam backend.
*   [ ] CA5: Permite la fácil pulsación de un TextButton derivativo hacia la Pantalla "/register" para creación de usuario.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la BBDD.
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba.
*   [ ] Documentación mínima actualizada.

### HU-06: Pantalla Registro de cliente
**Descripción:** Como prospecto cliente, usaré una interfaz estructurada para establecer mi nuevo perfil introduciendo datos e indicando si pido rol extendido.
**Puntos:** 3 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: Posee los renglones mínimos acordados (Nombres, Correo, Clave, Rol preferido Dropdown).
*   [ ] CA2: Verificación doble clave (Repetir Contraseña) lanza invalidación en UI si ambas variables divergen.
*   [ ] CA3: Envío POST contra endpoint de creación responde 201 exitoso, arrojando Toast "Miembro Creado, ve a Loguearte Creador" y rutea auto a Login.
*   [ ] CA4: Un intento sobre Correo en uso arroja 400 bad request en API advirtiendo al civil de forma amigable.
*   [ ] CA5: El Request JSON asume la selección provista sobre el rol. Solo si es "Prestador", el sistema lo creará con el flag de revisión a la espera.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en terminal.
*   [ ] Pruebas básicas realizadas (manual / automatizada).
*   [ ] Validaciones implementadas.
*   [ ] Control por roles aplicado.
*   [ ] Datos persistidos en DB comprobados.
*   [ ] Evidencia adjunta agregada.
*   [ ] Documentación base mantenida.

### HU-07: Logout con limpieza de storage
**Descripción:** Como persona precavida, daré log out en el engranaje opciones aislando el perfil para cerrar la cortina personal.
**Puntos:** 1 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: Clic sobre Cerrar Sesión acciona el flag clean() en riverpod vaciando instancias del usuario.
*   [ ] CA2: Interceptores purgan los Keys del Secure Storage dejándolos inhabilitados del hardware cripto.
*   [ ] CA3: GoRouter manda sin reversa alguna a pantalla Home Pública u log-in y al pulsar Bottom de Atras (Atrás Nativos) sale del Software al OS del teléfono.
*   [ ] CA4: Carrito comercial Hive es exterminado, evitando que un secundario acceda a tus apartados post login.
*   [ ] CA5: Si disponía de socket activo u polling rastreando Domicilios, se envía signal Cancel al timer frenando el hilo asincrónico.

**Definition of Done (DoD):**
*   [ ] CA1 a CA5 verificados para el cierre de sesión.
*   [ ] El logout invoca el endpoint `/api/v1/auth/logout/` y blacklistea el refresh token cuando existe.
*   [ ] `SecureStorage` limpia `accessToken`, `refreshToken`, `userRole` y `userId` tras cerrar sesión.
*   [ ] La interfaz redirige a Login y no permite volver a pantallas protegidas con la sesión anterior.
*   [ ] El estado de autenticación se reinicia correctamente en Riverpod sin dejar usuario activo.
*   [ ] Evidencia de la prueba manual del logout adjunta (captura o video).
*   [ ] Documentación de usuario actualizada si cambió el flujo visible.

### HU-08: Navegación por rol (BottomNav diferenciado)
**Descripción:** Como usuario segmentado al ingresar a mi hogar panel solo quiero percibir el Scaffold Shell relativo a mi rubro evitando sub paneles basuras.
**Puntos:** 3 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: Cliente lee BottomBar (Tienda, Servicios, Contactos, Domicilios).
*   [ ] CA2: Rol Domiciliario enmarca únicamente dos paneles viables: "Nuevas Peticiones Mapa / Rendimiento Diario Financiero".
*   [ ] CA3: Prestador percibe una botonera abriendo sus Lead (Inbox pedidos), Contactos publicos, Setting.
*   [ ] CA4: Admin rompe y reemplaza el footer mostrando Pantallas Tablares de Gestión Masiva o Métricas de Chart.
*   [ ] CA5: Ninguno rompe la UI subyacente y la tab seleccionada se pinta activamente del MainColor Theme.

**Definition of Done (DoD):**
*   [ ] Criterios pasaron la totalidad de validación y control manual.
*   [ ] Integrado a Github sin conflictos.
*   [ ] Se validó con logs o pruebas en simulador.
*   [ ] Los fallos son mostrados de presentarse en pantallas de fallback.
*   [ ] Rol 100% verificado en BBDD con su enum pertinente y respetado acá.
*   [ ] Persistencia coherente, las variables del usuario no cruzan la base.
*   [ ] Constancia visual probada con video/foto.
*   [ ] Documentación técnica anexada para los programadores.

---

## 🛒 ÉPICA 03: Tienda y Compras

### HU-09: Pantalla Tienda con categorías y comercios
**Descripción:** Como habitante requiero un Marketplace mostrando clasificaciones superiores e hileras de los negocios locales registrados.
**Puntos:** 5 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: Carga visual por bloque AsyncValue; "Buscando data.." luego expone el listado.
*   [ ] CA2: Listado horizontal de tipo Chip mostrando categorías extraídas (Farmacias, Comidas, Bebidas).
*   [ ] CA3: Clicar en la categoría Farmacias vuelve a pedir / filtrar los negocios que tengan coincidente Foreign Key a esa categoría puntual arrojando grillas correspondientes.
*   [ ] CA4: Flete 404 al faltar tiendas muestra amigablemente el placeholder "Pronto agregaremos mas a tu zona".
*   [ ] CA5: Comercios expuestos cerrados por horario presentan un overlay opaco bloqueándoles su interacción total impidiendo entrada a compra fantasmal.

**Definition of Done (DoD)** (Checklist 8 Pts de norma):
*   [ ] Todos CAs verificados
*   [ ] Código subido correcto
*   [ ] Pruebas efectuadas
*   [ ] Manejos validados con try/catch en Flutter
*   [ ] Rol de acceso cliente mantenido
*   [ ] Extracciones Django veraces en la BDD
*   [ ] Imagen agregada al ticket ClickUp
*   [ ] Doc read.me listo

### HU-10: Detalle de comercio con catálogo
**Descripción:** Como habitante interesado pulsaré el chip del restaurante, accediendo a sus vitrinas internas con coste por platinos y descripciones unitarias.
**Puntos:** 3 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: Recepción de API endpoint anidado `commerce/{id}/products` rellenando lista Scaffold con Imagen y Precio flotante.
*   [ ] CA2: Permite un tap superior para revisar los datos de contacto y la información o logo nativo del propio restaurante y sus horarios de cierre.
*   [ ] CA3: Presenta botonerías de sumar a carrito rápidas en los productos o pulsar para ver su Modal expansivo sobre Ingredientes Descriptivos extra que cargan de Django.
*   [ ] CA4: Ojo: Cargar sin imagen en la JSON original pone un placeholder local "no-foto.png", garantizando no estallar la renderización ListView.
*   [ ] CA5: Presenciar un objeto agotado (`stock_qty <= 0`) bloqueará enteramente el botón aditivo reemplazado visualmente de gris a "Agotado en Tienda".

*El resto de sub-puntos (DoD de 8 elementos por HUs) continúan de la misma manera sistemática y requerida en el código final implementador.*
*(Ver DoD en los primeros HUs de plantilla)*
*(Se adjuntan listado a continuación de las historias)*

### HU-11: Carrito de compras (CartNotifier)
**Descripción:** Como cliente, mantendré en un widget flotador (Notificador Riverpod) el acumulado de items que pretendo ordenar actualizando en tiempo vivo.
**Puntos:** 5 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: Agregar productos incrementa cantidades y actualiza el total.
*   [ ] CA2: El carrito impide mezclar productos de comercios distintos.
*   [ ] CA3: Se puede aumentar, disminuir o eliminar productos desde la vista del carrito.
*   [ ] CA4: El estado del carrito se conserva mientras la sesión esté activa.
*   [ ] CA5: El total se calcula de forma precisa y visible antes de confirmar.
**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de carrito y totales realizadas.
*   [ ] Reglas de negocio del carrito validadas.
*   [ ] Persistencia temporal o en memoria verificada.
*   [ ] Manejo de errores y estados vacíos incluido.
*   [ ] Evidencia adjunta: capturas, video o demo.
*   [ ] Documentación mínima actualizada.

### HU-12: Confirmación y creación de pedido
**Descripción:** Como cliente, quiero confirmar mi carrito y crear el pedido en el backend.
**Puntos:** 3 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: El pedido se envía correctamente con los ítems y el total esperado.
*   [ ] CA2: Al confirmar con éxito, el carrito se vacía.
*   [ ] CA3: El sistema registra la trazabilidad del pedido en backend.
*   [ ] CA4: Si hay un error de validación, se informa al usuario sin perder la selección.
*   [ ] CA5: La app muestra confirmación visual del pedido creado.
**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de creación de pedido realizadas.
*   [ ] Persistencia y trazabilidad verificadas.
*   [ ] Manejo de errores funcional confirmado.
*   [ ] Integración frontend-backend validada.
*   [ ] Evidencia adjunta: capturas, video o demo.
*   [ ] Documentación mínima actualizada.

### HU-13: Historial de pedidos del cliente
**Descripción:** Como cliente, quiero revisar mis pedidos anteriores y su estado.
**Puntos:** 3 | **Prioridad:** Media
**Criterios de Aceptación:**
*   [ ] CA1: El historial lista los pedidos del usuario autenticado.
*   [ ] CA2: Cada pedido muestra estado, fecha y total.
*   [ ] CA3: El detalle del pedido permite ver sus ítems asociados.
*   [ ] CA4: Si no hay pedidos, se muestra un estado vacío claro.
*   [ ] CA5: La recarga manual actualiza la información del listado.
**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de historial y detalle realizadas.
*   [ ] Filtro por usuario autenticado confirmado.
*   [ ] Estados vacíos y recarga validados.
*   [ ] Persistencia histórica verificada.
*   [ ] Evidencia adjunta: capturas, video o demo.
*   [ ] Documentación mínima actualizada.

---

## 🛠️ ÉPICA 04: Servicios Profesionales

### HU-14: Pantalla Servicios con categorías y prestadores
**Descripción:** Como cliente, quiero buscar prestadores de servicios por categoría y disponibilidad.
**Puntos:** 5 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: La pantalla lista categorías de servicios y prestadores disponibles.
*   [ ] CA2: El filtro por categoría actualiza los prestadores mostrados.
*   [ ] CA3: Solo se muestran prestadores aprobados y activos.
*   [ ] CA4: La búsqueda por texto ayuda a encontrar prestadores más rápido.
*   [ ] CA5: Los errores de red se gestionan con feedback claro.
**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de listado, búsqueda y filtro realizadas.
*   [ ] Reglas de aprobación y visibilidad confirmadas.
*   [ ] Persistencia de servicios y categorías verificada.
*   [ ] UX y estados de carga validados.
*   [ ] Evidencia adjunta: capturas, video o demo.
*   [ ] Documentación mínima actualizada.

### HU-15: Detalle del prestador
**Descripción:** Como cliente, quiero ver el detalle de un prestador antes de solicitar el servicio.
**Puntos:** 3 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: Se muestra la información principal del prestador y su categoría.
*   [ ] CA2: La vista incluye imagen o avatar por defecto si no existe foto.
*   [ ] CA3: El usuario puede abrir el flujo para solicitar el servicio desde aquí.
*   [ ] CA4: Si el prestador está inactivo o no existe, se informa con claridad.
*   [ ] CA5: La vista no pierde el contexto de navegación al regresar.
**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de detalle del prestador realizadas.
*   [ ] Manejo de estados inexistentes o inactivos validado.
*   [ ] Navegación de ida y vuelta confirmada.
*   [ ] Persistencia de datos del prestador verificada.
*   [ ] Evidencia adjunta: capturas, video o demo.
*   [ ] Documentación mínima actualizada.

### HU-16: Formulario de solicitud de servicio
**Descripción:** Como cliente, quiero enviar una solicitud de servicio con datos claros y validados.
**Puntos:** 3 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: El formulario solicita la información necesaria para generar la solicitud.
*   [ ] CA2: Los campos obligatorios se validan antes de enviar.
*   [ ] CA3: La solicitud se asocia al cliente autenticado y al prestador correcto.
*   [ ] CA4: Si el envío falla, la app informa el motivo sin perder la información ingresada.
*   [ ] CA5: Al guardar correctamente, el usuario recibe confirmación visual.
**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de formulario y envío realizadas.
*   [ ] Asociación cliente-prestador verificada.
*   [ ] Manejo de errores y validaciones implementado.
*   [ ] Persistencia de solicitudes confirmada.
*   [ ] Evidencia adjunta: capturas, video o demo.
*   [ ] Documentación mínima actualizada.

### HU-17: Registro como prestador (file_picker + upload)
**Descripción:** Como ciudadano, quiero registrarme como prestador subiendo documentación de soporte.
**Puntos:** 5 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: El formulario permite subir archivos de soporte en formatos permitidos.
*   [ ] CA2: El tamaño del archivo se valida antes de enviarlo al servidor.
*   [ ] CA3: El upload se realiza correctamente mediante multipart/form-data.
*   [ ] CA4: El prestador queda pendiente de aprobación tras el registro.
*   [ ] CA5: Un error de red o archivo inválido se comunica con un mensaje claro.
**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de carga de archivos realizadas.
*   [ ] Validación de extensiones y tamaño confirmada.
*   [ ] Persistencia de documentos y perfil verificada.
*   [ ] Flujo de aprobación pendiente confirmado.
*   [ ] Evidencia adjunta: capturas, video o demo.
*   [ ] Documentación mínima actualizada.

### HU-18: Panel del prestador con cambio de estado
**Descripción:** Como prestador, quiero ver mis solicitudes y cambiar mi estado operativo.
**Puntos:** 3 | **Prioridad:** Media
**Criterios de Aceptación:**
*   [ ] CA1: El panel lista las solicitudes o actividades asignadas al prestador.
*   [ ] CA2: El prestador puede aceptar o rechazar una solicitud según las reglas.
*   [ ] CA3: El cambio de estado se refleja en la interfaz y en backend.
*   [ ] CA4: Los usuarios sin rol autorizado no pueden modificar este estado.
*   [ ] CA5: La vista muestra la información necesaria para operar con claridad.
**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de cambio de estado realizadas.
*   [ ] Restricciones de rol verificadas.
*   [ ] Persistencia del estado operativo confirmada.
*   [ ] UX del panel validada.
*   [ ] Evidencia adjunta: capturas, video o demo.
*   [ ] Documentación mínima actualizada.

---

## 🛵 ÉPICA 05: Domicilios y Finanzas

### HU-19: Pantalla Domicilios con lista de disponibles
**Descripción:** Como domiciliario, quiero ver las solicitudes disponibles para tomar trabajo.
**Puntos:** 3 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: La vista muestra solicitudes disponibles y no asignadas.
*   [ ] CA2: El domiciliario puede aceptar una solicitud disponible.
*   [ ] CA3: Al aceptar, la solicitud cambia de estado y deja de mostrarse como disponible.
*   [ ] CA4: Si la solicitud ya fue tomada, la app informa el conflicto de forma clara.
*   [ ] CA5: La pantalla se actualiza para reflejar nuevos domicilios disponibles.
**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de aceptación de domicilios realizadas.
*   [ ] Concurrencia y bloqueo de asignación confirmados.
*   [ ] Persistencia de estado de entrega verificada.
*   [ ] Actualización visual validada.
*   [ ] Evidencia adjunta: capturas, video o demo.
*   [ ] Documentación mínima actualizada.

### HU-20: Panel financiero del domiciliario
**Descripción:** Como domiciliario, quiero revisar mis ingresos, egresos y balance acumulado.
**Puntos:** 5 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: El panel muestra ingresos, egresos y balance total de forma clara.
*   [ ] CA2: Los valores se calculan correctamente incluso si no hay movimientos.
*   [ ] CA3: La vista permite consultar el detalle de los movimientos registrados.
*   [ ] CA4: Los datos mostrados corresponden solo al domiciliario autenticado.
*   [ ] CA5: La pantalla maneja estados vacíos y recarga manual.
**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de cálculos y balance realizadas.
*   [ ] Filtrado por usuario autenticado validado.
*   [ ] Persistencia de movimientos y balance verificada.
*   [ ] UX financiera y estados vacíos confirmados.
*   [ ] Evidencia adjunta: capturas, video o demo.
*   [ ] Documentación mínima actualizada.

### HU-21: Registro de ingresos y egresos
**Descripción:** Como domiciliario, quiero registrar ingresos y egresos para controlar mis finanzas.
**Puntos:** 3 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: El formulario permite registrar ingresos y egresos con validación de valores.
*   [ ] CA2: Los montos negativos o inválidos se rechazan con un mensaje claro.
*   [ ] CA3: El balance se actualiza automáticamente después de guardar un movimiento.
*   [ ] CA4: El registro queda asociado al domiciliario autenticado.
*   [ ] CA5: Un fallo de conexión no borra la información ingresada por el usuario.
**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de creación de movimientos realizadas.
*   [ ] Reglas de validación y cálculo confirmadas.
*   [ ] Persistencia financiera verificada en backend.
*   [ ] Control de acceso por rol validado.
*   [ ] Evidencia adjunta: capturas, video o demo.
*   [ ] Documentación mínima actualizada.

---

## 📞 ÉPICA 06: Contactos, Directorio y Llamadas

### HU-22: Directorio de contactos con buscador y filtros
**Descripción:** Como usuario, quiero buscar contactos de interés con filtros simples.
**Puntos:** 3 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: La pantalla muestra el directorio de contactos disponible.
*   [ ] CA2: La búsqueda por nombre y filtro por categoría funcionan correctamente.
*   [ ] CA3: Los contactos inactivos o eliminados no se muestran.
*   [ ] CA4: Si no hay resultados, se muestra un estado vacío amigable.
*   [ ] CA5: El contenido se actualiza al refrescar la vista.
**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de búsqueda y filtro realizadas.
*   [ ] Estados vacíos y actualización confirmados.
*   [ ] Persistencia del directorio verificada.
*   [ ] Accesibilidad y UX revisadas.
*   [ ] Evidencia adjunta: capturas, video o demo.
*   [ ] Documentación mínima actualizada.

### HU-23: Llamada directa desde la app (url_launcher)
**Descripción:** Como usuario, quiero llamar directamente a un contacto desde la aplicación.
**Puntos:** 1 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: Al pulsar el contacto, la app abre el marcador telefónico del dispositivo.
*   [ ] CA2: Antes de llamar, se verifica que el dispositivo soporte la acción.
*   [ ] CA3: Si no se puede iniciar la llamada, se muestra un mensaje claro.
*   [ ] CA4: La acción no interrumpe la navegación ni el estado de la app.
*   [ ] CA5: La experiencia de usuario se mantiene simple y directa.
**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de lanzamiento de llamada realizadas.
*   [ ] Manejo de dispositivos no compatibles validado.
*   [ ] Integración con el sistema telefónico confirmada.
*   [ ] UX y permisos revisados.
*   [ ] Evidencia adjunta: capturas, video o demo.
*   [ ] Documentación mínima actualizada.

---

## 📊 ÉPICA 07: Administración

### HU-24: Dashboard del admin (resumen y métricas)
**Descripción:** Como administrador, quiero ver un panel con métricas generales del sistema.
**Puntos:** 5 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: El dashboard muestra conteos y métricas clave del sistema.
*   [ ] CA2: Los datos se obtienen de endpoints protegidos por rol de administrador.
*   [ ] CA3: Los valores se muestran correctamente incluso cuando no hay registros.
*   [ ] CA4: La vista se adapta a diferentes tamaños de pantalla.
*   [ ] CA5: Los errores de carga se comunican de forma clara.
**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de métricas y acceso realizadas.
*   [ ] Restricciones de administrador verificadas.
*   [ ] Persistencia de reportes y conteos confirmada.
*   [ ] Adaptabilidad visual revisada.
*   [ ] Evidencia adjunta: capturas, video o demo.
*   [ ] Documentación mínima actualizada.

### HU-25: Aprobación/rechazo de prestadores desde admin
**Descripción:** Como administrador, quiero aprobar o rechazar prestadores pendientes de validación.
**Puntos:** 3 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: El listado muestra solo prestadores pendientes de validación.
*   [ ] CA2: El administrador puede aprobar un prestador y cambiar su estado a activo.
*   [ ] CA3: El administrador puede rechazar un prestador y registrar el motivo si aplica.
*   [ ] CA4: Los usuarios sin permisos no pueden ejecutar estas acciones.
*   [ ] CA5: La decisión tomada se refleja en la vista y en la base de datos.
**Definition of Done (DoD):**
*   [ ] Criterios de aceptación cumplidos y verificados.
*   [ ] Código integrado en el repositorio y ejecuta sin errores.
*   [ ] Pruebas de aprobación y rechazo realizadas.
*   [ ] Control de permisos verificado.
*   [ ] Persistencia del estado del prestador confirmada.
*   [ ] Estados de aprobación y rechazo auditables.
*   [ ] Evidencia adjunta: capturas, video o demo.
*   [ ] Documentación mínima actualizada.

*(Nota: Adicionalmente, todas las historias aplican un criterio exhaustivo de DoD enfocado en la completitud de código, tests en BBDD y manejos resilientes de conectividad base según lo exigido por el estándar ágil del formato maestro final de Runners.)*



## 🧱 Sprint 1 — Infraestructura + Autenticación (3 semanas | 12 pts)

### Semana 1: Setup del proyecto

| Tarea | Responsable | Horas | Pts | Etiqueta | Prioridad | Estado |
|------|-------------|-------|-----|----------|-----------|--------|
| Crear repo GitHub, estructura de carpetas, README | Laura (PM) | 4h | 0.5 | pm config | 🔴 Urgente | ✅ Hecho |
| Inicializar proyecto Django + settings (base, dev, prod) | Julian (Backend) | 4h | 0.5 | backend config | 🔴 Urgente | ✅ Hecho |
| Configurar \.env\, CORS, INSTALLED_APPS, SimpleJWT | Julian (Backend) | 4h | 0.5 | backend config | 🔴 Urgente | ✅ Hecho |
| Inicializar proyecto React + Vite, configurar eslint | Alison (Frontend) | 4h | 0.5 | frontend config | 🔴 Urgente | ✅ Hecho |
| Configurar Axios con interceptor de refresh token | Alison (Frontend) | 4h | 0.5 | frontend config | 🔴 Urgente | ✅ Hecho |
| Crear tablero en ClickUp, definir columnas y etiquetas | Laura (PM) | 4h | 0.5 | pm | 🟠 Alta | ✅ Hecho |
| Modelo User personalizado (AbstractBaseUser + roles) | Julian (Backend) | 8h | 1 | backend | 🔴 Urgente | ✅ Hecho |
| Crear UserManager, migraciones, superuser | Julian (Backend) | 4h | 0.5 | backend config | 🔴 Urgente | ✅ Hecho |

**Subtotal Semana 1:** 36h | 4.5 pts
