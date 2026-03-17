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
**CA:**
*   [ ] CA1: Añadir repite o acumula unidades y actualiza contadores.
*   [ ] CA2: Alertar y obstruir al mezclar Comercio 1 con Comercio 2; "Carrito solo acepta 1 tienda actual".
*   [ ] CA3: Restaurar cerrado forzado, Riverpod lee Hive de nuevo recuperando progreso.
*   [ ] CA4: Restar al número máximo 0 extrae y depura al producto de la cadena de objetos Hive.
*   [ ] CA5: Computa matematicamente el valor real Float total en pantalla final sin errores por redondeo.
*   [ ] DoD universal cubierto ✅.

### HU-12: Confirmación y creación de pedido
**Descripción:** Como cliente, haré la rúbrica y envío de los lotes del carrito para convertirlos en tickets del modelo Orders de Backend.
**CA:**
*   [ ] CA1: Mandar paquete con array de artículos envía request múltiple al Backend devolviendo estatus In Order Process (201).
*   [ ] CA2: Tras el retorno exitoso, Flutter ordena matar vaciando el carrito visual y persistente base 0.
*   [ ] CA3: Intercepta fallos; Si Django declina por desincronización de precio con la data oficial remite "Precio modificado intermitente, Refresque".
*   [ ] CA4: El POST inyecta la lat/lng o string geográfico proporcionado en un Text form extra "A donde enviar".
*   [ ] CA5: Redirige pantalla al panel temporal "Compra confirmada: Generado con UUID xxxx".
*   [ ] DoD universal cubierto ✅.

### HU-13: Historial de pedidos del cliente
**Descripción:** Como cliente, requiero revisar viejas compras retrospectivas visualizando el list status y detalle ordenado viejo a nuevo.
**CA:**
*   [ ] CA1: Mapear historial y mostrar Enum states en verde "finalizado" o rojo "Cancelado" ordenado por datetime en UI ListView.
*   [ ] CA2: Tap simple abrirá las subdivisiones de objetos implicados que poseía este pedido en su línea transaccional originada.
*   [ ] CA3: Impide filtración JWT, la base a nivel DB filtra query con mi UID personal restringiendo listados ajenos en endpoints API crudos.
*   [ ] CA4: Ausencia devuelve Placeholder nulo de "Realiza tu compra primera".
*   [ ] CA5: Refresh indicator implementado para recargas jalando hacia abajo actualizando estados de un pedido "En progreso".
*   [ ] DoD universal cubierto ✅.

---

## 🛠️ ÉPICA 04: Servicios Profesionales

### HU-14: Pantalla Servicios con categorías y prestadores
**Descripción:** Como prospecto cliente, usaré listas buscando profesionales o plomeros verificados exponiendo solo las variables calificativas y su rubro general.
**CA:**
*   [ ] CA1: Devuelve desde Backend a los prestatarios que el flag Is_Approved posean y cumplan la pertenencia True.
*   [ ] CA2: Agrupados bajo chips de filtros ("Fontanero, Belleza, Tutor").
*   [ ] CA3: Un search bar con Riverpod provider intercepta filtrando cadenas por coincidencia de strings dentro del objeto visual de los prestatarios.
*   [ ] CA4: Red responde 403 u vacía en peticiones fuera de un token de client u admin logueados base garantizando resguardo y privacidad de prestadores.
*   [ ] CA5: Se protegen los rendimientos nulos arrojando fallbacks al fallar red base.
*   [ ] DoD universal cubierto ✅.

### HU-15: Detalle del prestador
**Descripción:** Como futuro contratista, pulso al ofertante examinando sus datos a gran escala y evaluando calificaciones pasadas o un poco del about descriptivo de la persona.
**CA:**
*   [ ] CA1: Consumir URL `provider/{id}` jalando información de sus tablas anexas que llenó la BD biográfica Django devolviendo a vista expandible.
*   [ ] CA2: Foto renderizada mediante avatar de red y control de fallo (Avatar Letras iniciales de No ser posible una foto).
*   [ ] CA3: Se renderiza un gran botón flotante de Acción Principal "Solicitar Ayuda De Este Profesional".
*   [ ] CA4: Impedimento de solicitar si es su misma cuenta quien revisa (Cliente que es prestador no se contrata así mismo).
*   [ ] CA5: Fallas devuelven red un Modal Not-found alert visual UI "No se ubica prestatario activo".
*   [ ] DoD universal cubierto ✅.

