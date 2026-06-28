class ApiConstants {
  static const String baseUrl = 'http://localhost:5000/api';

  static const String register = '$baseUrl/v1/auth/register';

  static const String login = "$baseUrl/v1/auth/login";

  static const String profile = "$baseUrl/v1/users/me";
}
