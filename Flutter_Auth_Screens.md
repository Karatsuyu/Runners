# 📱 Runners — Pantallas de Autenticación en Flutter/Dart

> Adaptación del frontend React (Login, Register, Navbar) al framework **Flutter** para implementación **100% móvil**.
>
> **Fecha de generación:** 12 de marzo de 2026
>
> **Origen:** Commit `3b8dc79` — archivos `Login.jsx`, `Login.css`, `Register.jsx`, `Register.css`, `Navbar.jsx`, `AuthContext.jsx`, `axiosConfig.js`

---

## 📁 Estructura de archivos sugerida

```
lib/
├── main.dart
├── config/
│   └── api_config.dart              # Base URL y configuración
├── services/
│   ├── api_service.dart             # Cliente HTTP (Dio) con interceptores
│   └── auth_service.dart            # Login, Register, Logout, Profile
├── providers/
│   └── auth_provider.dart           # Estado global de autenticación
├── models/
│   └── user_model.dart              # Modelo User
├── screens/
│   ├── login_screen.dart            # Pantalla de Login
│   └── register_screen.dart         # Pantalla de Registro
├── widgets/
│   ├── custom_text_field.dart       # Input reutilizable con iconos
│   ├── primary_button.dart          # Botón verde principal
│   └── top_bar.dart                 # Barra superior con logo y ayuda
└── assets/
    ├── fondo.png
    ├── r2.jpg
    ├── ayuda.png
    ├── correo.png
    ├── contraseña.png
    ├── mostrar.png
    └── ocultar.png
```

---

## 📦 Dependencias (`pubspec.yaml`)

```yaml
name: runners_app
description: Runners - Plataforma de intermediación de servicios

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  dio: ^5.4.0                  # Cliente HTTP (equivale a Axios)
  provider: ^6.1.1             # Estado global (equivale a Context API)
  flutter_secure_storage: ^9.0.0  # Almacenamiento seguro de tokens
  go_router: ^14.0.0           # Navegación declarativa

flutter:
  uses-material-design: true
  assets:
    - assets/fondo.png
    - assets/r2.jpg
    - assets/ayuda.png
    - assets/correo.png
    - assets/contraseña.png
    - assets/mostrar.png
    - assets/ocultar.png
```

---

## 🎨 Colores del proyecto (constantes)

```dart
// lib/config/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF003818);
  static const Color darkGreen = Color(0xFF0D4D2F);
  static const Color background = Color(0xFFFFFDFD);
  static const Color inputBg = Color(0xFFDCDCDC);
  static const Color inputBgLight = Color(0xFFEFEFEF);
  static const Color redAccent = Color(0xFFF80000);
  static const Color textGray = Color(0xFFB5B5B5);
  static const Color gold = Color(0xFFFFD700);
  static const Color greenNeon = Color(0xFF00FF88);
}
```

---

## 1. `api_config.dart` — Configuración base

```dart
// lib/config/api_config.dart

class ApiConfig {
  // Cambiar a tu IP local para pruebas en emulador/dispositivo
  // En emulador Android usar 10.0.2.2 en vez de localhost
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  // Para dispositivo físico usar la IP de tu PC:
  // static const String baseUrl = 'http://192.168.x.x:8000/api/v1';
}
```

---

## 2. `user_model.dart` — Modelo de usuario

```dart
// lib/models/user_model.dart

class UserModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final String phone;
  final String role;
  final String dateJoined;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.phone,
    required this.role,
    required this.dateJoined,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      fullName: json['full_name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'CLIENTE',
      dateJoined: json['date_joined'] ?? '',
    );
  }

  bool get isAdmin => role == 'ADMIN';
  bool get isDomiciliario => role == 'DOMICILIARIO';
  bool get isPrestador => role == 'PRESTADOR';
}
```

---

## 3. `api_service.dart` — Cliente HTTP con interceptores JWT

> **Equivale a:** `axiosConfig.js` (interceptor de request + interceptor de response para refresh automático)

