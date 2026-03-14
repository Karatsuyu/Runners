# Backlog de Historias de Usuario - Runners (Formato ClickUp)

Este documento contiene las Historias de Usuario estructuradas según la arquitectura actual (Flutter + Django) listas para ser copiadas y pegadas como tareas en **ClickUp** o cualquier otro gestor Kanban. Cada historia cuenta con sus Criterios de Aceptación (CA) y Definition of Done (DoD) detallados completos.

---

## 🔒 MÓDULO 1: Autenticación y Usuarios

### HU-01: Registro de usuario
**Descripción:** Como usuario nuevo, quiero registrarme en el sistema con mi nombre, apellido, correo, contraseña y el rol solicitado, para crear una cuenta en la aplicación.

**Implicación Frontend (Flutter):**
*   **UI:** Construir RegisterScreen con TextFormField, validadores de formulario, y opciones de selección de rol.
*   **Lógica:** Usar Riverpod (authProvider) para manejar el estado (loading, success, error) y llamar a AuthRepository.
*   **Rutas:** Configurar GoRouter para navegación de vuelta al login al terminar.

**Implicación Backend (Django):**
*   **API:** Crear POST /api/users/register/.
*   **Lógica:** Implementar UserSerializer en Django REST Framework para validación. Guardar de forma segura la contraseña usando el hashing de Django.
*   **Reglas:** Si el rol es "Prestador", dejar cuenta en estado pendiente de aprobación.

**Criterios de Aceptación:**
*   [ ] CA1: Con datos válidos, el sistema guarda el usuario en BBDD asociando correctamente su rol (Cliente/Domiciliario) y redirige al confirmarse.
*   [ ] CA2: Si falta un campo obligatorio (Nombre, Correo, etc.), el sistema bloquea el envío y muestra un mensaje "Este campo es requerido".
*   [ ] CA3: Si se ingresa un correo con formato inválido o una contraseña menor a 8 caracteres, lanza alerta "Formato inválido".
*   [ ] CA4: Si se solicita el rol "Prestador", el usuario se crea exitosamente pero queda en estado "inactivo" o "pendiente de aprobación" por el administrador.
*   [ ] CA5: Si el correo electrónico ya existe registrado en la base de datos, el backend responde con error 400 y UI muestra "Usuario ya existe".
*   [ ] CA6: En caso de falla de conectividad de red, la aplicación retiene los datos sin vaciar el formulario y muestra "Revise su conexión a internet".

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos de Historia:** 3 | **Prioridad:** Urgente

---

### HU-02: Inicio de sesión
**Descripción:** Como usuario registrado, quiero iniciar sesión con mi correo y contraseña, para acceder a mi perfil y a las pantallas restringidas para mi rol.

**Implicación Frontend (Flutter):**
*   **UI:** Pantalla LoginScreen con inputs de email y password.
*   **Lógica:** Consumir endpoint de login mediante DioClient. Guardar JWT en secure_storage.
*   **Navegación:** Evaluar rol extraído del JSON para direccionar.

**Implicación Backend (Django):**
*   **API:** Endpoint POST /api/users/login/.

**Criterios de Aceptación:**
*   [ ] CA1: Con credenciales correctas, el backend retorna tokens JWT que se guardan en el Storage y la UI enruta hacia la portada principal de la app según perfil.
*   [ ] CA2: Si el usuario pulsa Entrar dejando campos en blanco, no se hace el POST y se advierte en rojo "Todos los campos son obligatorios".
*   [ ] CA3: Si se pone un correo/contraseña erróneo, el sistema muestra el error "Credenciales no coinciden" sin especificar si el error es del correo o clave.
*   [ ] CA4: Si el usuario fue bloqueado temporalmente por un Administrador, la API retorna error 403 y se avisa "Su cuenta ha sido suspendida".
*   [ ] CA5: Cerrar totalmente la App y volverla a abrir no debe pedir login de nuevo siempre y cuando los tokens JWT locales no hayan expirado (Persistencia de sesión).
*   [ ] CA6: Si el Access Token expiró silenciosamente, el sistema usa el Refresh Token para continuar la experiencia en segundo plano.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos de Historia:** 5 | **Prioridad:** Urgente

