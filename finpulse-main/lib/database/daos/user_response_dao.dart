import 'package:drift/drift.dart';
import '../database.dart';

part 'user_response_dao.g.dart';

/// Data Access Object for UserResponses table
/// Stores all user categorization responses for Gemini learning
@DriftAccessor(tables: [UserResponses])
class UserResponseDao extends DatabaseAccessor<AppDatabase> with _$UserResponseDaoMixin {
  UserResponseDao(super.db);

  // ============================================================================
  // CREATE
  // ============================================================================

  /// Insert a new user response
  Future<int> insertResponse(UserResponsesCompanion response) async {
    return await into(userResponses).insert(response);
  }

  /// Log a user interaction
  Future<int> logResponse({
    required String transactionId,
    required String inputMethod,
    required String rawInput,
    String? merchantAtTime,
    double? amountAtTime,
  }) {
    return into(userResponses).insert(UserResponsesCompanion(
      transactionId: Value(transactionId),
      inputMethod: Value(inputMethod),
      rawInput: Value(rawInput),
      merchantAtTime: Value(merchantAtTime),
      amountAtTime: Value(amountAtTime),
      createdAt: Value(DateTime.now().millisecondsSinceEpoch),
    ));
  }

  /// Update with AI interpretation
  Future<void> updateAiInterpretation(
    int id, {
    required String geminiInterpretation,
    String? geminiCategory,
    String? geminiSubcategory,
    String? geminiReasoning,
    required String finalCategory,
  }) {
    return (update(userResponses)..where((t) => t.id.equals(id))).write(
      UserResponsesCompanion(
        geminiInterpretation: Value(geminiInterpretation),
        geminiCategory: Value(geminiCategory),
        geminiSubcategory: Value(geminiSubcategory),
        geminiReasoning: Value(geminiReasoning),
        finalCategory: Value(finalCategory),
        interpretedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ),
    );
  }

  // ============================================================================
  // READ
  // ============================================================================

