import 'package:drift/drift.dart';
import 'package:spendsmart/core/database/app_database.dart';
import 'package:spendsmart/core/database/tables/local_notifications.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';

part 'notification_dao.g.dart';

@DriftAccessor(tables: [LocalNotifications])
class NotificationDao extends DatabaseAccessor<AppDatabase> with _$NotificationDaoMixin {
  NotificationDao(super.db);

  /// Watch notifications for a user ordered by createdAt DESC
  Stream<List<LocalNotification>> watchNotifications(String userId) {
    return (select(localNotifications)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .watch();
  }

  /// Watch count of unread notifications
  Stream<int> watchUnreadCount(String userId) {
    final countExp = localNotifications.id.count();
    final query = selectOnly(localNotifications)
      ..addColumns([countExp])
      ..where(localNotifications.userId.equals(userId) & localNotifications.isRead.equals(false));

    return query.map((row) => row.read(countExp) ?? 0).watchSingle();
  }

  /// Get notifications for a user
  Future<List<LocalNotification>> getNotifications(String userId) {
    return (select(localNotifications)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  /// Insert single notification (e.g. from FCM)
  Future<int> insertNotification(LocalNotificationsCompanion notification) {
    return into(localNotifications).insertOnConflictUpdate(notification);
  }

  /// Batch insert notifications
  Future<void> insertNotifications(List<LocalNotificationsCompanion> notifications) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(localNotifications, notifications);
    });
  }

  /// Mark single notification as read
  Future<int> markAsRead(String id) {
    return (update(localNotifications)..where((tbl) => tbl.id.equals(id))).write(
      const LocalNotificationsCompanion(
        isRead: Value(true),
        syncStatus: Value(SyncStatus.pendingUpdate),
      ),
    );
  }

  /// Mark all notifications as read for a user
  Future<int> markAllAsRead(String userId) {
    return (update(localNotifications)..where((tbl) => tbl.userId.equals(userId))).write(
      const LocalNotificationsCompanion(
        isRead: Value(true),
        syncStatus: Value(SyncStatus.pendingUpdate),
      ),
    );
  }

  /// Get pending sync notifications
  Future<List<LocalNotification>> getPendingSync() {
    return (select(localNotifications)
          ..where((tbl) => tbl.syncStatus.isNotValue(SyncStatus.synced.index)))
        .get();
  }

  /// Mark notification as synced
  Future<int> markSynced(String id) {
    return (update(localNotifications)..where((tbl) => tbl.id.equals(id))).write(
      const LocalNotificationsCompanion(
        syncStatus: Value(SyncStatus.synced),
      ),
    );
  }
}
