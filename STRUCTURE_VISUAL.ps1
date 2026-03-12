#!/usr/bin/env pwsh
# Script para visualizar la estructura del proyecto Runners

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║        🏃 RUNNERS - Estructura del Proyecto                    ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

Write-Host "📁 Raíz: c:\Users\Usuario\Documents\runners" -ForegroundColor Yellow
Write-Host ""

Write-Host "runners/" -ForegroundColor White
Write-Host "│" -ForegroundColor Gray
Write-Host "├── 📁 frontend/" -ForegroundColor Green
Write-Host "│   ├── 📁 lib/                  🎨 Código Dart (Clean Architecture)" -ForegroundColor Green
Write-Host "│   │   ├── features/           Auth, Store, Services, Deliveries, Contacts, Admin"
Write-Host "│   │   ├── core/               API, Providers, Storage, Auth, Services"
Write-Host "│   │   ├── shared/             Widgets, Extensions, Theme"
Write-Host "│   │   ├── main.dart"
Write-Host "│   │   └── app.dart"
Write-Host "│   ├── 📁 android/             📱 Código Android (Gradle, APK)"
Write-Host "│   ├── 📁 ios/                 🍎 Código iOS (Xcode, IPA)"
Write-Host "│   ├── 📁 assets/              📸 Imágenes e íconos"
Write-Host "│   ├── 📁 web/                 🌐 Soporte web (opcional)"
Write-Host "│   ├── 📁 linux/               🐧 Soporte Linux (opcional)"
Write-Host "│   ├── 📁 macos/               💻 Soporte macOS (opcional)"
Write-Host "│   ├── 📁 windows/             🪟 Soporte Windows (opcional)"
Write-Host "│   ├── 📁 test/                ✔️ Tests unitarios"
Write-Host "│   ├── 📄 pubspec.yaml         📦 Dependencias Flutter"
Write-Host "│   ├── 📄 pubspec.lock         🔒 Lock de versiones"
Write-Host "│   ├── 📄 .env                 🔑 Variables (API_BASE_URL, etc.)"
Write-Host "│   ├── 📄 analysis_options.yaml📋 Reglas Dart"
Write-Host "│   └── 📄 ... (configs Flutter)"
Write-Host "│"
Write-Host "├── 📁 backend/                 ✅ COMPLETADO" -ForegroundColor Magenta
Write-Host "│   ├── 📁 apps/                🗂️ Aplicaciones Django"
Write-Host "│   │   ├── users/              👤 Usuarios + Auth + Permisos"
Write-Host "│   │   ├── store/              🛒 Tienda (Commerce, Product, Order)"
Write-Host "│   │   ├── services/           🔧 Servicios (Provider, Request)"
Write-Host "│   │   ├── deliveries/         🛵 Domicilios (Deliverer, Request, FinRecord)"
Write-Host "│   │   ├── contacts/           📞 Contactos (Directorio local)"
Write-Host "│   │   └── reports/            📊 Dashboard + Analytics"
Write-Host "│   ├── 📁 runners_project/     ⚙️ Configuración Django"
Write-Host "│   │   ├── settings/           base, development, production"
Write-Host "│   │   ├── urls.py"
Write-Host "│   │   ├── wsgi.py"
Write-Host "│   │   └── asgi.py"
Write-Host "│   ├── 📁 media/               📁 Uploads (fotos, archivos)"
Write-Host "│   ├── 📁 migrations/          🔄 Migraciones aplicadas"
Write-Host "│   ├── 📄 manage.py            🎛️ CLI Django"
Write-Host "│   ├── 📄 requirements.txt     📦 Dependencias Python"
Write-Host "│   ├── 📄 .env                 🔑 Variables (DB, CORS, JWT)"
Write-Host "│   ├── 📄 db.sqlite3          💾 Base de datos + datos prueba"
Write-Host "│   ├── 📄 runners_api_postman.json 📮 Colección endpoints"
Write-Host "│   └── ... (configs Django)"
Write-Host "│"
Write-Host "├── 📁 .venv/                   🐍 Entorno virtual Python" -ForegroundColor Blue
Write-Host "│   ├── Scripts/                 python.exe, pip.exe, etc."
Write-Host "│   ├── Lib/site-packages/      Paquetes instalados (Django, DRF, Pillow, etc.)"
Write-Host "│   └── pyvenv.cfg"
Write-Host "│"
Write-Host "├── 📚 INDICE.md                📍 Tabla de contenidos (EMPIEZA AQUÍ)" -ForegroundColor Yellow
Write-Host "├── 📚 README.md                📖 Documentación completa" -ForegroundColor Yellow
Write-Host "├── 📚 QUICKSTART.md            ⚡ Ejecutar en 2 minutos" -ForegroundColor Yellow
Write-Host "├── 📚 PROYECTO_ESTRUCTURA.md   📐 Estructura detallada" -ForegroundColor Yellow
Write-Host "├── 📚 VERIFICACION.md          ✅ Checklist funcional" -ForegroundColor Yellow
Write-Host "├── 📚 runners_flutter_implementacion.md   🎯 Detalles Flutter"
Write-Host "├── 📚 runners_guia_implementacion_web.md  🎯 Detalles Backend"
Write-Host "├── 📚 Flutter_Auth_Screens.md  🔐 Pantallas auth"
Write-Host "│"
Write-Host "├── 📄 runners.iml              IDE config"
Write-Host "├── 📄 .gitignore               Git exclusions"
Write-Host "└── ... (otros archivos)"
Write-Host ""

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "📊 ESTADÍSTICAS" -ForegroundColor Green
Write-Host ""
Write-Host "Frontend:" -ForegroundColor Yellow
Write-Host "  ├─ Pantallas: 15+ screens completamente funcionales" -ForegroundColor Gray
Write-Host "  ├─ Providers: 12+ Riverpod notifiers" -ForegroundColor Gray
Write-Host "  ├─ Dependencias: 69 paquetes (Flutter)" -ForegroundColor Gray
Write-Host "  └─ Líneas código: ~8000+ líneas Dart" -ForegroundColor Gray
Write-Host ""
Write-Host "Backend:" -ForegroundColor Yellow
Write-Host "  ├─ Apps: 6 aplicaciones Django" -ForegroundColor Gray
Write-Host "  ├─ Modelos: 15+ modelos" -ForegroundColor Gray
Write-Host "  ├─ Endpoints: 30+ REST endpoints" -ForegroundColor Gray
Write-Host "  ├─ Datos: 9 usuarios + seed data" -ForegroundColor Gray
Write-Host "  ├─ Dependencias: 15 paquetes (Django)" -ForegroundColor Gray
Write-Host "  └─ Migraciones: todas aplicadas (0 pending)" -ForegroundColor Gray
Write-Host ""

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "✨ CARACTERÍSTICAS" -ForegroundColor Green
Write-Host ""
Write-Host "✅ Autenticación" -ForegroundColor Green
Write-Host "   JWT Bearer tokens con refresh automático (60min/30días)"
Write-Host ""
Write-Host "✅ Tienda" -ForegroundColor Green
Write-Host "   Catálogo de productos, carrito local, órdenes"
Write-Host ""
Write-Host "✅ Domicilios" -ForegroundColor Green
Write-Host "   AUTO-ASSIGN automático a domiciliarios disponibles"
Write-Host ""
Write-Host "✅ Servicios" -ForegroundColor Green
Write-Host "   Categorías, proveedores con aprobación admin"
Write-Host ""
Write-Host "✅ Contactos" -ForegroundColor Green
Write-Host "   Directorio local (Caicedonia) sin edición cliente"
Write-Host ""
Write-Host "✅ Admin" -ForegroundColor Green
Write-Host "   Dashboard, reportes, gestión de permisos"
Write-Host ""

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 CÓMO EJECUTAR" -ForegroundColor Yellow
Write-Host ""
Write-Host "Backend (Terminal 1):" -ForegroundColor Cyan
Write-Host "  cd backend" -ForegroundColor Gray
Write-Host "  python manage.py runserver 0.0.0.0:8000" -ForegroundColor Gray
Write-Host ""
Write-Host "Frontend (Terminal 2):" -ForegroundColor Cyan
Write-Host "  cd frontend" -ForegroundColor Gray
Write-Host "  flutter run" -ForegroundColor Gray
Write-Host ""
Write-Host "📍 Servidor: http://localhost:8000" -ForegroundColor Green
Write-Host "📍 API: http://10.0.2.2:8000/api/v1 (emulador Android)" -ForegroundColor Green
Write-Host "📍 Admin: http://localhost:8000/admin/" -ForegroundColor Green
Write-Host ""

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "✅ Proyecto 100% reorganizado y funcional" -ForegroundColor Green
Write-Host "📚 Ver INDICE.md para toda la documentación" -ForegroundColor Cyan
Write-Host "⚡ Ver QUICKSTART.md para ejecutar inmediatamente" -ForegroundColor Cyan
Write-Host ""
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
