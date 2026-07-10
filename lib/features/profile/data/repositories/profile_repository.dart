import 'package:spendsmart/features/profile/data/models/profile_model.dart';
import 'package:spendsmart/features/profile/data/services/profile_service.dart';

class ProfileRepository {
  final ProfileService _profileService = ProfileService();

  Future<ProfileModel> getProfile(String idToken) async {
    return await _profileService.getProfile(idToken);
  }

  Future<ProfileModel> updateProfile(
    String idToken, {
    String? name,
    String? avatarUrl,
    String? password,
    String? currency,
    String? theme,
    String? language,
  }) async {
    return await _profileService.updateProfile(
      idToken,
      name: name,
      avatarUrl: avatarUrl,
      password: password,
      currency: currency,
      theme: theme,
      language: language,
    );
  }
}
