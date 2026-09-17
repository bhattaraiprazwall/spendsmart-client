import 'dart:io';
import 'package:spendsmart/features/profile/domain/entities/profile.dart';
import 'package:spendsmart/features/profile/domain/repositories/profile_repository.dart';

class UploadAvatar {
  final ProfileRepository _repository;

  UploadAvatar(this._repository);

  Future<Profile> call(String idToken, File imageFile) {
    return _repository.uploadAvatar(idToken, imageFile);
  }
}
