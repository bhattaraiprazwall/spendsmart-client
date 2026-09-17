import 'package:drift/drift.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';

@DataClassName('LocalCategory')
class LocalCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  TextColumn get color => text()();
  TextColumn get canonicalKey => text().nullable()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  TextColumn get type => text().withDefault(const Constant('EXPENSE'))(); // 'EXPENSE' | 'INCOME'
  TextColumn get userId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  // Sync state tracking
  IntColumn get syncStatus => intEnum<SyncStatus>().withDefault(Constant(SyncStatus.synced.index))();

  @override
  Set<Column> get primaryKey => {id};
}
