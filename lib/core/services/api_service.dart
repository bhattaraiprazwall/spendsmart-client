import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';

class ApiService {
  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body,
    {Map<String, String>? headers,}
  ) async {
    final response = await http.post(
      Uri.parse(url),
      headers: headers ??  {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode == 401) throw UnauthorizedException();

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    final response = await http.put(
      Uri.parse(url),
      headers: headers ?? {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    if (response.statusCode == 401) throw UnauthorizedException();
    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    final response = await http.get(
      Uri.parse(url),
      headers: headers ?? {"Content-Type": "application/json"},
    );
    if (response.statusCode == 401) throw UnauthorizedException();
    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }
}
