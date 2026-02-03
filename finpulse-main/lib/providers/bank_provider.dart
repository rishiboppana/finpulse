import 'package:flutter/foundation.dart';

import '../models/bank_account.dart';
import '../services/database_account_service.dart';

/// Bank account provider for reactive state management.
/// Now backed by SQLite via DatabaseAccountService.
class BankProvider extends ChangeNotifier {
  final DatabaseAccountService _dbService = DatabaseAccountService.instance;

  List<BankAccount> _accounts = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _initialized = false;

  BankProvider() {
    _dbService.addListener(_onDbUpdate);
  }

  @override
  void dispose() {
    _dbService.removeListener(_onDbUpdate);
    super.dispose();
  }

  void _onDbUpdate() {
    _accounts = _dbService.accounts;
    notifyListeners();
  }

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
    try {
      return _accounts.firstWhere((a) => a.isPrimary);
    } catch (_) {
      return _accounts.first;
    }
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

  /// Initialize with user ID
  Future<void> initialize(String userId) async {
    if (_initialized) return;
    await loadAccounts();
    _initialized = true;
  }

  /// Reset state (call on logout)
  void reset() {
    _accounts = [];
    _initialized = false;
    _errorMessage = null;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Actions
  // ─────────────────────────────────────────────────────────────────────────────

  /// Load all accounts
  Future<void> loadAccounts() async {
    _setLoading(true);
    _clearError();

    try {
      await _dbService.refresh();
      _accounts = _dbService.accounts;
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
    _setLoading(true);
    _clearError();

    try {
      final account = BankAccount(
        id: 'acc_${DateTime.now().millisecondsSinceEpoch}',
        oderId: 'current_user',
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

      await _dbService.addAccount(account);
      return true;
    } catch (e) {
      _setError('Failed to add account');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update account balance
  Future<void> updateBalance(String id, double newBalance) async {
    await _dbService.updateBalance(id, newBalance);
  }

  /// Update full account details
  Future<bool> updateAccount(BankAccount account) async {
    _setLoading(true);
    try {
      return await _dbService.updateAccount(account);
    } finally {
      _setLoading(false);
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
}
