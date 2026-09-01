import 'package:spendsmart/features/profile/domain/entities/profile.dart';
import 'package:spendsmart/features/profile/domain/repositories/profile_repository.dart';

class UpdateSettings {
  final ProfileRepository _repository;

  UpdateSettings(this._repository);

  Future<Profile> call(
    String idToken, {
    String? currency,
    String? theme,
    String? language,
    bool? notificationsEnabled,
    int? budgetAlertThreshold,
  }) {
    return _repository.updateSettings(
      idToken,
      currency: currency,
      theme: theme,
      language: language,
      notificationsEnabled: notificationsEnabled,
      budgetAlertThreshold: budgetAlertThreshold,
    );
  }
}
