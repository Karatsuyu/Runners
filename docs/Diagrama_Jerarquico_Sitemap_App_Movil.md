# DIAGRAMA JERÁRQUICO (SITEMAP) — APLICACIÓN MÓVIL

---

**NOMBRE DE LA APP:** RUNNERS — Servicios, Domicilios y Comercio Local

**BREVE DESCRIPCIÓN:** Aplicación móvil de intermediación que conecta a la comunidad de Caicedonia, Valle del Cauca, con comercios locales (restaurantes, almacenes), prestadores de servicios profesionales (albañiles, contadores, doctores), domiciliarios y un directorio de contactos de emergencia. La app consume la misma API REST (Django/DRF) que la versión web, adaptando la experiencia a dispositivos móviles con navegación por tabs y pantallas nativas.

---

## 🔓 ZONA PÚBLICA (Sin login)

```
RUNNERS APP
│
├── 📱 Splash Screen (Logo animado de Runners + carga)
│
├── 🔑 Inicio de Sesión
│   ├── Campos: Correo electrónico, Contraseña
│   ├── Botón "Iniciar Sesión" → POST /api/v1/auth/login/
│   ├── Enlace "¿Olvidaste tu contraseña?" (versión futura)
│   └── Enlace "¿No tienes cuenta? Regístrate"
│
├── 📝 Registro de Cliente
│   ├── Campos: Nombre, Apellido, Correo, Teléfono, Contraseña, Confirmar Contraseña
│   ├── Botón "Registrarse" → POST /api/v1/auth/register/
│   └── Enlace "¿Ya tienes cuenta? Inicia Sesión"
│
└── 👁️ Modo Invitado: No
    └── (Se requiere autenticación para acceder a todos los módulos)
```

---

## 🔐 ZONA PRIVADA (Usuario logueado)

