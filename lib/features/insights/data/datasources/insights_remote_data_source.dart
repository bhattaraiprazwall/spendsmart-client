import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/services/api_service.dart';
import '../models/insight_model.dart';

class InsightsRemoteDataSource {
  final ApiService _apiService = ApiService();

  Future<InsightModel> getInsights(String token, String period) async {
    final response = await _apiService.get(
      '${ApiConstants.insights}?period=$period',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response['statusCode'] == 200) {
      return InsightModel.fromJson(response['data']['data']);
    } else {
      throw Exception(response['data']['message'] ?? 'Failed to load insights');
    }
  }
}