---

### HU-03: Cierre de sesión
**Descripción:** Como usuario autenticado, quiero cerrar sesión de forma segura, para proteger mi cuenta en el dispositivo.

**Implicación Frontend:** Borrar flutter_secure_storage y resetear Riverpod global. Forzar GoRouter hacia /login
**Implicación Backend:** Blacklist de token o eliminación de Push tokens asociados al user.

**Criterios de Aceptación:**
*   [ ] CA1: Al accionar el botón de Logout en el perfil, la app redirige de forma exitosa a la pantalla principal limpiando variables en memoria.
*   [ ] CA2: El storage seguro de FlutterSecureStorage pierde incondicionalmente las claves (Access/Refresh Token) evitando robo de sesión.
*   [ ] CA3: Presionar el botón "Back/Atrás" de Android tras estar en el Login no deja volver al muro donde estaban sus datos privados (historial/pila destruida).
*   [ ] CA4: El sistema notifica al endpoint de Backend a ser posible (si hay red) para agregar el Refresh Token en Blacklist.
*   [ ] CA5: Si el usuario desea loguearse en otra cuenta diferente tras cerrar sesión, el carrito e historiales previos no deben mezclar información.
*   [ ] CA6: Falla de internet no bloquea la acción local; es decir, asegura la expiración local sin importar la API en ese momento preciso.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 1 | **Prioridad:** Alta

---

## 🛒 MÓDULO 2: Tienda

### HU-04: Ver comercios y productos
**Descripción:** Como cliente, quiero ver los comercios disponibles y su catálogo de productos con fotos y precio.

**Implicación Frontend:**
* StoreScreen, uso de CachedNetworkImage. Riverpod FutureProviders para carga de apis.
**Implicación Backend:**
* GET /api/store/businesses/ y GET /api/store/businesses/{id}/products/

**Criterios de Aceptación:**
*   [ ] CA1: La pantalla renderiza un listado con éxito consumiendo los recursos desde el Backend, presentando comercios abiertos / cerrados.
*   [ ] CA2: Si falla la extracción de la solicitud GET, emite una pantalla de placeholder temporal "Tuvimos un problema trayendo los restaurantes".
*   [ ] CA3: Si algún producto carece de imagen propia configurada, no falla el dibujo del ListView y coloca una foto por defecto (Asset interno "no-img").
*   [ ] CA4: Permisos confirmados: Restringe totalmente el acceso a Roles de "Domingo/Domiciliario", regresándolo al Dashboard de conductor.
*   [ ] CA5: El paginado del backend sirve lotes finitos y se agregan a la pantalla al hacer scrollear inferiormente.
*   [ ] CA6: Presionar un comercio levanta sin demoras inusuales sus categorías de productos persistidas correctas y en orden.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 5 | **Prioridad:** Alta

### HU-05: Agregar al carrito
**Descripción:** Como cliente, quiero agregar productos al carrito interactivo y modificar las cantidades deseadas.

**Implicación Frontend:**
* Manejo de carrito global en Riverpod con persistencia en el dispositivo con el paquete Hive.
**Backend:** Ninguna (solo memoria frontal del teléfono temporal).

**Criterios de Aceptación:**
*   [ ] CA1: Clicar sobre "Añadir Producto" graba una entidad OrderItem en el HiveBox y suma de inmediato en el icono contador flotante.
*   [ ] CA2: Si se añade un producto de un *Comercio B* habiendo uno del *Comercio A*, el frontend advierte "Debe vaciar su compra del local anterior" (carrito mono-comercio).
*   [ ] CA3: Modificar la cantidad restando hasta valor numérico 0 ocasiona la auto-eliminación de esa ítem y actualiza re-calculando en vivo el subtotal.
*   [ ] CA4: Seleccionar cantidades desproporcionadas fallará la lógica indicando "Sujeto a límite de unidad máxima" en el input.
*   [ ] CA5: Al reiniciar el teléfono y relanzar el App, Riverpod inyecta la memoria desde Hive restaurando fielmente el carrito donde quedó.
*   [ ] CA6: El valor del subtotal (Cantidad x Precio Base) corresponde matemáticamente a la suma exacta flotante.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 5 | **Prioridad:** Alta

