import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/services/api_service.dart';
import 'package:spendsmart/features/profile/data/models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> uploadAvatar(String idToken, File imageFile);
  Future<ProfileModel> getProfile(String idToken);
  Future<ProfileModel> updateProfile(
    String idToken, {
    String? name,
    String? avatarUrl,
  });
  Future<ProfileModel> updateSettings(
    String idToken, {
    String? currency,
    String? theme,
    String? language,
    bool? notificationsEnabled,
    int? budgetAlertThreshold,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService _apiService;

  ProfileRemoteDataSourceImpl({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  @override
  Future<ProfileModel> uploadAvatar(String idToken, File imageFile) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConstants.uploadAvatar),
    );
    request.headers['Authorization'] = 'Bearer $idToken';

    final ext = imageFile.path.split('.').last.toLowerCase();
    MediaType contentType;
    if (ext == 'png') {
      contentType = MediaType('image', 'png');
    } else if (ext == 'webp') {
      contentType = MediaType('image', 'webp');
    } else {
      contentType = MediaType('image', 'jpeg');
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'avatar',
        imageFile.path,
        contentType: contentType,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    debugPrint('UPLOAD AVATAR STATUS: ${response.statusCode}');
    debugPrint('UPLOAD AVATAR BODY: ${response.body}');

    if (response.statusCode != 200) {
      String errorMessage = "Failed to upload avatar (${response.statusCode})";
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded['message'] != null) {
          errorMessage = decoded['message'];
        }
      } catch (_) {}
      throw Exception(errorMessage);
    }

    final decoded = jsonDecode(response.body);
    final data = decoded["data"];
    if (data is Map<String, dynamic> && data.containsKey("email")) {
      return ProfileModel.fromJson(data);
    }
    return getProfile(idToken);
  }

  @override
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

  @override
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

  @override
  Future<ProfileModel> updateSettings(
    String idToken, {
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
    if (notificationsEnabled != null) {
      body["notificationsEnabled"] = notificationsEnabled;
    }
    if (budgetAlertThreshold != null) {
      body["budgetAlertThreshold"] = budgetAlertThreshold;
    }
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
