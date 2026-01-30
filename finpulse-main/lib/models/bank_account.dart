/// Bank account model for FinPulse.
/// Designed for India market with support for UPI, Savings, Current accounts.
/// Structure compatible with future integration with Account Aggregator (AA) framework.

enum AccountType {
  savings,
  current,
  creditCard,
  wallet,  // For UPI wallets like Paytm, PhonePe
  fixedDeposit,
  recurringDeposit,
}

class BankAccount {
  final String id;
  final String oderId; // Owner user ID
  final String institutionId; // Bank identifier (e.g., "hdfc", "icici")
  final String institutionName; // Display name (e.g., "HDFC Bank")
  final String accountName; // User's label (e.g., "Salary Account")
  final AccountType accountType;
  final String maskedNumber; // Last 4 digits (e.g., "•••• 1234")
  final double balance;
  final String currency; // INR for India
  final bool isActive;
  final bool isPrimary; // Primary account for transactions
  final DateTime linkedAt;
  final DateTime? lastSyncAt;
  final String? ifscCode; // Indian bank IFSC code
  final String? upiId; // UPI ID if linked

  const BankAccount({
    required this.id,
    required this.oderId,
    required this.institutionId,
    required this.institutionName,
    required this.accountName,
    required this.accountType,
    required this.maskedNumber,
    required this.balance,
    this.currency = 'INR',
    this.isActive = true,
    this.isPrimary = false,
    required this.linkedAt,
    this.lastSyncAt,
    this.ifscCode,
    this.upiId,
  });

  /// Create from JSON (API response / local storage)
  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'] as String,
      oderId: json['userId'] as String,
      institutionId: json['institutionId'] as String,
      institutionName: json['institutionName'] as String,
      accountName: json['accountName'] as String,
      accountType: AccountType.values.firstWhere(
        (e) => e.name == json['accountType'],
        orElse: () => AccountType.savings,
      ),
      maskedNumber: json['maskedNumber'] as String,
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'INR',
      isActive: json['isActive'] as bool? ?? true,
      isPrimary: json['isPrimary'] as bool? ?? false,
      linkedAt: DateTime.parse(json['linkedAt'] as String),
      lastSyncAt: json['lastSyncAt'] != null
          ? DateTime.parse(json['lastSyncAt'] as String)
          : null,
      ifscCode: json['ifscCode'] as String?,
      upiId: json['upiId'] as String?,
    );
  }

  /// Convert to JSON (for storage / API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': oderId,
      'institutionId': institutionId,
      'institutionName': institutionName,
      'accountName': accountName,
      'accountType': accountType.name,
      'maskedNumber': maskedNumber,
      'balance': balance,
      'currency': currency,
      'isActive': isActive,
      'isPrimary': isPrimary,
      'linkedAt': linkedAt.toIso8601String(),
      'lastSyncAt': lastSyncAt?.toIso8601String(),
      'ifscCode': ifscCode,
      'upiId': upiId,
    };
  }

  /// Create a copy with updated fields
  BankAccount copyWith({
    String? id,
    String? oderId,
    String? institutionId,
    String? institutionName,
    String? accountName,
    AccountType? accountType,
    String? maskedNumber,
    double? balance,
    String? currency,
    bool? isActive,
    bool? isPrimary,
    DateTime? linkedAt,
    DateTime? lastSyncAt,
    String? ifscCode,
    String? upiId,
  }) {
    return BankAccount(
      id: id ?? this.id,
      oderId: oderId ?? this.oderId,
      institutionId: institutionId ?? this.institutionId,
      institutionName: institutionName ?? this.institutionName,
      accountName: accountName ?? this.accountName,
      accountType: accountType ?? this.accountType,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      isActive: isActive ?? this.isActive,
      isPrimary: isPrimary ?? this.isPrimary,
      linkedAt: linkedAt ?? this.linkedAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      ifscCode: ifscCode ?? this.ifscCode,
      upiId: upiId ?? this.upiId,
    );
  }

  /// Format balance with INR symbol
  String get formattedBalance {
    final parts = balance.toStringAsFixed(2).split('.');
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
  String toString() => 'BankAccount(id: $id, $institutionName - $accountName)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankAccount && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Common Indian banks for the institution picker
class IndianBanks {
  static const List<BankInstitution> banks = [
    BankInstitution(id: 'hdfc', name: 'HDFC Bank', color: 0xFF004C8F),
    BankInstitution(id: 'icici', name: 'ICICI Bank', color: 0xFFB02A30),
    BankInstitution(id: 'sbi', name: 'State Bank of India', color: 0xFF22409A),
    BankInstitution(id: 'axis', name: 'Axis Bank', color: 0xFF97144D),
    BankInstitution(id: 'kotak', name: 'Kotak Mahindra Bank', color: 0xFFED1C24),
    BankInstitution(id: 'pnb', name: 'Punjab National Bank', color: 0xFF1E3A8A),
    BankInstitution(id: 'bob', name: 'Bank of Baroda', color: 0xFFF47920),
    BankInstitution(id: 'canara', name: 'Canara Bank', color: 0xFF004B87),
    BankInstitution(id: 'idbi', name: 'IDBI Bank', color: 0xFF00A651),
    BankInstitution(id: 'yes', name: 'Yes Bank', color: 0xFF0066B3),
    BankInstitution(id: 'indusind', name: 'IndusInd Bank', color: 0xFF880E1B),
    BankInstitution(id: 'federal', name: 'Federal Bank', color: 0xFF003399),
    // UPI Wallets
    BankInstitution(id: 'paytm', name: 'Paytm Wallet', color: 0xFF00B9F1),
    BankInstitution(id: 'phonepe', name: 'PhonePe', color: 0xFF5F259F),
    BankInstitution(id: 'gpay', name: 'Google Pay', color: 0xFF4285F4),
  ];

  static BankInstitution? getById(String id) {
    try {
      return banks.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
}

class BankInstitution {
  final String id;
  final String name;
  final int color; // Brand color as hex int

  const BankInstitution({
    required this.id,
    required this.name,
    required this.color,
  });
}
