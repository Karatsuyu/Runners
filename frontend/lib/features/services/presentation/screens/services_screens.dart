import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/services_provider.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../core/constants/app_colors.dart';

// ── Services Screen (Client) ─────────────────────────────────────────────

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(serviceCategoriesProvider);
    final providersAsync = ref.watch(providersProvider);
    final selectedCategory = ref.watch(selectedServiceCategoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      body: Column(
        children: [
          // Category chips
          categoriesAsync.when(
            loading: () => const SizedBox(
                height: 56,
                child: Center(child: AppLoading(size: 24))),
            error: (_, __) => const SizedBox(),
            data: (cats) => SizedBox(
              height: 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: const Text('Todos'),
                      selected: selectedCategory == null,
                      selectedColor:
                          AppColors.primaryGreen.withAlpha(30),
                      onSelected: (_) => ref
                          .read(selectedServiceCategoryProvider.notifier)
                          .state = null,
                    ),
                  ),
                  ...cats.map((cat) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat.name),
                          selected: selectedCategory == cat.id,
                          selectedColor:
                              AppColors.primaryGreen.withAlpha(30),
                          onSelected: (_) => ref
                              .read(selectedServiceCategoryProvider.notifier)
                              .state = cat.id,
                        ),
                      )),
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
                      onRefresh: () async =>
                          ref.invalidate(providersProvider),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: providers.length,
                        itemBuilder: (_, i) {
                          final p = providers[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    AppColors.primaryGreen.withAlpha(20),
                                child: const Icon(Icons.person,
                                    color: AppColors.primaryGreen),
                              ),
                              title: Text(p.fullName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              subtitle: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(p.profession,
                                      style: const TextStyle(
                                          color: AppColors.primaryGreen,
                                          fontWeight: FontWeight.w500)),
                                  if (p.description.isNotEmpty)
                                    Text(p.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 12)),
                                ],
                              ),
                              trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16),
                              onTap: () => context
                                  .go('/client/services/${p.id}'),
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
          onRetry: () =>
              ref.invalidate(providerDetailProvider(providerId)),
        ),
        data: (provider) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor:
                    AppColors.primaryGreen.withAlpha(20),
                child: const Icon(Icons.person,
                    size: 50, color: AppColors.primaryGreen),
              ),
              const SizedBox(height: 16),
              Text(provider.fullName,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withAlpha(20),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(provider.profession,
                    style: const TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 20),
              if (provider.description.isNotEmpty) ...[
                const Divider(),
                const SizedBox(height: 8),
                const Text('Descripción',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(provider.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: AppColors.textSecondary)),
                const SizedBox(height: 20),
              ],
              const Divider(),
              const SizedBox(height: 16),
              const Text('Solicitar Servicio',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'Al solicitar este servicio, nuestro equipo administrativo se pondrá en contacto con el prestador y te avisará.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'Solicitar Servicio',
                icon: Icons.send_rounded,
                onPressed: () => context
                    .go('/client/services/${providerId}/request'),
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

class _ServiceRequestScreenState
    extends ConsumerState<ServiceRequestScreen> {
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
      await ref.read(servicesDataSourceProvider).createServiceRequest(
            providerId: widget.providerId,
            description: _descController.text.trim(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                '¡Solicitud enviada! El administrador se pondrá en contacto contigo.'),
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
            const Icon(Icons.info_outline,
                color: AppColors.primaryGreen, size: 32),
            const SizedBox(height: 12),
            const Text(
              'Describe lo que necesitas',
              style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              hintText: 'Ej: Necesito instalar un cerrojo en la puerta principal...',
              maxLines: 5,
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!,
                  style: const TextStyle(color: AppColors.error)),
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
          onRetry: () =>
              ref.invalidate(myProviderProfileProvider),
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
                          child: Icon(Icons.person,
                              color: Colors.white, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(profile.fullName,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text(profile.profession,
                                  style: const TextStyle(
                                      color: AppColors.primaryGreen)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: profile.isApproved
                                      ? AppColors.success.withAlpha(30)
                                      : AppColors.warning.withAlpha(30),
                                  borderRadius:
                                      BorderRadius.circular(8),
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
                                      fontWeight: FontWeight.bold),
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
                const Text('Solicitudes de Servicio',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                requestsAsync.when(
                  loading: () => const AppLoading(),
                  error: (e, _) => AppErrorWidget(
                    message: 'Error al cargar solicitudes',
                    onRetry: () =>
                        ref.invalidate(myServiceRequestsProvider),
                  ),
                  data: (requests) => requests.isEmpty
                      ? const AppEmptyState(
                          icon: Icons.inbox_outlined,
                          title: 'Sin solicitudes',
                          subtitle:
                              'Aún no tienes solicitudes de servicio.',
                        )
                      : Column(
                          children: requests
                              .map(
                                (r) => Card(
                                  margin: const EdgeInsets.only(
                                      bottom: 8),
                                  child: ListTile(
                                    leading: const Icon(
                                        Icons.assignment_outlined),
                                    title: Text(r.clientName),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(r.description,
                                            maxLines: 2,
                                            overflow:
                                                TextOverflow.ellipsis),
                                        Text(r.statusLabel,
                                            style: const TextStyle(
                                                color:
                                                    AppColors.primaryGreen,
                                                fontWeight:
                                                    FontWeight.w600)),
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
      await ref.read(servicesDataSourceProvider).registerAsProvider(
            categoryId: _selectedCategoryId!,
            profession: _professionCtrl.text.trim(),
            description: _descCtrl.text.trim(),
            cvPath: _cvPath,
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Solicitud enviada. El administrador revisará tu perfil y te notificará.'),
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
              style:
                  TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                    border: OutlineInputBorder()),
                items: cats
                    .map((c) => DropdownMenuItem(
                        value: c.id, child: Text(c.name)))
                    .toList(),
                onChanged: (v) =>
                    setState(() => _selectedCategoryId = v),
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
              hintText:
                  'Describe qué servicios ofreces, tu experiencia...',
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                // File picking handled via file_picker
                // Implementation depends on platform
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Selección de CV próximamente')),
                );
              },
              icon: const Icon(Icons.attach_file),
              label: Text(_cvPath != null
                  ? 'CV adjunto ✓'
                  : 'Adjuntar CV (opcional)'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!,
                  style: const TextStyle(color: AppColors.error)),
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
