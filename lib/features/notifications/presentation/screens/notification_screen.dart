import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';
import 'package:spendsmart/features/notifications/presentation/providers/notification_provider.dart';
import '../../domain/entities/notification.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final notifications = ref.watch(notificationProvider);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        elevation: 0,
        leading: BackButton(color: c.textPrimary),
        title: Text(
          context.tr('notifications'),
          style: TextStyle(
            color: c.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: notifications.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Text(
            context.tr('failed_to_load_notifications'),
            style: TextStyle(color: c.textSecondary),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Text(
                context.tr('no_notifications'),
                style: TextStyle(color: c.textSecondary),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref
                .read(notificationProvider.notifier)
                .refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: items.length,
              itemBuilder: (_, index) {
                return _buildNotificationCard(
                  context,
                  ref,
                  items[index],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    WidgetRef ref,
    NotificationItem item,
  ) {
    final c = context.colors;

    return GestureDetector(
      onTap: item.isRead
          ? null
          : () => ref
              .read(notificationProvider.notifier)
              .markAsRead(item.id),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: item.color,
              width: 4,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIconBox(item),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        color: item.color,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.message,
                      style: TextStyle(
                        color: c.textPrimary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatTime(item.createdAt),
                      style: TextStyle(
                        color: c.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (!item.isRead)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: item.color,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconBox(NotificationItem item) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: item.color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        item.icon,
        color: item.color,
        size: 20,
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inDays < 1) {
      return '${difference.inHours} hr ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}