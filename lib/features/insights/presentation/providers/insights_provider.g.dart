// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insights_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(insightsRemoteDataSource)
final insightsRemoteDataSourceProvider = InsightsRemoteDataSourceProvider._();

final class InsightsRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          InsightsRemoteDataSource,
          InsightsRemoteDataSource,
          InsightsRemoteDataSource
        >
    with $Provider<InsightsRemoteDataSource> {
  InsightsRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insightsRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$insightsRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<InsightsRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InsightsRemoteDataSource create(Ref ref) {
    return insightsRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InsightsRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InsightsRemoteDataSource>(value),
    );
  }
}

String _$insightsRemoteDataSourceHash() =>
    r'eadcdd9f1c6a3485fdcf3cfa0d4e4329c65b3d1f';

@ProviderFor(insightsRepository)
final insightsRepositoryProvider = InsightsRepositoryProvider._();

final class InsightsRepositoryProvider
    extends
        $FunctionalProvider<
          InsightsRepository,
          InsightsRepository,
          InsightsRepository
        >
    with $Provider<InsightsRepository> {
  InsightsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insightsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$insightsRepositoryHash();

  @$internal
  @override
  $ProviderElement<InsightsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InsightsRepository create(Ref ref) {
    return insightsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InsightsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InsightsRepository>(value),
    );
  }
}

String _$insightsRepositoryHash() =>
    r'e5c838ba2a830de72964da206d911e5996d47a06';

@ProviderFor(getInsights)
final getInsightsProvider = GetInsightsProvider._();

final class GetInsightsProvider
    extends $FunctionalProvider<GetInsights, GetInsights, GetInsights>
    with $Provider<GetInsights> {
  GetInsightsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getInsightsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getInsightsHash();

  @$internal
  @override
  $ProviderElement<GetInsights> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetInsights create(Ref ref) {
    return getInsights(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetInsights value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetInsights>(value),
    );
  }
}

String _$getInsightsHash() => r'3a771cf39ba96b3d7ae5032d17f3c539f8ae6214';

@ProviderFor(InsightsPeriod)
final insightsPeriodProvider = InsightsPeriodProvider._();

final class InsightsPeriodProvider
    extends $NotifierProvider<InsightsPeriod, String> {
  InsightsPeriodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insightsPeriodProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$insightsPeriodHash();

  @$internal
  @override
  InsightsPeriod create() => InsightsPeriod();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$insightsPeriodHash() => r'665c557ccd0b33179eceb4a5c0ae2bd7ecd67f57';

abstract class _$InsightsPeriod extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(insights)
final insightsProvider = InsightsProvider._();

final class InsightsProvider
    extends $FunctionalProvider<AsyncValue<Insight>, Insight, FutureOr<Insight>>
    with $FutureModifier<Insight>, $FutureProvider<Insight> {
  InsightsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insightsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$insightsHash();

  @$internal
  @override
  $FutureProviderElement<Insight> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Insight> create(Ref ref) {
    return insights(ref);
  }
}

String _$insightsHash() => r'57f76e27fb4f95342d28fd658a1ba50658544ab8';
