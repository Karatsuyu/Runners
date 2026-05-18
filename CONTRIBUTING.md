# Guía de Contribución

Este repositorio es mantenido por un equipo de tres desarrolladores. Este documento define el flujo de trabajo estándar para mantener el desarrollo limpio y predecible.

## 1) Flujo de trabajo del equipo

- Mantener `main` siempre estable y desplegable.
- No hacer commits directos a `main` para trabajo de funcionalidades.
- Usar ramas de corta duración y abrir Pull Requests.
- Requerir al menos una revisión antes de hacer merge.
- Preferir PR pequeñas enfocadas en un solo tema.

## 2) Estrategia de ramas

Crear ramas desde `main` usando uno de estos prefijos:

- `feature/<scope>-<short-description>`
- `fix/<scope>-<short-description>`
- `refactor/<scope>-<short-description>`
- `docs/<scope>-<short-description>`
- `chore/<scope>-<short-description>`
- `hotfix/<scope>-<short-description>`

Ejemplos:

- `feature/frontend-auth-refresh-token`
- `feature/backend-deliveries-auto-assign`
- `fix/backend-services-provider-validation`
- `docs/project-team-onboarding`

## 3) Convención de commits

Usar mensajes de commit concisos y semánticos:

- `feat(frontend): add login token refresh`
- `feat(backend): add deliveries auto-assign endpoint`
- `fix(frontend): handle 401 token expiration`
- `refactor(backend): split services serializers`
- `docs: update onboarding and run instructions`
- `chore: update gitignore and env templates`

Reglas:

- Mantener el asunto por debajo de ~72 caracteres cuando sea posible.
- Usar presente e imperativo.
- Un cambio lógico por commit.
- No usar emojis en mensajes de commit.

## 4) Proceso de Pull Request

1. Actualizar `main` local.
2. Crear una rama desde `main`.
3. Hacer commits en bloques lógicos.
4. Hacer push de la rama a origin.
5. Abrir PR hacia `main`.
6. Solicitar revisión de al menos un compañero.
7. Atender feedback.
8. Hacer merge solo cuando los checks pasen.

## 5) Tamaño y alcance de PR

- Preferir PR por debajo de ~500 líneas cambiadas cuando sea posible.
- Separar cambios de backend/frontend/docs en PR independientes, salvo que estén fuertemente acoplados.
- Si un cambio es grande, dividirlo en PR encadenadas.

## 6) Checks de calidad de código

### Frontend (Flutter)

Ejecutar antes de abrir la PR:

```powershell
Set-Location frontend
flutter pub get
flutter analyze
flutter test
```

### Backend (Django)

Ejecutar antes de abrir la PR:

```powershell
Set-Location backend
$c = "c:\Users\Usuario\Documents\runners\.venv\Scripts\python.exe"
& $c manage.py check
& $c manage.py test
```

Si una parte aún no tiene pruebas automáticas, incluir pasos de validación manual claros en la descripción de la PR.

## 7) Entorno y secretos

- Nunca subir secretos reales.
- Usar solo archivos plantilla:
  - `frontend/.env.example`
  - `backend/.env.example`
- Los archivos locales de ejecución están ignorados:
  - `frontend/.env`
  - `backend/.env`

## 8) Base de datos y migraciones

- Crear migraciones en la misma PR donde se introducen cambios de modelo.
- No editar migraciones ya aplicadas salvo caso excepcional.
- Verificar migraciones localmente:

```powershell
Set-Location backend
$c = "c:\Users\Usuario\Documents\runners\.venv\Scripts\python.exe"
& $c manage.py makemigrations
& $c manage.py migrate
```

## 9) Cambios de API

Al cambiar endpoints de backend:

- Actualizar serializers/views/urls de forma consistente.
- Actualizar `backend/runners_api_postman.json` si aplica.
- Documentar cambios breaking en la descripción de la PR.

## 10) Coordinación frontend-backend

Cuando cambie un contrato:

- La PR de backend debe incluir el detalle del contrato API.
- La PR de frontend debe incluir el consumo actualizado.
- Indicar el orden de despliegue requerido en la PR.

## 11) Política de merge

- Método recomendado: Squash o Rebase (decisión del equipo, manteniendo historial legible).
- Eliminar la rama después del merge.
- Si hay incidencia urgente en producción: usar `hotfix/*` y abrir PR con revisión prioritaria.

## 12) Inicio rápido para desarrolladores

```powershell
# Clonar y entrar al repositorio
Set-Location "c:\Users\Usuario\Documents"
git clone https://github.com/Karatsuyu/Runners.git
Set-Location Runners

# Backend
Set-Location backend
$c = "c:\Users\Usuario\Documents\runners\.venv\Scripts\python.exe"
& $c manage.py migrate
& $c manage.py seed_data
& $c manage.py runserver 0.0.0.0:8000

# Frontend (nueva terminal)
Set-Location "c:\Users\Usuario\Documents\runners\frontend"
flutter pub get
flutter run
```

## 13) Responsables y comunicación

- Asignar cada PR a un responsable y un revisor.
- Usar la descripción de la PR para explicar:
  - Qué cambió
  - Por qué cambió
  - Cómo se probó
  - Riesgos o tareas de seguimiento

Mantener este flujo de trabajo de forma consistente reduce regresiones y facilita el onboarding de todos los desarrolladores.
