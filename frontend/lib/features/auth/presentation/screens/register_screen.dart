import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscurePass2 = true;

  static const Color _panelWhite = Colors.white;

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
                    'Completa todos los campos\npara crear tu cuenta.\n\n*Si ya tienes cuenta,\ningresa con iniciar sesión*',
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

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await ref.read(authProvider.notifier).register({
      'email': _emailCtrl.text.trim(),
      'first_name': _firstNameCtrl.text.trim(),
      'last_name': _lastNameCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'password': _passCtrl.text,
      'password2': _pass2Ctrl.text,
    });
    if (success && mounted) {
      context.go(AppRoutes.store);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 600;
    final topInset = MediaQuery.of(context).padding.top;
    final headerHeight = topInset + 74;
    final cardWidth = isCompact ? width - 38 : 720.0;
    final topLogoSize = isCompact ? 100.0 : 116.0;
    final topLogoOffset = isCompact ? -50.0 : -58.0;
    final backgroundAsset = kIsWeb
        ? 'assets/images/login_background_web.jpg'
        : 'assets/images/login_background.jpg';

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
            child: Container(
              color: const Color.fromRGBO(255, 255, 255, 0.18),
            ),
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
                      padding: const EdgeInsets.fromLTRB(18, 64, 18, 16),
                      decoration: BoxDecoration(
                        color: _panelWhite,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Registrarse',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 14),
                            if (authState.error != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red.shade200),
                                ),
                                child: Text(
                                  authState.error!,
                                  style: const TextStyle(color: AppColors.error),
                                ),
                              ),
                            Row(
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    controller: _firstNameCtrl,
                                    label: 'Nombre',
                                    prefixIcon: Icons.person_outline,
                                    validator: (v) =>
                                        v == null || v.isEmpty ? 'Requerido' : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AppTextField(
                                    controller: _lastNameCtrl,
                                    label: 'Apellidos',
                                    prefixIcon: Icons.person_outline,
                                    validator: (v) =>
                                        v == null || v.isEmpty ? 'Requerido' : null,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: _emailCtrl,
                              label: 'Correo electrónico',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) =>
                                  v == null || !v.contains('@') ? 'Correo inválido' : null,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: _phoneCtrl,
                              label: 'Teléfono',
                              prefixIcon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (v) =>
                                  v == null || v.isEmpty ? 'Requerido' : null,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: _passCtrl,
                              label: 'Contraseña',
                              prefixIcon: Icons.lock_outline,
                              obscureText: _obscurePass,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePass ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () =>
                                    setState(() => _obscurePass = !_obscurePass),
                              ),
                              validator: (v) =>
                                  v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
                            ),
                            const SizedBox(height: 16),
                            AppTextField(
                              controller: _pass2Ctrl,
                              label: 'Confirmar contraseña',
                              prefixIcon: Icons.lock_outline,
                              obscureText: _obscurePass2,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePass2 ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () =>
                                    setState(() => _obscurePass2 = !_obscurePass2),
                              ),
                              validator: (v) => v != _passCtrl.text
                                  ? 'Las contraseñas no coinciden'
                                  : null,
                            ),
                            const SizedBox(height: 24),
                            AppButton(
                              label: 'Registrarse',
                              isLoading: authState.isLoading,
                              onPressed: _register,
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '¿Ya tienes cuenta?',
                                  style: TextStyle(
                                    color: Color(0xFFBDBABA),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => context.go(AppRoutes.login),
                                  child: const Text(
                                    'Inicia Sesión',
                                    style: TextStyle(
                                      color: AppColors.primaryGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
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
