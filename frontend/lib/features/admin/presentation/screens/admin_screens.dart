import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../contacts/presentation/providers/contacts_provider.dart';
import '../../../services/presentation/providers/services_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Admin Providers  (inline para evitar archivos extra)
// ─────────────────────────────────────────────────────────────────────────────

class AdminDashboardData {
  final int totalUsers;
  final int pendingProviders;
  final int totalOrders;
  final int activeDeliveries;
  final double totalRevenue;

  const AdminDashboardData({
    required this.totalUsers,
    required this.pendingProviders,
    required this.totalOrders,
    required this.activeDeliveries,
    required this.totalRevenue,
  });

  factory AdminDashboardData.fromJson(Map<String, dynamic> j) =>
      AdminDashboardData(
        totalUsers: j['total_users'] as int? ?? 0,
        pendingProviders: j['pending_providers'] as int? ?? 0,
        totalOrders: j['total_orders'] as int? ?? 0,
        activeDeliveries: j['active_deliveries'] as int? ?? 0,
        totalRevenue: (j['total_revenue'] as num?)?.toDouble() ?? 0.0,
      );
}

class AdminUserModel {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final bool isActive;

  const AdminUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.isActive,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> j) => AdminUserModel(
        id: j['id'] as int,
        fullName: j['full_name'] as String? ?? '',
        email: j['email'] as String? ?? '',
        phone: j['phone'] as String? ?? '',
        role: j['role'] as String? ?? '',
        isActive: j['is_active'] as bool? ?? true,
      );

  String get roleLabel {
    switch (role) {
      case 'CLIENTE':
        return 'Cliente';
      case 'PRESTADOR':
        return 'Prestador';
      case 'DOMICILIARIO':
        return 'Domiciliario';
      case 'ADMIN':
        return 'Admin';
      default:
        return role;
    }
  }
}

final adminDashboardProvider = FutureProvider<AdminDashboardData>((ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  final res = await dio.get(ApiConstants.dashboardReport);
  return AdminDashboardData.fromJson(res.data as Map<String, dynamic>);
});

final adminUsersProvider = FutureProvider<List<AdminUserModel>>((ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  final res = await dio.get(ApiConstants.users);
  final data = res.data is List
      ? res.data as List
      : (res.data['results'] as List? ?? []);
  return data.map((j) => AdminUserModel.fromJson(j as Map<String, dynamic>)).toList();
});

