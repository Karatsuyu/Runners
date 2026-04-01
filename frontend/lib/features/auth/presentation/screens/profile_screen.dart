import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  String? _newImagePath;
  bool _initialized = false;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _loadUserData() {
    if (_initialized) return;
    final user = ref.read(authProvider).user;
    if (user == null) return;
    _usernameCtrl.text = user.username ?? '';
    _firstNameCtrl.text = user.firstName;
    _lastNameCtrl.text = user.lastName;
    _phoneCtrl.text = user.phone ?? '';
    _emailCtrl.text = user.email;
    _initialized = true;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (image == null || !mounted) return;
    setState(() => _newImagePath = image.path);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final ok = await ref
        .read(authProvider.notifier)
        .updateProfile(
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim(),
          username: _usernameCtrl.text.trim(),
          profileImagePath: _newImagePath,
        );

    if (!mounted) return;

    if (!ok) {
      final error =
          ref.read(authProvider).error ?? 'No fue posible actualizar el perfil';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil actualizado correctamente')),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    _loadUserData();

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mi perfil'),
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('No hay sesión activa.')),
      );
    }

    final imageProvider = _newImagePath != null
        ? FileImage(File(_newImagePath!)) as ImageProvider
        : (user.profileImageUrl != null && user.profileImageUrl!.isNotEmpty
              ? NetworkImage(user.profileImageUrl!)
              : null);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi perfil'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Guardar',
            onPressed: authState.isLoading ? null : _saveProfile,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 56,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: imageProvider,
                      child: imageProvider == null
                          ? const Icon(
                              Icons.person,
                              size: 58,
                              color: AppColors.primaryGreen,
                            )
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: InkWell(
                        onTap: _pickImage,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _usernameCtrl,
                label: 'Nombre de usuario',
                prefixIcon: Icons.alternate_email,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Ingresa un nombre de usuario';
                  }
                  if (v.trim().length < 3) {
                    return 'Mínimo 3 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _firstNameCtrl,
                label: 'Nombre',
                prefixIcon: Icons.person_outline,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _lastNameCtrl,
                label: 'Apellidos',
                prefixIcon: Icons.badge_outlined,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _phoneCtrl,
                label: 'Teléfono',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _emailCtrl,
                label: 'Correo',
                prefixIcon: Icons.email_outlined,
                readOnly: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: authState.isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                  icon: authState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    authState.isLoading ? 'Guardando...' : 'Guardar cambios',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
