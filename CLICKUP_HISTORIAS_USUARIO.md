# Backlog de Historias de Usuario - Runners (Formato ClickUp)

Este documento contiene las Historias de Usuario estructuradas segun la arquitectura actual (Flutter + Django) listas para ser copiadas y pegadas como tareas en **ClickUp** o cualquier otro gestor Kanban.

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
*   [ ] Todos los campos obligatorios deben estar validados antes del submit.
*   [ ] Mostrar SnackBar informativo si el correo ya esta registrado (Error 400).
*   [ ] Tras completar el registro, redirigir al usuario al Login.

**Definition of Done (DoD):**
*   [ ] Pantalla construida fiel al diseño sin errores de linter en Flutter.
*   [ ] Endpoint testeado via Postman (creación exitosa retorna 201).
*   [ ] Pull Request revisado.

**Puntos de Historia:** 3 | **Prioridad:** Urgente

---

### HU-02: Inicio de sesion
**Descripción:** Como usuario registrado, quiero iniciar sesion con mi correo y contraseña, para acceder a mi perfil y a las pantallas restringidas para mi rol.

**Implicación Frontend (Flutter):**
*   **UI:** Pantalla LoginScreen con inputs de email y password.
*   **Lógica:** Consumir endpoint de login mediante DioClient. Guardar JWT.
*   **Navegación:** Evaluar rol.

**Implicación Backend (Django):**
*   **API:** Endpoint POST /api/users/login/.

**Criterios de Aceptación:**
*   [ ] Validación de credenciales erroneas.
*   [ ] El enrutamiento pos-login correcto.

**Definition of Done (DoD):**
*   [ ] Interceptor de Dio implementado.

**Puntos de Historia:** 5 | **Prioridad:** Urgente

---

### HU-03: Cierre de sesion
**Descripción:** Como usuario autenticado, quiero cerrar sesion de forma segura.

**Implicación Frontend:** Borrar flutter_secure_storage y reset. Forzar GoRouter hacia /login
**Implicación Backend:** Blacklist de token (opcional).

**Criterios:** 
* [ ] Retorna al Splash o Login limpiando todo vestigio.
**Puntos:** 1 | **Prioridad:** Alta

---

## 🛒 MÓDULO 2: Tienda

### HU-04: Ver comercios y productos
**Descripción:** Como cliente, quiero ver los comercios disponibles y su catálogo de productos.

**Implicación Frontend:**
* StoreScreen, uso de CachedNetworkImage. Riverpod FutureProviders.
**Implicación Backend:**
* GET /api/store/businesses/ y GET /api/store/businesses/{id}/products/

**Criterios:**
* [ ] Listados paginados por backend.
**Dod:** 
* [ ] UI fluida.
**Puntos:** 5 | **Prioridad:** Alta

### HU-05: Agregar al carrito
**Descripción:** Como cliente, quiero agregar productos al carrito y modificar cantidades.

**Implicación Frontend:**
* Manejo de carrito global en Riverpod con persistencia en paquete Hive.
**Backend:** Ninguna (solo memoria).

**Criterios:** 
* [ ] Posibilidad de editar unidades.
* [ ] Se recarga la app y el carro continua persistente en Hive.
**Puntos:** 5 | **Prioridad:** Alta

### HU-06: Confirmar orden
**Frontend:** Tomar el Hive Cart, construir JSON para envio (POST).
**Backend:** POST /api/store/orders/, almacenar en BD atado al User y vaciar carrito en exito.
**Puntos:** 3 | **Prioridad:** Alta

### HU-07: Historial ordenes
**Frontend:** OrderHistoryScreen.
**Backend:** Endpoint GET mis ordenes filtradas por JWT bearer.
**Puntos:** 2 | **Prioridad:** Media

---

## 🛵 MÓDULO 3: Domicilios

### HU-08: Solicitar domicilio
**Descripción:** Cliente reporta origenes, destinos y objeto.
**Frontend:** UI de form simple con validadores.
**Backend:** POST de peticion con estado "Pendiente".
**Puntos:** 3 | **Prioridad:** Alta

### HU-09: Ver estado de domicilio (Cliente)
**Frontend:** RequestTimer / WebSocket en flutter para traer el nuevo estado hasta que sea "Entregado".
**Backend:** GET estatus puntual.
**Puntos:** 3 | **Prioridad:** Alta

### HU-10: Gestionar peticiones asignadas (Domiciliario)
**Frontend:** DeliveryDashboardScreen. Botones para cambiar ciclo PENDIENTE->ACEPTADO->EN CAMINO->ENTREGADO.
**Backend:** PATCH status de ordenes, validando permisos (IsDomiciliario).
**Puntos:** 5 | **Prioridad:** Alta

### HU-11: Panel financiero del domiciliario
**Descripción:** Un listado de balance de cartera (cuanto gané).
**Backend:** Endpoints agregados (aggregate de Django) de envios en estado Finalizado atados a este user.
**Puntos:** 3 | **Prioridad:** Media

---

## 🛠️ MÓDULO 4: Servicios

### HU-12: Ver prestadores
**Frontend:** Directorio agrupado.
**Backend:** GET de usuarios con Role=Provider donde is_approved=True.
**Puntos:** 3 | **Prioridad:** Alta

### HU-13: Solicitar profesional
**Frontend:** Datepicker widget para pedir la reparacion/servicio.
**Backend:** POST servicio requerido.
**Puntos:** 3 | **Prioridad:** Alta

### HU-14: Perfil Complejo de Profesional (Prestador)
**Frontend:** file_picker para Hoja de vida (PDF) y envio por Dio Multipart FormData.
**Backend:** Recibir Archivos y guardarlos en /media/ usando Django.
**Criterios:** Subida de binarios probada.
**Puntos:** 5 | **Prioridad:** Alta

### HU-15: Responder solicitud (Prestador)
**Frontend:** Bandeja de recibidos. Lanza app externa de llamadas para llamar y concretar.
**Backend:** PATCH status aceptado o denegado.
**Puntos:** 3 | **Prioridad:** Alta

---

## 📞 MÓDULO 5: Contactos

### HU-16 y HU-17: Directorio Publico
**Frontend:** Vista tabulada. Al tocar uno debe disparar url de sistema de telefono.
**Backend:** GET directo.
**Puntos:** 2 | **Prioridad:** Alta

---

## 📊 MÓDULO 6: Admnistración

### HU-18: Dashboard Admin
**Frontend:** Tarjetas sumatorias (Métricas).
**Backend:** GET con sumas (Counts genericos).
**Puntos:** 5 | **Prioridad:** Media

### HU-19: Aprobar profesionales (CRITICA)
**Frontend:** Ver listado pendiente, ver PDF.
**Backend:** PATCH al field is_approved.
**Dod:** El sistema emite notificacion o un field visual cambia.
**Puntos:** 3 | **Prioridad:** Alta

### HU-20 y HU-21: CRUD contactos y Reportes
**Frontend/Backend:** Formularios nativos tipicos (REST).
**Puntos:** 3 y 5