### HU-16: Formulario de solicitud de servicio
**Descripción:** Como proponente, agendaré al ofertante escogido tipeando el requerimiento del desperfecto u necesidad fechada local.
**CA:**
*   [ ] CA1: Formulario posee limitantes mínimos descriptivos obligatorios y un DatePicker para asegurar fechas agendadas a futuro validado para no permitir cronología retrasa anterior a tiempo Time.Now().
*   [ ] CA2: Solicitud guarda exitosa atando en backend IDs entre Customer JWT actual y Target Provider ID originando Petición Base "Pending Revision".
*   [ ] CA3: Enviar con descripciones vacías estalla invalidación Front avisando su falta de datos.
*   [ ] CA4: Un hack desde el Motorizado a este API lanza reestructuración rebotando con Forbidden flag backend control.
*   [ ] CA5: Cierra la vista arrojando "Lead Generado con Exito al obrero" redirigiendo al dashboard natural de la App.
*   [ ] DoD universal cubierto ✅.

### HU-17: Registro como prestador (file_picker + upload)
**Descripción:** Como ciudadano me registro cargando form multipart de evidencia de certificaciones / CV documentado, solicitando validez gubernamental.
**CA:**
*   [ ] CA1: SDK File_picker funciona sobre los SO iOS Android abriendo árbol de archivos y subiendo validando extensiones puras admitidas (PDF, DOCX).
*   [ ] CA2: Retención límite 8 MB si se ingresa peso de más en app móvil lanza "Límite Excedido File Size Alert" ahorrando HTTP fallidos a la api.
*   [ ] CA3: La petición final muta multipart/form-data construida en capas nativas de dio con subida paulatina y barra per-cent visual a la UI informando % progression.
*   [ ] CA4: El servidor ubica de modo absoluto y correcto en directorio Media/ root del Django persistiendo URLs de ubicación y atando a perfil prestador en validación pendiente False.
*   [ ] CA5: Caída de subida por red se anula reportando el stack-trace limpio sin cierres destructivos de app permitiendo re intentarlo de nuevo por el usuario final.
*   [ ] DoD universal cubierto ✅.

### HU-18: Panel del prestador con cambio de estado
**Descripción:** Como trabajador contratado miro mis cotizaciones Lead recibidas aceptando en bandeja la resolución que aplicaré al pedido externo.
**CA:**
*   [ ] CA1: Observar una bandeja Inbox extraída de Backend model leads donde su `provider_id` empate al perfil actuante devolviendo las tareas y datos extra.
*   [ ] CA2: Al cliquear Aceptado ejecuta Patch sobre Backend resolviendo acuerdo (Acuerdo Accepted Status Update) grabando fecha update actual relacional en SQL.
*   [ ] CA3: Decline remueve lógicamente la tarea visual para desocupar la interfaz pasándola a un estatus negativo denegado.
*   [ ] CA4: Disparar llamada al cliente es posible vía action button ejecutando Native Telephone dialler si hay numero guardado en objeto Customer extraído.
*   [ ] CA5: Ninguno que no posea los roles "Prestador y/o Admin" parchará estas entidades blindadas.
*   [ ] DoD universal cubierto ✅.

---

## 🛵 ÉPICA 05: Domicilios y Finanzas

