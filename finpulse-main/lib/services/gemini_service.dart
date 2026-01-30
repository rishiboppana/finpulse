import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/transaction.dart';
import 'transaction_parser.dart';

/// Gemini AI Service for parsing complex SMS templates.
/// Uses Gemini 3 Flash for fast, accurate extraction when Regex fails.
class GeminiService {
  // TODO: Replace with your actual Gemini API key
  static const String _apiKey = 'YOUR_GEMINI_API_KEY';
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

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

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.1,
            'maxOutputTokens': 256,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        
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
      }

      return ParseResult.failure('Gemini API returned unexpected response');
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
