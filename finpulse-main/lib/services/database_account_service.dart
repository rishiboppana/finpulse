import 'package:flutter/foundation.dart';
import '../database/database.dart';
import 'package:drift/drift.dart';
import '../models/bank_account.dart' as model;

class DatabaseAccountService extends ChangeNotifier {
  static DatabaseAccountService? _instance;
  static DatabaseAccountService get instance {
    _instance ??= DatabaseAccountService._();
    return _instance!;
  }

  DatabaseAccountService._();

  final AppDatabase _db = AppDatabase.instance;
  List<model.BankAccount> _cachedAccounts = [];

  List<model.BankAccount> get accounts => List.unmodifiable(_cachedAccounts);

  Future<void> init() async {
    await refresh();
  }

  Future<void> refresh() async {
    final dbAccounts = await _db.accountDao.getAllAccounts();
    _cachedAccounts = dbAccounts.map(_fromDbAccount).toList();
    notifyListeners();
  }

  Future<void> addAccount(model.BankAccount account) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.accountDao.insertAccount(
      AccountsCompanion.insert(
        id: account.id,
        accountName: account.accountName,
        institutionId: account.institutionId,
        institutionName: account.institutionName,
        maskedNumber: account.maskedNumber,
        accountType: account.accountType.name,
        balance: Value(account.balance),
        currency: Value(account.currency),
        isPrimary: Value(account.isPrimary),
        createdAt: now,
        updatedAt: now,
      ),
    );
    await refresh();
  }

  Future<bool> updateAccount(model.BankAccount account) async {
    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      await _db.accountDao.upsertAccount(
        AccountsCompanion(
          id: Value(account.id),
          accountName: Value(account.accountName),
          institutionId: Value(account.institutionId),
          institutionName: Value(account.institutionName),
          maskedNumber: Value(account.maskedNumber),
          balance: Value(account.balance),
          updatedAt: Value(now),
        ),
      );
      await refresh();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateBalance(String id, double newBalance) async {
    await _db.accountDao.updateBalance(id, newBalance);
    await refresh();
  }

  model.BankAccount _fromDbAccount(Account dbAcc) {
    return model.BankAccount(
      id: dbAcc.id,
      oderId: 'current_user', // Placeholder
      institutionId: dbAcc.institutionId,
      institutionName: dbAcc.institutionName,
      accountName: dbAcc.accountName,
      accountType: model.AccountType.values.firstWhere(
        (e) => e.name == dbAcc.accountType,
        orElse: () => model.AccountType.savings,
      ),
      maskedNumber: dbAcc.maskedNumber,
      balance: dbAcc.balance,
      currency: dbAcc.currency,
      isActive: true,
      isPrimary: dbAcc.isPrimary,
      linkedAt: DateTime.fromMillisecondsSinceEpoch(dbAcc.createdAt),
      lastSyncAt: DateTime.fromMillisecondsSinceEpoch(dbAcc.updatedAt),
    );
  }

  Stream<List<model.BankAccount>> watchAccounts() {
    return _db.accountDao.watchAllAccounts().map(
      (list) => list.map(_fromDbAccount).toList(),
    );
  }
}
