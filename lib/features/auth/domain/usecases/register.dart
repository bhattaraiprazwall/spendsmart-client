import 'package:spendsmart/features/auth/domain/repositories/auth_repository.dart';

class Register {
  final AuthRepository _repository;

  Register(this._repository);

  Future<void> call({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _repository.register(
      name: name,
      email: email,
      password: password,
    );
    if (response["statusCode"] != 201) {
      throw Exception(response["data"]["message"] ?? "Registration failed");
    }
  }
}
