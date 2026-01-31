import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/transaction.dart';
import 'transaction_parser.dart';

/// Gemini AI Service for parsing complex SMS templates.
/// Uses Gemini 3 Flash for fast, accurate extraction when Regex fails.
class GeminiService {
  static const String _apiKey = 'AIzaSyCyKaSO5hp0indMCVdTYW9cuk0a02tuhfk';
  
  // Singleton instance
  static final GeminiService instance = GeminiService._();
  GeminiService._();
  
  static GenerativeModel? _model;
  
  static GenerativeModel get model {
    _model ??= GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.1,
        maxOutputTokens: 256,
      ),
    );
    return _model!;
  }

  /// Generate text content using Gemini
  Future<String?> generateContent(String prompt) async {
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text;
    } catch (e) {
      return null;
    }
  }

  /// Analyze a receipt image using Gemini Vision
  /// Returns parsed receipt data in JSON format
  Future<Map<String, dynamic>?> analyzeReceiptImage(List<int> imageBytes) async {
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
          DataPart('image/jpeg', imageBytes as Uint8List),
        ])
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
      print('Error analyzing receipt: $e');
      return null;
    }
  }

  /// Parse SMS with AI (wrapper for static method)
  Future<ParseResult> parseSmsWithAI(String rawText, DetectionSource source) async {
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

    // If regex failed, use Gemini
    try {
      final prompt = '''
You are a financial SMS parser for Indian bank transactions. Extract the following from this SMS:
1. amount (number only, no currency symbol)
2. date (ISO format: YYYY-MM-DD)
3. time (24hr format: HH:MM)
4. account_last_digits (last 4-6 digits of account)
5. merchant_id (raw merchant name/UPI VPA)
6. type (debit or credit)

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
      // Mark as AI-parsed for demo
      return ParseResult.success(
        regexResult.transaction!.copyWith(isParsedByAI: true),
        usedAI: true,
      );
    }

    // Simulate AI parsing for demo
    // Extract any number that looks like an amount
    final amountMatch = RegExp(r'(\d+(?:,\d+)*(?:\.\d{1,2})?)').firstMatch(rawText);
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
    );

    return ParseResult.success(transaction, usedAI: true);
  }
}
