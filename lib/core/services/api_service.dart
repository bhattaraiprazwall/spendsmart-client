import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  Future<void> syncUser(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/sync-user'),
      headers: {"Authorization": "Bearer $token"},
    );

    print(response.body);
  }

  Future<void> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {"Authorization": "Bearer $token"},
    );

    print(response.body);
  }
}