### HU-19: Pantalla Domicilios con lista de disponibles
**Descripción:** Como Motorizado independiente abro un Dashboard interactivo que capta tickets A->B pendientes públicos de cacería en mi metrópolis.
**CA:**
*   [ ] CA1: El pool list muestra los deliveries estatus `Pendiente` (Sin driver asignado) de manera fluida mostrando Puntos calles.
*   [ ] CA2: Aceptar vincula permanentemente mi driver UID con la fila forzando Status Recogiendo arrojando un HTTP PATCH success model y removiéndolo en vivo del panel a los competidores.
*   [ ] CA3: Concurrencia controlada, dos motorizados ganan el tap: Uno acepta 200 Okay y el segundo capta la excepción 400 "Has llegado Tarde ya fue tomado por colega motorizado".
*   [ ] CA4: Domiciliario que no cumple nivel de habilitación no captura la tarjeta (Fallback o Denied).
*   [ ] CA5: Lista auto pollea re refrescando en fondo para nuevos items por el thread provider.
*   [ ] DoD universal cubierto ✅.

### HU-20: Panel financiero del domiciliario
**Descripción:** Como conductor anhelo observar rendimientos sobre el saldo de tareas completadas de mi recolección histórica extraídas en vivo.
**CA:**
*   [ ] CA1: Sumatoria ORM de Django a nivel Backend expone un objeto Balance condensado calculando total flotante histórico por id.
*   [ ] CA2: Muestra panel $0.0 sin caídas Float o NullExceptions nativas si Motorizado se encuentra virgen ante la base inicial de entregas.
*   [ ] CA3: Posible tabulación para filtrar por rangos URL Parametrizados que envían '?mes=Actual' refrescando sumatorias UI sobre listado Frontal.
*   [ ] CA4: Nadie ajeno interactúa esta URI o le es retornada su data gracias al DRF filter.
*   [ ] CA5: Sub renglón detalla al motorizado las tareas pequeñas que originaron la suma del total de hoy al dar Tap.
*   [ ] DoD universal cubierto ✅.

### HU-21: Registro de ingresos y egresos
**Descripción:** Como motorizado deseo complementar finanzas anotando egresos diarios como (Gasolina, Mantenimientos) con inputs directos restando en visual contra la ganancia pasiva generada.
**CA:**
*   [ ] CA1: Creado form "Agregar Costo Operativo" impactando post básico en tabla auxiliar "Expenses" del Motorizado en Base de Datos de forma asíncrona validada en Django.
*   [ ] CA2: Si se ingresan valores negativos la UI trunca la expresión previniendo envíos con cálculos irreales que alteran balances.
*   [ ] CA3: Gráfica o Card Front realiza sencilla resta in-memory Provider de Flutter mostrando Profit: Total App (-) Egresos Extraordinarios.
*   [ ] CA4: Desconectar internet prevendrá cargar gastos informando retardo limitando al Motorizado y manteniendo la cuenta sana hasta recuperarse el HTTP Dio Client connection local.
*   [ ] CA5: Rol encriptado seguro; un Customer que fuerce URL no poseerá capacidad post arrojando HTTP 403 de base por restricciones seguras.
*   [ ] DoD universal cubierto ✅.

---

## 📞 ÉPICA 06: Contactos, Directorio y Llamadas

### HU-22: Directorio de contactos con buscador y filtros
**Descripción:** Como Usuario app preciso del tabulador general categorizado con teléfonos utilitarios y públicos con un filtrador activo local para búsquedas veloces en la capa móvil.
**CA:**
*   [ ] CA1: Renderiza la tabla recibida de BDD pública en hileras o cards según sub categorías separando paramédicos / policías / cerrajeros institucionales.
*   [ ] CA2: Search bar evalúa con `where`, matcheando case in sensitives el dictado (ej. Pol / POlí / PoL) exponiendo progresiva coincidencia textual y arrojando sin vacíos las cards con el target indicado.
*   [ ] CA3: Filtrar fallidamente devuelve mensaje de error sereno "0 Encuentros en el renglón Base de Datos Público" y un botón "Limpiar Casilla Búsqueda".
*   [ ] CA4: No requiere un login obligatorio cerrado por rol restrictivo o nivel al considerarse vista semi publica de los ciudadanos.
*   [ ] CA5: Refresco Swipe detecta los campos desactivados como Soft Deletes en backend para no mostrarlos ya en la tabla frontend oculta.
*   [ ] DoD universal cubierto ✅.

