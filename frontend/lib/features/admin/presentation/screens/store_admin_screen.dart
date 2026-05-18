import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../shared/widgets/pdf_thumbnail.dart';
import '../../../../shared/widgets/pdf_viewer_screen.dart';
import '../../../../shared/widgets/image_viewer_screen.dart';
import '../../../../core/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/store_admin_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

// Resuelve rutas relativas de imágenes devueltas por el backend a URLs completas
String? resolveImageUrl(String? img) {
  if (img == null || img.isEmpty) return null;
  // If absolute URL, return as-is but add cache-buster for menu files
  final bool isMenuPath = img.contains('store/menus/');
  if (img.startsWith('http')) {
    if (isMenuPath) {
      final sep = img.contains('?') ? '&' : '?';
      return '$img${sep}t=${DateTime.now().millisecondsSinceEpoch}';
    }
    return img;
  }

  final root = ApiConstants.baseUrl.replaceFirst('/api/v1', '');
  String full = img.startsWith('/') ? '$root$img' : '$root/$img';
  if (isMenuPath) {
    final sep = full.contains('?') ? '&' : '?';
    full = '$full${sep}t=${DateTime.now().millisecondsSinceEpoch}';
  }
  return full;
}

// ─────────────────────────────────────────────────────────────────────────────
// Store Admin Management Screens
// ─────────────────────────────────────────────────────────────────────────────

