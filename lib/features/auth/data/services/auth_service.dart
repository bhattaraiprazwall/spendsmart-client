import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/services/api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(ApiConstants.register, {
      "name": name,
      "email": email,
      "password": password,
    });
    return response;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(ApiConstants.login, {
      "email": email,
      "password": password,
    });
    // Throw here with the backend's friendly message

    if (response["statusCode"] != 200) {
      final message = response["data"]["message"] ?? "Login failed";
      throw Exception(message);
    }
    return response["data"]; // { idToken, refreshToken, expiresIn }
  }

  Future<void> changePassword(
    String idToken,
    String currentPassword,
    String newPassword,
  ) async {
    final response = await _apiService.post(
      ApiConstants.changePassword,
      {"currentPassword": currentPassword, "newPassword": newPassword},
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      },
    );
    if (response["statusCode"] != 200) {
      final message =
          response["data"]["message"] ?? "Failed to change password";
      throw Exception(message);
    }
  }
}
