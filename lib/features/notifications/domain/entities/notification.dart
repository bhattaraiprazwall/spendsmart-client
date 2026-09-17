import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String type;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  NotificationItem copyWith({
    String? id,
    String? type,
    String? title,
    String? message,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  factory NotificationItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return NotificationItem(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      isRead: (json['isRead'] as bool?) ?? false,
    );
  }

  IconData get icon {
    switch (type) {
      case 'Budget Alert':
        return Icons.warning_amber_rounded;

      case 'Reminder':
        return Icons.calendar_today_outlined;

      case 'Weekly Report':
        return Icons.bar_chart_rounded;

      case 'Goal Update':
        return Icons.flag_rounded;

      default:
        return Icons.notifications_outlined;
    }
  }

  Color get color {
    switch (type) {
      case 'Budget Alert':
        return Colors.red;

      case 'Reminder':
        return Colors.orange;

      case 'Weekly Report':
        return Colors.blue;

      case 'Goal Update':
        return Colors.green;

      default:
        return Colors.grey;
    }
  }
}