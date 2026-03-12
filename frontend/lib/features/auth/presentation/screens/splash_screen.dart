import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/constants/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final storage = ref.read(secureStorageProvider);
    final hasSession = await storage.hasValidSession();

    if (hasSession) {
      final authenticated =
          await ref.read(authProvider.notifier).checkAuthStatus();
      if (mounted) {
        if (authenticated) {
          final user = ref.read(authProvider).user!;
          context.go(_homeForRole(user.role.name));
        } else {
          context.go(AppRoutes.login);
        }
      }
    } else {
      if (mounted) context.go(AppRoutes.login);
    }
  }

  String _homeForRole(String role) {
    switch (role) {
      case 'ADMIN':
        return AppRoutes.adminDashboard;
      case 'PRESTADOR':
        return AppRoutes.providerDashboard;
      case 'DOMICILIARIO':
        return AppRoutes.delivererDashboard;
      default:
        return AppRoutes.store;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_run_rounded, size: 100, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'RUNNERS',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 6,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Caicedonia, Valle del Cauca',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 48),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
