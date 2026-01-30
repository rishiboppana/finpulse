import 'package:flutter/material.dart';

import '../services/merchant_learning_service.dart';
import '../services/notification_service.dart';

/// Screen to view and manage learned merchants
class LearnedMerchantsScreen extends StatefulWidget {
  const LearnedMerchantsScreen({super.key});

  @override
  State<LearnedMerchantsScreen> createState() => _LearnedMerchantsScreenState();
}

class _LearnedMerchantsScreenState extends State<LearnedMerchantsScreen> {
  Map<String, MerchantMapping> _mappings = {};

  @override
  void initState() {
    super.initState();
    _loadMappings();
  }

  void _loadMappings() {
    setState(() {
      _mappings = MerchantLearningService.instance.allMappings;
    });
  }

  Future<void> _deleteMerchant(String rawId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Forget Merchant?'),
        content: Text('FinPulse will no longer remember the category for this merchant.'),
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
      await MerchantLearningService.instance.forgetMerchant(rawId);
      _loadMappings();
    }
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF29D6C7);
    const textDark = Color(0xFF0F172A);
    const muted = Color(0xFF64748B);

    final stats = MerchantLearningService.instance.stats;
    final mappingsList = _mappings.values.toList();
    
    // Sort by usage count (most used first)
    mappingsList.sort((a, b) => b.usageCount.compareTo(a.usageCount));

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
      body: Column(
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
                        '${stats.totalMerchants}',
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
                        '${stats.categoryCounts.length}',
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
                              onPressed: () => _deleteMerchant(mapping.rawId),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
