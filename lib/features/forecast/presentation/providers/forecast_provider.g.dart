// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
    r'cf036d7a575c5a0453b81f9f96887c669badbd6e';

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
    r'e003fc7384e45641f41626e73825466554ba6485';

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

@ProviderFor(monthlyForecast)
final monthlyForecastProvider = MonthlyForecastProvider._();

final class MonthlyForecastProvider
    extends
        $FunctionalProvider<
          AsyncValue<MonthlyForecast>,
          MonthlyForecast,
          FutureOr<MonthlyForecast>
        >
    with $FutureModifier<MonthlyForecast>, $FutureProvider<MonthlyForecast> {
  MonthlyForecastProvider._()
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
  String debugGetCreateSourceHash() => _$monthlyForecastHash();

  @$internal
  @override
  $FutureProviderElement<MonthlyForecast> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MonthlyForecast> create(Ref ref) {
    return monthlyForecast(ref);
  }
}

String _$monthlyForecastHash() => r'75c97ec46c5cc11372c33ed3e0630827098946ef';
