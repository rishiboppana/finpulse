import 'package:drift/drift.dart';
import '../database.dart';

part 'insight_dao.g.dart';

/// Data Access Object for Insights table
/// Manages AI-generated insights cache
@DriftAccessor(tables: [Insights])
class InsightDao extends DatabaseAccessor<AppDatabase> with _$InsightDaoMixin {
  InsightDao(super.db);

  // ============================================================================
  // CREATE
  // ============================================================================

  /// Insert a new insight
  Future<int> insertInsight(InsightsCompanion insight) async {
    return await into(insights).insert(insight);
  }

  /// Create insight with parameters
  Future<int> createInsight({
    required String type,
    required String title,
    String? subtitle,
    String? icon,
    String? category,
    int? expiresAt,
    String? dataJson,
  }) async {
    return await into(insights).insert(InsightsCompanion.insert(
      type: type,
      title: title,
      subtitle: Value(subtitle),
      icon: Value(icon),
      category: Value(category),
      generatedAt: DateTime.now().millisecondsSinceEpoch,
      expiresAt: Value(expiresAt),
      dataJson: Value(dataJson),
    ));
  }

  // ============================================================================
  // READ
  // ============================================================================

  /// Get latest active insight (not expired, not dismissed)
  Future<Insight?> getLatestActive() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    return await (select(insights)
      ..where((i) => i.isDismissed.equals(false))
      ..where((i) => i.expiresAt.isNull() | i.expiresAt.isBiggerThanValue(now))
      ..orderBy([(i) => OrderingTerm.desc(i.generatedAt)])
      ..limit(1))
      .getSingleOrNull();
  }

  /// Get all active insights (not expired, not dismissed)
  Future<List<Insight>> getAllActive() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    return await (select(insights)
      ..where((i) => i.isDismissed.equals(false))
      ..where((i) => i.expiresAt.isNull() | i.expiresAt.isBiggerThanValue(now))
      ..orderBy([(i) => OrderingTerm.desc(i.generatedAt)]))
      .get();
  }

  /// Get unread insights
  Future<List<Insight>> getUnread() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    return await (select(insights)
      ..where((i) => i.isRead.equals(false))
      ..where((i) => i.isDismissed.equals(false))
      ..where((i) => i.expiresAt.isNull() | i.expiresAt.isBiggerThanValue(now))
      ..orderBy([(i) => OrderingTerm.desc(i.generatedAt)]))
      .get();
  }

  /// Get insights by type
  Future<List<Insight>> getByType(String type) async {
    return await (select(insights)
      ..where((i) => i.type.equals(type))
      ..orderBy([(i) => OrderingTerm.desc(i.generatedAt)]))
      .get();
  }

  /// Get insights for category
  Future<List<Insight>> getByCategory(String category) async {
    return await (select(insights)
      ..where((i) => i.category.equals(category))
      ..orderBy([(i) => OrderingTerm.desc(i.generatedAt)]))
      .get();
  }

  /// Get insight by ID
  Future<Insight?> getById(int id) async {
    return await (select(insights)..where((i) => i.id.equals(id))).getSingleOrNull();
  }

  /// Get count of unread insights
  Future<int> getUnreadCount() async {
    final unread = await getUnread();
    return unread.length;
  }

  // ============================================================================
  // UPDATE
  // ============================================================================

  /// Mark insight as read
  Future<void> markRead(int id) async {
    await (update(insights)..where((i) => i.id.equals(id))).write(
      const InsightsCompanion(isRead: Value(true)),
    );
  }

  /// Mark all as read
  Future<void> markAllRead() async {
    await (update(insights)..where((i) => i.isRead.equals(false))).write(
      const InsightsCompanion(isRead: Value(true)),
    );
  }

  /// Dismiss insight
  Future<void> dismiss(int id) async {
    await (update(insights)..where((i) => i.id.equals(id))).write(
      const InsightsCompanion(isDismissed: Value(true)),
    );
  }

  // ============================================================================
  // DELETE
  // ============================================================================

  /// Delete insight by ID
  Future<void> deleteById(int id) async {
    await (delete(insights)..where((i) => i.id.equals(id))).go();
  }

  /// Delete expired insights
  Future<int> deleteExpired() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    return await (delete(insights)
      ..where((i) => i.expiresAt.isNotNull() & i.expiresAt.isSmallerThanValue(now)))
      .go();
  }

  /// Delete all insights
  Future<void> deleteAll() async {
    await delete(insights).go();
  }

  // ============================================================================
  // WATCH
  // ============================================================================

  /// Watch latest active insight
  Stream<Insight?> watchLatestActive() {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    return (select(insights)
      ..where((i) => i.isDismissed.equals(false))
      ..where((i) => i.expiresAt.isNull() | i.expiresAt.isBiggerThanValue(now))
      ..orderBy([(i) => OrderingTerm.desc(i.generatedAt)])
      ..limit(1))
      .watchSingleOrNull();
  }

  /// Watch all active insights
  Stream<List<Insight>> watchAllActive() {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    return (select(insights)
      ..where((i) => i.isDismissed.equals(false))
      ..where((i) => i.expiresAt.isNull() | i.expiresAt.isBiggerThanValue(now))
      ..orderBy([(i) => OrderingTerm.desc(i.generatedAt)]))
      .watch();
  }

  /// Watch unread count
  Stream<int> watchUnreadCount() {
    return watchAllActive().map((insights) => insights.where((i) => !i.isRead).length);
  }
}