  /// Get all responses for a transaction
  Future<List<UserResponse>> getByTransaction(String transactionId) async {
    return await (select(userResponses)
      ..where((r) => r.transactionId.equals(transactionId))
      ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]))
      .get();
  }

  /// Get all responses for a category (for learning)
  Future<List<UserResponse>> getByCategory(String category) async {
    return await (select(userResponses)
      ..where((r) => r.finalCategory.equals(category))
      ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]))
      .get();
  }

  /// Get all responses for a merchant (for learning patterns)
  Future<List<UserResponse>> getByMerchant(String merchantId) async {
    return await (select(userResponses)
      ..where((r) => r.merchantAtTime.equals(merchantId))
      ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]))
      .get();
  }

  /// Get natural language responses only (voice/text, not taps)
  Future<List<UserResponse>> getNaturalLanguageResponses() async {
    return await (select(userResponses)
      ..where((r) => r.inputMethod.isIn(['voice', 'text']))
      ..where((r) => r.rawInput.isNotNull())
      ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]))
      .get();
  }

  /// Get responses where user corrected Gemini
  Future<List<UserResponse>> getCorrections() async {
    return await (select(userResponses)
      ..where((r) => r.userConfirmed.equals(false) | r.userCorrection.isNotNull())
      ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]))
      .get();
  }

  /// Get custom category responses
  Future<List<UserResponse>> getCustomCategoryResponses() async {
    return await (select(userResponses)
      ..where((r) => r.isCustomCategory.equals(true))
      ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]))
      .get();
  }

  /// Get recent responses (for context building)
  Future<List<UserResponse>> getRecent({int limit = 50}) async {
    return await (select(userResponses)
      ..orderBy([(r) => OrderingTerm.desc(r.createdAt)])
      ..limit(limit))
      .get();
  }

  // ============================================================================
  // LEARNING QUERIES
  // ============================================================================

  /// Get category distribution for a merchant
  /// Returns: {"Food": 5, "Coffee": 2, "Snacks": 1}
  Future<Map<String, int>> getCategoryCountsForMerchant(String merchantId) async {
    final responses = await getByMerchant(merchantId);
    final counts = <String, int>{};
    
    for (final response in responses) {
      counts[response.finalCategory] = (counts[response.finalCategory] ?? 0) + 1;
    }
    
    return counts;
  }

  /// Get most common category for merchant
  Future<String?> getMostCommonCategoryForMerchant(String merchantId) async {
    final counts = await getCategoryCountsForMerchant(merchantId);
    if (counts.isEmpty) return null;
    
    return counts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  /// Get all unique phrases for a category (for learning keywords)
  Future<List<String>> getPhrasesForCategory(String category) async {
    final responses = await (select(userResponses)
      ..where((r) => r.finalCategory.equals(category))
      ..where((r) => r.rawInput.isNotNull()))
      .get();
    
    return responses
        .where((r) => r.rawInput != null && r.rawInput!.isNotEmpty)
        .map((r) => r.rawInput!)
        .toList();
  }

  /// Get phrases that led to custom categories
  Future<Map<String, List<String>>> getCustomCategoryPhrases() async {
    final responses = await getCustomCategoryResponses();
    final phraseMap = <String, List<String>>{};
    
    for (final response in responses) {
      if (response.rawInput != null && response.rawInput!.isNotEmpty) {
        phraseMap.putIfAbsent(response.finalCategory, () => []);
        phraseMap[response.finalCategory]!.add(response.rawInput!);
      }
    }
    
    return phraseMap;
  }

  /// Get average response time (for UX optimization)
  Future<double> getAverageResponseTime() async {
    final result = await customSelect(
      'SELECT AVG(response_time_ms) as avg_time FROM user_responses WHERE response_time_ms IS NOT NULL',
    ).getSingleOrNull();
    
    return result?.data['avg_time'] as double? ?? 0.0;
  }

  /// Get input method distribution
  Future<Map<String, int>> getInputMethodDistribution() async {
    final result = await customSelect(
      'SELECT input_method, COUNT(*) as count FROM user_responses GROUP BY input_method',
    ).get();
    
    final distribution = <String, int>{};
    for (final row in result) {
      distribution[row.data['input_method'] as String] = row.data['count'] as int;
    }
    
    return distribution;
  }

  // ============================================================================
  // BUILDING GEMINI CONTEXT
  // ============================================================================

  /// Build learning context for a new transaction
  Future<Map<String, dynamic>> buildLearningContext(String? merchantId) async {
    final context = <String, dynamic>{};
    
    // Merchant-specific learning
    if (merchantId != null) {
      final categoryCounts = await getCategoryCountsForMerchant(merchantId);
      final mostCommon = await getMostCommonCategoryForMerchant(merchantId);
      
      context['merchant_history'] = {
        'category_counts': categoryCounts,
        'most_common': mostCommon,
        'times_seen': categoryCounts.values.fold(0, (a, b) => a + b),
      };
    }
    
    // Recent natural language responses for phrase patterns
    final recentNL = await getNaturalLanguageResponses();
    final phrasePatterns = <String, List<String>>{};
    
    for (final response in recentNL.take(100)) {
      phrasePatterns.putIfAbsent(response.finalCategory, () => []);
      if (response.rawInput != null) {
        phrasePatterns[response.finalCategory]!.add(response.rawInput!);
      }
    }
    
    context['phrase_patterns'] = phrasePatterns.map(
      (k, v) => MapEntry(k, v.take(5).toList()), // Limit to 5 examples each
    );
    
    // Custom categories used
    final customPhrases = await getCustomCategoryPhrases();
    context['custom_categories'] = customPhrases.keys.toList();
    
    return context;
  }

  // ============================================================================
  // DELETE
  // ============================================================================

  /// Delete responses for a transaction
  Future<void> deleteByTransaction(String transactionId) async {
    await (delete(userResponses)
      ..where((r) => r.transactionId.equals(transactionId)))
      .go();
  }

  /// Delete all responses
  Future<void> deleteAll() async {
    await delete(userResponses).go();
  }
}
