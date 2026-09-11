import '../entities/monthly_forecast.dart';

abstract class ForecastRepository {
  Future<MonthlyForecast> getMonthlyForecast(
    String token,
  );
}