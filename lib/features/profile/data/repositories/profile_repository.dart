import 'package:spendsmart/features/profile/data/services/profile_service.dart';

class ProfileRepository {
  final ProfileService _profileService = ProfileService();

  Future<Map<String, dynamic>> getProfile(String idToken) async {
    return await _profileService.getProfile(idToken);
  }
}
