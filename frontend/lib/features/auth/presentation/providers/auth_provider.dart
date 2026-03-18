import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth_usecases.dart';

// ─── Providers de infraestructura ─────────────────────────────────────────
final secureStorageProvider =
    Provider<SecureStorageService>((_) => SecureStorageService());

final dioClientProvider = Provider<DioClient>((ref) {
  final storage = ref.read(secureStorageProvider);
  return DioClient(storage);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(dioClientProvider).dio;
  final storage = ref.read(secureStorageProvider);
  final dataSource = AuthRemoteDataSourceImpl(dio);
  return AuthRepositoryImpl(dataSource, storage);
});

// ─── Use Cases ─────────────────────────────────────────────────────────────
final loginUseCaseProvider = Provider<LoginUseCase>(
    (ref) => LoginUseCase(ref.read(authRepositoryProvider)));

final registerUseCaseProvider = Provider<RegisterUseCase>(
    (ref) => RegisterUseCase(ref.read(authRepositoryProvider)));

final logoutUseCaseProvider = Provider<LogoutUseCase>(
    (ref) => LogoutUseCase(ref.read(authRepositoryProvider)));

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>(
  (ref) => UpdateProfileUseCase(ref.read(authRepositoryProvider)));

// ─── Estado de autenticación ──────────────────────────────────────────────
class AuthState {
  final UserEntity? user;
  final bool isGuest;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isGuest = false,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserEntity? user,
    bool removeUser = false,
    bool? isGuest,
    bool? isLoading,
    String? error,
  }) =>
      AuthState(
        user: removeUser ? null : (user ?? this.user),
        isGuest: isGuest ?? this.isGuest,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );

  AuthState clearUser() => AuthState(isLoading: false);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final AuthRepository _authRepository;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _registerUseCase = registerUseCase,
        _logoutUseCase = logoutUseCase,
        _updateProfileUseCase = updateProfileUseCase,
        _authRepository = authRepository,
        super(const AuthState());

  Future<bool> checkAuthStatus() async {
    final result = await _authRepository.getProfile();
    return result.fold(
      (_) => false,
      (user) {
        state = state.copyWith(user: user, isGuest: false);
        return true;
      },
    );
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _loginUseCase(email, password);
      return result.fold(
        (failure) {
          state = state.copyWith(isLoading: false, error: failure.message);
          return false;
        },
        (user) {
          state = state.copyWith(isLoading: false, user: user, isGuest: false);
          return true;
        },
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'No fue posible iniciar sesión. Intenta nuevamente.',
      );
      return false;
    }
  }

  Future<bool> register(Map<String, String> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _registerUseCase(data);
      return result.fold(
        (failure) {
          state = state.copyWith(isLoading: false, error: failure.message);
          return false;
        },
        (user) {
          state = state.copyWith(isLoading: false, user: user, isGuest: false);
          return true;
        },
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'No fue posible crear la cuenta. Intenta nuevamente.',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _logoutUseCase();
    state = const AuthState();
  }

  void continueAsGuest() {
    state = const AuthState(isGuest: true, isLoading: false, error: null);
  }

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final payload = <String, String>{
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone?.trim() ?? '',
    };

    final result = await _updateProfileUseCase(payload);
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user, error: null);
        return true;
      },
    );
  }
}

final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.read(loginUseCaseProvider),
    registerUseCase: ref.read(registerUseCaseProvider),
    logoutUseCase: ref.read(logoutUseCaseProvider),
    updateProfileUseCase: ref.read(updateProfileUseCaseProvider),
    authRepository: ref.read(authRepositoryProvider),
  );
});
