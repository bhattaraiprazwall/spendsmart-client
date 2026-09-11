import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/services/api_service.dart';

import '../models/monthly_forecast_model.dart';

class ForecastRemoteDataSource {
  final ApiService _apiService = ApiService();

  Future<MonthlyForecastModel> getMonthlyForecast(
    String token,
  ) async {
    final response = await _apiService.get(
      ApiConstants.monthlyForecast,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response['statusCode'] == 200) {
      return MonthlyForecastModel.fromJson(
        response['data']['data'],
      );
    }

    throw Exception(
      response['data']['message'] ??
          'Failed to fetch monthly forecast',
    );
  }
}