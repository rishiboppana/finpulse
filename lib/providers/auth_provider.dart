import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../services/storage_service.dart';

/// Authentication state for the app
enum AuthStatus {
  initial,      // App just started, checking stored session
  authenticated, // User is logged in
  unauthenticated, // No user logged in
}

/// Auth provider using ChangeNotifier for reactive state management.
/// Designed to match Firebase Auth patterns for easy migration.
class AuthProvider extends ChangeNotifier {
  final MockAuthService _authService;
  late final MockUserService _userService;
  
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;

  StreamSubscription<User?>? _authSubscription;

  AuthProvider({MockAuthService? authService, StorageService? storage})
      : _authService = authService ?? MockAuthService(storage: storage) {
    _userService = MockUserService(authService: _authService, storage: storage);
    _init();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────────────────────────

  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  // ─────────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────────

  Future<void> _init() async {
    // Listen to auth state changes
    _authSubscription = _authService.authStateChanges.listen((user) {
      _user = user;
      _status = user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
      notifyListeners();
    });

    // Check for existing session
    await _authService.initFromStorage();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Auth Actions
  // ─────────────────────────────────────────────────────────────────────────────

  /// Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.signUp(
      email: email,
      password: password,
      name: name,
    );

    _setLoading(false);

    if (!result.success) {
      _setError(result.errorMessage ?? 'Sign up failed');
      return false;
    }

    return true;
  }

  /// Sign in with email and password
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    final result = await _authService.signIn(
      email: email,
      password: password,
    );

    _setLoading(false);

    if (!result.success) {
      _setError(result.errorMessage ?? 'Sign in failed');
      return false;
    }

    return true;
  }

  /// Sign out
  Future<void> signOut() async {
    _setLoading(true);
    await _authService.signOut();
    _user = null;
    _status = AuthStatus.unauthenticated;
    _setLoading(false);
  }

  /// Request password reset
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to send reset email');
      _setLoading(false);
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Profile Actions
  // ─────────────────────────────────────────────────────────────────────────────

  /// Update user profile
  Future<bool> updateProfile({String? name, String? avatarUrl}) async {
    _setLoading(true);
    _clearError();

    try {
      final updatedUser = await _userService.updateProfile(
        name: name,
        avatarUrl: avatarUrl,
      );
      _user = updatedUser;
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update profile');
      _setLoading(false);
      return false;
    }
  }

  /// Delete user account
  Future<bool> deleteAccount() async {
    _setLoading(true);
    _clearError();

    try {
      await _userService.deleteAccount();
      _user = null;
      _status = AuthStatus.unauthenticated;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to delete account');
      _setLoading(false);
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────────

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  /// Clear any displayed error message
  void clearError() {
    _clearError();
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _authService.dispose();
    super.dispose();
  }
}
