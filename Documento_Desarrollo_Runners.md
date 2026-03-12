# RUNNERS – PLATAFORMA MÓVIL DE SERVICIOS, DOMICILIOS Y TIENDA LOCAL

**Trabajo académico presentado como parte del desarrollo de un proyecto de software**

**Presentado por:**  
Equipo de Desarrollo – Runners

**Institución:** Universidad del Valle  
**Fecha:** 2025

---

## Tabla de Contenido

1. [Runners](#1-runners)
2. [Planteamiento del problema](#2-planteamiento-del-problema)
3. [Justificación](#3-justificación)
4. [Objetivo general](#4-objetivo-general)
   - 4.1. Objetivos específicos
5. [Antecedentes](#5-antecedentes)
6. [Marco legal](#6-marco-legal)
7. [Marco teórico](#7-marco-teórico)
8. [Requerimientos funcionales y no funcionales](#8-requerimientos-funcionales-y-no-funcionales)
   - 8.1. Introducción
   - 8.2. Requisitos Funcionales a Nivel del Sistema
   - 8.3–8.15. Requisitos por módulo
   - 8.16. Requerimientos no funcionales
9. [Cualidades del Sistema](#9-cualidades-del-sistema)
10. [Interfaces del Sistema](#10-interfaces-del-sistema)
11. [Reglas de Negocio](#11-reglas-de-negocio)
12. [Restricciones del Sistema](#12-restricciones-del-sistema)
13. [Documentación del Sistema](#13-documentación-del-sistema)
14. [Marco metodológico](#14-marco-metodológico)
15. [Casos de uso (detallados)](#15-casos-de-uso-detallados)
16. [Estructura de carpetas](#16-estructura-de-carpetas)
17. [Plan de Gestión de Riesgos](#17-plan-de-gestión-de-riesgos)
18. [Tareas de Gestión de Riesgos](#18-tareas-de-gestión-de-riesgos)
19. [Organización y Responsabilidades](#19-organización-y-responsabilidades)
20. [Presupuesto](#20-presupuesto)
21. [Herramientas y Técnicas](#21-herramientas-y-técnicas)
22. [Elementos de Riesgo Por Gestionar](#22-elementos-de-riesgo-por-gestionar)
23. [Diagrama de paquetes](#23-diagrama-de-paquetes)
24. [Cronograma](#24-cronograma)
25. [Resultados Esperados](#25-resultados-esperados)
26. [Recomendaciones y Sugerencias a Futuro](#26-recomendaciones-y-sugerencias-a-futuro)
27. [Conclusiones](#27-conclusiones)
28. [Bibliografía](#28-bibliografía)

---

## 1. Runners

**Plataforma Móvil Integral para la Gestión de Servicios Locales, Domicilios y Tienda Comunitaria**

Runners es una aplicación móvil desarrollada en Flutter que conecta a usuarios de una comunidad con tres servicios clave: una **tienda local** (comercios y productos), un módulo de **domicilios** (envíos con asignación automática de repartidores) y un directorio de **servicios profesionales** (prestadores de servicios del hogar, técnicos, profesionales independientes). Además, cuenta con un **directorio de contactos** de emergencia y utilidad, así como un panel de **administración** para la gestión global de la plataforma.

---

## 2. Planteamiento del problema

Las comunidades locales enfrentan dificultades para:

- Conectar a sus habitantes con comercios, productos y servicios locales de forma digitalizada.
- Gestionar y asignar repartidores de forma eficiente y transparente para servicios de domicilio.
- Centralizar en un único canal la oferta de prestadores de servicios profesionales del hogar y de otro tipo.
- Mantener un directorio de contactos de emergencia y utilidad actualizado y accesible.
- Ofrecer a los administradores visibilidad sobre las operaciones financieras, de servicio y de reparto.

Los prestadores de servicios independientes, tenderos y repartidores carecen de una herramienta unificada que les permita gestionar su oferta, disponibilidad y relación con clientes. Del mismo modo, los clientes no tienen acceso a un canal único, confiable y moderno que integre compra en tienda, solicitud de domicilios y contratación de servicios.

Sin una solución unificada, la experiencia del usuario se fragmenta: se depende de llamadas telefónicas, grupos de mensajería informal y procesos manuales que generan errores, retrasos e informalidad en las transacciones locales.

---

## 3. Justificación

Este proyecto busca dar solución a la necesidad de digitalizar la economía local a través de una plataforma móvil que integre múltiples módulos de servicio en una sola experiencia. Con ello, se busca:

- **Mejorar la experiencia del cliente**, brindando acceso rápido a tiendas, servicios y domicilios desde un solo lugar.
- **Incrementar la competitividad** de los prestadores y comercios locales frente a plataformas informales.
- **Optimizar los procesos de asignación** de domicilios mediante un sistema automático basado en disponibilidad.
- **Formalizar la oferta de servicios profesionales**, validando a los prestadores antes de aparecer en el directorio.
- **Centralizar la información operativa** en un panel administrativo con reportes en tiempo real.
- **Reducir errores humanos** al automatizar flujos de solicitud, aprobación y seguimiento.
- **Fomentar la confianza** entre usuarios mediante perfiles verificados, estados de solicitud y seguimiento transparente.
- **Escalar y extender** la plataforma fácilmente gracias a una arquitectura Clean Architecture con separación clara de responsabilidades.

---

## 4. Objetivo general

Desarrollar una aplicación móvil integral para comunidades locales que proporcione una experiencia interactiva, moderna y eficiente, permitiendo a los usuarios acceder a servicios de tienda, domicilios y prestadores profesionales desde una única plataforma, con un sistema de autenticación seguro basado en roles, gestión de estado en tiempo real y panel administrativo completo.

El sistema deberá incorporar autenticación JWT con roles diferenciados (CLIENTE, PRESTADOR, DOMICILIARIO, ADMIN), un módulo de tienda con carrito de compras Hive, un módulo de domicilios con asignación automática de repartidores, un módulo de servicios con validación y aprobación de prestadores, un directorio de contactos de utilidad pública y un dashboard de administración con reportes.

Desde el punto de vista técnico, se plantea una arquitectura cliente-servidor basada en un backend desarrollado en Django REST Framework (DRF) con autenticación JWT y un frontend implementado en Flutter con Clean Architecture, Riverpod para gestión de estado, GoRouter para navegación y Dio con interceptores para comunicación HTTP asíncrona.

### 4.1. Objetivos específicos

- Diseñar y desarrollar un backend robusto utilizando Django y DRF que gestione de manera eficiente los módulos de usuarios, tienda, domicilios, servicios, contactos y reportes.
- Implementar un frontend móvil moderno e interactivo en Flutter que consuma los endpoints del backend mediante llamadas HTTP asíncronas con interceptores JWT.
- Desarrollar un sistema de autenticación y gestión de usuarios basado en tokens JWT con soporte para roles múltiples y refresco automático de tokens.
- Diseñar e implementar un modelo de base de datos relacional en Django optimizado para representar correctamente las entidades y relaciones del dominio de servicios locales.
- Implementar un sistema de asignación automática de domiciliarios disponibles a solicitudes de domicilio entrantes.
- Desarrollar un flujo completo de compra en tienda, donde el usuario pueda agregar productos al carrito (Hive), confirmar la orden y hacer seguimiento de su estado.
- Implementar un sistema de validación y aprobación de prestadores de servicios, donde el administrador pueda aprobar o rechazar solicitudes de incorporación.
- Desarrollar un panel de administración con dashboard, reportes de domicilios, servicios y tienda, y gestión global de usuarios.
- Aplicar una metodología de desarrollo ágil con historias de usuario, sprints planificados y control de versiones en GitHub.
- Realizar pruebas integrales del sistema tanto en el backend (API con Postman) como en el frontend (flujo completo de usuario).
- Definir una estrategia tecnológica sólida para el despliegue, incluyendo configuración de entorno de producción, base de datos PostgreSQL y variables de entorno.
- Documentar exhaustivamente todo el proceso de desarrollo, incluyendo arquitectura, modelo relacional, diagramas de casos de uso, diseño de interfaces y guías de instalación.

---

## 5. Antecedentes

Plataformas de servicios locales y domicilios (Rappi, Domicilios.com, TaskRabbit, aplicaciones propias de municipios) muestran que:

- La digitalización de servicios locales reduce la intermediación y mejora la transparencia en los precios.
- Los sistemas de asignación automática de repartidores (basados en disponibilidad) reducen tiempos de espera y mejoran la satisfacción del cliente.
- Los directorios de prestadores de servicios verificados generan mayor confianza y uso recurrente de la plataforma.
- Las arquitecturas mobiles nativas o híbridas (Flutter, React Native) son ampliamente adoptadas para proyectos con múltiples módulos y roles de usuario.
- Tech stacks como Django/DRF y Flutter son reconocidos por su productividad, escalabilidad y comunidad activa; JWT es el estándar para autenticación sin estado en APIs REST.
- El patrón Clean Architecture en Flutter permite un mantenimiento ágil, pruebas unitarias efectivas y separación clara de responsabilidades (dominio, datos, presentación).

Estos antecedentes justifican la elección tecnológica y el diseño modular propuesto para Runners.

---

## 6. Marco legal

Consideraciones principales aplicadas al proyecto:

- **Protección de datos personales:** Se respetan principios de minimización, finalidad y consentimiento. Los datos de usuarios (nombre, correo, teléfono, rol) se almacenan únicamente para fines operativos de la plataforma. Se debe adaptar la implementación a la legislación local (Ley 1581 de 2012 en Colombia – Habeas Data).
- **Políticas y Términos:** La plataforma debe contar con textos legales de uso del servicio y política de privacidad antes de su despliegue público.
- **Derechos de autor:** Se utilizan imágenes propias o con licencia libre para comercios, productos y prestadores. Los documentos adjuntos de prestadores (hoja de vida, foto) son responsabilidad del prestador.
- **Seguridad:** Las contraseñas se almacenan con hash (Django), los tokens JWT se gestionan en almacenamiento seguro (FlutterSecureStorage), y no se almacenan datos bancarios en la plataforma.
- **Nota:** El módulo de pagos es simulado en la fase actual. Cualquier integración real de pagos requiere evaluación legal y técnica adicional conforme a la normativa de pagos electrónicos.

---

## 7. Marco teórico

- **Arquitectura cliente/servidor:** el frontend Flutter consume el backend RESTful Django/DRF.
- **REST & JSON:** diseño de endpoints con recursos y verbos HTTP estándar (GET, POST, PUT, PATCH, DELETE).
- **JWT (JSON Web Tokens):** flujo access/refresh para autenticación stateless; el cliente envía `Authorization: Bearer <token>` en cada petición protegida; el interceptor Dio renueva el token automáticamente ante respuestas 401.
- **Clean Architecture (Flutter):** separación en capas — `domain` (entidades, casos de uso, repositorios abstractos), `data` (repositorios concretos, datasources, modelos), `presentation` (Riverpod providers, pantallas, widgets).
- **Riverpod:** gestión de estado reactiva para Flutter; los `StateNotifierProvider` y `FutureProvider` orquestan el estado de autenticación, carrito, solicitudes y paneles.
- **GoRouter:** enrutamiento declarativo con guardias de rol; redirige automáticamente según el rol del usuario autenticado.
- **Hive:** base de datos NoSQL local en Flutter para persistencia offline del carrito de compras.
- **Modelo relacional:** uso de tablas normalizadas, relaciones 1:N y N:M con tablas intermedias en Django ORM.
- **MVC en Django:** modelos (ORM), vistas (ViewSets DRF), serializadores (capa de transformación), URLs (enrutamiento).
- **UX centrado en el usuario:** interfaces simples con feedback visual (loading states, empty states, error messages), navegación por roles y accesos directos contextuales.

---

## 8. Requerimientos funcionales y no funcionales

### 8.1 Introducción

En esta sección se describe el desarrollo del sistema Runners, una plataforma móvil diseñada para conectar a usuarios de una comunidad con servicios de tienda, domicilios y profesionales independientes. El sistema gestiona cuatro tipos de usuarios (CLIENTE, PRESTADOR, DOMICILIARIO, ADMIN) con flujos diferenciados por rol, un backend API REST en Django y un frontend Flutter con arquitectura limpia.

El sistema facilita la gestión interna de la plataforma mediante la automatización de la asignación de domiciliarios, la aprobación de prestadores y la generación de reportes operativos. En este documento se especifican los requisitos funcionales, no funcionales, las restricciones, las reglas de negocio y los diagramas del sistema.

### 8.2 Requisitos Funcionales a Nivel del Sistema

| ID | Módulo | Requisito |
|---|---|---|
| REQ-01 | Autenticación | Registro de usuario con nombre, correo, contraseña y rol |
| REQ-02 | Autenticación | Inicio de sesión con JWT (access + refresh token) |
| REQ-03 | Tienda | Listado de comercios y productos por categoría |
| REQ-04 | Tienda | Carrito de compras persistido localmente (Hive) |
| REQ-05 | Tienda | Creación y seguimiento de órdenes de compra |
| REQ-06 | Domicilios | Solicitud de domicilio con dirección origen y destino |
| REQ-07 | Domicilios | Asignación automática de domiciliario disponible |
| REQ-08 | Domicilios | Seguimiento del estado del domicilio |
| REQ-09 | Servicios | Registro de prestadores con perfil, foto y hoja de vida |
| REQ-10 | Servicios | Aprobación/rechazo de prestadores por el administrador |
| REQ-11 | Servicios | Solicitud de servicio por parte del cliente |
| REQ-12 | Contactos | Directorio de contactos de emergencia y utilidad |
| REQ-13 | Admin | Dashboard con métricas de operación |
| REQ-14 | Admin | Reportes de domicilios, servicios y tienda |
| REQ-15 | Admin | Gestión de usuarios, comercios y configuración |

### 8.3 Registro de usuario (REQ-01)

El sistema permitirá a un nuevo usuario registrarse proporcionando nombre, apellido, correo electrónico, contraseña y rol deseado (CLIENTE por defecto). El sistema validará que el correo no esté previamente registrado y devolverá un mensaje de error si ya existe.

### 8.4 Inicio de sesión con credenciales únicas (REQ-02)

El sistema permitirá iniciar sesión con correo y contraseña, retornando un par de tokens JWT (access y refresh). El token de acceso tiene vigencia corta; el interceptor Dio renovará automáticamente el token usando el refresh token antes de que expire.

### 8.5 Visualización de tienda (REQ-03)

El cliente podrá visualizar los comercios activos, filtrar por categoría, ver los productos de cada comercio con nombre, descripción, precio e imagen, y agregar productos al carrito.

### 8.6 Carrito y orden de compra (REQ-04 / REQ-05)

El cliente podrá agregar productos al carrito (persistido en Hive), modificar cantidades, eliminar ítems y confirmar la compra. Al confirmar, se crea una Orden en el backend con estado `PENDIENTE` y los ítems correspondientes.

### 8.7 Solicitud de domicilio (REQ-06 / REQ-07)

El cliente podrá crear una solicitud de domicilio indicando dirección de recogida, dirección de entrega y descripción. El sistema asignará automáticamente el domiciliario con estado `DISPONIBLE` de menor número asignado. Si no hay domiciliarios disponibles, la solicitud queda en espera.

### 8.8 Seguimiento de domicilio (REQ-08)

El cliente y el domiciliario podrán consultar el estado de la solicitud (`PENDIENTE`, `ACEPTADO`, `EN_CAMINO`, `ENTREGADO`, `CANCELADO`) y actualizarlo según su rol.

### 8.9 Perfil de prestador de servicios (REQ-09)

Un usuario con rol PRESTADOR podrá completar su perfil adjuntando foto, descripción, categoría de servicio y hoja de vida. El perfil iniciará con estado de aprobación `PENDIENTE` hasta que el administrador lo revise.

### 8.10 Aprobación de prestadores (REQ-10)

El administrador podrá visualizar todos los prestadores con estado `PENDIENTE`, revisar su perfil y documentos, y aprobar o rechazar la incorporación con un motivo de rechazo si aplica.

### 8.11 Solicitud de servicio (REQ-11)

El cliente podrá solicitar un servicio a un prestador aprobado, indicando descripción, fecha programada y categoría. El prestador recibirá la solicitud con estado `PENDIENTE` y podrá aprobarla o rechazarla.

### 8.12 Directorio de contactos (REQ-12)

Todos los usuarios podrán consultar el directorio de contactos de emergencia, profesionales, comercios y otros. El administrador podrá crear, editar y desactivar contactos. Los contactos tienen nombre, teléfono, descripción y tipo.

### 8.13 Dashboard administrativo (REQ-13)

El administrador tendrá acceso a un panel con métricas clave: total de usuarios por rol, órdenes activas, solicitudes de domicilio del día, servicios en curso, y acceso rápido a módulos de gestión.

### 8.14 Reportes (REQ-14)

El sistema generará reportes de: domicilios realizados (por período, domiciliario, estado), servicios prestados (por categoría, prestador, estado), y ventas de tienda (por comercio, producto, período).

### 8.15 Gestión administrativa (REQ-15)

El administrador podrá gestionar usuarios (activar/desactivar, cambiar roles), comercios (activar/desactivar, asignar categoría), configuración del sistema (SystemConfig: parámetros clave-valor) y registros financieros de domiciliarios.

### 8.16 Requerimientos no funcionales

| ID | Categoría | Descripción |
|---|---|---|
| RNF-01 | Seguridad | Contraseñas con hash bcrypt (Django), JWT para sesiones, FlutterSecureStorage para tokens en cliente |
| RNF-02 | Rendimiento | Endpoints principales con latencia objetivo < 500ms; paginación en listados extensos |
| RNF-03 | Escalabilidad | Arquitectura Clean separada frontend/backend; compatible con contenedores Docker |
| RNF-04 | Mantenibilidad | Código modular (apps Django por dominio; features Flutter por módulo) con Clean Architecture |
| RNF-05 | Observabilidad | Logs en backend, manejo de errores estructurado en frontend (AppError), estados de carga |
| RNF-06 | Compatibilidad | Aplicación móvil Android/iOS; backend compatible con PostgreSQL en producción |
| RNF-07 | Disponibilidad | El backend debe estar disponible 24/7 en producción; soporte para reinicio automático (gunicorn/supervisor) |

---

## 9. Cualidades del Sistema

El sistema Runners se caracteriza por las siguientes cualidades:

### 9.1 Usabilidad y Accesibilidad

La interfaz Flutter presenta un diseño moderno, intuitivo y coherente. Los usuarios pueden acceder rápidamente a las funciones principales sin requerir conocimientos técnicos. Se aplican las siguientes buenas prácticas:

- **Navegación por roles:** GoRouter detecta el rol del usuario autenticado y presenta el menú y las rutas correspondientes, evitando confusión entre módulos.
- **Estados visuales:** Cada pantalla gestiona estados de carga (`AppLoading`), error (`AppError`) y vacío (`AppEmptyState`), evitando pantallas en blanco.
- **Widgets compartidos:** `AppButton`, `AppTextField`, `AppCard` garantizan consistencia visual en toda la aplicación.
- **Formularios accesibles:** campos con etiquetas claras, validación en tiempo real y mensajes de error descriptivos.
- **Controles nativos:** uso de `TextField`, `DropdownButton`, `ListView` y `FloatingActionButton` nativos de Flutter para máxima compatibilidad con lectores de pantalla.

### 9.2 Confiabilidad

El sistema maneja errores de red con reintentos automáticos (interceptor Dio), presenta mensajes de error claros al usuario y no pierde el estado del carrito ante desconexiones (persistencia Hive). Los tokens JWT se renuevan automáticamente, garantizando sesiones continuas sin interrupciones al usuario.

### 9.3 Rendimiento

- Backend: consultas ORM optimizadas con `select_related` y `prefetch_related`; paginación en listados de productos, servicios y domicilios.
- Frontend: carga lazy de imágenes, `CachedNetworkImage` para evitar re-descargas, paginación en listas extensas.
- Hive: persistencia local de carrito sin latencia de red.

### 9.4 Soportabilidad

El código está documentado y estructurado siguiendo Clean Architecture, lo que facilita la corrección de errores, actualización de módulos y mantenimiento continuo. Cada feature Flutter es independiente; cada app Django tiene su propio modelo, serializer, vista y URL. La arquitectura permite agregar nuevos módulos sin modificar los existentes.

---

## 10. Interfaces del Sistema

### 10.1 Interfaces de Usuario

#### 10.1.1 Aspecto y Sensación

La interfaz tiene un diseño moderno, visualmente atractivo y coherente. Se aplica un tema consistente con paleta de colores definida en `core/theme/`, tipografía unificada y componentes reutilizables. Los íconos de Material Design representan las funciones clave (tienda, domicilio, servicios, contactos, perfil).

#### 10.1.2 Requisitos de Diseño y Navegación

La navegación principal se realiza mediante un `BottomNavigationBar` o `NavigationDrawer` con accesos directos a los módulos según el rol del usuario. La pantalla de Splash gestiona la redirección inicial basada en el token almacenado. El flujo de autenticación (Login → Register) es independiente de los módulos funcionales.

#### 10.1.3 Consistencia

El esquema de colores, tipografía y estilo de botones se mantiene uniforme en toda la aplicación mediante el sistema de temas de Flutter (`ThemeData`) centralizado en `core/theme/app_theme.dart`. Los `AppButton` y `AppTextField` garantizan apariencia homogénea.

#### 10.1.4 Personalización por Rol

Cada rol ve un conjunto diferente de pantallas y acciones:
- **CLIENTE:** tienda, carrito, órdenes, domicilios, servicios (solicitar), contactos, perfil.
- **PRESTADOR:** perfil de prestador, mis solicitudes de servicio, gestión de disponibilidad.
- **DOMICILIARIO:** solicitudes de domicilio asignadas, cambio de estado, historial financiero.
- **ADMIN:** dashboard, gestión de usuarios, aprobación de prestadores, reportes, contactos, configuración.

### 10.2 Interfaces con Sistemas Externos

#### 10.2.1 Interfaces de Software

El sistema sigue una arquitectura cliente-servidor donde el frontend Flutter y el backend Django se comunican mediante API RESTful. El frontend está desarrollado en Flutter/Dart (SDK 3.9+); el backend en Python 3.12 con Django 5.2.6 y DRF 3.16.1.

#### 10.2.2 Interfaces de Hardware

No requiere hardware especializado. Compatible con cualquier dispositivo Android (5.0+) o iOS (12+) con conexión a internet. El backend puede ejecutarse en cualquier servidor Linux/Windows con Python 3.12+.

#### 10.2.3 Interfaces de Comunicaciones

Se utiliza HTTPS para garantizar la seguridad en las comunicaciones. El cliente Flutter se comunica con el backend mediante llamadas HTTP REST. Los tokens JWT viajan en el encabezado `Authorization: Bearer <token>`. En desarrollo se usa HTTP sobre `localhost:8000`; en producción se requiere HTTPS con certificado válido.

---

## 11. Reglas de Negocio

Las reglas de negocio definen y limitan el comportamiento del sistema Runners, asegurando que las operaciones se realicen de forma correcta, consistente y segura.

### 11.1 Clase de Reglas: Usuarios y Autenticación

#### 11.1.1 RN-01 – Roles Exclusivos
**Descripción:** Si un usuario se registra con rol CLIENTE, entonces no podrá acceder a las funciones de DOMICILIARIO, PRESTADOR ni ADMIN. El acceso a rutas se controla mediante GoRouter con guardias de rol en el frontend y permisos basados en rol en el backend.

#### 11.1.2 RN-02 – Validación de Registro
**Descripción:** Si el usuario ingresa un correo electrónico ya registrado, entonces el sistema notificará el conflicto e impedirá la creación de una cuenta duplicada. El campo `email` es `unique=True` en el modelo `User`.

#### 11.1.3 RN-03 – Inicio de Sesión Seguro
**Descripción:** Si el usuario inicia sesión, entonces el sistema validará correo y contraseña con hash bcrypt, retornando tokens JWT únicamente en caso de coincidencia. El token de acceso expira en 5 minutos; el refresh en 1 día.

### 11.2 Clase de Reglas: Tienda y Carrito

#### 11.2.1 RN-04 – Validación del Carrito
**Descripción:** Si el carrito no contiene productos válidos (mínimo un ítem con cantidad > 0), entonces el sistema no permitirá confirmar la compra y mostrará un mensaje de carrito vacío.

#### 11.2.2 RN-05 – Disponibilidad de Productos
**Descripción:** Si un producto tiene `is_available = False`, entonces no aparecerá en el listado de la tienda y no podrá ser agregado al carrito.

#### 11.2.3 RN-06 – Generación de Orden
**Descripción:** Si el cliente confirma el carrito, entonces el sistema creará una Orden con estado `PENDIENTE` y registrará los OrderItems con precio unitario al momento de la compra (precio histórico).

### 11.3 Clase de Reglas: Domicilios

#### 11.3.1 RN-07 – Asignación Automática
**Descripción:** Si se crea una solicitud de domicilio, entonces el sistema asignará automáticamente el domiciliario con estado `DISPONIBLE` y el menor `assigned_number`. Si no hay disponibles, la solicitud queda con `deliverer = null` en estado `PENDIENTE`.

#### 11.3.2 RN-08 – Cambio de Estado de Domicilio
**Descripción:** Si el domiciliario actualiza el estado a `ENTREGADO`, entonces el sistema registrará la fecha de entrega (`completed_at`), liberará al domiciliario (estado `DISPONIBLE`) y generará un registro financiero automático.

#### 11.3.3 RN-09 – Registro Financiero
**Descripción:** Si un domicilio se completa, entonces el sistema calculará la comisión de Runners (`runners_commission = delivery_fee * commission_rate`) y registrará el ingreso neto del domiciliario en `FinancialRecord`.

### 11.4 Clase de Reglas: Servicios

#### 11.4.1 RN-10 – Validación de Prestador
**Descripción:** Si un prestador no ha sido aprobado por el administrador (`approval_status != 'APROBADO'`), entonces no aparecerá en el directorio de servicios disponibles para el cliente.

#### 11.4.2 RN-11 – Solicitud Única por Servicio
**Descripción:** Si un cliente tiene una solicitud de servicio en estado `PENDIENTE` o `APROBADO` con el mismo prestador, entonces el sistema impedirá crear una solicitud duplicada.

#### 11.4.3 RN-12 – Cálculo de Tarifas de Servicio
**Descripción:** Si se crea una solicitud de servicio, entonces el `client_total = provider_fee + runners_fee`, donde `runners_fee` es calculado según la configuración del sistema (`SystemConfig`).

### 11.5 Clase de Reglas: Contactos

#### 11.5.1 RN-13 – Visibilidad de Contactos
**Descripción:** Solo los contactos con `is_active = True` serán visibles en el directorio público. Los contactos inactivos solo son visibles para el administrador.

#### 11.5.2 RN-14 – Gestión Exclusiva de Contactos
**Descripción:** Solo los usuarios con rol ADMIN podrán crear, editar o desactivar contactos. Los demás roles tienen acceso de solo lectura al directorio.

---

## 12. Restricciones del Sistema

### 12.1 Lenguaje de Implementación

El sistema será desarrollado bajo una arquitectura cliente-servidor con separación estricta de responsabilidades.

- **Backend:** Django (Python 3.12), aprovechando su ORM robusto, sistema de migraciones y ecosistema DRF para APIs REST.
- **Frontend:** Flutter (Dart 3.9+), con Clean Architecture para separación de capas y Riverpod para gestión de estado reactiva.

### 12.2 Base de Datos

El sistema utilizará el ORM de Django para la gestión de datos, facilitando operaciones CRUD y migraciones controladas.

- **Desarrollo:** SQLite (integrado en Django, sin configuración adicional).
- **Producción:** PostgreSQL, por su estabilidad, escalabilidad y soporte para consultas complejas. El driver `psycopg2-binary` está incluido en `requirements.txt`.

### 12.3 Herramientas de Desarrollo

**Lenguajes y runtimes:**
- Python 3.12 (backend)
- Dart 3.9+ / Flutter 3.9+ (frontend)

**Backend (Django + DRF):**
- Django 5.2.6
- Django REST Framework 3.16.1
- djangorestframework-simplejwt 5.5.1 (JWT)
- django-cors-headers 4.8.0 (CORS)
- Pillow 11.3.0 (soporte ImageField)
- psycopg2-binary 2.9.10 (PostgreSQL en producción)
- python-dotenv 1.1.1 (variables de entorno)

**Frontend (Flutter + Dart):**
- flutter_riverpod 2.x (gestión de estado)
- go_router 13.x (navegación declarativa)
- dio 5.x (cliente HTTP con interceptores)
- hive / hive_flutter 2.x (persistencia local del carrito)
- flutter_secure_storage 9.x (almacenamiento seguro de tokens)
- cached_network_image 3.x (carga optimizada de imágenes)
- image_picker (selección de imágenes en formularios)

**Control de versiones:**
- Git + GitHub
- Remoto: `https://github.com/Karatsuyu/Runners.git`
- Rama principal: `main`

**Herramientas adicionales:**
- Postman (colección `runners_api_postman.json` con 30+ endpoints)
- VS Code con extensiones Flutter y Python
- Django Admin para gestión directa de datos

### 12.4 Límites de Recursos

El sistema debe estar optimizado para funcionar en dispositivos con mínimo 2 GB de RAM (móvil). El servidor backend requiere mínimo 1 GB de RAM y procesador de 1 núcleo para entornos de desarrollo. Se recomienda 2 GB de RAM y 2 núcleos para producción con carga moderada.

---

## 13. Documentación del Sistema

### 13.1 Sistema de Ayuda en Línea y Soporte

La aplicación incluye mensajes contextuales en cada pantalla, indicadores de estado (cargando, error, vacío) y tooltips en botones de acción. Los errores del API se presentan al usuario en lenguaje natural (no en formato técnico).

### 13.2 Documentación Técnica

El equipo de desarrollo elaborará documentación técnica dirigida a futuros desarrolladores:

- Estructura de la base de datos (diagrama ER en Mermaid).
- Diagrama de arquitectura del sistema.
- Descripción de todos los endpoints de la API (colección Postman).
- Requisitos de instalación y despliegue (README.md, QUICKSTART.md).
- Guía de implementación web y Flutter.
- CONTRIBUTING.md con normas para contribuir al proyecto.
- Pull Request template en español.

### 13.3 Responsabilidad

El equipo de desarrollo será responsable de la creación y mantenimiento de toda la documentación. Se realizarán actualizaciones con cada nueva versión o cambio significativo en la arquitectura.

---

## 14. Marco metodológico

### 14.1 Metodología de proyecto

Se aplica una metodología ágil (Scrum/Kanban) para el desarrollo:

- Sprints cortos de 1 a 2 semanas.
- Historias de usuario organizadas por módulo.
- Iteraciones con entregables funcionales en cada ciclo.
- Control de versiones con commits semánticos (`feat:`, `fix:`, `docs:`, `chore:`).

### 14.2 Informe de técnica de elicitación

La elicitación de requisitos se basó en:

- **Análisis de dominio:** observación de sistemas similares (Rappi, Domicilios.com, TaskRabbit, apps municipales).
- **Identificación de módulos diferenciadores:** asignación automática de domiciliarios, aprobación de prestadores, directorio de contactos de emergencia.
- **Análisis de roles:** identificación de cuatro perfiles de usuario con necesidades distintas (CLIENTE, PRESTADOR, DOMICILIARIO, ADMIN).
- **Revisión de arquitectura:** adopción de Clean Architecture y Riverpod para garantizar mantenibilidad y escalabilidad.

### 14.3 Historias de usuario

#### MÓDULO 1: Autenticación y Usuarios

**HU-01 – Registro de usuario**  
*Como* usuario nuevo, *quiero* registrarme en el sistema con mi nombre, apellido, correo y contraseña, *para* crear una cuenta y acceder a las funciones según mi rol.

**HU-02 – Inicio de sesión**  
*Como* usuario registrado, *quiero* iniciar sesión con mi correo y contraseña, *para* acceder a mi perfil y a las funciones disponibles según mi rol.

**HU-03 – Cierre de sesión**  
*Como* usuario autenticado, *quiero* cerrar sesión de forma segura, *para* que mis tokens no queden activos en el dispositivo.

#### MÓDULO 2: Tienda

**HU-04 – Ver comercios y productos**  
*Como* cliente, *quiero* ver los comercios disponibles y sus productos con precio, descripción e imagen, *para* elegir qué comprar.

**HU-05 – Agregar al carrito**  
*Como* cliente, *quiero* agregar productos al carrito y modificar cantidades, *para* preparar mi compra antes de confirmarla.

**HU-06 – Confirmar orden**  
*Como* cliente, *quiero* confirmar mi carrito y crear una orden, *para* que el comercio reciba mi pedido y pueda procesarlo.

**HU-07 – Ver historial de órdenes**  
*Como* cliente, *quiero* ver el historial de mis órdenes con sus estados, *para* hacer seguimiento de mis compras.

#### MÓDULO 3: Domicilios

**HU-08 – Solicitar domicilio**  
*Como* cliente, *quiero* crear una solicitud de domicilio indicando dirección de recogida y entrega, *para* que me envíen lo que necesito.

**HU-09 – Ver estado del domicilio**  
*Como* cliente, *quiero* consultar el estado de mi solicitud de domicilio en tiempo real, *para* saber cuándo llega mi entrega.

**HU-10 – Gestionar solicitudes asignadas**  
*Como* domiciliario, *quiero* ver las solicitudes que me han asignado y actualizar su estado, *para* gestionar mis entregas de forma organizada.

**HU-11 – Ver historial financiero**  
*Como* domiciliario, *quiero* ver mis ingresos y la comisión de Runners por cada domicilio completado, *para* llevar control de mis ganancias.

#### MÓDULO 4: Servicios

**HU-12 – Ver prestadores de servicios**  
*Como* cliente, *quiero* ver el directorio de prestadores aprobados con su perfil, categoría y descripción, *para* contactar al más adecuado para mi necesidad.

**HU-13 – Solicitar servicio**  
*Como* cliente, *quiero* enviar una solicitud de servicio a un prestador específico con fecha y descripción, *para* que el prestador pueda aceptarla o rechazarla.

**HU-14 – Gestionar perfil de prestador**  
*Como* prestador, *quiero* completar mi perfil con foto, descripción, categoría y hoja de vida, *para* que el administrador pueda revisar y aprobar mi incorporación a la plataforma.

**HU-15 – Gestionar solicitudes de servicio**  
*Como* prestador, *quiero* ver las solicitudes que me envían los clientes y aprobarlas o rechazarlas, *para* gestionar mi agenda de trabajo.

#### MÓDULO 5: Contactos

**HU-16 – Ver directorio de contactos**  
*Como* usuario, *quiero* ver el directorio de contactos de emergencia, profesionales y comercios, *para* encontrar rápidamente un contacto de utilidad.

**HU-17 – Filtrar contactos**  
*Como* usuario, *quiero* filtrar el directorio por tipo de contacto (EMERGENCIA, PROFESIONAL, COMERCIO, OTRO), *para* encontrar más rápido lo que busco.

#### MÓDULO 6: Administración

**HU-18 – Ver dashboard**  
*Como* administrador, *quiero* ver un panel con métricas de la plataforma (usuarios, órdenes, domicilios, servicios activos), *para* monitorear el estado del sistema.

**HU-19 – Aprobar/rechazar prestadores**  
*Como* administrador, *quiero* revisar los perfiles de prestadores pendientes y aprobarlos o rechazarlos con justificación, *para* mantener la calidad de los servicios ofrecidos.

**HU-20 – Gestionar contactos**  
*Como* administrador, *quiero* crear, editar y desactivar contactos del directorio, *para* mantener la información de utilidad pública actualizada.

**HU-21 – Ver reportes**  
*Como* administrador, *quiero* consultar reportes de domicilios, servicios y tienda por período, *para* tomar decisiones operativas basadas en datos.

### 14.4 Diseño del Sistema

#### 14.4.1 Diagrama de Arquitectura

```mermaid
graph TB
    subgraph "Frontend – Flutter"
        A[Presentation Layer\nRiverpod Providers\nGoRouter\nScreens & Widgets]
        B[Domain Layer\nEntities\nUse Cases\nRepository Interfaces]
        C[Data Layer\nRepository Impl\nDio Datasources\nHive Storage]
    end

    subgraph "Backend – Django DRF"
        D[URLs / Router]
        E[ViewSets / APIViews]
        F[Serializers]
        G[Models / ORM]
        H[JWT Auth\nSimpleJWT]
        I[SQLite / PostgreSQL]
    end

    A --> B
    B --> C
    C -->|HTTP REST\nJWT Bearer| D
    D --> E
    E --> F
    F --> G
    G --> I
    H --> E
```

#### 14.4.2 Diagrama de Flujo – Autenticación

```mermaid
flowchart TD
    A([Inicio]) --> B[Abrir App]
    B --> C{¿Token válido\nen SecureStorage?}
    C -->|No| D[Pantalla Login]
    C -->|Sí| E{Verificar rol\nusuario}
    D --> F[Ingresar correo\ny contraseña]
    F --> G[POST /api/auth/login/]
    G --> H{¿Credenciales\nválidas?}
    H -->|No| I[Mostrar error]
    I --> D
    H -->|Sí| J[Guardar access\n+ refresh token]
    J --> E
    E -->|CLIENTE| K[Home Tienda]
    E -->|DOMICILIARIO| L[Panel Domicilios]
    E -->|PRESTADOR| M[Panel Servicios]
    E -->|ADMIN| N[Dashboard Admin]
```

#### 14.4.3 Diagrama de Flujo – Solicitud de Domicilio

```mermaid
flowchart TD
    A([Cliente]) --> B[Crear solicitud\nde domicilio]
    B --> C[POST /api/deliveries/requests/]
    C --> D{¿Hay domiciliario\nDISPONIBLE?}
    D -->|Sí| E[Asignar domiciliario\nde menor número]
    D -->|No| F[Solicitud PENDIENTE\nsin domiciliario]
    E --> G[Estado: ACEPTADO]
    G --> H[Domiciliario\nen camino]
    H --> I[PATCH estado\nEN_CAMINO]
    I --> J[PATCH estado\nENTREGADO]
    J --> K[Registrar\ncompleted_at]
    K --> L[Generar\nFinancialRecord]
    L --> M[Liberar domiciliario\nDISPONIBLE]
    M --> N([Fin])
    F --> O{¿Domiciliario\ndisponible?}
    O -->|Sí| E
```

#### 14.4.4 Diagrama de Flujo – Aprobación de Prestador

```mermaid
flowchart TD
    A([Prestador]) --> B[Completar perfil\nfoto + HV + categoría]
    B --> C[POST /api/services/providers/]
    C --> D[Estado: PENDIENTE]
    D --> E[Admin revisa\nperfil]
    E --> F{¿Decisión?}
    F -->|Aprobar| G[PATCH approval_status\n= APROBADO]
    F -->|Rechazar| H[PATCH approval_status\n= RECHAZADO\n+ motivo]
    G --> I[Prestador visible\nen directorio]
    H --> J[Notificar rechazo\ncon motivo]
    I --> K([Cliente puede\nsolicitar servicio])
```

#### 14.4.5 Diseño Relacional

```mermaid
erDiagram
    User {
        int id PK
        string email UK
        string password
        string first_name
        string last_name
        string role
        bool is_active
        datetime date_joined
    }

    StoreCategory {
        int id PK
        string name
        string description
    }

    Commerce {
        int id PK
        string name
        string description
        string city
        string address
        string phone
        string logo
        int category_id FK
        int owner_id FK
        bool is_active
    }

    ProductCategory {
        int id PK
        string name
    }

    Product {
        int id PK
        string name
        string description
        decimal price
        int commerce_id FK
        int category_id FK
        string image
        bool is_available
    }

    Order {
        int id PK
        int client_id FK
        int commerce_id FK
        string status
        decimal total_price
        string notes
        datetime created_at
        datetime updated_at
    }

    OrderItem {
        int id PK
        int order_id FK
        int product_id FK
        int quantity
        decimal unit_price
    }

    Deliverer {
        int id PK
        int user_id FK
        string status
        int assigned_number
        bool is_active
    }

    DeliveryRequest {
        int id PK
        int client_id FK
        int deliverer_id FK
        string pickup_address
        string delivery_address
        decimal delivery_fee
        string status
        datetime completed_at
        datetime created_at
    }

    FinancialRecord {
        int id PK
        int deliverer_id FK
        string record_type
        decimal amount
        decimal runners_commission
        string description
        datetime created_at
    }

    SystemConfig {
        int id PK
        string key UK
        string value
        string description
    }

    ServiceCategory {
        int id PK
        string name
        string description
    }

    ServiceProvider {
        int id PK
        int user_id FK
        int category_id FK
        string description
        string photo
        string resume
        bool terms_accepted
        string status
        string approval_status
        string rejection_reason
        int approved_by_id FK
        datetime approved_at
    }

    ServiceRequest {
        int id PK
        int client_id FK
        int provider_id FK
        int category_id FK
        string description
        datetime scheduled_date
        decimal provider_fee
        decimal runners_fee
        decimal client_total
        string status
        string notes
        datetime created_at
    }

    Contact {
        int id PK
        string name
        string phone
        string description
        string contact_type
        bool is_active
        datetime created_at
        datetime updated_at
    }

    User ||--o{ Commerce : "owns"
    User ||--o{ Order : "places"
    User ||--o{ DeliveryRequest : "requests"
    User ||--o{ ServiceRequest : "requests"
    User ||--|| Deliverer : "is a"
    User ||--|| ServiceProvider : "is a"
    Commerce ||--o{ Product : "contains"
    Commerce }o--|| StoreCategory : "belongs to"
    Order ||--o{ OrderItem : "includes"
    Order }o--|| Commerce : "from"
    Product ||--o{ OrderItem : "in"
    Product }o--|| ProductCategory : "categorized as"
    Deliverer ||--o{ DeliveryRequest : "handles"
    Deliverer ||--o{ FinancialRecord : "has"
    ServiceProvider }o--|| ServiceCategory : "belongs to"
    ServiceProvider ||--o{ ServiceRequest : "receives"
    ServiceRequest }o--|| ServiceCategory : "categorized as"
```

#### 14.4.6 Diagrama de Clases (Dominio Flutter)

```mermaid
classDiagram
    class UserEntity {
        +int id
        +String email
        +String firstName
        +String lastName
        +String role
        +bool isActive
    }

    class AuthRepository {
        <<interface>>
        +login(email, password) Future~AuthTokens~
        +register(data) Future~UserEntity~
        +logout() Future~void~
        +refreshToken(refresh) Future~AuthTokens~
    }

    class AuthNotifier {
        +StateNotifier~AuthState~
        +login(email, password) void
        +logout() void
        +checkAuth() void
    }

    class CommerceEntity {
        +int id
        +String name
        +String city
        +String logo
        +bool isActive
    }

    class ProductEntity {
        +int id
        +String name
        +decimal price
        +bool isAvailable
    }

    class CartRepository {
        <<interface>>
        +addItem(product, qty) void
        +removeItem(productId) void
        +clearCart() void
        +getItems() List~CartItem~
    }

    class DeliveryRequestEntity {
        +int id
        +String pickupAddress
        +String deliveryAddress
        +String status
        +DateTime? completedAt
    }

    class ServiceProviderEntity {
        +int id
        +String description
        +String approvalStatus
        +String status
    }

    class ContactEntity {
        +int id
        +String name
        +String phone
        +String contactType
        +bool isActive
    }

    AuthNotifier --> AuthRepository
    CartRepository --> ProductEntity
```

### 14.5 Prototipado

Se desarrollará/desarrolló un prototipo funcional en Flutter que incluye:

- Pantallas de login y registro con validación.
- Home con navegación por módulos según rol.
- Tienda con listado de comercios, productos y carrito.
- Flujo de solicitud y seguimiento de domicilios.
- Directorio de servicios con perfil de prestador.
- Directorio de contactos con filtro por tipo.
- Panel de administración con dashboard y gestión.

---

## 15. Casos de uso (detallados)

**Actores:** Cliente (Usuario), Prestador, Domiciliario, Administrador (Admin), Sistema (API Django).

### UC-01: Registrarse (Cliente / Prestador / Domiciliario)

- **Precondición:** el usuario no está registrado.
- **Flujo:** Usuario ingresa nombre, apellido, correo, contraseña y rol → `POST /api/auth/register/` → Sistema valida correo único → Crea usuario → Retorna tokens JWT.
- **Excepciones:** email ya registrado, contraseña muy corta, rol inválido.

### UC-02: Iniciar sesión

- **Precondición:** cuenta existente con credenciales válidas.
- **Flujo:** `POST /api/auth/login/` → Sistema valida credenciales → Retorna access + refresh token → Flutter guarda en SecureStorage → GoRouter redirige según rol.
- **Excepciones:** credenciales inválidas, cuenta inactiva.

### UC-03: Consultar tienda

- **Flujo:** `GET /api/store/commerces/` → listar comercios activos; `GET /api/store/products/?commerce_id=X` → listar productos; Flutter muestra listado con imagen, nombre y precio.

### UC-04: Gestionar carrito

- **Flujo:** Cliente agrega/elimina productos → CartNotifier actualiza Hive → Flutter refleja cambios en tiempo real → Cliente confirma → `POST /api/store/orders/` con ítems.

### UC-05: Solicitar domicilio

- **Flujo:** Cliente llena formulario (pickup_address, delivery_address) → `POST /api/deliveries/requests/` → Sistema asigna domiciliario disponible automáticamente → Retorna solicitud con domiciliario asignado o null.

### UC-06: Actualizar estado de domicilio

- **Flujo:** Domiciliario consulta `GET /api/deliveries/requests/` (sus solicitudes) → `PATCH /api/deliveries/requests/{id}/` con nuevo estado → Sistema actualiza completed_at si estado = ENTREGADO → Genera FinancialRecord.

### UC-07: Completar perfil de prestador

- **Flujo:** `POST /api/services/providers/` con foto, descripción, categoría, hoja de vida, aceptación de términos → Sistema crea perfil con `approval_status = PENDIENTE` → Admin notificado.

### UC-08: Aprobar / rechazar prestador (Admin)

- **Flujo:** Admin consulta `GET /api/services/providers/?approval_status=PENDIENTE` → Revisa perfil → `PATCH /api/services/providers/{id}/` con `approval_status = APROBADO` o `RECHAZADO` + `rejection_reason`.

### UC-09: Solicitar servicio (Cliente)

- **Flujo:** Cliente busca prestadores aprobados → `GET /api/services/providers/` → Selecciona prestador → `POST /api/services/requests/` con descripción y fecha → Sistema calcula client_total → Prestador recibe solicitud.

### UC-10: Gestionar solicitudes de servicio (Prestador)

- **Flujo:** `GET /api/services/requests/` (mis solicitudes) → `PATCH /api/services/requests/{id}/` con status `APROBADO` o `RECHAZADO`.

### UC-11: Consultar directorio de contactos

- **Flujo:** `GET /api/contacts/` → filtros opcionales por `contact_type` → Flutter muestra directorio con nombre, teléfono, descripción e ícono por tipo.

### UC-12: Administrar catálogo y usuarios (Admin)

- **Flujo:** Admin accede a endpoints de gestión: usuarios (`/api/users/`), comercios (`/api/store/commerces/`), configuración (`/api/deliveries/config/`), contactos (`/api/contacts/`).

### UC-13: Ver reportes (Admin)

- **Flujo:** `GET /api/reports/deliveries/` → reportes de domicilios con filtros; `GET /api/reports/services/` → reportes de servicios; `GET /api/reports/store/` → reportes de tienda.

### 15.1 Diagrama de casos de uso

```mermaid
graph LR
    Cliente((Cliente))
    Prestador((Prestador))
    Domiciliario((Domiciliario))
    Admin((Admin))
    Sistema((Sistema))

    Cliente --> UC01[Registrarse]
    Cliente --> UC02[Iniciar sesión]
    Cliente --> UC03[Ver tienda]
    Cliente --> UC04[Gestionar carrito]
    Cliente --> UC05[Solicitar domicilio]
    Cliente --> UC09[Solicitar servicio]
    Cliente --> UC11[Ver contactos]

    Prestador --> UC02
    Prestador --> UC07[Completar perfil]
    Prestador --> UC10[Gestionar solicitudes]

    Domiciliario --> UC02
    Domiciliario --> UC06[Actualizar domicilio]

    Admin --> UC02
    Admin --> UC08[Aprobar prestador]
    Admin --> UC12[Administrar plataforma]
    Admin --> UC13[Ver reportes]

    Sistema --> UC05
    Sistema --> UC06
```

---

## 16. Estructura de carpetas

### 16.1 Backend (Django)

```
backend/
├── manage.py
├── requirements.txt
├── .env / .env.example
├── runners_project/          # Configuración global
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   ├── wsgi.py
│   └── asgi.py
├── apps/
│   ├── users/                # Modelo User con roles
│   │   ├── models.py
│   │   ├── serializers.py
│   │   ├── views.py
│   │   └── urls.py
│   ├── store/                # Comercios, Productos, Órdenes
│   │   ├── models.py
│   │   ├── serializers.py
│   │   ├── views.py
│   │   └── urls.py
│   ├── deliveries/           # Domicilios y registros financieros
│   │   ├── models.py
│   │   ├── serializers.py
│   │   ├── views.py
│   │   └── urls.py
│   ├── services/             # Prestadores y solicitudes de servicio
│   │   ├── models.py
│   │   ├── serializers.py
│   │   ├── views.py
│   │   └── urls.py
│   ├── contacts/             # Directorio de contactos
│   │   ├── models.py
│   │   ├── serializers.py
│   │   ├── views.py
│   │   └── urls.py
│   └── reports/              # Endpoints de reportes y dashboard
│       ├── views.py
│       └── urls.py
├── media/                    # Archivos subidos (fotos, HV)
└── db.sqlite3
```

### 16.2 Frontend (Flutter + Clean Architecture)

```
frontend/
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── network/          # Cliente Dio + interceptores JWT
│   │   ├── router/           # GoRouter con guardias de rol
│   │   ├── storage/          # Hive (carrito) + SecureStorage (tokens)
│   │   ├── theme/            # AppTheme, colores, tipografía
│   │   ├── constants/        # URLs base, constantes de la app
│   │   ├── errors/           # Clases de error y failure
│   │   └── utils/            # Utilidades generales
│   ├── features/
│   │   ├── auth/             # Login, Register, Splash
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── store/            # Comercios, Productos, Carrito, Órdenes
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── deliveries/       # Domicilios, Repartidores
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── services/         # Categorías, Prestadores, Solicitudes
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   ├── contacts/         # Directorio de contactos
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   └── admin/            # Dashboard, Reportes, Gestión
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   └── shared/
│       └── widgets/          # AppButton, AppTextField, AppCard, etc.
├── android/
├── ios/
└── test/
```

---

## 17. Plan de Gestión de Riesgos

### 17.1 Introducción

Esta sección establece las estrategias, procedimientos y responsabilidades necesarias para identificar, analizar, mitigar y controlar los riesgos del proyecto Runners a lo largo de su ciclo de vida.

#### 17.1.1 Propósito

El propósito de este plan es definir la metodología y las acciones que se implementarán para gestionar los riesgos del proyecto Runners, garantizando la entrega a tiempo de una plataforma funcional, segura y bien documentada.

#### 17.1.2 Alcance

Este plan abarca todos los riesgos identificados durante las fases de análisis, diseño, desarrollo, pruebas y despliegue del sistema Runners. Se aplica a todo el equipo de trabajo, herramientas tecnológicas utilizadas, procesos de comunicación y gestión interna del proyecto.

#### 17.1.3 Definiciones y Acrónimos

- **DRF:** Django REST Framework
- **JWT:** JSON Web Token
- **HU:** Historia de Usuario
- **RN:** Regla de Negocio
- **UC:** Caso de Uso

#### 17.1.4 Referencias

- Documentación oficial Django: https://docs.djangoproject.com/
- Documentación DRF: https://www.django-rest-framework.org/
- Documentación Flutter: https://docs.flutter.dev/
- Riverpod: https://riverpod.dev/
- GoRouter: https://pub.dev/packages/go_router

#### 17.1.5 Descripción General

Este plan se organiza en:
- **Resumen de riesgos:** lista priorizada de riesgos identificados.
- **Tareas de gestión:** identificación, análisis y mitigación.
- **Responsabilidades:** roles del equipo frente a cada riesgo.
- **Presupuesto:** asignación de tiempo para contingencias.
- **Herramientas:** Git, GitHub Issues, documentación colaborativa.

---

## 18. Tareas de Gestión de Riesgos

- **Identificación:** sesiones de análisis con el equipo revisando cada módulo.
- **Análisis:** Matriz de probabilidad/impacto (escala 1-5).
- **Priorización:** Riesgos con puntuación ≥ 8 se gestionan primero.
- **Seguimiento:** revisión semanal durante el sprint activo.

---

## 19. Organización y Responsabilidades

- **Líder del Proyecto:** responsable de coordinar las actividades generales, asegurar el cumplimiento del plan, gestionar la comunicación con los interesados y tomar decisiones de alcance.
- **Gestor de Riesgos:** encargado de identificar, documentar y hacer seguimiento a los riesgos identificados durante el desarrollo.
- **Equipo Técnico (todos los integrantes):** participa en la detección temprana de riesgos técnicos relacionados con el stack (Django, Flutter, JWT, despliegue).
- **Comité de Revisión (equipo completo):** realiza revisiones periódicas para evaluar el estado de los riesgos e implementar medidas correctivas.

---

## 20. Presupuesto

El proyecto Runners es académico y de código abierto. Los costos son:

| Recurso | Costo |
|---|---|
| Servidor de desarrollo (local) | $0 |
| Repositorio GitHub (público) | $0 |
| Herramientas de desarrollo (VS Code, Postman) | $0 |
| Flutter SDK, Django, librerías open source | $0 |
| Servidor de producción (estimado futuro) | Variable según proveedor |
| Contingencia de tiempo (15% del sprint) | 4-6 horas por sprint |

---

## 21. Herramientas y Técnicas

- **Control de versiones:** Git + GitHub (ramas feature, commits semánticos, Pull Requests).
- **Gestión de tareas:** GitHub Issues / tablero Kanban para historias de usuario y bugs.
- **Comunicación:** reuniones regulares de sincronización del equipo.
- **Documentación:** Markdown en el repositorio (README, QUICKSTART, CONTRIBUTING, este documento).
- **Pruebas de API:** Postman con colección `runners_api_postman.json` (30+ endpoints).
- **Pruebas de Frontend:** flujos manuales completos por módulo.

---

## 22. Elementos de Riesgo Por Gestionar

### Riesgo 1 – Pérdida o ausencia de un integrante del equipo

**Descripción:** Un miembro del equipo deja de participar temporalmente o definitivamente.  
**Control:** Documentación accesible en GitHub, commits descriptivos, arquitectura modular que permite que otro integrante retome cualquier módulo.  
- *Prevención:* distribuir responsabilidades equitativamente y documentar avances continuamente.  
- *Mitigación:* asignar roles con redundancia; cualquier miembro puede levantar el backend y el frontend de forma independiente.

### Riesgo 2 – Pérdida o daño de archivos de proyecto

**Descripción:** Fallo de disco, pérdida de laptop o corrupción de archivos.  
**Control:** Todo el código está versionado en GitHub (`https://github.com/Karatsuyu/Runners.git`).  
- *Prevención:* push frecuente al repositorio remoto.  
- *Mitigación:* clone desde GitHub en cualquier equipo en minutos.

### Riesgo 3 – Falta de comunicación en el equipo

**Descripción:** Desacuerdos o malentendidos que afectan el progreso.  
**Control:** Reglas claras de branches, commits semánticos, Pull Requests con descripción.  
- *Prevención:* reuniones periódicas de sincronización.  
- *Mitigación:* revisión cruzada de Pull Requests antes de merge a main.

### Riesgo 4 – Incumplimiento de plazos

**Descripción:** Subestimación del tiempo requerido para módulos complejos.  
**Control:** Sprints con estimación en puntos de historia, revisiones frecuentes.  
- *Prevención:* dejar 15% del sprint como buffer para imprevistos.  
- *Mitigación:* reducir el alcance del sprint y posponer features no críticas.

### Riesgo 5 – Problemas con herramientas o dependencias

**Descripción:** Incompatibilidades de versiones (Flutter, Dart, Django, librerías).  
**Control:** Versiones fijas en `pubspec.yaml` y `requirements.txt`; entorno virtual Python.  
- *Prevención:* usar `requirements.txt` con versiones exactas.  
- *Mitigación:* ambiente virtual Python aislado; `flutter pub get` restaura dependencias.

### Riesgo 6 – Falta de experiencia con el stack

**Descripción:** Miembros del equipo no familiarizados con Clean Architecture, Riverpod o DRF.  
**Control:** Documentación de arquitectura incluida en el repositorio.  
- *Prevención:* sesiones de revisión del código entre pares.  
- *Mitigación:* guías de implementación (`runners_flutter_implementacion.md`, `runners_guia_implementacion_web.md`) disponibles en el proyecto.

### Riesgo 7 – Cambios en los requisitos

**Descripción:** Modificaciones en las funcionalidades o el modelo de datos después de iniciado el desarrollo.  
**Control:** Arquitectura modular que minimiza el impacto de cambios en un módulo sobre los otros.  
- *Prevención:* definir requisitos completos antes de comenzar cada módulo.  
- *Mitigación:* migraciones Django para cambios en el modelo; Clean Architecture para cambios en el frontend sin afectar dominio.

### Riesgo 8 – Fallas en el despliegue a producción

**Descripción:** Errores de configuración al migrar de SQLite a PostgreSQL o al desplegar en servidor.  
**Control:** Variables de entorno en `.env` con `.env.example` documentado.  
- *Prevención:* probar con PostgreSQL en entorno local antes del despliegue.  
- *Mitigación:* documentación de despliegue en `QUICKSTART.md`; SQLite funcional para demostración.

**Niveles de riesgo:** 🟢 Bajo (1-4) | 🟡 Medio (5-9) | 🟠 Alto (10-14) | 🔴 Muy alto (15-25)

---

## 23. Diagrama de paquetes

```mermaid
graph TB
    subgraph "Flutter App"
        subgraph "core"
            NET[network\nDio + Interceptors]
            ROUTER[router\nGoRouter]
            STORE_LOCAL[storage\nHive + SecureStorage]
            THEME[theme]
        end

        subgraph "features"
            AUTH[auth\nlogin/register/splash]
            STORE[store\ncommerces/products\norders/cart]
            DELIV[deliveries\nrequests/deliverers]
            SERV[services\nproviders/requests]
            CONT[contacts\ndirectory]
            ADMIN[admin\ndashboard/reports]
        end

        subgraph "shared"
            WIDGETS[widgets\nAppButton\nAppTextField\nAppCard\n...]
        end
    end

    subgraph "Django Backend"
        subgraph "apps"
            USERS[users]
            STOREAPP[store]
            DELIVAPP[deliveries]
            SERVAPP[services]
            CONTAPP[contacts]
            REPORTS[reports]
        end
        CONFIG[runners_project\nsettings / urls]
        DB[(SQLite\nPostgreSQL)]
    end

    NET --> AUTH
    NET --> STORE
    NET --> DELIV
    NET --> SERV
    NET --> CONT
    NET --> ADMIN

    USERS --> CONFIG
    STOREAPP --> CONFIG
    DELIVAPP --> CONFIG
    SERVAPP --> CONFIG
    CONTAPP --> CONFIG
    REPORTS --> CONFIG
    CONFIG --> DB
```

---

## 24. Cronograma

### Planificación del Tiempo

**Duración del Sprint:** 2 semanas (10 días hábiles)

**Capacidad del Equipo:**
- 3 desarrolladores × 40 hr/semana × 2 semanas = 240 hr
- Restando reuniones y sincronización (8 hr): **232 hr efectivas**
- 1 punto de historia = 8 hr → **29 puntos disponibles por sprint**

### Sprint 1 – Autenticación + Tienda

| Historia | Tareas | Puntos |
|---|---|---|
| HU-01 Registro | Diseño pantalla registro, validación de correo único, serializer usuario | 2 |
| HU-02 Login | Diseño pantalla login, endpoint JWT, interceptor Dio, SecureStorage | 3 |
| HU-03 Logout | Limpiar tokens SecureStorage, GoRouter redirige a Login | 1 |
| HU-04 Ver tienda | Endpoint comercios y productos, pantalla listado con categorías | 4 |
| HU-05 Carrito | CartNotifier Riverpod, persistencia Hive, pantalla carrito | 4 |
| HU-06 Confirmar orden | Endpoint crear orden con ítems, pantalla confirmación | 4 |
| HU-07 Historial órdenes | Endpoint listado órdenes del cliente, pantalla historial | 3 |

**Total Sprint 1: 21 puntos**

### Sprint 2 – Domicilios + Servicios

| Historia | Tareas | Puntos |
|---|---|---|
| HU-08 Solicitar domicilio | Endpoint solicitud, asignación automática domiciliario | 4 |
| HU-09 Ver estado domicilio | Pantalla seguimiento, endpoint detalle solicitud | 2 |
| HU-10 Gestionar domicilios | Pantalla domiciliario, PATCH estado, FinancialRecord automático | 4 |
| HU-11 Historial financiero | Endpoint registros financieros, pantalla domiciliario | 2 |
| HU-12 Ver prestadores | Endpoint prestadores aprobados, pantalla directorio servicios | 3 |
| HU-13 Solicitar servicio | Endpoint crear solicitud servicio, cálculo tarifas | 3 |
| HU-14 Perfil prestador | Endpoint crear/actualizar perfil, subida de foto y HV | 3 |
| HU-15 Gestionar solicitudes | Endpoint aprobar/rechazar solicitudes, pantalla prestador | 2 |

**Total Sprint 2: 23 puntos**

### Sprint 3 – Contactos + Admin + Refinamiento

| Historia | Tareas | Puntos |
|---|---|---|
| HU-16 Ver contactos | Endpoint directorio, pantalla listado con filtro | 2 |
| HU-17 Filtrar contactos | Filtros por tipo en endpoint y UI | 1 |
| HU-18 Dashboard admin | Endpoint métricas, pantalla dashboard con cards | 4 |
| HU-19 Aprobar prestadores | Endpoint PATCH approval, pantalla gestión prestadores | 3 |
| HU-20 Gestionar contactos | CRUD contactos para admin, pantalla gestión | 3 |
| HU-21 Reportes | Endpoints reportes domicilios/servicios/tienda, pantallas | 4 |
| Buffer / pruebas | Pruebas Postman, flujos completos, ajustes UX | 4 |

**Total Sprint 3: 21 puntos**

---

## 25. Resultados Esperados

La aplicación Runners se proyecta como una solución integral para la gestión de servicios comunitarios, domicilios y tienda local.

1. **Digitalización de la economía local:** conectar clientes con comercios y prestadores de la comunidad en un canal único y formal.
2. **Eficiencia en la asignación de domicilios:** reducir tiempos de respuesta mediante asignación automática basada en disponibilidad.
3. **Validación de prestadores:** garantizar calidad del servicio mediante aprobación administrativa previa.
4. **Centralización de información:** el administrador tendrá visibilidad completa sobre operaciones, finanzas y usuarios en tiempo real.
5. **Reducción de errores:** flujos automatizados (asignación, cálculo de tarifas, registro financiero) minimizan la intervención manual.
6. **Arquitectura escalable:** la separación Clean Architecture + DRF permitirá agregar módulos (pagos en línea, chat, notificaciones push) sin reestructurar el sistema.
7. **Experiencia de usuario fluida:** gestión de estado con Riverpod, persistencia offline con Hive y manejo de errores con feedback visual garantizan una experiencia confiable.
8. **Documentación completa:** README, QUICKSTART, guías de implementación, colección Postman y este documento aseguran la transferencia del conocimiento.

---

## 26. Recomendaciones y Sugerencias a Futuro

### 1. Implementar pagos en línea reales
Integrar pasarelas como PayPal, Stripe o MercadoPago para completar transacciones reales. Esto requerirá adecuarse a la normativa de pagos electrónicos local y evaluar la seguridad de la integración.

### 2. Notificaciones push en tiempo real
Implementar Firebase Cloud Messaging (FCM) para notificar a clientes sobre cambios de estado en domicilios y servicios, y a domiciliarios sobre nuevas solicitudes asignadas.

### 3. Chat integrado entre cliente y prestador/domiciliario
Un módulo de chat en tiempo real (Django Channels + WebSockets en Flutter) mejoraría la comunicación durante la prestación del servicio o el domicilio.

### 4. Sistema de calificaciones y reseñas
Agregar un módulo de rating para domiciliarios y prestadores después de completar un servicio, mejorando la confianza y la calidad de la plataforma.

### 5. Geolocalización en tiempo real
Integrar GPS para seguimiento de domicilios en mapa (Google Maps SDK para Flutter, backend con coordenadas en DeliveryRequest).

### 6. Panel de analytics avanzado
Dashboard con gráficos de ventas, servicios más solicitados, domiciliarios más activos y métricas de retención de clientes.

### 7. Aplicación web (PWA o React)
Con la API ya desarrollada, construir una versión web para administradores y comercios que no requieran la app móvil.

### 8. Despliegue en producción con Docker
Contenerizar el backend Django con Docker Compose, configurar PostgreSQL, Nginx, SSL y gunicorn para un despliegue robusto en VPS o plataforma cloud.

### 9. Sistema de recomendaciones con IA
Recomendar prestadores o productos basados en el historial de solicitudes del usuario, usando técnicas de filtrado colaborativo.

### 10. Auditoría y trazabilidad
Registrar todas las acciones administrativas (aprobaciones, cambios de estado, configuración) en un log de auditoría para mejorar la seguridad y el control.

---

## 27. Conclusiones

- La arquitectura propuesta (Flutter + Clean Architecture + Riverpod frontend; Django + DRF + JWT backend) ofrece una base sólida, productiva y mantenible para el desarrollo del sistema Runners.
- El modelo relacional diseñado es flexible y soporta correctamente los cuatro módulos principales (tienda, domicilios, servicios, contactos) con sus respectivas relaciones entre entidades.
- La asignación automática de domiciliarios simplifica el flujo operativo sin requerir intervención manual, reduciendo errores y tiempos de respuesta.
- El sistema de aprobación de prestadores garantiza calidad en el directorio de servicios, protegiendo la reputación de la plataforma.
- La arquitectura Clean en Flutter asegura que los cambios en la capa de datos (p.ej., cambio de URL base o estructura de respuesta) no afecten la capa de presentación, reduciendo el costo de mantenimiento.
- Para producción se recomienda: PostgreSQL, almacenamiento de media en S3 o equivalente, HTTPS, contenedores Docker, y pruebas automatizadas con CI/CD en GitHub Actions.
- Se recomienda implementar notificaciones push (FCM) y geolocalización como próximas funcionalidades de alto impacto para la experiencia del usuario.

---

## 28. Bibliografía

- Sommerville, I. (2016). *Ingeniería del Software*. Pearson.
- Pressman, R. (2015). *Ingeniería del Software: Un enfoque práctico*. McGraw-Hill.
- Django Software Foundation. *Django Documentation*. https://docs.djangoproject.com/
- Django REST Framework. *DRF Documentation*. https://www.django-rest-framework.org/
- JWT.io. *JSON Web Tokens Introduction*. https://jwt.io/introduction
- Flutter Team. *Flutter Documentation*. https://docs.flutter.dev/
- Riverpod. *Riverpod Documentation*. https://riverpod.dev/
- GoRouter. *go_router package*. https://pub.dev/packages/go_router
- Hive. *Hive Documentation*. https://docs.hivedb.dev/
- Mermaid. *Mermaid Diagramming Tool*. https://mermaid.js.org/
- Simple JWT. *djangorestframework-simplejwt Documentation*. https://django-rest-framework-simplejwt.readthedocs.io/
