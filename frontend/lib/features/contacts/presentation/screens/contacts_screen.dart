import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/media_url.dart';
import '../../../../core/theme/theme_mode_provider.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../store/presentation/providers/store_provider.dart';
import '../../../services/presentation/providers/services_provider.dart';
import 'package:file_picker/file_picker.dart';
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
  Widget build(BuildContext context) {
    final contactsAsync = ref.watch(contactsProvider);
    final providersAsync = ref.watch(providersProvider);
    final cart = ref.watch(cartProvider);
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;
    final isAdmin = currentUser?.isAdmin ?? false;
    final isGuest = authState.isGuest;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Perfil',
            onPressed: _openProfileMenu,
          ),
          title: const Text('Contactos / Servicios'),
          // removed TabBar from AppBar so it can be shown under the search field
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: _goToCart,
                ),
                if (cart.isNotEmpty)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${cart.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        // Move the TabBar under the search field so it's visually below the search button
        body: SafeArea(
          bottom: false,
          child: Column(
          children: [
            // shared search field across both tabs
            Container(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).scaffoldBackgroundColor
                  : AppColors.primaryGreen,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  ref.read(contactSearchProvider.notifier).state = val;
                  setState(() {});
                },
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar contactos...',
                  hintStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white54
                          : Colors.white60),
                  prefixIcon: Icon(Icons.search,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.white70),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white70
                                  : Colors.white70),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(contactSearchProvider.notifier).state = '';
                            setState(() {});
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor ??
                      (Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white.withAlpha(38)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
            Material(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).scaffoldBackgroundColor
                  : AppColors.primaryGreen,
              child: TabBar(
                labelColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.white,
                unselectedLabelColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white70
                    : Colors.white70,
                indicatorColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.white,
                tabs: const [Tab(text: 'Contactos'), Tab(text: 'Servicios')],
              ),
            ),
            // the tab views
            Expanded(
              child: TabBarView(
                children: [
                  // Contactos content (without the search field)
                  contactsAsync.when(
                    loading: () => const AppLoading(),
                    error: (e, _) => AppErrorWidget(
                      message: 'Error al cargar contactos',
                      onRetry: () => ref.invalidate(contactsProvider),
                    ),
                    data: (contacts) {
                      final query = _searchController.text.trim().toLowerCase();
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
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Añadir espacio extra para evitar overflow con la barra inferior
                            final bottomPadding = MediaQuery.of(context).padding.bottom + 12 + kBottomNavigationBarHeight;
                            return GridView.builder(
                              padding: EdgeInsets.fromLTRB(12, 12, 12, bottomPadding),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (context, i) {
                                return _ContactTile(
                                  contact: filtered[i],
                                  isCurrentUserOwner: false,
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  // Services tab
                  const _ServicesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
        floatingActionButton: Builder(
          builder: (fabContext) {
            final tc = DefaultTabController.of(fabContext);
            if (tc == null) return const SizedBox.shrink();
            return AnimatedBuilder(
              animation: tc,
              builder: (_, __) {
                // If admin and on Contactos tab (index 0) show admin add button
                if (isAdmin && tc.index == 0) {
                  return FloatingActionButton.extended(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text('Agregar'),
                    onPressed: _openCreateContactDialog,
                  );
                }
                // If not admin and on Services tab (index 1) show postularse button
                if (!isAdmin && tc.index == 1) {
                  final selCat = ref.read(selectedServiceCategoryProvider);
                  return FloatingActionButton.extended(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    icon: const Icon(Icons.how_to_reg_rounded),
                    label: const Text('Postularme'),
                    onPressed: () => _openApplyDialog(initialCategory: selCat),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _openProfileMenu() async {
    final authState = ref.read(authProvider);
    final user = authState.user;
    final isGuest = authState.isGuest;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                    backgroundImage: resolveMediaUrl(user?.profileImageUrl) != null
                        ? NetworkImage(resolveMediaUrl(user?.profileImageUrl)!)
                        : null,
                    child: resolveMediaUrl(user?.profileImageUrl) == null
                        ? const Icon(Icons.person_outline)
                        : null,
                  ),
                  title: Text(
                    user?.fullName.isNotEmpty == true
                        ? user!.fullName
                        : (isGuest ? 'Modo invitado' : 'Mi perfil'),
                  ),
                  subtitle: Text(user?.email ?? 'Sin correo'),
                ),
                if (!isGuest)
                  ListTile(
                    leading: const Icon(Icons.edit_outlined),
                    title: const Text('Editar perfil'),
                    onTap: () async {
                      Navigator.of(sheetContext).pop();
                      if (mounted) {
                        context.push(AppRoutes.clientProfile);
                      }
                    },
                  ),
                if (!isGuest)
                  Consumer(
                    builder: (c, r, _) {
                      final mode = r.watch(themeModeProvider);
                      final isDark = mode == ThemeMode.dark;
                      return ListTile(
                        leading: const Icon(Icons.brightness_6_outlined),
                        title: const Text('Cambiar tema'),
                        trailing: Switch.adaptive(
                          value: isDark,
                          onChanged: (v) async {
                            await r.read(themeModeProvider.notifier).toggle();
                          },
                        ),
                        onTap: () async {
                          await r.read(themeModeProvider.notifier).toggle();
                        },
                      );
                    },
                  ),
                ListTile(
                  leading: Icon(
                    isGuest ? Icons.login_rounded : Icons.logout,
                    color: Colors.red,
                  ),
                  title: Text(
                    isGuest ? 'Iniciar sesión' : 'Cerrar sesión',
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    if (isGuest) {
                      context.push(AppRoutes.login);
                    } else {
                      ref.read(authProvider.notifier).logout();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _goToCart() {
    final authState = ref.read(authProvider);
    if (authState.isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes iniciar sesión para realizar compras.'),
        ),
      );
      context.go(AppRoutes.login);
      return;
    }
    context.go('/client/cart');
  }

  void _openApplyDialog({int? initialCategory}) {
    final nameCtrl = TextEditingController();
    final professionCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    int? selectedCategory = initialCategory;
    String? cvPath;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('Postularse como prestador'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  items: ref.read(serviceCategoriesProvider).maybeWhen(
                        data: (cats) => cats.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                        orElse: () => [],
                      ),
                  onChanged: (v) => selectedCategory = v,
                ),
                const SizedBox(height: 8),
                TextField(controller: professionCtrl, decoration: const InputDecoration(labelText: 'Servicio / Profesión')),
                const SizedBox(height: 8),
                TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descripción'), maxLines: 3),
                const SizedBox(height: 8),
                Row(children: [
                  FilledButton.icon(
                    onPressed: () async {
                      final res = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);
                      if (res != null && res.files.single.path != null) {
                        cvPath = res.files.single.path;
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Adjuntar CV'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(cvPath != null ? cvPath!.split('/').last : 'No hay CV seleccionado', overflow: TextOverflow.ellipsis)),
                ]),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () async {
                if (selectedCategory == null || professionCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completa categoría y profesión')));
                  return;
                }
                try {
                  await ref.read(servicesDataSourceProvider).registerAsProvider(
                        categoryId: selectedCategory!,
                        profession: professionCtrl.text.trim(),
                        description: descCtrl.text.trim(),
                        cvPath: cvPath,
                      );
                  ref.invalidate(myProviderProfileProvider);
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Postulación enviada')));
                } catch (e) {
                  if (!dialogContext.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
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
    int? selectedCategory;

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
                      backgroundColor: AppColors.primaryGreen.withValues(
                        alpha: 0.12,
                      ),
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
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (typeCtrl.text == 'servicio')
                    Consumer(builder: (context, dialogRef, _) {
                      final catsAsync = dialogRef.watch(serviceCategoriesProvider);
                      return catsAsync.when(
                        data: (cats) {
                          return DropdownButtonFormField<int>(
                                value: selectedCategory,
                                decoration: const InputDecoration(labelText: 'Categoría'),
                                items: (() {
                                  final seen = <int>{};
                                  return cats.where((c) => seen.add(c.id)).map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList();
                                })(),
                                onChanged: (val) {
                                  setDialogState(() {
                                    selectedCategory = val;
                                  });
                                },
                              );
                        },
                        loading: () => const SizedBox(height: 48, child: Center(child: CircularProgressIndicator())),
                        error: (_, __) => const SizedBox.shrink(),
                      );
                    }),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Ingresa un nombre'
                        : null,
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
                    decoration: const InputDecoration(
                      labelText: 'Email (opcional)',
                    ),
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
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Registro',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'contacto',
                        child: Text('Contacto (Público)'),
                      ),
                      DropdownMenuItem(
                        value: 'servicio',
                        child: Text('Servicio (Privado)'),
                      ),
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
                      color: typeCtrl.text == 'contacto'
                          ? AppColors.warning
                          : AppColors.primaryGreen,
                      fontStyle: FontStyle.italic,
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
                  await ref
                      .read(contactsActionsProvider)
                      .addManualContact(
                        name: nameCtrl.text.trim(),
                        phone: phoneCtrl.text.trim(),
                        email: effectiveEmail,
                        description: descriptionCtrl.text.trim().isEmpty
                            ? null
                            : descriptionCtrl.text.trim(),
                        imagePath: pickedImage?.path,
                        type: typeCtrl.text,
                        categoryId: typeCtrl.text == 'servicio' ? selectedCategory : null,
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
                      backgroundColor: AppColors.primaryGreen.withValues(
                        alpha: 0.12,
                      ),
                      backgroundImage: imageProvider,
                      child:
                          pickedImage == null &&
                              (contact.imageUrl == null ||
                                  contact.imageUrl!.isEmpty)
                          ? const Icon(
                              Icons.add_a_photo_outlined,
                              color: AppColors.primaryGreen,
                            )
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
                    await ref
                        .read(contactsActionsProvider)
                        .updateOwnContact(
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
  const _ContactTile({required this.contact, required this.isCurrentUserOwner});

  Future<void> _call() async {
    final uri = Uri(scheme: 'tel', path: contact.phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      elevation: 1.5,
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: contact.imageUrl != null && contact.imageUrl!.isNotEmpty
                ? Image.network(
                    contact.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fallbackImage(context),
                  )
                : _fallbackImage(context),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
            child: Text(
              contact.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: isDark ? Colors.white : Colors.black,
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
                      ? AppColors.error.withAlpha(32)
                      : AppColors.warning.withAlpha(32),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Text(
              contact.phone,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDark ? Colors.white70 : AppColors.textSecondary,
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackImage(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? Colors.black : AppColors.primaryGreen.withAlpha(20),
      child: Icon(
        Icons.person_rounded,
        size: 56,
        color: isDark ? Colors.white24 : AppColors.primaryGreen,
      ),
    );
  }
}


class _ServicesTab extends ConsumerWidget {
  const _ServicesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(serviceCategoriesProvider);
    final providersAsync = ref.watch(providersProvider);
    final authState = ref.watch(authProvider);
    final isGuest = authState.isGuest;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          categoriesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (cats) => SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: cats.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) => ChoiceChip(
                  label: Text(cats[i].name),
                  selected: false,
                  onSelected: (v) {
                    ref.read(selectedServiceCategoryProvider.notifier).state = v ? cats[i].id : null;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: providersAsync.when(
              loading: () => const AppLoading(),
              error: (e, _) => const AppEmptyState(
                icon: Icons.miscellaneous_services_outlined,
                title: 'Sin prestadores',
                subtitle: 'Por el momento no hay prestadores',
              ),
              data: (providers) {
                if (providers.isEmpty) return const AppEmptyState(icon: Icons.miscellaneous_services_outlined, title: 'Sin prestadores', subtitle: 'No hay prestadores disponibles');
                return RefreshIndicator(
                  color: AppColors.primaryGreen,
                  onRefresh: () async => ref.invalidate(providersProvider),
                  child: ListView.separated(
                    itemCount: providers.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final p = providers[i];
                      return ListTile(
                        leading: p.photoUrl != null ? CircleAvatar(backgroundImage: NetworkImage(p.photoUrl!)) : const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(p.fullName),
                        subtitle: Text(p.profession),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            // open provider detail or request service
                            showModalBottomSheet(
                              context: context,
                              builder: (_) => Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(p.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Text(p.description),
                                    const SizedBox(height: 12),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _openApplyDialog(context, ref);
                                      },
                                      icon: const Icon(Icons.how_to_reg_rounded),
                                      label: const Text('Postularme como prestador'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: const Text('Ver'),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openApplyDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final professionCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    int? selectedCategory;
    String? cvPath;
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          title: const Text('Postularse como prestador'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Categoría'),
                  items: ref.read(serviceCategoriesProvider).when(
                    data: (cats) {
                      final seen = <int>{};
                      return cats.where((c) => seen.add(c.id)).map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList();
                    },
                    loading: () => [],
                    error: (_, __) => [],
                  ),
                  onChanged: (v) => selectedCategory = v,
                ),
                const SizedBox(height: 8),
                TextField(controller: professionCtrl, decoration: const InputDecoration(labelText: 'Servicio / Profesión')),
                const SizedBox(height: 8),
                TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descripción'), maxLines: 3),
                const SizedBox(height: 8),
                Row(children: [
                  FilledButton.icon(
                    onPressed: () async {
                      final res = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc', 'docx']);
                      if (res != null && res.files.single.path != null) {
                        cvPath = res.files.single.path;
                        setState(() {});
                      }
                    },
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Adjuntar CV'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(cvPath != null ? cvPath!.split('/').last : 'No hay CV seleccionado', overflow: TextOverflow.ellipsis)),
                ]),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () async {
                if (selectedCategory == null || professionCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completa categoría y profesión')));
                  return;
                }
                try {
                  await ref.read(servicesDataSourceProvider).registerAsProvider(
                    categoryId: selectedCategory!,
                    profession: professionCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    cvPath: cvPath,
                  );
                  ref.invalidate(myProviderProfileProvider);
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Postulación enviada')));
                } catch (e) {
                  if (!dialogContext.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        ),
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
