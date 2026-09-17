import 'package:drift/drift.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';

@DataClassName('LocalTransaction')
class LocalTransactions extends Table {
  TextColumn get id => text()(); // UUID String
  TextColumn get userId => text()();
  TextColumn get type => text().withDefault(const Constant('EXPENSE'))(); // 'EXPENSE' | 'INCOME'
  RealColumn get amount => real()();
  TextColumn get title => text()();
  TextColumn get note => text().nullable()();
  TextColumn get paymentMethod => text().withDefault(const Constant('CARD'))();
  DateTimeColumn get date => dateTime()();
  TextColumn get categoryId => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // Sync state tracking
  IntColumn get syncStatus => intEnum<SyncStatus>().withDefault(Constant(SyncStatus.synced.index))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
