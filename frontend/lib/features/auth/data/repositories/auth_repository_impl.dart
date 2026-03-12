import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _storage;

  AuthRepositoryImpl(this._remoteDataSource, this._storage);

  @override
  Future<Either<Failure, UserEntity>> login(
      String email, String password) async {
    try {
      final data = await _remoteDataSource.login(email, password);
      await _storage.saveTokens(
        accessToken: data['access'] as String,
        refreshToken: data['refresh'] as String,
      );
      final profile = await _remoteDataSource.getProfile();
      return Right(profile.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.firstError));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
      Map<String, String> data) async {
    try {
      final response = await _remoteDataSource.register(data);
      // El backend puede retornar tokens directamente o dentro de 'tokens'
      final tokens = response['tokens'] as Map<String, dynamic>? ?? response;
      await _storage.saveTokens(
        accessToken: tokens['access'] as String,
        refreshToken: tokens['refresh'] as String,
      );
      final profile = await _remoteDataSource.getProfile();
      return Right(profile.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.firstError));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final user = await _remoteDataSource.getProfile();
      return Right(user.toEntity());
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null) {
        await _remoteDataSource.logout(refreshToken);
      }
      await _storage.clearAll();
      return const Right(null);
    } catch (_) {
      await _storage.clearAll();
      return const Right(null);
    }
  }
}
