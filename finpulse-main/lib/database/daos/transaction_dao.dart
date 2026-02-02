import 'package:drift/drift.dart';
import '../database.dart';

part 'transaction_dao.g.dart';

/// Data Access Object for Transactions table
@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase> with _$TransactionDaoMixin {
  TransactionDao(super.db);

  // ============================================================================
  // CREATE
  // ============================================================================

  /// Insert a new transaction
  Future<void> insertTransaction(TransactionsCompanion transaction) async {
    await into(transactions).insert(transaction);
  }

  /// Insert or update transaction
  Future<void> upsertTransaction(TransactionsCompanion transaction) async {
    await into(transactions).insertOnConflictUpdate(transaction);
  }

  // ============================================================================
  // READ
  // ============================================================================

  /// Get all transactions ordered by timestamp descending
  Future<List<Transaction>> getAllTransactions() async {
    return await (select(transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
      .get();
  }

  /// Get transaction by ID
  Future<Transaction?> getById(String id) async {
    return await (select(transactions)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get transaction by fingerprint (for de-duplication)
  Future<Transaction?> getByFingerprint(String fingerprint) async {
    return await (select(transactions)
      ..where((t) => t.fingerprint.equals(fingerprint)))
      .getSingleOrNull();
  }

  /// Check if fingerprint exists
  Future<bool> fingerprintExists(String fingerprint) async {
    final result = await getByFingerprint(fingerprint);
    return result != null;
  }

  /// Find similar transactions (fuzzy de-duplication)
  Future<Transaction?> findSimilar({
    required double amount,
    required String? normalizedMerchantId,
    required int timestamp,
    int windowMinutes = 5,
  }) async {
    final minTime = timestamp - (windowMinutes * 60 * 1000);
    final maxTime = timestamp + (windowMinutes * 60 * 1000);

    final query = select(transactions)
      ..where((t) =>
          t.amount.equals(amount) &
          t.timestamp.isBetweenValues(minTime, maxTime));

    if (normalizedMerchantId != null) {
      query.where((t) => t.normalizedMerchantId.equals(normalizedMerchantId));
    }

    return await query.getSingleOrNull();
  }

  /// Get uncategorized transactions
  Future<List<Transaction>> getUncategorized() async {
    return await (select(transactions)
      ..where((t) => t.isCategorized.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
      .get();
  }

  /// Get transactions for today
  Future<List<Transaction>> getTodayTransactions() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final todayEnd = todayStart + (24 * 60 * 60 * 1000);

    return await (select(transactions)
      ..where((t) => t.timestamp.isBetweenValues(todayStart, todayEnd))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
      .get();
  }

  /// Get transactions for this week
  Future<List<Transaction>> getThisWeekTransactions() async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartMs = DateTime(weekStart.year, weekStart.month, weekStart.day).millisecondsSinceEpoch;

    return await (select(transactions)
      ..where((t) => t.timestamp.isBiggerOrEqualValue(weekStartMs))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
      .get();
  }

  /// Get transactions for this month
  Future<List<Transaction>> getThisMonthTransactions() async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1).millisecondsSinceEpoch;

    return await (select(transactions)
      ..where((t) => t.timestamp.isBiggerOrEqualValue(monthStart))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
      .get();
  }

  /// Get transactions by category
  Future<List<Transaction>> getByCategory(String category) async {
    return await (select(transactions)
      ..where((t) => t.category.equals(category))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
      .get();
  }

  /// Get transactions by merchant
  Future<List<Transaction>> getByMerchant(String normalizedMerchantId) async {
    return await (select(transactions)
      ..where((t) => t.normalizedMerchantId.equals(normalizedMerchantId))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
      .get();
  }

  /// Get transactions in date range
  Future<List<Transaction>> getInRange(int fromMs, int toMs) async {
    return await (select(transactions)
      ..where((t) => t.timestamp.isBetweenValues(fromMs, toMs))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
      .get();
  }

  // ============================================================================
  // AGGREGATIONS
  // ============================================================================

  /// Get total spending for today
  Future<double> getTodaySpending() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final todayEnd = todayStart + (24 * 60 * 60 * 1000);

    final result = await customSelect(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ? AND timestamp >= ? AND timestamp < ?',
      variables: [Variable.withString('debit'), Variable.withInt(todayStart), Variable.withInt(todayEnd)],
    ).getSingle();

    return result.data['total'] as double? ?? 0.0;
  }

  /// Get spending by category in date range
  Future<Map<String, double>> getSpendingByCategory({int? fromMs, int? toMs}) async {
    String sql = 'SELECT category, SUM(amount) as total FROM transactions WHERE type = ?';
    final variables = <Variable>[Variable.withString('debit')];

    if (fromMs != null) {
      sql += ' AND timestamp >= ?';
      variables.add(Variable.withInt(fromMs));
    }
    if (toMs != null) {
      sql += ' AND timestamp < ?';
      variables.add(Variable.withInt(toMs));
    }

    sql += ' GROUP BY category';

    final result = await customSelect(sql, variables: variables).get();

    final Map<String, double> categoryTotals = {};
    for (final row in result) {
      final category = row.data['category'] as String? ?? 'Uncategorized';
      final total = row.data['total'] as double? ?? 0.0;
      categoryTotals[category] = total;
    }

    return categoryTotals;
  }

  /// Get daily spending trend for last N days
  Future<List<MapEntry<DateTime, double>>> getDailySpendingTrend(int days) async {
    final now = DateTime.now();
    final List<MapEntry<DateTime, double>> trend = [];

    for (int i = days - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final nextDate = date.add(const Duration(days: 1));

      final result = await customSelect(
        'SELECT SUM(amount) as total FROM transactions WHERE type = ? AND timestamp >= ? AND timestamp < ?',
        variables: [
          Variable.withString('debit'),
          Variable.withInt(date.millisecondsSinceEpoch),
          Variable.withInt(nextDate.millisecondsSinceEpoch),
        ],
      ).getSingle();

      final total = result.data['total'] as double? ?? 0.0;
      trend.add(MapEntry(date, total));
    }

    return trend;
  }

  // ============================================================================
  // UPDATE
  // ============================================================================

  /// Update transaction category
  Future<void> updateCategory(String id, String category, {bool isCustom = false}) async {
    await (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        category: Value(category),
        isCustomCategory: Value(isCustom),
        isCategorized: const Value(true),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// Mark transaction as categorized
  Future<void> markCategorized(String id) async {
    await (update(transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        isCategorized: const Value(true),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  // ============================================================================
  // DELETE
  // ============================================================================

  /// Delete transaction by ID
  Future<void> deleteById(String id) async {
    await (delete(transactions)..where((t) => t.id.equals(id))).go();
  }

  /// Delete all transactions
  Future<void> deleteAll() async {
    await delete(transactions).go();
  }

  // ============================================================================
  // WATCH (Streams)
  // ============================================================================

  /// Watch all transactions
  Stream<List<Transaction>> watchAllTransactions() {
    return (select(transactions)
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
      .watch();
  }

  /// Watch uncategorized transactions
  Stream<List<Transaction>> watchUncategorized() {
    return (select(transactions)
      ..where((t) => t.isCategorized.equals(false))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
      .watch();
  }

  /// Watch today's transactions
  Stream<List<Transaction>> watchTodayTransactions() {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final todayEnd = todayStart + (24 * 60 * 60 * 1000);

    return (select(transactions)
      ..where((t) => t.timestamp.isBetweenValues(todayStart, todayEnd))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
      .watch();
  }
}
