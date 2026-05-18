import sys

content = \"\"\"# Backlog de Historias de Usuario - Runners (Formato ClickUp)

Este documento contiene las Historias de Usuario estructuradas según la arquitectura actual (Flutter + Django) listas para ser copiadas y pegadas como tareas en **ClickUp** o cualquier otro gestor Kanban.

---

## 🔒 MÓDULO 1: Autenticación y Usuarios

### HU-01: Registro de usuario
**Descripción:** Como usuario nuevo, quiero registrarme en el sistema con mi nombre, apellido, correo, contraseña y el rol solicitado, para crear una cuenta en la aplicación.

**Implicación Frontend (Flutter):**
*   **UI:** Construir RegisterScreen con TextFormField, validadores de formulario, y opciones de selección de rol.
*   **Lógica:** Usar Riverpod (authProvider) para manejar el estado y llamar a AuthRepository.
*   **Rutas:** Configurar GoRouter para navegación de vuelta al login al terminar.

**Implicación Backend (Django):**
*   **API:** Crear POST /api/users/register/.
*   **Lógica:** Implementar UserSerializer en Django REST Framework. Guardar contraseña en hash.
*   **Reglas:** Si el rol es "Prestador", dejar cuenta en estado pendiente de aprobación.

**Criterios de Aceptación:**
*   [ ] CA1: Con datos válidos completos, el sistema crea la cuenta, persiste al usuario en la BD y muestra éxito.
*   [ ] CA2: Si falta correo, contraseña o rol, impide el envío y alerta "Campo obligatorio faltante".
*   [ ] CA3: Si el correo es inválido o ya existe en el sistema, informa "El correo ya está registrado" u "Otorga un email válido".
*   [ ] CA4: Si el rol seleccionado es Admin, no debe permitirse desde esta vista (acceso denegado por seguridad).
*   [ ] CA5: Al crear una cuenta rol "Prestador", el usuario figura en base de datos como inactivo o con flag_approved=False.
*   [ ] CA6: En caso de desconexión sin red, muestra "Error de red" sin colapsar y permite reintentar.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos de Historia:** 3 | **Prioridad:** Urgente

---

### HU-02: Inicio de sesión
**Descripción:** Como usuario registrado, quiero iniciar sesión con mi correo y contraseña, para acceder a mi perfil y a las pantallas restringidas para mi rol.

**Implicación Frontend (Flutter):**
*   **UI:** LoginScreen con email de entrada, ocultamiento de password y Loading overlay.
*   **Lógica:** Consumir backend, guardar JWT en SecureStorage, setear el Token global.
*   **Navegación:** Usar JWT Claims o response body para saber a qué Shell redirigir.

**Implicación Backend (Django):**
*   **API:** POST /api/users/login/ con SimpleJWT.

**Criterios de Aceptación:**
*   [ ] CA1: Al insertar datos válidos, devuelve los tokens de sesión, inicia sesión y bifurca al panel correcto por el Rol.
*   [ ] CA2: Con datos vacíos, bloquea formulario hasta ingreso de al menos un carcter validado.
*   [ ] CA3: Con data inválida (mala contraseña), el backend devuelve credenciales inválidas; interfaz imprime error.
*   [ ] CA4: Si la cuenta está deshabilitada (Prestador suspendido, Cliente borrado), recibe "Cuenta Inhabilitada" en login.
*   [ ] CA5: Usuario autenticado visualiza su pantalla objetivo. Storage local asegura un reinicio fluido.
*   [ ] CA6: Token caducado redirige de inmediato a ventana login en nueva sesión.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos de Historia:** 5 | **Prioridad:** Urgente

---

### HU-03: Cierre de sesión (Logout)
**Descripción:** Como usuario autenticado, quiero cerrar sesión de forma segura para proteger mi cuenta y borrar datos locales.

**Implicación Frontend Frontend:** Lógica de AuthProvider para Hive y SecureStorage delete clear. Refrescar GoRouter.
**Implicación Backend Backed:** Endpoint Logout para blacklist del refreshToken.

