import 'package:drift/drift.dart';
import '../database.dart';

part 'merchant_intelligence_dao.g.dart';

@DriftAccessor(tables: [MerchantIntelligence])
class MerchantIntelligenceDao extends DatabaseAccessor<AppDatabase> with _$MerchantIntelligenceDaoMixin {
  MerchantIntelligenceDao(AppDatabase db) : super(db);

  /// Get intelligence for a merchant
  Future<MerchantIntelligenceData?> get(String id) {
    return (select(merchantIntelligence)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Update or Insert intelligence
  Future<void> upsert({
    required String id,
    String? historySummary,
    String? spendingPatterns,
    double? typicalAmount,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    await into(merchantIntelligence).insertOnConflictUpdate(
      MerchantIntelligenceCompanion(
        id: Value(id),
        historySummary: Value(historySummary),
        spendingPatterns: Value(spendingPatterns),
        typicalAmount: Value(typicalAmount),
        lastAnalyzedAt: Value(now),
      ),
    );
  }
}