// ─────────────────────────────────────────────────────────────────────────────
// AdminDashboardScreen
// ─────────────────────────────────────────────────────────────────────────────

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashAsync = ref.watch(adminDashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(adminDashboardProvider),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primaryGreen,
        onRefresh: () async => ref.invalidate(adminDashboardProvider),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ───────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryGreen, AppColors.darkGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Panel Administrativo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Runners · Caicedonia',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Resumen',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              dashAsync.when(
                loading: () => const AppLoading(),
                error: (e, _) => AppErrorWidget(
                  message: 'Error cargando estadísticas',
                  onRetry: () => ref.invalidate(adminDashboardProvider),
                ),
                data: (data) => GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    _DashCard(
                      title: 'Usuarios',
                      value: '${data.totalUsers}',
                      icon: Icons.people_outline,
                      color: AppColors.primaryGreen,
                    ),
                    _DashCard(
                      title: 'Prestadores Pendientes',
                      value: '${data.pendingProviders}',
                      icon: Icons.pending_outlined,
                      color: AppColors.warning,
                    ),
                    _DashCard(
                      title: 'Pedidos',
                      value: '${data.totalOrders}',
                      icon: Icons.shopping_bag_outlined,
                      color: AppColors.statusConfirmed,
                    ),
                    _DashCard(
                      title: 'Domicilios Activos',
                      value: '${data.activeDeliveries}',
                      icon: Icons.delivery_dining_outlined,
                      color: AppColors.statusInProgress,
                    ),
                    _DashCard(
                      title: 'Ingresos Totales',
                      value: AppFormatters.currency(data.totalRevenue),
                      icon: Icons.monetization_on_outlined,
                      color: AppColors.success,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _DashCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ManageUsersScreen
// ─────────────────────────────────────────────────────────────────────────────

class ManageUsersScreen extends ConsumerWidget {
  const ManageUsersScreen({super.key});

  Future<void> _toggleStatus(
    BuildContext context,
    WidgetRef ref,
    AdminUserModel user,
  ) async {
    final action = user.isActive ? 'suspender' : 'activar';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('¿$action usuario?'),
        content: Text(
          'Esto ${user.isActive ? 'suspenderá' : 'activará'} la cuenta de ${user.fullName}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: user.isActive ? AppColors.error : AppColors.success,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(action, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final dio = ref.read(dioClientProvider).dio;
      await dio.post(ApiConstants.toggleUserStatus(user.id));
      ref.invalidate(adminUsersProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Usuario ${user.isActive ? 'suspendido' : 'activado'}'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(adminUsersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Gestionar Usuarios'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(adminUsersProvider),
          ),
        ],
      ),
      body: usersAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => AppErrorWidget(
          message: 'Error cargando usuarios',
          onRetry: () => ref.invalidate(adminUsersProvider),
        ),
        data: (users) {
          if (users.isEmpty) {
            return const AppEmptyState(
              icon: Icons.people_outline,
              title: 'Sin usuarios',
              subtitle: 'No hay usuarios registrados',
            );
          }
          return RefreshIndicator(
            color: AppColors.primaryGreen,
            onRefresh: () async => ref.invalidate(adminUsersProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, i) => _UserTile(
                user: users[i],
                onToggle: () => _toggleStatus(context, ref, users[i]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final AdminUserModel user;
  final VoidCallback onToggle;

  const _UserTile({required this.user, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: user.isActive
              ? AppColors.primaryGreen.withValues(alpha: 0.12)
              : AppColors.textSecondary.withValues(alpha: 0.12),
          child: Text(
            user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
            style: TextStyle(
              color: user.isActive ? AppColors.primaryGreen : AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email, style: const TextStyle(fontSize: 12)),
            Text(user.roleLabel,
                style: const TextStyle(fontSize: 12, color: AppColors.primaryGreen)),
          ],
        ),
        trailing: Switch(
          value: user.isActive,
          activeThumbColor: AppColors.primaryGreen,
          onChanged: (_) => onToggle(),
        ),
        isThreeLine: true,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ManageProvidersScreen  (approve / reject)
// ─────────────────────────────────────────────────────────────────────────────

class ManageProvidersScreen extends ConsumerWidget {
  const ManageProvidersScreen({super.key});

  Future<void> _approve(BuildContext context, WidgetRef ref, int providerId) async {
    try {
      final dio = ref.read(dioClientProvider).dio;
      await dio.post(ApiConstants.approveProvider(providerId), data: {'approved': true});
      ref.invalidate(providersProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prestador aprobado'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _reject(BuildContext context, WidgetRef ref, int providerId) async {
    final reasonCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rechazar prestador'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('¿Por qué rechazas este prestador?'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonCtrl,
              decoration: const InputDecoration(
                hintText: 'Motivo del rechazo',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Rechazar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final dio = ref.read(dioClientProvider).dio;
      await dio.post(
        ApiConstants.approveProvider(providerId),
        data: {'approved': false, 'reason': reasonCtrl.text},
      );
      ref.invalidate(providersProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Prestador rechazado'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providersAsync = ref.watch(providersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Gestionar Prestadores'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(providersProvider),
          ),
        ],
      ),
      body: providersAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => AppErrorWidget(
          message: 'Error cargando prestadores',
          onRetry: () => ref.invalidate(providersProvider),
        ),
        data: (providers) {
          if (providers.isEmpty) {
            return const AppEmptyState(
              icon: Icons.work_outline,
              title: 'Sin prestadores',
              subtitle: 'No hay prestadores registrados',
            );
          }
          return RefreshIndicator(
            color: AppColors.primaryGreen,
            onRefresh: () async => ref.invalidate(providersProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: providers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final p = providers[i];
                final isPending = !p.isApproved;
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.work_outline,
                                color: AppColors.primaryGreen, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                p.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            _StatusBadge(status: p.isApproved ? 'active' : 'pending'),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(p.profession,
                            style: const TextStyle(color: AppColors.textSecondary)),
                        Text(p.phone,
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 12)),
                        if (p.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            p.description,
                            style: const TextStyle(fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        if (isPending) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.close, size: 16),
                                  label: const Text('Rechazar'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.error,
                                    side: const BorderSide(color: AppColors.error),
                                  ),
                                  onPressed: () => _reject(context, ref, p.id),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.check, size: 16),
                                  label: const Text('Aprobar'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.success,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () => _approve(context, ref, p.id),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  Color get _color {
    switch (status) {
      case 'pending':
        return AppColors.statusPending;
      case 'active':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String get _label {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'active':
        return 'Activo';
      case 'rejected':
        return 'Rechazado';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ManageStoreScreen
// ─────────────────────────────────────────────────────────────────────────────

class ManageStoreScreen extends ConsumerWidget {
  const ManageStoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ManageStoreView();
  }
}

class _ManageStoreView extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ManageStoreView> createState() => _ManageStoreViewState();
}

class _ManageStoreViewState extends ConsumerState<_ManageStoreView> {
  List<Map<String, dynamic>> _commerces = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final dio = ref.read(dioClientProvider).dio;
      final res = await dio.get(ApiConstants.commerces);
      final data = res.data is List
          ? res.data as List
          : (res.data['results'] as List? ?? []);
      setState(() {
        _commerces = data.cast<Map<String, dynamic>>();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Gestionar Tienda'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _loading
          ? const AppLoading()
          : _error != null
              ? AppErrorWidget(message: _error!, onRetry: _load)
              : _commerces.isEmpty
                  ? const AppEmptyState(
                      icon: Icons.store_outlined,
                      title: 'Sin comercios',
                      subtitle: 'Aún no hay comercios registrados',
                    )
                  : RefreshIndicator(
                      color: AppColors.primaryGreen,
                      onRefresh: _load,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(12),
                        itemCount: _commerces.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final c = _commerces[i];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    AppColors.primaryGreen.withValues(alpha: 0.12),
                                child: const Icon(Icons.store_outlined,
                                    color: AppColors.primaryGreen),
                              ),
                              title: Text(
                                c['name'] as String? ?? '',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                c['category_name'] as String? ??
                                    c['category'] as String? ??
                                    '',
                              ),
                              trailing: Switch(
                                value: c['is_active'] as bool? ?? true,
                                activeThumbColor: AppColors.primaryGreen,
                                onChanged: (val) async {
                                  try {
                                    final dio = ref.read(dioClientProvider).dio;
                                    final id = c['id'] as int;
                                    await dio.patch(
                                      ApiConstants.commerceDetail(id),
                                      data: {'is_active': val},
                                    );
                                    _load();
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Error: $e'),
                                        backgroundColor: AppColors.error,
                                      ));
                                    }
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ManageContactsScreen  (CRUD)
// ─────────────────────────────────────────────────────────────────────────────

class ManageContactsScreen extends ConsumerWidget {
  const ManageContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsync = ref.watch(contactsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Gestionar Contactos'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(contactsProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        onPressed: () => _showContactForm(context, ref, null),
        child: const Icon(Icons.add),
      ),
      body: contactsAsync.when(
        loading: () => const AppLoading(),
        error: (e, _) => AppErrorWidget(
          message: 'Error cargando contactos',
          onRetry: () => ref.invalidate(contactsProvider),
        ),
        data: (contacts) {
          if (contacts.isEmpty) {
            return const AppEmptyState(
              icon: Icons.contacts_outlined,
              title: 'Sin contactos',
              subtitle: 'Toca + para agregar un contacto',
            );
          }
          return RefreshIndicator(
            color: AppColors.primaryGreen,
            onRefresh: () async => ref.invalidate(contactsProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: contacts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, i) {
                final c = contacts[i];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.12),
                      child: Text(
                        c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                        style: const TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(c.name,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '${c.phone} · ${c.typeLabel} · ${c.approvalStatus}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (c.approvalStatus == 'PENDIENTE')
                          IconButton(
                            icon: const Icon(
                              Icons.check_circle_outline,
                              color: AppColors.success,
                              size: 20,
                            ),
                            tooltip: 'Aprobar',
                            onPressed: () => _reviewContact(
                              context,
                              ref,
                              c.id,
                              approve: true,
                            ),
                          ),
                        if (c.approvalStatus == 'PENDIENTE')
                          IconButton(
                            icon: const Icon(
                              Icons.cancel_outlined,
                              color: AppColors.warning,
                              size: 20,
                            ),
                            tooltip: 'Rechazar',
                            onPressed: () => _reviewContact(
                              context,
                              ref,
                              c.id,
                              approve: false,
                            ),
                          ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined,
                              color: AppColors.primaryGreen, size: 20),
                          onPressed: () => _showContactForm(context, ref, c),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.error, size: 20),
                          onPressed: () => _deleteContact(context, ref, c.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _reviewContact(
    BuildContext context,
    WidgetRef ref,
    int contactId, {
    required bool approve,
  }) async {
    try {
      final ds = ref.read(contactsDataSourceProvider);
      await ds.reviewContact(id: contactId, approve: approve);
      ref.invalidate(contactsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(approve ? 'Contacto aprobado' : 'Contacto rechazado'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo actualizar estado: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _deleteContact(
    BuildContext context,
    WidgetRef ref,
    int contactId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar contacto'),
        content: const Text('¿Estás seguro de eliminar este contacto?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final ds = ref.read(contactsDataSourceProvider);
      await ds.deleteContact(contactId);
      ref.invalidate(contactsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contacto eliminado'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _showContactForm(
    BuildContext context,
    WidgetRef ref,
    ContactModel? existing,
  ) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final emailCtrl = TextEditingController(text: existing?.email ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    String selectedType = existing?.type ?? 'professional';
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: StatefulBuilder(builder: (ctx, setModalState) {
          return Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    existing == null ? 'Nuevo Contacto' : 'Editar Contacto',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    controller: nameCtrl,
                    label: 'Nombre',
                    prefixIcon: Icons.person_outline,
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: phoneCtrl,
                    label: 'Teléfono',
                    prefixIcon: Icons.phone_outlined,
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: emailCtrl,
                    label: 'Email (opcional)',
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: descCtrl,
                    label: 'Descripción (opcional)',
                    prefixIcon: Icons.description_outlined,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    decoration: InputDecoration(
                      labelText: 'Tipo',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      prefixIcon: const Icon(Icons.category_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'professional', child: Text('Profesional')),
                      DropdownMenuItem(value: 'emergency', child: Text('Emergencia')),
                      DropdownMenuItem(value: 'commerce', child: Text('Comercio')),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedType = val);
                    },
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    label: existing == null ? 'Crear Contacto' : 'Guardar Cambios',
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      try {
                        final ds = ref.read(contactsDataSourceProvider);
                        final contact = ContactModel(
                          id: existing?.id ?? 0,
                          name: nameCtrl.text.trim(),
                          phone: phoneCtrl.text.trim(),
                          email: emailCtrl.text.trim().isNotEmpty
                              ? emailCtrl.text.trim()
                              : null,
                          type: selectedType,
                          description: descCtrl.text.trim().isNotEmpty
                              ? descCtrl.text.trim()
                              : null,
                        );
                        if (existing == null) {
                          await ds.createContact(contact);
                        } else {
                          await ds.updateContact(existing.id, contact);
                        }
                        ref.invalidate(contactsProvider);
                        if (ctx.mounted) Navigator.pop(ctx);
                      } catch (e) {
                        if (ctx.mounted) {
                          ScaffoldMessenger.of(ctx).showSnackBar(
                            SnackBar(
                                content: Text('Error: $e'),
                                backgroundColor: AppColors.error),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ReportsScreen
// ─────────────────────────────────────────────────────────────────────────────

class _ReportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ReportCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(subtitle,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  Map<String, dynamic>? _reportData;
  String _activeReport = '';
  bool _loading = false;

  Future<void> _loadReport(String endpoint, String label) async {
    setState(() {
      _loading = true;
      _activeReport = label;
    });
    try {
      final dio = ref.read(dioClientProvider).dio;
      final res = await dio.get(endpoint);
      setState(() {
        _reportData = res.data is Map ? res.data as Map<String, dynamic> : {'data': res.data};
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _reportData = null;
        _loading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reportes'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informes disponibles',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _ReportCard(
              title: 'Reporte de Ventas',
              subtitle: 'Pedidos y facturación de la tienda',
              icon: Icons.bar_chart,
              color: AppColors.statusConfirmed,
              onTap: () => _loadReport(ApiConstants.salesReport, 'Ventas'),
            ),
            const SizedBox(height: 8),
            _ReportCard(
              title: 'Reporte de Domicilios',
              subtitle: 'Rendimiento de repartidores',
              icon: Icons.delivery_dining_outlined,
              color: AppColors.statusInProgress,
              onTap: () =>
                  _loadReport(ApiConstants.deliverersReport, 'Domicilios'),
            ),
            const SizedBox(height: 8),
            _ReportCard(
              title: 'Reporte de Servicios',
              subtitle: 'Solicitudes y prestadores activos',
              icon: Icons.work_outline,
              color: AppColors.primaryGreen,
              onTap: () =>
                  _loadReport(ApiConstants.servicesReport, 'Servicios'),
            ),

            if (_loading) ...[
              const SizedBox(height: 24),
              const AppLoading(),
            ] else if (_reportData != null) ...[
              const SizedBox(height: 24),
              Text(
                'Reporte: $_activeReport',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _reportData!.entries
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      e.key,
                                      style: const TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 13),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      '${e.value}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
