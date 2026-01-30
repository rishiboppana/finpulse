/// Transaction model for detected payments.
/// Stores the extracted data from SMS/Notifications for the "Golden Window" flow.

enum TransactionType {
  debit,
  credit,
  unknown,
}

enum DetectionSource {
  sms,
  notification,
  accessibility,
  manual, // Mock generator or user-triggered
}

class Transaction {
  final String id;
  final double amount;
  final String currency;
  final DateTime timestamp;
  final String? accountLastDigits;
  final String? rawMerchantId; // The cryptic merchant string
  final String? merchantName; // User-friendly name (learned over time)
  final String? category; // User-tagged category
  final TransactionType type;
  final DetectionSource source;
  final String rawText; // Original SMS/notification text
  final bool isParsedByAI; // True if Gemini was used

  const Transaction({
    required this.id,
    required this.amount,
    this.currency = 'INR',
    required this.timestamp,
    this.accountLastDigits,
    this.rawMerchantId,
    this.merchantName,
    this.category,
    this.type = TransactionType.debit,
    required this.source,
    required this.rawText,
    this.isParsedByAI = false,
  });

  /// Create from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'INR',
      timestamp: DateTime.parse(json['timestamp'] as String),
      accountLastDigits: json['accountLastDigits'] as String?,
      rawMerchantId: json['rawMerchantId'] as String?,
      merchantName: json['merchantName'] as String?,
      category: json['category'] as String?,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.unknown,
      ),
      source: DetectionSource.values.firstWhere(
        (e) => e.name == json['source'],
        orElse: () => DetectionSource.manual,
      ),
      rawText: json['rawText'] as String,
      isParsedByAI: json['isParsedByAI'] as bool? ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'currency': currency,
      'timestamp': timestamp.toIso8601String(),
      'accountLastDigits': accountLastDigits,
      'rawMerchantId': rawMerchantId,
      'merchantName': merchantName,
      'category': category,
      'type': type.name,
      'source': source.name,
      'rawText': rawText,
      'isParsedByAI': isParsedByAI,
    };
  }

  /// Create a copy with updated fields
  Transaction copyWith({
    String? id,
    double? amount,
    String? currency,
    DateTime? timestamp,
    String? accountLastDigits,
    String? rawMerchantId,
    String? merchantName,
    String? category,
    TransactionType? type,
    DetectionSource? source,
    String? rawText,
    bool? isParsedByAI,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      timestamp: timestamp ?? this.timestamp,
      accountLastDigits: accountLastDigits ?? this.accountLastDigits,
      rawMerchantId: rawMerchantId ?? this.rawMerchantId,
      merchantName: merchantName ?? this.merchantName,
      category: category ?? this.category,
      type: type ?? this.type,
      source: source ?? this.source,
      rawText: rawText ?? this.rawText,
      isParsedByAI: isParsedByAI ?? this.isParsedByAI,
    );
  }

  /// Format amount with INR symbol (Indian formatting)
  String get formattedAmount {
    final parts = amount.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    // Indian number formatting (e.g., 1,23,456.78)
    String formatted = '';
    int count = 0;
    for (int i = intPart.length - 1; i >= 0; i--) {
      if (count == 3 || (count > 3 && (count - 3) % 2 == 0)) {
        formatted = ',$formatted';
      }
      formatted = intPart[i] + formatted;
      count++;
    }

    return '₹$formatted.$decPart';
  }

  @override
  String toString() =>
      'Transaction(id: $id, amount: $formattedAmount, merchant: $rawMerchantId)';
}

/// Result of parsing an SMS/notification
class ParseResult {
  final bool success;
  final Transaction? transaction;
  final String? errorMessage;
  final bool usedAI;

  const ParseResult({
    required this.success,
    this.transaction,
    this.errorMessage,
    this.usedAI = false,
  });

  factory ParseResult.success(Transaction transaction, {bool usedAI = false}) =>
      ParseResult(success: true, transaction: transaction, usedAI: usedAI);

  factory ParseResult.failure(String message) =>
      ParseResult(success: false, errorMessage: message);
}
