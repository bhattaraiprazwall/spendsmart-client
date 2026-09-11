import '../../domain/entities/notification.dart';

class NotificationModel extends NotificationItem {
  const NotificationModel({
    required super.id,
    required super.type,
    required super.title,
    required super.message,
    required super.createdAt,
    required super.isRead,
  });

  factory NotificationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return NotificationModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      isRead: json['isRead'] as bool,
    );
  }
}