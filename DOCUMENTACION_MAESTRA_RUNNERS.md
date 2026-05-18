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
