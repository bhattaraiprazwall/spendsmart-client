// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(forecastLocalDataSource)
final forecastLocalDataSourceProvider = ForecastLocalDataSourceProvider._();

final class ForecastLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ForecastLocalDataSource,
          ForecastLocalDataSource,
          ForecastLocalDataSource
        >
    with $Provider<ForecastLocalDataSource> {
  ForecastLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forecastLocalDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forecastLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ForecastLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ForecastLocalDataSource create(Ref ref) {
    return forecastLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ForecastLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ForecastLocalDataSource>(value),
    );
  }
}

String _$forecastLocalDataSourceHash() =>
    r'a14d78602f5a04207bd68e05c3f9f752fce99e83';

@ProviderFor(forecastRemoteDataSource)
final forecastRemoteDataSourceProvider = ForecastRemoteDataSourceProvider._();

final class ForecastRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ForecastRemoteDataSource,
          ForecastRemoteDataSource,
          ForecastRemoteDataSource
        >
    with $Provider<ForecastRemoteDataSource> {
  ForecastRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forecastRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forecastRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ForecastRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ForecastRemoteDataSource create(Ref ref) {
    return forecastRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ForecastRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ForecastRemoteDataSource>(value),
    );
  }
}

String _$forecastRemoteDataSourceHash() =>
    r'2557d34a8415e6411c2ab3dc24f1dce97c7986d7';

@ProviderFor(forecastRepository)
final forecastRepositoryProvider = ForecastRepositoryProvider._();

final class ForecastRepositoryProvider
    extends
        $FunctionalProvider<
          ForecastRepository,
          ForecastRepository,
          ForecastRepository
        >
    with $Provider<ForecastRepository> {
  ForecastRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forecastRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forecastRepositoryHash();

  @$internal
  @override
  $ProviderElement<ForecastRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ForecastRepository create(Ref ref) {
    return forecastRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ForecastRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ForecastRepository>(value),
    );
  }
}

String _$forecastRepositoryHash() =>
    r'57462c227e08685ed63e6aa90d2d665fdcaa5d3a';

@ProviderFor(getMonthlyForecast)
final getMonthlyForecastProvider = GetMonthlyForecastProvider._();

final class GetMonthlyForecastProvider
    extends
        $FunctionalProvider<
          GetMonthlyForecast,
          GetMonthlyForecast,
          GetMonthlyForecast
        >
    with $Provider<GetMonthlyForecast> {
  GetMonthlyForecastProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getMonthlyForecastProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getMonthlyForecastHash();

  @$internal
  @override
  $ProviderElement<GetMonthlyForecast> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetMonthlyForecast create(Ref ref) {
    return getMonthlyForecast(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetMonthlyForecast value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetMonthlyForecast>(value),
    );
  }
}

String _$getMonthlyForecastHash() =>
    r'2b214756b754ca0c3f1d601d42d4d2c6f6dda228';

@ProviderFor(MonthlyForecastNotifier)
final monthlyForecastProvider = MonthlyForecastNotifierProvider._();

final class MonthlyForecastNotifierProvider
    extends $AsyncNotifierProvider<MonthlyForecastNotifier, MonthlyForecast> {
  MonthlyForecastNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'monthlyForecastProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$monthlyForecastNotifierHash();

  @$internal
  @override
  MonthlyForecastNotifier create() => MonthlyForecastNotifier();
}

String _$monthlyForecastNotifierHash() =>
    r'7685dbc6d7dc3ac67c1e8dcdb26d382383e09d9c';

abstract class _$MonthlyForecastNotifier
    extends $AsyncNotifier<MonthlyForecast> {
  FutureOr<MonthlyForecast> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<MonthlyForecast>, MonthlyForecast>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<MonthlyForecast>, MonthlyForecast>,
              AsyncValue<MonthlyForecast>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
