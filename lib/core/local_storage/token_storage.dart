import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class TokenSecureStorage {
  // access token
  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();
  Future<void> removeAccessToken();
  // refresh token
  Future<void> saveRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
  Future<void> removeRefreshToken();
  // token expiration
  Future<void> saveTokenExpirationTime(DateTime time);
  Future<DateTime?> getTokenExpirationTime();
  Future<void> removeExpirationTime();
}

class TokenStorage implements TokenSecureStorage {
  final FlutterSecureStorage _secureStorage;

  TokenStorage(this._secureStorage);

  // Store access token
  @override
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: 'access_token', value: token);
  }

  // Retrieve access token
  @override
  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: 'access_token');
    } catch (e) {
      log("Error reading auth token: $e");
      return null;
    }
  }

  // Remove access token
  @override
  Future<void> removeAccessToken() async {
    await _secureStorage.delete(key: 'access_token');
  }

  // Store refresh token
  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: 'refresh_token');
    } catch (e) {
      log("Error reading refresh token: $e");
      return null;
    }
  }

  // Remove refresh token
  @override
  Future<void> removeRefreshToken() async {
    await _secureStorage.delete(key: 'refresh_token');
  }

  @override
  Future<void> saveTokenExpirationTime(DateTime time) async {
    await _secureStorage.write(
      key: 'token_expiration_time',
      value: time.toLocal().toIso8601String(),
    );
    log("Expiration time stored successfully: $time");
  }

  @override
  Future<DateTime?> getTokenExpirationTime() async {
    try {
      final response = await _secureStorage.read(key: 'token_expiration_time');
      if (response != null) {
        return DateTime.parse(response);
      }
    } catch (e) {
      log("Error reading expiration time: $e");
    }
    return null;
  }

  @override
  Future<void> removeExpirationTime() async {
    await _secureStorage.delete(key: 'token_expiration_time');
  }
}
