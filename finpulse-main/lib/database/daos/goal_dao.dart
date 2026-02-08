import 'package:drift/drift.dart';
import '../database.dart';

part 'goal_dao.g.dart';

@DriftAccessor(tables: [Goals])
class GoalDao extends DatabaseAccessor<AppDatabase> with _$GoalDaoMixin {
  GoalDao(AppDatabase db) : super(db);

  /// Get all active goals
  Future<List<Goal>> getActiveGoals() {
    return (select(goals)
          ..where((t) => t.isCompleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.priority)]))
        .get();
  }

  /// Watch all active goals
  Stream<List<Goal>> watchActiveGoals() {
    return (select(goals)
          ..where((t) => t.isCompleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.priority)]))
        .watch();
  }

  /// Get all completed goals
  Future<List<Goal>> getCompletedGoals() {
    return (select(goals)
          ..where((t) => t.isCompleted.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
  }

  /// Create a new goal
  Future<int> createGoal(GoalsCompanion companion) {
    return into(goals).insert(companion);
  }

  /// Update a goal
  Future<bool> updateGoal(Goal goal) {
    return update(goals).replace(goal);
  }

  /// Delete a goal
  Future<int> deleteGoal(int id) {
    return (delete(goals)..where((t) => t.id.equals(id))).go();
  }

  /// Update progress
  Future<void> updateProgress(int id, double amount) async {
    final goal = await (select(goals)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (goal != null) {
      final newAmount = goal.currentAmount + amount;
      final isCompleted = newAmount >= goal.targetAmount;
      
      await (update(goals)..where((t) => t.id.equals(id))).write(
        GoalsCompanion(
          currentAmount: Value(newAmount),
          isCompleted: Value(isCompleted),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );
    }
  }
}
