import 'package:spendsmart/features/auth/data/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _authService.register(
      name: name,
      email: email,
      password: password,
    );
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await _authService.login(email: email, password: password);
  }
}