```dart
// lib/services/api_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiService._internal() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    // ─── Interceptor de Request: añadir token ───
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },

      // ─── Interceptor de Response: renovar token si expira (401) ───
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 &&
            !error.requestOptions.extra.containsKey('_retry')) {
          error.requestOptions.extra['_retry'] = true;

          try {
            final refresh = await _storage.read(key: 'refresh_token');
            if (refresh == null) throw Exception('No refresh token');

            final response = await Dio().post(
              '${ApiConfig.baseUrl}/auth/token/refresh/',
              data: {'refresh': refresh},
            );

            final newAccess = response.data['access'];
            await _storage.write(key: 'access_token', value: newAccess);

            // Reintentar el request original con el nuevo token
            error.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
            final retryResponse = await dio.fetch(error.requestOptions);
            return handler.resolve(retryResponse);
          } catch (_) {
            // Refresh falló → limpiar tokens (el Provider se encargará de redirigir)
            await _storage.deleteAll();
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    ));
  }

  // Acceso directo al storage para los servicios
  FlutterSecureStorage get storage => _storage;
}
```

---

## 4. `auth_service.dart` — Funciones de autenticación

> **Equivale a:** las funciones `login()`, `register()`, `logout()` del `AuthContext.jsx`

```dart
// lib/services/auth_service.dart

import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final _api = ApiService();
  Dio get _dio => _api.dio;

  /// POST /auth/login/ → guarda tokens → GET /auth/profile/
  Future<UserModel> login(String email, String password) async {
    final loginRes = await _dio.post('/auth/login/', data: {
      'email': email,
      'password': password,
    });

    await _api.storage.write(key: 'access_token', value: loginRes.data['access']);
    await _api.storage.write(key: 'refresh_token', value: loginRes.data['refresh']);

    final profileRes = await _dio.get('/auth/profile/');
    return UserModel.fromJson(profileRes.data);
  }

  /// POST /auth/register/ → guarda tokens → retorna user
  Future<UserModel> register({
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String password2,
  }) async {
    final res = await _dio.post('/auth/register/', data: {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'password': password,
      'password2': password2,
    });

    await _api.storage.write(key: 'access_token', value: res.data['tokens']['access']);
    await _api.storage.write(key: 'refresh_token', value: res.data['tokens']['refresh']);

    return UserModel.fromJson(res.data['user']);
  }

  /// POST /auth/logout/ → blacklist refresh token → limpia storage
  Future<void> logout() async {
    try {
      final refresh = await _api.storage.read(key: 'refresh_token');
      if (refresh != null) {
        await _dio.post('/auth/logout/', data: {'refresh': refresh});
      }
    } finally {
      await _api.storage.deleteAll();
    }
  }

  /// GET /auth/profile/ → retorna user actual (para verificar sesión al abrir app)
  Future<UserModel?> getProfile() async {
    try {
      final token = await _api.storage.read(key: 'access_token');
      if (token == null) return null;

      final res = await _dio.get('/auth/profile/');
      return UserModel.fromJson(res.data);
    } catch (_) {
      await _api.storage.deleteAll();
      return null;
    }
  }
}
```

---

## 5. `auth_provider.dart` — Estado global

> **Equivale a:** `AuthContext.jsx` (createContext + Provider + useAuth)

```dart
// lib/providers/auth_provider.dart

import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _loading = true;

  UserModel? get user => _user;
  bool get loading => _loading;
  bool get isAuthenticated => _user != null;

  /// Verificar sesión existente al abrir la app
  Future<void> checkAuth() async {
    _loading = true;
    notifyListeners();

    _user = await _authService.getProfile();

    _loading = false;
    notifyListeners();
  }

  /// Login
  Future<UserModel> login(String email, String password) async {
    final user = await _authService.login(email, password);
    _user = user;
    notifyListeners();
    return user;
  }

  /// Register
  Future<UserModel> register({
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String password2,
  }) async {
    final user = await _authService.register(
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      password: password,
      password2: password2,
    );
    _user = user;
    notifyListeners();
    return user;
  }

  /// Logout
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
```

