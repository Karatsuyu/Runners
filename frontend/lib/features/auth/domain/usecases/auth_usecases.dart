import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);
  Future<Either<Failure, UserEntity>> call(String email, String password) =>
      _repository.login(email, password);
}

class RegisterUseCase {
  final AuthRepository _repository;
  RegisterUseCase(this._repository);
  Future<Either<Failure, UserEntity>> call(Map<String, String> data) =>
      _repository.register(data);
}

class LogoutUseCase {
  final AuthRepository _repository;
  LogoutUseCase(this._repository);
  Future<Either<Failure, void>> call() => _repository.logout();
}

class GetProfileUseCase {
  final AuthRepository _repository;
  GetProfileUseCase(this._repository);
  Future<Either<Failure, UserEntity>> call() => _repository.getProfile();
}

class UpdateProfileUseCase {
  final AuthRepository _repository;
  UpdateProfileUseCase(this._repository);
  Future<Either<Failure, UserEntity>> call({
    required String firstName,
    required String lastName,
    String? phone,
    String? username,
    String? profileImagePath,
  }) => _repository.updateProfile(
    firstName: firstName,
    lastName: lastName,
    phone: phone,
    username: username,
    profileImagePath: profileImagePath,
  );
}

class RequestPasswordResetCodeUseCase {
  final AuthRepository _repository;
  RequestPasswordResetCodeUseCase(this._repository);
  Future<Either<Failure, void>> call(String email) =>
      _repository.requestPasswordResetCode(email);
}

class ConfirmPasswordResetUseCase {
  final AuthRepository _repository;
  ConfirmPasswordResetUseCase(this._repository);
  Future<Either<Failure, void>> call({
    required String email,
    required String code,
    required String newPassword,
    required String newPassword2,
  }) => _repository.confirmPasswordReset(
    email: email,
    code: code,
    newPassword: newPassword,
    newPassword2: newPassword2,
  );
}
