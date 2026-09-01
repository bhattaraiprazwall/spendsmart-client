import 'package:spendsmart/features/profile/domain/entities/profile.dart';
import 'package:spendsmart/features/profile/domain/repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository _repository;

  GetProfile(this._repository);

  Future<Profile> call(String idToken) {
    return _repository.getProfile(idToken);
  }
}
