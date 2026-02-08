import 'package:flutter/foundation.dart';
import '../database/database.dart';

/// Database-backed Merchant Learning Service
/// 
/// Replaces SharedPreferences-based MerchantLearningService with SQLite
/// Maintains the same API for backward compatibility
class DatabaseMerchantService {
  static DatabaseMerchantService? _instance;
  static DatabaseMerchantService get instance {
    _instance ??= DatabaseMerchantService._();
    return _instance!;
  }

  DatabaseMerchantService._();

  final AppDatabase _db = AppDatabase.instance;
  bool _isInitialized = false;

  // Cache for quick lookups
  Map<String, MerchantMapping> _merchantCache = {};

  /// Initialize the service
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await _loadCache();
      _isInitialized = true;
      debugPrint('DatabaseMerchantService: Loaded ${_merchantCache.length} merchants');
    } catch (e) {
      debugPrint('DatabaseMerchantService: Error loading merchants: $e');
      _merchantCache = {};
      _isInitialized = true;
    }
  }

  /// Load merchant cache from database
  Future<void> _loadCache() async {
    final merchants = await _db.merchantDao.getAll();
    _merchantCache = {
      for (final m in merchants)
        m.id: MerchantMapping(
          rawId: m.rawId,
          category: m.category ?? '',
          friendlyName: m.friendlyName,
          learnedAt: DateTime.fromMillisecondsSinceEpoch(m.learnedAt),
          usageCount: m.usageCount,
          isCustomCategory: m.isCustomCategory,
        )
    };
  }

  /// Refresh cache from database
  Future<void> refresh() async {
    await _loadCache();
  }

  /// Learn a new merchant-category mapping
  Future<void> learnMerchant({
    required String rawMerchantId,
    required String category,
    String? friendlyName,
    bool isCustomCategory = false,
    double? amount,
  }) async {
    await init();

    final normalizedId = _normalize(rawMerchantId);

    await _db.merchantDao.learnCategory(
      id: normalizedId,
      rawId: rawMerchantId,
      category: category,
      isCustomCategory: isCustomCategory,
      amount: amount ?? 0.0,
    );

    if (friendlyName != null) {
      await _db.merchantDao.setFriendlyName(normalizedId, friendlyName);
    }

    // Update cache
    _merchantCache[normalizedId] = MerchantMapping(
      rawId: rawMerchantId,
      category: category,
      friendlyName: friendlyName,
      learnedAt: DateTime.now(),
      usageCount: (_merchantCache[normalizedId]?.usageCount ?? 0) + 1,
      isCustomCategory: isCustomCategory,
    );
  }

  /// Get the learned category for a merchant
  MerchantMapping? getMapping(String rawMerchantId) {
    final normalizedId = _normalize(rawMerchantId);
    return _merchantCache[normalizedId];
  }

  /// Get mapping async (from database)
  Future<MerchantMapping?> getMappingAsync(String rawMerchantId) async {
    await init();
    
    final normalizedId = _normalize(rawMerchantId);
    final merchant = await _db.merchantDao.getById(normalizedId);
    
    if (merchant == null) return null;
    
    return MerchantMapping(
      rawId: merchant.rawId,
      category: merchant.category ?? '',
      friendlyName: merchant.friendlyName,
      learnedAt: DateTime.fromMillisecondsSinceEpoch(merchant.learnedAt),
      usageCount: merchant.usageCount,
      isCustomCategory: merchant.isCustomCategory,
    );
  }

  /// Check if a merchant has been learned
  bool isLearned(String rawMerchantId) {
    return getMapping(rawMerchantId) != null;
  }

  /// Get all learned merchants
  Map<String, MerchantMapping> get allMappings => Map.unmodifiable(_merchantCache);

  /// Get merchants by category
  List<MerchantMapping> getMerchantsByCategory(String category) {
    return _merchantCache.values
        .where((m) => m.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Get merchants by category async (from database)
  Future<List<MerchantMapping>> getMerchantsByCategoryAsync(String category) async {
    await init();
    
    final merchants = await _db.merchantDao.getByCategory(category);
    return merchants.map((m) => MerchantMapping(
      rawId: m.rawId,
      category: m.category ?? '',
      friendlyName: m.friendlyName,
      learnedAt: DateTime.fromMillisecondsSinceEpoch(m.learnedAt),
      usageCount: m.usageCount,
      isCustomCategory: m.isCustomCategory,
    )).toList();
  }

  /// Delete a merchant mapping
  Future<void> forgetMerchant(String rawMerchantId) async {
    await init();

    final normalizedId = _normalize(rawMerchantId);
    await _db.merchantDao.deleteById(normalizedId);
    _merchantCache.remove(normalizedId);
  }

  /// Clear all learned mappings
  Future<void> clearAll() async {
    await _db.merchantDao.deleteAll();
    _merchantCache.clear();
  }

  /// Normalize merchant ID for consistent matching
  String _normalize(String merchantId) {
    return merchantId
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9]'), '')
        .trim();
  }

  /// Get statistics
  MerchantLearningStats get stats => MerchantLearningStats(
    totalMerchants: _merchantCache.length,
    categoryCounts: _getCategoryCounts(),
  );

  /// Get statistics async
  Future<Map<String, dynamic>> getStatsAsync() async {
    return await _db.merchantDao.getStats();
  }

  /// Watch all merchants
  Stream<List<MerchantMapping>> get watchAllMappings {
    return _db.merchantDao.watchAll().map((merchants) {
      return merchants.map((m) => MerchantMapping(
        rawId: m.rawId,
        category: m.category ?? '',
        friendlyName: m.friendlyName,
        learnedAt: DateTime.fromMillisecondsSinceEpoch(m.learnedAt),
        usageCount: m.usageCount,
        isCustomCategory: m.isCustomCategory,
      )).toList();
    });
  }

  Map<String, int> _getCategoryCounts() {
    final counts = <String, int>{};
    for (final mapping in _merchantCache.values) {
      counts[mapping.category] = (counts[mapping.category] ?? 0) + 1;
    }
    return counts;
  }

  /// Get category distribution for a merchant
  Future<Map<String, int>> getCategoryDistribution(String rawMerchantId) async {
    final normalizedId = _normalize(rawMerchantId);
    return await _db.merchantDao.getCategoryCounts(normalizedId);
  }

  /// Get top merchants by usage
  Future<List<MerchantMapping>> getTopMerchants({int limit = 20}) async {
    final merchants = await _db.merchantDao.getTopMerchants(limit: limit);
    return merchants.map((m) => MerchantMapping(
      rawId: m.rawId,
      category: m.category ?? '',
      friendlyName: m.friendlyName,
      learnedAt: DateTime.fromMillisecondsSinceEpoch(m.learnedAt),
      usageCount: m.usageCount,
      isCustomCategory: m.isCustomCategory,
    )).toList();
  }

  /// Get recent merchants
  Future<List<MerchantMapping>> getRecentMerchants({int limit = 10}) async {
    final merchants = await _db.merchantDao.getRecent(limit: limit);
    return merchants.map((m) => MerchantMapping(
      rawId: m.rawId,
      category: m.category ?? '',
      friendlyName: m.friendlyName,
      learnedAt: DateTime.fromMillisecondsSinceEpoch(m.learnedAt),
      usageCount: m.usageCount,
      isCustomCategory: m.isCustomCategory,
    )).toList();
  }
}

/// A learned merchant -> category mapping
class MerchantMapping {
  final String rawId;
  final String category;
  final String? friendlyName;
  final DateTime learnedAt;
  final int usageCount;
  final bool isCustomCategory;

  const MerchantMapping({
    required this.rawId,
    required this.category,
    this.friendlyName,
    required this.learnedAt,
    this.usageCount = 1,
    this.isCustomCategory = false,
  });

  /// Display name (friendly name or raw ID)
  String get displayName => friendlyName ?? rawId;
}

/// Statistics about learned merchants
class MerchantLearningStats {
  final int totalMerchants;
  final Map<String, int> categoryCounts;

  const MerchantLearningStats({
    required this.totalMerchants,
    required this.categoryCounts,
  });
}