---

## 6. `login_screen.dart` — Pantalla de Login

> **Equivale a:** `Login.jsx` + `Login.css`
> - Fondo de imagen con overlay oscuro
> - Tarjeta blanca centrada con logo circular flotante
> - Input de email con ícono de correo
> - Input de contraseña con toggle mostrar/ocultar
> - Barra superior fija con logo y botón de ayuda
> - Checkbox "Recordarme" + link "¿Olvidaste tu contraseña?"
> - Links inferiores: Registrarse | Continuar como invitado

```dart
// lib/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _remember = true;
  bool _loading = false;
  String? _error;
  bool _helpOpen = false;

  Future<void> _handleLogin() async {
    setState(() { _error = null; _loading = true; });

    try {
      final authProvider = context.read<AuthProvider>();
      final user = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (user.isAdmin) {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() {
        _error = 'Correo o contraseña incorrectos.';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Fondo con imagen y overlay oscuro ──
          Positioned.fill(
            child: Image.asset('assets/fondo.png', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.18)),
          ),

          // ── Barra superior ──
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Container(
                height: 60,
                color: AppColors.background,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    ClipOval(
                      child: Image.asset('assets/r2.jpg', height: 40, width: 40, fit: BoxFit.cover),
                    ),
                    // Botón ayuda
                    GestureDetector(
                      onTap: () => setState(() => _helpOpen = !_helpOpen),
                      child: Image.asset('assets/ayuda.png', height: 36, width: 36),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Popup de ayuda ──
          if (_helpOpen)
            Positioned(
              top: MediaQuery.of(context).padding.top + 64,
              right: 16,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 260,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('¿Necesitas ayuda?',
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                      const Divider(color: Color(0xFFF0A0A0), thickness: 2),
                      const Text('Escribe tu usuario o correo y contraseña registrados.',
                        style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      const Text('Si olvidaste tus datos, usa la opción de "¿Olvidaste tu contraseña?"',
                        style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),

          // ── Tarjeta de Login centrada ──
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 100,
                left: 24, right: 24, bottom: 24,
              ),
              child: Column(
                children: [
                  // Logo circular flotante (sobresale de la tarjeta)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                    ),
                    child: ClipOval(
                      child: Image.asset('assets/r2.jpg', height: 120, width: 120, fit: BoxFit.cover),
                    ),
                  ),
                  // Separación negativa para solapar con la tarjeta
                  Transform.translate(
                    offset: const Offset(0, -40),
                    child: Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 420),
                      padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 30, offset: const Offset(0, 10))],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Título
                          Text('Inicia sesión',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                          const SizedBox(height: 16),

                          // Error
                          if (_error != null) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Text(_error!, style: TextStyle(color: Colors.red.shade800, fontSize: 14)),
                            ),
                            const SizedBox(height: 12),
                          ],

                          // Campo email
                          _buildLabel('Usuario o Correo', required: true),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset('assets/correo.png', height: 20, width: 20),
                              ),
                              filled: true,
                              fillColor: AppColors.inputBgLight,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Campo contraseña
                          _buildLabel('Contraseña', required: true),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset('assets/contraseña.png', height: 20, width: 20),
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () => setState(() => _showPassword = !_showPassword),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Image.asset(
                                    _showPassword ? 'assets/ocultar.png' : 'assets/mostrar.png',
                                    height: 22, width: 22,
                                  ),
                                ),
                              ),
                              filled: true,
                              fillColor: AppColors.inputBgLight,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Botón Acceder
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                foregroundColor: AppColors.background,
                                disabledBackgroundColor: AppColors.primaryGreen.withOpacity(0.7),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: _loading
                                ? const SizedBox(height: 22, width: 22,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text('Acceder', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Recordarme + Olvidaste contraseña
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 20, width: 20,
                                    child: Checkbox(
                                      value: _remember,
                                      onChanged: (v) => setState(() => _remember = v ?? true),
                                      activeColor: AppColors.primaryGreen,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text('Recordarme', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  // TODO: Navegar a pantalla de recuperación
                                },
                                child: Text('¿Olvidaste tu contraseña?',
                                  style: TextStyle(
                                    color: AppColors.primaryGreen,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Links inferiores
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(context, '/register'),
                                child: Text('Registrarse',
                                  style: TextStyle(
                                    color: AppColors.primaryGreen,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                  )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // TODO: Navegar como invitado
                                  Navigator.pushReplacementNamed(context, '/home');
                                },
                                child: Text('Continuar como invitado',
                                  style: TextStyle(
                                    color: AppColors.primaryGreen,
                                    fontWeight: FontWeight.bold,
                                  )),
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildLabel(String text, {bool required = false}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.primaryGreen),
          children: required
            ? [TextSpan(text: ' *', style: TextStyle(color: AppColors.redAccent, fontWeight: FontWeight.bold))]
            : [],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

---

## 7. `register_screen.dart` — Pantalla de Registro

> **Equivale a:** `Register.jsx` + `Register.css`
> - Barra superior con logo y botón "?"
> - Fondo de imagen
> - Tarjeta con logo flotante circular
> - Grid 2 columnas: Nombre + Apellidos
> - Email, Teléfono
> - Grid 2 columnas: Contraseña + Confirmar contraseña
> - Botón "Registrarse"
> - Link "¿Ya tienes cuenta? Iniciar Sesión"

```dart
// lib/screens/register_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../config/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _password2Ctrl = TextEditingController();

  bool _loading = false;
  String? _error;

  Future<void> _handleRegister() async {
    setState(() => _error = null);

    if (_passwordCtrl.text != _password2Ctrl.text) {
      setState(() => _error = 'Las contraseñas no coinciden');
      return;
    }

    setState(() => _loading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.register(
        email: _emailCtrl.text.trim(),
        firstName: _firstNameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        password: _passwordCtrl.text,
        password2: _password2Ctrl.text,
      );

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() {
        _error = 'Error al registrarse. Verifica los datos.';
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Fondo ──
          Positioned.fill(
            child: Image.asset('assets/fondo.png', fit: BoxFit.cover),
          ),

          // ── Barra superior ──
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Container(
                height: 60,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipOval(
                      child: Image.asset('assets/r2.jpg', height: 40, width: 40, fit: BoxFit.cover),
                    ),
                    Container(
                      width: 35, height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade700, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: const Text('?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Tarjeta centrada ──
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: 80, left: 20, right: 20, bottom: 24,
                ),
                child: Column(
                  children: [
                    // Logo flotante
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                      ),
                      child: ClipOval(
                        child: Image.asset('assets/r2.jpg', height: 90, width: 90, fit: BoxFit.cover),
                      ),
                    ),

                    Transform.translate(
                      offset: const Offset(0, -30),
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 460),
                        padding: const EdgeInsets.fromLTRB(24, 46, 24, 24),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 10))],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Registrarse',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkGreen)),
                            const SizedBox(height: 20),

                            // Error
                            if (_error != null) ...[
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red.shade200),
                                ),
                                child: Text(_error!, style: TextStyle(color: Colors.red.shade800)),
                              ),
                              const SizedBox(height: 12),
                            ],

                            // Fila: Nombre + Apellidos
                            Row(
                              children: [
                                Expanded(child: _buildField('Nombre', _firstNameCtrl)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildField('Apellidos', _lastNameCtrl)),
                              ],
                            ),

                            // Email
                            _buildField('Correo electrónico', _emailCtrl,
                              keyboardType: TextInputType.emailAddress),

                            // Teléfono
                            _buildField('Teléfono', _phoneCtrl,
                              keyboardType: TextInputType.phone),

                            // Fila: Contraseña + Confirmar
                            Row(
                              children: [
                                Expanded(child: _buildField('Contraseña', _passwordCtrl, obscure: true)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildField('Confirmar contraseña', _password2Ctrl, obscure: true)),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Botón
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _handleRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.darkGreen,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: _loading
                                  ? const SizedBox(height: 22, width: 22,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                  : const Text('Registrarse', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Link a Login
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('¿Ya tienes cuenta? ', style: TextStyle(color: AppColors.textGray)),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, '/login'),
                                  child: Text('Iniciar Sesión',
                                    style: TextStyle(
                                      color: AppColors.darkGreen,
                                      fontWeight: FontWeight.w600,
                                    )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl, {
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.darkGreen),
              children: const [
                TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            obscureText: obscure,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.inputBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _password2Ctrl.dispose();
    super.dispose();
  }
}
```

---

## 8. `main.dart` — Punto de entrada

```dart
// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'config/app_colors.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider()..checkAuth(),
      child: const RunnersApp(),
    ),
  );
}

