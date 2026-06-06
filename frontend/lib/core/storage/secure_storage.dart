import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/storage_keys.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;
  static const Duration _ioTimeout = Duration(seconds: 5);

  SecureStorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
          iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
        );

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    // Sequential writes avoid sporadic lockups observed in some web runtimes.
    await _storage
        .write(key: StorageKeys.accessToken, value: accessToken)
        .timeout(_ioTimeout);
    await _storage
        .write(key: StorageKeys.refreshToken, value: refreshToken)
        .timeout(_ioTimeout);
  }

  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: StorageKeys.accessToken).timeout(_ioTimeout);
    } catch (_) {
      return null;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: StorageKeys.refreshToken).timeout(_ioTimeout);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveRememberedCredentials({
    required String email,
    required String password,
  }) async {
    await _storage
        .write(key: StorageKeys.rememberMe, value: 'true')
        .timeout(_ioTimeout);
    await _storage
        .write(key: StorageKeys.rememberedEmail, value: email)
        .timeout(_ioTimeout);
    await _storage
        .write(key: StorageKeys.rememberedPassword, value: password)
        .timeout(_ioTimeout);
  }

  Future<void> clearRememberedCredentials() async {
    await _storage.delete(key: StorageKeys.rememberMe).timeout(_ioTimeout);
    await _storage
        .delete(key: StorageKeys.rememberedEmail)
        .timeout(_ioTimeout);
    await _storage
        .delete(key: StorageKeys.rememberedPassword)
        .timeout(_ioTimeout);
  }

  Future<bool> isRememberMeEnabled() async {
    try {
      final value = await _storage.read(key: StorageKeys.rememberMe).timeout(_ioTimeout);
      return value == 'true';
    } catch (_) {
      return false;
    }
  }

  Future<String?> getRememberedEmail() async {
    try {
      return await _storage
          .read(key: StorageKeys.rememberedEmail)
          .timeout(_ioTimeout);
    } catch (_) {
      return null;
    }
  }

  Future<String?> getRememberedPassword() async {
    try {
      return await _storage
          .read(key: StorageKeys.rememberedPassword)
          .timeout(_ioTimeout);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearAll() async {
    try {
      await _storage.deleteAll().timeout(_ioTimeout);
    } catch (_) {
      // Ignored intentionally; clearing tokens is best-effort.
    }
  }

  Future<void> clearSession() async {
    try {
      await _storage.delete(key: StorageKeys.accessToken).timeout(_ioTimeout);
      await _storage.delete(key: StorageKeys.refreshToken).timeout(_ioTimeout);
      await _storage.delete(key: StorageKeys.userRole).timeout(_ioTimeout);
      await _storage.delete(key: StorageKeys.userId).timeout(_ioTimeout);
      await _storage.delete(key: StorageKeys.userEmail).timeout(_ioTimeout);
    } catch (_) {
      // Ignored intentionally; session cleanup is best-effort.
    }
  }

  Future<bool> hasValidSession() async {
    try {
      final token = await getAccessToken();
      if (token == null || token.isEmpty) return false;
      // Consider token valid only if it's not expired (check `exp` claim)
      final isExpired = _isTokenExpired(token);
      return !isExpired;
    } catch (_) {
      return false;
    }
  }

  bool _isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      var payload = parts[1];
      // Base64url decode with padding fix
      var normalized = payload.replaceAll('-', '+').replaceAll('_', '/');
      switch (normalized.length % 4) {
        case 2:
          normalized += '==';
          break;
        case 3:
          normalized += '=';
          break;
        case 0:
          break;
        default:
          normalized += '==';
      }
      final decoded = utf8.decode(base64.decode(normalized));
      final Map<String, dynamic> map = json.decode(decoded) as Map<String, dynamic>;
      final exp = map['exp'];
      if (exp == null) return true;
      final expInt = exp is int ? exp : int.parse(exp.toString());
      final expiry = DateTime.fromMillisecondsSinceEpoch(expInt * 1000);
      return DateTime.now().isAfter(expiry);
    } catch (_) {
      return true;
    }
  }

  // Cached user profile helpers (minimal)
  Future<void> saveCachedUser({required int id, required String role, required String email}) async {
    try {
      await _storage.write(key: StorageKeys.userId, value: id.toString()).timeout(_ioTimeout);
      await _storage.write(key: StorageKeys.userRole, value: role).timeout(_ioTimeout);
      await _storage.write(key: StorageKeys.userEmail, value: email).timeout(_ioTimeout);
    } catch (_) {
      // ignore
    }
  }

  Future<int?> getCachedUserId() async {
    try {
      final v = await _storage.read(key: StorageKeys.userId).timeout(_ioTimeout);
      if (v == null) return null;
      return int.tryParse(v);
    } catch (_) {
      return null;
    }
  }

  Future<String?> getCachedUserRole() async {
    try {
      return await _storage.read(key: StorageKeys.userRole).timeout(_ioTimeout);
    } catch (_) {
      return null;
    }
  }

  Future<String?> getCachedUserEmail() async {
    try {
      return await _storage.read(key: StorageKeys.userEmail).timeout(_ioTimeout);
    } catch (_) {
      return null;
    }
  }
}
