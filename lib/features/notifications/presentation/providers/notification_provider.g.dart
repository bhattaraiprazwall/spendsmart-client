// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationLocalDataSource)
final notificationLocalDataSourceProvider =
    NotificationLocalDataSourceProvider._();

final class NotificationLocalDataSourceProvider
    extends
        $FunctionalProvider<
          NotificationLocalDataSource,
          NotificationLocalDataSource,
          NotificationLocalDataSource
        >
    with $Provider<NotificationLocalDataSource> {
  NotificationLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<NotificationLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationLocalDataSource create(Ref ref) {
    return notificationLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationLocalDataSource>(value),
    );
  }
}

String _$notificationLocalDataSourceHash() =>
    r'347df999c461f696ef7de75435aa62a29c524cde';

@ProviderFor(notificationRemoteDataSource)
final notificationRemoteDataSourceProvider =
    NotificationRemoteDataSourceProvider._();

final class NotificationRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          NotificationRemoteDataSource,
          NotificationRemoteDataSource,
          NotificationRemoteDataSource
        >
    with $Provider<NotificationRemoteDataSource> {
  NotificationRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<NotificationRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationRemoteDataSource create(Ref ref) {
    return notificationRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationRemoteDataSource>(value),
    );
  }
}

String _$notificationRemoteDataSourceHash() =>
    r'95869bbc9c67f6e27022d3cac68f5114646f9aa9';

@ProviderFor(notificationRepository)
final notificationRepositoryProvider = NotificationRepositoryProvider._();

final class NotificationRepositoryProvider
    extends
        $FunctionalProvider<
          NotificationRepository,
          NotificationRepository,
          NotificationRepository
        >
    with $Provider<NotificationRepository> {
  NotificationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationRepositoryHash();

  @$internal
  @override
  $ProviderElement<NotificationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  NotificationRepository create(Ref ref) {
    return notificationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationRepository>(value),
    );
  }
}

String _$notificationRepositoryHash() =>
    r'33ab9113401a9f2084a7510525c6680d627d9045';

@ProviderFor(getNotifications)
final getNotificationsProvider = GetNotificationsProvider._();

final class GetNotificationsProvider
    extends
        $FunctionalProvider<
          GetNotifications,
          GetNotifications,
          GetNotifications
        >
    with $Provider<GetNotifications> {
  GetNotificationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getNotificationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getNotificationsHash();

  @$internal
  @override
  $ProviderElement<GetNotifications> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetNotifications create(Ref ref) {
    return getNotifications(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetNotifications value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetNotifications>(value),
    );
  }
}

String _$getNotificationsHash() => r'e24a86deeee7dd48ad43c56d8ee3f863cce50a96';

@ProviderFor(markNotificationAsRead)
final markNotificationAsReadProvider = MarkNotificationAsReadProvider._();

final class MarkNotificationAsReadProvider
    extends
        $FunctionalProvider<
          MarkNotificationAsRead,
          MarkNotificationAsRead,
          MarkNotificationAsRead
        >
    with $Provider<MarkNotificationAsRead> {
  MarkNotificationAsReadProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'markNotificationAsReadProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$markNotificationAsReadHash();

  @$internal
  @override
  $ProviderElement<MarkNotificationAsRead> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MarkNotificationAsRead create(Ref ref) {
    return markNotificationAsRead(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarkNotificationAsRead value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarkNotificationAsRead>(value),
    );
  }
}

String _$markNotificationAsReadHash() =>
    r'94f827b7b4c2972770e4bbb313b6d4fe86175eec';

@ProviderFor(NotificationNotifier)
final notificationProvider = NotificationNotifierProvider._();

final class NotificationNotifierProvider
    extends
        $AsyncNotifierProvider<NotificationNotifier, List<NotificationItem>> {
  NotificationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationNotifierHash();

  @$internal
  @override
  NotificationNotifier create() => NotificationNotifier();
}

String _$notificationNotifierHash() =>
    r'bd0fa3afc0dbb4d60fb67fd9a85fc8890dc1f9c6';

abstract class _$NotificationNotifier
    extends $AsyncNotifier<List<NotificationItem>> {
  FutureOr<List<NotificationItem>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<NotificationItem>>, List<NotificationItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<NotificationItem>>,
                List<NotificationItem>
              >,
              AsyncValue<List<NotificationItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
