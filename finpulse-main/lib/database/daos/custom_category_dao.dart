import 'dart:convert';
import 'package:drift/drift.dart';
import '../database.dart';

part 'custom_category_dao.g.dart';

/// Data Access Object for CustomCategories table
/// Manages user-defined categories and their learned keywords
@DriftAccessor(tables: [CustomCategories])
class CustomCategoryDao extends DatabaseAccessor<AppDatabase> with _$CustomCategoryDaoMixin {
  CustomCategoryDao(super.db);

  // ============================================================================
  // CREATE
  // ============================================================================

  /// Create a new custom category
  Future<int> createCategory({
    required String name,
    required String displayName,
    String? emoji,
    String? color,
    String? description,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    return await into(customCategories).insert(
      CustomCategoriesCompanion.insert(
        name: name,
        displayName: displayName,
        emoji: Value(emoji),
        color: Value(color),
        description: Value(description),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  // ============================================================================
  // READ
  // ============================================================================

  /// Get all active custom categories
  Future<List<CustomCategory>> getAllActive() async {
    return await (select(customCategories)
      ..where((c) => c.isActive.equals(true))
      ..orderBy([(c) => OrderingTerm.desc(c.usageCount)]))
      .get();
  }

  /// Get all custom categories (including inactive)
  Future<List<CustomCategory>> getAll() async {
    return await (select(customCategories)
      ..orderBy([(c) => OrderingTerm.desc(c.usageCount)]))
      .get();
  }

  /// Get category by name
  Future<CustomCategory?> getByName(String name) async {
    return await (select(customCategories)
      ..where((c) => c.name.equals(name)))
      .getSingleOrNull();
  }

  /// Check if category name exists
  Future<bool> exists(String name) async {
    final result = await getByName(name);
    return result != null;
  }

  /// Get category names only
  Future<List<String>> getActiveNames() async {
    final categories = await getAllActive();
    return categories.map((c) => c.name).toList();
  }

  // ============================================================================
  // UPDATE
  // ============================================================================

  /// Update category display name (for renaming)
  Future<void> updateDisplayName(String name, String newDisplayName) async {
    await (update(customCategories)..where((c) => c.name.equals(name))).write(
      CustomCategoriesCompanion(
        displayName: Value(newDisplayName),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// Update category emoji
  Future<void> updateEmoji(String name, String emoji) async {
    await (update(customCategories)..where((c) => c.name.equals(name))).write(
      CustomCategoriesCompanion(
        emoji: Value(emoji),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// Increment usage count and update last used
  Future<void> recordUsage(String name) async {
    final category = await getByName(name);
    if (category == null) return;
    
    await (update(customCategories)..where((c) => c.name.equals(name))).write(
      CustomCategoriesCompanion(
        usageCount: Value(category.usageCount + 1),
        lastUsedAt: Value(DateTime.now().millisecondsSinceEpoch),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// Add learned keywords (from Gemini)
  Future<void> addLearnedKeywords(String name, List<String> newKeywords) async {
    final category = await getByName(name);
    if (category == null) return;
    
    // Parse existing keywords
    List<String> existing = [];
    if (category.learnedKeywords != null) {
      existing = List<String>.from(jsonDecode(category.learnedKeywords!));
    }
    
    // Add new unique keywords
    final combined = {...existing, ...newKeywords}.toList();
    
    await (update(customCategories)..where((c) => c.name.equals(name))).write(
      CustomCategoriesCompanion(
        learnedKeywords: Value(jsonEncode(combined)),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// Add learned merchant
  Future<void> addLearnedMerchant(String name, String merchantId) async {
    final category = await getByName(name);
    if (category == null) return;
    
    // Parse existing merchants
    List<String> existing = [];
    if (category.learnedMerchants != null) {
      existing = List<String>.from(jsonDecode(category.learnedMerchants!));
    }
    
    // Add if not already present
    if (!existing.contains(merchantId)) {
      existing.add(merchantId);
      
      await (update(customCategories)..where((c) => c.name.equals(name))).write(
        CustomCategoriesCompanion(
          learnedMerchants: Value(jsonEncode(existing)),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );
    }
  }

  /// Deactivate category (soft delete)
  Future<void> deactivate(String name) async {
    await (update(customCategories)..where((c) => c.name.equals(name))).write(
      CustomCategoriesCompanion(
        isActive: const Value(false),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  /// Reactivate category
  Future<void> reactivate(String name) async {
    await (update(customCategories)..where((c) => c.name.equals(name))).write(
      CustomCategoriesCompanion(
        isActive: const Value(true),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  // ============================================================================
  // LEARNING QUERIES
  // ============================================================================

  /// Get keywords for a category
  Future<List<String>> getKeywords(String name) async {
    final category = await getByName(name);
    if (category?.learnedKeywords == null) return [];
    
    return List<String>.from(jsonDecode(category!.learnedKeywords!));
  }

  /// Get merchants associated with a category
  Future<List<String>> getMerchants(String name) async {
    final category = await getByName(name);
    if (category?.learnedMerchants == null) return [];
    
    return List<String>.from(jsonDecode(category!.learnedMerchants!));
  }

  /// Find categories by keyword match
  Future<List<CustomCategory>> findByKeyword(String keyword) async {
    final allCategories = await getAllActive();
    final matching = <CustomCategory>[];
    
    for (final category in allCategories) {
      if (category.learnedKeywords != null) {
        final keywords = List<String>.from(jsonDecode(category.learnedKeywords!));
        if (keywords.any((k) => keyword.toLowerCase().contains(k.toLowerCase()))) {
          matching.add(category);
        }
      }
    }
    
    return matching;
  }

  /// Get all custom categories with their keywords for Gemini context
  Future<List<Map<String, dynamic>>> getCategoriesForGemini() async {
    final categories = await getAllActive();
    
    return categories.map((c) => {
      'name': c.name,
      'display_name': c.displayName,
      'keywords': c.learnedKeywords != null ? jsonDecode(c.learnedKeywords!) : [],
      'merchants': c.learnedMerchants != null ? jsonDecode(c.learnedMerchants!) : [],
      'usage_count': c.usageCount,
    }).toList();
  }

  // ============================================================================
  // DELETE
  // ============================================================================

  /// Permanently delete category
  Future<void> deleteByName(String name) async {
    await (delete(customCategories)..where((c) => c.name.equals(name))).go();
  }

  /// Delete all custom categories
  Future<void> deleteAll() async {
    await delete(customCategories).go();
  }

  // ============================================================================
  // WATCH
  // ============================================================================

  /// Watch all active categories
  Stream<List<CustomCategory>> watchActive() {
    return (select(customCategories)
      ..where((c) => c.isActive.equals(true))
      ..orderBy([(c) => OrderingTerm.desc(c.usageCount)]))
      .watch();
  }
}
