import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_token.dart';
import '../models/user.dart';

/// Secure storage service for authentication data.
/// Abstraction layer for easy migration to Firebase/GCP.
class StorageService {
  static const _tokenKey = 'auth_token';
  static const _userKey = 'current_user';

  final FlutterSecureStorage _secureStorage;
  SharedPreferences? _prefs;

  StorageService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  /// Initialize shared preferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Auth Token (Secure Storage)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Save auth token securely
  Future<void> saveToken(AuthToken token) async {
    await _secureStorage.write(
      key: _tokenKey,
      value: jsonEncode(token.toJson()),
    );
  }

  /// Get stored auth token
  Future<AuthToken?> getToken() async {
    final data = await _secureStorage.read(key: _tokenKey);
    if (data == null) return null;
    try {
      return AuthToken.fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (e) {
      // Corrupted token data, clear it
      await deleteToken();
      return null;
    }
  }

  /// Delete auth token
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // User Data (SharedPreferences for non-sensitive profile data)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Save current user profile
  Future<void> saveUser(User user) async {
    await init();
    await _prefs!.setString(_userKey, jsonEncode(user.toJson()));
  }

  /// Get stored user profile
  Future<User?> getUser() async {
    await init();
    final data = _prefs!.getString(_userKey);
    if (data == null) return null;
    try {
      return User.fromJson(jsonDecode(data) as Map<String, dynamic>);
    } catch (e) {
      await deleteUser();
      return null;
    }
  }

  /// Delete user profile
  Future<void> deleteUser() async {
    await init();
    await _prefs!.remove(_userKey);
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Clear All (for logout)
  // ─────────────────────────────────────────────────────────────────────────────

  /// Clear all stored auth data
  Future<void> clearAll() async {
    await deleteToken();
    await deleteUser();
  }
}