**Criterios de Aceptación:**
*   [ ] CA1: Dar tap al cerrar sesión borra absolutamente Token local y lo direcciona a Splash / Login.
*   [ ] CA2: Al presionar regresar (Atrás Android), evita regresar al contenido privado obligando un Login forzado.
*   [ ] CA3: Peticiones HTTP en curso son frenadas / expiran 401 para ese usuario.
*   [ ] CA4: El sistema se recupera de manera elegante permitiendo el acceso con cuentas distintas posteriores.
*   [ ] CA5: Excepción en red local permite cerrar sesión asíncrona pero sin validación servida hasta reiniciar.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 1 | **Prioridad:** Alta

---

## 🛒 MÓDULO 2: Tienda

### HU-04: Ver comercios y productos
**Descripción:** Como cliente, quiero ver los comercios disponibles y su catálogo de productos.

**Implicación Frontend:** StoreScreen, FutureProviders, ListView / GridView builders e Images por Cache.
**Implicación Backend:** Endpoints GET comercios e items.

**Criterios de Aceptación:**
*   [ ] CA1: Visualizará lista de tiendas, y entrando le detallará el catálogo base, respetando stock.
*   [ ] CA2: Si la conexión a la base de datos pierde enlace de internet mostrará de reintento.
*   [ ] CA3: Permite visualizar de forma atómica el detalle producto al pinchar para mostrar un modal expansivo (Info).
*   [ ] CA4: Restringe su uso. Roles Domiciliario y Prestador se les avisa acceso fallido por vista y back.
*   [ ] CA5: Muestra mensaje al faltar items dentro de almacenes no operantes "Sin catálogo actual".
*   [ ] CA6: Paginar los registros. Una base no trunca >50 records mostrándolos en Lazy Load general.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 5 | **Prioridad:** Alta

### HU-05: Agregar al carrito
**Descripción:** Como cliente, quiero agregar productos al carrito y modificar cantidades localmente.

**Implicación Frontend:** Notifier usando Hive Boxes asincronos locales para carro.
**Backend:** Memoria limpia temporal sin contacto Backend.

**Criterios de Aceptación:**
*   [ ] CA1: Añadiendo artículos su contador escala, actualiza precio total visual y de carrito base.
*   [ ] CA2: Desfase nulo o numérico negativo anula el objeto borrándolo del carrito global sin problemas.
*   [ ] CA3: Apagar App y prender restituye íntegramente de la base Hive el mismo set de compra.
*   [ ] CA4: Máximo 99 objetos impiden tap al usuario mandando "Límite establecido".
*   [ ] CA5: Intentando insertar ítems de tienda A y B juntos exige un pop up previniendo compras inter-tiendas (si rige por normas BD).

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 5 | **Prioridad:** Alta

### HU-06: Confirmar orden (Checkout)
**Frontend:** Checkout Payload Action a API Order endpoint.
**Backend:** POST para grabar Cabecera Store_Order y líneas OrderItems.

**Criterios de Aceptación:**
*   [ ] CA1: Estando listo e informando parámetros OK envía transaccion; al retornar 201 exitoso despeja local store Carrito e informa "Éxito".
*   [ ] CA2: Envío de objetos inexistentes provoca denegación backend validado y frena orden.
*   [ ] CA3: Falla servidor local frena con Time Out al cliente emitiendo snackbar al respecto, NO borra data en celular.
*   [ ] CA4: Evidencia base guarda a la hora de envío con el Cliente Logueado el objeto.
*   [ ] CA5: Permite asociar una descripción breve de envío a la orden al restaurante/tienda sin romper JSON.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 3 | **Prioridad:** Alta

### HU-07: Historial órdenes
**Frontend:** Pantalla Order History con lista orden de base de datos.
**Backend:** GET mis orders filtradas por Token de user ID.

**Criterios de Aceptación:**
*   [ ] CA1: Puestos param de fecha descendente trae mis compras personales en estado respectivo.
*   [ ] CA2: Alguien buscando por GET ajeno no obtiene respuestas bloqueadas a 403 Forbidden.
*   [ ] CA3: Si historia esta limpia muestra layout indicativo amistoso ("Sin Pedidos").
*   [ ] CA4: Un Token falso interrumpe redireccionando a login.
*   [ ] CA5: Contiene filtros para ordenes completas, en proceso y canceladas en vista de APP.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 2 | **Prioridad:** Media

---

## 🛵 MÓDULO 3: Domicilios

