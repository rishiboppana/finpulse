import 'package:flutter/material.dart';

import '../services/database_merchant_service.dart';
import '../services/service_initializer.dart';
import '../services/notification_service.dart';
import '../services/transaction_parser.dart';

/// Screen to view and manage learned merchants
class LearnedMerchantsScreen extends StatefulWidget {
  const LearnedMerchantsScreen({super.key});

  @override
  State<LearnedMerchantsScreen> createState() => _LearnedMerchantsScreenState();
}

class _LearnedMerchantsScreenState extends State<LearnedMerchantsScreen> {
  
  Future<void> _deleteMerchant(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Forget Merchant?'),
        content: const Text('FinPulse will no longer remember the category for this merchant.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Forget', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ServiceInitializer.database.merchantDao.deleteById(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF29D6C7);
    const textDark = Color(0xFF0F172A);
    const muted = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Learned Merchants',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.white,
        foregroundColor: textDark,
        elevation: 0,
      ),
      body: StreamBuilder<List<MerchantMapping>>(
        stream: ServiceInitializer.merchants.watchAllMappings,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final mappingsList = snapshot.data!;
          final totalMerchants = mappingsList.length;
          final uniqueCategories = mappingsList.map((m) => m.category).toSet().length;

          return Column(
            children: [
              // Stats header
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: teal.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    // Total count
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$totalMerchants',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: textDark,
                            ),
                          ),
                          const Text(
                            'Merchants Learned',
                            style: TextStyle(color: muted, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 50, color: teal.withOpacity(0.3)),
                    // Categories
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '$uniqueCategories',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: textDark,
                            ),
                          ),
                          const Text(
                            'Categories Used',
                            style: TextStyle(color: muted, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // List of merchants
              Expanded(
                child: mappingsList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.school_outlined, size: 64, color: muted.withOpacity(0.5)),
                            const SizedBox(height: 16),
                            const Text(
                              'No merchants learned yet',
                              style: TextStyle(fontWeight: FontWeight.w700, color: muted),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Use the Mock Trigger to tag transactions',
                              style: TextStyle(color: muted, fontSize: 13),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: mappingsList.length,
                        itemBuilder: (ctx, index) {
                          final mapping = mappingsList[index];
                          final category = ExpenseCategories.getByName(mapping.category);
                          
                          // Convert raw ID into the normalized ID for deletion
                          // Since we don't have the ID in MerchantMapping (bad design in my part previously),
                          // we re-normalize it here.
                          // Ideally MerchantMapping should have the ID.
                          // For now, let's assume TransactionParser.normalizeMerchantId works.
                          final id = TransactionParser.normalizeMerchantId(mapping.rawId);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFE5E7EB)),
                            ),
                            child: Row(
                              children: [
                                // Category icon
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: category != null 
                                        ? Color(category.color).withOpacity(0.15)
                                        : muted.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      category?.emoji ?? '💰',
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                
                                // Merchant info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mapping.displayName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 15,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: category != null 
                                                  ? Color(category.color).withOpacity(0.15)
                                                  : muted.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              mapping.category,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: category?.colorValue ?? muted,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${mapping.usageCount}x used',
                                            style: const TextStyle(
                                              fontSize: 12, color: muted),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Delete button
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: muted),
                                  onPressed: () => _deleteMerchant(id),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
