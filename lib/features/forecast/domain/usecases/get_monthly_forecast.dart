import 'package:spendsmart/features/forecast/domain/entities/monthly_forecast.dart';
import 'package:spendsmart/features/forecast/domain/repo/forecast_repository.dart';

class GetMonthlyForecast {
  final ForecastRepository _repository;

  GetMonthlyForecast(this._repository);

  Future<MonthlyForecast> call(String token) {
    return _repository.getMonthlyForecast(token);
  }
}
