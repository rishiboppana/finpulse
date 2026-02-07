import 'dart:math';
import 'package:flutter/foundation.dart';

import '../models/transaction.dart';
import '../models/bank_account.dart';
import 'database_transaction_service.dart';
import 'service_initializer.dart';

/// Service to seed sample data for testing and demo purposes
/// Creates realistic transactions with random categories
class DataSeederService {
  static DataSeederService? _instance;
  static DataSeederService get instance {
    _instance ??= DataSeederService._();
    return _instance!;
  }

  DataSeederService._();

  final _random = Random();

  // Categories with weights (higher = more likely)
  static const List<Map<String, dynamic>> _categoryWeights = [
    {'name': 'Food', 'weight': 25, 'minAmount': 50, 'maxAmount': 800},
    {'name': 'Groceries', 'weight': 20, 'minAmount': 200, 'maxAmount': 3000},
    {'name': 'Transport', 'weight': 15, 'minAmount': 20, 'maxAmount': 500},
    {'name': 'Shopping', 'weight': 12, 'minAmount': 100, 'maxAmount': 5000},
    {'name': 'Bills', 'weight': 10, 'minAmount': 500, 'maxAmount': 5000},
    {'name': 'Entertainment', 'weight': 8, 'minAmount': 100, 'maxAmount': 1500},
    {'name': 'Health', 'weight': 5, 'minAmount': 100, 'maxAmount': 3000},
    {'name': 'Coffee', 'weight': 5, 'minAmount': 100, 'maxAmount': 500},
  ];

  // Merchant names by category
  static const Map<String, List<String>> _merchantsByCategory = {
    'Food': ['Swiggy', 'Zomato', 'Dominos', 'McDonalds', 'KFC', 'Burger King', 'Pizza Hut'],
    'Groceries': ['BigBasket', 'Zepto', 'Blinkit', 'DMart', 'More Supermarket', 'Reliance Fresh'],
    'Transport': ['Uber', 'Ola', 'Rapido', 'Metro Recharge', 'Petrol Pump', 'IRCTC'],
    'Shopping': ['Amazon', 'Flipkart', 'Myntra', 'Ajio', 'Nykaa', 'Meesho'],
    'Bills': ['Electricity Board', 'Airtel', 'Jio', 'Gas Bill', 'Water Bill', 'Broadband'],
    'Entertainment': ['Netflix', 'Spotify', 'Amazon Prime', 'Hotstar', 'BookMyShow', 'PVR'],
    'Health': ['Apollo Pharmacy', '1mg', 'PharmEasy', 'Practo', 'Netmeds'],
    'Coffee': ['Starbucks', 'CCD', 'Blue Tokai', 'Third Wave', 'Tim Hortons'],
  };

  // Sample Indian banks for demo
  static const List<Map<String, String>> _sampleBanks = [
    {'id': 'hdfc', 'name': 'HDFC Bank', 'ifsc': 'HDFC0001234'},
    {'id': 'icici', 'name': 'ICICI Bank', 'ifsc': 'ICIC0001234'},
    {'id': 'sbi', 'name': 'State Bank of India', 'ifsc': 'SBIN0001234'},
  ];

  /// Pick a random category based on weights
  String _pickRandomCategory() {
    int totalWeight = _categoryWeights.fold(0, (sum, c) => sum + (c['weight'] as int));
    int random = _random.nextInt(totalWeight);
    int cumulative = 0;
    
    for (final cat in _categoryWeights) {
      cumulative += cat['weight'] as int;
      if (random < cumulative) {
        return cat['name'] as String;
      }
    }
    return 'Food'; // Default
  }

  /// Get amount range for a category
  Map<String, int> _getAmountRange(String category) {
    final cat = _categoryWeights.firstWhere(
      (c) => c['name'] == category,
      orElse: () => {'minAmount': 50, 'maxAmount': 500},
    );
    return {'min': cat['minAmount'] as int, 'max': cat['maxAmount'] as int};
  }

  /// Pick a random merchant for a category
  String _pickRandomMerchant(String category) {
    final merchants = _merchantsByCategory[category] ?? ['Unknown Merchant'];
    return merchants[_random.nextInt(merchants.length)];
  }

  /// Generate a random amount within a range
  double _randomAmount(int min, int max) {
    return (min + _random.nextDouble() * (max - min)).roundToDouble();
  }

