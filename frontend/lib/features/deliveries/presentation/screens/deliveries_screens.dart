import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/formatters.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../store/presentation/providers/store_provider.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/deliveries_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CLIENTE: DeliveriesScreen
// ─────────────────────────────────────────────────────────────────────────────

class DeliveriesScreen extends ConsumerStatefulWidget {
  const DeliveriesScreen({super.key});

  @override
  ConsumerState<DeliveriesScreen> createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends ConsumerState<DeliveriesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickupCtrl = TextEditingController();
  final _deliveryCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _loading = false;

  Future<bool> _openEditProfileDialog(UserEntity? user) async {
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
                      if (mounted) {
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
                    if (mounted) {
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

  @override
  void dispose() {
    _pickupCtrl.dispose();
    _deliveryCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final ds = ref.read(deliveriesDataSourceProvider);
      await ds.createDeliveryRequest(
        pickupAddress: _pickupCtrl.text.trim(),
        deliveryAddress: _deliveryCtrl.text.trim(),
        description: _descCtrl.text.trim(),
      );
      _pickupCtrl.clear();
      _deliveryCtrl.clear();
      _descCtrl.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '¡Domicilio solicitado! Asignando repartidor automáticamente...',
            ),
            backgroundColor: AppColors.success,
          ),
        );
        ref.invalidate(myDeliveryRequestsProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(myDeliveryRequestsProvider);
    final cart = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.person_outline),
          tooltip: 'Perfil',
          onPressed: _openProfileMenu,
        ),
        title: const Text('Domicilios'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Request Form ──────────────────────────────────────────
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.delivery_dining,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Solicitar Domicilio',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryGreen,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Un repartidor disponible será asignado automáticamente',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _pickupCtrl,
                        label: 'Dirección de recogida',
                        prefixIcon: Icons.location_on_outlined,
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Ingresa la dirección de recogida'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _deliveryCtrl,
                        label: 'Dirección de entrega',
                        prefixIcon: Icons.location_on,
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Ingresa la dirección de entrega'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _descCtrl,
                        label: 'Descripción del pedido',
                        prefixIcon: Icons.description_outlined,
                        maxLines: 3,
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Describe qué necesitas enviar'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        label: 'Solicitar Domicilio',
                        onPressed: _submit,
                        isLoading: _loading,
                        icon: Icons.send,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── My Requests History ───────────────────────────────────
            Text(
              'Mis Solicitudes',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            requestsAsync.when(
              loading: () => const AppLoading(),
              error: (e, _) => AppErrorWidget(
                message: 'Error al cargar solicitudes',
                onRetry: () => ref.invalidate(myDeliveryRequestsProvider),
              ),
              data: (requests) {
                if (requests.isEmpty) {
                  return const AppEmptyState(
                    icon: Icons.delivery_dining_outlined,
                    title: 'Sin solicitudes',
                    subtitle: 'Tus domicilios aparecerán aquí',
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: requests.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, i) =>
                      _DeliveryRequestCard(request: requests[i]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DeliveryRequestCard extends StatelessWidget {
  final DeliveryRequestModel request;
  const _DeliveryRequestCard({required this.request});

  Color get _statusColor {
    switch (request.status) {
      case 'pending':
        return AppColors.statusPending;
      case 'assigned':
        return AppColors.statusConfirmed;
      case 'in_progress':
        return AppColors.statusInProgress;
      case 'completed':
        return AppColors.statusDelivered;
      case 'cancelled':
        return AppColors.statusCancelled;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    request.description,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    request.statusLabel,
                    style: TextStyle(
                      color: _statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            _AddressRow(
              icon: Icons.trip_origin_outlined,
              text: request.pickupAddress,
            ),
            const SizedBox(height: 2),
            _AddressRow(icon: Icons.location_on, text: request.deliveryAddress),
            if (request.delivererName != null) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Repartidor: ${request.delivererName}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 4),
            Text(
              AppFormatters.dateTime(request.createdAt),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _AddressRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.primaryGreen),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DOMICILIARIO: DelivererDashboardScreen
// ─────────────────────────────────────────────────────────────────────────────

class DelivererDashboardScreen extends ConsumerWidget {
  const DelivererDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(myDelivererProfileProvider);
    final deliveriesAsync = ref.watch(myDeliveriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi Panel'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(myDelivererProfileProvider);
              ref.invalidate(myDeliveriesProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primaryGreen,
        onRefresh: () async {
          ref.invalidate(myDelivererProfileProvider);
          ref.invalidate(myDeliveriesProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Profile / Status Card ─────────────────────────────
              profileAsync.when(
                loading: () => const AppLoading(),
                error: (e, _) => AppErrorWidget(
                  message: 'Error cargando perfil',
                  onRetry: () => ref.invalidate(myDelivererProfileProvider),
                ),
                data: (profile) => _DelivererProfileCard(profile: profile),
              ),

              const SizedBox(height: 24),

              Text(
                'Domicilios Asignados',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // ── Assigned Deliveries ───────────────────────────────
              deliveriesAsync.when(
                loading: () => const AppLoading(),
                error: (e, _) => AppErrorWidget(
                  message: 'Error cargando domicilios',
                  onRetry: () => ref.invalidate(myDeliveriesProvider),
                ),
                data: (deliveries) {
                  final active = deliveries
                      .where(
                        (d) =>
                            d.status != 'completed' && d.status != 'cancelled',
                      )
                      .toList();
                  if (active.isEmpty) {
                    return const AppEmptyState(
                      icon: Icons.check_circle_outline,
                      title: 'Sin domicilios activos',
                      subtitle: 'Los domicilios asignados aparecerán aquí',
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: active.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) =>
                        _ActiveDeliveryCard(delivery: active[i]),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DelivererProfileCard extends ConsumerStatefulWidget {
  final DelivererModel profile;
  const _DelivererProfileCard({required this.profile});

  @override
  ConsumerState<_DelivererProfileCard> createState() =>
      _DelivererProfileCardState();
}

class _DelivererProfileCardState extends ConsumerState<_DelivererProfileCard> {
  bool _updating = false;

  Future<void> _changeStatus(DelivererStatus newStatus) async {
    setState(() => _updating = true);
    try {
      await ref
          .read(deliveriesDataSourceProvider)
          .updateDelivererStatus(newStatus);
      ref.invalidate(myDelivererProfileProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _updating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;
    final statusColor = _statusColor(profile.status);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primaryGreen.withValues(
                    alpha: 0.15,
                  ),
                  child: const Icon(
                    Icons.delivery_dining,
                    color: AppColors.primaryGreen,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.fullName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        profile.phone,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    profile.status.label,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Ganancias',
                    value: AppFormatters.currency(profile.totalEarnings),
                    icon: Icons.attach_money,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(
                    label: 'Completados',
                    value: '${profile.completedDeliveries}',
                    icon: Icons.check_circle_outline,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (_updating)
              const SizedBox(
                height: 36,
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Row(
                children: DelivererStatus.values.map((s) {
                  final isActive = s == profile.status;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: OutlinedButton(
                        onPressed: isActive ? null : () => _changeStatus(s),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: isActive
                              ? _statusColor(s)
                              : Colors.transparent,
                          foregroundColor: isActive
                              ? Colors.white
                              : _statusColor(s),
                          side: BorderSide(color: _statusColor(s)),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                        ),
                        child: Text(
                          s.label,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(DelivererStatus s) {
    switch (s) {
      case DelivererStatus.disponible:
        return AppColors.success;
      case DelivererStatus.ocupado:
        return AppColors.warning;
      case DelivererStatus.inactivo:
        return AppColors.textSecondary;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 22),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveDeliveryCard extends ConsumerStatefulWidget {
  final DeliveryRequestModel delivery;
  const _ActiveDeliveryCard({required this.delivery});

  @override
  ConsumerState<_ActiveDeliveryCard> createState() =>
      _ActiveDeliveryCardState();
}

class _ActiveDeliveryCardState extends ConsumerState<_ActiveDeliveryCard> {
  bool _completing = false;

  Future<void> _complete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar entrega'),
        content: const Text('¿Confirmas que el domicilio fue entregado?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Confirmar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _completing = true);
    try {
      await ref
          .read(deliveriesDataSourceProvider)
          .completeDelivery(widget.delivery.id);
      ref.invalidate(myDeliveriesProvider);
      ref.invalidate(myDelivererProfileProvider);
      ref.invalidate(financialRecordsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Domicilio completado!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _completing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.delivery;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              d.description,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 15,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(d.clientName, style: const TextStyle(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 4),
            _AddressRow(
              icon: Icons.trip_origin_outlined,
              text: d.pickupAddress,
            ),
            const SizedBox(height: 2),
            _AddressRow(icon: Icons.location_on, text: d.deliveryAddress),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _completing ? null : _complete,
                icon: _completing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: const Text('Marcar como Entregado'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DOMICILIARIO: MyDeliveriesScreen
// ─────────────────────────────────────────────────────────────────────────────

class MyDeliveriesScreen extends ConsumerWidget {
  const MyDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveriesAsync = ref.watch(myDeliveriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mis Domicilios'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(myDeliveriesProvider),
          ),
        ],
      ),
      body: deliveriesAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => AppErrorWidget(
          message: 'Error al cargar domicilios',
          onRetry: () => ref.invalidate(myDeliveriesProvider),
        ),
        data: (deliveries) {
          if (deliveries.isEmpty) {
            return const AppEmptyState(
              icon: Icons.delivery_dining_outlined,
              title: 'Sin domicilios',
              subtitle: 'Aquí verás tu historial de domicilios',
            );
          }
          return RefreshIndicator(
            color: AppColors.primaryGreen,
            onRefresh: () async => ref.invalidate(myDeliveriesProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: deliveries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) =>
                  _DeliveryHistoryCard(delivery: deliveries[i]),
            ),
          );
        },
      ),
    );
  }
}

class _DeliveryHistoryCard extends StatelessWidget {
  final DeliveryRequestModel delivery;
  const _DeliveryHistoryCard({required this.delivery});

  Color get _statusColor {
    switch (delivery.status) {
      case 'completed':
        return AppColors.statusDelivered;
      case 'cancelled':
        return AppColors.statusCancelled;
      case 'in_progress':
        return AppColors.statusInProgress;
      default:
        return AppColors.statusPending;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    delivery.description,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    delivery.statusLabel,
                    style: TextStyle(
                      color: _statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(delivery.clientName, style: const TextStyle(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 4),
            _AddressRow(
              icon: Icons.trip_origin_outlined,
              text: delivery.pickupAddress,
            ),
            const SizedBox(height: 2),
            _AddressRow(
              icon: Icons.location_on,
              text: delivery.deliveryAddress,
            ),
            if (delivery.income != null || delivery.expenses != null) ...[
              const Divider(height: 16),
              Row(
                children: [
                  if (delivery.income != null)
                    Expanded(
                      child: _MiniStat(
                        label: 'Ingreso',
                        value: AppFormatters.currency(delivery.income!),
                        color: AppColors.success,
                      ),
                    ),
                  if (delivery.expenses != null)
                    Expanded(
                      child: _MiniStat(
                        label: 'Gasto',
                        value: AppFormatters.currency(delivery.expenses!),
                        color: AppColors.error,
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 4),
            Text(
              AppFormatters.dateTime(delivery.createdAt),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11, color: color)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DOMICILIARIO: FinancialRecordsScreen
// ─────────────────────────────────────────────────────────────────────────────

class FinancialRecordsScreen extends ConsumerWidget {
  const FinancialRecordsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(myDelivererProfileProvider);
    final recordsAsync = ref.watch(financialRecordsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Finanzas'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(financialRecordsProvider);
              ref.invalidate(myDelivererProfileProvider);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Balance Summary ───────────────────────────────────────
            profileAsync.when(
              loading: () => const AppLoading(),
              error: (_, __) => const SizedBox.shrink(),
              data: (profile) => Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: AppColors.primaryGreen,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resumen Financiero',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppFormatters.currency(profile.totalEarnings),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total acumulado · ${profile.completedDeliveries} entregas',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Registros',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // ── Records List ──────────────────────────────────────────
            recordsAsync.when(
              loading: () => const AppLoading(),
              error: (e, _) => AppErrorWidget(
                message: 'Error al cargar registros',
                onRetry: () => ref.invalidate(financialRecordsProvider),
              ),
              data: (records) {
                if (records.isEmpty) {
                  return const AppEmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'Sin registros',
                    subtitle: 'Los registros financieros aparecerán aquí',
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (context, i) =>
                      _FinancialRecordTile(record: records[i]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FinancialRecordTile extends StatelessWidget {
  final FinancialRecordModel record;
  const _FinancialRecordTile({required this.record});

  @override
  Widget build(BuildContext context) {
    final isIncome = record.type == 'income';
    final color = isIncome ? AppColors.success : AppColors.error;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: color,
            size: 20,
          ),
        ),
        title: Text(record.description),
        subtitle: Text(AppFormatters.date(record.date)),
        trailing: Text(
          '${isIncome ? '+' : '-'} ${AppFormatters.currency(record.amount)}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
