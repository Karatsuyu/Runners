import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../providers/contacts_provider.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contactsAsync = ref.watch(contactsProvider);
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;
    final isAdmin = currentUser?.isAdmin ?? false;
    final isGuest = authState.isGuest;
    final query = _searchController.text.trim().toLowerCase();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Contactos'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.primaryGreen,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                ref.read(contactSearchProvider.notifier).state = val;
                setState(() {});
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar contactos...',
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(contactSearchProvider.notifier).state = '';
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),

          Expanded(
            child: contactsAsync.when(
              loading: () => const AppLoading(),
              error: (e, _) => AppErrorWidget(
                message: 'Error al cargar contactos',
                onRetry: () => ref.invalidate(contactsProvider),
              ),
              data: (contacts) {
                final filtered = contacts.where((c) {
                  if (query.isEmpty) return true;
                  final byName = c.name.toLowerCase().contains(query);
                  final byPhone = c.phone.toLowerCase().contains(query);
                  return byName || byPhone;
                }).toList();

                if (filtered.isEmpty) {
                  return const AppEmptyState(
                    icon: Icons.contact_page_outlined,
                    title: 'Sin contactos',
                    subtitle: 'No hay contactos para mostrar',
                  );
                }
                  return RefreshIndicator(
                    color: AppColors.primaryGreen,
                    onRefresh: () async => ref.invalidate(contactsProvider),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: isGuest ? filtered.length : filtered.length + 1,
                      itemBuilder: (context, i) {
                        if (!isGuest && i == 0) {
                          return _AddContactCard(onTap: () {
                            final myContact = (currentUser == null)
                                ? null
                                : contacts.cast<ContactModel?>().firstWhere(
                                      (c) => c?.ownerId == currentUser.id,
                                      orElse: () => null,
                                    );
                            if (myContact != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Ya tienes un registro creado')),
                              );
                            } else {
                              _openCreateContactDialog();
                            }
                          });
                        }

                        final contactIndex = isGuest ? i : i - 1;
                        return _ContactTile(
                          contact: filtered[contactIndex],
                          isCurrentUserOwner: currentUser != null &&
                              filtered[contactIndex].ownerId == currentUser.id,
                        );
                      },
                    ),
                  );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isGuest
          ? null
          : isAdmin
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Agregar'),
              onPressed: _openCreateContactDialog,
            )
          : contactsAsync.maybeWhen(
              data: (contacts) {
                final myContact = (currentUser == null)
                    ? null
                    : contacts.cast<ContactModel?>().firstWhere(
                          (c) => c?.ownerId == currentUser.id,
                          orElse: () => null,
                        );
                return FloatingActionButton.extended(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  icon: Icon(
                    myContact?.isApproved == true
                        ? Icons.edit
                        : Icons.how_to_reg_rounded,
                  ),
                  label: Text(
                    myContact?.isApproved == true
                        ? 'Editar mi contacto'
                        : 'Solicitar contacto',
                  ),
                  onPressed: () {
                    if (myContact?.isApproved == true) {
                      _openEditOwnContactDialog(myContact!);
                    } else {
                      _openCreateContactDialog();
                    }
                  },
                );
              },
              orElse: () => null,
            ),
    );
  }

  Future<void> _openCreateContactDialog() async {
    final authUser = ref.read(authProvider).user;
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final descriptionCtrl = TextEditingController();
    final typeCtrl = TextEditingController(text: 'contacto');
    final formKey = GlobalKey<FormState>();
    final picker = ImagePicker();
    XFile? pickedImage;

    await showDialog<void>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('Nuevo contacto'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final image = await _pickFromCameraOrGallery(
                        context: dialogContext,
                        picker: picker,
                      );
                      if (image != null) {
                        setDialogState(() {
                          pickedImage = image;
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.12),
                      backgroundImage: pickedImage != null
                          ? FileImage(File(pickedImage!.path))
                          : null,
                      child: pickedImage == null
                          ? const Icon(
                              Icons.add_a_photo_outlined,
                              color: AppColors.primaryGreen,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Seleccionar foto (cámara o galería)',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Ingresa un nombre' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: phoneCtrl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Ingresa un teléfono'
                        : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email (opcional)'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descriptionCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Qué haces / descripción',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: typeCtrl.text,
                    decoration: const InputDecoration(labelText: 'Tipo de Registro'),
                    items: const [
                      DropdownMenuItem(value: 'contacto', child: Text('Contacto (Público)')),
                      DropdownMenuItem(value: 'servicio', child: Text('Servicio (Privado)')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() {
                          typeCtrl.text = val;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    typeCtrl.text == 'contacto' 
                        ? '* Tu número de teléfono.'
                        : '* Tu número de teléfono.',
                    style: TextStyle(
                      fontSize: 12, 
                      color: typeCtrl.text == 'contacto' ? AppColors.warning : AppColors.primaryGreen,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                try {
                  final effectiveEmail = emailCtrl.text.trim().isNotEmpty
                      ? emailCtrl.text.trim()
                      : authUser?.email;
                  await ref.read(contactsActionsProvider).addManualContact(
                        name: nameCtrl.text.trim(),
                        phone: phoneCtrl.text.trim(),
                        email: effectiveEmail,
                        description: descriptionCtrl.text.trim().isEmpty
                            ? null
                            : descriptionCtrl.text.trim(),
                        imagePath: pickedImage?.path,
                        type: typeCtrl.text,
                      );
                  ref.invalidate(contactsProvider);
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                } catch (e) {
                  if (!dialogContext.mounted) return;
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    SnackBar(
                      content: Text('No se pudo guardar el contacto: $e'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );

    nameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    descriptionCtrl.dispose();
  }

  Future<void> _openEditOwnContactDialog(ContactModel contact) async {
    final phoneCtrl = TextEditingController(text: contact.phone);
    final formKey = GlobalKey<FormState>();
    final picker = ImagePicker();
    XFile? pickedImage;

    await showDialog<void>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final ImageProvider<Object>? imageProvider = pickedImage != null
              ? FileImage(File(pickedImage!.path))
              : (contact.imageUrl != null && contact.imageUrl!.isNotEmpty
                  ? NetworkImage(contact.imageUrl!)
                  : null);
          return AlertDialog(
            title: const Text('Editar mi contacto'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final image = await _pickFromCameraOrGallery(
                        context: dialogContext,
                        picker: picker,
                      );
                      if (image != null) {
                        setDialogState(() {
                          pickedImage = image;
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.12),
                      backgroundImage: imageProvider,
                      child: pickedImage == null &&
                              (contact.imageUrl == null || contact.imageUrl!.isEmpty)
                          ? const Icon(Icons.add_a_photo_outlined, color: AppColors.primaryGreen)
                          : null,
                    ),
                  ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Ingresa un teléfono'
                      : null,
                ),
              ],
            ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  try {
                    await ref.read(contactsActionsProvider).updateOwnContact(
                          contactId: contact.id,
                          phone: phoneCtrl.text.trim(),
                          imagePath: pickedImage?.path,
                        );
                    ref.invalidate(contactsProvider);
                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                  } catch (e) {
                    if (!dialogContext.mounted) return;
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(
                        content: Text('No se pudo actualizar: $e'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      ),
    );

    phoneCtrl.dispose();
  }

  Future<XFile?> _pickFromCameraOrGallery({
    required BuildContext context,
    required ImagePicker picker,
  }) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Tomar foto'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Elegir de galería'),
              onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return null;
    return picker.pickImage(source: source, imageQuality: 75, maxWidth: 1200);
  }
}

class _ContactTile extends StatelessWidget {
  final ContactModel contact;
  final bool isCurrentUserOwner;
  const _ContactTile({
    required this.contact,
    required this.isCurrentUserOwner,
  });

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: contact.phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      elevation: 1.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: contact.imageUrl != null && contact.imageUrl!.isNotEmpty
                ? Image.network(
                    contact.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fallbackImage(),
                  )
                : _fallbackImage(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
            child: Text(
              contact.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          if (isCurrentUserOwner && !contact.isApproved)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: contact.approvalStatus == 'RECHAZADO'
                      ? AppColors.error.withValues(alpha: 0.12)
                      : AppColors.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  contact.approvalStatus == 'RECHAZADO'
                      ? 'Rechazado'
                      : 'Pendiente aprobación',
                  style: TextStyle(
                    color: contact.approvalStatus == 'RECHAZADO'
                        ? AppColors.error
                        : AppColors.warning,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              contact.phone,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: 34,
              child: ElevatedButton.icon(
                onPressed: _call,
                icon: const Icon(Icons.phone, size: 16),
                label: const Text('Llamar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackImage() {
    return Container(
      color: AppColors.primaryGreen.withValues(alpha: 0.08),
      child: const Icon(
        Icons.person_rounded,
        size: 56,
        color: AppColors.primaryGreen,
      ),
    );
  }
}

class _AddContactCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddContactCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        clipBehavior: Clip.antiAlias,
        elevation: 1.5,
        color: AppColors.primaryGreen.withValues(alpha: 0.08),
        child: const Center(
          child: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primaryGreen,
            child: Icon(Icons.add, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}
