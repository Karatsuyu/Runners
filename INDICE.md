# 📚 Índice de Documentación - Runners

## 🏠 Punto de Entrada

Empeza aquí según lo que necesites:

### Para Ejecutar la Aplicación
👉 **[QUICKSTART.md](QUICKSTART.md)** - Guía rápida (2 minutos)
- Cómo ejecutar Backend + Frontend
- Credenciales de prueba
- URLs importantes

### Para Entender la Estructura
👉 **[PROYECTO_ESTRUCTURA.md](PROYECTO_ESTRUCTURA.md)** - Estructura detallada
- Organización de carpetas
- Mapeo de flujos (Auth, Tienda, Domicilios, etc.)
- Modelos principales
- APIs disponibles

### Para Verificar el Estado
👉 **[VERIFICACION.md](VERIFICACION.md)** - Checklist de funcionalidad
- Estado actual (✅ completado)
- Pruebas de integración
- Checklist pre-refinamiento

### Para Documentación Completa
👉 **[README.md](README.md)** - Guía exhaustiva
- Stack tecnológico completo
- Features implementados
- Troubleshooting
- Variables de entorno

---

## 📁 Documentación Específica

### Frontend (Flutter)

**[runners_flutter_implementacion.md](runners_flutter_implementacion.md)**
- Detalles de cada pantalla
- Estructura de código Dart
- Riverpod providers
- Manejo de estado

**[Flutter_Auth_Screens.md](Flutter_Auth_Screens.md)**
- Pantallas de autenticación
- Flujos de login/register
- Validaciones

### Backend (Django)

**[runners_guia_implementacion_web.md](runners_guia_implementacion_web.md)**
- Guía original de backend
- Especificaciones del API
- Business logic

**[backend/runners_api_postman.json](backend/runners_api_postman.json)**
- Colección Postman/Insomnia
- Todos los endpoints documentados
- Variables de entorno

---

## 🎯 Casos de Uso

### 1. "Quiero ejecutar el proyecto"
1. Lee: [QUICKSTART.md](QUICKSTART.md)
2. Terminal 1: `cd backend && python manage.py runserver 0.0.0.0:8000`
3. Terminal 2: `cd frontend && flutter run`

### 2. "Quiero entender cómo funciona el auto-assign de domicilios"
1. Lee: [PROYECTO_ESTRUCTURA.md](PROYECTO_ESTRUCTURA.md) → Sección "3️⃣ Domicilios (AUTO-ASSIGN)"
2. Revisa: `backend/apps/deliveries/views.py` → `DeliveryRequestListCreateView`

### 3. "Quiero probar los endpoints"
1. Importa: `backend/runners_api_postman.json` en Postman/Insomnia
2. Sigue: [QUICKSTART.md](QUICKSTART.md) → "Verificar Conexión"

### 4. "Quiero agregar una nueva característica"
1. Frontend: Revisa [runners_flutter_implementacion.md](runners_flutter_implementacion.md)
2. Backend: Revisa [runners_guia_implementacion_web.md](runners_guia_implementacion_web.md)

### 5. "Quiero entender la estructura de carpetas"
1. Lee: [PROYECTO_ESTRUCTURA.md](PROYECTO_ESTRUCTURA.md) → Sección principal

---

## 🔑 Información Clave

### URLs
| Servicio | URL |
|----------|-----|
| **Backend** | `http://localhost:8000` |
| **Admin** | `http://localhost:8000/admin/` |
| **API** | `http://localhost:8000/api/v1` |
| **API (emulador)** | `http://10.0.2.2:8000/api/v1` |

### Credenciales
| Rol | Email | Password |
|-----|-------|----------|
| Admin | `admin@runners.co` | `Admin2024!` |
| Cliente | `cliente1@runners.co` | `Runners2024!` |
| Domiciliario | `domi1@runners.co` | `Runners2024!` |
| Prestador | `prest1@runners.co` | `Runners2024!` |

### Tecnologías
**Frontend:** Flutter 3.9+, Dart 3.9+, Riverpod, GoRouter, Dio
**Backend:** Django 5.2, DRF 3.16, SimpleJWT, PostgreSQL/SQLite

---

## 📊 Estado del Proyecto

### ✅ Completado
- ✅ Flutter: 0 errores, todas las pantallas funcionales
- ✅ Backend: 0 issues, 30+ endpoints
- ✅ Autenticación: JWT con refresh automático
- ✅ Auto-assign domicilios: Implementado
- ✅ Admin-mediated services: Implementado
- ✅ Datos de prueba: 9 usuarios + datos completos
- ✅ Estructura: Frontend + Backend separados

### 🎯 Próxima Fase
- Refinamiento de código
- Optimizaciones UI/UX
- Testing exhaustivo
- Build para producción (APK/IPA)

---

## 🚀 Quick Commands

```bash
# Backend
cd backend
python manage.py runserver 0.0.0.0:8000     # Ejecutar
python manage.py migrate                     # Migraciones
python manage.py seed_data                   # Datos prueba
python manage.py shell                       # Shell interactivo
python manage.py check                       # Verificar config

# Frontend
cd frontend
flutter pub get                              # Dependencias
flutter run                                  # Ejecutar
flutter build apk --release                  # Build Android
flutter clean                                # Limpiar caché
flutter analyze                              # Análisis Dart
```

---

## 📞 Recursos Adicionales

- **Flutter Docs:** https://flutter.dev
- **Django Docs:** https://docs.djangoproject.com
- **REST Framework:** https://www.django-rest-framework.org
- **Riverpod:** https://riverpod.dev
- **GoRouter:** https://pub.dev/packages/go_router

---

## 📝 Notas Importantes

1. **Emulador Android:** Usa `10.0.2.2` en lugar de `localhost` para conectar al backend
2. **Dispositivo físico:** Usa tu IP local (ej: `192.168.1.100`)
3. **CORS:** Habilitado en desarrollo, requiere configuración en producción
4. **JWT Tokens:** Acceso 60 minutos, refresh 30 días
5. **Base de datos:** SQLite en desarrollo, PostgreSQL en producción

---

## 🎓 Flujo de Aprendizaje

**Si eres nuevo en el proyecto:**
1. Lee: [README.md](README.md)
2. Lee: [PROYECTO_ESTRUCTURA.md](PROYECTO_ESTRUCTURA.md)
3. Lee: [QUICKSTART.md](QUICKSTART.md)
4. Ejecuta el proyecto
5. Prueba endpoints con Postman
6. Explora el código

---

✅ **Documentación completa y organizada. ¡Listo para trabajar!**

*Última actualización: Marzo 12, 2026*
