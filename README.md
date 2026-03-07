# 🏃 Sistema Web Runners

**Plataforma de Intermediación de Servicios y Domicilios**  
Caicedonia, Valle del Cauca — Fundada 2019

## Descripción

Runners es una plataforma web que conecta a la comunidad de Caicedonia con:
- 🛒 **Tiendas y restaurantes** — Pedidos en línea
- 🔧 **Prestadores de servicios** — Intermediación profesional
- 🏍️ **Domiciliarios** — Gestión de pedidos y control financiero
- 📞 **Contactos de emergencia** — Directorio con disponibilidad

## Stack Tecnológico

- **Backend:** Python 3.12 + Django 5.2.6 + Django REST Framework
- **Frontend:** React 19 + Vite 7
- **Base de datos:** SQLite (desarrollo) / PostgreSQL (producción)
- **Autenticación:** JWT (djangorestframework-simplejwt)

## Configuración del Entorno

### Backend

```bash
cd backend
python -m venv venv

# Windows
venv\Scripts\activate

# Linux/Mac
source venv/bin/activate

pip install -r requirements.txt
cp .env.example .env
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

Servidor en: http://localhost:8000

### Frontend

```bash
cd frontend
npm install
cp .env.example .env
npm run dev
```

Servidor en: http://localhost:5173

## Estructura del Proyecto

```
runners/
├── backend/           # Django REST Framework
│   ├── apps/
│   │   ├── users/     # Gestión de usuarios y roles
│   │   ├── store/     # Módulo Tienda
│   │   ├── services/  # Módulo Servicios
│   │   ├── deliveries/# Módulo Domicilios
│   │   ├── contacts/  # Módulo Contactos
│   │   └── reports/   # Módulo Reportes
│   └── runners_project/
├── frontend/          # React + Vite
│   └── src/
└── docs/              # Documentación
```

## API Endpoints

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/api/v1/auth/register/` | Registro de usuario |
| POST | `/api/v1/auth/login/` | Login JWT |
| POST | `/api/v1/auth/token/refresh/` | Renovar token |
| GET | `/api/v1/store/commerces/` | Listar comercios |
| POST | `/api/v1/store/orders/create/` | Crear pedido |
| GET | `/api/v1/services/providers/` | Prestadores disponibles |
| GET | `/api/v1/deliveries/deliverers/` | Listar domiciliarios |
| GET | `/api/v1/contacts/` | Directorio de contactos |
| GET | `/api/v1/reports/dashboard/` | Resumen admin |

## Equipo

3 desarrolladores | Duración: 4 meses

## Licencia

Proyecto privado — Runners © 2024
