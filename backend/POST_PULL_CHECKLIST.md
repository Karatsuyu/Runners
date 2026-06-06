POST-PULL Checklist — Backend (rápido)

Propósito
- Pasos mínimos que debe seguir cada desarrollador después de hacer `git pull origin main` para dejar el entorno local en buen estado y poder probar login.

1) Actualizar código

```bash
# desde la raíz del repo
git checkout main
git pull origin main
```

2) Preparar el entorno Python (si no lo tienen)

```bash
# crear y activar virtualenv (Windows PowerShell)
python -m venv .venv
.\.venv\Scripts\Activate.ps1

# o (macOS / Linux)
python3 -m venv .venv
source .venv/bin/activate

pip install -r backend/requirements.txt
```

3) Variables de entorno
- Asegúrate de tener las variables necesarias (DB, SECRET_KEY, DEBUG, etc.). Si usan `.env`, cargarlo según su flujo.

4) Aplicar migraciones

```bash
cd backend
python manage.py migrate
```

Notas:
- Si aparece un conflicto de migraciones (mensaje que sugiere `makemigrations --merge`) avisa al equipo. En la mayoría de los casos hacer:

```bash
python manage.py makemigrations --merge
python manage.py migrate
```

- Si el comando `migrate` falla por historial inconsistente, contacta al responsable o sigue el procedimiento del repositorio (no forzar sin revisar cambios en remoto).

5) Cargar datos semilla (opcional)

```bash
# si el proyecto incluye un comando de seed
python manage.py seed_data
# o si hay fixtures
python manage.py loaddata initial_data.json
```

6) Crear superuser (si necesitas acceder al admin)

```bash
python manage.py createsuperuser --email admin@runners.co
```

7) Verificar login y correr servidor

```bash
# ejecutar servidor local
python manage.py runserver 0.0.0.0:8000
# probar endpoint de login (curl ejemplo):
curl -X POST http://localhost:8000/api/v1/auth/login/ -H "Content-Type: application/json" -d '{"email":"cliente1@runners.co","password":"Runners2024!"}'
```

Respuesta esperada (éxito): JSON con `access` y `refresh` (o `{ "tokens": { "access": ..., "refresh": ... } }` dependiendo del cliente).

8) Problemas comunes y soluciones rápidas
- Error: "no such column: runners_users.username" → ejecutar `python manage.py migrate` (la migración que añade `username` no está aplicada).
- Error: import-time NameError al arrancar (p.ej. `DeliveryZone` no definido) → revisa que los archivos `apps/*/migrations` y `models.py` estén sincronizados; en caso de duda contacta al autor del merge.
- Si ves `LF/CRLF` warnings en archivos generados (Flutter), no es crítico para el backend; evita commitearlos si no son cambios funcionales.

9) Confirmación
- Después de `migrate` y `runserver`, prueba el login con `curl` o desde el frontend; debe devolver `access` y `refresh`.

Contacto
- Si algo falla y no puedes resolverlo con lo anterior, abre una issue o contacta a la persona que hizo el merge (revisar el commit con el arreglo de auth en `main`).

---
Breve nota: ya subí las correcciones de backend a `main`; este checklist cubre los pasos mínimos para que tu equipo actualice y verifique localmente.
