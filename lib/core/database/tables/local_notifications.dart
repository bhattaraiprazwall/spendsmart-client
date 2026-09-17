import 'package:drift/drift.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';

@DataClassName('LocalNotification')
class LocalNotifications extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get type => text()();
  TextColumn get title => text()();
  TextColumn get message => text()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // Sync state tracking
  IntColumn get syncStatus => intEnum<SyncStatus>().withDefault(Constant(SyncStatus.synced.index))();

  @override
  Set<Column> get primaryKey => {id};
}
