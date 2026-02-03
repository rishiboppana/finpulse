import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/transaction.dart' as model;
import '../models/bank_account.dart';
import 'database_transaction_service.dart';
import 'database_account_service.dart';

class DataSeedingService {
  static final Random _random = Random();

  static const List<String> _merchants = [
    'Swiggy', 'Zomato', 'Amazon India', 'Flipkart', 'Starbucks India',
    'Blue Tokai', 'BigBasket', 'Blinkit', 'Uber India', 'Ola Cabs',
    'Jio Recharge', 'Airtel Bill', 'Netflix', 'Spotify', 'Nykaa',
    'Myntra', 'Apollo Pharmacy', 'Reliance Digital', 'Shell Petrol',
    'HP Petrol', 'HDFC Credit Card', 'LIC Premium', 'Society Maintenance',
    'Maid Salary', 'Gym Membership', 'Cult.fit', 'BookMyShow', 'PVR Cinemas'
  ];

  static const Map<String, List<String>> _categoryMerchants = {
    'Food': ['Swiggy', 'Zomato', 'Starbucks India', 'Blue Tokai'],
    'Groceries': ['BigBasket', 'Blinkit', 'Reliance Fresh'],
    'Transport': ['Uber India', 'Ola Cabs', 'Shell Petrol', 'HP Petrol'],
    'Shopping': ['Amazon India', 'Flipkart', 'Nykaa', 'Myntra', 'Reliance Digital'],
    'Bills': ['Jio Recharge', 'Airtel Bill', 'LIC Premium', 'Society Maintenance'],
    'Entertainment': ['Netflix', 'Spotify', 'BookMyShow', 'PVR Cinemas'],
    'Wellness': ['Apollo Pharmacy', 'Gym Membership', 'Cult.fit'],
  };

  static Future<void> seedIfEmpty() async {
    final accountService = DatabaseAccountService.instance;
    final transactionService = DatabaseTransactionService.instance;

    await accountService.init();
    await transactionService.init();

    if (accountService.accounts.isEmpty) {
      debugPrint('DataSeedingService: Seeding accounts...');
      await _seedAccounts();
    }

    if (transactionService.transactions.isEmpty) {
      debugPrint('DataSeedingService: Seeding transactions...');
      await _seedTransactions();
    }
  }

  static Future<void> _seedAccounts() async {
    final accountService = DatabaseAccountService.instance;

    final accounts = [
      BankAccount(
        id: 'acc_hdfc_1234',
        oderId: 'user_1',
        institutionId: 'hdfc',
        institutionName: 'HDFC Bank',
        accountName: 'Salary Account',
        accountType: AccountType.savings,
        maskedNumber: '1234',
        balance: 75250.50,
        linkedAt: DateTime.now().subtract(const Duration(days: 365)),
        isPrimary: true,
      ),
      BankAccount(
        id: 'acc_icici_5678',
        oderId: 'user_1',
        institutionId: 'icici',
        institutionName: 'ICICI Bank',
        accountName: 'Savings Account',
        accountType: AccountType.savings,
        maskedNumber: '5678',
        balance: 21400.00,
        linkedAt: DateTime.now().subtract(const Duration(days: 200)),
      ),
      BankAccount(
        id: 'acc_paytm_9999',
        oderId: 'user_1',
        institutionId: 'paytm',
        institutionName: 'Paytm Wallet',
        accountName: 'Digital Wallet',
        accountType: AccountType.wallet,
        maskedNumber: '9999',
        balance: 1250.00,
        linkedAt: DateTime.now().subtract(const Duration(days: 100)),
      ),
    ];

    for (final acc in accounts) {
      await accountService.addAccount(acc);
    }
  }

  static Future<void> _seedTransactions() async {
    final transactionService = DatabaseTransactionService.instance;
    final accountService = DatabaseAccountService.instance;
    
    if (accountService.accounts.isEmpty) return;

    final now = DateTime.now();
    
    // Generate 80 transactions over the last 90 days
    for (int i = 0; i < 80; i++) {
      final daysAgo = _random.nextInt(90);
      final hoursAgo = _random.nextInt(24);
      final minutesAgo = _random.nextInt(60);
      final timestamp = now.subtract(Duration(days: daysAgo, hours: hoursAgo, minutes: minutesAgo));
      
      final category = _categoryMerchants.keys.elementAt(_random.nextInt(_categoryMerchants.length));
      final merchantsInCat = _categoryMerchants[category]!;
      final merchant = merchantsInCat[_random.nextInt(merchantsInCat.length)];
      
      double amount;
      if (category == 'Bills') {
        amount = 500.0 + _random.nextInt(5000);
      } else if (category == 'Food') {
        amount = 150.0 + _random.nextInt(1500);
      } else if (category == 'Shopping') {
        amount = 300.0 + _random.nextInt(8000);
      } else {
        amount = 50.0 + _random.nextInt(2000);
      }

      final account = accountService.accounts[_random.nextInt(accountService.accounts.length)];

      final tx = model.Transaction(
        id: 'seed_${i}_${timestamp.millisecondsSinceEpoch}',
        amount: amount,
        timestamp: timestamp,
        accountLastDigits: account.maskedNumber,
        rawMerchantId: merchant.toUpperCase().replaceAll(' ', '_'),
        merchantName: merchant,
        category: category,
        type: model.TransactionType.debit,
        source: model.DetectionSource.sms,
        rawText: 'Paid ₹$amount to $merchant. Ref: ${100000 + _random.nextInt(900000)}',
        isParsedByAI: _random.nextBool(), // Randomly mark some as AI parsed for visual variety
      );

      await transactionService.addTransaction(tx);
    }
    
    // Add some credits (income)
    for (int i = 0; i < 3; i++) {
      final daysAgo = 30 * i;
      final timestamp = DateTime(now.year, now.month, 1).subtract(Duration(days: daysAgo));
      
      final tx = model.Transaction(
        id: 'seed_income_${i}',
        amount: 85000.0,
        timestamp: timestamp,
        accountLastDigits: '1234',
        rawMerchantId: 'COMPANY_SALARY',
        merchantName: 'Salary Credit',
        category: 'Income',
        type: model.TransactionType.credit,
        source: model.DetectionSource.sms,
        rawText: 'Salary of ₹85000.00 credited to HDFC A/c 1234.',
      );
      
      await transactionService.addTransaction(tx);
    }
  }
}
