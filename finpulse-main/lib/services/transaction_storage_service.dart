import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

/// Service for storing and retrieving transactions locally
/// Uses SharedPreferences for persistence
class TransactionStorageService extends ChangeNotifier {
  static final TransactionStorageService instance = TransactionStorageService._();
  TransactionStorageService._();

  static const String _transactionsKey = 'stored_transactions';
  static const int _maxTransactions = 500; // Limit storage

  List<Transaction> _transactions = [];
  bool _isInitialized = false;

  List<Transaction> get transactions => List.unmodifiable(_transactions);
  
  /// Get transactions for today
  List<Transaction> get todayTransactions {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _transactions.where((t) {
      final txDate = DateTime(t.timestamp.year, t.timestamp.month, t.timestamp.day);
      return txDate == today;
    }).toList();
  }
  
  /// Get transactions for this week
  List<Transaction> get thisWeekTransactions {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    return _transactions.where((t) => t.timestamp.isAfter(start)).toList();
  }
  
  /// Get transactions for this month
  List<Transaction> get thisMonthTransactions {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    return _transactions.where((t) => t.timestamp.isAfter(monthStart)).toList();
  }

  /// Initialize and load stored transactions
  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString(_transactionsKey);
      
      if (data != null) {
        final List<dynamic> jsonList = jsonDecode(data);
        _transactions = jsonList
            .map((json) => Transaction.fromJson(json as Map<String, dynamic>))
            .toList();
        
        // Sort by timestamp descending
        _transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }
      
      _isInitialized = true;
      debugPrint('TransactionStorageService: Loaded ${_transactions.length} transactions');
    } catch (e) {
      debugPrint('TransactionStorageService: Error loading transactions: $e');
      _transactions = [];
      _isInitialized = true;
    }
    
    notifyListeners();
  }

  /// Add a new transaction
  Future<void> addTransaction(Transaction transaction) async {
    await init();
    
    // Check for duplicates (same amount, within 5 minutes, same source)
    final isDuplicate = _transactions.any((t) =>
        t.amount == transaction.amount &&
        t.source == transaction.source &&
        t.timestamp.difference(transaction.timestamp).inMinutes.abs() < 5);
    
    if (isDuplicate) {
      debugPrint('TransactionStorageService: Skipping duplicate transaction');
      return;
    }
    
    _transactions.insert(0, transaction);
    
    // Trim if exceeds max
    if (_transactions.length > _maxTransactions) {
      _transactions = _transactions.take(_maxTransactions).toList();
    }
    
    await _save();
    notifyListeners();
  }

  /// Update a transaction (e.g., to add category)
  Future<void> updateTransaction(Transaction updated) async {
    await init();
    
    final index = _transactions.indexWhere((t) => t.id == updated.id);
    if (index != -1) {
      _transactions[index] = updated;
      await _save();
      notifyListeners();
    }
  }

  /// Delete a transaction
  Future<void> deleteTransaction(String id) async {
    await init();
    
    _transactions.removeWhere((t) => t.id == id);
    await _save();
    notifyListeners();
  }

  /// Get total spending for a period
  double getTotalSpending({DateTime? from, DateTime? to}) {
    var filtered = _transactions.where((t) => t.type == TransactionType.debit);
    
    if (from != null) {
      filtered = filtered.where((t) => t.timestamp.isAfter(from));
    }
    if (to != null) {
      filtered = filtered.where((t) => t.timestamp.isBefore(to));
    }
    
    return filtered.fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Get spending by category
  Map<String, double> getSpendingByCategory({DateTime? from, DateTime? to}) {
    final Map<String, double> categoryTotals = {};
    
    var filtered = _transactions.where((t) => t.type == TransactionType.debit);
    
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

  /// Get spending trend for last N days
  List<MapEntry<DateTime, double>> getDailySpendingTrend(int days) {
    final List<MapEntry<DateTime, double>> trend = [];
    final now = DateTime.now();
    
    for (int i = days - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final nextDate = date.add(const Duration(days: 1));
      
      final dayTotal = _transactions
          .where((t) => 
              t.type == TransactionType.debit &&
              t.timestamp.isAfter(date) &&
              t.timestamp.isBefore(nextDate))
          .fold(0.0, (sum, t) => sum + t.amount);
      
      trend.add(MapEntry(date, dayTotal));
    }
    
    return trend;
  }

  /// Save transactions to storage
  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _transactions.map((t) => t.toJson()).toList();
      await prefs.setString(_transactionsKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('TransactionStorageService: Error saving: $e');
    }
  }

  /// Clear all transactions
  Future<void> clear() async {
    _transactions.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_transactionsKey);
    notifyListeners();
  }
}