class RunnersApp extends StatelessWidget {
  const RunnersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Runners',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryGreen,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryGreen),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const Scaffold(body: Center(child: Text('Home — TODO'))),
        '/admin': (_) => const Scaffold(body: Center(child: Text('Admin — TODO'))),
      },
    );
  }
}
```

---

## 📋 Mapeo React → Flutter (referencia rápida)

| Concepto React | Equivalente Flutter |
|---|---|
| `useState` | `StatefulWidget` + `setState()` |
| `useEffect` | `initState()` + `dispose()` |
| `useRef` | `GlobalKey` o `FocusNode` |
| `useContext(AuthContext)` | `context.read<AuthProvider>()` / `context.watch<>()` |
| `AuthContext.Provider` | `ChangeNotifierProvider<AuthProvider>` |
| `localStorage` | `FlutterSecureStorage` |
| `axios` + interceptors | `Dio` + `InterceptorsWrapper` |
| `<Link to="/register">` | `Navigator.pushNamed(context, '/register')` |
| `navigate('/home')` | `Navigator.pushReplacementNamed(context, '/home')` |
| CSS `background-image` | `Image.asset()` con `Positioned.fill` en `Stack` |
| CSS `border-radius: 50%` | `ClipOval` |
| CSS `box-shadow` | `BoxShadow` en `BoxDecoration` |
| CSS `@media` responsive | `MediaQuery.of(context).size` / `LayoutBuilder` |
| `import img from '../assets/x.png'` | `Image.asset('assets/x.png')` |

---

## 🔗 Endpoints que usa esta implementación

| Endpoint | Método | Uso |
|---|---|---|
| `/api/v1/auth/login/` | POST | Login (email + password → tokens) |
| `/api/v1/auth/register/` | POST | Registro (6 campos → tokens + user) |
| `/api/v1/auth/logout/` | POST | Logout (blacklist refresh token) |
| `/api/v1/auth/profile/` | GET | Obtener perfil del usuario autenticado |
| `/api/v1/auth/token/refresh/` | POST | Renovar access token con refresh |

---

## ⚡ Notas de adaptación móvil

1. **Imágenes de assets:** Copiar los mismos archivos (`fondo.png`, `r2.jpg`, `ayuda.png`, etc.) a la carpeta `assets/` del proyecto Flutter y registrarlos en `pubspec.yaml`.

2. **Base URL:** En emulador Android usar `10.0.2.2` en vez de `localhost`. En dispositivo físico usar la IP de tu PC en la red WiFi.

3. **Tokens seguros:** Se usa `flutter_secure_storage` en vez de `localStorage` (almacenamiento cifrado nativo iOS/Android).

4. **Responsive:** El diseño ya usa `SingleChildScrollView` + `constraints(maxWidth)` para adaptarse a diferentes tamaños de pantalla móvil.

5. **Fuente Inter:** Para usar la misma fuente, agregar el paquete `google_fonts` o incluir la fuente en `assets/fonts/`.
