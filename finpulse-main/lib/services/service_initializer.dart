import 'package:flutter/foundation.dart';
import '../database/database.dart';
import '../database/migration.dart';
import 'database_transaction_service.dart';
import 'database_merchant_service.dart';
import 'database_account_service.dart';
import 'data_seeding_service.dart';

/// Service Initializer for FinPulse
/// 
/// Handles database initialization, migration from SharedPreferences,
/// and initialization of all database-backed services.
class ServiceInitializer {
  static bool _isInitialized = false;
  static MigrationResult? _migrationResult;

  /// Initialize all services
  /// Call this early in the app lifecycle (e.g., in main() or splash screen)
  static Future<void> initialize() async {
    if (_isInitialized) return;

    debugPrint('ServiceInitializer: Starting initialization...');
    final stopwatch = Stopwatch()..start();

    try {
      // 1. Get database instance (this creates/opens the database)
      final db = AppDatabase.instance;
      debugPrint('ServiceInitializer: Database opened');

      // 2. Run migration from SharedPreferences if needed
      final migration = DatabaseMigration(db);
      _migrationResult = await migration.migrate();
      debugPrint('ServiceInitializer: Migration result: $_migrationResult');

      // 3. Initialize database-backed services
      await DatabaseTransactionService.instance.init();
      await DatabaseMerchantService.instance.init();
      await DatabaseAccountService.instance.init();
      
      // 4. Seed initial data if empty
      await DataSeedingService.seedIfEmpty();
      
      debugPrint('ServiceInitializer: Services initialized');

      _isInitialized = true;
      stopwatch.stop();
      debugPrint('ServiceInitializer: Initialization complete in ${stopwatch.elapsedMilliseconds}ms');
    } catch (e, stack) {
      debugPrint('ServiceInitializer: Error during initialization: $e');
      debugPrint('Stack trace: $stack');
      rethrow;
    }
  }

  /// Check if services are initialized
  static bool get isInitialized => _isInitialized;

  /// Get migration result (null if not migrated yet)
  static MigrationResult? get migrationResult => _migrationResult;

  /// Get database instance
  static AppDatabase get database => AppDatabase.instance;

  /// Get transaction service
  static DatabaseTransactionService get transactions => DatabaseTransactionService.instance;

  /// Get merchant service
  static DatabaseMerchantService get merchants => DatabaseMerchantService.instance;

  /// Get account service
  static DatabaseAccountService get accounts => DatabaseAccountService.instance;

  /// Close all services (call on app dispose)
  static Future<void> dispose() async {
    await AppDatabase.instance.closeDatabase();
    _isInitialized = false;
  }

  /// Reset for testing
  @visibleForTesting
  static void reset() {
    AppDatabase.resetInstance();
    _isInitialized = false;
    _migrationResult = null;
  }
}

/// Extension to easily access services from anywhere
extension ServiceAccess on AppDatabase {
  /// Get the transaction service
  DatabaseTransactionService get txService => DatabaseTransactionService.instance;
  
  /// Get the merchant service
  DatabaseMerchantService get merchantService => DatabaseMerchantService.instance;
}
