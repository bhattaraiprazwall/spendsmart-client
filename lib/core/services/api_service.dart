import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost/api';

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

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return body as Map<String, dynamic>;
    } else {
      final message = body is Map ? (body['message'] ?? 'Registration failed') : 'Registration failed';
      throw Exception(message);
    }
  }
}
