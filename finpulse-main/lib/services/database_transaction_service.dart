import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../models/transaction.dart' as model;
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Database-backed Transaction Storage Service
/// 
/// Replaces SharedPreferences-based TransactionStorageService with SQLite
/// Maintains the same API for backward compatibility
class DatabaseTransactionService extends ChangeNotifier {
  static DatabaseTransactionService? _instance;
  static DatabaseTransactionService get instance {
    _instance ??= DatabaseTransactionService._();
    return _instance!;
  }

  DatabaseTransactionService._();

  final AppDatabase _db = AppDatabase.instance;
  bool _isInitialized = false;
  
  // Cache for reactive updates
  List<model.Transaction> _cachedTransactions = [];

  List<model.Transaction> get transactions => List.unmodifiable(_cachedTransactions);

  /// Get transactions for today
  List<model.Transaction> get todayTransactions {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _cachedTransactions.where((t) {
      final txDate = DateTime(t.timestamp.year, t.timestamp.month, t.timestamp.day);
      return txDate == today;
    }).toList();
  }

  /// Get transactions for this week
  List<model.Transaction> get thisWeekTransactions {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    return _cachedTransactions.where((t) => t.timestamp.isAfter(start)).toList();
  }

  /// Get transactions for this month
  List<model.Transaction> get thisMonthTransactions {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    return _cachedTransactions.where((t) => t.timestamp.isAfter(monthStart)).toList();
  }