### HU-06: Confirmar orden
**Descripción:** Como cliente, quiero revisar y finalizar el pedido que construí en mi carrito para su generación formal.

**Implicación Frontend:** Tomar el record de Hive Cart, construir base JSON y disparar POST method.
**Implicación Backend:** POST /api/store/orders/, almacenar en BD amarrado al UUID de ese Client y de ese Comercio.

**Criterios de Aceptación:**
*   [ ] CA1: Al pulsar Pagar, la data es enviada y grabada integralmente en la Base de Datos con estatus `Pendiente` emitiendo respuesta 201 Created.
*   [ ] CA2: Intentar concretar un intento vacío no ejecuta el llamado Red, muestra de inmediato "Carrito inactivo" en pantalla.
*   [ ] CA3: Detecta precios modificados: el Backend audita los precios de Productos vs los expuestos; devuelve alerta ante diferencia sospechosa.
*   [ ] CA4: Posterioridad de compra confirmada expulsa exitosamente las entidades de la memoria temporal (limpieza del carrito Hive).
*   [ ] CA5: Se asocia a esa Order de manera forzosa el JWT Profile y la tienda objetivo sin posibilidad de crear datos ajenos o anónimos.
*   [ ] CA6: La aplicación deriva a una vista "Check / Success" que posee el botón volver o ver historial.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 3 | **Prioridad:** Alta

### HU-07: Historial órdenes
**Descripción:** Como cliente, deseo explorar la retrospectiva de órdenes ejecutadas evaluando su estatus actual.

**Implicación Frontend:** OrderHistoryScreen. Renderizando lista recuperada del servidor y cacheada.
**Implicación Backend:** Endpoint GET mis ordenes filtradas por usuario en JWT Bearer autenticado.

**Criterios de Aceptación:**
*   [ ] CA1: Resuelve de forma lista ordenada (Fechas Descendentes), detallando ID, Comercio, CostoTotal y color de estado de Orden.
*   [ ] CA2: Al cliente no presentar récord histórico en Backend, retorna lista vacía en Flutter dictando "No cuentas con encargos en plataforma."
*   [ ] CA3: Validado férreamente para que en BD unicamente retorne IDs pertenecientes al usuario. Intrusión de GET muestra 403 o no results ajenos.
*   [ ] CA4: Abrir un Item derivará detalladamente qué se seleccionó internamente, abriendo en modalidad Pantalla Completa.
*   [ ] CA5: Un valor dañado en la respuesta JSON no quiebra el renderizado entero; el interceptor de excepciones protege en su diseño Riverpod.
*   [ ] CA6: Estado visual usa patrón `Enum`: ej. Entregado(Verde), Cancelado(Rojo), Preparando(Amarillo).

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 2 | **Prioridad:** Media

---

## 🛵 MÓDULO 3: Domicilios (Entregas A/B)

### HU-08: Solicitar domicilio individual
**Descripción:** Como cliente, quiero especificar una recogida simple (Punto A) hacia un destino (Punto B) describiendo su naturaleza.

**Implicación Frontend:** UI de form con validadores. Opciones desplegables.
**Implicación Backend:** POST de petición independiente DeliveryRequest, no atada a la tienda comercial.

