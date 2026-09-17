import 'package:drift/drift.dart';
import 'package:spendsmart/core/database/app_database.dart';
import 'package:spendsmart/core/database/tables/local_budgets.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';

part 'budget_dao.g.dart';

@DriftAccessor(tables: [LocalBudgets, LocalBudgetCategories])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(super.db);

  /// Watch budget for a specific month and year
  Stream<LocalBudget?> watchBudget(String userId, int month, int year) {
    return (select(localBudgets)
          ..where((tbl) => tbl.userId.equals(userId) & tbl.month.equals(month) & tbl.year.equals(year)))
        .watchSingleOrNull();
  }

  /// Get budget for a specific month and year
  Future<LocalBudget?> getBudget(String userId, int month, int year) {
    return (select(localBudgets)
          ..where((tbl) => tbl.userId.equals(userId) & tbl.month.equals(month) & tbl.year.equals(year)))
        .getSingleOrNull();
  }

  /// Watch category limits for a budget
  Stream<List<LocalBudgetCategory>> watchBudgetCategories(String budgetId) {
    return (select(localBudgetCategories)..where((tbl) => tbl.budgetId.equals(budgetId))).watch();
  }

  /// Get category limits for a budget
  Future<List<LocalBudgetCategory>> getBudgetCategories(String budgetId) {
    return (select(localBudgetCategories)..where((tbl) => tbl.budgetId.equals(budgetId))).get();
  }

  /// Insert or update budget
  Future<int> insertBudget(LocalBudgetsCompanion budget) {
    return into(localBudgets).insertOnConflictUpdate(budget);
  }

  /// Set category limits for a budget (clears old limits first)
  Future<void> setBudgetCategories(String budgetId, List<LocalBudgetCategoriesCompanion> limits) async {
    await transaction(() async {
      await (delete(localBudgetCategories)..where((tbl) => tbl.budgetId.equals(budgetId))).go();
      await batch((b) {
        b.insertAll(localBudgetCategories, limits);
      });
    });
  }

  /// Get pending budgets for sync
  Future<List<LocalBudget>> getPendingSync() {
    return (select(localBudgets)
          ..where((tbl) => tbl.syncStatus.isNotValue(SyncStatus.synced.index)))
        .get();
  }

  /// Mark budget as synced
  Future<int> markSynced(String id) {
    return (update(localBudgets)..where((tbl) => tbl.id.equals(id))).write(
      const LocalBudgetsCompanion(
        syncStatus: Value(SyncStatus.synced),
      ),
    );
  }
}
