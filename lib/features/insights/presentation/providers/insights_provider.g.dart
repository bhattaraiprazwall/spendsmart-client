// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insights_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(insightsLocalDataSource)
final insightsLocalDataSourceProvider = InsightsLocalDataSourceProvider._();

final class InsightsLocalDataSourceProvider
    extends
        $FunctionalProvider<
          InsightsLocalDataSource,
          InsightsLocalDataSource,
          InsightsLocalDataSource
        >
    with $Provider<InsightsLocalDataSource> {
  InsightsLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insightsLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$insightsLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<InsightsLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InsightsLocalDataSource create(Ref ref) {
    return insightsLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InsightsLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InsightsLocalDataSource>(value),
    );
  }
}

String _$insightsLocalDataSourceHash() =>
    r'2e422fea340d5914d30d5e39e51e9df430db4226';

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
    r'b5749399049c7085e6aea310d785f996987b8349';

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
    r'b3bddd8502087a86a4f0fd3d0183e8da79572489';

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

@ProviderFor(getSpendingAnomaly)
final getSpendingAnomalyProvider = GetSpendingAnomalyProvider._();

final class GetSpendingAnomalyProvider
    extends
        $FunctionalProvider<
          GetSpendingAnomaly,
          GetSpendingAnomaly,
          GetSpendingAnomaly
        >
    with $Provider<GetSpendingAnomaly> {
  GetSpendingAnomalyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getSpendingAnomalyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getSpendingAnomalyHash();

  @$internal
  @override
  $ProviderElement<GetSpendingAnomaly> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetSpendingAnomaly create(Ref ref) {
    return getSpendingAnomaly(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetSpendingAnomaly value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetSpendingAnomaly>(value),
    );
  }
}

String _$getSpendingAnomalyHash() =>
    r'699f8ba23d65342466649a6599195c0941d1229f';

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

@ProviderFor(InsightsNotifier)
final insightsProvider = InsightsNotifierProvider._();

final class InsightsNotifierProvider
    extends $AsyncNotifierProvider<InsightsNotifier, Insight> {
  InsightsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'insightsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$insightsNotifierHash();

  @$internal
  @override
  InsightsNotifier create() => InsightsNotifier();
}

String _$insightsNotifierHash() => r'2035faedf3bf8ef09dcb29a624c130dae0b4092f';

abstract class _$InsightsNotifier extends $AsyncNotifier<Insight> {
  FutureOr<Insight> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Insight>, Insight>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Insight>, Insight>,
              AsyncValue<Insight>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(SpendingAnomalyNotifier)
final spendingAnomalyProvider = SpendingAnomalyNotifierProvider._();

final class SpendingAnomalyNotifierProvider
    extends $AsyncNotifierProvider<SpendingAnomalyNotifier, SpendingAnomaly> {
  SpendingAnomalyNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'spendingAnomalyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$spendingAnomalyNotifierHash();

  @$internal
  @override
  SpendingAnomalyNotifier create() => SpendingAnomalyNotifier();
}

String _$spendingAnomalyNotifierHash() =>
    r'e7a9bf21886832945e454592e61e2f2ff1056ddf';

abstract class _$SpendingAnomalyNotifier
    extends $AsyncNotifier<SpendingAnomaly> {
  FutureOr<SpendingAnomaly> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SpendingAnomaly>, SpendingAnomaly>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SpendingAnomaly>, SpendingAnomaly>,
              AsyncValue<SpendingAnomaly>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