**Criterios de Aceptación:**
*   [ ] CA1: Llenando Direcciones Origen/Destino de forma lícita, Django percibe el modelo con éxito originando ID Ticket inicial "EN BUSCA DE REPARTIDOR".
*   [ ] CA2: Si se omite una de las calles, o se da campo nulo de nota, Flutter arroja "El campo requerido necesita especificación puntual".
*   [ ] CA3: Limitación validacional String máxima; la nota extensa a > 200 caracteres es truncada o no aceptada comunicándose activamente al remitente.
*   [ ] CA4: Permiso Backend anula su ejecución si el JWT corresponde a Categoría "Domiciliario", ya que estos no solicitan.
*   [ ] CA5: Al retornar el status http 200 de aceptación por parte del servidor, redirige frontal avisando "Generada orden, esperando repartidor cercano".
*   [ ] CA6: Persiste el dato de longitud de forma segura guardada en la Delivery table base de Django DB.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 3 | **Prioridad:** Alta

### HU-09: Ver estado de domicilio en curso (Cliente)
**Descripción:** Como cliente, quiero observar en vivo la cronología o avances del repartidor operando.

**Implicación Frontend:** Vista de rastreo. Polling Timer o Web Socket simple en Flutter refescando el status textual.
**Implicación Backend:** GET estatus o emitir canal a receptor de que algo varió.

**Criterios de Aceptación:**
*   [ ] CA1: Muestra los niveles paso a paso desde "Buscando...", "En Recolección", "En Trayecto" e interconectando actualizados fiel a base.
*   [ ] CA2: Al tomar el contrato un motorizado, este muestra Nombre y Vehículo del Conductor extraídos del profile Django.
*   [ ] CA3: Restricción absoluta para solo permitir este chequeo/bucle a quien haya firmado o sea el propietario original ID UUID del Ticket.
*   [ ] CA4: Pérdida momentánea de Wi-Fi en el dispositivo no destruye los datos de UI congelando y espera recuperación del Thread Polling.
*   [ ] CA5: Cerrar la app temporalmente y regresar, abre directamente a la misma orden inconclusa sin perder el rastreo o requerir re-navegación.
*   [ ] CA6: Lograr el "Entregado" final pausa por completo la comunicación HTTP recurrente para ahorro lógico del dispositivo (Kill stream).

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 3 | **Prioridad:** Alta

### HU-10: Gestionar peticiones asignadas (Dashboard Domiciliario)
**Descripción:** Como domiciliario, observo mi bolsa o bandeja de misiones, decidiendo aceptarlas y actualizando la línea.

**Implicación Frontend:** DashboardScreen exclusivo de su Shell. Cajas con botones de ciclo de vida con llamadas PATCH.
**Implicación Backend:** PATCH status y amigable de UUID Driver hacia la tabla Deliveries. Aseguramiento drástico en DRF sobre quién parcha la ruta.

**Criterios de Aceptación:**
*   [ ] CA1: Un domiciliario libre ve la tarjeta pública. Pulsa 'Aceptar', Backend lo ancla en Django BD actualizando Status originado 200, desapareciendo al resto.
*   [ ] CA2: Pulsar "Entregado" al paquete recién recibido sin haber presionado el punto cronológico "En camino/Recogido" estallará y limitará la decisión 400 ERROR.
*   [ ] CA3: Backend responde firmemente 403 FORBIDDEN si trata de simularlo una cuenta cliente común que accedió por alteración de código postman.
*   [ ] CA4: Si simultáneamente Motorizado A y Motorizado B acuden por presionar Aceptar el ticket único, el último rebotará y la UI responderá "El pedido ha sido asignado a un tercero".
*   [ ] CA5: Al liquidar "Finalizado", la app del Motorizado limpia visualmente la fila e informa del siguiente objetivo disponible.
*   [ ] CA6: Todo evento es persistido anexándole la variable datetime automática en BDD garantizando pista auditora.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 5 | **Prioridad:** Alta

### HU-11: Panel financiero del domiciliario (Balances)
**Descripción:** Un listado visual de ganancias personales agrupadas.
**Implicación Backend:** Django ORM uso de método Aggregate/Sumatoria de domicilios entregados filtrando con `Driver_id = requests.user`.

