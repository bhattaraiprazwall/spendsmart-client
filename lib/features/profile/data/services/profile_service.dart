import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/services/api_service.dart';

class ProfileService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getProfile(String idToken) async {
    final response = await _apiService.get(
      ApiConstants.profile,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      },
    );

    if (response["statusCode"] != 200) {
      throw Exception(response["data"]["message"] ?? "Failed to load profile");
    }

    return response["data"];
  }
}
