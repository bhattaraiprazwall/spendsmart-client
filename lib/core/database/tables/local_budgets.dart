import 'package:drift/drift.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';

@DataClassName('LocalBudget')
class LocalBudgets extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  IntColumn get month => integer()(); // 1-12
  IntColumn get year => integer()();
  RealColumn get totalAmount => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // Sync state tracking
  IntColumn get syncStatus => intEnum<SyncStatus>().withDefault(Constant(SyncStatus.synced.index))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LocalBudgetCategory')
class LocalBudgetCategories extends Table {
  TextColumn get id => text()();
  TextColumn get budgetId => text()();
  TextColumn get categoryId => text()();
  RealColumn get limit => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // Sync state tracking
  IntColumn get syncStatus => intEnum<SyncStatus>().withDefault(Constant(SyncStatus.synced.index))();

  @override
  Set<Column> get primaryKey => {id};
}
