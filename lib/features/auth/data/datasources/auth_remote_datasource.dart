import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/services/api_service.dart';
import 'package:spendsmart/features/auth/data/models/login_request_model.dart';
import 'package:spendsmart/features/auth/data/models/register_request_model.dart';

class AuthRemoteDataSource {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final request = RegisterRequestModel(
      name: name,
      email: email,
      password: password,
    );
    final response = await _apiService.post(ApiConstants.register, request.toJson());
    return response;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequestModel(email: email, password: password);
    final response = await _apiService.post(ApiConstants.login, request.toJson());

    if (response["statusCode"] != 200) {
      final message = response["data"]["message"] ?? "Login failed";
      throw Exception(message);
    }
    return response["data"];
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
