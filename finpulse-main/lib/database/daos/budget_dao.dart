import 'package:drift/drift.dart';
import '../database.dart';

part 'budget_dao.g.dart';

/// Data Access Object for Budgets table
/// Manages user spending limits (daily, weekly, monthly)
@DriftAccessor(tables: [Budgets])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(super.db);

  // ============================================================================
  // CREATE / UPDATE
  // ============================================================================

  /// Set a budget for category and period
  Future<void> setBudget({
    required String category,
    required String period,
    required double amount,
    bool isCustomCategory = false,
  }) async {
    final existing = await getBudget(category, period);
    final now = DateTime.now().millisecondsSinceEpoch;

    if (existing == null) {
      await into(budgets).insert(BudgetsCompanion.insert(
        category: category,
        period: period,
        amount: amount,
        isCustomCategory: Value(isCustomCategory),
        createdAt: now,
        updatedAt: now,
      ));
    } else {
      await (update(budgets)..where((b) => b.id.equals(existing.id))).write(
        BudgetsCompanion(
          amount: Value(amount),
          updatedAt: Value(now),
        ),
      );
    }
  }

  // ============================================================================
  // READ
  // ============================================================================

  /// Get a specific budget
  Future<Budget?> getBudget(String category, String period) async {
    return await (select(budgets)
      ..where((b) => b.category.equals(category) & b.period.equals(period)))
      .getSingleOrNull();
  }

  /// Get all budgets
  Future<List<Budget>> getAll() async {
    return await select(budgets).get();
  }

  /// Get budgets by period (daily, weekly, monthly)
  Future<List<Budget>> getByPeriod(String period) async {
    return await (select(budgets)..where((b) => b.period.equals(period))).get();
  }

  /// Get budgets for a category
  Future<List<Budget>> getByCategory(String category) async {
    return await (select(budgets)..where((b) => b.category.equals(category))).get();
  }

  /// Get daily budgets
  Future<List<Budget>> getDailyBudgets() => getByPeriod('daily');

  /// Get weekly budgets
  Future<List<Budget>> getWeeklyBudgets() => getByPeriod('weekly');

  /// Get monthly budgets
  Future<List<Budget>> getMonthlyBudgets() => getByPeriod('monthly');

  /// Check if any budgets exist
  Future<bool> hasBudgets() async {
    final all = await getAll();
    return all.isNotEmpty;
  }

  // ============================================================================
  // BUDGET PROGRESS QUERIES (requires transaction data)
  // ============================================================================

  /// Get all budgets with their amounts as a simple map
  Future<Map<String, Map<String, double>>> getAllBudgetAmounts() async {
    final all = await getAll();
    final result = <String, Map<String, double>>{};

    for (final budget in all) {
      result.putIfAbsent(budget.category, () => {});
      result[budget.category]![budget.period] = budget.amount;
    }

    return result;
  }

  // ============================================================================
  // DELETE
  // ============================================================================

  /// Delete a specific budget
  Future<void> deleteBudget(String category, String period) async {
    await (delete(budgets)
      ..where((b) => b.category.equals(category) & b.period.equals(period)))
      .go();
  }

  /// Delete all budgets for a category
  Future<void> deleteByCategory(String category) async {
    await (delete(budgets)..where((b) => b.category.equals(category))).go();
  }

  /// Delete all budgets
  Future<void> deleteAll() async {
    await delete(budgets).go();
  }

  // ============================================================================
  // WATCH
  // ============================================================================

  /// Watch all budgets
  Stream<List<Budget>> watchAll() {
    return select(budgets).watch();
  }

  /// Watch all budgets (Alias)
  Stream<List<Budget>> watchAllBudgets() => watchAll();
  
  /// Get all budgets (Alias)
  Future<List<Budget>> getAllBudgets() => getAll();

  /// Watch budgets by period
  Stream<List<Budget>> watchByPeriod(String period) {
    return (select(budgets)..where((b) => b.period.equals(period))).watch();
  }

  /// Get current spending for a specific budget
  Future<double> getBudgetSpending(int budgetId, DateTime referenceDate) async {
    final budget = await (select(budgets)..where((b) => b.id.equals(budgetId))).getSingleOrNull();
    if (budget == null) return 0.0;

    DateTime start;
    DateTime end;
    
    final now = referenceDate;
    if (budget.period.toLowerCase() == 'daily') {
       start = DateTime(now.year, now.month, now.day);
       end = start.add(const Duration(days: 1));
    } else if (budget.period.toLowerCase() == 'weekly') {
       start = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
       start = DateTime(start.year, start.month, start.day);
       end = start.add(const Duration(days: 7));
    } else { // monthly
       start = DateTime(now.year, now.month, 1);
       if (now.month == 12) {
         end = DateTime(now.year + 1, 1, 1);
       } else {
         end = DateTime(now.year, now.month + 1, 1);
       }
    }

    final totals = await db.transactionDao.getSpendingByCategory(
      fromMs: start.millisecondsSinceEpoch, 
      toMs: end.millisecondsSinceEpoch
    );
    
    return totals[budget.category] ?? 0.0;
  }
}
