import 'package:spendsmart/features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile(String idToken);

  Future<Profile> updateProfile(
    String idToken, {
    String? name,
    String? avatarUrl,
  });

  Future<Profile> updateSettings(
    String idToken, {
    String? currency,
    String? theme,
    String? language,
    bool? notificationsEnabled,
    int? budgetAlertThreshold,
  });
}
