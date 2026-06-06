# Backlog Oficial de Historias de Usuario - Runners (100% Fiel al Proyecto)

Este documento contiene las **25 Historias de Usuario** originales e íntegras definidas en el archivo maestro de implementación del proyecto (`runners_flutter_implementacion.md`), mapeadas a través de sus **7 Épicas**. 
Listas para importar directamente como tareas en **ClickUp**. Cada una con 5 a 6 Criterios de Aceptación (CA) detallados y su rigurosa Definition of Done (DoD).

---

## 🏗️ ÉPICA 01: Core & Configuración

### HU-01: Splash Screen con verificación de sesión
**Descripción:** Como sistema, necesito mostrar una pantalla de carga inicial mientras verifico si el usuario ya posee un token válido guardado, para dirigirlo al Login o a su módulo correspondiente.
**Puntos:** 1 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: Al abrir la app, la pantalla de Splash se muestra al menos por 1-2 segundos exhibiendo el logo de Runners centrado correctamente.
*   [ ] CA2: El sistema consulta el SecureStorage para buscar la persistencia del `access_token` JWT. Si no existe, al terminar el tiempo redirige a /login.
*   [ ] CA3: Si el token existe y es válido, decodifica el atributo Rol para calcular la redirección final (Dashboard Admin vs Vista Cliente).
*   [ ] CA4: Si el token ha expirado durante el estado offline, reintenta transparentemente el uso del `refresh_token` antes de expulsar al usuario.
*   [ ] CA5: En el caso de que la validación falle corruptamente, la excepción es atrapada en el provider emitiendo rediseño hacia la ruta base pública.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la BBDD.
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba.
*   [ ] Documentación mínima actualizada.

### HU-02: Configuración Dio + interceptores JWT
**Descripción:** Como desarrollador, necesito instanciar el cliente HTTP Dio global con interceptores que inyecten el Bearer Token en cada salto para mantener estandarizadas las peticiones.
**Puntos:** 3 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: La instancia base de Dio añade por defecto la cabecera `Authorization: Bearer <token>` cuando el destino es la capa `/api/`.
*   [ ] CA2: Al recibir respuetas globales tipo HTTP 401 Unauthorized, un interceptor actúa renovando el access_token mediante el endpoint de Refresh de Django.
*   [ ] CA3: Tras una renovación exitosa en segundo plano, la petición frenada repite él mismo request subyacente sin que el usuario cliente perciba la caída.
*   [ ] CA4: Un error prolongado tras el Refresh Token (Ej. Cuenta baneada, 403 o RefreshExpirado) forzará un "Force 로그out" expulsando variables de memoria.
*   [ ] CA5: Los logs de terminal (Dio Logger) ocultan tokens parcialmente en ambientes de Producción por reglas de seguridad y confidencialidad celular.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la BBDD.
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba.
*   [ ] Documentación mínima actualizada.

### HU-03: SecureStorage para tokens
**Descripción:** Como arquitecto Flutter, aseguraré que los secretos de la sesión estén acartonados en el KeyStore nativo de iOS y SharedPreferences en vez de Hive en texto plano.
**Puntos:** 1 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: Las credenciales extraídas en login (`access`, `refresh`) se graban mediante package FlutterSecureStorage. Ningún token reside expuesto a exploradores root.
*   [ ] CA2: Invocar un read() sobre un key vacío retorna un null mapeado controlado sin causar NullPointer exceptions en la consola.
*   [ ] CA3: Acción DeleteAll() garantiza purgar el compartimiento nativo al realizar cierre de sesión.
*   [ ] CA4: El sistema en Android maneja la encriptación por hardware y auto regenera su llave keystore fallando silencioso de forma segura si la versión SO lo requiere.
*   [ ] CA5: Cualquier actualización del Refresh expulsa el Value anterior sobrescribiéndose correctamente sin acumular copias residuales en memoria del hardware.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la BBDD.
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba.
*   [ ] Documentación mínima actualizada.

### HU-04: GoRouter con guards por rol
**Descripción:** Como cliente/proveedor, el sistema debe prohibirme la ruta si digito accesos no contemplados de mi respectiva clase evitando vulnerabilidades inter-app.
**Puntos:** 3 | **Prioridad:** Alta
**Criterios de Aceptación:**
*   [ ] CA1: Las rutas GoRouter manejan un parámetro `redirect:` que evalúa constantemente el estado logueado del AuthProvider en Riverpod.
*   [ ] CA2: Si un token no registra ser Admin, todo intento visual de ingresar a `/admin_dashboard` se sustituye agresivamente devolviéndolo a `/home`.
*   [ ] CA3: Las rutas `/login` o `/register` no son accesibles si el estado Auth persiste "Authenticated". El usuario rebota automáticamente hacia adentro.
*   [ ] CA4: El enrutador encapsula un ShellRoute que mantiene la barra de navegación de pie sin destruirla entre pantallas dependientes (Nested Navigation).
*   [ ] CA5: De no hallarse una sub-ruta válida dentro de las declaraciones (Ej. link trunco web), se levanta la vista Error404 nativa "Ruta No hallada" conteniendo el appbar.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la BBDD.
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba.
*   [ ] Documentación mínima actualizada.

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
*   [ ] CA observados todos.
*   [ ] Git Comiteado sin issues de render.
*   [ ] Unit test verificado.
*   [ ] Validaciones en forms no corrompidas.
*   [ ] Protección final anti rebotes lógicos.
*   [ ] BD desancló el Refresh.
*   [ ] Evidencias anexas.
*   [ ] Doc de usuario actual.

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
