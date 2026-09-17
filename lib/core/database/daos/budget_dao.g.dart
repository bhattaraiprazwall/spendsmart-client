// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_dao.dart';

// ignore_for_file: type=lint
mixin _$BudgetDaoMixin on DatabaseAccessor<AppDatabase> {
  $LocalBudgetsTable get localBudgets => attachedDatabase.localBudgets;
  $LocalBudgetCategoriesTable get localBudgetCategories =>
      attachedDatabase.localBudgetCategories;
  BudgetDaoManager get managers => BudgetDaoManager(this);
}

class BudgetDaoManager {
  final _$BudgetDaoMixin _db;
  BudgetDaoManager(this._db);
  $$LocalBudgetsTableTableManager get localBudgets =>
      $$LocalBudgetsTableTableManager(_db.attachedDatabase, _db.localBudgets);
  $$LocalBudgetCategoriesTableTableManager get localBudgetCategories =>
      $$LocalBudgetCategoriesTableTableManager(
        _db.attachedDatabase,
        _db.localBudgetCategories,
      );
}