### HU-08: Solicitar domicilio (Cliente)
**Descripción:** Cliente reporta envío externo A a punto B simple.
**Frontend:** Formularios text Form fields origen y paquete. Backend api endpoint deliveries.

**Criterios de Aceptación:**
*   [ ] CA1: Rellena Origen "Calle A" y Destino "Casa B" y texto; devuelve un identificador base y estado Pendiente en BBDD.
*   [ ] CA2: Dejo nulo el origen emite alerta y sombrea en rojo input respectivo denegando pasaje.
*   [ ] CA3: Token sin permiso (Ej. Provider rol) intenta POST, revoca de tajo.
*   [ ] CA4: Finalizado se expulsa notificación "Asignado a Driver de manera satisfactoria."
*   [ ] CA5: Una solicitud con tarifa calculada guarda dicho precio desde el principio.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 3 | **Prioridad:** Alta

### HU-09: Ver tracker domicilio (Cliente)
**Frontend:** Poller u Socket hacia Status Id. Tracker vertical.
**Backend:** GET Status del objeto Domicilio especifico.

**Criterios de Aceptación:**
*   [ ] CA1: Flujo positivo muestra a qué driver esta asociado su orden e icono reacciona "En Camino".
*   [ ] CA2: Si falla internet entra espera congelada pasiva previendo caídas masivas en APP.
*   [ ] CA3: Restringe por API que solo Owner (User ID emisor) vigila su envio personal en curso.
*   [ ] CA4: Cambia fase final a Entregado concluyendo la vista y dejando calificar (opcional UI).
*   [ ] CA5: Al finalizar, recargar vista expulsa a pantalla Home "Sin envíos recientes".

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 3 | **Prioridad:** Alta

### HU-10: Gestionar peticiones asignadas (Domiciliario)
**Frontend:** Tablero Delivery Dashboard y gestor status PATCH.
**Backend:** Viewset Domiciliario.

**Criterios de Aceptación:**
*   [ ] CA1: El domiciliario puede listar "Pendientes" libremente tomando 1 para sí; esta toma registra su User_ID en ORM BBDD y lo quita del mapa colectivo.
*   [ ] CA2: El orden requerido (Pendiente -> Aceptado -> En Recogida -> Finalizado) traba la BD si se intenta saltar fases sin pasar progresivo.
*   [ ] CA3: Roles de Admin o cliente que clican endpoint asumen error severo y deniega entrada 403 Rest DRF.
*   [ ] CA4: Si simultáneamente alguien más toma su ticket local le da error soft "Has perdido la chance, Orden asignada ya".
*   [ ] CA5: Actualiza la variable Fecha_Modificación a tiempo real para reportes futuros de rapidez por encargo.
*   [ ] CA6: Culminar "Finalizado" elimina registro su lista volviendo estado del Domiciliario a 'Disponible'.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 5 | **Prioridad:** Alta

### HU-11: Finanzas domiciliario
**Descripción:** Panel resumido que integra tabla monetizado.
**Backend:** Aggregate Queries de Django con DRF.

**Criterios de Aceptación:**
*   [ ] CA1: Domiciliario visualiza en verde monto general amarrado a Deliveries "Entregado" propios.
*   [ ] CA2: Inhabilita ver métricas de otros envios paralelos no pertenecidos.
*   [ ] CA3: Consultas de fechas vacías por default traen Semanal.
*   [ ] CA4: Listado incluye botón inferior "Historial Completo" extendible sin recargar RAM brutal del Server.
*   [ ] CA5: Si cuenta personal tiene ingresos de 0, texto afable reporta "Inicia jornada".

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 3 | **Prioridad:** Media

---

## 🛠️ MÓDULO 4: Servicios

### HU-12: Ver prestadores
**Frontend:** Directorio agrupado de personal de oficios varios.
**Backend:** GET Users Role Prestador approved validos.

**Criterios de Aceptación:**
*   [ ] CA1: Los usuarios con check "Approved=True" listan correctos con imágenes por categoría seleccionadas.
*   [ ] CA2: Fallos del servidor o red devuelven Shimmer Effect y mensaje "Error red" al cliente.
*   [ ] CA3: Cualquier Prestador pendiente es completamente invisible ante esta querie en la API (Proteccion Nivel Backend).
*   [ ] CA4: Cada tarjeta responde en el clic hacia su respectiva vista interior Info Profile Detail de su ID.
*   [ ] CA5: Muestra mensaje genérico neutro ante grupo Categoria "Plomero" Vacío de afiliados.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 3 | **Prioridad:** Alta

