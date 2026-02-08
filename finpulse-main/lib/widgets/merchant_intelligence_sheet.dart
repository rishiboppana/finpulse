import 'package:flutter/material.dart';
import '../database/database.dart';
import '../services/service_initializer.dart';
import 'package:flutter_application_1/models/transaction.dart' as model;
import '../services/transaction_parser.dart';

class MerchantIntelligenceSheet extends StatelessWidget {
  final model.Transaction transaction;

  const MerchantIntelligenceSheet({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    if (transaction.rawMerchantId == null) return const SizedBox.shrink();

    return FutureBuilder<MerchantIntelligenceData?>(
      future: ServiceInitializer.database.merchantIntelligenceDao.get(
        TransactionParser.normalizeMerchantId(transaction.rawMerchantId!)
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          // Fallback or "Scanning..." state
          return Container(
            padding: const EdgeInsets.all(16),
            child: const Text("No intelligence available for this merchant yet."),
          );
        }

        final data = snapshot.data!;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFE0F2FE),
                    child: const Icon(Icons.store, color: Color(0xFF0284C7)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Merchant Intelligence",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          transaction.merchantName ?? transaction.rawMerchantId!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // AI Summary
              if (data.historySummary != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.psychology, color: Color(0xFF16A34A)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          data.historySummary!,
                          style: const TextStyle(
                            color: Color(0xFF14532D),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
              const SizedBox(height: 16),
              
              // Stats Row
              Row(
                children: [
                  _StatItem(
                    label: "Typical Spend",
                    value: data.typicalAmount != null 
                        ? "₹${data.typicalAmount!.toStringAsFixed(0)}" 
                        : "—",
                  ),
                  _StatItem(
                    label: "This Spend",
                    value: "₹${transaction.amount.toStringAsFixed(0)}",
                    isHigh: (data.typicalAmount != null && transaction.amount > data.typicalAmount! * 1.5),
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isHigh;

  const _StatItem({
    required this.label, 
    required this.value,
    this.isHigh = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isHigh ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
