import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<List<NotificationItem>> getNotifications();

  Future<void> markAsRead(String notificationId);

  Future<void> markAllAsRead();
}