### HU-23: Llamada directa desde la app (url_launcher)
**Descripción:** Como residente urgido pulsaré la tarjeta y el app se encargará de gestionar marcaciones a nivel plataforma externa delegando sin quiebres mi terminal móvil hacia el discador real telefónico central de Android / Ios sin cuelgues extraños.
**CA:**
*   [ ] CA1: Clic Tap efectúa puente in-App con modulo Flutter url_launcher forzando Scheme type "tel://888555".
*   [ ] CA2: Enlaza directo abriendo el discador de fabrica celular marcando automático pre llenado los campos numerales permitiendo un solo click secundario para originar vía red móvil del cliente.
*   [ ] CA3: Si ocurre fallo de paquete en un iPad u tableta sin red celular telefónica el Future bloquea el fallo e inserta un try Catch arrojando pop "Dispuesto No Soporta Llamadas Nativas Telefónicas directas" de forma educada al usuario previendo el Crash Nativo Fatal a la matriz del SO interno.
*   [ ] CA4: Las llamadas omiten guardar caché interno asegurando privacidad de la aplicación general y eluden recargar recursos de internet base.
*   [ ] CA5: Botón animado genera tinta indicativa tras toque Ripple de interacciones nativas confirmadas del material design.
*   [ ] DoD universal cubierto ✅.

---

## 📊 ÉPICA 07: Administración

### HU-24: Dashboard del admin (resumen y métricas)
**Descripción:** Como ente responsable visualizo un panel general de cuadros condensando volumetrías contables registradas y métricas maestras con seguridad global total de la capa superior.
**CA:**
*   [ ] CA1: Mapeo de URL `/api/reports/dashboard` resolviendo conteos base de forma veraz devolviendo diccionarios contables (Users: x, Stores: y, Process: z) mostrando Tarjetas informativas de Flutter Front end.
*   [ ] CA2: La capa HTTP prohíbe el tránsito tajante mediante el Permiso IS_STAFF true / o Rol Admin. Enseña un 403 Forbidden a la penetración no autorizada devolviendo intrusos al home en el frente de enrutamiento visual.
*   [ ] CA3: Base resuelve agregados ORM optimizados para evitar sobre pasarse el rango de segundos permitidos de un timeout general.
*   [ ] CA4: Datos en tabla de cero registros son resueltos e instanciados como `0` en vez de ocasionar bucles vacíos de renders Front nulos.
*   [ ] CA5: Adaptabilidad a Landscape y dimensiones iPad resueltas en el diseño del frontend renderizado global adaptativo.
*   [ ] DoD universal completado. ✅

### HU-25: Aprobación/rechazo de prestadores desde admin
**Descripción:** Como moderador evaluador listaré la masa de perfiles prestadores "Pendientes de validación" leyendo su archivo de anexo subido y clicando sus booleans autorizaciones determinantes expuestas frontalmente.
**CA:**
*   [ ] CA1: El ListView genera solo query a aquellos donde la columna `is_validated = False`.
*   [ ] CA2: Enseña botón pre visual de descargas para atrapar la cadena URL remota enviada de PDF currículos ejecutándola sobre web browser viewer validando autenticidad documentara humana.
*   [ ] CA3: Botón de aprobar envía patch enviando estado flag true moviéndolo a las bases publicas listadas generalistas.
*   [ ] CA4: Clic Cancelar / Reject lo envía al listado denegado, purga la vista temporal de la capa Moderador y libera almacenamiento del servidor a elección final.
*   [ ] CA5: Cierre asegurado por Barrera JWT is_admin total y no expone el fallo transaccional sin Rollbacks. El backend se re asegura de resguardar el status base transaccional original.
*   [ ] DoD universal completado y cubierto en el resguardo veraz de base. ✅

*(Nota: Adicionalmente, todas las historias aplican un criterio exhaustivo de DoD enfocado en la completitud de código, tests en BBDD y manejos resilientes de conectividad base según lo exigido por el estándar ágil del formato maestro final de Runners.)*
