# Gestión de Tiendas/Restaurantes - Admin

## Descripción

Sistema completo de gestión de tiendas y restaurantes con soporte para carga de PDFs de cartas/menús. Solo administradores pueden crear, editar, eliminar tiendas.

## Características

- ✅ Crear nuevas tiendas/restaurantes
- ✅ Editar información de tiendas
- ✅ Eliminar tiendas
- ✅ Subir PDF de carta/menú
- ✅ Filtrar tiendas por categoría
- ✅ Ver estado de tiendas (activas/inactivas)
- ✅ Panel de administrador integrado en Django

## Modelo de Datos

### Commerce (Comercio/Tienda)
```
- id: Identificador único
- category: Categoría del negocio (FK)
- name: Nombre de la tienda
- description: Descripción
- phone: Teléfono
- address: Dirección
- image: Imagen de la tienda
- menu_pdf: Archivo PDF de la carta/menú (NUEVO)
- is_active: Estado (activo/inactivo)
- created_at: Fecha de creación
- updated_at: Fecha de última actualización
```

## Endpoints de API

### Para todos los usuarios (lectura):
```
GET /api/store/commerces/
  - Retorna: Lista de tiendas activas
  - Filtros: ?category=ID

GET /api/store/commerces/{id}/
  - Retorna: Detalle completo de la tienda con productos
```

### Para administradores (acceso total):
```
# Crear tienda
POST /api/store/admin/commerces/
Content-Type: multipart/form-data
{
  "category": 1,
  "name": "Mi Restaurante",
  "description": "Descripción del negocio",
  "phone": "+57 300 1234567",
  "address": "Calle Principal 123",
  "image": <archivo>,
  "menu_pdf": <archivo PDF>,
  "is_active": true
}

# Listar todas las tiendas (activas e inactivas)
GET /api/store/admin/commerces/
  - Filtros: ?category=ID&is_active=true

# Obtener detalles de una tienda
GET /api/store/admin/commerces/{id}/

# Editar tienda
PUT /api/store/admin/commerces/{id}/
PATCH /api/store/admin/commerces/{id}/
Content-Type: multipart/form-data
{
  "name": "Nombre actualizado",
  "menu_pdf": <nuevo PDF>,
  ...
}

# Eliminar tienda
DELETE /api/store/admin/commerces/{id}/
```

## Estructura de Archivos

### Backend
```
backend/apps/store/
├── models.py                 # Modelos (actualizado con menu_pdf)
├── serializers.py            # Serializadores (actualizado)
├── views.py                  # Vistas (nuevas vistas para admin)
├── urls.py                   # URLs (nuevos endpoints)
├── admin.py                  # Panel de Django admin (mejorado)
├── migrations/
│   └── 0002_commerce_menu_pdf.py  # Nueva migración
└── ...
```

## Uso del Panel de Administrador Django

1. Acceder a: `http://localhost:8000/admin/`
2. Iniciar sesión con cuenta de administrador
3. En la sección "Store Commerces", puede:
   - Crear nuevas tiendas
   - Editar tiendas existentes
   - Subir/cambiar imagen e PDF
   - Cambiar estado (activo/inactivo)
   - Eliminar tiendas

## Permisos

- **Lectura (GET)**: Todos los usuarios autenticados
- **Creación (POST)**: Solo administradores
- **Edición (PUT/PATCH)**: Solo administradores
- **Eliminación (DELETE)**: Solo administradores

## Validaciones

- Los precios de productos deben ser mayores a cero
- El archivo PDF debe ser un archivo válido
- La imagen debe ser un archivo de imagen válido
- Solo las tiendas activas se muestran a usuarios normales

## Migración de Base de Datos

```bash
cd backend
python manage.py makemigrations
python manage.py migrate
```

## Próximos Pasos

- [ ] Crear interfaz en Flutter para administradores
- [ ] Agregar vista previa de PDF en la app móvil
- [ ] Implementar sincronización de medios
