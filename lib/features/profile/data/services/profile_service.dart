import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/services/api_service.dart';
import 'package:spendsmart/features/profile/data/models/profile_model.dart';

class ProfileService {
  final ApiService _apiService = ApiService();

  Future<ProfileModel> getProfile(String idToken) async {
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
    return ProfileModel.fromJson(response["data"]["data"]);
  }

  Future<ProfileModel> updateProfile(
    String idToken, {
    String? name,
    String? avatarUrl,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body["name"] = name;
    if (avatarUrl != null) body["avatarUrl"] = avatarUrl;

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

    return ProfileModel.fromJson(response["data"]["data"]);
  }

  Future<ProfileModel> updateSettings(
    String idToken,{
    String? currency,
    String? theme,
    String? language,
    bool? notificationsEnabled,
    int? budgetAlertThreshold,
  }) async {
    final body = <String, dynamic>{};
    if (currency != null) body["currency"] = currency;
    if (theme != null) body["theme"] = theme;
    if (language != null) body["language"] = language;
    if (notificationsEnabled != null) body["notificationsEnabled"] = notificationsEnabled;
    if (budgetAlertThreshold != null) body["budgetAlertThreshold"] = budgetAlertThreshold;
    final response = await _apiService.put(
      ApiConstants.profileSettings,
      body,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      },
    );
    if (response["statusCode"] != 200) {
      throw Exception(
        response["data"]["message"] ?? "Failed to update settings",
      );
    }
    return ProfileModel.fromJson(response["data"]["data"]);
  }
}