  /// Seed sample transactions for the last N days
  /// Returns total spending amount
  Future<Map<String, dynamic>> seedTransactions({
    int days = 30,
    int minPerDay = 2,
    int maxPerDay = 6,
  }) async {
    final txService = ServiceInitializer.transactions;
    await txService.init();

    int count = 0;
    double totalSpending = 0;
    final now = DateTime.now();

    for (int d = 0; d < days; d++) {
      final day = now.subtract(Duration(days: d));
      final transactionsForDay = minPerDay + _random.nextInt(maxPerDay - minPerDay + 1);

      for (int t = 0; t < transactionsForDay; t++) {
        final category = _pickRandomCategory();
        final merchant = _pickRandomMerchant(category);
        final range = _getAmountRange(category);
        final amount = _randomAmount(range['min']!, range['max']!);

        // Random time during the day
        final hour = 8 + _random.nextInt(14); // 8am to 10pm
        final minute = _random.nextInt(60);
        final timestamp = DateTime(day.year, day.month, day.day, hour, minute);

        // Leave transactions from today and yesterday uncategorized 
        // so they appear in "Yet to Transpond" for demo
        final bool isRecent = d < 2; // 0 = today, 1 = yesterday
        final String? txCategory = isRecent ? null : category;

        final transaction = Transaction(
          id: 'seed_${timestamp.millisecondsSinceEpoch}_$t',
          amount: amount,
          rawMerchantId: merchant.toUpperCase().replaceAll(' ', '_'),
          merchantName: merchant,
          category: txCategory, // null for recent = uncategorized
          timestamp: timestamp,
          type: TransactionType.debit,
          source: DetectionSource.manual,
          rawText: 'INR $amount debited to $merchant via UPI',
          accountLastDigits: '4521', // Link to our demo account
        );

        try {
          await txService.addTransaction(transaction);
          count++;
          totalSpending += amount;
        } catch (e) {
          debugPrint('Failed to seed transaction: $e');
        }
      }
    }

    // Also add some income transactions (salary)
    final salaryDates = [
      now.subtract(const Duration(days: 1)),
      now.subtract(const Duration(days: 30)),
    ];
    double totalIncome = 0;
    
    for (final salaryDate in salaryDates) {
      final salaryAmount = 75000.0 + _random.nextDouble() * 25000; // ₹75k-1L
      final salaryTx = Transaction(
        id: 'salary_${salaryDate.millisecondsSinceEpoch}',
        amount: salaryAmount,
        rawMerchantId: 'SALARY_NEFT',
        merchantName: 'Salary Credit',
        category: 'Income',
        timestamp: salaryDate,
        type: TransactionType.credit,
        source: DetectionSource.manual,
        rawText: 'NEFT-SALARY CREDIT FROM EMPLOYER',
        accountLastDigits: '4521',
      );
      
      try {
        await txService.addTransaction(salaryTx);
        totalIncome += salaryAmount;
      } catch (e) {
        debugPrint('Failed to add salary: $e');
      }
    }

    debugPrint('DataSeederService: Seeded $count expense transactions, spending: ₹$totalSpending');
    return {
      'count': count,
      'totalSpending': totalSpending,
      'totalIncome': totalIncome,
    };
  }

  /// Creates a dummy bank account for demo purposes
  /// Call this with BankProvider from UI context
  static BankAccount createDummyBankAccount({
    double balance = 125000.0,
    String? accountLastDigits,
  }) {
    final lastDigits = accountLastDigits ?? '4521';
    return BankAccount(
      id: 'demo_account_$lastDigits',
      oderId: 'demo_user',
      institutionId: 'hdfc',
      institutionName: 'HDFC Bank',
      accountName: 'Salary Account',
      accountType: AccountType.savings,
      maskedNumber: '•••• $lastDigits',
      balance: balance,
      linkedAt: DateTime.now(),
      lastSyncAt: DateTime.now(),
      ifscCode: 'HDFC0001234',
      upiId: 'demo@hdfcbank',
      isPrimary: true,
    );
  }

  /// Calculate realistic balance (base + income - spending)
  Future<double> calculateDemoBalance() async {
    final txService = ServiceInitializer.transactions;
    await txService.init();
    
    // Base balance in savings account
    const baseBalance = 50000.0;
    
    // Get total income (credits)
    double totalIncome = 0;
    double totalSpending = 0;
    
    for (final tx in txService.transactions) {
      if (tx.type == TransactionType.credit) {
        totalIncome += tx.amount;
      } else if (tx.type == TransactionType.debit) {
        totalSpending += tx.amount;
      }
    }
    
    final balance = baseBalance + totalIncome - totalSpending;
    debugPrint('DataSeederService: Balance calc: $baseBalance + $totalIncome - $totalSpending = $balance');
    return balance.clamp(0, double.infinity);
  }

  /// Full demo seed: transactions + bank account
  /// Returns the bank account to be added via BankProvider
  Future<BankAccount> seedFullDemo() async {
    // First seed the transactions
    await seedTransactions(days: 30, minPerDay: 3, maxPerDay: 5);
    
    // Calculate balance from transactions
    final balance = await calculateDemoBalance();
    
    // Create and return the demo account with calculated balance
    return createDummyBankAccount(balance: balance);
  }

  /// Clear all seeded data
  Future<void> clearSeededData() async {
    final txService = ServiceInitializer.transactions;
    await txService.clear();
    debugPrint('DataSeederService: Cleared all transactions');
  }

  /// Assign random category to an uncategorized transaction
  static String assignRandomCategory() {
    final service = DataSeederService.instance;
    return service._pickRandomCategory();
  }
}
