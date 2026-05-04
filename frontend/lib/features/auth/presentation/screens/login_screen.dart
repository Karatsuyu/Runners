import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _rememberMe = true;

  static const Color _panelWhite = Colors.white;

  @override
  void initState() {
    super.initState();
    _loadRememberedCredentials();
  }

  Future<void> _loadRememberedCredentials() async {
    final storage = ref.read(secureStorageProvider);
    final rememberMeEnabled = await storage.isRememberMeEnabled();

    if (!mounted) return;

    if (!rememberMeEnabled) {
      setState(() => _rememberMe = false);
      return;
    }

    final rememberedEmail = await storage.getRememberedEmail();
    final rememberedPassword = await storage.getRememberedPassword();

    if (!mounted) return;

    setState(() {
      _rememberMe = true;
      _emailCtrl.text = rememberedEmail ?? '';
      _passCtrl.text = rememberedPassword ?? '';
    });
  }

  Future<void> _onRememberMeChanged(bool value) async {
    setState(() => _rememberMe = value);

    if (!value) {
      final storage = ref.read(secureStorageProvider);
      await storage.clearRememberedCredentials();
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(authProvider.notifier)
        .login(_emailCtrl.text.trim(), _passCtrl.text, rememberMe: _rememberMe);

    if (!mounted || !success) return;

    final user = ref.read(authProvider).user!;
    context.go(_homeForRole(user.role.name));
  }

  void _continueAsGuest() {
    ref.read(authProvider.notifier).continueAsGuest();
    context.go(AppRoutes.store);
  }

  void _showHelpDialog() {
    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar ayuda',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 160),
      pageBuilder: (context, _, __) {
        final topInset = MediaQuery.of(context).padding.top;
        final width = MediaQuery.of(context).size.width;
        final panelWidth = width > 420 ? 270.0 : width - 78;

        return SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              width: panelWidth,
              margin: EdgeInsets.only(top: topInset + 58, right: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _panelWhite,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '¿Necesitas ayuda?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6),
                  Divider(color: AppColors.redAccent, thickness: 1.5),
                  SizedBox(height: 8),
                  Text(
                    'Escribe tu usuario o\ncorreo y contraseña\nregistrados.\n\n*Si olvidaste tus\ndatos, usa la opción\nde olvidaste tu\ncontraseña*',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
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
    final authState = ref.watch(authProvider);
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 600;

    final topInset = MediaQuery.of(context).padding.top;
    final headerHeight = topInset + 74;

    final cardWidth = isCompact ? width - 38 : 640.0;
    final titleSize = isCompact ? 24.0 : 30.0;
    final topLogoSize = isCompact ? 100.0 : 116.0;
    final topLogoOffset = isCompact ? -50.0 : -58.0;

    final backgroundAsset = kIsWeb
        ? 'assets/images/login_background_web.jpg'
        : 'assets/images/login_background.jpg';

    final linkStyle = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(backgroundAsset),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              child: const SizedBox.expand(),
            ),
          ),
          Positioned.fill(
            child: Container(color: const Color.fromRGBO(255, 255, 255, 0.18)),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: headerHeight + (isCompact ? 56 : 70),
              bottom: 16,
            ),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      width: cardWidth,
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      padding: const EdgeInsets.fromLTRB(18, 72, 18, 22),
                      constraints: BoxConstraints(
                        minHeight: isCompact ? 420 : 470,
                      ),
                      decoration: BoxDecoration(
                        color: _panelWhite,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Inicia sesión',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: titleSize,
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 14),
                            if (authState.error != null)
                              Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.red.shade200,
                                  ),
                                ),
                                child: Text(
                                  authState.error!,
                                  style: const TextStyle(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            AppTextField(
                              controller: _emailCtrl,
                              label: 'Usuario o Correo',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) => v == null || !v.contains('@')
                                  ? 'Ingresa un correo válido'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: _passCtrl,
                              label: 'Contraseña',
                              prefixIcon: Icons.lock_outline,
                              obscureText: _obscurePass,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePass
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() => _obscurePass = !_obscurePass);
                                },
                              ),
                              validator: (v) => v == null || v.length < 6
                                  ? 'Mínimo 6 caracteres'
                                  : null,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: isCompact ? 52 : 58,
                              child: ElevatedButton(
                                onPressed: authState.isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28),
                                  ),
                                ),
                                child: authState.isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      )
                                    : const Text(
                                        'Acceder',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.scale(
                                  scale: 1.1,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    activeColor: AppColors.primaryGreen,
                                    onChanged: (value) {
                                      _onRememberMeChanged(value ?? false);
                                    },
                                  ),
                                ),
                                const Text(
                                  'Recordarme',
                                  style: TextStyle(
                                    color: AppColors.primaryGreen,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              style: linkStyle,
                              onPressed: () {
                                context.go(AppRoutes.forgotPassword);
                              },
                              child: const Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.primaryGreen,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 10,
                              children: [
                                TextButton(
                                  style: linkStyle,
                                  onPressed: () =>
                                      context.go(AppRoutes.register),
                                  child: const Text(
                                    'Registrarse',
                                    style: TextStyle(
                                      color: AppColors.primaryGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.primaryGreen,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  style: linkStyle,
                                  onPressed: _continueAsGuest,
                                  child: const Text(
                                    'Continuar como invitado',
                                    style: TextStyle(
                                      color: AppColors.primaryGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.primaryGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: topLogoOffset,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/login_logo.png',
                          width: topLogoSize,
                          height: topLogoSize,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: topLogoSize,
                            height: topLogoSize,
                            color: _panelWhite,
                            child: const Icon(
                              Icons.directions_run_rounded,
                              color: AppColors.primaryGreen,
                              size: 62,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: headerHeight,
              color: _panelWhite,
              padding: EdgeInsets.fromLTRB(18, topInset + 2, 18, 2),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/login_logo.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 70,
                        height: 70,
                        color: _panelWhite,
                        child: const Icon(
                          Icons.directions_run_rounded,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _showHelpDialog,
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 2.5),
                      ),
                      child: const Icon(
                        Icons.question_mark,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
