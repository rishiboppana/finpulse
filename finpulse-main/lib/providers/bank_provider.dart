import 'package:flutter/foundation.dart';

import '../models/bank_account.dart';
import '../services/bank_service.dart';
import '../services/storage_service.dart';

/// Bank account provider for reactive state management.
class BankProvider extends ChangeNotifier {
  MockBankService? _bankService;
  final StorageService _storage;

  List<BankAccount> _accounts = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _initialized = false;

  BankProvider({StorageService? storage})
      : _storage = storage ?? StorageService();

  // ─────────────────────────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────────────────────────

  List<BankAccount> get accounts => _accounts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasAccounts => _accounts.isNotEmpty;

  /// Get primary account (or first account if none marked primary)
  BankAccount? get primaryAccount {
    if (_accounts.isEmpty) return null;
    return _accounts.firstWhere(
      (a) => a.isPrimary,
      orElse: () => _accounts.first,
    );
  }

  /// Get total balance across all active accounts
  double get totalBalance =>
      _accounts.where((a) => a.isActive).fold(0.0, (sum, a) => sum + a.balance);

  /// Format total balance with INR
  String get formattedTotalBalance {
    final parts = totalBalance.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    // Indian number formatting
    String formatted = '';
    int count = 0;
    for (int i = intPart.length - 1; i >= 0; i--) {
      if (count == 3 || (count > 3 && (count - 3) % 2 == 0)) {
        formatted = ',$formatted';
      }
      formatted = intPart[i] + formatted;
      count++;
    }

    return '₹$formatted.$decPart';
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────────

  /// Initialize with user ID (call after login)
  Future<void> initialize(String oderId) async {
    if (_initialized && _bankService != null) return;

    _bankService = MockBankService(oderId: oderId, storage: _storage);
    await loadAccounts();
    _initialized = true;
  }

  /// Reset state (call on logout)
  void reset() {
    _accounts = [];
    _bankService = null;
    _initialized = false;
    _errorMessage = null;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Actions
  // ─────────────────────────────────────────────────────────────────────────────

  /// Load all accounts
  Future<void> loadAccounts() async {
    if (_bankService == null) return;

    _setLoading(true);
    _clearError();

    try {
      _accounts = await _bankService!.getAccounts();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load accounts');
    } finally {
      _setLoading(false);
    }
  }

  /// Add a new bank account
  Future<bool> addAccount({
    required String institutionId,
    required String institutionName,
    required String accountName,
    required AccountType accountType,
    required String maskedNumber,
    required double balance,
    String? ifscCode,
    String? upiId,
  }) async {
    if (_bankService == null) return false;

    _setLoading(true);
    _clearError();

    try {
      final account = BankAccount(
        id: '', // Will be generated
        oderId: '', // Will be set by service
        institutionId: institutionId,
        institutionName: institutionName,
        accountName: accountName,
        accountType: accountType,
        maskedNumber: maskedNumber,
        balance: balance,
        linkedAt: DateTime.now(),
        ifscCode: ifscCode,
        upiId: upiId,
      );

      final newAccount = await _bankService!.addAccount(account);
      _accounts.add(newAccount);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to add account');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update an existing account
  Future<bool> updateAccount(BankAccount account) async {
    if (_bankService == null) return false;

    _setLoading(true);
    _clearError();

    try {
      final updated = await _bankService!.updateAccount(account);
      final index = _accounts.indexWhere((a) => a.id == account.id);
      if (index != -1) {
        _accounts[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Failed to update account');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Remove an account
  Future<bool> removeAccount(String accountId) async {
    if (_bankService == null) return false;

    _setLoading(true);
    _clearError();

    try {
      await _bankService!.removeAccount(accountId);
      _accounts.removeWhere((a) => a.id == accountId);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to remove account');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Sync account balance
  Future<bool> syncAccount(String accountId) async {
    if (_bankService == null) return false;

    try {
      final updated = await _bankService!.syncAccount(accountId);
      final index = _accounts.indexWhere((a) => a.id == accountId);
      if (index != -1) {
        _accounts[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Set primary account
  Future<bool> setPrimaryAccount(String accountId) async {
    if (_bankService == null) return false;

    try {
      await _bankService!.setPrimaryAccount(accountId);
      for (int i = 0; i < _accounts.length; i++) {
        _accounts[i] = _accounts[i].copyWith(
          isPrimary: _accounts[i].id == accountId,
        );
      }
      notifyListeners();
      return true;
    } catch (e) {
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

  void clearError() {
    _clearError();
    notifyListeners();
  }
}
