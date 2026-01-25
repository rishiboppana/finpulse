import 'dart:convert';
import 'dart:math';

import '../models/bank_account.dart';
import 'storage_service.dart';

/// Bank account service for managing linked accounts.
/// Mock implementation for local development.
/// Future: Integrate with Account Aggregator (AA) framework or bank APIs.
abstract class BankServiceBase {
  Future<List<BankAccount>> getAccounts();
  Future<BankAccount> addAccount(BankAccount account);
  Future<BankAccount> updateAccount(BankAccount account);
  Future<void> removeAccount(String accountId);
  Future<BankAccount> syncAccount(String accountId);
  Future<double> getTotalBalance();
}

class MockBankService implements BankServiceBase {
  static const _storageKey = 'linked_bank_accounts';
  final StorageService _storage;
  final String _userId;

  // In-memory cache
  List<BankAccount>? _cachedAccounts;

  MockBankService({
    required String oderId,
    StorageService? storage,
  })  : _userId = oderId,
        _storage = storage ?? StorageService();

  @override
  Future<List<BankAccount>> getAccounts() async {
    if (_cachedAccounts != null) return _cachedAccounts!;

    await _storage.init();
    final prefs = await _storage.getPrefs();
    final data = prefs.getString('${_storageKey}_$_userId');

    if (data == null) {
      _cachedAccounts = [];
      return [];
    }

    try {
      final list = jsonDecode(data) as List;
      _cachedAccounts = list
          .map((e) => BankAccount.fromJson(e as Map<String, dynamic>))
          .toList();
      return _cachedAccounts!;
    } catch (e) {
      _cachedAccounts = [];
      return [];
    }
  }

  @override
  Future<BankAccount> addAccount(BankAccount account) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    final accounts = await getAccounts();

    // Generate ID if not provided
    final newAccount = account.id.isEmpty
        ? account.copyWith(id: _generateId())
        : account;

    // If this is the first account, make it primary
    final finalAccount = accounts.isEmpty
        ? newAccount.copyWith(isPrimary: true)
        : newAccount;

    accounts.add(finalAccount);
    await _saveAccounts(accounts);

    return finalAccount;
  }

  @override
  Future<BankAccount> updateAccount(BankAccount account) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final accounts = await getAccounts();
    final index = accounts.indexWhere((a) => a.id == account.id);

    if (index == -1) {
      throw Exception('Account not found');
    }

    accounts[index] = account;
    await _saveAccounts(accounts);

    return account;
  }

  @override
  Future<void> removeAccount(String accountId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final accounts = await getAccounts();
    accounts.removeWhere((a) => a.id == accountId);

    // If we removed the primary, make another one primary
    if (accounts.isNotEmpty && !accounts.any((a) => a.isPrimary)) {
      accounts[0] = accounts[0].copyWith(isPrimary: true);
    }

    await _saveAccounts(accounts);
  }

  @override
  Future<BankAccount> syncAccount(String accountId) async {
    // Simulate syncing with bank (fetching new balance)
    await Future.delayed(const Duration(milliseconds: 800));

    final accounts = await getAccounts();
    final index = accounts.indexWhere((a) => a.id == accountId);

    if (index == -1) {
      throw Exception('Account not found');
    }

    // Simulate balance change (±5%)
    final random = Random();
    final currentBalance = accounts[index].balance;
    final change = currentBalance * (random.nextDouble() * 0.1 - 0.05);
    final newBalance = (currentBalance + change).clamp(0.0, double.infinity);

    final updatedAccount = accounts[index].copyWith(
      balance: newBalance,
      lastSyncAt: DateTime.now(),
    );

    accounts[index] = updatedAccount;
    await _saveAccounts(accounts);

    return updatedAccount;
  }

  @override
  Future<double> getTotalBalance() async {
    final accounts = await getAccounts();
    return accounts
        .where((a) => a.isActive)
        .fold<double>(0.0, (sum, a) => sum + a.balance);
  }

  /// Set an account as primary
  Future<void> setPrimaryAccount(String accountId) async {
    final accounts = await getAccounts();

    for (int i = 0; i < accounts.length; i++) {
      accounts[i] = accounts[i].copyWith(
        isPrimary: accounts[i].id == accountId,
      );
    }

    await _saveAccounts(accounts);
  }

  /// Clear all accounts (for logout)
  Future<void> clearAccounts() async {
    _cachedAccounts = [];
    await _storage.init();
    final prefs = await _storage.getPrefs();
    await prefs.remove('${_storageKey}_$_userId');
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────────

  Future<void> _saveAccounts(List<BankAccount> accounts) async {
    _cachedAccounts = accounts;
    await _storage.init();
    final prefs = await _storage.getPrefs();
    final data = jsonEncode(accounts.map((a) => a.toJson()).toList());
    await prefs.setString('${_storageKey}_$_userId', data);
  }

  String _generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return 'acct_${List.generate(16, (_) => chars[random.nextInt(chars.length)]).join()}';
  }
}

/// Factory to create bank service
BankServiceBase createBankService({
  required String oderId,
  StorageService? storage,
}) {
  return MockBankService(oderId: oderId, storage: storage);
}
