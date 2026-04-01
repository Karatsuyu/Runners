import 'dart:async';

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
    } catch (_) {
      // Ignored intentionally; session cleanup is best-effort.
    }
  }

  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