**Criterios de Aceptación:**
*   [ ] CA1: Panel muestra fielmente la suma de entregas exitosamente terminadas convertidas a divisas monetarias globales.
*   [ ] CA2: Si el Motorizado ingresa el lunes de su primera semana, la pantalla expone $0.0 sin quebrar ni exponer null object referencers de lenguaje dart.
*   [ ] CA3: Se permite pulsar chips de mes: "Semana/Mes/Todos" reaccionando en base a parámetros HTTP URL Queries `?filter=mes`.
*   [ ] CA4: Absorbente filtro restringe a CERO visibilidad si interfiere personal no autorizado.
*   [ ] CA5: Genera desglose histórico, indicando el ID del domicilio relacionado y el pequeño valor parcial que se sumó.
*   [ ] CA6: Las cifras en BD superan tests automáticos comprobables asegurando sumatoria de la base a nivel DB sin error redondeos extraños de float.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 3 | **Prioridad:** Media

---

## 🛠️ MÓDULO 4: Servicios Diferenciados

### HU-12: Ver prestadores (Directorio Profesionales)
**Descripción:** Como cliente, usaré una plataforma estilo directorio para encontrar técnicos o profesionales confiables.
**Implicación Frontend:** Muestreo ListView de usuarios "Prestador" de Django.
**Implicación Backend:** Backend expone endpoint condicionado en que su perfil debe contener True en variable de ValidadoAdmin.

**Criterios de Aceptación:**
*   [ ] CA1: Listas exhiben a todo prestador clasificado por "Rubros", devolviendo Name, Profesión y calificación o Descripción básica de tabla original Django.
*   [ ] CA2: Exclusión agresiva: Prestadores no revisados por Admin se aíslan radicalmente del listado previniendo accesos truchos o fraudes.
*   [ ] CA3: Falla de base de red responde en UI con un "Offline: Conéctate o Reinténtalo".
*   [ ] CA4: El directorio implementa search-bar local Front permitiendo re-dibujar la lista mediante coincidencias con su título / oficio de forma nativa.
*   [ ] CA5: Las fotos del perfil devueltas por Django cargan eficientemente; a defecto sin foto, pinta un Vector ícono.
*   [ ] CA6: Rol garantizado para navegar a cualquier Client verificado y Administrador.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 3 | **Prioridad:** Alta

### HU-13: Solicitar profesional (Crear Lead)
**Descripción:** Como cliente elegí uno de los prestadores en pantalla anterior, deseo ahora mandarle una petición/fecha agendable de avería.
**Implicación Frontend:** Datepicker, text-area, y envio de Petición/ServiceLead. POST simple.
**Implicación Backend:** End Point creando ServiceLead, inyectando user id en campo FK `customer` y profesional FK `provider`.

**Criterios de Aceptación:**
*   [ ] CA1: Tipeados detalles correctos de fecha futura y falla descriptiva; se elabora con respuesta "Enviada". Queda listado persistido.
*   [ ] CA2: Invalidación obligatoria del Datepicker: bloquea tajante seleccionar fechas retrospectivas irreales o "Días pasados".
*   [ ] CA3: Faltar descripción del encargo previene peticionar informando que el Prestador debe conocer la información obligatoria antes de ir a domicilio.
*   [ ] CA4: Control estricto prohibiendo a cuentas Admin / Domiciliario jugar al creador de servicios profesionales bajo su token jwt.
*   [ ] CA5: Genera una línea transaccional en Base de Datos asegurada en Status Inicial Incierto/"Revision del Obrero".
*   [ ] CA6: El Prestador destinatario recibe el ID nuevo de forma automática en su pool interno.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 3 | **Prioridad:** Alta

### HU-14: Perfil de Profesional (Subida de Docs/CV)
**Descripción:** Como prestador requiero un formulario para subir mis documentos oficiales avalables por administrador y mis referencias iniciales.
**Implicación Frontend:** Complejidad media. Integrar SDK de `file_picker` e `image_picker`. Envió pesado de binarios en Dio multi-part.
**Implicación Backend:** Interceptor REST que atrapa Files form-data, adjuntando e insertándose a Media folder de su registro asociado User Profile.