  /// Initialize and load stored transactions
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await _loadTransactions();
      _isInitialized = true;
      debugPrint('DatabaseTransactionService: Loaded ${_cachedTransactions.length} transactions');
    } catch (e) {
      debugPrint('DatabaseTransactionService: Error loading transactions: $e');
      _cachedTransactions = [];
      _isInitialized = true;
    }

    notifyListeners();
  }

  /// Load transactions from database
  Future<void> _loadTransactions() async {
    final dbTransactions = await _db.transactionDao.getAllTransactions();
    _cachedTransactions = dbTransactions.map(_fromDbTransaction).toList();
  }

  /// Refresh cache from database
  Future<void> refresh() async {
    await _loadTransactions();
    notifyListeners();
  }

  /// Add a new transaction
  Future<void> addTransaction(model.Transaction transaction) async {
    await init();

    // Generate fingerprint for de-duplication
    final fingerprint = _generateFingerprint(transaction);

    // Check for exact fingerprint match
    if (await _db.transactionDao.fingerprintExists(fingerprint)) {
      debugPrint('DatabaseTransactionService: Skipping duplicate (fingerprint match)');
      return;
    }

    // Check for fuzzy duplicate (same amount, similar time, same merchant)
    final normalizedMerchant = _normalizeMerchant(transaction.rawMerchantId);
    final similar = await _db.transactionDao.findSimilar(
      amount: transaction.amount,
      normalizedMerchantId: normalizedMerchant,
      timestamp: transaction.timestamp.millisecondsSinceEpoch,
      windowMinutes: 5,
    );

    if (similar != null) {
      debugPrint('DatabaseTransactionService: Skipping duplicate (fuzzy match)');
      return;
    }

    // Insert into database
    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.transactionDao.insertTransaction(
      TransactionsCompanion.insert(
        id: transaction.id,
        amount: transaction.amount,
        timestamp: transaction.timestamp.millisecondsSinceEpoch,
        detectedAt: now,
        source: transaction.source.name,
        rawText: transaction.rawText,
        type: transaction.type.name,
        createdAt: now,
        updatedAt: now,
        fingerprint: Value(fingerprint),
        rawMerchantId: Value(transaction.rawMerchantId),
        normalizedMerchantId: Value(normalizedMerchant),
        merchantName: Value(transaction.merchantName),
        category: Value(transaction.category),
        isCategorized: Value(transaction.category != null),
        accountLastDigits: Value(transaction.accountLastDigits),
      ),
    );

    // Refresh cache
    await _loadTransactions();
    notifyListeners();
  }

  /// Update a transaction (e.g., to add category)
  Future<void> updateTransaction(model.Transaction updated) async {
    await init();

    final now = DateTime.now().millisecondsSinceEpoch;
    await _db.transactionDao.upsertTransaction(
      TransactionsCompanion(
        id: Value(updated.id),
        amount: Value(updated.amount),
        timestamp: Value(updated.timestamp.millisecondsSinceEpoch),
        detectedAt: Value(now),
        source: Value(updated.source.name),
        rawText: Value(updated.rawText),
        type: Value(updated.type.name),
        category: Value(updated.category),
        isCategorized: Value(updated.category != null),
        merchantName: Value(updated.merchantName),
        rawMerchantId: Value(updated.rawMerchantId),
        normalizedMerchantId: Value(_normalizeMerchant(updated.rawMerchantId)),
        accountLastDigits: Value(updated.accountLastDigits),
        updatedAt: Value(now),
        createdAt: Value(now),
      ),
    );

    await _loadTransactions();
    notifyListeners();
  }

  /// Delete a transaction
  Future<void> deleteTransaction(String id) async {
    await init();

    await _db.transactionDao.deleteById(id);

    await _loadTransactions();
    notifyListeners();
  }

  /// Get total spending for a period
  double getTotalSpending({DateTime? from, DateTime? to}) {
    var filtered = _cachedTransactions.where((t) => t.type == model.TransactionType.debit);

    if (from != null) {
      filtered = filtered.where((t) => t.timestamp.isAfter(from));
    }
    if (to != null) {
      filtered = filtered.where((t) => t.timestamp.isBefore(to));
    }

    return filtered.fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Get today's spending directly from database
  Future<double> getTodaySpendingAsync() async {
    return await _db.transactionDao.getTodaySpending();
  }

  /// Get today's transactions directly from database (async)
  Future<List<model.Transaction>> get todayTransactionsAsync async {
    final dbTransactions = await _db.transactionDao.getTodayTransactions();
    return dbTransactions.map(_fromDbTransaction).toList();
  }

  /// Get spending by category
  Map<String, double> getSpendingByCategory({DateTime? from, DateTime? to}) {
    final Map<String, double> categoryTotals = {};

    var filtered = _cachedTransactions.where((t) => t.type == model.TransactionType.debit);

    if (from != null) {
      filtered = filtered.where((t) => t.timestamp.isAfter(from));
    }
    if (to != null) {
      filtered = filtered.where((t) => t.timestamp.isBefore(to));
    }

    for (final transaction in filtered) {
      final category = transaction.category ?? 'Uncategorized';
      categoryTotals[category] = (categoryTotals[category] ?? 0) + transaction.amount;
    }

    return categoryTotals;
  }

  /// Get spending by category directly from database
  Future<Map<String, double>> getSpendingByCategoryAsync({DateTime? from, DateTime? to}) async {
    return await _db.transactionDao.getSpendingByCategory(
      fromMs: from?.millisecondsSinceEpoch,
      toMs: to?.millisecondsSinceEpoch,
    );
  }

  /// Get spending trend for last N days
  List<MapEntry<DateTime, double>> getDailySpendingTrend(int days) {
    final List<MapEntry<DateTime, double>> trend = [];
    final now = DateTime.now();

    for (int i = days - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final nextDate = date.add(const Duration(days: 1));

      final dayTotal = _cachedTransactions
          .where((t) =>
              t.type == model.TransactionType.debit &&
              t.timestamp.isAfter(date) &&
              t.timestamp.isBefore(nextDate))
          .fold(0.0, (sum, t) => sum + t.amount);

      trend.add(MapEntry(date, dayTotal));
    }

    return trend;
  }

  /// Get spending trend directly from database
  Future<List<MapEntry<DateTime, double>>> getDailySpendingTrendAsync(int days) async {
    return await _db.transactionDao.getDailySpendingTrend(days);
  }

  /// Clear all transactions
  Future<void> clear() async {
    await _db.transactionDao.deleteAll();
    _cachedTransactions.clear();
    notifyListeners();
  }

  /// Get uncategorized transactions
  Future<List<model.Transaction>> getUncategorizedTransactions() async {
    final dbTransactions = await _db.transactionDao.getUncategorized();
    return dbTransactions.map(_fromDbTransaction).toList();
  }

  /// Watch all transactions (reactive stream)
  Stream<List<model.Transaction>> watchAllTransactions() {
    return _db.transactionDao.watchAllTransactions().map(
      (list) => list.map(_fromDbTransaction).toList(),
    );
  }

  /// Watch uncategorized transactions
  Stream<List<model.Transaction>> watchUncategorized() {
    return _db.transactionDao.watchUncategorized().map(
      (list) => list.map(_fromDbTransaction).toList(),
    );
  }

  /// Watch today's transactions
  Stream<List<model.Transaction>> watchTodayTransactions() {
    return _db.transactionDao.watchTodayTransactions().map(
      (list) => list.map(_fromDbTransaction).toList(),
    );
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Generate fingerprint for de-duplication
  String _generateFingerprint(model.Transaction transaction) {
    final data = '${transaction.amount}|${transaction.rawMerchantId}|'
        '${transaction.timestamp.millisecondsSinceEpoch ~/ 60000}|' // Round to minute
        '${transaction.accountLastDigits}';
    return md5.convert(utf8.encode(data)).toString();
  }

  /// Normalize merchant ID for matching
  String? _normalizeMerchant(String? id) {
    if (id == null) return null;
    return id.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  }

  /// Convert database Transaction to model Transaction
  model.Transaction _fromDbTransaction(Transaction dbTx) {
    return model.Transaction(
      id: dbTx.id,
      amount: dbTx.amount,
      rawMerchantId: dbTx.rawMerchantId,
      merchantName: dbTx.merchantName,
      category: dbTx.category,
      timestamp: DateTime.fromMillisecondsSinceEpoch(dbTx.timestamp),
      type: model.TransactionType.values.firstWhere(
        (t) => t.name == dbTx.type,
        orElse: () => model.TransactionType.unknown,
      ),
      source: model.DetectionSource.values.firstWhere(
        (s) => s.name == dbTx.source,
        orElse: () => model.DetectionSource.manual,
      ),
      accountLastDigits: dbTx.accountLastDigits,
      rawText: dbTx.rawText,
    );
  }
}
