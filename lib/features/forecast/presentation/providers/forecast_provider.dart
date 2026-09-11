import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/providers/core_providers.dart';

import '../../data/datasources/forecast_remote_data_source.dart';
import '../../data/repo/forecast_repository_impl.dart';
import '../../domain/entities/monthly_forecast.dart';
import '../../domain/repo/forecast_repository.dart';
import '../../domain/usecases/get_monthly_forecast.dart';

part 'forecast_provider.g.dart';

@riverpod
ForecastRemoteDataSource forecastRemoteDataSource(
  Ref ref,
) {
  return ForecastRemoteDataSource();
}

@riverpod
ForecastRepository forecastRepository(Ref ref) {
  return ForecastRepositoryImpl(ref.watch(forecastRemoteDataSourceProvider));
}

@riverpod
GetMonthlyForecast getMonthlyForecast(Ref ref) {
  return GetMonthlyForecast(ref.watch(forecastRepositoryProvider));
}

@riverpod
Future<MonthlyForecast> monthlyForecast(Ref ref) async {
  final storageService = ref.watch(storageServiceProvider);

  final token = await storageService.getToken();

  if (token == null || token.isEmpty) {
    throw Exception('Authentication token not found');
  }

  return ref.watch(getMonthlyForecastProvider).call(token);
}
