import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../models/transaction.dart' as model;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

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

  /// Add a new transaction with enhanced deduplication
  /// Returns true if transaction was inserted (new), false if duplicate
  Future<bool> addTransaction(model.Transaction transaction) async {
    await init();

    // Generate fingerprint for de-duplication
    final fingerprint = _generateFingerprint(transaction);
    
    // Generate internal ID for cross-source deduplication
    final internalId = _generateInternalId(transaction);
    
    // Generate rawText hash for identical SMS detection
    final rawTextHash = transaction.rawText != null 
        ? md5.convert(utf8.encode(transaction.rawText!)).toString()
        : null;
    
    // Get reference ID (UPI Ref, Bank Ref) from transaction
    final referenceId = transaction.referenceId;

    debugPrint('===== DEDUP CHECK: ${transaction.amount} =====');
    debugPrint('📝 rawText: ${transaction.rawText?.substring(0, min(50, transaction.rawText?.length ?? 0))}...');
    debugPrint('🔑 rawTextHash: $rawTextHash');
    debugPrint('🆔 referenceId: $referenceId');
    debugPrint('🔗 internalId: $internalId');
    debugPrint('🔖 fingerprint: $fingerprint');

    // ========== LAYER 0: Raw Text Hash Check ==========
    // If same SMS text was already processed, it's a duplicate
    if (rawTextHash != null) {
      debugPrint('⏳ Layer 0: Checking rawText hash...');
      final exists = await _db.transactionDao.rawTextHashExists(rawTextHash);
      debugPrint('   Layer 0 result: exists=$exists');
      if (exists) {
        debugPrint('DatabaseTransactionService: ❌ Duplicate (same SMS text): ${transaction.amount}');
        return false;
      }
    } else {
      debugPrint('⏭️ Layer 0: Skipped (no rawText)');
    }

    // ========== LAYER 1: Reference ID Check ==========
    // If we have a reference ID, check for exact match first (most reliable)
    if (referenceId != null && referenceId.isNotEmpty) {
      debugPrint('⏳ Layer 1: Checking referenceId...');
      final exists = await _db.transactionDao.referenceIdExists(referenceId);
      debugPrint('   Layer 1 result: exists=$exists');
      if (exists) {
        debugPrint('DatabaseTransactionService: ❌ Duplicate (referenceId match): $referenceId');
        return false;
      }
    } else {
      debugPrint('⏭️ Layer 1: Skipped (no referenceId)');
    }

    // ========== LAYER 2: Internal ID Check ==========
    // Check internal ID for cross-source duplicates (SMS + Accessibility detecting same tx)
    debugPrint('⏳ Layer 2: Checking internalId...');
    final internalExists = await _db.transactionDao.internalIdExists(internalId);
    debugPrint('   Layer 2 result: exists=$internalExists');
    if (internalExists) {
      debugPrint('DatabaseTransactionService: ❌ Duplicate (internalId match): $internalId');
      return false;
    }

    // ========== LAYER 3: Fingerprint Check ==========
    debugPrint('⏳ Layer 3: Checking fingerprint...');
    final fpExists = await _db.transactionDao.fingerprintExists(fingerprint);
    debugPrint('   Layer 3 result: exists=$fpExists');
    if (fpExists) {
      debugPrint('DatabaseTransactionService: ❌ Duplicate (fingerprint match)');
      return false;
    }

    // ========== LAYER 4: Fuzzy Match (Extended Window) ==========
    // Check for fuzzy duplicate: same amount + same type + similar merchant + within 24 hours
    debugPrint('⏳ Layer 4: Checking fuzzy match (24h window)...');
    final normalizedMerchant = _normalizeMerchant(transaction.rawMerchantId);
    debugPrint('   Normalized merchant: $normalizedMerchant');
    final similar = await _db.transactionDao.findSimilarWithType(
      amount: transaction.amount,
      type: transaction.type.name,
      normalizedMerchantId: normalizedMerchant,
      timestamp: transaction.timestamp.millisecondsSinceEpoch,
      windowMinutes: 1440, // 24 hours instead of 5 minutes
    );
    debugPrint('   Layer 4 result: similar=${similar != null}');

    if (similar != null) {
      debugPrint('DatabaseTransactionService: ❌ Duplicate (fuzzy match - same amount/type/merchant within 24h)');
      return false;
    }
    
    debugPrint('===== ALL LAYERS PASSED - NEW TRANSACTION =====');

    // ========== INSERT ==========
    debugPrint('DatabaseTransactionService: ✅ New transaction, inserting...');
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
        internalId: Value(internalId),
        referenceId: Value(referenceId),
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
    return true;
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

  /// Generate internal ID for cross-source deduplication
  /// This ID is SOURCE-AGNOSTIC - used to detect when SMS and Accessibility detect same tx
  String _generateInternalId(model.Transaction transaction) {
    // Use amount + merchant + account + timestamp (rounded to minute) for matching
    final data = '${transaction.amount}|'
        '${_normalizeMerchant(transaction.rawMerchantId) ?? ""}|'
        '${transaction.accountLastDigits ?? ""}|'
        '${transaction.timestamp.millisecondsSinceEpoch ~/ 60000}';
    final hash = md5.convert(utf8.encode(data)).toString().substring(0, 12);
    return 'fp_${transaction.timestamp.millisecondsSinceEpoch}_$hash';
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