```
El menú principal tendrá: 5 secciones (Tab Bar inferior)
│
│   ┌──────────┬──────────┬──────────┬──────────┬──────────┐
│   │  🏠      │  🛒      │  🔧      │  🏍️      │  👤      │
│   │  Inicio  │  Tienda  │ Servicios│ Domicilios│  Perfil  │
│   └──────────┴──────────┴──────────┴──────────┴──────────┘
│
│
├── 🏠 SECCIÓN 1: INICIO
│   ├── Banner de bienvenida "Hola, {nombre} 👋"
│   ├── Accesos rápidos (4 tarjetas grandes)
│   │   ├── 🛒 Ir a Tienda
│   │   ├── 🔧 Buscar Servicio
│   │   ├── 🏍️ Pedir Domicilio
│   │   └── 📞 Directorio de Contactos
│   ├── 📋 Mis últimos pedidos (resumen de los 3 más recientes)
│   │   └── Tocar pedido → Detalle del Pedido
│   └── 📢 Novedades de Runners (anuncios / comercios nuevos)
│
│
├── 🛒 SECCIÓN 2: TIENDA
│   ├── 🔍 Barra de búsqueda de comercios
│   ├── 📂 Filtro por categorías (horizontal scrollable)
│   │   ├── Restaurantes
│   │   ├── Almacenes
│   │   ├── Panaderías
│   │   └── Otros
│   ├── 📋 Lista de Comercios (cards con imagen, nombre, categoría, # productos)
│   │   └── Tocar comercio → DETALLE DEL COMERCIO
│   │       ├── Imagen, nombre, categoría, teléfono, dirección
│   │       ├── 📋 Lista de Productos disponibles
│   │       │   └── Cada producto: imagen, nombre, precio, botón "+" (agregar al carrito)
│   │       └── 🛒 Botón flotante "Ver Carrito ({n} items)"
│   │           └── PANTALLA DEL CARRITO
│   │               ├── Lista de ítems con controles +/- y eliminar
│   │               ├── Subtotal por ítem
│   │               ├── Total del pedido
│   │               ├── Campo "Notas adicionales" (opcional)
│   │               ├── Botón "Realizar Pedido" → POST /api/v1/store/orders/create/
│   │               └── Confirmación "✅ ¡Pedido realizado!" → Redirige a Historial
│   │
│   └── 📋 HISTORIAL DE PEDIDOS (ícono de reloj en el header)
│       ├── Lista de pedidos ordenados por fecha
│       └── Cada pedido muestra:
│           ├── # Pedido, Comercio, Fecha
│           ├── Estado con badge de color (Pendiente/Confirmado/En camino/Entregado/Cancelado)
│           └── Tocar → DETALLE DEL PEDIDO
│               ├── Información del comercio
│               ├── Lista de ítems (producto, cantidad, precio unitario, subtotal)
│               ├── Total
│               └── Estado actual con línea de tiempo visual
│
│
├── 🔧 SECCIÓN 3: SERVICIOS
│   ├── 📂 Categorías de Servicio (grid de tarjetas con ícono)
│   │   ├── Plomería
│   │   ├── Electricidad
│   │   ├── Contabilidad
│   │   ├── Medicina
│   │   ├── Albañilería
│   │   └── Otros...
│   │   └── Tocar categoría → PRESTADORES DISPONIBLES
│   │       ├── Lista de prestadores aprobados y disponibles
│   │       ├── Cada tarjeta muestra: nombre, foto, descripción, categoría
│   │       └── Botón "Solicitar Servicio"
│   │           └── SOLICITAR SERVICIO
│   │               ├── Campo "Describe lo que necesitas"
│   │               ├── Botón "Enviar Solicitud" → POST /api/v1/services/requests/create/
│   │               └── Confirmación "✅ Solicitud enviada. Runners será intermediaria."
│   │
│   ├── 📋 MIS SOLICITUDES (ícono en el header)
│   │   ├── Lista de solicitudes realizadas
│   │   └── Cada solicitud: prestador, categoría, estado, fecha
│   │
│   └── 📝 REGISTRARME COMO PRESTADOR (botón destacado si no es prestador)
│       ├── Seleccionar categoría de servicio
│       ├── Descripción de servicios ofrecidos
│       ├── Subir hoja de vida (PDF/imagen desde galería o cámara)
│       ├── ☑️ Aceptar términos y condiciones
│       ├── Botón "Enviar Solicitud" → POST /api/v1/services/providers/register/
│       └── Mensaje "Tu perfil está en revisión. Te notificaremos cuando sea aprobado."
│
│
├── 🏍️ SECCIÓN 4: DOMICILIOS
│   │
│   ├── [VISTA CLIENTE]
│   │   ├── 📋 Lista de Domiciliarios Disponibles
│   │   │   └── Cada tarjeta: #número, nombre, teléfono, tipo (Independiente/Empresa), estado
│   │   └── Botón "Solicitar" → Coordinación con Runners
│   │
│   └── [VISTA DOMICILIARIO — si rol = DOMICILIARIO]
│       ├── 🚦 CAMBIAR MI ESTADO
│       │   ├── 🟢 Disponible
│       │   ├── 🟡 Ocupado
│       │   └── ⚫ Inactivo
│       │
│       ├── 📊 RESUMEN FINANCIERO (4 tarjetas)
│       │   ├── 💚 Ingresos totales
│       │   ├── 🔴 Egresos totales
│       │   ├── 🔵 Balance neto
│       │   └── 🟡 Comisión Runners
│       │
│       ├── ➕ REGISTRAR MOVIMIENTO
│       │   ├── Tipo: Ingreso / Egreso
│       │   ├── Valor ($)
│       │   ├── Descripción
│       │   └── Botón "Registrar" → POST /api/v1/deliveries/records/
│       │
│       └── 📋 HISTORIAL DE MOVIMIENTOS
│           └── Lista cronológica de ingresos (verde) y egresos (rojo)
│               └── Cada registro: tipo, descripción, monto, comisión Runners (si ingreso)
│
│
├── 📞 CONTACTOS (accesible desde Inicio o como 5ta tab opcional)
│   ├── 🔍 Barra de búsqueda (nombre, teléfono)
│   ├── 📂 Filtro por tipo
│   │   ├── Emergencia (🚨)
│   │   ├── Profesional (👔)
│   │   ├── Comercio (🏪)
│   │   └── Otro
│   ├── 📂 Filtro por disponibilidad
│   │   ├── ✅ En Servicio
│   │   └── ❌ Fuera de Servicio
│   └── 📋 Lista de Contactos (cards)
│       └── Cada contacto: nombre, teléfono (con botón de llamada directa), tipo, disponibilidad
│
│
└── 👤 SECCIÓN 5: PERFIL
    ├── 📷 Foto de perfil (avatar con inicial del nombre)
    ├── 📝 Información personal
    │   ├── Nombre completo
    │   ├── Correo electrónico
    │   ├── Teléfono
    │   └── Rol (Cliente / Prestador / Domiciliario)
    │
    ├── ✏️ Editar Perfil
    │   ├── Modificar: Nombre, Apellido, Teléfono
    │   └── Botón "Guardar cambios" → PATCH /api/v1/auth/profile/
    │
    ├── [SI ROL = PRESTADOR]
    │   └── 🔧 Mi Perfil de Prestador
    │       ├── Estado actual (Disponible / Ocupado / Inactivo)
    │       ├── Botones para cambiar estado → PATCH /api/v1/services/providers/status/
    │       ├── Categoría de servicio
    │       ├── Descripción
    │       └── Estado de aprobación (Pendiente / Aprobado / Rechazado)
    │
    ├── ⚙️ Configuración
    │   ├── 🔔 Notificaciones (activar/desactivar push)
    │   ├── 🌙 Tema Oscuro / Claro
    │   └── 📱 Información de la app (versión, términos, privacidad)
    │
    └── 🚪 Cerrar Sesión → POST /api/v1/auth/logout/ + limpiar tokens
```

