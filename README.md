# 🏃 Runners - Plataforma Móvil de Intermediación de Servicios

Plataforma completa de domicilios y servicios especializados para Caicedonia, Valle del Cauca.

## 📁 Estructura del Proyecto

```
runners/
├── frontend/                 # Aplicación Flutter (móvil)
│   ├── android/             # Código Android nativo
│   ├── ios/                 # Código iOS nativo
│   ├── lib/                 # Código Dart principal
│   │   ├── features/        # Características (auth, store, services, etc.)
│   │   ├── core/            # Servicios compartidos (API, storage, auth)
│   │   ├── shared/          # Widgets reutilizables
│   │   ├── main.dart
│   │   └── app.dart
│   ├── pubspec.yaml         # Dependencias Flutter
│   ├── .env                 # Variables de entorno
│   └── ...
├── backend/                 # API Django REST Framework
│   ├── apps/                # Aplicaciones Django
│   │   ├── users/           # Usuarios y autenticación
│   │   ├── store/           # Tienda y productos
│   │   ├── services/        # Servicios especializados
│   │   ├── deliveries/      # Domicilios y entregas
│   │   ├── contacts/        # Directorio de contactos
│   │   └── reports/         # Reportes y analytics
│   ├── runners_project/     # Configuración Django
│   ├── manage.py
│   ├── requirements.txt
│   ├── .env
│   └── db.sqlite3           # BD SQLite (desarrollo)
├── .venv/                   # Entorno virtual Python
└── README.md
```

## 🚀 Quick Start

### Backend (Django)

```bash
# 1. Navegar a backend
cd backend

# 2. Activar entorno virtual (si no está activo)
..\\.venv\\Scripts\\Activate.ps1  # Windows PowerShell

# 3. Instalar dependencias
pip install -r requirements.txt

# 4. Ejecutar migraciones
python manage.py migrate

# 5. Cargar datos de prueba
python manage.py seed_data

# 6. Iniciar servidor
python manage.py runserver 0.0.0.0:8000
```

**Server disponible en:** `http://localhost:8000` (local) o `http://10.0.2.2:8000` (emulador Android)

**Admin panel:** `http://localhost:8000/admin/`
- Email: `admin@runners.co`
- Password: `Admin2024!`

### Frontend (Flutter)

```bash
# 1. Navegar a frontend
cd frontend

# 2. Obtener dependencias
flutter pub get

# 3. Ejecutar la app (emulador Android)
flutter run

# O ejecutar en iOS
flutter run -d iPhone
```

## 🔑 Credenciales de Prueba

| Rol | Email | Password |
|-----|-------|----------|
| Admin | `admin@runners.co` | `Admin2024!` |
| Cliente | `cliente1@runners.co` | `Runners2024!` |
| Domiciliario | `domi1@runners.co` | `Runners2024!` |
| Prestador Servicios | `prest1@runners.co` | `Runners2024!` |

## 📋 API Endpoints

Ver archivo: `backend/runners_api_postman.json` (Colección Postman lista para usar)

### Principales:
- **Auth:** `POST /api/v1/auth/login/` → obtiene JWT
- **Comercios:** `GET /api/v1/store/commerces/`
- **Servicios:** `GET /api/v1/services/requests/`
- **Domicilios:** `GET /api/v1/deliveries/requests/` (auto-assign)
- **Contactos:** `GET /api/v1/contacts/`
- **Dashboard:** `GET /api/v1/reports/dashboard/` (admin-only)

## 🛠️ Stack Tecnológico

### Frontend
- **Flutter 3.9+** - Framework multiplataforma
- **Dart 3.9+** - Lenguaje de programación
- **Riverpod** - Gestión de estado
- **GoRouter** - Navegación
- **Dio** - Cliente HTTP
- **SimpleJWT** - Autenticación Bearer
- **Hive** - Base de datos local (offline)
- **Flutter Secure Storage** - Almacenamiento seguro

### Backend
- **Django 5.2** - Framework web
- **Django REST Framework** - API REST
- **SimpleJWT** - JWT tokens (60min access / 30 días refresh)
- **django-cors-headers** - CORS para emulador Android
- **Pillow** - Procesamiento de imágenes
- **SQLite** - Base de datos (desarrollo)
- **PostgreSQL** - Base de datos (producción)

## ✅ Features Implementados

### Autenticación
- ✅ JWT Bearer tokens con refresh automático
- ✅ Roles: Admin, Cliente, Domiciliario, Prestador
- ✅ Control de permisos por endpoint

