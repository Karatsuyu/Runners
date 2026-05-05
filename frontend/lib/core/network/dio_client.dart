import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';

class DioClient {
  late final Dio _dio;
  final SecureStorageService _storage;

  DioClient(this._storage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    // Debug: show which baseUrl the app is using at startup
    // (quitar o comentar en producción)
    try {
      // ignore: avoid_print
      print('DioClient: using baseUrl=${ApiConstants.baseUrl}');
    } catch (_) {}
    _addInterceptors();
  }

  void _addInterceptors() {
    // Interceptor de autenticación y renovación de token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          // Debug: print outgoing request URL
          try {
            // ignore: avoid_print
            print('DioClient: request ${options.method} ${options.baseUrl}${options.path}');
          } catch (_) {}
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401 &&
              !error.requestOptions.extra.containsKey('_retry')) {
            error.requestOptions.extra['_retry'] = true;
            final refreshed = await _refreshToken();
            if (refreshed) {
              final token = await _storage.getAccessToken();
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            } else {
              await _storage.clearSession();
            }
          }
          return handler.next(error);
        },
      ),
    );
    // Add simple log interceptor to show responses for debugging
    _dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: false, requestHeader: false, responseHeader: false));
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await Dio().post(
        '${ApiConstants.baseUrl}${ApiConstants.tokenRefresh}',
        data: {'refresh': refreshToken},
      );

      final newAccessToken = response.data['access'] as String;
      final newRefreshToken =
          response.data['refresh'] as String? ?? refreshToken;
      await _storage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Dio get dio => _dio;
}
