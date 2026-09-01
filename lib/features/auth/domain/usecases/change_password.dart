import 'package:spendsmart/features/auth/domain/repositories/auth_repository.dart';

class ChangePassword {
  final AuthRepository _repository;

  ChangePassword(this._repository);

  Future<void> call({
    required String idToken,
    required String currentPassword,
    required String newPassword,
  }) async {
    return _repository.changePassword(
      idToken,
      currentPassword,
      newPassword,
    );
  }
}
