abstract class AuthRepository {
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<void> changePassword(
    String idToken,
    String currentPassword,
    String newPassword,
  );
}
