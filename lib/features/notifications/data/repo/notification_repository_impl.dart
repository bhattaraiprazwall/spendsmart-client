import '../../domain/entities/notification.dart';
import '../../domain/repo/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl
    implements NotificationRepository {
  final NotificationRemoteDataSource _dataSource;

  NotificationRepositoryImpl(this._dataSource);

  @override
  Future<List<NotificationItem>> getNotifications() async {
    final response = await _dataSource.getNotifications();

    if (response['statusCode'] != 200) {
      final message = response['data'] is Map
          ? response['data']['message']
          : null;
      throw Exception(message ?? 'Failed to load notifications');
    }

    final payload = response['data'];
    final List<dynamic> data;
    if (payload is Map<String, dynamic> && payload['data'] is List) {
      data = payload['data'] as List<dynamic>;
    } else if (payload is List) {
      data = payload;
    } else {
      data = [];
    }

    return data
        .map(
          (json) => NotificationModel.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final response = await _dataSource.markAsRead(notificationId);

    if (response['statusCode'] != 200) {
      final message = response['data'] is Map
          ? response['data']['message']
          : null;
      throw Exception(message ?? 'Failed to mark notification as read');
    }
  }
}