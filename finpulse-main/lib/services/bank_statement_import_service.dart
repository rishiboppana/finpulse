import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import '../models/transaction.dart';
import '../database/database.dart';
import 'database_transaction_service.dart';
import 'service_initializer.dart';
import 'gemini_service.dart';
import 'app_logger.dart';

/// Service for importing historical bank statement data
/// Supports Excel (.xlsx) files with automatic column detection
class BankStatementImportService {
  static BankStatementImportService? _instance;
  static BankStatementImportService get instance {
    _instance ??= BankStatementImportService._();
    return _instance!;
  }

  BankStatementImportService._();

  final _logger = AppLogger.instance;

  /// Pick and import a bank statement file
  Future<ImportResult> pickAndImportStatement() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls', 'csv'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return ImportResult(success: false, message: 'No file selected');
      }

      final file = result.files.first;
      if (file.path == null) {
        return ImportResult(success: false, message: 'Invalid file path');
      }

      return await importFromFile(file.path!);
    } catch (e) {
      _logger.logError(AppLogger.categoryDataFlow, 'Statement import failed', {
        'error': e.toString(),
      });
      return ImportResult(success: false, message: 'Import failed: $e');
    }
  }

  /// Import bank statement from file path
  Future<ImportResult> importFromFile(String filePath) async {
    _logger.logDataFlowStage(
      stage: 'IMPORT_START',
      description: 'Starting bank statement import',
      data: {'file': filePath},
    );

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return ImportResult(success: false, message: 'File not found');
      }

      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      // Get the first sheet
      if (excel.tables.isEmpty) {
        return ImportResult(success: false, message: 'No sheets found in file');
      }

      final sheetName = excel.tables.keys.first;
      final sheet = excel.tables[sheetName]!;

      _logger.logDataFlowStage(
        stage: 'SHEET_LOADED',
        description: 'Excel sheet loaded',
        data: {
          'sheetName': sheetName,
          'rows': sheet.maxRows,
          'cols': sheet.maxCols,
        },
      );

      // Detect column headers
      final columnMap = _detectColumns(sheet);
      if (columnMap.isEmpty) {
        return ImportResult(
          success: false,
          message:
              'Could not detect required columns (Date, Amount, Description)',
        );
      }

      // Parse transactions
      final transactions = <Transaction>[];
      int imported = 0;
      int skipped = 0;

      // Start from row 1 (skip header row 0)
      for (int rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
        final row = sheet.row(rowIndex);
        final transaction = await _parseRow(row, columnMap, rowIndex);

        if (transaction != null) {
          // Add to database
          final added = await ServiceInitializer.transactions.addTransaction(
            transaction,
          );
          if (added) {
            transactions.add(transaction);
            imported++;

            _logger.logTransactionSaved(
              transactionId: transaction.id,
              amount: transaction.amount,
              source: 'bank_statement',
              parsedByAI: false,
            );
          } else {
            skipped++; // Duplicate
          }
        } else {
          skipped++;
        }
      }

      _logger.logDataFlowStage(
        stage: 'IMPORT_COMPLETE',
        description: 'Bank statement import finished',
        data: {
          'imported': imported,
          'skipped': skipped,
          'total': sheet.maxRows - 1,
        },
      );

      return ImportResult(
        success: true,
        message: 'Imported $imported transactions (${skipped} skipped)',
        importedCount: imported,
        skippedCount: skipped,
        transactions: transactions,
      );
    } catch (e) {
      _logger.logError(AppLogger.categoryDataFlow, 'Import error', {
        'error': e.toString(),
      });
      return ImportResult(success: false, message: 'Import failed: $e');
    }
  }

  /// Detect column positions from header row
  Map<String, int> _detectColumns(Sheet sheet) {
    final headerRow = sheet.row(0);
    final columnMap = <String, int>{};

    for (int i = 0; i < headerRow.length; i++) {
      final cell = headerRow[i];
      final value = cell?.value?.toString().toLowerCase().trim() ?? '';

      // Date columns
      if (value.contains('date') ||
          value.contains('txn') ||
          value.contains('transaction')) {
        if (!columnMap.containsKey('date')) {
          columnMap['date'] = i;
        }
      }

      // Amount columns (debit/credit or combined)
      if (value.contains('debit') ||
          value.contains('withdrawal') ||
          value.contains('dr')) {
        columnMap['debit'] = i;
      } else if (value.contains('credit') ||
          value.contains('deposit') ||
          value.contains('cr')) {
        columnMap['credit'] = i;
      } else if (value.contains('amount') && !columnMap.containsKey('amount')) {
        columnMap['amount'] = i;
      }

      // Description/narration
      if (value.contains('description') ||
          value.contains('narration') ||
          value.contains('particulars') ||
          value.contains('remarks')) {
        columnMap['description'] = i;
      }

      // Balance
      if (value.contains('balance') || value.contains('closing')) {
        columnMap['balance'] = i;
      }

      // Reference
      if (value.contains('ref') ||
          value.contains('cheque') ||
          value.contains('utr')) {
        columnMap['reference'] = i;
      }
    }

    debugPrint('[BankStatementImport] Detected columns: $columnMap');
    return columnMap;
  }

  /// Parse a row into a Transaction
  Future<Transaction?> _parseRow(
    List<Data?> row,
    Map<String, int> columnMap,
    int rowIndex,
  ) async {
    try {
      // Extract date
      DateTime? date;
      if (columnMap.containsKey('date')) {
        final dateCell = row[columnMap['date']!];
        date = _parseDate(dateCell?.value);
      }

      if (date == null) return null;

      // Extract amount and determine type
      double? amount;
      TransactionType type = TransactionType.debit;

      if (columnMap.containsKey('debit') && columnMap.containsKey('credit')) {
        // Separate debit/credit columns
        final debitCell = row[columnMap['debit']!];
        final creditCell = row[columnMap['credit']!];

        final debitAmount = _parseAmount(debitCell?.value);
        final creditAmount = _parseAmount(creditCell?.value);

        if (debitAmount != null && debitAmount > 0) {
          amount = debitAmount;
          type = TransactionType.debit;
        } else if (creditAmount != null && creditAmount > 0) {
          amount = creditAmount;
          type = TransactionType.credit;
        }
      } else if (columnMap.containsKey('amount')) {
        // Single amount column
        amount = _parseAmount(row[columnMap['amount']!]?.value);
        // Assume debit unless positive value with indicator
      }

      if (amount == null || amount == 0) return null;

      // Extract description
      String description = '';
      if (columnMap.containsKey('description')) {
        description =
            row[columnMap['description']!]?.value?.toString().trim() ?? '';
      }

      if (description.isEmpty) return null;

      // Try to extract merchant from description using Gemini (optional)
      String? merchantId;
      String? merchantName;
      String? category;

      // Use simple extraction for now (can enhance with Gemini later)
      final extracted = _extractMerchantFromDescription(description);
      merchantId = extracted['id'];
      merchantName = extracted['name'];
      category = extracted['category'];

      // Generate unique ID
      final id =
          'stmt_${date.millisecondsSinceEpoch}_${rowIndex}_${amount.toInt()}';

      return Transaction(
        id: id,
        amount: amount,
        rawMerchantId: merchantId,
        merchantName: merchantName,
        category: category,
        timestamp: date,
        type: type,
        source: DetectionSource.manual,
        rawText: description,
        isParsedByAI: false,
      );
    } catch (e) {
      debugPrint('[BankStatementImport] Error parsing row $rowIndex: $e');
      return null;
    }
  }

  /// Parse date from cell value
  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    if (value is DateTime) return value;

    if (value is int || value is double) {
      // Excel numeric date (days since 1900-01-01)
      try {
        final days = (value as num).toInt();
        // Excel dates start from 1900-01-01, but there's a leap year bug
        return DateTime(1899, 12, 30).add(Duration(days: days));
      } catch (e) {
        return null;
      }
    }

    if (value is String) {
      final str = value.trim();
      // Try common date formats
      final formats = [
        r'(\d{1,2})[/-](\d{1,2})[/-](\d{2,4})', // DD/MM/YYYY or MM/DD/YYYY
        r'(\d{4})[/-](\d{1,2})[/-](\d{1,2})', // YYYY-MM-DD
      ];

      for (final pattern in formats) {
        final match = RegExp(pattern).firstMatch(str);
        if (match != null) {
          try {
            final parts = match
                .groups([1, 2, 3])
                .whereType<String>()
                .map(int.parse)
                .toList();
            if (parts.length == 3) {
              // Assume DD/MM/YYYY for Indian bank statements
              int day = parts[0];
              int month = parts[1];
              int year = parts[2];

              if (year < 100) year += 2000;

              // Swap if looks like YYYY-MM-DD
              if (parts[0] > 31) {
                year = parts[0];
                month = parts[1];
                day = parts[2];
              }

              return DateTime(year, month, day);
            }
          } catch (e) {
            continue;
          }
        }
      }
    }

    return null;
  }

  /// Parse amount from cell value
  double? _parseAmount(dynamic value) {
    if (value == null) return null;

    if (value is num) return value.toDouble().abs();

    if (value is String) {
      // Remove currency symbols and commas
      final cleaned = value
          .replaceAll(RegExp(r'[₹$€£,\s]'), '')
          .replaceAll('(', '-')
          .replaceAll(')', '')
          .trim();

      if (cleaned.isEmpty || cleaned == '-') return null;

      final parsed = double.tryParse(cleaned);
      return parsed?.abs();
    }

    return null;
  }

  /// Extract merchant info from description
  Map<String, String?> _extractMerchantFromDescription(String description) {
    final upper = description.toUpperCase();

    // Common merchant patterns
    final patterns = {
      'upi': r'(?:UPI|IMPS)[/-]?\s*[\w]+[/-]([^/]+)',
      'neft': r'NEFT[/-]?\s*[\w]+[/-]([^/]+)',
      'pos': r'POS\s+\d+\s+([\w\s]+)',
      'atm': r'ATM\s+([\w\s]+)',
    };

    String? merchantId;
    String? merchantName;
    String? category;

    // Try to extract UPI/IMPS recipient
    for (final entry in patterns.entries) {
      final match = RegExp(
        entry.value,
        caseSensitive: false,
      ).firstMatch(description);
      if (match != null && match.groupCount >= 1) {
        merchantId = match.group(1)?.trim();
        merchantName = merchantId;
        break;
      }
    }

    // Fallback: use first significant words
    if (merchantName == null) {
      final words = description
          .split(RegExp(r'[\s/\-]+'))
          .where(
            (w) =>
                w.length > 2 &&
                !RegExp(r'^\d+$').hasMatch(w) &&
                ![
                  'INR',
                  'UPI',
                  'NEFT',
                  'IMPS',
                  'REF',
                  'TXN',
                ].contains(w.toUpperCase()),
          )
          .take(3)
          .toList();

      if (words.isNotEmpty) {
        merchantName = words.join(' ');
        merchantId = words.first.toUpperCase();
      }
    }

    // Auto-categorize based on keywords
    if (upper.contains('SWIGGY') ||
        upper.contains('ZOMATO') ||
        upper.contains('FOOD')) {
      category = 'Food';
    } else if (upper.contains('UBER') ||
        upper.contains('OLA') ||
        upper.contains('IRCTC')) {
      category = 'Transport';
    } else if (upper.contains('AMAZON') ||
        upper.contains('FLIPKART') ||
        upper.contains('MYNTRA')) {
      category = 'Shopping';
    } else if (upper.contains('NETFLIX') ||
        upper.contains('PRIME') ||
        upper.contains('SPOTIFY')) {
      category = 'Subscription';
    } else if (upper.contains('ELECTRICITY') ||
        upper.contains('GAS') ||
        upper.contains('WATER')) {
      category = 'Bills';
    } else if (upper.contains('HOSPITAL') ||
        upper.contains('PHARMA') ||
        upper.contains('MEDICAL')) {
      category = 'Health';
    } else if (upper.contains('ATM') || upper.contains('CASH')) {
      category = 'Cash';
    }

    return {'id': merchantId, 'name': merchantName, 'category': category};
  }
}

/// Result of bank statement import
class ImportResult {
  final bool success;
  final String message;
  final int importedCount;
  final int skippedCount;
  final List<Transaction> transactions;

  ImportResult({
    required this.success,
    required this.message,
    this.importedCount = 0,
    this.skippedCount = 0,
    this.transactions = const [],
  });
}
