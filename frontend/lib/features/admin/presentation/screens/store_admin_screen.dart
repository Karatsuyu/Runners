import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/store_admin_provider.dart';

// Resuelve rutas relativas de imágenes devueltas por el backend a URLs completas
String? resolveImageUrl(String? img) {
  if (img == null || img.isEmpty) return null;
  if (img.startsWith('http')) return img;
  final root = ApiConstants.baseUrl.replaceFirst('/api/v1', '');
  if (img.startsWith('/')) return '$root$img';
  return '$root/$img';
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

  void _openEditDialog(BuildContext context, WidgetRef ref, AdminCommerceModel commerce) {
    showDialog(
      context: context,
      builder: (context) => StoreAdminEditDialog(
        initialData: commerce,
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
                  Icon(Icons.picture_as_pdf_outlined, size: 14, color: AppColors.warning),
                  const SizedBox(width: 4),
                  const Text('PDF', style: TextStyle(fontSize: 12, color: AppColors.warning)),
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

class _StoreAdminEditDialogState extends ConsumerState<StoreAdminEditDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  int? selectedCategoryId;
  bool isActive = true;
  String? selectedMenuPdfPath;
  bool isLoading = false;
  String? selectedImagePath;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialData?.name ?? '');
    descriptionController = TextEditingController(text: widget.initialData?.description ?? '');
    phoneController = TextEditingController(text: widget.initialData?.phone ?? '');
    addressController = TextEditingController(text: widget.initialData?.address ?? '');
    selectedCategoryId = widget.initialData?.categoryId;
    isActive = widget.initialData?.isActive ?? true;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        selectedMenuPdfPath = result.files.single.path;
      });
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
                items: categories
                    .map(
                      (category) => DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
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
                          TextButton.icon(
                            onPressed: _pickPdf,
                            icon: const Icon(Icons.upload_file, size: 18),
                            label: const Text('PDF'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
        if (selectedMenuPdfPath != null)
          'menu_pdf': await MultipartFile.fromFile(selectedMenuPdfPath!),
        if (selectedImagePath != null)
          'image': await MultipartFile.fromFile(selectedImagePath!),
      });

      await widget.onSave(formData);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
}
