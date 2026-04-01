import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(Map<String, String> data);
  Future<UserModel> getProfile();
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    String? username,
    String? profileImagePath,
  });
  Future<void> logout(String refreshToken);
  Future<void> requestPasswordResetCode(String email);
  Future<void> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
    required String newPassword2,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e, isAuthRequest: true);
    }
  }

  @override
  Future<Map<String, dynamic>> register(Map<String, String> data) async {
    try {
      final response = await _dio.post(ApiConstants.register, data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleError(e, isAuthRequest: true);
    }
  }

  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await _dio.get(ApiConstants.profile);
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String firstName,
    required String lastName,
    String? phone,
    String? username,
    String? profileImagePath,
  }) async {
    try {
      final payload = <String, dynamic>{
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone?.trim() ?? '',
        'username': username?.trim() ?? '',
      };

      if (profileImagePath != null && profileImagePath.trim().isNotEmpty) {
        final normalized = profileImagePath.replaceAll('\\', '/');
        final fileName = normalized.split('/').last;
        payload['profile_image'] = await MultipartFile.fromFile(
          profileImagePath,
          filename: fileName,
        );
      }

      final response = await _dio.patch(
        ApiConstants.profile,
        data: FormData.fromMap(payload),
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post(ApiConstants.logout, data: {'refresh': refreshToken});
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  @override
  Future<void> requestPasswordResetCode(String email) async {
    try {
      await _dio.post(
        ApiConstants.passwordResetRequest,
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw _handleError(e, isAuthRequest: true);
    }
  }

  @override
  Future<void> confirmPasswordReset({
    required String email,
    required String code,
    required String newPassword,
    required String newPassword2,
  }) async {
    try {
      await _dio.post(
        ApiConstants.passwordResetConfirm,
        data: {
          'email': email,
          'code': code,
          'new_password': newPassword,
          'new_password2': newPassword2,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e, isAuthRequest: true);
    }
  }

  Exception _handleError(DioException e, {bool isAuthRequest = false}) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.unknown ||
        e.type == DioExceptionType.connectionError) {
      return NetworkException();
    }
    if (e.response?.statusCode == 401) {
      if (isAuthRequest) {
        return ServerException(
          message:
              _extractMessage(e.response?.data) ??
              'Credenciales inválidas. Verifica tus datos.',
          statusCode: e.response?.statusCode,
        );
      }
      return UnauthorizedException();
    }
    if (e.response?.statusCode == 400) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        return ValidationException(errors: data);
      }
    }
    return ServerException(
      message: _extractMessage(e.response?.data) ?? 'Error del servidor',
      statusCode: e.response?.statusCode,
    );
  }

  String? _extractMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map)
      return data['detail']?.toString() ?? data['message']?.toString();
    return data.toString();
  }
}
