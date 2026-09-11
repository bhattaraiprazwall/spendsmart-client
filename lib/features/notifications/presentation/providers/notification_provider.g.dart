// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
    r'27c104d28a9c4267b7da490aadc3030713752516';

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
    r'1d72aedf961fc7f7fba8b4493771db8e633c5dd8';

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
    r'88cb53ede088fa9c559ae02804e019fda76314df';

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
