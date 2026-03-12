# 🚀 Quick Start - Runners

## 🎯 Ejecutar Ambos (Frontend + Backend)

### Opción 1: Dos Terminales (Recomendado)

**Terminal 1 - Backend:**
```powershell
cd backend
..\\.venv\\Scripts\\Activate.ps1
python manage.py runserver 0.0.0.0:8000
```

**Terminal 2 - Frontend:**
```powershell
cd frontend
flutter run
```

### Opción 2: Una Sola Terminal

```powershell
# Abrir 2 procesos en paralelo
Start-Process -NoNewWindow -FilePath "powershell" -ArgumentList '-Command "cd backend; ..\\.venv\\Scripts\\Activate.ps1; python manage.py runserver 0.0.0.0:8000"'
Start-Process -NoNewWindow -FilePath "powershell" -ArgumentList '-Command "cd frontend; flutter run"'
```

---

## 📋 Checklist Inicial

- [ ] Python 3.9+ instalado
- [ ] Flutter SDK instalado (`flutter --version`)
- [ ] Android Studio / Xcode (para emulador)
- [ ] Emulador Android o iOS iniciado
- [ ] Variables `.env` configuradas

---

## 🔍 Verificar Conexión

**En Flutter:**
```dart
// Debería conectar a:
// Emulador Android: http://10.0.2.2:8000
// Dispositivo físico: http://192.168.x.x:8000
```

**Probar Backend:**
```bash
curl -X POST http://localhost:8000/api/v1/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"cliente1@runners.co","password":"Runners2024!"}'
```

---

## 🔑 Credenciales

| Rol | Email | Password |
|-----|-------|----------|
| Admin | admin@runners.co | Admin2024! |
| Cliente | cliente1@runners.co | Runners2024! |
| Domiciliario | domi1@runners.co | Runners2024! |
| Prestador | prest1@runners.co | Runners2024! |

---

## 📁 Estructura de Carpetas

```
runners/
├── frontend/                # Flutter app
│   └── flutter run
├── backend/                 # Django REST API
│   └── python manage.py runserver
└── .venv/                   # Entorno Python compartido
```

---

## ⚡ Comandos Útiles

### Backend
```bash
cd backend

# Migraciones
python manage.py makemigrations
python manage.py migrate

# Datos de prueba
python manage.py seed_data

# Panel admin
python manage.py runserver
# Luego ir a: http://localhost:8000/admin/

# Shell interactivo
python manage.py shell
```

### Frontend
```bash
cd frontend

# Obtener dependencias
flutter pub get

# Limpiar caché
flutter clean

# Build APK (Android)
flutter build apk --release

# Build IPA (iOS)
flutter build ios --release
```

---

## 🆘 Problemas Comunes

| Problema | Solución |
|----------|----------|
| "No estoy conectando al backend" | Cambiar URL a `http://10.0.2.2:8000` en emulador Android |
| "Error de CORS" | Verificar `CORS_ALLOW_ALL_ORIGINS=True` en backend/.env |
| "Database locked" | Cerrar server y ejecutar `python manage.py migrate` |
| "Token inválido" | Logout y login nuevamente |
| "Módulo no encontrado" | Ejecutar `pip install -r requirements.txt` |

---

## 📞 URLs Importantes

- **API Base:** `http://10.0.2.2:8000/api/v1` (emulador)
- **Admin Panel:** `http://localhost:8000/admin/`
- **Postman:** Ver `backend/runners_api_postman.json`
- **Docs:** Ver `README.md`

---

**¡Listo! La app debería estar ejecutándose en segundos.** 🎉
