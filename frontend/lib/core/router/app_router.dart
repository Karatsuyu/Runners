import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../router/app_routes.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/store/presentation/screens/store_screens.dart';
import '../../features/store/presentation/screens/order_confirm_screen.dart';
import '../../features/services/presentation/screens/services_screens.dart';
import '../../features/deliveries/presentation/screens/deliveries_screens.dart';
import '../../features/contacts/presentation/screens/contacts_screen.dart';
import '../../features/admin/presentation/screens/admin_screens.dart';
import '../../shared/widgets/app_shells.dart';

/// Bridges Riverpod [AuthState] changes → [ChangeNotifier] for GoRouter.
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier(this._ref) {
    _ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthChangeNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuth = authState.isAuthenticated;
      final isGuest = authState.isGuest;
      final location = state.matchedLocation;

      final publicRoutes = [AppRoutes.splash, AppRoutes.login, AppRoutes.register];
      final isPublic = publicRoutes.contains(location);
      final isClientRoute = location.startsWith('/client/');
      final guestBlockedRoutes = [
        '/client/cart',
        AppRoutes.orderHistory,
        AppRoutes.orderConfirm,
      ];
      final isGuestBlockedRoute =
          guestBlockedRoutes.any((route) => location.startsWith(route));

      if (!isAuth && !isGuest && !isPublic) return AppRoutes.login;

      if (isGuest && !isPublic && !isClientRoute) return AppRoutes.login;
      if (isGuest && isGuestBlockedRoute) return AppRoutes.login;

      if (isAuth && isPublic && location != AppRoutes.splash) {
        return _homeForRole(authState.user?.role);
      }
      if (!isAuth && isGuest && location == AppRoutes.splash) {
        return AppRoutes.store;
      }
      return null;
    },
    routes: [
      // ── Public routes ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // ── Client Shell ───────────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => ClientShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.store,
            builder: (context, state) => const StoreScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return CommerceDetailScreen(commerceId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.services,
            builder: (context, state) => const ServicesScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  return ProviderDetailScreen(providerId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.deliveries,
            builder: (context, state) => const DeliveriesScreen(),
          ),
          GoRoute(
            path: AppRoutes.contacts,
            builder: (context, state) => const ContactsScreen(),
          ),
          GoRoute(
            path: AppRoutes.orderHistory,
            builder: (context, state) => const OrderHistoryScreen(),
          ),
        ],
      ),

      // ── Cart (no shell, full-screen) ───────────────────────────────────
      GoRoute(
        path: '/client/cart',
        builder: (context, state) => const CartScreen(),
      ),

      // ── Order Confirm (no shell, full-screen) ──────────────────────────
      GoRoute(
        path: AppRoutes.orderConfirm,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OrderConfirmScreen(
            orderId: extra?['orderId'] as int?,
            total: extra?['total'] as double?,
            commerceName: extra?['commerceName'] as String?,
          );
        },
      ),

      // ── Provider Shell ─────────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => ProviderShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.providerDashboard,
            builder: (context, state) => const ProviderDashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.registerProvider,
            builder: (context, state) => const RegisterProviderScreen(),
          ),
          // Contacts accessible from provider shell too
          GoRoute(
            path: '/provider/contacts',
            builder: (context, state) => const ContactsScreen(),
          ),
        ],
      ),

      // ── Deliverer Shell ────────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => DelivererShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.delivererDashboard,
            builder: (context, state) => const DelivererDashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.myDeliveries,
            builder: (context, state) => const MyDeliveriesScreen(),
          ),
          GoRoute(
            path: AppRoutes.financialRecords,
            builder: (context, state) => const FinancialRecordsScreen(),
          ),
          // Contacts accessible from deliverer shell too
          GoRoute(
            path: '/deliverer/contacts',
            builder: (context, state) => const ContactsScreen(),
          ),
        ],
      ),

      // ── Admin Shell ────────────────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => AdminShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.adminDashboard,
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.manageUsers,
            builder: (context, state) => const ManageUsersScreen(),
          ),
          GoRoute(
            path: AppRoutes.manageProviders,
            builder: (context, state) => const ManageProvidersScreen(),
          ),
          GoRoute(
            path: AppRoutes.manageStore,
            builder: (context, state) => const ManageStoreScreen(),
          ),
          GoRoute(
            path: AppRoutes.manageContacts,
            builder: (context, state) => const ManageContactsScreen(),
          ),
          GoRoute(
            path: AppRoutes.reports,
            builder: (context, state) => const ReportsScreen(),
          ),
        ],
      ),
    ],
  );
});

String _homeForRole(UserRole? role) {
  switch (role) {
    case UserRole.CLIENTE:
      return AppRoutes.store;
    case UserRole.PRESTADOR:
      return AppRoutes.providerDashboard;
    case UserRole.DOMICILIARIO:
      return AppRoutes.delivererDashboard;
    case UserRole.ADMIN:
      return AppRoutes.adminDashboard;
    case null:
      return AppRoutes.login;
  }
}
