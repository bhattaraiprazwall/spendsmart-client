import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/database/database_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';

import '../../data/datasources/notification_local_data_source.dart';
import '../../data/datasources/notification_remote_data_source.dart';
import '../../data/repo/notification_repository_impl.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repo/notification_repository.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_as_read.dart';

part 'notification_provider.g.dart';

@riverpod
NotificationLocalDataSource notificationLocalDataSource(Ref ref) {
  return NotificationLocalDataSourceImpl(
    notificationDao: ref.watch(notificationDaoProvider),
    storageService: ref.watch(storageServiceProvider),
  );
}

@riverpod
NotificationRemoteDataSource notificationRemoteDataSource(Ref ref) {
  return NotificationRemoteDataSourceImpl(
    storageService: ref.watch(storageServiceProvider),
  );
}

@riverpod
NotificationRepository notificationRepository(Ref ref) {
  return NotificationRepositoryImpl(
    ref.watch(notificationRemoteDataSourceProvider),
    ref.watch(notificationLocalDataSourceProvider),
  );
}

@riverpod
GetNotifications getNotifications(Ref ref) {
  return GetNotifications(
    ref.watch(notificationRepositoryProvider),
  );
}

@riverpod
MarkNotificationAsRead markNotificationAsRead(Ref ref) {
  return MarkNotificationAsRead(
    ref.watch(notificationRepositoryProvider),
  );
}

@riverpod
class NotificationNotifier extends _$NotificationNotifier {
  @override
  Future<List<NotificationItem>> build() async {
    return ref.read(getNotificationsProvider).call();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(
      () => ref.read(getNotificationsProvider).call(),
    );
  }

  Future<void> markAsRead(String notificationId) async {
    final currentList = state.asData?.value;
    if (currentList != null) {
      state = AsyncData(
        currentList.map((item) {
          if (item.id == notificationId) {
            return item.copyWith(isRead: true);
          }
          return item;
        }).toList(),
      );
    }

    try {
      await ref
          .read(markNotificationAsReadProvider)
          .call(notificationId);
      await refresh();
    } catch (_) {
      await refresh();
    }
  }

  Future<void> markAllAsRead() async {
    final currentList = state.asData?.value;
    if (currentList != null) {
      state = AsyncData(
        currentList.map((item) => item.copyWith(isRead: true)).toList(),
      );
    }

    try {
      await ref.read(notificationRepositoryProvider).markAllAsRead();
      await refresh();
    } catch (_) {
      await refresh();
    }
  }
}