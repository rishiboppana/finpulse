import 'package:drift/drift.dart';
import '../database.dart';

part 'account_dao.g.dart';

@DriftAccessor(tables: [Accounts])
class AccountDao extends DatabaseAccessor<AppDatabase> with _$AccountDaoMixin {
  AccountDao(super.db);

  Future<List<Account>> getAllAccounts() => select(accounts).get();
  
  Stream<List<Account>> watchAllAccounts() => select(accounts).watch();

  Future<Account?> getById(String id) =>
      (select(accounts)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> insertAccount(AccountsCompanion account) =>
      into(accounts).insert(account);

  Future<void> upsertAccount(AccountsCompanion account) =>
      into(accounts).insertOnConflictUpdate(account);

  Future<void> updateBalance(String id, double newBalance) =>
      (update(accounts)..where((t) => t.id.equals(id))).write(
        AccountsCompanion(
          balance: Value(newBalance),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );

  Future<void> deleteAccount(String id) =>
      (delete(accounts)..where((t) => t.id.equals(id))).go();

  Future<void> deleteAll() => delete(accounts).go();
}
