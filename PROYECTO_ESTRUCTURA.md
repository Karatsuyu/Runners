# 📦 Estructura del Proyecto - Runners

## Organización Completa

```
runners/                                          # Raíz del proyecto
│
├── 📁 frontend/                                  # ✅ Aplicación Flutter (móvil)
│   ├── 📁 lib/
│   │   ├── features/
│   │   │   ├── auth/                            # Autenticación (login, registro)
│   │   │   ├── store/                           # Tienda (comercios, productos, órdenes)
│   │   │   ├── services/                        # Servicios especializados
│   │   │   ├── deliveries/                      # Domicilios y entregas
│   │   │   ├── contacts/                        # Directorio de contactos
│   │   │   └── admin/                           # Pantallas administrativas
│   │   ├── core/
│   │   │   ├── api/                             # Cliente HTTP (Dio)
│   │   │   ├── providers/                       # Riverpod state management
│   │   │   ├── storage/                         # Hive (local) + SecureStorage (tokens)
│   │   │   ├── auth/                            # JWT token manager
│   │   │   └── services/                        # Notificaciones, connectivity, etc.
│   │   ├── shared/
│   │   │   ├── widgets/                         # Componentes reutilizables
│   │   │   ├── extensions/                      # Extensiones de tipos (Color, Duration, etc.)
│   │   │   └── theme/                           # Temas de color y estilos
│   │   ├── 📄 main.dart                         # Entry point
│   │   └── 📄 app.dart                          # Configuración de la app
│   │
│   ├── 📁 android/                              # Código Android nativo
│   │   ├── app/
│   │   │   ├── src/
│   │   │   │   ├── debug/
│   │   │   │   ├── main/                        # AndroidManifest.xml con permisos
│   │   │   │   └── profile/
│   │   │   └── build.gradle.kts
│   │   ├── gradle/
│   │   ├── gradle.properties
│   │   ├── gradlew / gradlew.bat
│   │   └── local.properties                     # SDK paths
│   │
│   ├── 📁 ios/                                  # Código iOS nativo
│   │   ├── Runner/
│   │   │   ├── 📄 Info.plist                    # Permisos y config iOS
│   │   │   ├── GeneratedPluginRegistrant.h/.m
│   │   │   └── Assets.xcassets/
│   │   ├── Runner.xcworkspace/                  # Workspace Xcode
│   │   └── Flutter/                             # Config Flutter
│   │
│   ├── 📁 web/                                  # Soporte web (opcional)
│   │   ├── 📄 index.html
│   │   ├── manifest.json
│   │   └── icons/
│   │
│   ├── 📁 linux/                                # Soporte Linux (opcional)
│   ├── 📁 macos/                                # Soporte macOS (opcional)
│   ├── 📁 windows/                              # Soporte Windows (opcional)
│   ├── 📁 assets/                               # Imágenes e íconos
│   │   ├── images/
│   │   └── icons/
│   ├── 📁 test/                                 # Pruebas unitarias
│   ├── 📄 pubspec.yaml                          # Dependencias Flutter
│   ├── 📄 pubspec.lock                          # Lock de versiones
│   ├── 📄 .env                                  # Variables de entorno
│   ├── 📄 .metadata
│   ├── 📄 analysis_options.yaml                 # Reglas de análisis Dart
│   └── 📄 .flutter-plugins-dependencies
│
├── 📁 backend/                                  # ✅ API Django REST Framework
│   ├── 📁 apps/                                 # Aplicaciones Django
│   │   ├── users/                               # Usuarios y autenticación
│   │   │   ├── models.py                        # User personalizado
│   │   │   ├── serializers.py                   # Serialización
│   │   │   ├── views.py                         # Login, Register
│   │   │   ├── urls.py
│   │   │   ├── permissions.py                   # IsAdmin, IsCliente, IsPrestador, etc.
│   │   │   ├── admin.py
│   │   │   └── management/
│   │   │       └── commands/
│   │   │           └── seed_data.py             # Datos de prueba
│   │   │
│   │   ├── store/                               # Tienda (commerces, products, orders)
│   │   │   ├── models.py                        # Commerce, Product, Order
│   │   │   ├── serializers.py
│   │   │   ├── views.py                         # CRUD endpoints
│   │   │   ├── urls.py
│   │   │   └── admin.py
│   │   │
│   │   ├── services/                            # Servicios especializados
│   │   │   ├── models.py                        # ServiceCategory, ServiceProvider, ServiceRequest
│   │   │   ├── serializers.py                   # Con foto y validaciones
│   │   │   ├── views.py                         # Auto-approval por admin
│   │   │   ├── urls.py
│   │   │   └── admin.py
│   │   │
│   │   ├── deliveries/                          # Domicilios y entregas
│   │   │   ├── models.py                        # Deliverer, DeliveryRequest, FinancialRecord
│   │   │   ├── serializers.py
│   │   │   ├── views.py                         # AUTO-ASSIGN en POST /requests/
│   │   │   ├── urls.py
│   │   │   └── admin.py
│   │   │
│   │   ├── contacts/                            # Directorio local
│   │   │   ├── models.py                        # Contact (sin availability)
│   │   │   ├── serializers.py
│   │   │   ├── views.py                         # GET con search y filtro type
│   │   │   ├── urls.py
│   │   │   ├── admin.py
│   │   │   └── migrations/
│   │   │       ├── 0001_initial.py
│   │   │       └── 0002_remove_contact_availability.py
│   │   │
│   │   └── reports/                             # Dashboard y analytics
│   │       ├── views.py                         # Dashboard, sales, deliverers, services reports
│   │       ├── urls.py
│   │       └── admin.py                         # ✅ Creado (sin modelos)
│   │
│   ├── 📁 runners_project/                      # Configuración Django
│   │   ├── settings/
│   │   │   ├── base.py                          # Configuración compartida
│   │   │   ├── development.py                   # DEBUG=True, SQLite
│   │   │   └── production.py                    # DEBUG=False, PostgreSQL
│   │   ├── urls.py                              # Rutas principales
│   │   ├── wsgi.py                              # WSGI app
│   │   └── asgi.py                              # ASGI app
│   │
│   ├── 📁 media/                                # Uploads (imágenes, archivos)
│   │   └── services/
│   │       └── providers/
│   │           └── photos/
│   │
│   ├── 📁 migrations/                           # Migraciones aplicadas
│   │   ├── contacts/
│   │   │   ├── 0001_initial.py
│   │   │   ├── 0002_remove_contact_availability.py
│   │   │   └── ...
│   │   ├── deliveries/
│   │   │   ├── 0001_initial.py
│   │   │   ├── 0002_...py
│   │   │   ├── 0003_deliveryrequest_completed_at_and_more.py
│   │   │   └── ...
│   │   └── services/
│   │       ├── 0001_initial.py
│   │       ├── 0002_...py
│   │       ├── 0003_serviceprovider_photo.py      # ✅ Aplicada
│   │       └── ...
│   │
│   ├── 📄 manage.py                             # CLI de Django
│   ├── 📄 requirements.txt                      # Dependencias Python
│   ├── 📄 .env                                  # Variables de entorno
│   ├── 📄 .env.example
│   ├── 📄 db.sqlite3                            # Base de datos (desarrollo)
│   ├── 📄 runners_api_postman.json              # Colección Postman completa
│   └── 📄 .gitignore
│
├── 📁 .venv/                                    # Entorno virtual Python (compartido)
│   ├── Scripts/
│   │   └── python.exe                           # Intérprete Python
│   ├── Lib/
│   │   └── site-packages/                       # Paquetes instalados
│   └── pyvenv.cfg
│
├── 📄 README.md                                 # Documentación principal
├── 📄 QUICKSTART.md                             # Guía rápida de ejecución
├── 📄 runners_flutter_implementacion.md         # Detalles Flutter
├── 📄 runners_guia_implementacion_web.md        # Guía backend original
├── 📄 Flutter_Auth_Screens.md                   # Documentación auth screens
├── 📄 .gitignore                                # Exclusiones git
└── 📄 runners.iml                               # Proyecto IntelliJ/Android Studio

```

