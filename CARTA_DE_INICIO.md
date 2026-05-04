# Carta de Inicio

**Proyecto:** Desarrollo de una Plataforma Móvil para la Gestión de Tienda, Servicios y Domicilios de la empresa Runners.

**Tipo de Proyecto:** Desarrollo de Sistema de Información (Aplicación Móvil con Backend).

## 1. Problema y Justificación

### 1.1 Planteamiento del Problema

La empresa Runners, dedicada a la prestación de servicios a domicilio y apoyo a comercios locales, actualmente gestiona sus operaciones de manera manual o mediante canales informales como llamadas telefónicas y mensajería directa. Esta situación genera:

*   Falta de control centralizado de pedidos.
*   Dificultad para llevar un registro de ventas.
*   Ausencia de seguimiento formal a prestadores de servicios y domiciliarios.
*   Escaso control financiero sobre los movimientos de los domiciliarios.
*   Ineficiencia en la gestión de la disponibilidad de servicios y personal.

Además, el crecimiento de la demanda ha superado la capacidad organizativa actual, lo que limita la escalabilidad del negocio y afecta la calidad del servicio ofrecido a la comunidad.

### 1.2 Justificación

Este proyecto da solución a la necesidad de ofrecer un sistema centralizado que no solo gestione pedidos de comercios locales, sino que también integre la intermediación de servicios profesionales, el control financiero de domiciliarios y un directorio de contactos en una sola plataforma móvil.

Con ello, se busca:

*   **Mejorar la experiencia del usuario:** Ofrecer acceso centralizado a comercios, servicios y domicilios desde una aplicación móvil intuitiva.
*   **Incrementar la competitividad de Runners:** Proporcionar herramientas digitales modernas que reemplacen los procesos manuales.
*   **Optimizar procesos internos:** Automatizar la gestión de pedidos, la aprobación de prestadores de servicios y el cálculo de balances de domiciliarios.
*   **Garantizar la trazabilidad:** Registrar cada transacción que pasa por la plataforma.
*   **Mejorar la seguridad:** Implementar autenticación por tokens (JWT) y un sistema de roles y permisos.
*   **Obtener datos valiosos:** Recopilar información sobre ventas, servicios y finanzas para la toma de decisiones.
*   **Escalar a futuro:** Sentar las bases para funcionalidades avanzadas como notificaciones push y geolocalización.

## 2. Propósitos y objetivos del proyecto

### 2.1 Propósito General

Diseñar e implementar una plataforma integral, compuesta por una **aplicación móvil (Flutter)** para los usuarios y un **sistema de backend (Django)** para la administración, que permita a Runners gestionar de manera eficiente sus operaciones de tienda, servicios y domicilios.

### 2.2 Objetivos del proyecto

**Objetivo General:**
Desarrollar en un período de 16 semanas una plataforma funcional que integre los módulos de Tienda, Servicios, Domicilios y Contactos, permitiendo automatizar al menos el 80% de los procesos operativos actuales de Runners.

**Objetivos Específicos:**

*   Elaborar la documentación del proyecto, incluyendo requerimientos funcionales y no funcionales.
*   Analizar las necesidades operativas y financieras de Runners para digitalizar sus procesos clave.
*   Diseñar la arquitectura del sistema, definiendo la API REST, el modelo de base de datos y la estructura de la aplicación móvil.
*   Diseñar las interfaces de usuario de la aplicación móvil, garantizando una experiencia intuitiva para clientes, domiciliarios, prestadores de servicio y administradores.
*   Desarrollar e implementar los módulos de Tienda, Servicios, Domicilios y Contactos.
*   Integrar el control financiero (ingresos/egresos) para los domiciliarios.
*   Realizar pruebas continuas para asegurar el correcto funcionamiento de cada módulo.
*   Ejecutar pruebas funcionales finales y realizar los ajustes necesarios.
*   Preparar la documentación técnica final y el manual de usuario.
*   Entregar el sistema implementado y funcional.

## 3. Alcance

### 3.1 Alcance Incluido

El proyecto contempla el desarrollo de una API REST y una aplicación móvil con los siguientes módulos:

*   **Módulo Tienda:**
    *   **Registro de Comercios (por Administrador):** El administrador del sistema es el encargado de registrar, actualizar y gestionar los restaurantes y almacenes afiliados.
    *   Catálogo de productos por comercio.
    *   Generación de pedidos por parte de los clientes.
    *   Historial de ventas y pedidos.

