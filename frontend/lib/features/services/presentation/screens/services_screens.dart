import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/services_provider.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../store/presentation/providers/store_provider.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';

// ── Services Screen (Client) ─────────────────────────────────────────────

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  Future<bool> _openEditProfileDialog(
    BuildContext context,
    WidgetRef ref,
    UserEntity? user,
  ) async {
    final firstNameController = TextEditingController(
      text: user?.firstName ?? '',
    );
    final lastNameController = TextEditingController(
      text: user?.lastName ?? '',
    );
    final phoneController = TextEditingController(text: user?.phone ?? '');

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Editar perfil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lastNameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Apellidos'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () async {
                final firstName = firstNameController.text.trim();
                final lastName = lastNameController.text.trim();
                if (firstName.isEmpty || lastName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nombre y apellidos son obligatorios'),
                    ),
                  );
                  return;
                }

                final ok = await ref
                    .read(authProvider.notifier)
                    .updateProfile(
                      firstName: firstName,
                      lastName: lastName,
                      phone: phoneController.text.trim(),
                    );
                if (!dialogContext.mounted) return;

                if (ok) {
                  Navigator.of(dialogContext).pop(true);
                } else {
                  final error =
                      ref.read(authProvider).error ??
                      'No fue posible actualizar el perfil';
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(error)));
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    return result ?? false;
  }

  Future<void> _openProfileMenu(BuildContext context, WidgetRef ref) async {
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
                  leading: const CircleAvatar(
                    child: Icon(Icons.person_outline),
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
                      if (context.mounted) {
                        context.push(AppRoutes.clientProfile);
                      }
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
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    if (!isGuest) {
                      await ref.read(authProvider.notifier).logout();
                    }
                    if (context.mounted) {
                      context.go(AppRoutes.login);
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

  void _goToCart(BuildContext context, WidgetRef ref) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(serviceCategoriesProvider);
    final providersAsync = ref.watch(providersProvider);
    final selectedCategory = ref.watch(selectedServiceCategoryProvider);
    final cart = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person_outline),
          tooltip: 'Perfil',
          onPressed: () => _openProfileMenu(context, ref),
        ),
        title: const Text('Servicios'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => _goToCart(context, ref),
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
      body: Column(
        children: [
          // Category chips
          categoriesAsync.when(
            loading: () => const SizedBox(
              height: 56,
              child: Center(child: AppLoading(size: 24)),
            ),
            error: (_, __) => const SizedBox(),
            data: (cats) => SizedBox(
              height: 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: const Text('Todos'),
                      selected: selectedCategory == null,
                      selectedColor: AppColors.primaryGreen.withAlpha(30),
                      onSelected: (_) =>
                          ref
                                  .read(
                                    selectedServiceCategoryProvider.notifier,
                                  )
                                  .state =
                              null,
                    ),
                  ),
                  ...cats.map(
                    (cat) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat.name),
                        selected: selectedCategory == cat.id,
                        selectedColor: AppColors.primaryGreen.withAlpha(30),
                        onSelected: (_) =>
                            ref
                                .read(selectedServiceCategoryProvider.notifier)
                                .state = cat
                                .id,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Providers list
          Expanded(
            child: providersAsync.when(
              loading: () => const AppLoading(),
              error: (e, _) => AppErrorWidget(
                message: 'Error al cargar prestadores',
                onRetry: () => ref.invalidate(providersProvider),
              ),
              data: (providers) => providers.isEmpty
                  ? const AppEmptyState(
                      icon: Icons.engineering_outlined,
                      title: 'Sin prestadores',
                      subtitle:
                          'No hay prestadores disponibles en esta categoría.',
                    )
                  : RefreshIndicator(
                      onRefresh: () async => ref.invalidate(providersProvider),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: providers.length,
                        itemBuilder: (_, i) {
                          final p = providers[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primaryGreen
                                    .withAlpha(20),
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                              title: Text(
                                p.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.profession,
                                    style: const TextStyle(
                                      color: AppColors.primaryGreen,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (p.description.isNotEmpty)
                                    Text(
                                      p.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                ],
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                              ),
                              onTap: () =>
                                  context.go('/client/services/${p.id}'),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Provider Detail Screen ────────────────────────────────────────────────

class ProviderDetailScreen extends ConsumerWidget {
  final int providerId;
  const ProviderDetailScreen({super.key, required this.providerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerAsync = ref.watch(providerDetailProvider(providerId));

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil del Prestador')),
      body: providerAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => AppErrorWidget(
          message: 'Error al cargar el perfil',
          onRetry: () => ref.invalidate(providerDetailProvider(providerId)),
        ),
        data: (provider) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primaryGreen.withAlpha(20),
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                provider.fullName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  provider.profession,
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (provider.description.isNotEmpty) ...[
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Descripción',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  provider.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
              ],
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                'Solicitar Servicio',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Al solicitar este servicio, nuestro equipo administrativo se pondrá en contacto con el prestador y te avisará.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'Solicitar Servicio',
                icon: Icons.send_rounded,
                onPressed: () =>
                    context.go('/client/services/${providerId}/request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Service Request Screen ────────────────────────────────────────────────

class ServiceRequestScreen extends ConsumerStatefulWidget {
  final int providerId;
  const ServiceRequestScreen({super.key, required this.providerId});

  @override
  ConsumerState<ServiceRequestScreen> createState() =>
      _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends ConsumerState<ServiceRequestScreen> {
  final _descController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_descController.text.trim().isEmpty) {
      setState(() => _error = 'Por favor describe el servicio que necesitas.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(servicesDataSourceProvider)
          .createServiceRequest(
            providerId: widget.providerId,
            description: _descController.text.trim(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '¡Solicitud enviada! El administrador se pondrá en contacto contigo.',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        context.go('/client/services');
      }
    } catch (e) {
      setState(() => _error = 'Error al enviar la solicitud: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Servicio')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.primaryGreen,
              size: 32,
            ),
            const SizedBox(height: 12),
            const Text(
              'Describe lo que necesitas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'El administrador de Runners revisará tu solicitud, coordinará con el prestador y te contactará para confirmar la disponibilidad y el precio.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            AppTextField(
              controller: _descController,
              label: 'Descripción del servicio',
              hintText:
                  'Ej: Necesito instalar un cerrojo en la puerta principal...',
              maxLines: 5,
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: AppColors.error)),
            ],
            const SizedBox(height: 24),
            AppButton(
              label: 'Enviar Solicitud',
              isLoading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Provider Dashboard Screen ────────────────────────────────────────────

class ProviderDashboardScreen extends ConsumerWidget {
  const ProviderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(myProviderProfileProvider);
    final requestsAsync = ref.watch(myServiceRequestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Panel')),
      body: profileAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => AppErrorWidget(
          message: 'No se pudo cargar tu perfil de prestador',
          onRetry: () => ref.invalidate(myProviderProfileProvider),
        ),
        data: (profile) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(myProviderProfileProvider);
            ref.invalidate(myServiceRequestsProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColors.primaryGreen,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.fullName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                profile.profession,
                                style: const TextStyle(
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: profile.isApproved
                                      ? AppColors.success.withAlpha(30)
                                      : AppColors.warning.withAlpha(30),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  profile.isApproved
                                      ? 'Aprobado'
                                      : 'Pendiente de aprobación',
                                  style: TextStyle(
                                    color: profile.isApproved
                                        ? AppColors.success
                                        : AppColors.warning,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Solicitudes de Servicio',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                requestsAsync.when(
                  loading: () => const AppLoading(),
                  error: (e, _) => AppErrorWidget(
                    message: 'Error al cargar solicitudes',
                    onRetry: () => ref.invalidate(myServiceRequestsProvider),
                  ),
                  data: (requests) => requests.isEmpty
                      ? const AppEmptyState(
                          icon: Icons.inbox_outlined,
                          title: 'Sin solicitudes',
                          subtitle: 'Aún no tienes solicitudes de servicio.',
                        )
                      : Column(
                          children: requests
                              .map(
                                (r) => Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.assignment_outlined,
                                    ),
                                    title: Text(r.clientName),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          r.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          r.statusLabel,
                                          style: const TextStyle(
                                            color: AppColors.primaryGreen,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Register as Provider Screen ──────────────────────────────────────────

class RegisterProviderScreen extends ConsumerStatefulWidget {
  const RegisterProviderScreen({super.key});

  @override
  ConsumerState<RegisterProviderScreen> createState() =>
      _RegisterProviderScreenState();
}

class _RegisterProviderScreenState
    extends ConsumerState<RegisterProviderScreen> {
  final _professionCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  int? _selectedCategoryId;
  String? _cvPath;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _professionCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedCategoryId == null) {
      setState(() => _error = 'Selecciona una categoría');
      return;
    }
    if (_professionCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Ingresa tu profesión');
      return;
    }
    if (_descCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Describe tus servicios');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(servicesDataSourceProvider)
          .registerAsProvider(
            categoryId: _selectedCategoryId!,
            profession: _professionCtrl.text.trim(),
            description: _descCtrl.text.trim(),
            cvPath: _cvPath,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Solicitud enviada. El administrador revisará tu perfil y te notificará.',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        context.go('/client/store');
      }
    } catch (e) {
      setState(() => _error = 'Error al registrarse: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(serviceCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ser Prestador de Servicios')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Únete como Prestador',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Completa tu perfil. El administrador revisará tu información y aprobará tu registro.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            categoriesAsync.when(
              loading: () => const AppLoading(),
              error: (_, __) => const Text('Error al cargar categorías'),
              data: (cats) => DropdownButtonFormField<int>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Categoría de servicio',
                  border: OutlineInputBorder(),
                ),
                items: cats
                    .map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategoryId = v),
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _professionCtrl,
              label: 'Profesión / Oficio',
              hintText: 'Ej: Plomero, Electricista, Contador...',
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _descCtrl,
              label: 'Descripción de tus servicios',
              hintText: 'Describe qué servicios ofreces, tu experiencia...',
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                // File picking handled via file_picker
                // Implementation depends on platform
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Selección de CV próximamente')),
                );
              },
              icon: const Icon(Icons.attach_file),
              label: Text(
                _cvPath != null ? 'CV adjunto ✓' : 'Adjuntar CV (opcional)',
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: AppColors.error)),
            ],
            const SizedBox(height: 24),
            AppButton(
              label: 'Enviar solicitud',
              isLoading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
