import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
// platform imports removed to keep original behavior

class DioClient {
  late final Dio _dio;
  final SecureStorageService _storage;
  late final List<String> _baseCandidates;

  DioClient(this._storage) {
    // Build candidate base URLs (order matters: prefer configured base)
    final deviceOverride = dotenv.env['API_BASE_URL_DEVICE'] ?? dotenv.env['API_BASE_URL_MOBILE'];
    // Keep order deterministic: prefer configured baseUrl, then device override,
    // then common local fallbacks. Use a List (not a Set) so order is preserved.
    final candidates = <String>[
      ApiConstants.baseUrl,
      if (deviceOverride != null && deviceOverride.isNotEmpty) deviceOverride,
      'http://10.0.2.2:8000/api/v1',
      'http://127.0.0.1:8000/api/v1',
      'http://localhost:8000/api/v1',
    ];

    // Normalize candidates for the current platform. On Android emulators
    // replace localhost/127.0.0.1 with 10.0.2.2 and prefer the emulator host first.
    List<String> normalized = List.from(candidates);
    try {
      if (!kIsWeb && Platform.isAndroid) {
        normalized = candidates.map((c) {
          var n = c;
          if (n.contains('localhost')) n = n.replaceAll('localhost', '10.0.2.2');
          if (n.contains('127.0.0.1')) n = n.replaceAll('127.0.0.1', '10.0.2.2');
          return n;
        }).toList();
        // ensure emulator host is first
        normalized.removeWhere((c) => c.contains('10.0.2.2'));
        normalized.insert(0, 'http://10.0.2.2:8000/api/v1');
      }
    } catch (_) {
      normalized = List.from(candidates);
    }

    _baseCandidates = normalized;

    _dio = Dio(
      BaseOptions(
        baseUrl: _baseCandidates.first,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Debug: show which baseUrl the app is using at startup
    try {
      // ignore: avoid_print
      print('DioClient: using baseUrl=${_dio.options.baseUrl}');
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
          // If it's a connectivity/network error, try alternate base URLs
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.unknown ||
              error.type == DioExceptionType.connectionError) {
            await _attemptRetryWithAlternateBase(error, handler);
            return;
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

  Future<void> _attemptRetryWithAlternateBase(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final tried = (error.requestOptions.extra['_triedBases'] as List?) ?? <String>[];
      final remaining = _baseCandidates.where((b) => !tried.contains(b)).toList();
      if (remaining.isEmpty) {
        // nothing left to try
        return handler.next(error);
      }

      final nextBase = remaining.first;
      tried.add(nextBase);
      error.requestOptions.extra['_triedBases'] = tried;

      // switch base and retry
      _dio.options.baseUrl = nextBase;
      // ignore: avoid_print
      print('DioClient: retrying with baseUrl=$nextBase');

      final response = await _dio.fetch(error.requestOptions);
      return handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        // recursive attempt with next candidate
        await _attemptRetryWithAlternateBase(e, handler);
        return;
      }
      return handler.next(error);
    }
  }
}
