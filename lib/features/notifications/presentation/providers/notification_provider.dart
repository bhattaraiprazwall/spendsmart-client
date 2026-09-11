import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/notification_remote_data_source.dart';
import '../../data/repo/notification_repository_impl.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repo/notification_repository.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_as_read.dart';

part 'notification_provider.g.dart';

@riverpod
NotificationRemoteDataSource notificationRemoteDataSource(Ref ref) {
  return NotificationRemoteDataSource();
}

@riverpod
NotificationRepository notificationRepository(Ref ref) {
  return NotificationRepositoryImpl(
    ref.watch(notificationRemoteDataSourceProvider),
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
    await ref
        .read(markNotificationAsReadProvider)
        .call(notificationId);

    await refresh();
  }
}