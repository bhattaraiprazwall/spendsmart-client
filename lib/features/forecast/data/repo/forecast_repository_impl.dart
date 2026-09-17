import 'package:spendsmart/features/forecast/data/datasources/forecast_local_data_source.dart';
import 'package:spendsmart/features/forecast/data/datasources/forecast_remote_data_source.dart';
import 'package:spendsmart/features/forecast/domain/entities/monthly_forecast.dart';
import 'package:spendsmart/features/forecast/domain/repo/forecast_repository.dart';

class ForecastRepositoryImpl implements ForecastRepository {
  final ForecastRemoteDataSource _remoteDataSource;
  final ForecastLocalDataSource _localDataSource;

  ForecastRepositoryImpl({
    required ForecastRemoteDataSource remoteDataSource,
    required ForecastLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<MonthlyForecast> getMonthlyForecast(String token) async {
    if (token.isNotEmpty) {
      try {
        final model = await _remoteDataSource.getMonthlyForecast(token);
        return model.toEntity();
      } catch (_) {
        // Fallback to local computation
      }
    }

    return _localDataSource.computeLocalForecast();
  }
}