**Criterios de Aceptación:**
*   [ ] CA1: Subida de hoja de vida (PDF/DOC) es exitosa, viaja seguro multi parte completando la base relacional del usuario indicándole "Subido exitoso".
*   [ ] CA2: Al excederse del peso natural permitido de Documentos (> 8 Mb) rechaza el guardado antes de gastar recursos de envío y despliega barra roja de peligro.
*   [ ] CA3: Seleccionado un documento con extensión ilegítima (como un exe o zip peligroso) deniega desde UI o Backend "Solo extensiones PDF/Docx admitidas".
*   [ ] CA4: Un hackeo tipo request alterada de Cliente o Motorizado a este Endpoint de actualización profesional retorna 403 Inminente.
*   [ ] CA5: Editar en un futuro de manera profunda su especialidad/archivo, retrocede a forcejeo su validez a estado "Requiere Revistar a cargo del Admin por nuevos cambios".
*   [ ] CA6: Toda variable persiste en su tabla UserProvider sub tabla localizable.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 5 | **Prioridad:** Alta

### HU-15: Responder solicitud o cotizarla (Prestador)
**Descripción:** Como trabajador contratado miro mis cotizaciones recibidas desde clientes evaluando si voy al lugar o niego el trabajo.
**Implicación Frontend:** UI Tabulación de Inbox / Bandejas Entrada. Dispara app llamadas celular (`url_launcher`).
**Implicación Backend:** Acción HTTP Patch sobre Entidad Lead a Status Aceptado(Acuerdo)/Denegado.

**Criterios de Aceptación:**
*   [ ] CA1: Elegir "Tomar Trabajo" cambia visualmente la barra a Aprobado y sincroniza guardado a servidor notificando (opcional) a contraparte.
*   [ ] CA2: Tocar Ícono Teléfono ejecuta de manera nativa sin rotura SO de Android ni iOS activando agenda de llamadas local para concretar montos monetarios de mano de obra.
*   [ ] CA3: Denegado extingue listado central apartándolo por siempre bajo denominación Archivo Cancele en base de datos.
*   [ ] CA4: Restricción garantizada: Motorizados, ni Clientes diferentes pueden parchar esta decisión de labor especializada.
*   [ ] CA5: Intentar volver a cancelar o aceptar algo que lleva más de su tiempo procesado / O de ID erróneo previene con "Dato ya gestionado".
*   [ ] CA6: En inestabilidad conectiva, UI de botones retiene interacciones con Loading indicators (Spinner) previniendo duplicados HTTP.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 3 | **Prioridad:** Alta

---

## 📞 MÓDULO 5: Contactos

### HU-16: Ver directorio
**Descripción:** Como persona residente local quiero poder abrir un sub menú mostrando paramédicos bomberos hospitales disponibles en app.
**Implicación Frontend:** Tabs/TabBar segmentadas mostrando Cards coloridas y llamadas launcher.
**Implicación Backend:** GET sencillo que trae registros desde tabla PublicContacts.

**Criterios de Aceptación:**
*   [ ] CA1: Solicitud entrega Data exitosamente acomodando filas según Categorías en pestañas UI adaptables con su nombre y numero.
*   [ ] CA2: Falta de Data Global del servidor en DB genera "Contactos no pre establecidos, contacte admin."
*   [ ] CA3: Acción sobre el renglón marcado deriva eficazmente a efectuar una llamada nativa del usuario sin fallas de paquete móvil.
*   [ ] CA4: Base consultable de forma omnipotente dado su naturalidad pública para los distintos roles logueados previstos.
*   [ ] CA5: Contactos des habilitados u escondidos vía sistema Soft Delete (is_active) no traspasan filtro devolviendo pulcritud al frontend. 
*   [ ] CA6: Un reinicio general no traba listado y no demora la ejecución bajo conectividad estándar validada.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 2 | **Prioridad:** Media / Alta

