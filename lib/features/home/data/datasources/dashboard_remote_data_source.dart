import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/services/api_service.dart';
import 'package:spendsmart/features/home/domain/entities/dashboard_summary.dart';

class DashboardRemoteDataSource {
  final ApiService _apiService = ApiService();

  Future<DashboardSummary> getSummary(
    String idToken, {
    int? month,
    int? year,
  }) async {
    final now = DateTime.now();
    final query = <String, String>{
      "month": (month ?? now.month).toString(),
      "year": (year ?? now.year).toString(),
    };

    final uri = Uri.parse(ApiConstants.dashboardSummary)
        .replace(queryParameters: query);

    final response = await _apiService.get(
      uri.toString(),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      },
    );

    if (response["statusCode"] != 200) {
      throw Exception(
        response["data"]["message"] ?? "Failed to load dashboard",
      );
    }

    return DashboardSummary.fromJson(
      response["data"]["data"] as Map<String, dynamic>,
    );
  }
}
