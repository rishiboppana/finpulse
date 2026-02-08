import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../database/database.dart';
import 'gemini_service.dart';
import 'service_initializer.dart';
import 'app_logger.dart';

/// Service to handle user interactions (The "Social Brain")
/// 
/// Processes natural language input from users (e.g., "Doodh liya")
/// and updates transaction categorization and merchant intelligence.
class InteractionService {
  static final InteractionService instance = InteractionService._();
  InteractionService._();

  final _gemini = GeminiService.instance;
  final _db = ServiceInitializer.database;

  /// Process user input for a transaction
  Future<void> processUserInput({
    required String transactionId,
    required String input,
    required String inputMethod, // 'text' or 'voice'
  }) async {
    final logger = AppLogger.instance;
    final stopwatch = Stopwatch()..start();

    // 1. Fetch Transaction
    final transaction = await _db.transactionDao.getById(transactionId);
    if (transaction == null) {
      debugPrint('[InteractionService] Transaction not found: $transactionId');
      return;
    }

    // 2. Log initial user response
    final responseId = await _db.userResponseDao.logResponse(
      transactionId: transactionId,
      inputMethod: inputMethod,
      rawInput: input,
      merchantAtTime: transaction.rawMerchantId,
      amountAtTime: transaction.amount,
    );

    // 3. Construct Prompt for Gemini
    final prompt = _buildPrompt(transaction, input);

    // 4. Call Gemini
    final aiResponse = await _gemini.generateContent(prompt);
    stopwatch.stop();

    if (aiResponse == null) {
      logger.logGeminiResponse(
        operation: 'interaction',
        success: false,
        latencyMs: stopwatch.elapsedMilliseconds,
        errorMessage: 'Gemini returned null',
      );
      return;
    }

    // 5. Parse AI Response
    try {
      final parsed = _parseJson(aiResponse);
      final category = parsed['category'] as String?;
      final item = parsed['item'] as String?; // Mapped to subcategory
      final reasoning = parsed['reasoning'] as String?;

      if (category != null) {
        // 6. Update Transaction
        await _db.transactionDao.updateCategory(
          transactionId,
          category,
        );

        // 7. Update UserResponse with AI interpretation
        await _db.userResponseDao.updateAiInterpretation(
          responseId,
          geminiInterpretation: aiResponse,
          geminiCategory: category,
          geminiSubcategory: item,
          geminiReasoning: reasoning,
          finalCategory: category,
        );

        // 8. Update Merchant Intelligence (Async)
        _updateMerchantIntelligence(transaction.rawMerchantId, category, item);
      }
    } catch (e) {
      debugPrint('[InteractionService] Error parsing AI response: $e');
    }
  }

  String _buildPrompt(Transaction transaction, String input) {
    return '''
User Input: "$input"
Transaction Context:
- Merchant: ${transaction.merchantName ?? transaction.rawMerchantId ?? "Unknown"}
- Amount: ${transaction.amount}
- Time: ${DateTime.fromMillisecondsSinceEpoch(transaction.timestamp).toString()}

Task: Interpret the user's input to categorize this transaction.
1. Identify the 'category' (e.g., Food, Travel, Grocery, Bills, Entertainment, Health).
2. Identify the specific 'item' (e.g., Milk, Uber, Movie).
3. Provide brief 'reasoning'.

Respond ONLY in JSON:
{
  "category": "Grocery",
  "item": "Milk",
  "reasoning": "User said 'Doodh' which means Milk"
}
''';
  }

  Map<String, dynamic> _parseJson(String text) {
    // Extract JSON from potential markdown
    String jsonStr = text;
    if (text.contains('```json')) {
      jsonStr = text.split('```json')[1].split('```')[0].trim();
    } else if (text.contains('```')) {
      jsonStr = text.split('```')[1].split('```')[0].trim();
    }
    return jsonDecode(jsonStr);
  }

  Future<void> _updateMerchantIntelligence(
    String? merchantId,
    String category,
    String? item,
  ) async {
    if (merchantId == null) return;
    
    // Normalize ID
    final id = merchantId.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '').trim();
    
    // Check existing intelligence
    final intelligence = await _db.merchantIntelligenceDao.get(id);
    
    // Simple update for now (Placeholder for deeper Deep Brain analysis)
    // In future, this will append to history and re-summarize
    await _db.merchantIntelligenceDao.upsert(
      id: id,
      historySummary: "User bought $item ($category)",
      spendingPatterns: intelligence?.spendingPatterns, // Keep existing
      typicalAmount: intelligence?.typicalAmount, // Keep existing
    );
     
    // Also update basic Merchant mapping
    await _db.merchantDao.learnCategory(
      id: id,
      rawId: merchantId,
      category: category,
    );
  }
}
