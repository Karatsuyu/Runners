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