## 📊 Mapeo de Flujos

### 1️⃣ Autenticación

```
Frontend (Flutter)                Backend (Django)
├── Login Screen
│   └─ POST /auth/login/
│       ├─ Email: cliente1@runners.co
│       ├─ Password: Runners2024!
│       └─> Retorna: access_token, refresh_token
│
├── Store en Riverpod
│   └─ authProvider (guarda tokens en SecureStorage)
│       └─ Incluye en headers: Authorization: Bearer {access_token}
│
└─> Logged In ✅
    └─ Redirect a Home
```

### 2️⃣ Tienda (Store)

```
Pantalla Comercios          API Backend
├─ GET /store/commerces/    ← Django REST
│   └─ Filter por ciudad
│
├─ GET /store/commerces/{id}/products/
│   └─ Carrito local (Hive)
│
└─ POST /store/orders/
    └─ Create Order
        └─> Notification
```

### 3️⃣ Domicilios (AUTO-ASSIGN)

```
Cliente solicita domicilio   Backend AUTO-ASSIGN
├─ POST /deliveries/requests/
│   ├─ pickup_address: "Calle 5 #10-20"
│   ├─ delivery_address: "Calle 3 #5-15"
│   └─ delivery_fee: 3000
│
└─> Backend
    ├─ Busca primer Deliverer con status=DISPONIBLE
    ├─ Crea DeliveryRequest con status=ACEPTADO
    ├─ Cambia Deliverer a status=OCUPADO
    └─> Retorna request_id + deliverer_info
```

