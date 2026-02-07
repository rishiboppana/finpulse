import 'package:flutter/material.dart';
import '../models/transaction.dart';

/// Full-screen scrollable list of today's transactions
class TodayTransactionsScreen extends StatelessWidget {
  final List<Transaction> transactions;
  
  const TodayTransactionsScreen({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);
    final accentColor = const Color(0xFF29D6C7);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Today's Transactions",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: textDark,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: textDark),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${transactions.length} total',
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: muted.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions today yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                // Placeholder for refresh - could reload from database
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  return _TransactionCard(transaction: tx);
                },
              ),
            ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;
  
  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == TransactionType.credit;
    final amountColor = isCredit ? const Color(0xFF10B981) : const Color(0xFFEF4444);
    final typeIcon = isCredit ? Icons.arrow_downward : Icons.arrow_upward;
    final typeText = isCredit ? '+' : '-';
    final textDark = const Color(0xFF0F172A);
    final muted = const Color(0xFF64748B);
    
    final time = "${transaction.timestamp.hour > 12 ? transaction.timestamp.hour - 12 : transaction.timestamp.hour}:${transaction.timestamp.minute.toString().padLeft(2, '0')} ${transaction.timestamp.hour >= 12 ? 'PM' : 'AM'}";
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: amountColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              typeIcon,
              color: amountColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.merchantName ?? transaction.rawMerchantId ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: muted),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: muted,
                      ),
                    ),
                    if (transaction.category != null) ...[
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          transaction.category!,
                          style: TextStyle(
                            fontSize: 10,
                            color: muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          
          // Amount
          Text(
            '$typeText₹${transaction.amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
