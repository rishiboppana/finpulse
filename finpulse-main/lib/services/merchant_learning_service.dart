import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Merchant Learning Service for FinPulse.
/// Stores and retrieves per-user merchant -> category mappings.
/// 
/// Example: "PAYTM*CHAISTALL" -> "Snacks" or "ZOMATO" -> "Food"
class MerchantLearningService {
  static const String _storageKey = 'finpulse_merchant_map';
  static MerchantLearningService? _instance;
  
  SharedPreferences? _prefs;
  Map<String, MerchantMapping> _merchantMap = {};

  // Singleton pattern
  static MerchantLearningService get instance {
    _instance ??= MerchantLearningService._();
    return _instance!;
  }

  MerchantLearningService._();

  /// Initialize the service (call on app start)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadMerchantMap();
  }

  /// Load the merchant map from storage
  Future<void> _loadMerchantMap() async {
    final jsonStr = _prefs?.getString(_storageKey);
    if (jsonStr != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(jsonStr);
        _merchantMap = decoded.map(
          (key, value) => MapEntry(key, MerchantMapping.fromJson(value)),
        );
      } catch (e) {
        _merchantMap = {};
      }
    }
  }

  /// Save the merchant map to storage
  Future<void> _saveMerchantMap() async {
    final jsonStr = jsonEncode(
      _merchantMap.map((key, value) => MapEntry(key, value.toJson())),
    );
    await _prefs?.setString(_storageKey, jsonStr);
  }

  /// Learn a new merchant-category mapping
  /// [rawMerchantId] - The cryptic merchant string (e.g., "PAYTM*CHAISTALL")
  /// [category] - The user-assigned category (e.g., "Snacks")
  /// [friendlyName] - Optional user-friendly name (e.g., "Chai Corner")
  Future<void> learnMerchant({
    required String rawMerchantId,
    required String category,
    String? friendlyName,
  }) async {
    final normalizedId = _normalize(rawMerchantId);
    
    _merchantMap[normalizedId] = MerchantMapping(
      rawId: rawMerchantId,
      category: category,
      friendlyName: friendlyName,
      learnedAt: DateTime.now(),
      usageCount: (_merchantMap[normalizedId]?.usageCount ?? 0) + 1,
    );
    
    await _saveMerchantMap();
  }

  /// Get the learned category for a merchant
  /// Returns null if not learned yet
  MerchantMapping? getMapping(String rawMerchantId) {
    final normalizedId = _normalize(rawMerchantId);
    return _merchantMap[normalizedId];
  }

  /// Check if a merchant has been learned
  bool isLearned(String rawMerchantId) {
    return getMapping(rawMerchantId) != null;
  }

  /// Get all learned merchants (for debugging/display)
  Map<String, MerchantMapping> get allMappings => Map.unmodifiable(_merchantMap);

  /// Get merchants by category
  List<MerchantMapping> getMerchantsByCategory(String category) {
    return _merchantMap.values
        .where((m) => m.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Delete a merchant mapping
  Future<void> forgetMerchant(String rawMerchantId) async {
    final normalizedId = _normalize(rawMerchantId);
    _merchantMap.remove(normalizedId);
    await _saveMerchantMap();
  }

  /// Clear all learned mappings
  Future<void> clearAll() async {
    _merchantMap.clear();
    await _saveMerchantMap();
  }

  /// Normalize merchant ID for consistent matching
  String _normalize(String merchantId) {
    return merchantId
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9]'), '') // Remove special chars
        .trim();
  }

  /// Get statistics
  MerchantLearningStats get stats => MerchantLearningStats(
    totalMerchants: _merchantMap.length,
    categoryCounts: _getCategoryCounts(),
  );

  Map<String, int> _getCategoryCounts() {
    final counts = <String, int>{};
    for (final mapping in _merchantMap.values) {
      counts[mapping.category] = (counts[mapping.category] ?? 0) + 1;
    }
    return counts;
  }
}

/// A learned merchant -> category mapping
class MerchantMapping {
  final String rawId;
  final String category;
  final String? friendlyName;
  final DateTime learnedAt;
  final int usageCount;

  const MerchantMapping({
    required this.rawId,
    required this.category,
    this.friendlyName,
    required this.learnedAt,
    this.usageCount = 1,
  });

  factory MerchantMapping.fromJson(Map<String, dynamic> json) {
    return MerchantMapping(
      rawId: json['rawId'] as String,
      category: json['category'] as String,
      friendlyName: json['friendlyName'] as String?,
      learnedAt: DateTime.parse(json['learnedAt'] as String),
      usageCount: json['usageCount'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'rawId': rawId,
    'category': category,
    'friendlyName': friendlyName,
    'learnedAt': learnedAt.toIso8601String(),
    'usageCount': usageCount,
  };

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
