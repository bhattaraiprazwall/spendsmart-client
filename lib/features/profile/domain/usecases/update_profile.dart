import 'package:spendsmart/features/profile/domain/entities/profile.dart';
import 'package:spendsmart/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository _repository;

  UpdateProfile(this._repository);

  Future<Profile> call(
    String idToken, {
    String? name,
    String? avatarUrl,
  }) {
    return _repository.updateProfile(
      idToken,
      name: name,
      avatarUrl: avatarUrl,
    );
  }
}
