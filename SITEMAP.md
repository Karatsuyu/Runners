# DIAGRAMA JERÁRQUICO (SITEMAP)

**Objetivo**: Crear el diagrama jerárquico (sitemap) de la aplicación móvil "Runners", mostrando todas sus pantallas y cómo se organizan basándose en la implementación real en Flutter y las rutas definidas.

**¿Qué tienen que entregar?**
Un diagrama de texto que muestre la estructura completa de la app, desde que el usuario abre la pantalla de inicio hasta que cierra sesión, respetando la lógica de navegación basada en los 4 roles creados.

**NOMBRE DE LA APP:** [Runners]
**BREVE DESCRIPCIÓN:** [Súper-app desarrollada en Flutter que conecta Clientes con Comercios (Tienda), Profesionales Independientes (Servicios) y mensajeros (Domicilios/Entregas), gestionado mediante diferentes capas o perfiles de usuario.]

# DIAGRAMA JERÁRQUICO (SITEMAP)

**Objetivo**: Crear el diagrama jerárquico (sitemap) de la aplicación móvil "Runners", mostrando todas sus pantallas y cómo se organizan basándose en la implementación real en Flutter y las rutas definidas.

**¿Qué tienen que entregar?**
Un diagrama de texto que muestre la estructura completa de la app, desde que el usuario abre la pantalla de inicio hasta que cierra sesión, respetando la lógica de navegación basada en los 4 roles creados.

**NOMBRE DE LA APP:** [Runners]
**BREVE DESCRIPCIÓN:** [Súper-app desarrollada en Flutter que conecta Clientes con Comercios (Tienda), Profesionales Independientes (Servicios) y mensajeros (Domicilios/Entregas), gestionado mediante diferentes capas o perfiles de usuario.]

---

## 🌎 ZONA PÚBLICA (Sin login)

```text
├── Pantalla de inicio / Splash (`/splash`)
│   └── (Evalúa el estado de autenticación de forma automática)
│
├── Registro (`/register`)
│   └── (Completar campos: Nombre, Apellido, Email, Contraseña, Verificación)
│
├── Inicio de sesión (`/login`)
│   └── (Completar campos: Email, Contraseña)
│
└── Modo invitado: [No]
    └── ¿Qué puede ver? [La aplicación requiere autenticación previa vía JWT para enrutar el rol de forma segura]
```

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🔒 ZONA PRIVADA (Usuario logueado)
*(Dado el alcance de la súper-app, la estructura varía según el Rol)*


### 👤 ROL: CLIENTE (ClientShell)
*(El menú principal tendrá: [4] pestañas inferiores en NavigationBar + Carrito)*

```text
│
├── SECCIÓN 1: [TIENDA] (`/client/store`)
│   ├── [Vista de categorías recomendadas y comercios disponibles]
│   └── [Detalle de Comercio] -> [Abre menú, info e ítem a comprar (`/client/store/:id`)]
│       └── [Botón: Añadir al carrito]
│
├── SECCIÓN 2: [SERVICIOS] (`/client/services`)
│   ├── [Listado de profesionales, oficios y oficios varios]
│   └── [Detalle de Proveedor] -> [Vista de experiencia y botón 'Contactar' (`/client/services/:id`)]
│
├── SECCIÓN 3: [DOMICILIOS] (`/client/deliveries`)
│   ├── [Formulario de solicitud: ¿Qué necesitas?, Origen y Destino]
│   └── [Botón solicitar asignación de repartidor]
│
├── SECCIÓN 4: [CONTACTOS] (`/client/contacts`)
│   ├── [Listado de opciones de soporte oficiales]
│   └── [Atención de consultas e incidencias]
│
├── [CARRITO DE COMPRAS] (`/client/cart`) - *Flotante a nivel de Tienda*
│   ├── [Visualización de lista de productos guardados, cantidad y subtotal]
│   └── [Confirmación y generación de orden (`/client/order-history`)]
│
└── PERFIL Y AJUSTES
    ├── [Mi Historial] -> [Ruta `/client/orderHistory` para mis pedidos de tienda pasados]
    ├── Ver mis datos (Identificación del Rol y Email)
    ├── CONFIGURACIÓN
    │   ├── Opción 1: [Tema Visual y Personalización]
    │   └── Opción 2: [Gestión básica de la cuenta]
    └── Cerrar sesión (Regreso incondicional a la Pantalla de Login/Splash)
```

---

### 🛠️ ROL: PRESTADOR Y TIENDA (ProviderShell)
*(El menú principal tendrá: [3] pestañas inferiores)*

```text
│
├── SECCIÓN 1: [MI PANEL / DASHBOARD] (`/provider/dashboard`)
│   ├── [Resumen operativo, métricas y pedidos pendientes]
│   └── [Acción 'Registrar Nuevo Servicio' (`/provider/register`)]
│
├── SECCIÓN 2: [SERVICIOS] (`/client/services`)
│   └── [Catálogo general para observar la oferta en el mercado (Modo Búsqueda)]
│
├── SECCIÓN 3: [CONTACTOS] (`/client/contacts`)
│   └── [Centro de ayuda para proveedores y comercios]
│
└── PERFIL Y AJUSTES
    └── Cerrar sesión
```

---

### 🛵 ROL: DOMICILIARIO (DelivererShell)
*(El menú principal tendrá: [3] pestañas inferiores)*

```text
│
├── SECCIÓN 1: [MI PANEL / DASHBOARD] (`/deliverer/dashboard`)
│   └── [Módulo para aceptar domicilios solicitados u observar pendientes actualizados]
│
├── SECCIÓN 2: [FINANZAS] (`/deliverer/financial`)
│   └── [Monitoreo del fondo propio, ingresos acumulados por entregas y cortes de cuenta]
│
├── SECCIÓN 3: [CONTACTOS] (`/client/contacts`)
│   └── [Auxilio y emergencias para el repartidor]
│
└── PERFIL Y AJUSTES
    └── Cerrar sesión
```

---

### 👑 ROL: ADMINISTRADOR (AdminShell)
*(Navegación estructurada a través de un Drawer / Menú lateral)*

```text
│
├── SECCIÓN 1: [PANEL DE CONTROL] (`/admin/dashboard`)
│   └── [Estadísticas conjuntas en tiempo real y revisión al vuelo]
│
├── SECCIÓN 2: [USUARIOS] (`/admin/manageUsers`)
│   └── [Tabla de clientes y mensajeros para bloquear u otorgar permisos]
│
├── SECCIÓN 3: [PROVEEDORES] (`/admin/manageProviders`)
│   └── [Aceptación de tiendas y profesionales para listarlos]
│
├── SECCIÓN 4: [REPORTES] (`/admin/reports`)
│   └── [Extracción de analítica, reportes financieros de la app]
│
└── PERFIL Y AJUSTES
    └── Cerrar sesión
```
