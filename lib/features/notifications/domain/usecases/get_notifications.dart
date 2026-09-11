import '../entities/notification.dart';
import '../repo/notification_repository.dart';

class GetNotifications {
  final NotificationRepository _repository;

  GetNotifications(this._repository);

  Future<List<NotificationItem>> call() {
    return _repository.getNotifications();
  }
}