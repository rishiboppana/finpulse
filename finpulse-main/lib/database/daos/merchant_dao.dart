import 'dart:convert';
import 'package:drift/drift.dart';
import '../database.dart';

part 'merchant_dao.g.dart';

/// Data Access Object for Merchants table
/// Manages learned merchant → category mappings
@DriftAccessor(tables: [Merchants])
class MerchantDao extends DatabaseAccessor<AppDatabase> with _$MerchantDaoMixin {
  MerchantDao(super.db);

  // ============================================================================
  // CREATE / UPSERT
  // ============================================================================

  /// Insert or update merchant mapping
  Future<void> upsertMerchant({
    required String id,
    required String rawId,
    String? category,
    bool isCustomCategory = false,
    String? friendlyName,
  }) async {
    final existing = await getById(id);
    final now = DateTime.now().millisecondsSinceEpoch;

    if (existing == null) {
      await into(merchants).insert(MerchantsCompanion.insert(
        id: id,
        rawId: rawId,
        category: Value(category),
        isCustomCategory: Value(isCustomCategory),
        friendlyName: Value(friendlyName),
        learnedAt: now,
      ));
    } else {
      await (update(merchants)..where((m) => m.id.equals(id))).write(
        MerchantsCompanion(
          category: Value(category),
          isCustomCategory: Value(isCustomCategory),
          friendlyName: Value(friendlyName ?? existing.friendlyName),
          usageCount: Value(existing.usageCount + 1),
          lastUsedAt: Value(now),
        ),
      );
    }
  }

  /// Learn a new category for merchant
  Future<void> learnCategory({
    required String id,
    required String rawId,
    required String category,
    bool isCustomCategory = false,
    double amount = 0.0,
  }) async {
    final existing = await getById(id);
    final now = DateTime.now().millisecondsSinceEpoch;

    if (existing == null) {
      // New merchant
      final categoryCounts = {category: 1};
      
      await into(merchants).insert(MerchantsCompanion.insert(
        id: id,
        rawId: rawId,
        category: Value(category),
        isCustomCategory: Value(isCustomCategory),
        lastCategoryCounts: Value(jsonEncode(categoryCounts)),
        totalSpent: Value(amount),
        learnedAt: now,
      ));
    } else {
      // Update existing
      Map<String, int> counts = {};
      if (existing.lastCategoryCounts != null) {
        counts = Map<String, int>.from(jsonDecode(existing.lastCategoryCounts!));
      }
      
      counts[category] = (counts[category] ?? 0) + 1;
      
      // Find most common category
      final mostCommon = counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      
      await (update(merchants)..where((m) => m.id.equals(id))).write(
        MerchantsCompanion(
          category: Value(mostCommon),
          isCustomCategory: Value(isCustomCategory),
          timesCategorized: Value(existing.timesCategorized + 1),
          lastCategoryCounts: Value(jsonEncode(counts)),
          usageCount: Value(existing.usageCount + 1),
          totalSpent: Value(existing.totalSpent + amount),
          lastUsedAt: Value(now),
        ),
      );
    }
  }

  // ============================================================================
  // READ
  // ============================================================================

  /// Get merchant by ID
  Future<Merchant?> getById(String id) async {
    return await (select(merchants)..where((m) => m.id.equals(id))).getSingleOrNull();
  }

  /// Get category for merchant
  Future<String?> getCategory(String id) async {
    final merchant = await getById(id);
    return merchant?.category;
  }

  /// Check if merchant has learned category
  Future<bool> hasCategory(String id) async {
    final merchant = await getById(id);
    return merchant?.category != null;
  }

  /// Get all merchants with a specific category
  Future<List<Merchant>> getByCategory(String category) async {
    return await (select(merchants)
      ..where((m) => m.category.equals(category))
      ..orderBy([(m) => OrderingTerm.desc(m.usageCount)]))
      .get();
  }

  /// Get all merchants
  Future<List<Merchant>> getAll() async {
    return await (select(merchants)
      ..orderBy([(m) => OrderingTerm.desc(m.usageCount)]))
      .get();
  }

  /// Get top merchants by usage
  Future<List<Merchant>> getTopMerchants({int limit = 20}) async {
    return await (select(merchants)
      ..orderBy([(m) => OrderingTerm.desc(m.usageCount)])
      ..limit(limit))
      .get();
  }

  /// Get recently used merchants
  Future<List<Merchant>> getRecent({int limit = 10}) async {
    return await (select(merchants)
      ..where((m) => m.lastUsedAt.isNotNull())
      ..orderBy([(m) => OrderingTerm.desc(m.lastUsedAt)])
      ..limit(limit))
      .get();
  }

  // ============================================================================
  // LEARNING QUERIES
  // ============================================================================

  /// Get category distribution for merchant
  Future<Map<String, int>> getCategoryCounts(String id) async {
    final merchant = await getById(id);
    if (merchant?.lastCategoryCounts == null) return {};
    
    return Map<String, int>.from(jsonDecode(merchant!.lastCategoryCounts!));
  }

  /// Get merchants that use a custom category
  Future<List<Merchant>> getCustomCategoryMerchants() async {
    return await (select(merchants)
      ..where((m) => m.isCustomCategory.equals(true))
      ..orderBy([(m) => OrderingTerm.desc(m.usageCount)]))
      .get();
  }

  /// Get merchant statistics
  Future<Map<String, dynamic>> getStats() async {
    final all = await getAll();
    
    return {
      'total_merchants': all.length,
      'categorized': all.where((m) => m.category != null).length,
      'custom_category': all.where((m) => m.isCustomCategory).length,
      'total_spent': all.fold(0.0, (sum, m) => sum + m.totalSpent),
    };
  }

  // ============================================================================
  // UPDATE
  // ============================================================================

  /// Update friendly name
  Future<void> setFriendlyName(String id, String name) async {
    await (update(merchants)..where((m) => m.id.equals(id))).write(
      MerchantsCompanion(friendlyName: Value(name)),
    );
  }

  // ============================================================================
  // DELETE
  // ============================================================================

  /// Delete merchant by ID
  Future<void> deleteById(String id) async {
    await (delete(merchants)..where((m) => m.id.equals(id))).go();
  }

  /// Delete all merchants
  Future<void> deleteAll() async {
    await delete(merchants).go();
  }

  // ============================================================================
  // WATCH
  // ============================================================================

  /// Watch all merchants
  Stream<List<Merchant>> watchAll() {
    return (select(merchants)
      ..orderBy([(m) => OrderingTerm.desc(m.usageCount)]))
      .watch();
  }
}
