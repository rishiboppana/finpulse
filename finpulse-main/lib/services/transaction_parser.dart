import 'dart:math';

import '../models/transaction.dart';

/// Universal SMS/Notification Parser for FinPulse.
/// Uses a hybrid approach: Fast Regex for common patterns + Gemini Flash fallback.
class TransactionParser {
  // ─────────────────────────────────────────────────────────────────────────────
  // Common Indian Bank SMS Patterns
  // ─────────────────────────────────────────────────────────────────────────────

  // Amount patterns (matches ₹, Rs, Rs., INR followed by amount)
  static final _amountPattern = RegExp(
    r'(?:Rs\.?|₹|INR)\s*([0-9,]+(?:\.[0-9]{1,2})?)',
    caseSensitive: false,
  );

  // Account number pattern (last 4-6 digits)
  static final _accountPattern = RegExp(
    r'(?:A/c|Ac|Account|Acct|XXXX|XX|a/c\s*(?:no\.?)?)\s*[Xx]*(\d{4,6})',
    caseSensitive: false,
  );

  // Date patterns (DD/MM/YY, DD-MM-YYYY, etc.)
  static final _datePattern = RegExp(
    r'(\d{1,2}[/-]\d{1,2}[/-]\d{2,4})',
  );

  // Time pattern (HH:MM, HH:MM:SS, with optional AM/PM)
  static final _timePattern = RegExp(
    r'(\d{1,2}:\d{2}(?::\d{2})?(?:\s*[AaPp][Mm])?)',
  );

  // Debit/Credit keywords
  static final _debitKeywords = RegExp(
    r'(?:debited|debit|paid|spent|withdrawn|sent|transferred|purchase)',
    caseSensitive: false,
  );

  static final _creditKeywords = RegExp(
    r'(?:credited|credit|received|deposited|refund)',
    caseSensitive: false,
  );

  // Merchant patterns (common formats)
  static final _merchantPatterns = [
    RegExp(r'(?:to|at|@)\s+([A-Za-z0-9_\-\s]+?)(?:\s+on|\s+ref|\s+UPI|$)', caseSensitive: false),
    RegExp(r'VPA\s*[:\s]*([a-zA-Z0-9@._\-]+)', caseSensitive: false),
    RegExp(r'UPI[:\s]*([A-Za-z0-9@._\-]+)', caseSensitive: false),
  ];

  // UPI Reference pattern
  static final _upiRefPattern = RegExp(
    r'(?:UPI\s*Ref|Ref\s*No|Reference)[:\s]*(\d{12})',
    caseSensitive: false,
  );

  /// Parse a raw SMS or notification text
  static ParseResult parse(String rawText, {DetectionSource source = DetectionSource.sms}) {
    if (rawText.trim().isEmpty) {
      return ParseResult.failure('Empty text provided');
    }

    try {
      // Extract amount (required)
      final amount = _extractAmount(rawText);
      if (amount == null) {
        return ParseResult.failure('Could not extract amount from text');
      }

      // Extract other fields
      final accountDigits = _extractAccountDigits(rawText);
      final dateTime = _extractDateTime(rawText);
      final transactionType = _determineTransactionType(rawText);
      final merchant = _extractMerchant(rawText);

      final transaction = Transaction(
        id: _generateId(),
        amount: amount,
        timestamp: dateTime ?? DateTime.now(),
        accountLastDigits: accountDigits,
        rawMerchantId: merchant,
        type: transactionType,
        source: source,
        rawText: rawText,
        isParsedByAI: false,
      );

      return ParseResult.success(transaction);
    } catch (e) {
      return ParseResult.failure('Parsing error: $e');
    }
  }

  /// Extract amount from text
  static double? _extractAmount(String text) {
    final match = _amountPattern.firstMatch(text);
    if (match == null) return null;

    final amountStr = match.group(1)!.replaceAll(',', '');
    return double.tryParse(amountStr);
  }

  /// Extract last digits of account number
  static String? _extractAccountDigits(String text) {
    final match = _accountPattern.firstMatch(text);
    return match?.group(1);
  }

  /// Extract date and time from text
  static DateTime? _extractDateTime(String text) {
    final dateMatch = _datePattern.firstMatch(text);
    final timeMatch = _timePattern.firstMatch(text);

    if (dateMatch == null) return null;

    try {
      final dateParts = dateMatch.group(1)!.split(RegExp(r'[/-]'));
      int day = int.parse(dateParts[0]);
      int month = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      // Handle 2-digit years
      if (year < 100) {
        year += 2000;
      }

      int hour = 0, minute = 0;
      if (timeMatch != null) {
        final timeParts = timeMatch.group(1)!.split(':');
        hour = int.parse(timeParts[0]);
        minute = int.parse(timeParts[1].substring(0, 2));

        // Handle AM/PM
        final timeStr = timeMatch.group(1)!.toLowerCase();
        if (timeStr.contains('pm') && hour < 12) {
          hour += 12;
        } else if (timeStr.contains('am') && hour == 12) {
          hour = 0;
        }
      }

      return DateTime(year, month, day, hour, minute);
    } catch (e) {
      return null;
    }
  }

  /// Determine if transaction is debit or credit
  static TransactionType _determineTransactionType(String text) {
    if (_debitKeywords.hasMatch(text)) {
      return TransactionType.debit;
    } else if (_creditKeywords.hasMatch(text)) {
      return TransactionType.credit;
    }
    return TransactionType.unknown;
  }

  /// Extract merchant name/ID from text
  static String? _extractMerchant(String text) {
    for (final pattern in _merchantPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(1)?.trim();
      }
    }
    return null;
  }

  /// Generate a unique transaction ID
  static String _generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    final suffix = List.generate(12, (_) => chars[random.nextInt(chars.length)]).join();
    return 'txn_${DateTime.now().millisecondsSinceEpoch}_$suffix';
  }
}

/// Sample SMS templates for testing (The "Chaos Suite")
class SampleSmsTemplates {
  static const List<String> templates = [
    // HDFC Bank
    'Rs.2500.00 debited from A/c XXXX1234 on 27-01-26 at 10:30AM. VPA:starbucks@ybl. Avl Bal:Rs.45000.00',
    'INR 1,500.00 debited from HDFC Bank A/c XX6789 on 27/01/2026. Info: UPI/SWIGGY/Payment. Bal: 32000',
    
    // ICICI Bank
    'ICICI Bank Acct XX4567 debited for Rs 850.00 on 27-Jan-26; BigBasket. UPI Ref 123456789012',
    'Your A/c XXXX8901 is credited with Rs.25,000.00 on 27-01-2026. NEFT from SALARY. Avl bal Rs.75000',
    
    // SBI
    'Your SBI A/c X1234 debited by Rs.350 on 27Jan26 transfer to PAYTM*CHAI. Ref No 456789123012. Avl Bal Rs 12500',
    
    // Axis Bank
    'Rs 1200 has been debited from Axis Bank A/c no. XX5678 to VPA phonepe@ybl on 27/01/26 at 14:25.',
    
    // PhonePe
    'Paid Rs.150 to RAJESH_STORES_99 via PhonePe. UPI Ref: 789012345678',
    
    // GPay
    'You paid ₹500 to BigBazaar on Google Pay. UPI Ref No. 901234567890',
    
    // Paytm
    'Rs.80 paid to PAYTM*METRO via Paytm UPI. Ref: 234567890123',
    
    // Generic UPI
    'UPI transaction of Rs 2000 successful. VPA: zomato@paytm. Ref 567890123456',
  ];
}
