import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _requestFormKey = GlobalKey<FormState>();
  final _confirmFormKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _newPass2Ctrl = TextEditingController();

  bool _codeSent = false;
  bool _hideNewPassword = true;
  bool _hideNewPassword2 = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _codeCtrl.dispose();
    _newPassCtrl.dispose();
    _newPass2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!_requestFormKey.currentState!.validate()) return;

    final error = await ref
        .read(authProvider.notifier)
        .requestPasswordResetCode(_emailCtrl.text.trim());

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    setState(() => _codeSent = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Si el correo existe, enviamos un codigo de verificacion.',
        ),
      ),
    );
  }

  Future<void> _confirmReset() async {
    if (!_confirmFormKey.currentState!.validate()) return;

    final error = await ref
        .read(authProvider.notifier)
        .confirmPasswordReset(
          email: _emailCtrl.text.trim(),
          code: _codeCtrl.text.trim(),
          newPassword: _newPassCtrl.text,
          newPassword2: _newPass2Ctrl.text,
        );

    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contrasena actualizada. Ya puedes iniciar sesion.'),
      ),
    );
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go(AppRoutes.login),
          icon: Image.asset(
            'assets/images/flecha.png',
            width: 24,
            height: 24,
            errorBuilder: (_, __, ___) => const Icon(Icons.arrow_back),
          ),
        ),
        title: const Text('Recuperar contrasena'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Te enviaremos un codigo de verificacion al correo registrado.',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 14),
            Form(
              key: _requestFormKey,
              child: Column(
                children: [
                  AppTextField(
                    controller: _emailCtrl,
                    label: 'Correo electronico',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) => v == null || !v.contains('@')
                        ? 'Ingresa un correo valido'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _sendCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                      ),
                      child: authState.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Enviar codigo'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_codeSent)
              Form(
                key: _confirmFormKey,
                child: Column(
                  children: [
                    AppTextField(
                      controller: _codeCtrl,
                      label: 'Codigo de verificacion',
                      prefixIcon: Icons.verified_user_outlined,
                      keyboardType: TextInputType.number,
                      validator: (v) => v == null || v.trim().length != 6
                          ? 'El codigo debe tener 6 digitos'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _newPassCtrl,
                      label: 'Nueva contrasena',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _hideNewPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hideNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => _hideNewPassword = !_hideNewPassword);
                        },
                      ),
                      validator: (v) => v == null || v.length < 6
                          ? 'Minimo 6 caracteres'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _newPass2Ctrl,
                      label: 'Confirmar nueva contrasena',
                      prefixIcon: Icons.lock_reset,
                      obscureText: _hideNewPassword2,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hideNewPassword2
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(
                            () => _hideNewPassword2 = !_hideNewPassword2,
                          );
                        },
                      ),
                      validator: (v) {
                        if (v == null || v.length < 6) {
                          return 'Minimo 6 caracteres';
                        }
                        if (v != _newPassCtrl.text) {
                          return 'Las contrasenas no coinciden';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: authState.isLoading ? null : _confirmReset,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                        ),
                        child: authState.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Actualizar contrasena'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
