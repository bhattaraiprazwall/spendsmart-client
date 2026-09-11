import '../repo/notification_repository.dart';

class MarkNotificationAsRead {
  final NotificationRepository _repository;

  MarkNotificationAsRead(this._repository);

  Future<void> call(String notificationId) {
    return _repository.markAsRead(notificationId);
  }
}