### HU-13: Solicitar profesional (Cliente)
**Frontend:** Datepicker Flutter y Lead TextField.
**Backend:** Post Lead Service object in DRF.

**Criterios de Aceptación:**
*   [ ] CA1: Siendo diligenciada la solicitud con fecha futura / actual lanza alerta éxito persistiendo BD.
*   [ ] CA2: Al introducir fecha histórica (ayer), bloquea en vista y anula Request a API.
*   [ ] CA3: Descriptivo corto de >10 char es rechazado, exigiendo detallar la anomalía/servicio deseada.
*   [ ] CA4: Permisologia bloquea la posibilidad de Prestador a pedir a prestador de forma cruzada para evitar fallos lógicos.
*   [ ] CA5: Genera notificación pasiva visible a Bandeja de Recepciones del proveedor destinatario.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 3 | **Prioridad:** Alta

### HU-14: Perfil Complejo Profesional (Prestador)
**Frontend:** Uso FilePicker a fin de hoja de vida (Multipart).
**Backend:** Request de Archivos y actualizador put profile view.

**Criterios de Aceptación:**
*   [ ] CA1: Seleccionado un doc PDF o foto, y validado en UI, el envío emite base FormData adjuntando archivo a MEDIA path y persistiendo nombre ORM.
*   [ ] CA2: Fija máxima tamaño subida; deniega mayores de X megabytes sin romper memoria Flutter con alerta pertinente.
*   [ ] CA3: Evita envíos sin foto ó sin descripción limitante, bloqueando el flag "Revisar Por Admin".
*   [ ] CA4: Altere datos un profesional validado, lo devuelve forzosamente a PENDIENTE bloqueándole listado público por seguridad.
*   [ ] CA5: En un corte de luz repentino / sin datos, el proceso Multipart falla avisado cancelando su subida parcial.
*   [ ] CA6: Prohíbe a Clientes ver o enviar estos perfiles restringiendo url por RolePermission base.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 5 | **Prioridad:** Alta

### HU-15: Responder solicitud (Prestador)
**Frontend:** Accept or Deny panel and Launcher URL app phone.
**Backend:** Patch status accept.

**Criterios de Aceptación:**
*   [ ] CA1: Cargar su perfil lee sus Leads; Darle "Check Okey" muta DB confirmándolo en cita acordada y lo mueve en UI.
*   [ ] CA2: El botar "x/Denegar" purga solicitud o la deja como Fallida por su parte.
*   [ ] CA3: Action Llamar toma String param phone del cliente de ORM resolviendo en app de teléfono limpia.
*   [ ] CA4: Privacidad asegurada ocultando Leads de Obrero Y a Obrero X siempre en DRF query filters.
*   [ ] CA5: Botón repetido (Doble clic Accept) neutraliza envío duplicado y salva consistencia BD status.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 3 | **Prioridad:** Alta

---

## 📞 MÓDULO 5: Contactos

### HU-16: Ver directorio de contactos
**Frontend:** Vista tabulada local base.
**Backend:** Public contact Endpoint GET.

**Criterios de Aceptación:**
*   [ ] CA1: Se renderiza Data persistida backend lista sin demoras mayores segmentadas por tabulación Categoría (Emergencia/Servicio).
*   [ ] CA2: Todo tipo y rol ve esto dado a que no requiere Bearer Token intrincado.
*   [ ] CA3: Los deletes lógicos False Is_Active no cruzan JSON al cliente nunca.
*   [ ] CA4: Tapping action abre dialer de celular confirmando conectividad a sistema numérico.
*   [ ] CA5: Caída de server produce cache local alternativo sin entorpecer visibilidad por emergencia.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 2 | **Prioridad:** Alta

### HU-17: Filtrar contactos
**Frontend:** SearchBar string matcher local memory.

