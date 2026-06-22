import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  Future<Map<String,dynamic>> post(
    String url,
    Map<String,dynamic> body,
  ) async {

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type":"application/json",
      },
      body: jsonEncode(body),
    );

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }
}