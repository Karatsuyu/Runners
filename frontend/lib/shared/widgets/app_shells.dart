import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_routes.dart';
import '../../core/constants/app_colors.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class _NavTab {
  final String route;
  final IconData icon;
  final String label;
  const _NavTab(this.route, this.icon, this.label);
}

// ── Shell del Cliente ──────────────────────────────────────────────────────
class ClientShell extends StatelessWidget {
  final Widget child;
  const ClientShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final tabs = [
      _NavTab(AppRoutes.deliveries, Icons.delivery_dining_rounded, 'Domicilios'),
      _NavTab(AppRoutes.store, Icons.store_rounded, 'Tienda'),
      _NavTab(AppRoutes.contacts, Icons.contacts_rounded, 'Contactos'),
    ];
    int currentIndex =
        tabs.indexWhere((t) => location.startsWith(t.route));
    if (currentIndex == -1) currentIndex = 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => context.go(tabs[i].route),
        destinations: tabs
            .map((t) => NavigationDestination(
                  icon: Icon(t.icon),
                  label: t.label,
                ))
            .toList(),
      ),
    );
  }
}

// ── Shell del Prestador ───────────────────────────────────────────────────
class ProviderShell extends StatelessWidget {
  final Widget child;
  const ProviderShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final tabs = [
      _NavTab(AppRoutes.providerDashboard, Icons.dashboard_rounded, 'Mi Panel'),
      _NavTab(AppRoutes.providerContacts, Icons.contacts_rounded, 'Contactos'),
    ];
    int idx = tabs.indexWhere((t) => location.startsWith(t.route));
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx < 0 ? 0 : idx,
        onDestinationSelected: (i) => context.go(tabs[i].route),
        destinations: tabs
            .map((t) => NavigationDestination(
                  icon: Icon(t.icon),
                  label: t.label,
                ))
            .toList(),
      ),
    );
  }
}

// ── Shell del Domiciliario ────────────────────────────────────────────────
class DelivererShell extends StatelessWidget {
  final Widget child;
  const DelivererShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final tabs = [
      _NavTab(AppRoutes.delivererDashboard, Icons.dashboard_rounded, 'Mi Panel'),
      _NavTab(AppRoutes.myDeliveries, Icons.delivery_dining_rounded, 'Mis Domicilios'),
      _NavTab(AppRoutes.financialRecords, Icons.account_balance_wallet_rounded, 'Finanzas'),
      _NavTab(AppRoutes.delivererContacts, Icons.contacts_rounded, 'Contactos'),
    ];
    int idx = tabs.indexWhere((t) => location.startsWith(t.route));
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx < 0 ? 0 : idx,
        onDestinationSelected: (i) => context.go(tabs[i].route),
        destinations: tabs
            .map((t) => NavigationDestination(
                  icon: Icon(t.icon),
                  label: t.label,
                ))
            .toList(),
      ),
    );
  }
}

// ── Shell del Admin ───────────────────────────────────────────────────────
class AdminShell extends ConsumerWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Runners Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primaryGreen),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.directions_run_rounded, color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Runners Admin',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Text('Panel de administración',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            _DrawerItem(
                Icons.dashboard_rounded, 'Dashboard', AppRoutes.adminDashboard),
            _DrawerItem(
                Icons.people_rounded, 'Usuarios', AppRoutes.manageUsers),
            _DrawerItem(
                Icons.handyman_rounded, 'Prestadores', AppRoutes.manageProviders),
            _DrawerItem(
                Icons.store_rounded, 'Tienda', AppRoutes.manageStore),
            _DrawerItem(
                Icons.contacts_rounded, 'Contactos', AppRoutes.manageContacts),
            _DrawerItem(
                Icons.bar_chart_rounded, 'Reportes', AppRoutes.reports),
          ],
        ),
      ),
      body: child,
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  const _DrawerItem(this.icon, this.label, this.route);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}
