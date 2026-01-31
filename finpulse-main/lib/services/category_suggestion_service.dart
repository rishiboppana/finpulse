import 'package:flutter/foundation.dart';
import 'gemini_service.dart';

/// Service that uses Gemini AI to suggest categories for transactions
class CategorySuggestionService {
  static final CategorySuggestionService instance = CategorySuggestionService._();
  CategorySuggestionService._();

  /// Default categories used as fallback
  static const List<Map<String, String>> defaultCategories = [
    {'name': 'Food', 'emoji': '🍕'},
    {'name': 'Groceries', 'emoji': '🛒'},
    {'name': 'Transport', 'emoji': '🚗'},
    {'name': 'Shopping', 'emoji': '🛍️'},
  ];

  /// Category definitions with emojis
  static const Map<String, String> categoryEmojis = {
    'Food': '🍕',
    'Groceries': '🛒',
    'Transport': '🚗',
    'Shopping': '🛍️',
    'Entertainment': '🎬',
    'Coffee': '☕',
    'Fuel': '⛽',
    'Health': '💊',
    'Bills': '📄',
    'Subscription': '📱',
    'Travel': '✈️',
    'Dining': '🍽️',
    'Fitness': '💪',
    'Education': '📚',
    'Electronics': '📱',
    'Gifts': '🎁',
    'Personal Care': '💇',
    'Home': '🏠',
    'Utilities': '💡',
    'Other': '📦',
  };

  /// Get AI-suggested categories based on transaction details
  /// Returns a list of category suggestions with emojis
  Future<List<Map<String, String>>> suggestCategories({
    required String amount,
    required String merchant,
    required String rawText,
  }) async {
    try {
      // Build prompt for Gemini
      final prompt = '''
You are a financial categorization AI. Based on the transaction below, suggest 3-4 most likely spending categories.

Transaction Details:
- Amount: ₹$amount
- Merchant: $merchant
- Raw Message: $rawText

Available categories: Food, Groceries, Transport, Shopping, Entertainment, Coffee, Fuel, Health, Bills, Subscription, Travel, Dining, Fitness, Education, Electronics, Gifts, Personal Care, Home, Utilities, Other

Respond with ONLY a comma-separated list of 3-4 category names, most likely first.
Example response: Food, Dining, Entertainment

Your response:''';

      // Get AI response
      final response = await GeminiService.instance.generateContent(prompt);
      
      if (response != null && response.isNotEmpty) {
        return _parseCategories(response);
      }
    } catch (e) {
      debugPrint('CategorySuggestionService error: $e');
    }

    // Return default categories on error
    return defaultCategories;
  }

  /// Parse Gemini response into category list
  List<Map<String, String>> _parseCategories(String response) {
    try {
      // Split by comma and clean up
      final categories = response
          .split(',')
          .map((c) => c.trim())
          .where((c) => c.isNotEmpty && categoryEmojis.containsKey(c))
          .take(4)
          .toList();

      if (categories.isEmpty) {
        return defaultCategories;
      }

      return categories.map((name) {
        return {
          'name': name,
          'emoji': categoryEmojis[name] ?? '📦',
        };
      }).toList();
    } catch (e) {
      debugPrint('Error parsing categories: $e');
      return defaultCategories;
    }
  }

  /// Quick category suggestion based on merchant name (no API call)
  /// Uses simple keyword matching for instant suggestions
  List<Map<String, String>> quickSuggest(String merchant) {
    final lowerMerchant = merchant.toLowerCase();
    final suggestions = <Map<String, String>>[];

    // Food & Dining
    if (_matchesAny(lowerMerchant, ['zomato', 'swiggy', 'domino', 'mcdonald', 'kfc', 'pizza', 'burger', 'restaurant', 'cafe', 'food'])) {
      suggestions.add({'name': 'Food', 'emoji': '🍕'});
      suggestions.add({'name': 'Dining', 'emoji': '🍽️'});
    }

    // Coffee
    if (_matchesAny(lowerMerchant, ['starbucks', 'ccd', 'coffee', 'cafe'])) {
      suggestions.add({'name': 'Coffee', 'emoji': '☕'});
    }

    // Groceries
    if (_matchesAny(lowerMerchant, ['bigbasket', 'zepto', 'blinkit', 'dmrt', 'grocery', 'mart', 'store', 'supermarket', 'reliance'])) {
      suggestions.add({'name': 'Groceries', 'emoji': '🛒'});
    }

    // Transport
    if (_matchesAny(lowerMerchant, ['uber', 'ola', 'rapido', 'metro', 'irctc', 'railway', 'cab', 'taxi', 'auto'])) {
      suggestions.add({'name': 'Transport', 'emoji': '🚗'});
    }

    // Fuel
    if (_matchesAny(lowerMerchant, ['petrol', 'diesel', 'fuel', 'hp', 'iocl', 'bpcl', 'shell', 'gas station'])) {
      suggestions.add({'name': 'Fuel', 'emoji': '⛽'});
    }

    // Shopping
    if (_matchesAny(lowerMerchant, ['amazon', 'flipkart', 'myntra', 'ajio', 'nykaa', 'shopping', 'mall', 'store'])) {
      suggestions.add({'name': 'Shopping', 'emoji': '🛍️'});
    }

    // Entertainment
    if (_matchesAny(lowerMerchant, ['netflix', 'hotstar', 'prime', 'spotify', 'pvr', 'inox', 'movie', 'cinema', 'theatre'])) {
      suggestions.add({'name': 'Entertainment', 'emoji': '🎬'});
    }

    // Bills & Subscriptions
    if (_matchesAny(lowerMerchant, ['airtel', 'jio', 'vodafone', 'bsnl', 'electricity', 'water', 'gas', 'bill'])) {
      suggestions.add({'name': 'Bills', 'emoji': '📄'});
    }

    // Health
    if (_matchesAny(lowerMerchant, ['apollo', 'medplus', 'netmeds', 'pharmeasy', 'pharmacy', 'hospital', 'clinic', 'doctor'])) {
      suggestions.add({'name': 'Health', 'emoji': '💊'});
    }

    // Add default "Other" if no matches
    if (suggestions.isEmpty) {
      suggestions.addAll(defaultCategories);
    }

    // Ensure we have at least 3 options, pad with defaults
    while (suggestions.length < 3) {
      for (final cat in defaultCategories) {
        if (!suggestions.any((s) => s['name'] == cat['name'])) {
          suggestions.add(cat);
          if (suggestions.length >= 4) break;
        }
      }
    }

    return suggestions.take(4).toList();
  }

  bool _matchesAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }
}
