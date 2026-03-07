# SISTEMA WEB RUNNERS

## Plataforma de Intermediación de Servicios y Domicilios

---

Trabajo académico presentado como parte del desarrollo de un proyecto de software para la materia Desarrollo de Software II

---

**Presentado por:**

- Integrante 1
- Integrante 2
- Integrante 3

---

**Universidad del Valle – Sede regional Caicedonia**

**2026**

---

## Tabla de Contenido

1. [Runners](#1-runners)
2. [Planteamiento del problema](#2-planteamiento-del-problema)
3. [Justificación](#3-justificación)
4. [Objetivo general](#4-objetivo-general)
   - 4.1 [Objetivos específicos](#41-objetivos-específicos)
5. [Antecedentes](#5-antecedentes)
6. [Marco legal](#6-marco-legal)
7. [Marco teórico](#7-marco-teórico)
8. [Requerimientos funcionales y no funcionales](#8-requerimientos-funcionales-y-no-funcionales)
   - 8.1 [Introducción](#81-introducción)
   - 8.2 [Requisitos Funcionales a Nivel del Sistema](#82-requisitos-funcionales-a-nivel-del-sistema)
   - 8.3 – 8.15 [Requisitos funcionales detallados](#83-registro-de-cliente-req1)
   - 8.16 [Requerimientos no funcionales](#816-requerimientos-no-funcionales)
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
24. [Resultados Esperados de la Aplicación](#24-resultados-esperados-de-la-aplicación)
25. [Recomendaciones y Sugerencias a Futuro](#25-recomendaciones-y-sugerencias-a-futuro)
26. [Conclusiones](#26-conclusiones)
27. [Bibliografía](#27-bibliografía)

---

### Historial de versiones

| Versión | Fecha de modificación/creación | Descripción |
|---------|-------------------------------|-------------|
| 0.1 | 01/02/2026 | Primer requisito funcional y estructura base |
| 0.2 | 05/02/2026 | Se agregaron los requisitos funcionales del módulo Tienda y Servicios |
| 0.3 | 10/02/2026 | Se agregaron los requisitos de Domicilios y Contactos |
| 0.4 | 15/02/2026 | Se agregó la información de cualidades del sistema |
| 0.5 | 18/02/2026 | Se agregó la información de interfaces de usuario |
| 0.6 | 20/02/2026 | Se agregaron las reglas de negocio |
| 0.7 | 22/02/2026 | Se agregaron las restricciones del sistema |
| 0.8 | 25/02/2026 | Se agregó la documentación del sistema y casos de uso |
| 0.9 | 28/02/2026 | Se actualizó la introducción y plan de riesgos |
| 1.0 | 03/03/2026 | Revisiones finales |

---

## 1. Runners

Sistema Web para la Intermediación de Servicios, Domicilios y Comercio Local en Caicedonia, Valle del Cauca.

**Runners** es una plataforma web de intermediación que conecta a la comunidad de Caicedonia con:

- **Tiendas y restaurantes** — pedidos en línea con notificación directa al comercio.
- **Prestadores de servicios** — conexión intermediada entre clientes y profesionales (albañiles, contadores, doctores, etc.).
- **Domiciliarios** — gestión de pedidos, control de ingresos/egresos y deuda con la empresa.
- **Contactos de emergencia y profesionales** — directorio de disponibilidad en tiempo real.

Runners fue fundada en 2019 y actualmente opera de forma manual (papel, listas y comunicación directa). El presente proyecto busca digitalizar y automatizar estos procesos mediante una solución web moderna.

---

## 2. Planteamiento del problema

Las microempresas de intermediación en municipios como Caicedonia enfrentan dificultades para:

- Gestionar pedidos de múltiples comercios de forma centralizada y sin errores.
- Conectar clientes con prestadores de servicios profesionales verificados y disponibles.
- Controlar ingresos, egresos y comisiones de los domiciliarios de manera eficiente.
- Proveer un directorio de contactos de emergencia y profesionales con disponibilidad en tiempo real.
- Mantener la trazabilidad de todas las transacciones realizadas a través de la plataforma.

Runners actualmente opera mediante listas manuales, llamadas telefónicas y registros en papel. Esto genera:

- **Errores humanos** en la toma de pedidos y el cálculo de comisiones.
- **Pérdida de información** sobre ventas, servicios prestados y balances financieros.
- **Falta de trazabilidad** para demostrar que una venta o servicio pasó por la plataforma.
- **Ineficiencia operativa** al depender de procesos manuales para conectar clientes con comercios, prestadores y domiciliarios.
- **Imposibilidad de escalar** el negocio a medida que crece la demanda de servicios.

Sin una solución unificada, la experiencia del cliente se fragmenta, los procesos requieren intervención manual constante y se pierde información valiosa para la toma de decisiones.

---

## 3. Justificación

Este proyecto busca dar solución a la necesidad de ofrecer un sistema en línea que no solo gestione pedidos de comercios locales, sino que también integre la intermediación de servicios profesionales, el control financiero de domiciliarios y un directorio de contactos de emergencia en una sola plataforma.

Con ello, se busca:

- **Mejorar la experiencia del cliente**, ofreciendo acceso centralizado a comercios, servicios y domicilios desde cualquier dispositivo.
- **Incrementar la competitividad de Runners**, proporcionando herramientas digitales que reemplacen los procesos manuales actuales.
- **Optimizar procesos internos**, automatizando la gestión de pedidos, aprobación de prestadores y cálculo de comisiones.
- **Garantizar la trazabilidad**, registrando cada transacción que pasa por la plataforma con el campo `via_runners`.
- **Mejorar la seguridad**, implementando autenticación JWT y control de roles diferenciados.
- **Obtener datos** (ventas, servicios, balances de domiciliarios) para la toma de decisiones comerciales.
- **Escalar y extender funcionalidades** (pagos reales, notificaciones push, app móvil) en el futuro.

---

## 4. Objetivo general

Desarrollar una aplicación web integral para la empresa Runners que funcione como plataforma de intermediación, permitiendo a los clientes de Caicedonia acceder a comercios locales, solicitar servicios profesionales, contactar domiciliarios y consultar un directorio de emergencias, mientras se automatiza la gestión operativa interna de la empresa.

Asimismo, la aplicación buscará optimizar los procesos internos de Runners mediante la automatización del flujo de pedidos desde su registro en el carrito hasta su entrega, incluyendo la trazabilidad completa de cada transacción y el control financiero de los domiciliarios.

El sistema deberá incorporar una plataforma de usuarios robusta que incluya funcionalidades de registro, inicio de sesión seguro mediante autenticación JWT, gestión de perfiles, historial de pedidos, aprobación de prestadores de servicio y panel de administración centralizado.

Desde el punto de vista técnico, se plantea una arquitectura cliente-servidor basada en un backend desarrollado en Django REST Framework y un frontend implementado en React con entorno Vite, siguiendo el patrón Modelo–Vista–Controlador (MVC).

---

### 4.1. Objetivos específicos

1. **Diseñar y desarrollar un backend robusto** utilizando Django 5.2.6 y Django REST Framework 3.16.1 que gestione de manera eficiente las operaciones de los módulos principales: Usuarios, Tienda, Servicios, Domicilios, Contactos y Reportes.

2. **Implementar un frontend moderno e interactivo** utilizando React 19 con Vite 7, que consuma los endpoints del backend de forma asíncrona mediante Axios, ofreciendo una experiencia de usuario fluida y responsiva.

3. **Desarrollar un sistema de autenticación y gestión de usuarios** basado en tokens JWT (JSON Web Tokens) con `djangorestframework-simplejwt`, que garantice acceso seguro con cuatro roles diferenciados: CLIENTE, PRESTADOR, DOMICILIARIO y ADMIN.

4. **Diseñar e implementar un modelo de base de datos relacional** en Django, optimizado para representar las entidades del dominio: usuarios, comercios, productos, pedidos, prestadores de servicio, domiciliarios, registros financieros y contactos.

5. **Integrar un módulo de tienda** que permita al administrador registrar comercios y productos, y a los clientes navegar por categorías, seleccionar productos y generar pedidos con carrito de compras.

6. **Desarrollar un módulo de servicios profesionales** que permita a los prestadores registrarse con hoja de vida, ser aprobados por el administrador, y a los clientes buscar y solicitar servicios por categoría.

7. **Implementar un módulo de domicilios** con control de estado de domiciliarios, registro de ingresos y egresos, cálculo automático de comisión de Runners, y solicitud directa por parte de clientes.

8. **Crear un módulo de contactos** que funcione como directorio de emergencias y profesionales con búsqueda, filtrado por tipo y estado de disponibilidad.

9. **Desarrollar un panel de administración** con dashboard de resumen, reportes de ventas, reportes de domiciliarios, gestión de usuarios y aprobación de perfiles.

10. **Aplicar una metodología de desarrollo ágil**, utilizando herramientas de planificación y gestión como Trello, donde se registren las historias de usuario, requisitos funcionales y el avance de cada sprint.

11. **Realizar pruebas integrales del sistema**, tanto en el backend (API con Postman) como en el frontend (flujo de usuario completo), verificando la funcionalidad, seguridad y rendimiento de cada módulo.

12. **Documentar exhaustivamente todo el proceso de desarrollo**, incluyendo la arquitectura, el modelo relacional, los diagramas de casos de uso, la estructura de carpetas y el plan de riesgos.

---

## 5. Antecedentes

Plataformas de intermediación y servicios de delivery (Rappi, Domicilios.com, UberEats) demuestran que:

- La digitalización reduce errores de pedido y tiempos de atención significativamente.
- La centralización de servicios en una sola plataforma incrementa la fidelización del cliente.
- El control financiero automatizado mejora la relación entre la empresa y sus colaboradores (domiciliarios).
- Los directorios de servicios profesionales con verificación generan mayor confianza en los usuarios.

Sin embargo, estas plataformas están diseñadas para grandes ciudades y no atienden las necesidades específicas de municipios pequeños como Caicedonia, donde la intermediación es más personal y multifuncional.

Tech stacks como Django/DRF y React son ampliamente usados en proyectos SPA + API; JWT es un estándar para autenticación sin estado.

Estos antecedentes justifican la elección tecnológica y el diseño modular que se propone.

---

## 6. Marco legal

Consideraciones principales:

- **Protección de datos personales**: respetar principios de minimización, finalidad y consentimiento. Adaptar la implementación a la legislación colombiana (Ley 1581 de 2012 – Protección de Datos Personales y Ley 1266 de 2008 – Habeas Data).
- **Políticas y Términos**: textos legales para uso del servicio, política de privacidad y términos y condiciones que los prestadores de servicio deben aceptar.
- **Derechos de autor**: usar imágenes con licencia o propias (productos/comercios).
- **Seguridad**: contraseñas hashed (Django), no almacenar datos sensibles en texto plano. Los tokens JWT se transmiten por cabeceras Authorization con esquema Bearer.
- **Registro mercantil**: Runners opera como intermediario y no como proveedor directo de los servicios, lo cual implica responsabilidades legales diferenciadas.

> **Nota:** en la fase actual no se procesan pagos reales. El sistema gestiona el proceso de intermediación automatizando lo que antes era manual. Cualquier integración de pagos requiere evaluación legal y técnica adicional.

---

## 7. Marco teórico

- **Arquitectura cliente/servidor**: frontend (React SPA) consume backend RESTful (Django/DRF).
- **REST & JSON**: diseño de endpoints con recursos y verbos HTTP estándar.
- **JWT (JSON Web Tokens)**: flujo access/refresh para autenticación stateless. Access token con vigencia de 15 minutos y refresh token con vigencia de 7 días.
- **Modelo relacional**: uso de tablas normalizadas, relaciones 1:N y M:N con tablas intermedias gestionadas por el ORM de Django.
- **UX centrado en el usuario**: interfaces simples para navegar comercios, solicitar servicios y contactar domiciliarios, minimizando fricción en cada flujo.
- **MVC (Modelo-Vista-Controlador)**: en el backend Django (modelos y vistas API); en el frontend patrón componente-estado (React con Context API).
- **Intermediación digital**: modelo de negocio donde Runners actúa como puente entre clientes y proveedores de servicios, registrando la trazabilidad de cada transacción.

---

## 8. Requerimientos funcionales y no funcionales

### 8.1 Introducción

En esta sección se describe el desarrollo del sistema web Runners, una plataforma diseñada para intermediar servicios, domicilios y comercio local en Caicedonia, Valle del Cauca. El proyecto busca automatizar y optimizar los procesos que la empresa Runners actualmente gestiona de forma manual.

Asimismo, el sistema facilita la gestión interna de la empresa mediante la automatización de pedidos, la aprobación de prestadores, el control financiero de domiciliarios y la generación de reportes. En este documento se presentan las etapas de análisis, diseño, implementación y validación del sistema.

---

### 8.2 Requisitos Funcionales a Nivel del Sistema

---

### 8.3 Registro de cliente (REQ1)

**Código:** USR-RF-001

**Nombre:** Registro de cliente en la plataforma

**Descripción:** Permite a una persona natural registrarse como cliente en la plataforma Runners para poder realizar pedidos, solicitar servicios y consultar el directorio de contactos.

**Actores:** Cliente (usuario nuevo), Sistema

**Precondición:**
- El usuario no debe tener una cuenta registrada previamente con el mismo correo.
- El sistema debe estar en línea y operativo.

**Secuencia normal:**

| Paso | Descripción |
|------|-------------|
| 1 | El usuario accede a la página de registro desde la pantalla principal. |
| 2 | El sistema presenta el formulario de registro (nombre, apellido, correo, teléfono, contraseña). |
| 3 | El usuario diligencia el formulario y hace clic en "Registrarse". |
| 4 | El sistema valida los campos obligatorios y el formato del correo. |
| 5 | El sistema crea el usuario con rol `CLIENTE` y genera un token JWT. |
| 6 | El usuario es redirigido al panel principal autenticado. |

**Secuencia alterna:**

| Paso | Descripción |
|------|-------------|
| 1A | Si el correo ya existe, el sistema muestra un mensaje de error indicando que ya hay una cuenta registrada. |
| 3A | Si el usuario ya tiene cuenta, puede hacer clic en "Iniciar sesión" para ir al login. |

**Excepciones:**

| Código | Descripción |
|--------|-------------|
| E1 | Error de conexión con la base de datos: el sistema muestra un mensaje de error 500 y pide reintentar. |
| E2 | Campos inválidos (correo mal formado, contraseña corta): el sistema muestra validación en línea sin enviar el formulario. |

**Postcondición:**
- El usuario queda registrado con rol `CLIENTE` en la base de datos.
- El usuario recibe un JWT válido para operar en la plataforma.

**Comentarios:** Se puede añadir verificación por correo electrónico en versiones futuras.

---

### 8.4 Inicio de sesión con JWT (REQ2)

**Código:** USR-RF-002

**Nombre:** Inicio de sesión con JWT

**Descripción:** Permite a usuarios registrados (clientes, prestadores, domiciliarios, administradores) autenticarse en la plataforma y obtener tokens de acceso y refresco.

**Actores:** Cliente, Prestador de Servicio, Domiciliario, Administrador, Sistema

**Precondición:**
- El usuario debe estar registrado y activo en el sistema.

**Secuencia normal:**

| Paso | Descripción |
|------|-------------|
| 1 | El usuario accede a la pantalla de inicio de sesión. |
| 2 | Ingresa correo y contraseña. |
| 3 | El sistema valida las credenciales contra la base de datos. |
| 4 | El sistema genera un `access_token` (15 min) y un `refresh_token` (7 días). |
| 5 | El token se almacena en el cliente (localStorage). |
| 6 | El usuario es redirigido a su panel según su rol. |

**Secuencia alterna:**

| Paso | Descripción |
|------|-------------|
| 3A | Si las credenciales son incorrectas, el sistema muestra "Correo o contraseña incorrectos" sin especificar cuál falló (seguridad). |
| 6A | Si el usuario está suspendido, el sistema muestra "Cuenta suspendida, contacte al administrador". |

**Excepciones:**

| Código | Descripción |
|--------|-------------|
| E1 | Token expirado: el sistema usa el refresh_token para renovar automáticamente el access_token. |
| E2 | Refresh expirado: el usuario es redirigido al login. |

**Postcondición:**
- El usuario queda autenticado con token válido.
- El sistema registra la sesión activa.

**Comentarios:** Usar `djangorestframework-simplejwt` para la gestión de tokens.

---

### 8.5 Gestión de roles (REQ3)

**Código:** USR-RF-003

**Nombre:** Diferenciación y control de roles

**Descripción:** El sistema debe diferenciar y controlar el acceso según el rol del usuario: CLIENTE, PRESTADOR, DOMICILIARIO, ADMIN.

**Actores:** Sistema, Administrador

**Precondición:**
- El usuario debe estar autenticado.

**Secuencia normal:**

| Paso | Descripción |
|------|-------------|
| 1 | El sistema lee el campo `role` del token JWT o del perfil del usuario. |
| 2 | El sistema aplica permisos de acceso según el rol. |
| 3 | El frontend renderiza el menú y las vistas correspondientes al rol. |
| 4 | El backend valida el rol en cada endpoint con decoradores de permisos. |

**Secuencia alterna:**

| Paso | Descripción |
|------|-------------|
| 2A | Si un usuario intenta acceder a un endpoint no autorizado, el sistema devuelve HTTP 403 Forbidden. |

**Excepciones:**

| Código | Descripción |
|--------|-------------|
| E1 | Token manipulado o inválido: el sistema devuelve HTTP 401 Unauthorized. |

**Postcondición:**
- Solo se permite el acceso a los recursos autorizados para cada rol.

**Comentarios:** El rol ADMIN puede gestionar todos los demás usuarios. Los roles se definen en el modelo de usuario personalizado.

---

### 8.6 Aprobación de prestadores de servicio (REQ4)

**Código:** USR-RF-004

**Nombre:** Aprobación de perfil de prestador por administrador

**Descripción:** Un prestador de servicio debe ser aprobado por el administrador antes de aparecer activo en la plataforma, previa carga de hoja de vida.

**Actores:** Prestador de Servicio, Administrador, Sistema

**Precondición:**
- El prestador debe haberse registrado y cargado su hoja de vida en formato PDF o imagen.
- El administrador debe estar autenticado con rol ADMIN.

**Secuencia normal:**

| Paso | Descripción |
|------|-------------|
| 1 | El prestador completa su perfil y adjunta hoja de vida. |
| 2 | El sistema guarda el perfil con estado `PENDIENTE`. |
| 3 | El administrador accede al panel de perfiles pendientes. |
| 4 | El administrador revisa la hoja de vida y la información del prestador. |
| 5 | El administrador aprueba o rechaza el perfil. |
| 6 | El sistema actualiza el estado a `APROBADO` o `RECHAZADO` y notifica al prestador. |

**Secuencia alterna:**

| Paso | Descripción |
|------|-------------|
| 5A | Si rechaza, el administrador puede dejar un comentario de motivo. |

**Excepciones:**

| Código | Descripción |
|--------|-------------|
| E1 | Error al subir el archivo de hoja de vida (formato no soportado o tamaño excesivo): el sistema muestra mensaje de error con las restricciones permitidas. |

**Postcondición:**
- El prestador aprobado queda activo y visible para los clientes.
- El prestador rechazado recibe notificación con motivo.

**Comentarios:** Los tipos de archivo permitidos: PDF, JPG, PNG. Tamaño máximo recomendado: 5 MB.

---

### 8.7 Registro de comercio (REQ5)

**Código:** TDA-RF-001

**Nombre:** Registro de restaurante o almacén en la Tienda

**Descripción:** Permite al administrador registrar un comercio (restaurante, almacén u otro tipo) en la plataforma, asignándole categoría, nombre, descripción e imagen.

**Actores:** Administrador, Sistema

**Precondición:**
- El administrador debe estar autenticado.
- La categoría del comercio debe existir en el sistema.

**Secuencia normal:**

| Paso | Descripción |
|------|-------------|
| 1 | El administrador accede al panel de administración → Módulo Tienda → Registrar Comercio. |
| 2 | El sistema presenta el formulario de registro de comercio. |
| 3 | El administrador completa nombre, categoría, descripción, teléfono e imagen. |
| 4 | El sistema guarda el comercio en la base de datos. |
| 5 | El comercio queda visible en la tienda para los clientes. |

**Secuencia alterna:**

| Paso | Descripción |
|------|-------------|
| 3A | Si la categoría no existe, el administrador puede crear una nueva categoría antes de continuar. |

**Excepciones:**

| Código | Descripción |
|--------|-------------|
| E1 | Error al subir la imagen: el sistema muestra error y permite continuar sin imagen (opcional). |

**Postcondición:**
- El comercio queda registrado y disponible en la tienda.

**Comentarios:** En versiones futuras, los propios comerciantes podrán auto-registrarse y gestionar su catálogo.

---

### 8.8 Gestión de productos del comercio (REQ6)

**Código:** TDA-RF-002

**Nombre:** Registro y gestión de productos de un comercio

**Descripción:** Permite registrar, editar y desactivar productos asociados a un comercio registrado en la plataforma.

**Actores:** Administrador, Sistema

**Precondición:**
- El comercio debe estar previamente registrado y activo.

**Secuencia normal:**

| Paso | Descripción |
|------|-------------|
| 1 | El administrador selecciona el comercio desde el panel. |
| 2 | Accede a la sección "Productos" del comercio. |
| 3 | Hace clic en "Agregar producto". |
| 4 | Completa nombre, descripción, precio e imagen del producto. |
| 5 | El sistema guarda el producto asociado al comercio. |
| 6 | El producto queda visible en el catálogo del comercio para clientes. |

**Secuencia alterna:**

| Paso | Descripción |
|------|-------------|
| 4A | El administrador puede editar o desactivar un producto existente. |

**Excepciones:**

| Código | Descripción |
|--------|-------------|
| E1 | Precio negativo o cero: el sistema muestra error de validación. |

**Postcondición:**
- El producto queda disponible en el catálogo del comercio.

**Comentarios:** El campo `is_available` (boolean) permite activar/desactivar productos sin eliminarlos.

---

### 8.9 Generación de pedido por cliente (REQ7)

**Código:** TDA-RF-003

**Nombre:** Generación de pedido desde la tienda

**Descripción:** Permite al cliente seleccionar productos de un comercio y generar un pedido que llega directamente al establecimiento a través de la plataforma.

**Actores:** Cliente, Sistema, Comercio

**Precondición:**
- El cliente debe estar autenticado.
- Los productos del comercio deben estar disponibles.

**Secuencia normal:**

| Paso | Descripción |
|------|-------------|
| 1 | El cliente navega a la tienda y selecciona un comercio. |
| 2 | El cliente selecciona uno o más productos y los agrega al carrito. |
| 3 | El cliente revisa el carrito y hace clic en "Realizar pedido". |
| 4 | El sistema registra el pedido con estado `PENDIENTE` y lo asocia al comercio. |
| 5 | El comercio recibe notificación del nuevo pedido. |
| 6 | El cliente visualiza el pedido en su historial con estado actualizado. |

**Secuencia alterna:**

| Paso | Descripción |
|------|-------------|
| 2A | El cliente puede vaciar el carrito o eliminar productos antes de confirmar. |
| 3A | Si el cliente no está autenticado, el sistema lo redirige al login antes de confirmar el pedido. |

**Excepciones:**

| Código | Descripción |
|--------|-------------|
| E1 | Producto no disponible al momento de confirmar: el sistema muestra un aviso y elimina el ítem del carrito. |

**Postcondición:**
- El pedido queda registrado en el historial del cliente y del comercio.
- El campo `via_runners = True` garantiza la trazabilidad.

**Comentarios:** No se procesan pagos en esta implementación inicial. El seguimiento es informativo.

---

### 8.10 Historial de ventas (REQ8)

**Código:** TDA-RF-004

**Nombre:** Visualización del historial de ventas

**Descripción:** Permite al administrador ver el historial de pedidos generados a través de la plataforma, incluyendo qué se vendió, cuándo y a través de qué comercio.

**Actores:** Administrador, Sistema

**Precondición:**
- Deben existir pedidos registrados en el sistema.
- El administrador debe estar autenticado.

**Secuencia normal:**

| Paso | Descripción |
|------|-------------|
| 1 | El administrador accede al módulo de Reportes → Historial de Ventas. |
| 2 | El sistema muestra listado de pedidos con filtros por fecha, comercio y estado. |
| 3 | El administrador aplica filtros según necesidad. |
| 4 | El sistema muestra los resultados filtrados con detalle de cada transacción. |

**Secuencia alterna:**

| Paso | Descripción |
|------|-------------|
| 3A | Si no hay pedidos en el rango seleccionado, el sistema muestra "Sin resultados para el período indicado". |

**Excepciones:**

| Código | Descripción |
|--------|-------------|
| E1 | Error en la consulta a la base de datos: el sistema muestra mensaje de error y permite reintentar. |

**Postcondición:**
- El administrador puede ver la trazabilidad completa de ventas vía Runners.

**Comentarios:** Se puede extender con exportación a CSV o PDF en versiones futuras.

---

### 8.11 Registro de prestador de servicio (REQ9)

**Código:** SRV-RF-001

**Nombre:** Registro de prestador de servicio

**Descripción:** Permite a una persona registrarse como prestador de servicio en la plataforma, cargando su información profesional y hoja de vida para revisión del administrador.

**Actores:** Prestador de Servicio, Sistema

**Precondición:**
- La persona no debe tener un perfil de prestador activo con el mismo correo.
- El sistema debe tener al menos una categoría de servicio registrada.

**Secuencia normal:**

| Paso | Descripción |
|------|-------------|
| 1 | El prestador accede a la sección "Registrarme como prestador". |
| 2 | El sistema muestra formulario con: categoría, descripción, hoja de vida (archivo), aceptación de términos. |
| 3 | El prestador completa el formulario y acepta los términos y condiciones. |
| 4 | El sistema guarda el perfil con estado `PENDIENTE` a espera de aprobación. |
| 5 | El prestador recibe confirmación de que su perfil está en revisión. |

**Secuencia alterna:**

| Paso | Descripción |
|------|-------------|
| 3A | Si no acepta los términos, el sistema no permite continuar y resalta el campo. |

**Excepciones:**

| Código | Descripción |
|--------|-------------|
| E1 | Error al cargar el archivo de hoja de vida: el sistema muestra mensaje con formatos y tamaño permitido. |

**Postcondición:**
- El perfil del prestador queda registrado con estado PENDIENTE.
- El administrador recibe notificación de nuevo perfil a revisar.

**Comentarios:** Términos y condiciones deben redactarse como documento legal separado.

---

### 8.12 Búsqueda y solicitud de servicio (REQ10)

**Código:** SRV-RF-002

**Nombre:** Búsqueda y solicitud de servicio por categoría

**Descripción:** Permite al cliente buscar servicios por categoría (ej: plomería, contabilidad, medicina) y solicitar un prestador disponible a través de la plataforma.

**Actores:** Cliente, Sistema, Prestador de Servicio

**Precondición:**
- El cliente debe estar autenticado.
- Deben existir prestadores aprobados y con estado DISPONIBLE en la categoría buscada.

**Secuencia normal:**

| Paso | Descripción |
|------|-------------|
| 1 | El cliente accede al módulo Servicios. |
| 2 | Selecciona o busca una categoría de servicio. |
| 3 | El sistema muestra la lista de prestadores disponibles en esa categoría. |
| 4 | El cliente hace clic en "Solicitar servicio" sobre el prestador elegido. |
| 5 | El sistema registra la solicitud y la redirige a Runners como intermediaria. |
| 6 | El sistema notifica al prestador y genera el registro de la solicitud. |
| 7 | El cliente visualiza los datos de contacto del prestador para coordinar. |

**Secuencia alterna:**

| Paso | Descripción |
|------|-------------|
| 3A | Si no hay prestadores disponibles, el sistema muestra "Sin prestadores disponibles en este momento". |

**Excepciones:**

| Código | Descripción |
|--------|-------------|
| E1 | El prestador cambia a estado OCUPADO mientras el cliente confirma: el sistema recalcula disponibilidad y lo informa. |

**Postcondición:**
- La solicitud queda registrada en el historial de la plataforma.
- Runners queda como intermediaria del contacto entre cliente y prestador.

**Comentarios:** El sistema registra la comisión de Runners (ej: prestador cobra $50.000, cliente paga $60.000). La gestión del cobro es manual en esta versión.

---

### 8.13 Control de estado del prestador (REQ11)

**Código:** SRV-RF-003

**Nombre:** Cambio de estado del prestador (Disponible / Ocupado / Inactivo)

**Descripción:** Permite al prestador de servicio actualizar su estado de disponibilidad dentro de la plataforma.

**Actores:** Prestador de Servicio, Sistema

**Precondición:**
- El prestador debe estar aprobado y autenticado.

**Secuencia normal:**

| Paso | Descripción |
|------|-------------|
| 1 | El prestador accede a su panel de perfil. |
| 2 | Visualiza su estado actual (Disponible / Ocupado / Inactivo). |
| 3 | Hace clic en el botón de cambio de estado. |
| 4 | El sistema actualiza el estado en la base de datos. |
| 5 | El cambio se refleja en tiempo real en el módulo de Servicios. |

**Secuencia alterna:**

| Paso | Descripción |
|------|-------------|
| 4A | Si hay solicitudes activas asignadas al prestador, el sistema advierte antes de pasar a INACTIVO. |

**Excepciones:**

| Código | Descripción |
|--------|-------------|
| E1 | Error de conexión al guardar el estado: el sistema muestra mensaje de error y conserva el estado anterior. |

**Postcondición:**
- El estado del prestador se actualiza y los clientes solo ven prestadores DISPONIBLES.

---

### 8.14 Registro de domiciliario (REQ12)

**Código:** DOM-RF-001

**Nombre:** Registro de domiciliario en la plataforma

**Descripción:** Permite registrar a un domiciliario con su perfil, número asignado e información de contacto.

**Actores:** Administrador, Sistema

**Precondición:**
- El administrador debe estar autenticado.

**Secuencia normal:**

| Paso | Descripción |
|------|-------------|
| 1 | El administrador accede al módulo de Domicilios → Registrar domiciliario. |
| 2 | Completa el formulario: nombre, teléfono, número asignado, tipo (independiente / empresa). |
| 3 | El sistema guarda el perfil del domiciliario con estado DISPONIBLE. |
| 4 | El domiciliario aparece en el módulo de domicilios para los clientes. |

**Secuencia alterna:**

| Paso | Descripción |
|------|-------------|
| 2A | El propio domiciliario puede auto-registrarse y el administrador lo aprueba. |

**Excepciones:**

| Código | Descripción |
|--------|-------------|
| E1 | Número asignado duplicado: el sistema valida unicidad y muestra error. |

**Postcondición:**
- El domiciliario queda activo con su perfil y número asignado.

**Comentarios:** El número asignado es el identificador visual del domiciliario dentro de la plataforma.

---

### 8.15 Control de ingresos y egresos del domiciliario (REQ13)

**Código:** DOM-RF-002

**Nombre:** Registro y control de ingresos y egresos del domiciliario

**Descripción:** Permite al domiciliario registrar sus servicios realizados, llevar control de ingresos y egresos, y calcular cuánto debe pagarle a Runners.

**Actores:** Domiciliario, Administrador, Sistema

**Precondición:**
- El domiciliario debe estar registrado y autenticado.

**Secuencia normal:**

| Paso | Descripción |
|------|-------------|
| 1 | El domiciliario accede a su panel de control financiero. |
| 2 | Registra un nuevo servicio con descripción y valor. |
| 3 | El sistema suma el valor al total de ingresos del domiciliario. |
| 4 | El sistema calcula automáticamente el porcentaje que corresponde a Runners. |
| 5 | El domiciliario puede ver su balance: ingresos, egresos y deuda con Runners. |

**Secuencia alterna:**

| Paso | Descripción |
|------|-------------|
| 2A | El domiciliario puede registrar un egreso (gasto) para restar del balance. |

**Excepciones:**

| Código | Descripción |
|--------|-------------|
| E1 | Valor ingresado negativo o no numérico: el sistema muestra error de validación. |

**Postcondición:**
- El registro queda guardado en el historial del domiciliario.
- El administrador puede consultar el estado financiero de cada domiciliario.

**Comentarios:** El porcentaje de comisión de Runners se configura en el panel de administración mediante el modelo `SystemConfig`.

---

### 8.16 Requerimientos no funcionales

- **RNF-01 Seguridad:** contraseñas hashed (Django), autenticación JWT con access/refresh tokens, validaciones de entrada en serializers, permisos por roles (IsAdmin, IsCliente, IsPrestador, IsDomiciliario).
- **RNF-02 Rendimiento:** endpoints principales con latencia objetivo < 500ms en dev; paginación con PAGE_SIZE=20 en todas las listas.
- **RNF-03 Escalabilidad:** separación frontend/backend; arquitectura compatible con contenedores; PostgreSQL para producción.
- **RNF-04 Mantenibilidad:** código modular (6 apps Django; componentes React organizados por módulo).
- **RNF-05 Observabilidad:** logs backend, manejo de errores en frontend con interceptores Axios.
- **RNF-06 Compatibilidad:** responsive web, navegadores modernos (Chrome, Firefox, Edge, Safari).

---

## 9. Cualidades del Sistema

El sistema web Runners se caracteriza por las siguientes cualidades:

### 9.1 Usabilidad y Accesibilidad

Presenta una interfaz intuitiva, moderna y fácil de navegar. Los usuarios pueden acceder rápidamente a las funciones principales sin requerir conocimientos técnicos previos.

**Implementaciones presentes:**

**(Perceivable)**

- **Alternativas textuales:** Títulos descriptivos en botones y enlaces de navegación en `Navbar.jsx`.
- **Información y relaciones:** Uso de elementos semánticos HTML (`<header>`, `<nav>`, `<main>`, `<footer>`), etiquetas de encabezado semánticas (`<h1>`, `<h2>`, `<h3>`) en páginas y componentes.
- **Formularios accesibles:** `Login.jsx` y `Register.jsx` utilizan `<label>` vinculados con `htmlFor`, inputs con tipos semánticos (`type="email"`, `type="password"`, `type="tel"`) y atributo `required`.
- **Controles interactivos:** Uso de `<button>` para acciones y `<Link>` (react-router) para navegación, con estados de carga y deshabilitación adecuados.
- **Mensajes de estado:** Mensajes de error visibles en formularios, indicadores de carga (`LoadingSpinner.jsx`) y mensajes de error (`ErrorMessage.jsx`).

### 9.2 Confiabilidad

El sistema gestiona la intermediación de servicios con validaciones en cada paso. Las transacciones quedan registradas con trazabilidad completa (`via_runners`). Los tokens JWT se rotan automáticamente y se invalidan al cerrar sesión (token blacklist).

### 9.3 Rendimiento

Ofrece carga rápida de componentes gracias al uso de Vite como herramienta de compilación. El backend utiliza paginación (PAGE_SIZE=20), filtros optimizados y consultas eficientes para asegurar una experiencia fluida.

### 9.4 Soportabilidad

Su código está documentado y estructurado en módulos independientes (6 apps Django, componentes React organizados por dominio), lo que facilita la corrección de errores, actualización de componentes y mantenimiento continuo.

---

## 10. Interfaces del Sistema

### 10.1 Interfaces de Usuario

#### 10.1.1 Aspecto y Sensación

La interfaz tiene un diseño moderno, limpio y coherente. Se utilizan colores institucionales de Runners con fuentes legibles y una paleta consistente. Los componentes comunes (`Navbar`, `Footer`, `LoadingSpinner`, `ErrorMessage`) mantienen la coherencia visual en toda la aplicación.

#### 10.1.2 Requisitos de Diseño y Navegación

El menú principal (`Navbar.jsx`) se ubica en la parte superior con accesos directos según el rol del usuario:
- **Todos:** Inicio, Tienda, Servicios, Domicilios, Contactos
- **Admin:** Panel de Administración
- **Domiciliario:** Dashboard de Domicilios

La navegación se realiza mediante React Router con rutas protegidas (`ProtectedRoute.jsx`) que verifican autenticación y roles. El `Footer.jsx` contiene información de la empresa.

#### 10.1.3 Consistencia

El esquema de colores, tipografía y estilo de botones se mantiene de forma uniforme en todo el sitio. Los componentes reutilizables (`ProductCard`, `ServiceCard`, `DeliveryCard`, `ContactCard`) siguen el mismo patrón de diseño.

#### 10.1.4 Requisitos de Personalización del Usuario

El usuario puede gestionar su perfil, ver su historial de pedidos y, según su rol, acceder a funcionalidades específicas (dashboard financiero para domiciliarios, panel de estado para prestadores, panel administrativo para admins).

### 10.2 Interfaces con Sistemas o Dispositivos Externos

#### 10.2.1 Interfaces de Software

El sistema sigue una arquitectura MVC donde el frontend (React SPA con Vite) y el backend (Django REST Framework) se comunican mediante API RESTful con formato JSON. El frontend usa Axios con interceptores para autenticación automática.

#### 10.2.2 Interfaces de Hardware

No requiere hardware especializado. Compatible con cualquier navegador web moderno y conexión estable a Internet.

#### 10.2.3 Interfaces de Comunicaciones

Se utiliza el protocolo HTTP/HTTPS para las comunicaciones entre cliente y servidor. Django REST Framework gestiona las respuestas con códigos de estado HTTP estándar. CORS está configurado con `django-cors-headers` para permitir comunicación entre el frontend (puerto 5173) y el backend (puerto 8000).

---

## 11. Reglas de Negocio

Las reglas de negocio son declaraciones que definen y limitan el comportamiento del sistema Runners, asegurando que las operaciones se realicen de acuerdo con las políticas de la empresa.

Las reglas se expresan mediante estructura condicional:
**Si [condiciones], entonces [acciones o resultados esperados].**

### 11.1 Clase de Reglas: Usuarios y Autenticación

#### 11.1.1 RN-01 – Registro con correo único

**Descripción:**
Si el usuario ingresa un correo electrónico que ya está registrado, entonces el sistema debe notificar que la cuenta existe e impedir la creación de un duplicado.

#### 11.1.2 RN-02 – Inicio de sesión seguro

**Descripción:**
Si el usuario inicia sesión, entonces el sistema deberá validar correo y contraseña cifrados mediante JWT, permitiendo el acceso solo en caso de coincidencia. Se genera un access_token (15 min) y un refresh_token (7 días).

#### 11.1.3 RN-03 – Roles diferenciados

**Descripción:**
Si el usuario está autenticado, entonces el sistema aplicará los permisos correspondientes a su rol (CLIENTE, PRESTADOR, DOMICILIARIO, ADMIN) tanto en el frontend (renderizado condicional) como en el backend (permisos por endpoint).

### 11.2 Clase de Reglas: Tienda y Pedidos

#### 11.2.1 RN-04 – Validación de productos

**Descripción:**
Si un producto tiene el campo `is_available = False`, entonces no aparecerá en el catálogo del comercio ni podrá ser agregado al carrito.

#### 11.2.2 RN-05 – Validación de precio

**Descripción:**
Si un administrador intenta registrar un producto con precio menor o igual a cero, entonces el sistema mostrará un error de validación e impedirá el guardado.

#### 11.2.3 RN-06 – Trazabilidad de pedidos

**Descripción:**
Si un pedido es generado a través de la plataforma, entonces el campo `via_runners` se establecerá en `True` automáticamente, garantizando la trazabilidad de que la venta pasó por Runners.

#### 11.2.4 RN-07 – Validación del carrito

**Descripción:**
Si el carrito de compras no contiene productos válidos, entonces el sistema no permitirá continuar con la generación del pedido.

#### 11.2.5 RN-08 – Generación de pedido

**Descripción:**
Si el cliente confirma su carrito, entonces el sistema debe crear un pedido con estado inicial `PENDIENTE`, calcular el total sumando los subtotales de cada ítem, y registrar la fecha de creación.

### 11.3 Clase de Reglas: Servicios

#### 11.3.1 RN-09 – Aprobación obligatoria

**Descripción:**
Si un prestador se registra en la plataforma, entonces su perfil quedará con estado `PENDIENTE` hasta que un administrador lo apruebe o rechace. Solo los prestadores con estado `APROBADO` serán visibles para los clientes.

#### 11.3.2 RN-10 – Aceptación de términos

**Descripción:**
Si un prestador no acepta los términos y condiciones, entonces el sistema no permitirá completar su registro.

#### 11.3.3 RN-11 – Visibilidad por disponibilidad

**Descripción:**
Si un prestador cambia su estado a `OCUPADO` o `INACTIVO`, entonces dejará de aparecer en los resultados de búsqueda de los clientes.

### 11.4 Clase de Reglas: Domicilios y Finanzas

#### 11.4.1 RN-12 – Número asignado único

**Descripción:**
Si se intenta registrar un domiciliario con un número asignado que ya existe, entonces el sistema validará la unicidad e impedirá el registro duplicado.

#### 11.4.2 RN-13 – Cálculo automático de comisión

**Descripción:**
Si un domiciliario registra un ingreso, entonces el sistema calculará automáticamente la comisión de Runners según el porcentaje configurado en `SystemConfig` (parámetro `runners_commission_pct`).

#### 11.4.3 RN-14 – Auto-suspensión del administrador

**Descripción:**
Si un administrador intenta suspender su propia cuenta, entonces el sistema impedirá la operación para evitar que el sistema quede sin administradores activos.

---

## 12. Restricciones del Sistema

Las restricciones establecen los lineamientos técnicos, de implementación y recursos que deben cumplirse en el desarrollo del sistema Runners.

### 12.1 Lenguaje de Implementación

El sistema se desarrolla bajo una arquitectura Modelo–Vista–Controlador (MVC). El backend se implementa en Django (Python), aprovechando su robustez, modularidad y seguridad, además de su ORM integrado. El frontend se desarrolla en React (JavaScript/JSX) con Vite como bundler.

### 12.2 Base de Datos

El sistema utiliza el ORM de Django para la gestión de datos, facilitando las operaciones CRUD.

- **Desarrollo:** SQLite por su integración nativa en Django, bajo consumo de recursos y facilidad de configuración.
- **Producción:** PostgreSQL, por su estabilidad, escalabilidad y compatibilidad con consultas complejas y grandes volúmenes de datos.

### 12.3 Herramientas de Desarrollo

Para la planificación, seguimiento y organización del proyecto se utiliza Trello como herramienta principal de gestión de tareas.

**Lenguajes y runtimes:**
- Python 3.12
- Node.js ≥ 18 (para Vite 7)
- JavaScript/JSX (React)

**Backend (Django + DRF):**
- Framework: Django 5.2.6, Django REST Framework 3.16.1
- Autenticación: djangorestframework-simplejwt 5.5.1, PyJWT 2.10.1
- CORS: django-cors-headers 4.8.0
- Base de datos: SQLite (dev), psycopg2-binary 2.9.10 (PostgreSQL para prod)
- Media: Pillow 11.3.0 (soporte ImageField)
- Utilidades: python-dotenv 1.1.1, asgiref 3.9.1, sqlparse 0.5.3, tzdata 2025.2
- Apps: users, store, services, deliveries, contacts, reports
- Servidor de desarrollo: manage.py runserver (puerto 8000)

**Frontend (React + Vite):**
- Framework y router: React 19.1.1, react-router-dom 7.9.4
- Cliente HTTP: axios 1.12.2
- Build: Vite 7.1.0, @vitejs/plugin-react 5.0.0
- Linting: ESLint 9.33.0, eslint-plugin-react-hooks 5.2.0, eslint-plugin-react-refresh 0.4.20
- Estado/UI: Context API (AuthContext, CartContext), componentes organizados por módulo

**Gestión de dependencias:**
- Backend: pip (requirements.txt)
- Frontend: npm (package.json)

**Control de versiones:**
- Git + GitHub

### 12.4 Límites de Recursos

El sistema debe estar optimizado para funcionar en equipos con un mínimo de 4 GB de RAM, procesador de 2 núcleos y conexión estable a Internet. No deberá requerir instalación de software adicional por parte del usuario final salvo el navegador.

---

## 13. Documentación del Sistema

### 13.1 Sistema de Ayuda en Línea y Soporte

El sistema incluirá mensajes contextuales y feedback visual en formularios para guiar al usuario. Además, se ofrecerá soporte a través de los canales de comunicación de Runners. El panel de administración Django (`/admin`) sirve como respaldo administrativo durante el desarrollo.

### 13.2 Documentación Técnica

El equipo de desarrollo elaborará documentación técnica que incluirá:

- Estructura de la base de datos (modelos Django).
- Diagrama de arquitectura del sistema.
- Descripción de los endpoints de la API.
- Requisitos de instalación y despliegue.
- Procedimientos de respaldo y restauración.
- README.md con instrucciones completas de setup.

### 13.3 Responsabilidad

El equipo de desarrollo será responsable de la creación y mantenimiento de toda la documentación. Se realizarán actualizaciones con cada nueva versión del sistema.

---

## 14. Marco metodológico

### 14.1. Metodología de proyecto

Se aplica una metodología ágil (Scrum/Kanban) para el desarrollo:

- Sprints de 3 semanas.
- Uso de Trello para gestionar tareas (historias de usuario).
- Iteraciones con entregables funcionales en cada ciclo.
- Equipo de 3 desarrolladores con capacidad de 4 meses.

### 14.2. Informe de técnica de elicitación

La elicitación de requisitos se basó en:

- **Análisis de dominio:** observación de sistemas similares (Rappi, Domicilios.com, UberEats).
- **Entrevistas exploratorias:** con el equipo de Runners para entender los procesos manuales actuales.
- **Tormenta de ideas:** para identificar módulos diferenciadores (intermediación de servicios, control financiero de domiciliarios, directorio de contactos).
- **Análisis de procesos existentes:** documentación de los flujos manuales que Runners gestiona con papel y listas.

### 14.3 Historias de usuario – Trello

A continuación se detallan las 25 historias de usuario organizadas por módulo. Cada una incluye su descripción funcional, las tareas realizadas en el **backend** (Django/DRF) y en el **frontend** (React/Vite).

---

**MÓDULO 1: Autenticación y Usuarios**

---

**HU-01 – Registro de cliente**

*Como cliente, quiero registrarme en el sistema con mi nombre, apellido, correo, teléfono y contraseña, para poder crear una cuenta y acceder a todas las funcionalidades de la plataforma Runners.*

**Descripción:** El usuario accede a la página de registro, completa un formulario con sus datos personales y, al enviarlo, el sistema crea su cuenta con rol CLIENTE y devuelve tokens JWT automáticamente para que quede autenticado de inmediato.

**Backend:**
- Modelo `User` personalizado (`AbstractBaseUser` + `PermissionsMixin`) en `apps/users/models.py` con campos: `email` (único, usado como USERNAME_FIELD), `first_name`, `last_name`, `phone`, `role` (default CLIENTE), `is_active`, `date_joined`.
- `UserManager` con métodos `create_user()` y `create_superuser()`.
- `UserRegisterSerializer` en `apps/users/serializers.py` con campos `email`, `first_name`, `last_name`, `phone`, `password`, `password2`. Valida que las contraseñas coincidan y aplica `validate_password` de Django.
- `RegisterView` (CreateAPIView) en `apps/users/views.py` con `permission_classes = [AllowAny]`. Al crear el usuario genera `RefreshToken.for_user(user)` y retorna el perfil del usuario + tokens (access y refresh) con status 201.
- Endpoint: `POST /api/v1/auth/register/`.

**Frontend:**
- Página `Register.jsx` en `src/pages/Register.jsx` con formulario de 6 campos: nombre, apellido, correo, teléfono, contraseña, confirmar contraseña. Usa grid de 2 columnas para nombre/apellido y contraseñas.
- Validación en cliente: verifica que `password === password2` antes de enviar. Si no coinciden, muestra error sin hacer request.
- Llama a `register(form)` del `AuthContext`, que hace `POST /api/v1/auth/register/`, almacena tokens en `localStorage` y establece el usuario en el estado global.
- Al registrarse exitosamente, redirige a `/` (Home). Si hay error, muestra mensajes con componente `ErrorMessage`.
- Enlace "¿Ya tienes cuenta? → Iniciar Sesión" que redirige a `/login`.

---

**HU-02 – Inicio de sesión**

*Como cliente, quiero iniciar sesión con mi correo y contraseña, para acceder a mi perfil, realizar pedidos, solicitar servicios y consultar contactos.*

**Descripción:** El usuario ingresa sus credenciales en la pantalla de login. El sistema valida contra la base de datos, genera tokens JWT y carga el perfil del usuario para redirigirlo según su rol.

**Backend:**
- Endpoint de login usa `TokenObtainPairView` de `djangorestframework-simplejwt` directamente en `apps/users/urls.py`: `POST /api/v1/auth/login/`. Recibe `email` y `password`, retorna `access` y `refresh` tokens.
- Endpoint de perfil: `GET /api/v1/auth/profile/` → `UserProfileView` (RetrieveUpdateAPIView) que retorna el usuario autenticado con `UserProfileSerializer` (campos: id, email, first_name, last_name, full_name, phone, role, date_joined).
- Endpoint de refresh: `POST /api/v1/auth/token/refresh/` → `TokenRefreshView` para renovar el access_token usando el refresh_token.

**Frontend:**
- Página `Login.jsx` en `src/pages/Login.jsx` con formulario de correo y contraseña. Campos con `type="email"` y `type="password"`.
- Llama a `login(email, password)` del `AuthContext`, que hace `POST /api/v1/auth/login/`, almacena access y refresh en `localStorage`, luego hace `GET /api/v1/auth/profile/` para obtener datos del usuario.
- Redirección inteligente por rol: si `user.role === 'ADMIN'` redirige a `/admin`, en caso contrario redirige a `/`.
- Interceptor en `axiosConfig.js`: cuando un request falla con 401, automáticamente intenta renovar el token con el refresh_token. Si el refresh también falla, limpia localStorage y redirige a `/login`.
- Enlace "¿No tienes cuenta? → Registrarse" que redirige a `/register`.

---

**HU-03 – Cierre de sesión**

*Como usuario autenticado, quiero cerrar sesión de forma segura, para que mi token sea invalidado y nadie más pueda usar mi sesión.*

**Descripción:** Al hacer clic en "Salir", el sistema envía el refresh token al backend para invalidarlo (token blacklist), limpia el almacenamiento local y redirige al login.

**Backend:**
- Endpoint: `POST /api/v1/auth/logout/` → `TokenBlacklistView` de `djangorestframework-simplejwt`. Recibe el `refresh` token y lo añade a la tabla de tokens bloqueados.
- App `rest_framework_simplejwt.token_blacklist` registrada en `INSTALLED_APPS` (base.py). Tabla de blacklist creada mediante migración.

**Frontend:**
- Botón "Salir" en `Navbar.jsx` (color rojo `#e74c3c`). Al hacer clic ejecuta `handleLogout()`.
- `handleLogout` llama a `logout()` del `AuthContext`, que hace `POST /api/v1/auth/logout/` enviando el refresh_token. Independientemente del resultado (try/finally), limpia `localStorage` y establece `user = null`.
- Después del logout, `navigate('/login')` redirige al usuario a la pantalla de inicio de sesión.

---

**HU-04 – Roles diferenciados**

*Como administrador, quiero que el sistema diferencie los roles (CLIENTE, PRESTADOR, DOMICILIARIO, ADMIN), para controlar el acceso a cada módulo según corresponda.*

**Descripción:** El sistema implementa 4 roles con permisos diferenciados tanto en backend (permisos por endpoint) como en frontend (renderizado condicional y rutas protegidas).

**Backend:**
- Campo `role` en modelo `User` con `TextChoices`: CLIENTE, PRESTADOR, DOMICILIARIO, ADMIN.
- 6 clases de permisos personalizados en `apps/users/permissions.py`:
  - `IsAdmin` — solo ADMIN.
  - `IsCliente` — solo CLIENTE.
  - `IsPrestador` — solo PRESTADOR.
  - `IsDomiciliario` — solo DOMICILIARIO.
  - `IsAdminOrReadOnly` — ADMIN para escritura, autenticado para lectura.
  - `IsOwnerOrAdmin` — propietario del recurso o ADMIN.
- Cada vista aplica el permiso correspondiente (ej: `UserListView` usa `IsAdmin`, `FinancialRecordListCreateView` verifica el rol del usuario para filtrar datos).

**Frontend:**
- `ProtectedRoute` en `src/components/common/ProtectedRoute.jsx` y en `AppRouter.jsx`: verifica autenticación y opcionalmente acepta un array de `roles` permitidos. Si el usuario no está autenticado redirige a `/login`; si no tiene el rol permitido redirige a `/`.
- `Navbar.jsx` muestra enlaces condicionales: enlace "Admin" (dorado) solo para rol ADMIN, enlace "Mi Panel" (verde) solo para rol DOMICILIARIO.
- `AppRouter.jsx` define rutas protegidas por rol: `/admin` requiere `['ADMIN']`, `/deliveries/dashboard` requiere `['DOMICILIARIO', 'ADMIN']`.

---

**MÓDULO 2: Tienda**

---

**HU-05 – Registro de comercio**

*Como administrador, quiero registrar restaurantes y almacenes en la plataforma con nombre, categoría, descripción e imagen, para que los clientes puedan ver los comercios disponibles.*

**Descripción:** El administrador crea comercios asignándoles una categoría existente (restaurante, almacén, etc.), con imagen, teléfono, dirección y descripción. Los comercios activos son visibles para todos los usuarios autenticados.

**Backend:**
- Modelo `Category` en `apps/store/models.py`: `name` (único), `description`, `icon`, `is_active`.
- Modelo `Commerce`: FK a `Category`, campos `name`, `description`, `phone`, `address`, `image` (ImageField, upload_to `store/commerces/`), `is_active`.
- `CategorySerializer` y `CommerceSerializer` en `apps/store/serializers.py`. `CommerceSerializer` incluye `category_name` (read_only) y `products_count` (método que cuenta productos disponibles).
- `CategoryListView` (ListCreateAPIView, permiso `IsAdminOrReadOnly`): `GET` lista categorías activas para todos, `POST` crea categoría solo para ADMIN.
- `CommerceListView` (ListCreateAPIView, permiso `IsAdminOrReadOnly`): filtra `is_active=True`, acepta query param `?category=` para filtrar por categoría. `POST` crea comercio solo para ADMIN.
- Endpoints: `GET/POST /api/v1/store/categories/`, `GET/POST /api/v1/store/commerces/`, `GET/PUT/DELETE /api/v1/store/commerces/{id}/`.

**Frontend:**
- Página `StorePage.jsx` en `src/pages/store/StorePage.jsx`: carga categorías y comercios al montar. Muestra grid de tarjetas con imagen, nombre, categoría, descripción y conteo de productos.
- Componente `CategoryFilter.jsx` permite filtrar comercios por categoría seleccionada.
- Cada tarjeta de comercio es un `<Link>` a `/store/{id}` para ver el detalle con productos.
- La gestión CRUD de comercios se realiza desde el panel Django Admin (`/admin`) en esta versión. Página placeholder `ManageStore.jsx` preparada para implementación completa del frontend admin.

---

**HU-06 – Gestión de productos**

*Como administrador, quiero registrar, editar y desactivar productos de un comercio, para mantener el catálogo actualizado.*

**Descripción:** Los productos se asocian a un comercio específico. Cada producto tiene nombre, descripción, precio, imagen y un campo `is_available` que permite desactivarlo sin eliminarlo.

**Backend:**
- Modelo `Product` en `apps/store/models.py`: FK a `Commerce`, campos `name`, `description`, `price` (DecimalField 10,2), `image` (ImageField, upload_to `store/products/`), `is_available` (default True).
- `ProductSerializer` en `apps/store/serializers.py` con validación: `validate_price()` rechaza valores ≤ 0.
- `ProductListView` (ListCreateAPIView, permiso `IsAdminOrReadOnly`): filtra por `commerce_id` (de la URL) y `is_available=True`. Solo ADMIN puede crear (POST).
- `ProductDetailView` (RetrieveUpdateDestroyAPIView, permiso `IsAdminOrReadOnly`): permite al ADMIN editar/eliminar; usuarios autenticados solo lectura.
- Endpoints: `GET/POST /api/v1/store/commerces/{commerce_pk}/products/`, `GET/PUT/DELETE /api/v1/store/products/{id}/`.

**Frontend:**
- En `ComercioDetail.jsx`, al cargar el detalle del comercio (`GET /api/v1/store/commerces/{id}/`), el serializer `CommerceDetailSerializer` incluye la lista de productos anidada.
- Componente `ProductCard.jsx` muestra cada producto con imagen, nombre, precio formateado y botón "Agregar al carrito".
- Solo se muestran productos con `is_available = true` (filtrado en la vista `commerce.products.filter(p => p.is_available)`).
- La gestión CRUD de productos (crear, editar, desactivar) se realiza desde el panel Django Admin en esta versión.

---

**HU-07 – Crear pedido**

*Como cliente, quiero seleccionar productos de un comercio, agregarlos al carrito y generar un pedido, para que el comercio reciba mi solicitud a través de Runners.*

**Descripción:** El cliente navega productos de un comercio, agrega ítems al carrito (manejado en estado global), revisa cantidades y totales, y al confirmar el sistema genera un pedido completo con trazabilidad `via_runners = True`.

**Backend:**
- Modelo `Order` en `apps/store/models.py`: FK a `User` (client) y `Commerce`, campo `status` (TextChoices: PENDIENTE, CONFIRMADO, EN_PREPARACION, EN_CAMINO, ENTREGADO, CANCELADO), `total` (DecimalField), `notes`, `via_runners` (BooleanField, default True).
- Modelo `OrderItem`: FK a `Order` y `Product`, campos `quantity`, `unit_price` (precio al momento del pedido). Propiedad calculada `subtotal = unit_price * quantity`.
- `OrderCreateSerializer` (Serializer puro) en `apps/store/serializers.py`: recibe `commerce_id`, `items` (lista de {product, quantity}) y `notes` opcional. Valida que haya al menos un ítem, que el comercio esté activo, que cada producto esté disponible. Crea `Order` + `OrderItem`s y calcula el total con `order.calculate_total()`.
- `OrderCreateView` (CreateAPIView, permiso `IsAuthenticated`): `POST /api/v1/store/orders/create/`.
- El campo `via_runners = True` se establece automáticamente en la creación para garantizar trazabilidad.

**Frontend:**
- `CartContext.jsx` en `src/context/CartContext.jsx`: estado global del carrito con funciones `addItem`, `removeItem`, `updateQuantity`, `clearCart`. Calcula `total` como suma de `price * quantity`. Si se agregan productos de un comercio diferente, vacía el carrito automáticamente.
- `ComercioDetail.jsx`: grid de 2 columnas — productos a la izquierda, carrito a la derecha. Cada `ProductCard` tiene botón "Agregar" que llama `addItem(product, commerce_id)`.
- Componente `Cart.jsx` muestra los ítems del carrito con controles de cantidad, subtotal por ítem, total general y botón "Realizar Pedido".
- Al confirmar, `handleCheckout` hace `POST /api/v1/store/orders/create/` con `commerce_id`, `items` (array de {product: id, quantity}) y `notes`. Si tiene éxito muestra mensaje verde "¡Pedido realizado exitosamente!" y limpia el carrito.

---

**HU-08 – Historial de pedidos**

*Como cliente, quiero ver el historial de mis pedidos con sus estados, para llevar un registro de mis compras.*

**Descripción:** El usuario autenticado puede ver todos sus pedidos ordenados por fecha, con el detalle de cada ítem, estado visual diferenciado por color y el total de cada pedido.

**Backend:**
- `OrderListView` (ListAPIView, permiso `IsAuthenticated`): si el usuario es ADMIN retorna todos los pedidos (con filtro opcional `?commerce=`), si es otro rol retorna solo los pedidos del usuario (`client=user`). Acepta filtro `?status=`.
- `OrderSerializer` en `apps/store/serializers.py`: incluye `items` (OrderItemSerializer anidado con `product_name` y `subtotal`), `client_name`, `commerce_name`, `status`, `total`, `via_runners`, `created_at`.
- Endpoint: `GET /api/v1/store/orders/`, `GET /api/v1/store/orders/{id}/`.

**Frontend:**
- Página `OrderHistory.jsx` en `src/pages/store/OrderHistory.jsx`: al montar hace `GET /api/v1/store/orders/` y muestra la lista de pedidos.
- Cada pedido muestra: número de pedido, estado con badge de color (verde para ENTREGADO, rojo para CANCELADO, amarillo para otros), nombre del comercio, fecha formateada en español colombiano, lista de ítems con nombre, cantidad y subtotal, y total general en negrita.
- Si no hay pedidos muestra "No tienes pedidos aún".
- Ruta: `/orders` (protegida, requiere autenticación).

---

**MÓDULO 3: Servicios**

---

**HU-09 – Registro de prestador**

*Como usuario, quiero registrarme como prestador de servicio cargando mi hoja de vida y aceptando los términos, para ofrecer mis servicios a través de la plataforma.*

**Descripción:** Un usuario registrado puede crear un perfil de prestador seleccionando una categoría de servicio, escribiendo una descripción, cargando su hoja de vida (PDF/imagen) y aceptando los términos y condiciones. El perfil queda en estado PENDIENTE hasta que un administrador lo apruebe.

**Backend:**
- Modelo `ServiceCategory` en `apps/services/models.py`: `name` (único), `description`, `is_active`.
- Modelo `ServiceProvider`: OneToOneField a `User`, FK a `ServiceCategory`, campos `description`, `resume` (FileField, upload_to `services/resumes/`), `terms_accepted`, `status` (DISPONIBLE/OCUPADO/INACTIVO, default INACTIVO), `approval_status` (PENDIENTE/APROBADO/RECHAZADO, default PENDIENTE), `rejection_reason`, `approved_by` (FK a User, nullable), `approved_at`.
- `ServiceProviderRegisterSerializer`: campos `category`, `description`, `resume`, `terms_accepted`. Valida que `terms_accepted = True` (si no, rechaza con error "Debes aceptar los términos y condiciones"). Crea el `ServiceProvider` asociado al usuario del request.
- `RegisterAsProviderView` (CreateAPIView, permiso `IsAuthenticated`): en `perform_create`, después de guardar el perfil, actualiza `user.role = 'PRESTADOR'`.
- Endpoint: `POST /api/v1/services/providers/register/` (multipart/form-data para el archivo).

**Frontend:**
- Función `registerAsProvider(formData)` en `src/api/servicesApi.js`: envía `POST` con `Content-Type: multipart/form-data` para soportar la carga del archivo de hoja de vida.
- La interfaz de registro de prestador se gestiona desde las páginas de servicios. El formulario solicita categoría, descripción, archivo de hoja de vida y checkbox de aceptación de términos.

---

**HU-10 – Aprobación de prestador**

*Como administrador, quiero aprobar o rechazar perfiles de prestadores con motivo, para asegurar la calidad de los servicios ofrecidos.*

**Descripción:** El administrador revisa los perfiles de prestadores en estado PENDIENTE. Puede aprobarlos (cambiándolos a APROBADO y DISPONIBLE) o rechazarlos (con motivo de rechazo).

**Backend:**
- Función `approve_provider(request, pk)` decorada con `@api_view(['POST'])` y `@permission_classes([IsAdmin])` en `apps/services/views.py`.
- Recibe `action` en el body: si es `"approve"` → actualiza `approval_status = APROBADO`, `status = DISPONIBLE`, registra `approved_by` y `approved_at`. Si es `"reject"` → actualiza `approval_status = RECHAZADO` y guarda `rejection_reason`.
- Retorna el perfil actualizado con `ServiceProviderSerializer`.
- Endpoint: `POST /api/v1/services/providers/{id}/approve/`.

**Frontend:**
- Función `approveProvider(id, data)` en `src/api/servicesApi.js`: envía `POST` con `{ action: "approve" }` o `{ action: "reject", reason: "..." }`.
- Página placeholder `ManageProviders.jsx` preparada para la interfaz de gestión completa. Actualmente la aprobación se puede hacer desde el panel Django Admin o via API con Postman.

---

**HU-11 – Buscar servicio por categoría**

*Como cliente, quiero buscar prestadores de servicio por categoría, para encontrar al profesional que necesito.*

**Descripción:** El cliente navega las categorías de servicio disponibles (plomería, contabilidad, medicina, etc.) y al seleccionar una ve la lista de prestadores aprobados y disponibles en esa categoría.

**Backend:**
- `ServiceCategoryListView` (ListCreateAPIView, permiso `IsAdminOrReadOnly`): retorna categorías activas. `GET /api/v1/services/categories/`.
- `ServiceProviderListView` (ListAPIView, permiso `IsAuthenticated`): filtra proveedores con `approval_status = APROBADO` y `status = DISPONIBLE`. Acepta query param `?category=` para filtrar por categoría.
- `ServiceProviderSerializer`: incluye `user_info` (UserProfileSerializer anidado con nombre, email, teléfono), `category_name`, `description`, `resume`, `status`, `approval_status`.
- Endpoint: `GET /api/v1/services/providers/?category={id}`.

**Frontend:**
- Página `ServicesPage.jsx` en `src/pages/services/ServicesPage.jsx`: al montar carga categorías con `getServiceCategories()`. Muestra grid de tarjetas de categoría usando `ServiceCard.jsx`.
- Al hacer clic en una categoría, llama `getProviders({ category: catId })` y muestra las tarjetas de prestadores con `ProviderCard.jsx`.
- Botón "← Volver a categorías" para regresar a la vista de categorías.
- Si no hay prestadores disponibles muestra "Sin prestadores disponibles en este momento".

---

**HU-12 – Solicitar servicio**

*Como cliente, quiero solicitar un servicio a un prestador disponible, para que Runners intermedie la conexión.*

**Descripción:** Desde la tarjeta del prestador, el cliente puede solicitar un servicio describiendo brevemente lo que necesita. El sistema registra la solicitud y Runners queda como intermediaria.

**Backend:**
- Modelo `ServiceRequest` en `apps/services/models.py`: FK a `User` (client), `ServiceProvider`, `ServiceCategory`, campos `description`, `status` (REGISTRADA/ASIGNADA/EN_PROCESO/COMPLETADA/CANCELADA), `provider_fee`, `runners_fee`, `client_total`.
- `ServiceRequestCreateView` (CreateAPIView, permiso `IsAuthenticated`): en `perform_create` asigna `client = request.user`. Endpoint: `POST /api/v1/services/requests/create/`.
- `ServiceRequestListView` (ListAPIView): ADMIN ve todas, PRESTADOR ve las asignadas a él, CLIENTE ve las propias. Endpoint: `GET /api/v1/services/requests/`.

**Frontend:**
- En `ServicesPage.jsx`, cada `ProviderCard` tiene botón "Solicitar servicio". Al hacer clic, `handleRequest(provider)` abre un `prompt()` pidiendo la descripción del servicio.
- Envía `POST /api/v1/services/requests/create/` con `{ provider: id, category: id, description }`.
- Si tiene éxito muestra mensaje verde: "Solicitud enviada a {nombre}. Runners será intermediaria del contacto."
- Función `createServiceRequest(data)` en `src/api/servicesApi.js`.

---

**HU-13 – Cambiar estado de prestador**

*Como prestador, quiero cambiar mi estado (Disponible/Ocupado/Inactivo), para que los clientes sepan si puedo atenderlos.*

**Descripción:** El prestador aprobado puede alternar su estado de disponibilidad. Solo los prestadores con estado DISPONIBLE aparecen en las búsquedas de los clientes.

**Backend:**
- `ProviderStatusView` (UpdateAPIView, permiso `IsPrestador`) en `apps/services/views.py`: obtiene el `ServiceProvider` del usuario autenticado y actualiza su `status`. Valida que el nuevo estado sea uno de los permitidos (DISPONIBLE, OCUPADO, INACTIVO).
- Endpoint: `PATCH /api/v1/services/providers/status/` con body `{ "status": "DISPONIBLE" | "OCUPADO" | "INACTIVO" }`.

**Frontend:**
- Función `updateProviderStatus(status)` en `src/api/servicesApi.js`: envía `PATCH` al endpoint de estado.
- La interfaz de cambio de estado se integra en el perfil del prestador (página `ProviderProfile.jsx`, actualmente placeholder preparado para implementación completa).

---

**MÓDULO 4: Domicilios**

---

**HU-14 – Registro de domiciliario**

*Como administrador, quiero registrar domiciliarios con su nombre, teléfono, número asignado y tipo de trabajo, para que aparezcan en el módulo de domicilios.*

**Descripción:** El administrador crea perfiles de domiciliarios asignándoles un número único identificador y tipo de trabajo (independiente o con la empresa). El domiciliario queda activo y disponible para los clientes.

**Backend:**
- Modelo `Deliverer` en `apps/deliveries/models.py`: OneToOneField a `User`, `assigned_number` (PositiveIntegerField, unique), `status` (DISPONIBLE/OCUPADO/INACTIVO, default DISPONIBLE), `work_type` (INDEPENDIENTE/EMPRESA), `is_active`.
- Propiedad calculada `current_balance`: suma ingresos - egresos de los `FinancialRecord` asociados.
- `DelivererSerializer` en `apps/deliveries/views.py`: incluye `user_name`, `phone`, `balance` (current_balance).
- `DelivererCreateView` (CreateAPIView, permiso `IsAdmin`): `POST /api/v1/deliveries/deliverers/create/`.
- `DelivererListView` (ListAPIView, permiso `IsAuthenticated`): ADMIN ve todos los activos, otros roles solo ven los que están DISPONIBLES.

**Frontend:**
- Función `createDeliverer(data)` en `src/api/deliveriesApi.js`: envía `POST` para crear domiciliario.
- La creación se gestiona desde el panel Django Admin en esta versión. Endpoint disponible para integración futura.

---

**HU-15 – Cambiar estado domiciliario**

*Como domiciliario, quiero cambiar mi estado (Disponible/Ocupado/Inactivo), para controlar mi disponibilidad.*

**Descripción:** El domiciliario puede alternar entre estados DISPONIBLE, OCUPADO e INACTIVO mediante botones de color en su panel de control.

**Backend:**
- `DelivererStatusView` (UpdateAPIView, permiso `IsDomiciliario`) en `apps/deliveries/views.py`: obtiene el `Deliverer` del usuario autenticado. Valida que el nuevo estado sea uno de los permitidos y lo actualiza.
- Endpoint: `PATCH /api/v1/deliveries/deliverers/status/` con body `{ "status": "DISPONIBLE" | "OCUPADO" | "INACTIVO" }`.

**Frontend:**
- En `DeliveryDashboard.jsx`, tres botones de estado con colores diferenciados:
  - 🟢 **Disponible** (fondo verde `#dcfce7`, borde `#16a34a`)
  - 🟡 **Ocupado** (fondo amarillo `#fef3c7`, borde `#d97706`)
  - ⚫ **Inactivo** (fondo gris `#f3f4f6`, borde `#6b7280`)
- Al hacer clic, llama `updateDelivererStatus(status)` de `deliveriesApi.js` y muestra confirmación con `alert()`.

---

**HU-16 – Registrar ingreso**

*Como domiciliario, quiero registrar mis ingresos por servicios realizados, para llevar control de mis ganancias y la comisión de Runners.*

**Descripción:** El domiciliario registra cada servicio realizado con su valor. El sistema calcula automáticamente la comisión que corresponde a Runners según el porcentaje configurado en `SystemConfig`.

**Backend:**
- Modelo `FinancialRecord` en `apps/deliveries/models.py`: FK a `Deliverer`, `record_type` (INGRESO/EGRESO), `amount` (DecimalField), `description`, `runners_commission` (calculado automáticamente), `related_delivery` (FK nullable a DeliveryRequest).
- Modelo `SystemConfig`: `key` (único), `value`, `description`. El porcentaje de comisión se almacena con key `runners_commission_pct`.
- `FinancialRecordListCreateView` (ListCreateAPIView, permiso `IsAuthenticated`): en `perform_create`, obtiene el `Deliverer` del usuario, lee el porcentaje de comisión de `SystemConfig` (default 10%), y calcula `runners_commission = amount * pct / 100` solo si es INGRESO (para EGRESO la comisión es 0).
- Endpoint: `POST /api/v1/deliveries/records/` con body `{ "record_type": "INGRESO", "amount": 50000, "description": "Domicilio restaurante X" }`.

**Frontend:**
- En `DeliveryDashboard.jsx`, formulario de registro con: select (Ingreso/Egreso), input numérico de valor (min=1), input de texto para descripción, y botón "Registrar".
- Al enviar, llama `createFinancialRecord(data)` de `deliveriesApi.js`. Después recarga la lista de registros.
- Panel de resumen con 4 tarjetas de colores:
  - 💚 **Ingresos** (verde) — suma de todos los registros tipo INGRESO.
  - 🔴 **Egresos** (rojo) — suma de todos los registros tipo EGRESO.
  - 🔵 **Balance** (azul) — ingresos menos egresos.
  - 🟡 **Comisión Runners** (amarillo) — suma de `runners_commission` de todos los ingresos.

---

**HU-17 – Registrar egreso**

*Como domiciliario, quiero registrar mis egresos (gastos), para restar del balance y tener un control financiero completo.*

**Descripción:** El domiciliario registra gastos (gasolina, mantenimiento, etc.) que se restan de su balance. Los egresos no generan comisión para Runners.

**Backend:**
- Mismo modelo `FinancialRecord` y endpoint que HU-16. Cuando `record_type = "EGRESO"`, la comisión de Runners se establece en 0 automáticamente en `perform_create`.
- El balance se calcula dinámicamente con la propiedad `current_balance` del modelo `Deliverer`.

**Frontend:**
- Mismo formulario de `DeliveryDashboard.jsx`. El select permite elegir "Egreso". El color del registro en el historial cambia: fondo rojo `#fef2f2` para egresos vs fondo verde `#f0fdf4` para ingresos.
- Historial de movimientos: cada registro muestra tipo, descripción, monto con signo (+/-) y comisión (solo para ingresos). Los montos se formatean con `toLocaleString('es-CO')`.

---

**HU-18 – Solicitar domicilio**

*Como cliente, quiero ver los domiciliarios disponibles y solicitar uno directamente, para recibir un servicio de entrega.*

**Descripción:** El cliente ve la lista de domiciliarios con estado DISPONIBLE, con su nombre, teléfono y número asignado, y puede solicitar uno directamente.

**Backend:**
- `DelivererListView` retorna domiciliarios activos. Para clientes (no ADMIN), filtra solo los que tienen `status = DISPONIBLE`.
- Modelo `DeliveryRequest` en `apps/deliveries/models.py`: FK a `User` (client) y `Deliverer`, `description`, `status` (SOLICITADO/ACEPTADO/EN_CAMINO/ENTREGADO/CANCELADO).
- Endpoint: `GET /api/v1/deliveries/deliverers/`.

**Frontend:**
- Página `DeliveriesPage.jsx` en `src/pages/deliveries/DeliveriesPage.jsx`: al montar carga domiciliarios con `getDeliverers()`. Muestra grid de tarjetas usando `DeliveryCard.jsx`.
- Cada `DeliveryCard` muestra: número asignado, nombre, teléfono, estado y tipo de trabajo. Incluye botón "Solicitar".
- Al hacer clic en "Solicitar", `handleRequest(deliverer)` muestra un `alert()` indicando que Runners coordinará el servicio.
- Si no hay domiciliarios disponibles muestra "Sin domiciliarios disponibles."

---

**MÓDULO 5: Contactos**

---

**HU-19 – Registrar contacto**

*Como administrador, quiero registrar contactos de emergencia y profesionales en el directorio, para que los clientes puedan consultarlos.*

**Descripción:** El administrador registra contactos con nombre, teléfono, descripción, tipo (Emergencia, Profesional, Comercio, Otro) y estado de disponibilidad.

**Backend:**
- Modelo `Contact` en `apps/contacts/models.py`: `name`, `phone`, `description`, `contact_type` (TextChoices: EMERGENCIA/PROFESIONAL/COMERCIO/OTRO), `availability` (EN_SERVICIO/FUERA_DE_SERVICIO), `is_active`.
- `ContactSerializer` en `apps/contacts/views.py` con todos los campos.
- `ContactListView` (ListCreateAPIView, permiso `IsAdminOrReadOnly`): todos los autenticados pueden leer (GET), solo ADMIN puede crear (POST). Incluye `SearchFilter` y `OrderingFilter` de DRF como filter backends.
- Endpoint: `POST /api/v1/contacts/` con body `{ "name": "...", "phone": "...", "description": "...", "contact_type": "EMERGENCIA", "availability": "EN_SERVICIO" }`.

**Frontend:**
- Función `createContact(data)` en `src/api/contactsApi.js`: envía `POST` para crear contacto.
- La creación de contactos se gestiona desde el panel Django Admin en esta versión. Endpoint disponible para integración frontend futura.

---

**HU-20 – Buscar contacto**

*Como cliente, quiero buscar contactos por nombre o categoría, para encontrar rápidamente el número que necesito.*

**Descripción:** El cliente puede buscar contactos por texto libre (nombre, descripción, teléfono) y filtrar por tipo de contacto. La búsqueda es en tiempo real conforme se escribe.

**Backend:**
- `ContactListView` en `apps/contacts/views.py` con:
  - `filter_backends = [SearchFilter, OrderingFilter]`
  - `search_fields = ['name', 'description', 'phone']` — búsqueda de texto libre.
  - Query param `?type=EMERGENCIA` para filtrar por tipo de contacto.
  - Query param `?search=texto` para búsqueda por nombre, descripción o teléfono.
- Endpoint: `GET /api/v1/contacts/?search=bomberos&type=EMERGENCIA`.

**Frontend:**
- Página `ContactsPage.jsx` en `src/pages/contacts/ContactsPage.jsx` con barra de búsqueda y filtros.
- Input de texto con placeholder "🔍 Buscar por nombre o teléfono..." que actualiza el estado `search`. Cada cambio dispara un `useEffect` que recarga los contactos con los parámetros actuales.
- Select de tipo de contacto: "Todos los tipos", Emergencia, Profesional, Comercio, Otro.
- Muestra grid de tarjetas usando componente `ContactCard.jsx` con nombre, teléfono, descripción y tipo.
- Si no hay resultados muestra "Sin resultados para tu búsqueda."

---

**HU-21 – Filtrar por disponibilidad**

*Como cliente, quiero filtrar contactos por su estado de disponibilidad (En servicio / Fuera de servicio), para saber quién puede atenderme.*

**Descripción:** Además de la búsqueda por texto y tipo, el cliente puede filtrar contactos por su estado de disponibilidad actual.

**Backend:**
- En `ContactListView`, se filtra por query param `?availability=EN_SERVICIO` o `?availability=FUERA_DE_SERVICIO`.
- El filtrado se implementa en `get_queryset()`: `queryset.filter(availability=availability)`.

**Frontend:**
- En `ContactsPage.jsx`, tercer select de filtro: "Todas las disponibilidades", "En Servicio", "Fuera de Servicio".
- El cambio actualiza el estado `filterAvailability`, que dispara el `useEffect` para recargar contactos con `getContacts({ search, type, availability })`.
- Los tres filtros (búsqueda de texto, tipo y disponibilidad) se combinan y envían como query params simultáneamente.

---

**MÓDULO 6: Administración y Reportes**

---

**HU-22 – Panel de administración**

*Como administrador, quiero ver un dashboard con resumen de usuarios activos, pedidos pendientes y prestadores en espera de aprobación, para gestionar la plataforma eficientemente.*

**Descripción:** El dashboard centraliza las métricas clave de la plataforma en tarjetas visuales y ofrece accesos rápidos a cada módulo de gestión.

**Backend:**
- Función `dashboard_summary(request)` en `apps/reports/views.py` decorada con `@api_view(['GET'])` y `@permission_classes([IsAdmin])`.
- Retorna JSON con:
  - `users`: total activos, clientes, prestadores, domiciliarios (conteos con `User.objects.filter()`).
  - `orders`: total, pendientes, entregados.
  - `providers_pending_approval`: conteo de `ServiceProvider` con `approval_status = PENDIENTE`.
  - `deliverers_available`: conteo de `Deliverer` con `status = DISPONIBLE` y `is_active = True`.
- Endpoint: `GET /api/v1/reports/dashboard/`.

**Frontend:**
- Página `AdminDashboard.jsx` en `src/pages/admin/AdminDashboard.jsx`: ruta `/admin` protegida con `roles={['ADMIN']}`.
- Al montar hace `GET /api/v1/reports/dashboard/` y muestra 9 tarjetas `SummaryCard` con colores diferenciados:
  - Usuarios activos (azul), Clientes (verde), Prestadores (naranja), Domiciliarios (púrpura).
  - Pedidos totales (azul oscuro), Pedidos pendientes (rojo), Pedidos entregados (verde).
  - Prestadores pendientes (naranja oscuro), Domiciliarios disponibles (cyan).
- Cada tarjeta muestra un número grande con color y un título descriptivo.
- Sección "Gestión" con 6 enlaces `AdminLink` a: Gestionar Usuarios, Gestionar Tienda, Gestionar Servicios, Gestionar Domicilios, Gestionar Contactos, Historial de Ventas.

---

**HU-23 – Suspender/activar usuario**

*Como administrador, quiero activar o suspender usuarios, para controlar el acceso a la plataforma.*

**Descripción:** El administrador puede alternar el estado activo/inactivo de cualquier usuario excepto su propia cuenta. Los usuarios suspendidos no pueden iniciar sesión.

**Backend:**
- Función `toggle_user_status(request, pk)` en `apps/users/views.py` decorada con `@api_view(['POST'])` y `@permission_classes([IsAdmin])`.
- Busca al usuario por PK. Si el admin intenta suspenderse a sí mismo, retorna error 400: "No puedes suspenderte a ti mismo."
- Invierte `user.is_active` (True→False o False→True), guarda y retorna `{ message: "Usuario {activado|suspendido} exitosamente.", is_active: bool }`.
- `UserListView` (ListAPIView, permiso `IsAdmin`): lista todos los usuarios con filtros `?role=` y `?is_active=`. Endpoint: `GET /api/v1/auth/users/`.
- Endpoint toggle: `POST /api/v1/auth/users/{id}/toggle-status/`.

**Frontend:**
- Página placeholder `ManageUsers.jsx` preparada para implementación completa. La funcionalidad de suspender/activar está disponible vía API.
- El `AdminDashboard.jsx` tiene enlace "👥 Gestionar Usuarios" que redirige a la página de gestión.

---

**HU-24 – Reporte de ventas**

*Como administrador, quiero ver un reporte de ventas por período con desglose por comercio, para analizar el rendimiento de la tienda.*

**Descripción:** El administrador consulta las ventas realizadas en un período configurable, viendo el total de pedidos, ingresos totales y desglose por comercio.

**Backend:**
- Función `sales_report(request)` en `apps/reports/views.py` decorada con `@api_view(['GET'])` y `@permission_classes([IsAdmin])`.
- Acepta query param `?days=30` (default 30). Filtra pedidos desde `now - days`.
- Usa aggregations de Django: `Order.objects.filter(created_at__gte=since).values('commerce__name').annotate(order_count=Count('id'), total_sales=Sum('total')).order_by('-total_sales')`.
- Retorna: `{ period_days, total_orders, total_revenue, by_commerce: [{commerce__name, order_count, total_sales}] }`.
- Endpoint: `GET /api/v1/reports/sales/?days=30`.

**Frontend:**
- Página placeholder `Reports.jsx` en `src/pages/admin/Reports.jsx` preparada para implementación completa de la interfaz de reportes.
- El endpoint está disponible para consulta vía API. El `AdminDashboard.jsx` tiene enlace "📋 Historial de Ventas" para navegación futura.

---

**HU-25 – Reporte de domiciliarios**

*Como administrador, quiero ver un reporte financiero de cada domiciliario (ingresos, egresos, balance, comisión Runners), para controlar las finanzas.*

**Descripción:** El administrador consulta el estado financiero de todos los domiciliarios activos, viendo ingresos, egresos, balance neto y la comisión total que cada domiciliario le debe a Runners.

**Backend:**
- Función `deliverers_report(request)` en `apps/reports/views.py` decorada con `@api_view(['GET'])` y `@permission_classes([IsAdmin])`.
- Itera sobre todos los `Deliverer` activos. Para cada uno consulta sus `FinancialRecord`:
  - `incomes` = suma de `amount` donde `record_type = INGRESO`.
  - `expenses` = suma de `amount` donde `record_type = EGRESO`.
  - `commissions` = suma de `runners_commission` donde `record_type = INGRESO`.
- Retorna array: `[{ deliverer: "nombre", number: N, incomes, expenses, balance, runners_total_commission }]`.
- Endpoint: `GET /api/v1/reports/deliverers/`.

**Frontend:**
- Página placeholder `Reports.jsx` preparada para implementación completa.
- El endpoint está disponible para consulta vía API con Postman o integración frontend futura.

---

### 14.4 Diseño relacional

**User:** id (PK), email (UK), first_name, last_name, phone, role, is_active, is_staff, date_joined, updated_at

**Category (Tienda):** id (PK), name (UK), description, icon, is_active, created_at

**Commerce:** id (PK), category_id (FK→Category), name, description, phone, address, image, is_active, created_at, updated_at

**Product:** id (PK), commerce_id (FK→Commerce), name, description, price, image, is_available, created_at, updated_at

**Order:** id (PK), client_id (FK→User), commerce_id (FK→Commerce), status, total, notes, via_runners, created_at, updated_at

**OrderItem:** id (PK), order_id (FK→Order), product_id (FK→Product), quantity, unit_price

**ServiceCategory:** id (PK), name (UK), description, is_active

**ServiceProvider:** id (PK), user_id (FK→User), category_id (FK→ServiceCategory), description, resume, terms_accepted, status, approval_status, rejection_reason, approved_by (FK→User), approved_at, created_at, updated_at

**ServiceRequest:** id (PK), client_id (FK→User), provider_id (FK→ServiceProvider), category_id (FK→ServiceCategory), description, status, provider_fee, runners_fee, client_total, created_at, updated_at

**Deliverer:** id (PK), user_id (FK→User), assigned_number (UK), status, work_type, is_active, created_at

**DeliveryRequest:** id (PK), client_id (FK→User), deliverer_id (FK→Deliverer), description, status, created_at, updated_at

**FinancialRecord:** id (PK), deliverer_id (FK→Deliverer), record_type, amount, description, runners_commission, related_delivery_id (FK→DeliveryRequest), created_at

**Contact:** id (PK), name, phone, description, contact_type, availability, is_active, created_at, updated_at

**SystemConfig:** id (PK), key (UK), value, description, updated_at

---

### 14.5 Diagrama de clases

Las clases principales del sistema se corresponden directamente con los modelos Django descritos en el diseño relacional. Cada modelo define sus campos, relaciones (ForeignKey, OneToOneField) y métodos de negocio como `calculate_total()` en Order, `current_balance` en Deliverer y `get_full_name()` en User.

---

### 14.6 Prototipado

Se desarrollarán prototipos para visualizar:

- Pantalla de login/registro.
- Página principal (Home) con acceso a todos los módulos.
- Módulo Tienda: comercios, productos, carrito.
- Módulo Servicios: categorías, prestadores, solicitud.
- Módulo Domicilios: lista de domiciliarios, dashboard financiero.
- Módulo Contactos: directorio con búsqueda y filtros.
- Panel de Administración: dashboard, gestión de usuarios, reportes.

---

## 15. Casos de uso (detallados)

**Actores:** Cliente (Usuario), Prestador de Servicio, Domiciliario, Administrador, Sistema (API).

### UC-01: Registrarse (Cliente)

**Precondición:** El usuario no está registrado.

**Flujo:**
1. El usuario accede a `/register`.
2. Completa el formulario (nombre, apellido, correo, teléfono, contraseña).
3. `POST /api/v1/auth/register/` → crea usuario con rol CLIENTE y genera JWT.
4. El usuario es redirigido al Home autenticado.

**Excepciones:** Email ya usado, validaciones fallidas.

### UC-02: Iniciar sesión (Cliente)

**Precondición:** Cuenta existente y activa.

**Flujo:**
1. `POST /api/v1/auth/login/` → obtiene access_token y refresh_token.
2. `GET /api/v1/auth/profile/` → carga perfil del usuario.
3. Redirige según rol.

**Excepciones:** Credenciales inválidas, cuenta suspendida.

### UC-03: Ver comercios y productos (Cliente)

**Flujo:**
1. `GET /api/v1/store/commerces/` → lista comercios activos.
2. `GET /api/v1/store/commerces/{id}/` → detalle con productos.

### UC-04: Crear pedido (Cliente)

**Flujo:**
1. El cliente agrega productos al carrito (CartContext).
2. `POST /api/v1/store/orders/create/` → crea Order con OrderItems.
3. El sistema calcula el total y registra `via_runners = True`.

**Excepciones:** Producto no disponible al confirmar.

### UC-05: Buscar y solicitar servicio (Cliente)

**Flujo:**
1. `GET /api/v1/services/categories/` → lista categorías.
2. `GET /api/v1/services/providers/?category=X` → prestadores disponibles.
3. `POST /api/v1/services/requests/create/` → crea solicitud.

### UC-06: Registrarse como prestador (Usuario)

**Flujo:**
1. `POST /api/v1/services/providers/register/` → crea perfil con estado PENDIENTE.
2. El sistema actualiza el rol del usuario a PRESTADOR.

### UC-07: Aprobar prestador (Admin)

**Flujo:**
1. `POST /api/v1/services/providers/{id}/approve/` con `action: "approve"` o `"reject"`.
2. El sistema actualiza `approval_status` y `status`.

### UC-08: Solicitar domiciliario (Cliente)

**Flujo:**
1. `GET /api/v1/deliveries/deliverers/` → lista domiciliarios disponibles.
2. El cliente selecciona uno y coordina directamente.

### UC-09: Registrar ingreso/egreso (Domiciliario)

**Flujo:**
1. `POST /api/v1/deliveries/records/` → registra ingreso o egreso.
2. El sistema calcula automáticamente `runners_commission`.

### UC-10: Buscar contacto (Cliente)

**Flujo:**
1. `GET /api/v1/contacts/?search=X&type=EMERGENCIA` → búsqueda filtrada.

### UC-11: Gestionar usuarios (Admin)

**Flujo:**
1. `GET /api/v1/auth/users/` → lista todos los usuarios con filtros.
2. `POST /api/v1/auth/users/{id}/toggle-status/` → activar/suspender.

### UC-12: Ver reportes (Admin)

**Flujo:**
1. `GET /api/v1/reports/dashboard/` → resumen general.
2. `GET /api/v1/reports/sales/?days=30` → ventas por período.
3. `GET /api/v1/reports/deliverers/` → reporte financiero de domiciliarios.

---

## 16. Estructura de carpetas

### 16.1 Backend (Django)

```
backend/
├── manage.py
├── requirements.txt
├── .env
├── .env.example
├── runners_project/              # Configuración global
│   ├── __init__.py
│   ├── settings/
│   │   ├── __init__.py
│   │   ├── base.py
│   │   ├── development.py
│   │   └── production.py
│   ├── urls.py
│   ├── wsgi.py
│   └── asgi.py
├── apps/
│   ├── users/
│   │   ├── models.py
│   │   ├── serializers.py
│   │   ├── views.py
│   │   ├── urls.py
│   │   ├── permissions.py
│   │   ├── admin.py
│   │   └── tests.py
│   ├── store/
│   │   ├── models.py
│   │   ├── serializers.py
│   │   ├── views.py
│   │   ├── urls.py
│   │   ├── admin.py
│   │   └── tests.py
│   ├── services/
│   │   ├── models.py
│   │   ├── serializers.py
│   │   ├── views.py
│   │   ├── urls.py
│   │   ├── admin.py
│   │   └── tests.py
│   ├── deliveries/
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── urls.py
│   │   ├── admin.py
│   │   └── tests.py
│   ├── contacts/
│   │   ├── models.py
│   │   ├── views.py
│   │   ├── urls.py
│   │   ├── admin.py
│   │   └── tests.py
│   └── reports/
│       ├── views.py
│       ├── urls.py
│       └── tests.py
├── media/
└── db.sqlite3
```

### 16.2 Frontend (React + Vite)

```
frontend/
├── package.json
├── vite.config.js
├── eslint.config.js
├── index.html
├── .env
├── .env.example
└── src/
    ├── main.jsx
    ├── App.jsx
    ├── api/
    │   ├── axiosConfig.js
    │   ├── authApi.js
    │   ├── storeApi.js
    │   ├── servicesApi.js
    │   ├── deliveriesApi.js
    │   └── contactsApi.js
    ├── context/
    │   ├── AuthContext.jsx
    │   └── CartContext.jsx
    ├── hooks/
    │   ├── useAuth.js
    │   └── useCart.js
    ├── components/
    │   ├── common/
    │   │   ├── Navbar.jsx
    │   │   ├── Footer.jsx
    │   │   ├── ProtectedRoute.jsx
    │   │   ├── LoadingSpinner.jsx
    │   │   └── ErrorMessage.jsx
    │   ├── store/
    │   │   ├── ProductCard.jsx
    │   │   ├── Cart.jsx
    │   │   └── CategoryFilter.jsx
    │   ├── services/
    │   │   ├── ServiceCard.jsx
    │   │   └── ProviderCard.jsx
    │   ├── deliveries/
    │   │   └── DeliveryCard.jsx
    │   └── contacts/
    │       └── ContactCard.jsx
    ├── pages/
    │   ├── Home.jsx
    │   ├── Login.jsx
    │   ├── Register.jsx
    │   ├── store/
    │   │   ├── StorePage.jsx
    │   │   ├── ComercioDetail.jsx
    │   │   └── OrderHistory.jsx
    │   ├── services/
    │   │   ├── ServicesPage.jsx
    │   │   ├── ServiceDetail.jsx
    │   │   └── ProviderProfile.jsx
    │   ├── deliveries/
    │   │   ├── DeliveriesPage.jsx
    │   │   └── DeliveryDashboard.jsx
    │   ├── contacts/
    │   │   └── ContactsPage.jsx
    │   └── admin/
    │       ├── AdminDashboard.jsx
    │       ├── ManageUsers.jsx
    │       ├── ManageProviders.jsx
    │       ├── ManageStore.jsx
    │       └── Reports.jsx
    ├── router/
    │   └── AppRouter.jsx
    └── assets/
        └── logo.svg
```

---

## 17. Plan de Gestión de Riesgos

### 17.1 Introducción

Esta sección establece las estrategias, procedimientos y responsabilidades necesarias para identificar, analizar, mitigar y controlar los riesgos asociados al proyecto Runners. Busca garantizar que las posibles amenazas al desarrollo sean gestionadas de manera proactiva.

#### 17.1.1 Propósito

Definir la metodología y las acciones que se implementarán para gestionar los riesgos del proyecto Runners, garantizando que el equipo esté preparado para responder de manera oportuna ante cualquier evento que pueda afectar el cronograma, la calidad o el alcance del sistema.

#### 17.1.2 Alcance

Este plan abarca todos los riesgos identificados durante el ciclo de vida del proyecto Runners, incluyendo las fases de análisis, diseño, desarrollo, pruebas y despliegue. Se aplica a todo el equipo de trabajo, herramientas tecnológicas utilizadas, procesos de comunicación y gestión interna del proyecto.

#### 17.1.3 Definiciones, Acrónimos y Abreviaturas

- **JWT:** JSON Web Token
- **DRF:** Django REST Framework
- **SPA:** Single Page Application
- **CORS:** Cross-Origin Resource Sharing
- **API:** Application Programming Interface
- **CRUD:** Create, Read, Update, Delete

#### 17.1.4 Referencias

- runners_guia_implementacion.md — Guía técnica del proyecto.
- README.md — Instrucciones de instalación y uso.

#### 17.1.5 Descripción general

Este plan se organiza en:

- **Resumen de riesgos:** Lista priorizada.
- **Tareas de gestión:** Identificación, análisis y mitigación.
- **Responsabilidades:** Roles del equipo.
- **Presupuesto:** Asignación para contingencias.
- **Herramientas:** Software de seguimiento.

---

## 18. Tareas de Gestión de Riesgos

- **Identificación:** Brainstorming con equipo y stakeholders.
- **Análisis:** Matriz de probabilidad/impacto (escala 1-5).
- **Priorización:** Riesgos con puntuación ≥ 8 se gestionan primero.

---

## 19. Organización y Responsabilidades

- **Líder del Proyecto (Integrante 1):** Responsable de coordinar las actividades generales del proyecto, asegurar el cumplimiento del plan de gestión de riesgos y tomar decisiones frente a riesgos críticos. Supervisa la correcta implementación de los planes de mitigación.

- **Gestores de Riesgo (Integrante 2 e Integrante 3):** Encargados de identificar, analizar y documentar los riesgos potenciales. También son responsables de actualizar la matriz de riesgos, proponer controles y escalar situaciones críticas al líder.

- **Equipo Técnico (todos los miembros):** Participa en la detección temprana de riesgos técnicos relacionados con software, hardware o falta de capacitación. Debe documentar sus avances y reportar cualquier anomalía.

- **Comité de Revisión de Riesgos (equipo completo):** Realiza reuniones periódicas para revisar el estado de los riesgos, evaluar su evolución e implementar nuevas medidas.

---

## 20. Presupuesto

El proyecto se desarrolla en un contexto académico con recursos limitados. El presupuesto se destina principalmente a:

- Herramientas gratuitas (VS Code, Git, GitHub, Trello).
- Tiempo del equipo de desarrollo (3 integrantes × 4 meses).
- Infraestructura de desarrollo (equipos personales).
- Reserva para contingencias técnicas (reinstalación de software, migración de datos).

---

## 21. Herramientas y Técnicas

- **Seguimiento:** Trello para registro y seguimiento de riesgos y tareas.
- **Comunicación:** Reuniones semanales para revisión de avances y riesgos.
- **Control de versiones:** Git + GitHub para respaldo y colaboración.
- **Documentación:** Markdown (README.md, guía de implementación) para controles y lecciones aprendidas.

---

## 22. Elementos de Riesgo Por Gestionar

**Lista de riesgos claves:**

### Riesgo 1: Pérdida o ausencia de un integrante del equipo

**Riesgo:** Uno o más miembros del grupo deja de participar debido a enfermedad, abandono u otras causas.

**Ejemplo:** Un integrante clave del proyecto se enferma y no puede continuar con sus tareas.

**Control:**
- **Prevención:** Distribuir las tareas equitativamente y documentar avances de forma accesible para todos.
- **Mitigación:** Asignar roles con cierto grado de redundancia para que otro integrante pueda asumir tareas críticas.

---

### Riesgo 2: Pérdida o daño de dispositivos o archivos

**Riesgo:** Un integrante pierde su laptop o sufre daños en su dispositivo.

**Ejemplo:** Un fallo en el disco duro elimina información importante sin respaldo.

**Control:**
- **Prevención:** Realizar commits frecuentes a GitHub y backups en la nube.
- **Mitigación:** Utilizar herramientas colaborativas (GitHub, Google Drive) para evitar dependencia de un solo dispositivo.
- **Evitación:** No depender de un único dispositivo para almacenar información crítica.

---

### Riesgo 3: Falta de comunicación o conflictos en el equipo

**Riesgo:** Desacuerdos entre integrantes afectan el desarrollo del proyecto.

**Ejemplo:** Diferencias en la forma de trabajo generan malentendidos y retrasos.

**Control:**
- **Prevención:** Establecer reglas claras de comunicación y responsabilidades desde el inicio.
- **Mitigación:** Realizar reuniones periódicas para resolver conflictos a tiempo.

---

### Riesgo 4: Problemas con los plazos y la gestión del tiempo

**Riesgo:** El equipo no logra cumplir con las fechas de entrega.

**Ejemplo:** Se subestima el tiempo necesario para ciertas tareas, lo que retrasa todo el proyecto.

**Control:**
- **Prevención:** Elaborar un plan con tiempos organizados, dejando espacio para imprevistos.
- **Mitigación:** Hacer revisiones frecuentes del trabajo y ajustar según sea necesario.
- **Evitación:** No dejar tareas críticas para el último momento.

---

### Riesgo 5: Fallas técnicas o problemas con software/hardware

**Riesgo:** Problemas con software, servidores o herramientas utilizadas en el proyecto.

**Ejemplo:** Un software esencial deja de funcionar y no hay una alternativa inmediata.

**Control:**
- **Prevención:** Usar software confiable y actualizado (Django 5.2.6, React 19, Vite 7).
- **Mitigación:** Tener copias de seguridad y alternativas en caso de fallo.
- **Evitación:** No depender de herramientas sin soporte activo.

---

### Riesgo 6: Falta de capacitación del equipo

**Riesgo:** Los miembros del equipo no tienen las habilidades necesarias para cumplir con sus tareas.

**Ejemplo:** Un integrante no domina Django REST Framework o React.

**Control:**
- **Prevención:** Identificar competencias necesarias al inicio del proyecto.
- **Mitigación:** Documentar procedimientos clave para consulta rápida.
- **Evitación:** Capacitar al equipo en las tecnologías antes de iniciar el desarrollo.

---

### Riesgo 7: Cambios en los requisitos del proyecto

**Riesgo:** Modificaciones inesperadas en los objetivos o requisitos.

**Ejemplo:** Se solicitan nuevas funcionalidades que no estaban contempladas inicialmente.

**Control:**
- **Prevención:** Establecer un proceso formal para gestionar solicitudes de cambio.
- **Mitigación:** Mantener una reserva de tiempo para adaptarse a los ajustes.
- **Evitación:** Establecer acuerdos que limiten cambios después de una etapa definida.

---

### Riesgo 8: Falta de disponibilidad de herramientas o recursos

**Riesgo:** La ausencia de herramientas, software o recursos impide el avance.

**Ejemplo:** Una dependencia de npm o pip deja de estar disponible.

**Control:**
- **Prevención:** Verificar y asegurar la disponibilidad de las herramientas antes de iniciar.
- **Mitigación:** Tener herramientas o recursos alternativos disponibles.
- **Evitación:** Fijar versiones exactas en requirements.txt y package.json.

---

**Niveles de riesgo:**
🟢 Bajo (1-4) | 🟡 Medio (5-9) | 🟠 Alto (10-14) | 🔴 Muy alto (15-19) | 🔴 Extremo (20-25)

---

### Planificación del Tiempo

**Duración del Sprint:** 3 semanas (15 días hábiles)

**Capacidad del Equipo:**

Nuestro equipo está compuesto por 3 desarrolladores y cada desarrollador puede trabajar 40 hr/semana. La capacidad total por sprint es:

Capacidad total = 3 desarrolladores × 40 hr/semana × 3 semanas = 360 hr

Restando reuniones y revisiones:

Capacidad efectiva = 360 hr - 12 hr = 348 hr

**Estimación de historias de usuario:**

Convertimos puntos de historia a horas: 1 punto = 8 hr

Puntos totales disponibles por sprint = 348 hr / 8 hr ≈ 43 puntos

---

### Planificación de Sprints

| Sprint | Duración | Objetivo | HUs | Puntos |
|--------|----------|----------|-----|--------|
| Sprint 1 | 3 semanas | Infraestructura + Autenticación | HU-01, HU-02, HU-03, HU-04 + Config CORS, .env | 12 |
| Sprint 2 | 3 semanas | Módulo Tienda completo | HU-05, HU-06, HU-07, HU-08 | 14 |
| Sprint 3 | 3 semanas | Módulo Servicios completo | HU-09, HU-10, HU-11, HU-12, HU-13 | 15 |
| Sprint 4 | 3 semanas | Módulo Domicilios + Contactos | HU-14, HU-15, HU-16, HU-17, HU-18, HU-19, HU-20, HU-21 | 14 |
| Sprint 5 | 3 semanas | Admin + Reportes + Ajustes finales | HU-22, HU-23, HU-24, HU-25 + bugs + pruebas | 12 |

---

### Cronograma

**Historia: Como cliente quiero registrarme (HU-01)**
- Tareas:
  - Diseñar formulario de registro (4 hr)
  - Implementar modelo User personalizado con roles (8 hr)
  - Crear endpoint POST /api/v1/auth/register/ (4 hr)
  - Implementar página Register.jsx en frontend (4 hr)
  - Pruebas de funcionalidad (4 hr)

**Historia: Como cliente quiero iniciar sesión (HU-02)**
- Tareas:
  - Diseñar formulario de login (4 hr)
  - Configurar djangorestframework-simplejwt (4 hr)
  - Implementar página Login.jsx con AuthContext (8 hr)
  - Implementar interceptores Axios para refresh automático (4 hr)

**Historia: Como administrador quiero registrar comercios (HU-05)**
- Tareas:
  - Crear modelos Category y Commerce (4 hr)
  - Implementar serializers y vistas CRUD (8 hr)
  - Crear página ManageStore.jsx (8 hr)

**Historia: Como cliente quiero crear un pedido (HU-07)**
- Tareas:
  - Crear CartContext y componente Cart (8 hr)
  - Implementar endpoint POST /api/v1/store/orders/create/ (8 hr)
  - Integrar flujo completo frontend (8 hr)
  - Pruebas de creación de pedido (4 hr)

**Historia: Como usuario quiero registrarme como prestador (HU-09)**
- Tareas:
  - Crear modelos ServiceCategory y ServiceProvider (4 hr)
  - Implementar endpoint de registro con carga de archivo (8 hr)
  - Crear formulario de registro en frontend (8 hr)

**Historia: Como domiciliario quiero registrar ingresos (HU-16)**
- Tareas:
  - Crear modelo FinancialRecord y SystemConfig (4 hr)
  - Implementar cálculo automático de comisión (8 hr)
  - Crear DeliveryDashboard.jsx con formulario (8 hr)

**Historia: Como administrador quiero ver reportes (HU-24, HU-25)**
- Tareas:
  - Crear endpoints de dashboard, sales y deliverers (8 hr)
  - Implementar página Reports.jsx con gráficos (8 hr)
  - Pruebas de integración (4 hr)

---

## 23. Diagrama de paquetes

El sistema se organiza en los siguientes paquetes principales:

**Backend:**
- `runners_project` — Configuración global (settings, urls, wsgi, asgi)
- `apps.users` — Autenticación, registro, roles, permisos
- `apps.store` — Categorías, comercios, productos, pedidos
- `apps.services` — Categorías de servicio, prestadores, solicitudes
- `apps.deliveries` — Domiciliarios, solicitudes de domicilio, registros financieros
- `apps.contacts` — Directorio de contactos
- `apps.reports` — Dashboard, reportes de ventas y domiciliarios

**Frontend:**
- `api/` — Clientes HTTP (Axios) por módulo
- `context/` — Estado global (AuthContext, CartContext)
- `hooks/` — Custom hooks (useAuth, useCart)
- `components/` — Componentes reutilizables organizados por dominio
- `pages/` — Vistas principales por módulo
- `router/` — Configuración de rutas con protección por roles

---

## 24. Resultados Esperados de la Aplicación

La aplicación web desarrollada se proyecta como una solución integral para la intermediación de servicios, gestión de domicilios y comercio local en Caicedonia. Se espera que su implementación proporcione mejoras significativas en la operación de Runners.

### 1. Optimización del proceso de intermediación

El sistema debe permitir que los clientes puedan navegar comercios, solicitar servicios y contactar domiciliarios de manera rápida e intuitiva, eliminando la necesidad de listas manuales y llamadas telefónicas.

### 2. Incremento en la satisfacción del cliente

Gracias a la centralización de servicios en una sola plataforma, los usuarios tendrán acceso inmediato a comercios, profesionales verificados y domiciliarios disponibles, mejorando significativamente su experiencia.

### 3. Centralización de la información

Runners podrá mantener en un único sistema los datos de pedidos, servicios prestados, balances de domiciliarios y contactos de emergencia. Esto facilitará la toma de decisiones mediante los reportes del dashboard.

### 4. Reducción de errores humanos

La automatización del flujo de pedidos, el cálculo automático de comisiones y la gestión digital de perfiles eliminan errores frecuentes del registro manual.

### 5. Mayor alcance digital

El uso de una plataforma web accesible desde cualquier dispositivo permite que Runners amplíe su presencia digital y atienda más clientes sin incrementar proporcionalmente los recursos humanos.

### 6. Gestión eficiente de prestadores y domiciliarios

La aprobación digital de prestadores con hoja de vida y el control financiero automatizado de domiciliarios optimizan procesos que antes requerían seguimiento manual constante.

### 7. Trazabilidad completa

El campo `via_runners` en cada pedido y el registro de comisiones en `FinancialRecord` garantizan que Runners pueda demostrar el valor que aporta como intermediario.

### 8. Arquitectura escalable y mantenible

Gracias a la separación frontend/backend, al uso de Django REST Framework y React con Vite, el sistema puede crecer en funcionalidades sin comprometer el rendimiento.

---

## 25. Recomendaciones y Sugerencias a Futuro

Aunque la aplicación cumple con los requisitos establecidos en esta fase, se identifican oportunidades de mejora:

### 1. Implementar un sistema de pagos en línea real

Integrar pasarelas como MercadoPago, Nequi o PSE permitiría completar transacciones reales y automatizar cobros de comisiones. Esto requiere adecuarse a normas PCI DSS.

### 2. Desarrollar un módulo administrativo avanzado

Un dashboard completo con:
- Métricas de ventas y servicios más solicitados.
- Reportes automatizados exportables a CSV/PDF.
- Gestión avanzada de usuarios con auditoría.
- Control granular de roles y permisos.

### 3. Notificaciones en tiempo real

Implementar WebSockets (Django Channels) para:
- Actualización de estado de pedidos sin recargar página.
- Notificaciones instantáneas a domiciliarios y prestadores.
- Alertas al administrador de nuevos registros pendientes.

### 4. Aplicación móvil nativa o híbrida

Con la API ya desarrollada, sería viable construir aplicaciones para Android/iOS utilizando React Native o Flutter, ampliando el alcance de Runners.

### 5. Sistema de valoraciones y reseñas

Agregar un módulo que permita a los clientes calificar y reseñar comercios, prestadores y domiciliarios, mejorando la transparencia y la calidad del servicio.

### 6. Integración con sistemas externos

Conectar el sistema con:
- Software contable.
- Facturación electrónica (DIAN).
- Plataformas de marketing y mensajería (WhatsApp Business API).

### 7. Mejoras de rendimiento y arquitectura

Para una versión de producción escalada:
- Implementar caching (Redis).
- Migrar estáticos a un CDN.
- Contenerizar con Docker.
- Configurar CI/CD con GitHub Actions.

### 8. Geolocalización

Integrar mapas para:
- Ubicar comercios cercanos.
- Rastrear domiciliarios en tiempo real.
- Calcular costos de envío por distancia.

### 9. Auditoría, bitácoras y trazabilidad

Registrar todas las acciones del sistema (creación, modificación, eliminación) para mejorar seguridad, control y resolución de conflictos.

### 10. Verificación por correo electrónico

Agregar verificación de email al registro para garantizar la validez de las cuentas creadas.

---

## 26. Conclusiones

- La arquitectura propuesta (React + Vite frontend, Django + DRF backend) ofrece una base sólida y productiva para el desarrollo del sistema Runners.

- El modelo relacional diseñado es flexible y soporta los cuatro módulos principales: Tienda, Servicios, Domicilios y Contactos, con trazabilidad completa.

- El sistema de roles (CLIENTE, PRESTADOR, DOMICILIARIO, ADMIN) garantiza la seguridad y el control de acceso en cada módulo.

- El campo `via_runners = True` en todos los pedidos garantiza la trazabilidad de que la venta pasó por la plataforma.

- La comisión de Runners queda registrada en `FinancialRecord.runners_commission` pero su cobro es manual en esta versión.

- El Django Admin (`/admin`) sirve como respaldo administrativo durante el desarrollo.

- Para producción se recomienda: PostgreSQL, almacenamiento de media (S3), HTTPS, contenedores (Docker) y pruebas automatizadas continuas (CI/CD).

- Se recomienda completar prototipos de interfaz, afinar UX y realizar pruebas de integración antes del despliegue público.

---

## 27. Bibliografía

- Sommerville, I. (2016). *Ingeniería del Software*. Pearson.
- Pressman, R. (2015). *Ingeniería del Software: Un enfoque práctico*. McGraw-Hill.
- Django Software Foundation. *Django Documentation*. https://docs.djangoproject.com/
- Django REST Framework. *DRF Documentation*. https://www.django-rest-framework.org/
- JWT: *JWT.io* (introducción y buenas prácticas). https://jwt.io/
- React: *React Documentation*. https://react.dev/
- Vite: *Vite Documentation*. https://vite.dev/
- Ley 1581 de 2012. *Protección de Datos Personales*. Colombia.
- Ley 1266 de 2008. *Habeas Data*. Colombia.
