import 'package:spendsmart/features/forecast/domain/repo/forecast_repository.dart';
import '../../domain/entities/monthly_forecast.dart';
import '../datasources/forecast_remote_data_source.dart';

class ForecastRepositoryImpl implements ForecastRepository {
  final ForecastRemoteDataSource _remoteDataSource;

  ForecastRepositoryImpl(this._remoteDataSource);

  @override
  Future<MonthlyForecast> getMonthlyForecast(String token) async {
    final model =
        await _remoteDataSource.getMonthlyForecast(token);

    return model.toEntity();
  }
}