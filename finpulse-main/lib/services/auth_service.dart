import 'dart:async';
import 'dart:convert';
import 'dart:math';

import '../models/auth_token.dart';
import '../models/user.dart';
import 'storage_service.dart';

/// Authentication result wrapper
class AuthResult {
  final bool success;
  final User? user;
  final AuthToken? token;
  final String? errorMessage;

  const AuthResult({
    required this.success,
    this.user,
    this.token,
    this.errorMessage,
  });

  factory AuthResult.success(User user, AuthToken token) =>
      AuthResult(success: true, user: user, token: token);

  factory AuthResult.failure(String message) =>
      AuthResult(success: false, errorMessage: message);
}

/// Authentication service for FinPulse.
/// 
/// Current: Mock backend that simulates API calls locally.
/// Future: Replace with Firebase Auth or GCP Identity Platform.
/// 
/// The interface is designed to match Firebase Auth patterns:
/// - signUp, signIn, signOut
/// - getCurrentUser, authStateChanges stream
abstract class AuthServiceBase {
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String name,
  });

  Future<AuthResult> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();
  
  Future<User?> getCurrentUser();
  
  Future<bool> isAuthenticated();
  
  Future<void> resetPassword(String email);
  
  Stream<User?> get authStateChanges;
}

/// Mock implementation for local development.
/// Simulates network latency and stores data locally.
class MockAuthService implements AuthServiceBase {
  final StorageService _storage;
  final _authStateController = StreamController<User?>.broadcast();

  // Mock user database (in-memory, persisted via storage)
  final Map<String, _MockUserRecord> _users = {};

  MockAuthService({StorageService? storage})
      : _storage = storage ?? StorageService();

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;

  @override
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Validation
    if (email.isEmpty || !email.contains('@')) {
      return AuthResult.failure('Please enter a valid email address');
    }
    if (password.length < 6) {
      return AuthResult.failure('Password must be at least 6 characters');
    }
    if (name.trim().isEmpty) {
      return AuthResult.failure('Please enter your name');
    }

    // Check if user exists
    final normalizedEmail = email.toLowerCase().trim();
    if (_users.containsKey(normalizedEmail)) {
      return AuthResult.failure('An account with this email already exists');
    }

    // Create user
    final now = DateTime.now();
    final userId = _generateId();
    final user = User(
      id: userId,
      email: normalizedEmail,
      name: name.trim(),
      createdAt: now,
      lastLoginAt: now,
    );

    // Create token (expires in 7 days)
    final token = AuthToken(
      accessToken: _generateToken(),
      refreshToken: _generateToken(),
      expiresAt: now.add(const Duration(days: 7)),
    );

    // Store in mock database
    _users[normalizedEmail] = _MockUserRecord(
      user: user,
      passwordHash: _hashPassword(password),
    );

    // Persist session
    await _storage.saveToken(token);
    await _storage.saveUser(user);

    // Notify listeners
    _authStateController.add(user);

    return AuthResult.success(user, token);
  }

  @override
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    final normalizedEmail = email.toLowerCase().trim();

    // Check if user exists
    final record = _users[normalizedEmail];
    if (record == null) {
      return AuthResult.failure('No account found with this email');
    }

    // Verify password
    if (record.passwordHash != _hashPassword(password)) {
      return AuthResult.failure('Incorrect password');
    }

    // Update last login
    final now = DateTime.now();
    final updatedUser = record.user.copyWith(lastLoginAt: now);

    // Create new token
    final token = AuthToken(
      accessToken: _generateToken(),
      refreshToken: _generateToken(),
      expiresAt: now.add(const Duration(days: 7)),
    );

    // Update mock database
    _users[normalizedEmail] = _MockUserRecord(
      user: updatedUser,
      passwordHash: record.passwordHash,
    );

    // Persist session
    await _storage.saveToken(token);
    await _storage.saveUser(updatedUser);

    // Notify listeners
    _authStateController.add(updatedUser);

    return AuthResult.success(updatedUser, token);
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
    await _storage.clearAll();
    _authStateController.add(null);
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await _storage.getToken();
    if (token == null || !token.isValid) {
      return null;
    }
    return _storage.getUser();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _storage.getToken();
    return token != null && token.isValid;
  }

  @override
  Future<void> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // In production, this would send a reset email via Firebase/GCP
    // For mock, we just simulate success
  }

  /// Initialize from stored session (call on app start)
  Future<void> initFromStorage() async {
    final user = await getCurrentUser();
    if (user != null) {
      // Restore user to mock database if not present
      _users.putIfAbsent(
        user.email,
        () => _MockUserRecord(user: user, passwordHash: ''),
      );
    }
    _authStateController.add(user);
  }

  /// Update user profile (used by UserService)
  Future<User> updateUser(User updatedUser) async {
    final record = _users[updatedUser.email];
    if (record != null) {
      _users[updatedUser.email] = _MockUserRecord(
        user: updatedUser,
        passwordHash: record.passwordHash,
      );
    }
    await _storage.saveUser(updatedUser);
    _authStateController.add(updatedUser);
    return updatedUser;
  }

  void dispose() {
    _authStateController.close();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────────

  String _generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(20, (_) => chars[random.nextInt(chars.length)]).join();
  }

  String _generateToken() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(64, (_) => chars[random.nextInt(chars.length)]).join();
  }

  String _hashPassword(String password) {
    // Simple hash for mock (production would use bcrypt/argon2 on server)
    return base64Encode(utf8.encode('finpulse_$password'));
  }
}

class _MockUserRecord {
  final User user;
  final String passwordHash;

  const _MockUserRecord({required this.user, required this.passwordHash});
}

/// Factory to get the appropriate auth service
/// In production, this would return FirebaseAuthService or GCPAuthService
AuthServiceBase createAuthService({StorageService? storage}) {
  return MockAuthService(storage: storage);
}
