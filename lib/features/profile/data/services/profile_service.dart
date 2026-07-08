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

    return response["data"]["data"];
  }

  Future<Map<String, dynamic>> updateProfile(
    String idToken, {
    String? name,
    String? avatarUrl,
    String? password,
    String? currency,
    String? theme,
    String? language,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body["name"] = name;
    if (avatarUrl != null) body["avatarUrl"] = avatarUrl;
    if (password != null) body["password"] = password;
    if (currency != null) body["currency"] = currency;
    if (theme != null) body["theme"] = theme;
    if (language != null) body["language"] = language;

    final response = await _apiService.put(
      ApiConstants.profile,
      body,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      },
    );

    if (response["statusCode"] != 200) {
      throw Exception(
        response["data"]["message"] ?? "Failed to update profile",
      );
    }

    return response["data"]["data"];
  }
}