### Tienda
- ✅ Catálogo de productos por comercio
- ✅ Búsqueda y filtros
- ✅ Carrito de compras (local)
- ✅ Historial de órdenes

### Domicilios
- ✅ Auto-asignación de domiciliarios disponibles
- ✅ Tracking de entregas
- ✅ Registro de incomes/expenses
- ✅ Comisiones automáticas

### Servicios
- ✅ Categorías de servicios
- ✅ Proveedores con aprobación admin
- ✅ Solicitudes de servicios
- ✅ Historial completo

### Contactos
- ✅ Directorio local (Caicedonia)
- ✅ Tipos: Emergencia, Profesional, Comercio, Otro
- ✅ Búsqueda y filtros

### Admin
- ✅ Dashboard con estadísticas
- ✅ Reportes de ventas, domicilios y servicios
- ✅ Gestión de usuarios y permisos
- ✅ Panel Django admin (`/admin/`)

## 📚 Documentación Adicional

- `runners_flutter_implementacion.md` - Detalles de implementación Flutter
- `runners_guia_implementacion_web.md` - Guía backend original
- `Flutter_Auth_Screens.md` - Documentación de pantallas de auth
- `backend/runners_api_postman.json` - Colección de endpoints

## 🤝 Desarrollo

### Estructura Frontend (`frontend/lib/`)
```
lib/
├── features/
│   ├── auth/           # Autenticación (login, register)
│   ├── store/          # Tienda (commerces, products, orders)
│   ├── services/       # Servicios especializados
│   ├── deliveries/     # Domicilios
│   ├── contacts/       # Directorio
│   └── dashboard/      # Pantallas admin
├── core/
│   ├── api/            # Cliente HTTP (Dio)
│   ├── providers/      # Riverpod notifiers
│   ├── storage/        # Hive + SecureStorage
│   ├── auth/           # JWT token manager
│   └── services/       # Notificaciones, utils
└── shared/
    ├── widgets/        # Componentes reutilizables
    └── extensions/     # Extensiones de tipos
```

### Estructura Backend (`backend/apps/`)
```
apps/
├── users/              # Modelo User personalizado, auth
├── store/              # Commerces, Products, Orders
├── services/           # ServiceCategories, Providers, Requests
├── deliveries/         # Deliverers, Requests, FinancialRecords
├── contacts/           # Contacts (directorio local)
└── reports/            # Dashboard, reportes
```

## ⚙️ Configuración

### Variables de Entorno Frontend (`frontend/.env`)
```
API_BASE_URL=http://10.0.2.2:8000/api/v1  # Emulador Android
APP_NAME=Runners
```

### Variables de Entorno Backend (`backend/.env`)
```
DEBUG=True
CORS_ALLOW_ALL_ORIGINS_DEV=True
JWT_ACCESS_TOKEN_LIFETIME_MINUTES=60
JWT_REFRESH_TOKEN_LIFETIME_DAYS=30
ALLOWED_HOSTS=localhost,127.0.0.1,10.0.2.2
```

## 📱 Build de Producción

### Flutter (Android)
```bash
cd frontend
flutter build apk --release
# Output: build/app/outputs/flutter-app.apk
```

### Django
```bash
cd backend
# Cambiar a settings.production en manage.py
python manage.py migrate --database=postgresql
python manage.py collectstatic
gunicorn runners_project.wsgi:application
```

## 🐛 Troubleshooting

### Flutter no conecta al backend
- Verificar que server está en `http://10.0.2.2:8000` (emulador)
- Para dispositivo físico: usar IP local `192.168.x.x`
- Verificar CORS en `backend/runners_project/settings/base.py`

### "No hay domiciliarios disponibles"
- Ejecutar `python manage.py seed_data` en backend
- Crear domiciliarios vía API (`POST /api/v1/deliveries/deliverers/`)

### Token expirado
- App refresca automáticamente (Riverpod interceptor)
- Si persiste: logout y login nuevamente

## 🤝 Contribución del equipo

- Guía de colaboración: `CONTRIBUTING.md`
- Plantilla de Pull Request: `.github/pull_request_template.md`
- Convención de ramas: `feature/*`, `fix/*`, `refactor/*`, `docs/*`, `chore/*`, `hotfix/*`
- Política recomendada: no desarrollar directo en `main`; trabajar con PR y revisión

## 📄 Licencia

Proyecto privado - Caicedonia, Valle del Cauca 2026
