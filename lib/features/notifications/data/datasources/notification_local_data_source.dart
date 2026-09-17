import 'package:drift/drift.dart';
import 'package:spendsmart/core/database/app_database.dart';
import 'package:spendsmart/core/database/daos/notification_dao.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';
import '../models/notification_model.dart';

abstract class NotificationLocalDataSource {
  Future<List<LocalNotification>> getNotifications(String userId);
  Future<void> cacheNotifications(String userId, List<NotificationModel> models);
  Future<void> markAsRead(String notificationId);
  Future<void> markSynced(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<String?> getUserId();
  Future<String?> getToken();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final NotificationDao _notificationDao;
  final LocalStorageService _storage;

  NotificationLocalDataSourceImpl({
    required NotificationDao notificationDao,
    required LocalStorageService storageService,
  })  : _notificationDao = notificationDao,
        _storage = storageService;

  @override
  Future<String?> getUserId() => _storage.getUserId();

  @override
  Future<String?> getToken() => _storage.getToken();

  @override
  Future<List<LocalNotification>> getNotifications(String userId) {
    return _notificationDao.getNotifications(userId);
  }

  @override
  Future<void> cacheNotifications(String userId, List<NotificationModel> models) async {
    final companions = models.map((m) {
      return LocalNotificationsCompanion(
        id: Value(m.id),
        userId: Value(userId),
        type: Value(m.type),
        title: Value(m.title),
        message: Value(m.message),
        isRead: Value(m.isRead),
        createdAt: Value(m.createdAt),
        syncStatus: const Value(SyncStatus.synced),
      );
    }).toList();

    await _notificationDao.insertNotifications(companions);
  }

  @override
  Future<void> markAsRead(String notificationId) {
    return _notificationDao.markAsRead(notificationId);
  }

  @override
  Future<void> markSynced(String notificationId) {
    return _notificationDao.markSynced(notificationId);
  }

  @override
  Future<void> markAllAsRead(String userId) {
    return _notificationDao.markAllAsRead(userId);
  }
}