class StoreAdminListScreen extends ConsumerWidget {
  const StoreAdminListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commercesAsync = ref.watch(adminCommercesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Gestión de Tiendas'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined),
            tooltip: 'Gestionar categorías',
            onPressed: () => _openCategoryManager(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openCreateDialog(context, ref),
            tooltip: 'Crear tienda',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(adminCommercesProvider),
          ),
        ],
      ),
      body: commercesAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => AppErrorWidget(
          message: 'Error cargando tiendas: $e',
          onRetry: () => ref.invalidate(adminCommercesProvider),
        ),
        data: (commerces) {
          if (commerces.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.store_outlined, size: 64, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text(
                    'No hay tiendas registradas',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Crear Primera Tienda',
                    onPressed: () => _openCreateDialog(context, ref),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.primaryGreen,
            onRefresh: () async => ref.invalidate(adminCommercesProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: commerces.length,
              itemBuilder: (context, index) {
                final commerce = commerces[index];
                return _CommerceCard(
                  commerce: commerce,
                  onEdit: () => _openEditDialog(context, ref, commerce),
                  onDelete: () => _confirmDelete(context, ref, commerce.id),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _openCreateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => StoreAdminEditDialog(
        onSave: (data) async {
          try {
            await ref.read(storeAdminProvider).createCommerce(data);
            ref.invalidate(adminCommercesProvider);
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tienda creada exitosamente')),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _openEditDialog(BuildContext context, WidgetRef ref, AdminCommerceModel commerce) async {
    final repo = ref.read(storeAdminProvider);
    try {
      final detail = await repo.getCommerceDetail(commerce.id);
      // DEBUG: show how many menu_files arrived and log full list to console
      final count = detail.menuFiles?.length ?? 0;
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('DEBUG: menu_files count = $count')));
      // Print to console for deeper inspection
      debugPrint('DEBUG menu_files: ${detail.menuFiles}');
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => StoreAdminEditDialog(
          initialData: detail,
          onSave: (data) async {
            try {
              await ref.read(storeAdminProvider).updateCommerce(commerce.id, data);
              ref.invalidate(adminCommercesProvider);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tienda actualizada exitosamente')),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            }
          },
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No se pudo cargar detalles: $e')));
      }
    }
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, int commerceId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Deseas eliminar esta tienda? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              try {
                await ref.read(storeAdminProvider).deleteCommerce(commerceId);
                ref.invalidate(adminCommercesProvider);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tienda eliminada exitosamente')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _openCategoryManager(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => CategoryManagerDialog(),
    );
  }
}

class _CommerceCard extends StatelessWidget {
  final AdminCommerceModel commerce;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CommerceCard({
    required this.commerce,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        commerce.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        commerce.categoryName,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: commerce.isActive
                        ? AppColors.success.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    commerce.isActive ? 'Activa' : 'Inactiva',
                    style: TextStyle(
                      fontSize: 11,
                      color: commerce.isActive ? AppColors.success : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (commerce.image != null && commerce.image!.isNotEmpty)
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(resolveImageUrl(commerce.image!)!),
                    backgroundColor: Colors.transparent,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(commerce.phone, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 12),
                if (commerce.menuPdf != null) ...[
                  Builder(builder: (_) {
                    final url = commerce.menuPdf!;
                    final lower = url.toLowerCase();
                    if (lower.endsWith('.pdf')) {
                      return Row(children: const [
                        Icon(Icons.picture_as_pdf_outlined, size: 14, color: AppColors.warning),
                        SizedBox(width: 4),
                        Text('PDF', style: TextStyle(fontSize: 12, color: AppColors.warning)),
                      ]);
                    }
                    return Row(children: const [
                      Icon(Icons.image_outlined, size: 14, color: AppColors.primaryGreen),
                      SizedBox(width: 4),
                      Text('Imagen', style: TextStyle(fontSize: 12, color: AppColors.primaryGreen)),
                    ]);
                  }),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Editar'),
                ),
                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outlined, size: 18, color: Colors.red),
                  label: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StoreAdminEditDialog extends ConsumerStatefulWidget {
  final AdminCommerceModel? initialData;
  final Future<void> Function(FormData data) onSave;

  const StoreAdminEditDialog({
    super.key,
    this.initialData,
    required this.onSave,
  });

  @override
  ConsumerState<StoreAdminEditDialog> createState() => _StoreAdminEditDialogState();
}

class CategoryManagerDialog extends ConsumerWidget {
  const CategoryManagerDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(adminCategoriesProvider);

    return AlertDialog(
      title: const Text('Gestionar Categorías'),
      content: SizedBox(
        width: double.maxFinite,
        child: categoriesAsync.when(
          loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
          error: (e, _) => Text('Error cargando categorías: $e'),
          data: (categories) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () => _openCreateCategoryDialog(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Crear categoría'),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final c = categories[index];
                    return ListTile(
                      title: Text(c.name),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _openEditCategoryDialog(context, ref, c),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _confirmDeleteCategory(context, ref, c.id),
                        ),
                      ]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
      ],
    );
  }

  void _openCreateCategoryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => _CategoryEditDialog(onSave: (name) async {
        try {
          final repo = ref.read(adminStoreCategoryRepositoryProvider);
          await repo.createCategory(name);
          ref.invalidate(adminCategoriesProvider);
          if (context.mounted) Navigator.pop(context);
        } catch (e) {
          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }),
    );
  }

  void _openEditCategoryDialog(BuildContext context, WidgetRef ref, AdminCategoryModel category) {
    showDialog(
      context: context,
      builder: (_) => _CategoryEditDialog(
        initialName: category.name,
        onSave: (name) async {
          try {
            final repo = ref.read(adminStoreCategoryRepositoryProvider);
            await repo.updateCategory(category.id, name);
            ref.invalidate(adminCategoriesProvider);
            if (context.mounted) Navigator.pop(context);
          } catch (e) {
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
          }
        },
      ),
    );
  }

  void _confirmDeleteCategory(BuildContext context, WidgetRef ref, int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Eliminar esta categoría? Esto puede afectar tiendas asociadas.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              try {
                final repo = ref.read(adminStoreCategoryRepositoryProvider);
                await repo.deleteCategory(id);
                ref.invalidate(adminCategoriesProvider);
                Navigator.pop(context);
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _CategoryEditDialog extends StatefulWidget {
  final String? initialName;
  final Future<void> Function(String name) onSave;

  const _CategoryEditDialog({this.initialName, required this.onSave});

  @override
  State<_CategoryEditDialog> createState() => _CategoryEditDialogState();
}

class _CategoryEditDialogState extends State<_CategoryEditDialog> {
  late TextEditingController _ctrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.initialName ?? '');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialName == null ? 'Crear categoría' : 'Editar categoría'),
      content: TextField(controller: _ctrl, decoration: const InputDecoration(labelText: 'Nombre')),
      actions: [
        TextButton(onPressed: _loading ? null : () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(
          onPressed: _loading ? null : _save,
          child: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Guardar'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final name = _ctrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _loading = true);
    try {
      await widget.onSave(name);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _StoreAdminEditDialogState extends ConsumerState<StoreAdminEditDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  int? selectedCategoryId;
  bool isActive = true;
  String? selectedMenuPdfPath;
  List<String> selectedMenuPdfPaths = [];
  bool isLoading = false;
  String? selectedImagePath;
  List<Map<String, dynamic>> _menuFiles = [];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialData?.name ?? '');
    descriptionController = TextEditingController(text: widget.initialData?.description ?? '');
    phoneController = TextEditingController(text: widget.initialData?.phone ?? '');
    addressController = TextEditingController(text: widget.initialData?.address ?? '');
    selectedCategoryId = widget.initialData?.categoryId;
    isActive = widget.initialData?.isActive ?? true;
    // Initialize menu files from initial data so UI shows immediately,
    // then refresh from the API to get the latest list.
    _menuFiles = widget.initialData?.menuFiles ?? [];
    if (widget.initialData != null) {
      _loadMenuFiles();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _pickMenuFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
      allowMultiple: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        // Add all selected files to the pending list
        for (var f in result.files) {
          if (f.path != null) selectedMenuPdfPaths.add(f.path!);
        }
      });
    }
  }

  Future<void> _loadMenuFiles() async {
    if (widget.initialData == null) return;
    try {
      final repo = ref.read(storeAdminProvider);
      final files = await repo.getMenuFiles(widget.initialData!.id);
      if (mounted) setState(() => _menuFiles = files);
    } catch (_) {
      // ignore
    }
  }

  Future<void> _uploadMenuFile() async {
    if (widget.initialData == null) return;
    if (selectedMenuPdfPaths.isEmpty) return;
    setState(() => isLoading = true);
    try {
      final repo = ref.read(storeAdminProvider);
      // Upload all pending files sequentially
      for (final path in List<String>.from(selectedMenuPdfPaths)) {
        await repo.uploadMenuFile(widget.initialData!.id, path);
      }
      selectedMenuPdfPaths.clear();
      await _loadMenuFiles();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Archivo(s) subido(s)')));
    } catch (e) {
      debugPrint('Upload error: ${e.toString()}');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo subir el archivo')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _confirmDeleteMenuFile(BuildContext context, int fileId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Deseas eliminar este archivo de carta?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteMenuFile(fileId);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteMenuFile(int fileId) async {
    if (widget.initialData == null) return;
    try {
      final repo = ref.read(storeAdminProvider);
      await repo.deleteMenuFile(widget.initialData!.id, fileId);
      await _loadMenuFiles();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Archivo eliminado')));
    } catch (e) {
      debugPrint('Delete error: ${e.toString()}');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo eliminar el archivo')));
    }
  }

  Future<void> _openResolvedUrl(String? resolved) async {
    if (resolved == null || resolved.isEmpty) return;
    final lower = resolved.toLowerCase();
    if (lower.endsWith('.pdf')) {
      if (mounted) Navigator.of(context).push(MaterialPageRoute(builder: (_) => PdfViewerScreen(url: resolved)));
    } else {
      if (mounted) Navigator.of(context).push(MaterialPageRoute(builder: (_) => ImageViewerScreen(imageUrl: resolved)));
    }
  }

  Future<void> _replaceMenuFile(int oldFileId) async {
    if (widget.initialData == null) return;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
    );
    if (result == null) return;
    final newPath = result.files.single.path;
    if (newPath == null) return;

    setState(() => isLoading = true);
    try {
      final repo = ref.read(storeAdminProvider);
      await repo.uploadMenuFile(widget.initialData!.id, newPath);
      await repo.deleteMenuFile(widget.initialData!.id, oldFileId);
      await _loadMenuFiles();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Carta reemplazada')));
    } catch (e) {
      debugPrint('Replace error: ${e.toString()}');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo reemplazar la carta')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        selectedImagePath = result.files.single.path;
      });
    }
  }

  Future<void> _replaceLegacyMenuPdf() async {
    if (widget.initialData == null) return;
    // Pick a new file to replace the legacy menuPdf
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
    );
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null) return;

    setState(() => isLoading = true);
    try {
      final repo = ref.read(storeAdminProvider);
      // Upload as a new menu file
      await repo.uploadMenuFile(widget.initialData!.id, path);
      // Attempt to clear legacy menu_pdf field by sending empty value via update
      try {
        // Try clearing legacy menu_pdf by sending JSON null (not multipart). Backend will set field to null.
        await repo.updateCommerce(widget.initialData!.id, {'menu_pdf': null});
      } catch (_) {
        // non-fatal if backend does not accept clearing this way
      }
      await _loadMenuFiles();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Carta reemplazada')));
    } catch (e) {
      debugPrint('Replace legacy error: ${e.toString()}');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo reemplazar la carta')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _deleteLegacyMenuPdf() async {
    if (widget.initialData == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Deseas eliminar la carta actual?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => isLoading = true);
    try {
      final repo = ref.read(storeAdminProvider);
      // Try clearing legacy menu_pdf by sending JSON null
      await repo.updateCommerce(widget.initialData!.id, {'menu_pdf': null});
      await _loadMenuFiles();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Carta eliminada')));
    } catch (e) {
      debugPrint('Delete legacy error: ${e.toString()}');
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo eliminar la carta')));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // Local image resolver removed; use global `resolveImageUrl` instead.

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(adminCategoriesProvider);

    return AlertDialog(
      scrollable: true,
      title: Text(widget.initialData == null ? 'Crear Tienda' : 'Editar Tienda'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              controller: nameController,
              label: 'Nombre de la tienda',
              hintText: 'Ej: Mi Restaurante',
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: descriptionController,
              label: 'Descripción',
              hintText: 'Descripción del negocio',
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: phoneController,
              label: 'Teléfono',
              hintText: '+57 300 1234567',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: addressController,
              label: 'Dirección',
              hintText: 'Dirección del negocio',
            ),
            const SizedBox(height: 12),
            categoriesAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: LinearProgressIndicator(),
              ),
              error: (e, _) => Text(
                'No se pudieron cargar las categorías',
                style: TextStyle(color: AppColors.error),
              ),
              data: (categories) => DropdownButtonFormField<int>(
                value: selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  border: OutlineInputBorder(),
                ),
                items: (() {
                  final seen = <int>{};
                  return categories.where((c) => seen.add(c.id)).map((category) => DropdownMenuItem<int>(value: category.id, child: Text(category.name))).toList();
                })(),
                onChanged: (value) {
                  setState(() {
                    selectedCategoryId = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.08),
                  backgroundImage: selectedImagePath != null
                      ? FileImage(File(selectedImagePath!)) as ImageProvider
                      : (widget.initialData?.image != null
                          ? NetworkImage(resolveImageUrl(widget.initialData!.image!)!)
                          : null),
                  child: (selectedImagePath == null &&
                          (widget.initialData?.image == null || widget.initialData!.image!.isEmpty))
                      ? const Icon(Icons.add_a_photo_outlined, color: AppColors.primaryGreen)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedImagePath != null
                            ? 'Logo: ${selectedImagePath!.split('/').last}'
                            : (widget.initialData?.image != null ? 'Logo: Cargado' : 'Sin logo'),
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Show current carta status: filename or a 'No cargada' label.
                      Builder(builder: (_) {
                        if (_menuFiles.isNotEmpty) {
                          final first = _menuFiles.first;
                          final filename = first['filename'] as String? ?? '';
                          return Row(
                            children: [
                              Expanded(child: Text('Carta: $filename', style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                              TextButton(
                                onPressed: () async {
                                  final url = first['url'] as String?;
                                  if (url == null) return;
                                  final resolved = resolveImageUrl(url);
                                  await _openResolvedUrl(resolved);
                                },
                                child: const Text('Ver', style: TextStyle(fontSize: 12)),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  final id = first['id'] as int?;
                                  if (id == null) return;
                                  _replaceMenuFile(id);
                                },
                                icon: const Icon(Icons.edit_outlined, size: 16, color: Colors.blueGrey),
                                label: const Text('Editar', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                              ),
                              IconButton(
                                tooltip: 'Eliminar carta',
                                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                onPressed: () {
                                  final id = first['id'] as int?;
                                  if (id == null) return;
                                  _confirmDeleteMenuFile(context, id);
                                },
                              ),
                            ],
                          );
                        }

                        // Fallback: if backend still returns legacy `menuPdf` field, show it.
                        if (widget.initialData?.menuPdf != null && widget.initialData!.menuPdf!.isNotEmpty) {
                          final url = widget.initialData!.menuPdf!;
                          final name = Uri.parse(url).path.split('/').last;
                          return Row(
                            children: [
                              Expanded(child: Text('Carta: $name', style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                              TextButton(
                                onPressed: () async {
                                  final resolved = resolveImageUrl(url);
                                  await _openResolvedUrl(resolved);
                                },
                                child: const Text('Ver', style: TextStyle(fontSize: 12)),
                              ),
                            ],
                          );
                        }

                        return const Text('Carta: No cargada', style: TextStyle(fontSize: 12));
                      }),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          TextButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.photo_library, size: 18),
                            label: const Text('Logo'),
                          ),
                          // Allow picking multiple carta files (PDF or image).
                          TextButton.icon(
                            onPressed: _pickMenuFile,
                            icon: const Icon(Icons.upload_file, size: 18),
                            label: const Text('Carta (PDF/Imagen)'),
                          ),
                          // If there are pending selected files, show them with upload controls
                          if (selectedMenuPdfPaths.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Flexible(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: selectedMenuPdfPaths.map((p) {
                                    final name = p.split('/').last;
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Chip(
                                        label: Text(name, overflow: TextOverflow.ellipsis),
                                        onDeleted: () => setState(() => selectedMenuPdfPaths.remove(p)),
                                        deleteIcon: const Icon(Icons.close, size: 18),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: isLoading ? null : _uploadMenuFile,
                              child: const Text('Subir todo'),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Explicit Edit / Delete buttons for the primary carta (first uploaded file)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton.icon(
                            onPressed: (_menuFiles.isNotEmpty || (widget.initialData?.menuPdf != null && widget.initialData!.menuPdf!.isNotEmpty))
                                ? () async {
                                    if (_menuFiles.isNotEmpty) {
                                      final id = _menuFiles.first['id'] as int?;
                                      if (id != null) return _replaceMenuFile(id);
                                    }
                                    // Fallback: replace legacy menuPdf
                                    return _replaceLegacyMenuPdf();
                                  }
                                : null,
                            icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.blueGrey),
                            label: const Text('Editar carta', style: TextStyle(color: Colors.blueGrey)),
                          ),
                          const SizedBox(height: 4),
                          TextButton.icon(
                            onPressed: (_menuFiles.isNotEmpty || (widget.initialData?.menuPdf != null && widget.initialData!.menuPdf!.isNotEmpty))
                                ? () async {
                                    if (_menuFiles.isNotEmpty) {
                                      final id = _menuFiles.first['id'] as int?;
                                      if (id != null) return _confirmDeleteMenuFile(context, id);
                                    }
                                    // Fallback: delete legacy menuPdf
                                    return _deleteLegacyMenuPdf();
                                  }
                                : null,
                            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                            label: const Text('Borrar carta', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_menuFiles.isNotEmpty) ...[
              const Text('Archivos de carta cargados', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _menuFiles.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final f = _menuFiles[index];
                    final url = f['url'] as String?;
                    final filename = f['filename'] as String? ?? '';
                    final fileType = (f['file_type'] as String?) ?? '';
                    return InkWell(
                    onTap: () async {
                          final resolved = resolveImageUrl(url);
                          await _openResolvedUrl(resolved);
                    },
                      child: Card(
                        child: SizedBox(
                          width: 160,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: url != null && fileType != 'PDF'
                                    ? Image.network(resolveImageUrl(url)!, fit: BoxFit.cover)
                                    : Container(
                                        color: Colors.grey.shade100,
                                        child: const Center(child: Icon(Icons.picture_as_pdf, size: 48, color: Colors.red)),
                                      ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    Expanded(child: Text(filename, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12))),
                                    IconButton(
                                      tooltip: 'Editar carta',
                                      icon: const Icon(Icons.edit_outlined, color: Colors.blueGrey, size: 18),
                                      onPressed: () => _replaceMenuFile(f['id'] as int),
                                    ),
                                    IconButton(
                                      tooltip: 'Eliminar carta',
                                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                                      onPressed: () => _confirmDeleteMenuFile(context, f['id'] as int),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 12),
            CheckboxListTile(
              value: isActive,
              onChanged: (v) => setState(() => isActive = v ?? true),
              title: const Text('Tienda activa'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: isLoading ? null : _submit,
          child: isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Guardar'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre es obligatorio')),
      );
      return;
    }

    if (selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes seleccionar una categoría')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final formData = FormData.fromMap({
        'name': nameController.text,
        'description': descriptionController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'is_active': isActive,
        'category': selectedCategoryId,
        if (widget.initialData == null && selectedMenuPdfPaths.isNotEmpty)
          'menu_pdf': await MultipartFile.fromFile(selectedMenuPdfPaths.first),
        if (selectedImagePath != null)
          'image': await MultipartFile.fromFile(selectedImagePath!),
      });

      await widget.onSave(formData);

      // If the admin selected a carta while editing, upload it as an additional file on save.
      if (widget.initialData != null && selectedMenuPdfPaths.isNotEmpty) {
        try {
          final repo = ref.read(storeAdminProvider);
          for (final p in List<String>.from(selectedMenuPdfPaths)) {
            await repo.uploadMenuFile(widget.initialData!.id, p);
            selectedMenuPdfPaths.remove(p);
          }
          await _loadMenuFiles();
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Carta(s) subida(s)')));
        } catch (e) {
          debugPrint('Upload on save error: ${e.toString()}');
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo subir la(s) carta(s)')));
        }
      }
    } catch (e) {
      String message = 'Error al guardar: $e';
      if (e is DioException) {
        final base = ref.read(dioClientProvider).dio.options.baseUrl;
        if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.unknown) {
          message = 'No se pudo conectar al backend en $base. ¿El servidor está en ejecución?';
        } else if (e.response != null) {
          message = 'Error del servidor (${e.response?.statusCode}): ${e.response?.statusMessage ?? ''}';
        } else {
          message = e.message ?? message;
        }
      }
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
}