### 4️⃣ Servicios (ADMIN MEDIATED)

```
Cliente solicita servicio    Backend Admin Review
├─ POST /services/requests/
│   ├─ category: "Plomería"
│   ├─ provider_id: 123
│   └─ description: "Reparar tubería"
│
└─> Backend
    ├─ Valida provider está APROBADO + DISPONIBLE
    ├─ Crea ServiceRequest con status=PENDIENTE
    │
    └─> Admin Dashboard
        ├─ Revisa request
        ├─ Approve or Reject
        └─> Cliente notificado
```

### 5️⃣ Contactos (READ-ONLY)

```
Cliente busca contacto       Backend Directory
├─ GET /contacts/?search=bancolombia
│   ├─ type=COMERCIO
│   ├─ type=EMERGENCIA
│   └─ type=PROFESIONAL
│
└─> Retorna lista de contactos locales (Caicedonia)
    └─ No editable por cliente
```

### 6️⃣ Admin Dashboard

```
Admin accede dashboard       Backend Analytics
├─ GET /reports/dashboard/   ← admin-only
│   ├─ users_count
│   ├─ orders (active, completed, cancelled)
│   ├─ deliverers (available, busy)
│   ├─ services (pending, approved, rejected)
│   └─ revenue summary
│
└─> Visualiza en Admin Screen
    ├─ Approve/Reject providers
    ├─ View financial records
    ├─ See delivery status
    └─ Export reports
```

## 🔐 Permisos (Permission Classes)

| Endpoint | Permiso | Roles |
|----------|---------|-------|
| `POST /auth/login/` | - | Todos |
| `GET /store/commerces/` | - | Todos |
| `POST /services/requests/` | `IsCliente` | Cliente |
| `POST /deliveries/requests/` | `IsCliente` | Cliente |
| `PATCH /deliverers/status/` | `IsDomiciliario` | Domiciliario |
| `GET /reports/dashboard/` | `IsAdmin` | Admin |
| `PATCH /services/{id}/approve/` | `IsAdmin` | Admin |

## 🗄️ Modelos Principales

### users.User
```
Email, Password, FirstName, LastName, Role (CLIENTE|PRESTADOR|DOMICILIARIO|ADMIN)
```

### store.Commerce
```
Name, City, Logo, ProductCategories
```

### store.Product
```
Name, Description, Price, Commerce, ProductCategory
```

### store.Order
```
Client, Commerce, Products, TotalPrice, Status (PENDIENTE|CONFIRMADO|ENTREGADO|CANCELADO)
```

### deliveries.Deliverer
```
User, Status (DISPONIBLE|OCUPADO), AssignedNumber, IsActive
```

### deliveries.DeliveryRequest
```
Client, Deliverer (AUTO-ASSIGNED), PickupAddress, DeliveryAddress, DeliveryFee, 
Status (PENDIENTE|ACEPTADO|ENTREGADO|CANCELADO), CompletedAt
```

### services.ServiceProvider
```
User, Category, Description, Photo, Resume, Status (ACTIVO|INACTIVO), 
ApprovalStatus (PENDIENTE|APROBADO|RECHAZADO), ApprovedBy (Admin)
```

### services.ServiceRequest
```
Client, Provider, Category, Description, ProviderFee, RunnersFee, ClientTotal,
Status (PENDIENTE|APROBADO|RECHAZADO|COMPLETADO)
```

### contacts.Contact
```
Name, Phone, Description, ContactType (EMERGENCIA|PROFESIONAL|COMERCIO|OTRO), IsActive
```

## 📡 APIs Disponibles

Ver `backend/runners_api_postman.json` para colección completa.

### Principales:
- `POST /api/v1/auth/login/`
- `GET /api/v1/store/commerces/`
- `GET /api/v1/services/requests/`
- `GET /api/v1/deliveries/requests/`
- `POST /api/v1/deliveries/requests/` ← AUTO-ASSIGN
- `GET /api/v1/contacts/`
- `GET /api/v1/reports/dashboard/` ← Admin only

---

✅ **Estructura completamente organizada y funcional**
