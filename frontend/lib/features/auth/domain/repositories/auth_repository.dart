import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> register(Map<String, String> data);
  Future<Either<Failure, UserEntity>> getProfile();
  Future<Either<Failure, UserEntity>> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    String? username,
    String? profileImagePath,
  });
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> requestPasswordResetCode(String email);
  Future<Either<Failure, void>> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
    required String newPassword2,
  });
}
