class ApiConstants {
  static const String baseUrl = 'http://localhost:5000/api';

  static const String register = '$baseUrl/v1/auth/register';

  static const String login = "$baseUrl/v1/auth/login";

//profile page routes
  static const String profile = "$baseUrl/v1/users/me";

  static const String changePassword = '$baseUrl/v1/auth/change-password';

  static const String profileSettings = '$baseUrl/v1/users/me/settings';
}
