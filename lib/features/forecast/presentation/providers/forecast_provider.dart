import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/database/database_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';

import '../../data/datasources/forecast_local_data_source.dart';
import '../../data/datasources/forecast_remote_data_source.dart';
import '../../data/repo/forecast_repository_impl.dart';
import '../../domain/entities/monthly_forecast.dart';
import '../../domain/repo/forecast_repository.dart';
import '../../domain/usecases/get_monthly_forecast.dart';

part 'forecast_provider.g.dart';

@riverpod
ForecastLocalDataSource forecastLocalDataSource(Ref ref) {
  return ForecastLocalDataSourceImpl(
    transactionDao: ref.watch(transactionDaoProvider),
    storageService: ref.watch(storageServiceProvider),
  );
}

@riverpod
ForecastRemoteDataSource forecastRemoteDataSource(
  Ref ref,
) {
  return ForecastRemoteDataSourceImpl();
}

@riverpod
ForecastRepository forecastRepository(Ref ref) {
  return ForecastRepositoryImpl(
    remoteDataSource: ref.watch(forecastRemoteDataSourceProvider),
    localDataSource: ref.watch(forecastLocalDataSourceProvider),
  );
}

@riverpod
GetMonthlyForecast getMonthlyForecast(Ref ref) {
  return GetMonthlyForecast(ref.watch(forecastRepositoryProvider));
}

@riverpod
class MonthlyForecastNotifier extends _$MonthlyForecastNotifier {
  StreamSubscription? _driftSub;

  @override
  FutureOr<MonthlyForecast> build() async {
    final localDataSource = ref.watch(forecastLocalDataSourceProvider);
    final userId = await localDataSource.getUserId();

    if (userId != null) {
      _driftSub?.cancel();
      _driftSub = localDataSource
          .watchLocalForecast(userId)
          .listen((forecast) {
        state = AsyncData(forecast);
      });
      ref.onDispose(() => _driftSub?.cancel());
    }

    final storageService = ref.watch(storageServiceProvider);
    final token = await storageService.getToken() ?? '';

    return ref.watch(getMonthlyForecastProvider).call(token);
  }
}