**Criterios de Aceptación:**
*   [ ] CA1: Entrar caracteres actualiza la ListView local sin HTTP Extra con velocidad precisa matching títulos.
*   [ ] CA2: Al escribir tildes o mayúsculas el lowerCase Regex ignora diferencias y las matchea igual "polícia=Policia".
*   [ ] CA3: Nombres sin lógica devuelven panel de "No Contactos de búsqueda".
*   [ ] CA4: Desplazarse de tabulador resetea el String de Búsqueda a estado nativo limpliando su query.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 1 | **Prioridad:** Media

---

## 📊 MÓDULO 6: Administración

### HU-18: Dashboard Admin
**Frontend:** Data panel Admin Metric stats UI.
**Backend:** Serializer Aggregate Counts global.

**Criterios de Aceptación:**
*   [ ] CA1: Pantalla compila sin demoras mostrando Usuarios Totales extraídos por consulta optimizada del backend.
*   [ ] CA2: Entrar como cliente aquí causa Kick 401 con pantalla Redirigida de vuelta al comercio principal.
*   [ ] CA3: Contadores en Nulo no traen Crash Exception resolviendo Num=0 en cards Dashboarders.
*   [ ] CA4: Permiso exclusivo Role IsAdmin implementado a la clase completa y probado unitariamente de DRF.
*   [ ] CA5: La tabla general recarga información con un modelo drag refresh.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 5 | **Prioridad:** Media

### HU-19: Aprobrar profesionales (Admin)
**Frontend:** Checklist screen of reviews + Download Doc.
**Backend:** PATCH flag true/false to Provider status.

**Criterios de Aceptación:**
*   [ ] CA1: Lista todos los aspirantes "Is_Active=False" dejando la ruta del PDF lista.
*   [ ] CA2: Al ser clics se lee archivo a fondo en local por link HTTP media.
*   [ ] CA3: Accionar 'Aprobar' altera DB al instante reflejando dicho usuario aptamente en pantallas globales Clientes.
*   [ ] CA4: Invalidar y "Desaprobar" altera DB, manda a false, previene renderizar perfiles peligrosos o apócrifos.
*   [ ] CA5: Token bloquea su operación en roles mixtos con Permission Class estrictamente is_admin.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 3 | **Prioridad:** Alta

### HU-20: Crear Contacts Panel
**Frontend/Backend:** Contact creation form Model.

**Criterios de Aceptación:**
*   [ ] CA1: Formulario admin crea contacto emergente salvando todos los campos base en la nube.
*   [ ] CA2: Alarma por campo vacío traba HTTP form previniendolo.
*   [ ] CA3: SoftDelete desactiva de consulta pero deja log viejo a nivel base SQLAdmin.
*   [ ] CA4: Form detendrá strings invasivos o inyecciones sql básicas DRF serializer base valida su existencia y sanidad.
*   [ ] CA5: Permiso riguroso para SuperUsuario / Administradores de base.

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 3 | **Prioridad:** Baja

### HU-21: Ver reportes completos (Admin)
**Frontend/Backend:** Filters by Time and Status.

**Criterios de Aceptación:**
*   [ ] CA1: Un rango Fecha "Inicio y Final" válido exporta reporte Data Grid de todas entregas del rango.
*   [ ] CA2: Rango descabellado emite Alerta Fecha Invalida denegando Request "Finalizacion menor que Inicio".
*   [ ] CA3: Solo SuperAdmin emite orden HTTP, bloqueando filtración de datos de usuario a externos.
*   [ ] CA4: La paginación resguarda recursos de Memoria RAM listando páginas del reporte exportado en backend.
*   [ ] CA5: Retornar Vacías listas avisa con AlertBox simple, "Período temporal sin iteraciones a mostrar."

**Definition of Done (DoD):**
*   [ ] CA cumplidos y verificados (todos).
*   [ ] Código en repositorio principal (commit/push) ejecutando sin defectos.
*   [ ] Evidencia adjunta: validaciones visuales probadas en simulador (Captura/Video).
*   [ ] Control de acceso y roles aplicado correctamente en la ruta DRF.
*   [ ] Manejo de errores 400 y 500 configurado.
*   [ ] Operaciones en BD confirmadas mediante Postman.
*   [ ] Documentación/Readme con datos de prueba definidos.

**Puntos:** 5 | **Prioridad:** Baja
\"\"\"

with open('c:/Users/Usuario/Documents/runners/CLICKUP_HISTORIAS_USUARIO.md', 'w', encoding='utf-8') as f:
    f.write(content)
