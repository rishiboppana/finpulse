import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/transaction.dart';
import '../database/database.dart' hide Transaction;
import 'transaction_parser.dart';
import 'app_logger.dart';

/// Gemini AI Service for parsing complex SMS templates.
/// Uses Gemini 2.0 Flash for fast, accurate extraction when Regex fails.
class GeminiService {
  // API key from environment variable (secure)
  static String get _apiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  // Singleton instance
  static final GeminiService instance = GeminiService._();
  GeminiService._();

  static GenerativeModel? _model;

  static GenerativeModel get model {
    if (_apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not configured in .env file');
    }
    _model ??= GenerativeModel(
      model: 'gemini-2.5-flash',  // Updated to available model
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.1,
        maxOutputTokens: 256,
      ),
    );
    return _model!;
  }

  /// Generate text content using Gemini with retry logic
  /// Handles rate limiting (429) with longer backoff
  Future<String?> generateContent(String prompt, {int maxRetries = 3}) async {
    final logger = AppLogger.instance;
    final stopwatch = Stopwatch()..start();

    logger.logGeminiRequest(
      operation: 'generateContent',
      promptPreview: prompt,
    );

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        final response = await model.generateContent([Content.text(prompt)]);
        stopwatch.stop();

        logger.logGeminiResponse(
          operation: 'generateContent',
          success: true,
          responsePreview: response.text,
          latencyMs: stopwatch.elapsedMilliseconds,
        );

        return response.text;
      } catch (e) {
        final errorStr = e.toString().toLowerCase();
        final isRateLimit = errorStr.contains('429') || 
                           errorStr.contains('quota') || 
                           errorStr.contains('rate') ||
                           errorStr.contains('too many');

        debugPrint('[GeminiService] Attempt ${attempt + 1} failed: $e');
        
        if (attempt < maxRetries) {
          // Use longer delay for rate limiting (5s, 10s, 20s)
          // Use shorter delay for other errors (1s, 2s, 4s)
          final baseDelay = isRateLimit ? 5000 : 1000;
          final delayMs = baseDelay * (attempt + 1);
          
          debugPrint('[GeminiService] ${isRateLimit ? "⏳ Rate limited" : "⚠️ Error"}, waiting ${delayMs}ms before retry...');
          await Future.delayed(Duration(milliseconds: delayMs));
        }
      }
    }

    stopwatch.stop();
    logger.logGeminiResponse(
      operation: 'generateContent',
      success: false,
      latencyMs: stopwatch.elapsedMilliseconds,
      errorMessage: 'All retry attempts failed',
    );

    debugPrint('[GeminiService] All retry attempts failed');
    return null;
  }

  /// Check if text represents a CONFIRMED, COMPLETED transaction
  /// Returns true if it's a real transaction, false if it's promotional/warning
  static Future<bool> isConfirmedTransaction(String text) async {
    final logger = AppLogger.instance;
    final stopwatch = Stopwatch()..start();
    
    debugPrint('[GeminiService] 🔍 Intent Check Starting...');
    logger.logGeminiRequest(
      operation: 'intentCheck',
      promptPreview: 'Checking: ${text.substring(0, text.length > 50 ? 50 : text.length)}...',
    );
    
    try {
      final prompt = '''Analyze this message and determine if it describes a CONFIRMED, ALREADY-COMPLETED financial transaction.

Rules:
- "debited", "credited", "paid", "sent", "received" = COMPLETED transaction = YES
- "will be debited", "will be charged", "if balance is maintained" = FUTURE/CONDITIONAL = NO
- "offer", "cashback available", "recharge expiring" = PROMOTIONAL = NO
- Balance alerts without transaction = NO

Reply with ONLY one word: YES or NO

Message: "$text"''';
      
      final response = await instance.generateContent(prompt, maxRetries: 1);
      stopwatch.stop();
      
      final isTransaction = response?.toUpperCase().contains('YES') ?? false;
      
      logger.logGeminiResponse(
        operation: 'intentCheck',
        success: true,
        responsePreview: 'Intent: ${isTransaction ? "TRANSACTION" : "NOT_TRANSACTION"}',
        latencyMs: stopwatch.elapsedMilliseconds,
      );
      
      debugPrint('[GeminiService] ✅ Intent Check: ${isTransaction ? "✅ CONFIRMED TRANSACTION" : "❌ NOT A TRANSACTION"} (${stopwatch.elapsedMilliseconds}ms)');
      return isTransaction;
    } catch (e) {
      stopwatch.stop();
      logger.logGeminiResponse(
        operation: 'intentCheck',
        success: false,
        latencyMs: stopwatch.elapsedMilliseconds,
        errorMessage: e.toString(),
      );
      
      debugPrint('[GeminiService] ⚠️ Intent Check FAILED: $e - defaulting to true (fail-open)');
      return true; // Fail-open: if Gemini fails, proceed with parsing
    }
  }

  /// Analyze a receipt image using Gemini Vision
  /// Returns parsed receipt data in JSON format
  Future<Map<String, dynamic>?> analyzeReceiptImage(
    List<int> imageBytes,
  ) async {
    try {
      final visionModel = GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.1,
          maxOutputTokens: 1024,
        ),
      );

      final prompt = '''
Analyze this receipt/bill image and extract the following information:
1. merchant_name: The store/shop/restaurant name
2. date: The transaction date (in YYYY-MM-DD format if visible)
3. items: Array of items, each with "name", "price" (number), and "quantity" (default 1)
4. total: The total amount paid (number only)
5. category: Suggested category (Groceries, Food, Transport, Shopping, Bills, Healthcare, Entertainment, Other)

Important rules:
- Extract ONLY what you can clearly see in the image
- For prices, extract the number without currency symbol
- If you can't read something clearly, make your best guess
- If no items are visible, create a single item with the total amount

Respond ONLY with valid JSON in this exact format:
{
  "merchant_name": "Store Name",
  "date": "2026-01-31",
  "items": [
    {"name": "Item 1", "price": 50.00, "quantity": 1},
    {"name": "Item 2", "price": 30.00, "quantity": 2}
  ],
  "total": 110.00,
  "category": "Groceries",
  "confidence": 0.85
}
''';

      final response = await visionModel.generateContent([
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', Uint8List.fromList(imageBytes)),
        ]),
      ]);

      final text = response.text;
      if (text != null) {
        // Extract JSON from response (handle markdown code blocks)
        String jsonStr = text;
        if (text.contains('```json')) {
          jsonStr = text.split('```json')[1].split('```')[0].trim();
        } else if (text.contains('```')) {
          jsonStr = text.split('```')[1].split('```')[0].trim();
        }

        return jsonDecode(jsonStr) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('[GeminiService] Error analyzing receipt: $e');
      return null;
    }
  }

  /// Parse SMS with AI (wrapper for static method)
  Future<ParseResult> parseSmsWithAI(
    String rawText,
    DetectionSource source,
  ) async {
    return GeminiService.parseWithAI(rawText, source: source);
  }

  /// Parse SMS text using Gemini AI
  static Future<ParseResult> parseWithAI(
    String rawText, {
    DetectionSource source = DetectionSource.sms,
  }) async {
    // First, try regex-based parsing
    final regexResult = TransactionParser.parse(rawText, source: source);
    if (regexResult.success && regexResult.transaction!.amount > 0) {
      return regexResult;
    }

    // If regex failed, use Gemini with learning context
    try {
      // Fetch user's past corrections for this merchant (if available)
      String learningContext = '';
      try {
        final db = AppDatabase.instance;
        // Extract potential merchant from raw text
        final merchantMatch = RegExp(
          r'(?:to|at|@)\s+([A-Za-z0-9_\-]+)',
          caseSensitive: false,
        ).firstMatch(rawText);
        final merchantId = merchantMatch?.group(1);

        if (merchantId != null) {
          final context = await db.userResponseDao.buildLearningContext(
            merchantId,
          );
          if (context.isNotEmpty) {
            final merchantHistory =
                context['merchant_history'] as Map<String, dynamic>?;
            if (merchantHistory != null &&
                merchantHistory['most_common'] != null) {
              learningContext =
                  '''
USER HISTORY:
- This merchant was previously categorized as: ${merchantHistory['most_common']}
- Times seen: ${merchantHistory['times_seen']}
''';
            }
          }
        }
      } catch (e) {
        debugPrint('[GeminiService] Could not fetch learning context: $e');
      }

      final prompt =
          '''
You are a financial SMS parser for Indian bank transactions. Extract the following from this SMS:
1. amount (number only, no currency symbol)
2. date (ISO format: YYYY-MM-DD)
3. time (24hr format: HH:MM)
4. account_last_digits (last 4-6 digits of account)
5. merchant_id (raw merchant name/UPI VPA)
6. type (debit or credit)

$learningContext
SMS Text: "$rawText"

Respond ONLY with valid JSON in this exact format:
{
  "amount": 150.00,
  "date": "2026-01-27",
  "time": "14:30",
  "account_last_digits": "1234",
  "merchant_id": "STARBUCKS@ybl",
  "type": "debit"
}

If you cannot extract a field, use null. Always return valid JSON.
''';

      final response = await model.generateContent([Content.text(prompt)]);
      final text = response.text;

      if (text != null) {
        // Extract JSON from response (handle markdown code blocks)
        String jsonStr = text;
        if (text.contains('```json')) {
          jsonStr = text.split('```json')[1].split('```')[0].trim();
        } else if (text.contains('```')) {
          jsonStr = text.split('```')[1].split('```')[0].trim();
        }

        final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;

        DateTime? timestamp;
        if (parsed['date'] != null) {
          final dateStr = parsed['date'] as String;
          final timeStr = (parsed['time'] as String?) ?? '00:00';
          timestamp = DateTime.tryParse('${dateStr}T$timeStr:00');
        }

        final transaction = Transaction(
          id: 'txn_ai_${DateTime.now().millisecondsSinceEpoch}',
          amount: (parsed['amount'] as num?)?.toDouble() ?? 0.0,
          timestamp: timestamp ?? DateTime.now(),
          accountLastDigits: parsed['account_last_digits'] as String?,
          rawMerchantId: parsed['merchant_id'] as String?,
          type: parsed['type'] == 'credit'
              ? TransactionType.credit
              : TransactionType.debit,
          source: source,
          rawText: rawText,
          isParsedByAI: true,
        );

        return ParseResult.success(transaction, usedAI: true);
      }

      return ParseResult.failure('Gemini API returned empty response');
    } catch (e) {
      return ParseResult.failure('Gemini parsing error: $e');
    }
  }

  /// Mock Gemini response for demo purposes (no API key needed)
  static ParseResult mockParseWithAI(
    String rawText, {
    DetectionSource source = DetectionSource.sms,
  }) {
    // First, try regex-based parsing
    final regexResult = TransactionParser.parse(rawText, source: source);
    if (regexResult.success) {
      // Mark as AI-parsed for demo and link to dummy account
      return ParseResult.success(
        regexResult.transaction!.copyWith(
          isParsedByAI: true,
          accountLastDigits: '4521', // Link all to dummy HDFC account
        ),
        usedAI: true,
      );
    }

    // Simulate AI parsing for demo
    // Extract any number that looks like an amount
    final amountMatch = RegExp(
      r'(\d+(?:,\d+)*(?:\.\d{1,2})?)',
    ).firstMatch(rawText);
    final amount = amountMatch != null
        ? double.tryParse(amountMatch.group(1)!.replaceAll(',', '')) ?? 100.0
        : 100.0;

    final transaction = Transaction(
      id: 'txn_ai_mock_${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      timestamp: DateTime.now(),
      rawMerchantId: 'AI_DETECTED_MERCHANT',
      type: TransactionType.debit,
      source: source,
      rawText: rawText,
      isParsedByAI: true,
      accountLastDigits: '4521', // Link all to dummy HDFC account
    );

    return ParseResult.success(transaction, usedAI: true);
  }
}