---

## 👑 ZONA ADMINISTRADOR (Rol = ADMIN)

```
(Tab adicional o acceso desde Perfil)
│
└── 👑 PANEL ADMIN
    │
    ├── 📊 DASHBOARD
    │   ├── Usuarios activos (total, clientes, prestadores, domiciliarios)
    │   ├── Pedidos (total, pendientes, entregados)
    │   ├── Prestadores pendientes de aprobación
    │   └── Domiciliarios disponibles
    │
    ├── 👥 GESTIONAR USUARIOS
    │   ├── Lista de usuarios con filtros (rol, estado)
    │   ├── Buscar usuario
    │   └── Tocar usuario → Detalle
    │       ├── Información completa
    │       └── Botón "Suspender / Activar" → POST /api/v1/auth/users/{id}/toggle-status/
    │
    ├── 🔧 APROBAR PRESTADORES
    │   ├── Lista de prestadores con estado PENDIENTE
    │   └── Tocar prestador → Revisión
    │       ├── Datos del prestador
    │       ├── Descargar / ver hoja de vida
    │       ├── Botón "✅ Aprobar" → POST /api/v1/services/providers/{id}/approve/
    │       └── Botón "❌ Rechazar" (con campo de motivo)
    │
    ├── 🛒 GESTIONAR TIENDA
    │   ├── Crear / Editar categorías
    │   ├── Crear / Editar comercios
    │   └── Crear / Editar productos de un comercio
    │
    ├── 📞 GESTIONAR CONTACTOS
    │   ├── Crear contacto (nombre, teléfono, tipo, disponibilidad)
    │   ├── Editar contacto
    │   └── Eliminar contacto
    │
    └── 📈 REPORTES
        ├── 📊 Reporte de Ventas → GET /api/v1/reports/sales/?days=30
        │   ├── Filtro por período (7, 15, 30, 90 días)
        │   ├── Total de pedidos y revenue
        │   └── Desglose por comercio (tabla o gráfico)
        │
        └── 📊 Reporte de Domiciliarios → GET /api/v1/reports/deliverers/
            └── Por cada domiciliario: ingresos, egresos, balance, comisión Runners
```

---

## 🔄 FLUJO DE NAVEGACIÓN PRINCIPAL

```
┌─────────────┐
│   Splash     │
│   Screen     │
└──────┬───────┘
       │
       ▼
┌──────────────┐     ┌──────────────┐
│   Login      │◄───►│  Registro    │
└──────┬───────┘     └──────────────┘
       │
       ▼ (Token JWT almacenado)
┌──────────────────────────────────────────────────────────┐
│                    TAB BAR PRINCIPAL                      │
│                                                          │
│  🏠 Inicio  │  🛒 Tienda  │  🔧 Servicios  │  🏍️ Domicilios  │  👤 Perfil  │
│                                                          │
│  ┌─────────┐  ┌──────────┐  ┌───────────┐  ┌──────────┐  ┌────────┐ │
│  │Accesos  │  │Comercios │  │Categorías │  │Domic.    │  │Mis     │ │
│  │rápidos  │  │  ↓       │  │  ↓        │  │disponib. │  │datos   │ │
│  │Últimos  │  │Detalle   │  │Prestadores│  │  ↓       │  │Config  │ │
│  │pedidos  │  │  ↓       │  │  ↓        │  │[Panel    │  │Cerrar  │ │
│  │         │  │Carrito   │  │Solicitar  │  │financ.]* │  │sesión  │ │
│  │         │  │  ↓       │  │           │  │          │  │        │ │
│  │         │  │Pedido ✅ │  │           │  │          │  │        │ │
│  └─────────┘  └──────────┘  └───────────┘  └──────────┘  └────────┘ │
│                                                          │
│  * Panel financiero solo visible para rol DOMICILIARIO   │
│  ** Tab Admin visible solo para rol ADMIN                │
└──────────────────────────────────────────────────────────┘
```

