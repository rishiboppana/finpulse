import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/drift.dart';
import 'database.dart';
import 'daos/preference_dao.dart';

/// Handles migration from SharedPreferences to SQLite database
/// 
/// This should be run once when the app starts to migrate existing data
class DatabaseMigration {
  final AppDatabase _db;
  
  DatabaseMigration(this._db);
  
  /// Check if migration has been completed
  Future<bool> isMigrationComplete() async {
    return await _db.preferenceDao.isMigrationComplete();
  }
  
  /// Run the full migration from SharedPreferences to SQLite
  Future<MigrationResult> migrate() async {
    final result = MigrationResult();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if already migrated
      if (await isMigrationComplete()) {
        result.alreadyMigrated = true;
        return result;
      }
      
      // 1. Migrate transactions
      result.transactionsMigrated = await _migrateTransactions(prefs);
      
      // 2. Migrate merchants
      result.merchantsMigrated = await _migrateMerchants(prefs);
      
      // 3. Migrate preferences
      result.preferencesMigrated = await _migratePreferences(prefs);
      
      // 4. Mark migration complete
      await _db.preferenceDao.setMigrationComplete(true);
      
      result.success = true;
    } catch (e, stack) {
      result.success = false;
      result.error = e.toString();
      result.stackTrace = stack.toString();
    }
    
    return result;
  }
  
  /// Migrate transactions from SharedPreferences
  Future<int> _migrateTransactions(SharedPreferences prefs) async {
    int count = 0;
    
    // Try to get stored transactions
    final txnJson = prefs.getString('stored_transactions');
    if (txnJson == null) return count;
    
    try {
      final List<dynamic> transactions = jsonDecode(txnJson);
      
      for (final txn in transactions) {
        try {
          final now = DateTime.now().millisecondsSinceEpoch;
          
          await _db.transactionDao.insertTransaction(
            TransactionsCompanion.insert(
              id: txn['id'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
              amount: (txn['amount'] as num?)?.toDouble() ?? 0.0,
              timestamp: txn['timestamp'] ?? now,
              detectedAt: txn['timestamp'] ?? now,
              source: txn['source'] ?? 'sms',
              rawText: txn['rawText'] ?? '',
              type: txn['type'] ?? 'debit',
              createdAt: txn['createdAt'] ?? now,
              updatedAt: txn['updatedAt'] ?? now,
              // Optional fields
              fingerprint: Value(txn['fingerprint']),
              rawMerchantId: Value(txn['merchantId']),
              normalizedMerchantId: Value(_normalizeMerchant(txn['merchantId'])),
              merchantName: Value(txn['merchantName']),
              category: Value(txn['category']),
              isCategorized: Value(txn['category'] != null),
              accountLastDigits: Value(txn['accountId']),
            ),
          );
          count++;
        } catch (e) {
          // Skip individual transaction errors, continue with others
          debugPrint('Failed to migrate transaction: $e');
        }
      }
      
      // Remove old data after successful migration
      // await prefs.remove('stored_transactions');
    } catch (e) {
      debugPrint('Failed to parse transactions: $e');
    }
    
    return count;
  }
  
  /// Migrate merchant mappings from SharedPreferences
  Future<int> _migrateMerchants(SharedPreferences prefs) async {
    int count = 0;
    
    // Try to get stored merchant mappings
    final merchantJson = prefs.getString('finpulse_merchant_map');
    if (merchantJson == null) return count;
    
    try {
      final Map<String, dynamic> merchants = jsonDecode(merchantJson);
      
      for (final entry in merchants.entries) {
        try {
          final data = entry.value as Map<String, dynamic>;
          
          await _db.merchantDao.upsertMerchant(
            id: entry.key,
            rawId: data['rawId'] ?? entry.key,
            category: data['category'],
            friendlyName: data['name'],
          );
          count++;
        } catch (e) {
          debugPrint('Failed to migrate merchant ${entry.key}: $e');
        }
      }
      
      // Remove old data after successful migration
      // await prefs.remove('finpulse_merchant_map');
    } catch (e) {
      debugPrint('Failed to parse merchants: $e');
    }
    
    return count;
  }
  
  /// Migrate app preferences from SharedPreferences
  Future<int> _migratePreferences(SharedPreferences prefs) async {
    int count = 0;
    
    // List of preferences to migrate
    final Map<String, String> prefKeys = {
      'onboarding_complete': PreferenceDao.keyOnboardingComplete,
      'sms_permission': PreferenceDao.keySmsDetection,
      'notification_permission': PreferenceDao.keyNotificationDetection,
      'accessibility_permission': PreferenceDao.keyAccessibilityDetection,
      'selected_locale': PreferenceDao.keyLanguage,
      'theme_mode': PreferenceDao.keyTheme,
    };
    
    for (final entry in prefKeys.entries) {
      final oldKey = entry.key;
      final newKey = entry.value;
      
      // Try to get string value
      final strValue = prefs.getString(oldKey);
      if (strValue != null) {
        await _db.preferenceDao.set(newKey, strValue);
        count++;
        continue;
      }
      
      // Try to get bool value
      final boolValue = prefs.getBool(oldKey);
      if (boolValue != null) {
        await _db.preferenceDao.setBool(newKey, boolValue);
        count++;
        continue;
      }
    }
    
    return count;
  }
  
  /// Normalize merchant ID for matching
  String? _normalizeMerchant(String? id) {
    if (id == null) return null;
    return id.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
  }
}

/// Result of migration operation
class MigrationResult {
  bool success = false;
  bool alreadyMigrated = false;
  int transactionsMigrated = 0;
  int merchantsMigrated = 0;
  int preferencesMigrated = 0;
  String? error;
  String? stackTrace;
  
  @override
  String toString() {
    if (alreadyMigrated) {
      return 'Migration already completed';
    }
    if (success) {
      return 'Migration successful: '
          '$transactionsMigrated transactions, '
          '$merchantsMigrated merchants, '
          '$preferencesMigrated preferences';
    }
    return 'Migration failed: $error';
  }
}