### HU-17: Filtrar directorio
**Descripción:** Como ciudadano deseo ingresar término policía e interactuar dinámico extrayendo rápidamente resultados precisos locales.
**Implicación Frontend:** Implementar caja "Search" TextField amigable, filtrando matriz en memoria listado final.

**Criterios de Aceptación:**
*   [ ] CA1: Letra digitada "P" acorta progresivamente resultados en vivo encasillando coincidencias parciales con "Policía".
*   [ ] CA2: Campo inexistente con cero equivalencias ("Qwert") no explota variables de nullsafety del lenguaje móvil dictando amigable 'Sin Parecidos'.
*   [ ] CA3: Borrado por 'x' botón resetea toda la matriz inyectando lista completa de vuelta a la UI sin requerir volver a consumir en red.
*   [ ] CA4: Filtrado asume compatibilidad flexible sin que lo afecte mayúsculas u minúsculas de entrada en escritura de los usuarios finales.
*   [ ] CA5: Funciona a la par del sub tabulador interno para no sobrecruzar un dentista en la zona de médicos primarios.
*   [ ] CA6: Sin bloqueos por roles, permitiéndose en usuarios de diferentes esferas.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 1 | **Prioridad:** Media

---

## 📊 MÓDULO 6: Administración Control Central

### HU-18: Dashboard Admin (Métricas maestras)
**Descripción:** Como responsable operativo, ingreso en panel propio y veo conteos totales sobre movimientos estadísticos generales.
**Implicación Frontend:** Tarjetas y bloques (Dashboards Tiles). Variables mapeadas desde un View. 
**Implicación Backend:** Construye URL en `api/reports/dashboard` que devuelve objeto condensado calculando registros y cuentas generadas en ORM agil.

**Criterios de Aceptación:**
*   [ ] CA1: Auténticamente trae variables sumatorias a pantalla demostrando "10 Usuarios | 4 Tiendas | 5 Domicilios finalizados".
*   [ ] CA2: Al carecer métricas pasadas para su cálculo reporta 0 de forma serena y real evitando errores matemáticos de división flotante.
*   [ ] CA3: El pilar esencial es salvaguardar vía Roles que cualquier Intento de intromisión en "Role de Operario" resulta denegado en la barrera HTTP y no filtra data crucial de App (Error 403).
*   [ ] CA4: Front-end expulsa a intrusos mandándolo a Pantallas login u base predeterminadas, aliviando cruces de links.
*   [ ] CA5: Si hay una gran carga de registros, las sentencias Django Aggregate optimizadas entregan resultados en Tiempos de Respuesta lícitos (Debajo de los 5 Segundos).
*   [ ] CA6: Tarjetas de Dash se grafican correctas y adaptativas dentro de vistas Landscape/Vertical para navegantes en tabletas del Admin.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 5 | **Prioridad:** Alta (Si el rol Admin está planteado de Día 1 fase crítica).

### HU-19: Aprobar profesionales
**Descripción:** Como moderador evaluador quiero observar las filas de técnicos obreros registrados decidiendo si pueden ofrecer los servicios de su hoja currículo validando documentación temporal.
**Implicación Frontend:** Table UI del lado Flutter con botones Confirmación Cruzada. Vista pre visualizada y descarga Web de fichero link local.
**Implicación Backend:** PATCH URL campo Boolean `Is_Approved = true/false` con auditoria de respuesta enviada.

**Criterios de Aceptación:**
*   [ ] CA1: Clic Confirmar envía variable lógica verdadera por backend mudando el perfil del proveedor a público visible por la zona clientes y grabando fecha en BBDD.
*   [ ] CA2: Presentar botón Descarga / Abrir Hoja PDF que funciona correctamente abriendo la validación del binario en la app base.
*   [ ] CA3: Si Admin niega su perfil, desestima solicitud arrojándolo en lista final, opcionalmente despachando mensaje y negando ingreso app posterior del postulante.
*   [ ] CA4: Interrupción en la capa de Backend deja un Roll-back seguro alertando fallo en transacción HTTP previniendo botón fantasma confirmado.
*   [ ] CA5: Rol Super Administrador resguardado de punta a punta frente al ataque o alteramiento por terceros carentes del Role Permit y/o Autenticación Jwt Válido.
*   [ ] CA6: La vista solo arrastra perfiles pendientes ahorrando cargar miles de usuarios pre aprobados gracias al Django filtering.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 3 | **Prioridad:** Urgente (Sin esto los Proveedores resultan atorados tras alta).