*   **Módulo Servicios:**
    *   **Registro de Prestadores (con aprobación):** Los usuarios pueden registrarse como prestadores de servicios, pero un administrador debe validar y aprobar su perfil para que queden activos en la plataforma.
    *   Búsqueda de servicios por categoría.
    *   Gestión de estado del prestador (activo/inactivo) por parte del administrador.

*   **Módulo Domicilios:**
    *   **Registro de Domiciliarios (con aprobación):** Los usuarios pueden registrarse como domiciliarios, pero un administrador debe aprobar su perfil y asignarles un número de identificación.
    *   Gestión de solicitudes de domicilio.
    *   Control de estado del domiciliario (disponible/ocupado).
    *   **Gestión Financiera:** Registro de ingresos y egresos para cada domiciliario, con cálculo automático de balance.

*   **Módulo Contactos:**
    *   Registro y gestión de un directorio de contactos de interés (emergencia, profesionales, etc.) por parte del administrador.
    *   Búsqueda de contactos por nombre o categoría.

*   **Componentes Técnicos:**
    *   Backend con API REST (Django REST Framework).
    *   Base de datos relacional.
    *   Sistema de autenticación basado en JWT.
    *   Gestión de roles (Administrador, Cliente, Prestador, Domiciliario).
    *   Aplicación móvil para Android (Flutter).

### 3.2 Alcance Excluido

*   Pasarela de pagos real (los pagos se gestionan por fuera de la app).
*   Aplicación móvil para iOS (aunque Flutter lo facilita, el foco es Android).
*   Integración con GPS en tiempo real para seguimiento de domiciliarios.
*   Sistema de notificaciones push avanzado.
*   Despliegue en servidores de producción en la nube (se ejecuta en entorno local).

## 4. Recursos y Presupuestos

### 4.1 Recursos Humanos

*   **Estudiante desarrollador:** Responsable del análisis, diseño, desarrollo y pruebas.
*   **Empresa Runners:** Cliente, fuente de requisitos y validador del producto.

### 4.2 Recursos Tecnológicos

*   **Hardware:** Computador personal.
*   **Software y Frameworks:**
    *   **Backend:** Python, Django, Django REST Framework.
    *   **Frontend:** Dart, Flutter.
    *   **Base de Datos:** SQLite (para desarrollo).
    *   **Control de Versiones:** Git, GitHub.
    *   **Entorno de Desarrollo:** Visual Studio Code.

### 4.3 Presupuesto Estimado

Dado que es un proyecto académico, no se contemplan costos monetarios directos. El valor principal es el tiempo y la dedicación académica invertidos. Se utilizará software de código abierto y gratuito.

## 5. Riesgos

| Riesgo                                | Impacto | Mitigación                                                 |
| ------------------------------------- | ------- | ---------------------------------------------------------- |
| Retrasos en el desarrollo             | Medio   | Planificación semanal (sprints) y control de avances.      |
| Falta de definición clara de requisitos | Alto    | Validación temprana y continua con la empresa.             |
| Problemas técnicos inesperados        | Medio   | Investigación, pruebas unitarias y de integración.         |
| Limitaciones de tiempo académico      | Alto    | Priorización de funcionalidades clave (MVP).               |

## 6. Tiempo del proyecto

*   **Duración total:** 4 meses (16 semanas).
*   **Distribución general:**
    *   **Semanas 1–3:** Análisis, Diseño de Arquitectura y UI/UX.
    *   **Semanas 4–8:** Desarrollo del Backend (API REST) y Módulo de Tienda.
    *   **Semanas 9–10:** Desarrollo del Módulo de Servicios.
    *   **Semanas 11–13:** Desarrollo del Módulo de Domicilios y Contactos.
    *   **Semanas 14-16:** Pruebas de integración, ajustes finales y documentación.

## 7. Partes Interesadas (stakeholders)

### 7.1 Internos

*   Estudiante desarrollador.
*   Docentes y jurados evaluadores.

### 7.2 Externos

*   Empresa Runners (propietarios y administradores).
*   Comerciantes afiliados.
*   Prestadores de servicios.
*   Domiciliarios.
*   Clientes finales de la comunidad.

## DECLARACIÓN DE AUTORIZACIÓN

El presente documento establece formalmente el inicio del proyecto de grado **“Desarrollo de Plataforma Móvil Integral Runners”**, definiendo su propósito, alcance, recursos y planificación. Su aprobación autoriza el inicio de las actividades de análisis, diseño e implementación conforme a los objetivos establecidos.