---

## 📱 RESUMEN DE PANTALLAS

| # | Pantalla | Acceso | Descripción |
|---|----------|--------|-------------|
| 1 | Splash Screen | Público | Logo animado, carga inicial |
| 2 | Login | Público | Correo + contraseña, enlace a registro |
| 3 | Registro | Público | Formulario de 6 campos, crea cuenta CLIENTE |
| 4 | Inicio (Home) | Autenticado | Bienvenida, accesos rápidos, últimos pedidos |
| 5 | Tienda - Comercios | Autenticado | Grid de comercios con filtro por categoría |
| 6 | Tienda - Detalle Comercio | Autenticado | Productos del comercio con botón agregar |
| 7 | Tienda - Carrito | Autenticado | Ítems, cantidades, total, confirmar pedido |
| 8 | Tienda - Confirmación | Autenticado | Mensaje de éxito del pedido |
| 9 | Tienda - Historial Pedidos | Autenticado | Lista de pedidos con estado |
| 10 | Tienda - Detalle Pedido | Autenticado | Ítems, total, estado con timeline |
| 11 | Servicios - Categorías | Autenticado | Grid de categorías de servicio |
| 12 | Servicios - Prestadores | Autenticado | Lista filtrada por categoría |
| 13 | Servicios - Solicitar | Autenticado | Formulario de solicitud de servicio |
| 14 | Servicios - Mis Solicitudes | Autenticado | Historial de solicitudes |
| 15 | Servicios - Registrarme como Prestador | Autenticado | Formulario con hoja de vida |
| 16 | Domicilios - Disponibles | Autenticado | Lista de domiciliarios |
| 17 | Domicilios - Panel Financiero | Domiciliario | Estado, resumen, registrar movimiento |
| 18 | Domicilios - Historial Movimientos | Domiciliario | Ingresos y egresos |
| 19 | Contactos - Directorio | Autenticado | Búsqueda y filtros, lista de contactos |
| 20 | Perfil - Ver | Autenticado | Datos personales, rol |
| 21 | Perfil - Editar | Autenticado | Modificar nombre, apellido, teléfono |
| 22 | Perfil - Mi Prestador | Prestador | Estado, categoría, aprobación |
| 23 | Perfil - Configuración | Autenticado | Notificaciones, tema, info app |
| 24 | Admin - Dashboard | Admin | Resumen de métricas |
| 25 | Admin - Gestionar Usuarios | Admin | Lista, filtros, suspender/activar |
| 26 | Admin - Aprobar Prestadores | Admin | Pendientes, aprobar/rechazar |
| 27 | Admin - Gestionar Tienda | Admin | CRUD comercios y productos |
| 28 | Admin - Gestionar Contactos | Admin | CRUD directorio |
| 29 | Admin - Reportes Ventas | Admin | Ventas por período y comercio |
| 30 | Admin - Reportes Domiciliarios | Admin | Financiero por domiciliario |

**Total: 30 pantallas** (3 públicas + 20 autenticadas + 7 admin)

---

## 🛠️ NOTAS TÉCNICAS

- **API Backend:** La app móvil consume la misma API REST existente (`/api/v1/`) desarrollada en Django REST Framework. No se requieren cambios en el backend.
- **Autenticación:** JWT con access token (15 min) y refresh token (7 días), almacenados en almacenamiento seguro del dispositivo (SecureStore / Keychain).
- **Framework sugerido:** React Native (aprovechando el conocimiento existente en React) o Flutter.
- **Navegación:** React Navigation con Tab Navigator (5 tabs) + Stack Navigator por cada sección.
- **Estado global:** Context API (mismo patrón del frontend web) para AuthContext y CartContext.
- **Almacenamiento local:** AsyncStorage para cache de datos y preferencias (tema, notificaciones).