### HU-20: Gestionar contactos (CRUD de Directorio)
**Descripción:** Como gerente agrego de manera expedita un departamento policial de apoyo local en listado telefónico editándolo de ser erróneo.
**Implicación Frontend:** Formulario creación estándar en AdminShell gestionando y listando CRUD completo nativo REST.
**Implicación Backend:** Acciones POST, PATCH y DELETE Lógico a API public contacts protegiendo por permisos JWT.

**Criterios de Aceptación:**
*   [ ] CA1: Completar "Guardar", adiciona el número telefónico salvando registro y volviéndolo parte de la vista matriz pública expuesta de los usuarios.
*   [ ] CA2: Al eludir el Título nombre, la alerta Form invalida el envió dictando "Faltante Requisito" impidiendo ensuciar base.
*   [ ] CA3: Eliminar botón acciona modalidad soft borrado marcándolo extinto para no presentar roturas forenses transcurridas (is_active False).
*   [ ] CA4: Formato teléfono acepta estrictamente numerales truncándose la longitud o mostrando un validador tipo "Ingresa valores celulares exactos" erradicando letras base.
*   [ ] CA5: Duplicados son advertidos "Numero Existente de Pre-Mano" desde Base Django interconectando con capa Frontal.
*   [ ] CA6: Restringido al Administrador como base fundamental. Ni un cliente creará listas bajo ningún escenario de error frontal posible.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 3 | **Prioridad:** Baja

### HU-21: Ver reportes completos
**Descripción:** Como líder de la plataforma exporto de modo tabular un análisis generalizado segmentado según temporalidad y resultados monetarios.
**Implicación Frontend:** Paneles Filtro Fechas (Data Range Pickers) exportando UI.
**Implicación Backend:** Parámetros Query y filtro avanzado Django Rest Framework (django-filter) garantizando entregas condensables.

**Criterios de Aceptación:**
*   [ ] CA1: Ajustar "Fecha Rango y Fecha Final", dispara petición resolviendo satisfactoriamente el bloque Data Set visual mostrándose ordenado.
*   [ ] CA2: Mandar tiempo invertido inválido o incongruente ("De Diciembre a Enero en reverso") levanta barrera HTTP 400 avisando al gerente el mal cálculo humano.
*   [ ] CA3: Si no poseo registro de actividad esos feriados indicados me indica tabla totalmente en blanco excribiendo "Sin coincidencias encontradas".
*   [ ] CA4: Backend garantiza una contabilidad escalable proveyendo paginación robusta para no crashear la red RAM del servidor API base ante rangos inmensos pesados históricos.
*   [ ] CA5: Permite la lectura completa de Reportes solo, exclusiva y formalmente atado al nivel máximo administrativo JWT Role.
*   [ ] CA6: Genera cálculo preciso desde BBDD asegurado por ORM confiable sin discrepancia de la billetera final arrojada visual en Front.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio (commit/push) y ejecuta sin errores en consola/terminal.
*   [ ] Pruebas básicas realizadas (manual o automatizada vía tests unitarios) con evidencia.
*   [ ] Validaciones implementadas y manejo de errores visible al usuario.
*   [ ] Control de acceso por roles aplicado (manejo en BBDD y serializador de datos).
*   [ ] Datos persistidos correctamente y verificados directamente en la base de datos (PostgreSQL/SQLite).
*   [ ] Evidencia adjunta: capturas, video corto o link demo + datos de prueba usados.
*   [ ] Documentación mínima actualizada (README o nota de 'cómo probar' esta HU).

**Puntos:** 5 | **Prioridad:** Baja
