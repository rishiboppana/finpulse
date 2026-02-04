import 'package:flutter/material.dart';
import '../services/bank_statement_import_service.dart';

/// Screen for importing bank statement files
class BankStatementImportScreen extends StatefulWidget {
  const BankStatementImportScreen({super.key});

  @override
  State<BankStatementImportScreen> createState() =>
      _BankStatementImportScreenState();
}

class _BankStatementImportScreenState extends State<BankStatementImportScreen> {
  bool _isImporting = false;
  ImportResult? _lastResult;

  Future<void> _pickAndImport() async {
    setState(() {
      _isImporting = true;
      _lastResult = null;
    });

    final result = await BankStatementImportService.instance
        .pickAndImportStatement();

    if (mounted) {
      setState(() {
        _isImporting = false;
        _lastResult = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Import Bank Statement')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade400),
                        const SizedBox(width: 8),
                        const Text(
                          'Supported Formats',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('• Excel files (.xlsx, .xls)'),
                    const Text('• CSV files (.csv)'),
                    const SizedBox(height: 12),
                    Text(
                      'The import will automatically detect columns for Date, Amount, and Description.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Import button
            ElevatedButton.icon(
              onPressed: _isImporting ? null : _pickAndImport,
              icon: _isImporting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.upload_file),
              label: Text(
                _isImporting ? 'Importing...' : 'Select Bank Statement',
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // Result display
            if (_lastResult != null) ...[
              Card(
                color: _lastResult!.success
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _lastResult!.success
                                ? Icons.check_circle
                                : Icons.error,
                            color: _lastResult!.success
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _lastResult!.success
                                ? 'Import Successful'
                                : 'Import Failed',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _lastResult!.success
                                  ? Colors.green.shade800
                                  : Colors.red.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(_lastResult!.message),
                      if (_lastResult!.success) ...[
                        const SizedBox(height: 8),
                        Text(
                          '✓ ${_lastResult!.importedCount} transactions imported',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        if (_lastResult!.skippedCount > 0)
                          Text(
                            '⊘ ${_lastResult!.skippedCount} duplicates skipped',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                      ],
                    ],
                  ),
                ),
              ),

              // Show sample transactions
              if (_lastResult!.transactions.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Sample Imported Transactions:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...(_lastResult!.transactions
                    .take(5)
                    .map(
                      (tx) => Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: tx.type.name == 'debit'
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                            child: Icon(
                              tx.type.name == 'debit'
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: tx.type.name == 'debit'
                                  ? Colors.red
                                  : Colors.green,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            tx.merchantName ?? tx.rawMerchantId ?? 'Unknown',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${tx.timestamp.day}/${tx.timestamp.month}/${tx.timestamp.year}',
                          ),
                          trailing: Text(
                            '₹${tx.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: tx.type.name == 'debit'
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
