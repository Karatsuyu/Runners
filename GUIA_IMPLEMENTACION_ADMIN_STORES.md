# Guía de Implementación - Gestión de Tiendas para Administradores

## 📱 Frontend Flutter

### Archivos Creados

1. **`lib/features/admin/presentation/screens/store_admin_screen.dart`**
   - Pantalla de listado de tiendas
   - Diálogo para crear/editar tiendas
   - Gestión de eliminación con confirmación

2. **`lib/features/admin/presentation/providers/store_admin_provider.dart`**
   - Modelos de datos (`AdminCommerceModel`)
   - DataSource (`AdminStoreDataSource`)
   - Repository (`AdminStoreRepository`)
   - Providers para Riverpod

### Funcionalidades Implementadas

#### 📋 StoreAdminListScreen
- **Listar todas las tiendas** (activas e inactivas)
- **Crear nueva tienda** - Botón FAB en AppBar
- **Editar tienda existente** - Clic en botón "Editar"
- **Eliminar tienda** - Con confirmación de seguridad
- **Indicadores visuales** - Estado de tienda, PDF cargado, etc.
- **Refresh** - Actualizar lista manualmente

#### ✏️ StoreAdminEditDialog
- Formulario completo con campos:
  - Nombre (obligatorio)
  - Descripción
  - Teléfono
  - Dirección
  - Estado (activo/inactivo)
  - Carga de PDF de menú
- Validación básica
- Indicador de carga

### Integración en la Navegación

Agregar a `lib/core/router/app_routes.dart`:

```dart
class AppRoutes {
  // ... rutas existentes ...
  
  static const String adminStores = '/admin/stores';
  
  static List<GoRoute> adminRoutes = [
    // ... otras rutas ...
    GoRoute(
      path: 'stores',
      builder: (context, state) => const StoreAdminListScreen(),
      name: 'admin_stores',
    ),
  ];
}
```

Agregar a la navegación del Dashboard:

```dart
ListTile(
  leading: const Icon(Icons.store_outlined),
  title: const Text('Gestión de Tiendas'),
  onTap: () => context.go(AppRoutes.adminStores),
),
```

### Instalación de Dependencias

Si no está instalada la dependencia `file_picker`, agregar a `pubspec.yaml`:

```yaml
dependencies:
  file_picker: ^5.5.0
```

Luego ejecutar: `flutter pub get`

---

## 🔧 Backend Django

### Cambios Realizados

1. **Modelo actualizado** (`models.py`)
   - Campo `menu_pdf` agregado a `Commerce`
   - Almacenamiento en `store/menus/`

2. **Serializador mejorado** (`serializers.py`)
   - Incluye `menu_pdf` en los campos
   - Read-only fields configurados correctamente
   - Timestamps incluidos

3. **Vistas específicas** (`views.py`)
   - `CommerceAdminListView` - Listado completo para admin
   - `CommerceAdminDetailView` - Detalle y edición para admin

4. **URLs actualizadas** (`urls.py`)
   - `/store/admin/commerces/` - Listado (GET, POST)
   - `/store/admin/commerces/{id}/` - Detalle (GET, PUT, PATCH, DELETE)

5. **Admin panel mejorado** (`admin.py`)
   - Campos visibles en lista
   - Indicador de PDF cargado
   - Organización de campos en secciones

### Migración de Base de Datos

```bash
cd backend
python manage.py makemigrations
python manage.py migrate
```

Archivo de migración: `migrations/0002_commerce_menu_pdf.py`

---

## 🔐 Permisos y Seguridad

### Rutas de API

| Endpoint | Método | Permisos | Descripción |
|----------|--------|----------|-------------|
| `/store/admin/commerces/` | GET | Admin | Listar todas (activas/inactivas) |
| `/store/admin/commerces/` | POST | Admin | Crear tienda |
| `/store/admin/commerces/{id}/` | GET | Admin | Obtener detalles |
| `/store/admin/commerces/{id}/` | PUT/PATCH | Admin | Editar tienda |
| `/store/admin/commerces/{id}/` | DELETE | Admin | Eliminar tienda |

### Seguridad

✅ Solo usuarios con `role=ADMIN` pueden acceder
✅ Validación en el backend con `IsAdmin` permission
✅ Validación en el frontend con proveedores

---

## 📤 Carga de Archivos

### Tipos soportados

- **PDF**: Para menús/cartas
- **Imágenes**: Para foto de tienda (JPG, PNG)

### Límites recomendados

- Tamaño máximo PDF: 5MB
- Tamaño máximo imagen: 2MB

### Configuración en Django

En `settings.py`:

```python
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

# Límite de carga
FILE_UPLOAD_MAX_MEMORY_SIZE = 5242880  # 5MB
DATA_UPLOAD_MAX_MEMORY_SIZE = 5242880
```

En `urls.py`:

```python
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
```

---

## 🧪 Pruebas Recomendadas

### En Postman

1. **Crear tienda**
   ```
   POST /store/admin/commerces/
   Content-Type: multipart/form-data
   Authorization: Bearer <token_admin>
   
   name: "Test Restaurante"
   category: 1
   phone: "+57 300 1234567"
   address: "Calle Principal 123"
   menu_pdf: <archivo.pdf>
   is_active: true
   ```

2. **Listar tiendas**
   ```
   GET /store/admin/commerces/
   GET /store/admin/commerces/?is_active=true
   GET /store/admin/commerces/?category=1
   ```

3. **Editar tienda**
   ```
   PUT /store/admin/commerces/1/
   Content-Type: multipart/form-data
   ```

4. **Eliminar tienda**
   ```
   DELETE /store/admin/commerces/1/
   ```

---

## 🎨 Componentes UI Usados

- `StoreAdminListScreen` - Pantalla principal
- `StoreAdminEditDialog` - Formulario de creación/edición
- `_CommerceCard` - Tarjeta de tienda
- Widgets compartidos: `AppButton`, `AppTextField`, `AppLoading`, `AppErrorWidget`

---

## 📝 Próximas Mejoras

- [ ] Vista previa de PDF
- [ ] Galería de imágenes múltiples
- [ ] Búsqueda y filtrado avanzado
- [ ] Paginación de resultados
- [ ] Historial de cambios
- [ ] Estadísticas por tienda
- [ ] Integración con productos
- [ ] Exportar datos a CSV

---

## 🐛 Troubleshooting

### Error: "Unauthorized" al crear tienda
- Verificar que el usuario tiene role `ADMIN`
- Verificar que el token está siendo enviado correctamente
- Revisar los headers de autenticación

### Error al cargar PDF
- Verificar tamaño del archivo (máx 5MB)
- Verificar que sea un PDF válido
- Revisar permisos de carpeta `media/store/menus/`

### Tienda no aparece en listado
- Verificar que tiene `is_active=true` (si buscas activas)
- Verificar que tiene categoría válida
- Ejecutar `python manage.py migrate` si es necesario

