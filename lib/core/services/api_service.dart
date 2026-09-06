import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';

class ApiService {
  final LocalStorageService _storage = LocalStorageService();

  Future<String?> _performTokenRefresh() async {
    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null) return null;

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.refresh),
        body: jsonEncode({"refreshToken": refreshToken}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newIdToken = data["data"]["idToken"];
        final newRefreshToken = data["data"]["refreshToken"];

        await _storage.saveToken(newIdToken);
        await _storage.saveRefreshToken(newRefreshToken);
        return newIdToken;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<Map<String, dynamic>> _request(
    String method,
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse(url);
    final finalHeaders = headers ?? {"Content-Type": "application/json"};
    
    http.Response response;
    
    switch (method.toUpperCase()) {
      case 'POST':
        response = await http.post(uri, headers: finalHeaders, body: jsonEncode(body));
        break;
      case 'PUT':
        response = await http.put(uri, headers: finalHeaders, body: jsonEncode(body));
        break;
      case 'DELETE':
        response = await http.delete(uri, headers: finalHeaders);
        break;
      default:
        response = await http.get(uri, headers: finalHeaders);
    }

    if (response.statusCode == 401) {
      final newToken = await _performTokenRefresh();
      if (newToken != null) {
        final retryHeaders = Map<String, String>.from(finalHeaders);
        retryHeaders["Authorization"] = "Bearer $newToken";
        
        switch (method.toUpperCase()) {
          case 'POST':
            response = await http.post(uri, headers: retryHeaders, body: jsonEncode(body));
            break;
          case 'PUT':
            response = await http.put(uri, headers: retryHeaders, body: jsonEncode(body));
            break;
          case 'DELETE':
            response = await http.delete(uri, headers: retryHeaders);
            break;
          default:
            response = await http.get(uri, headers: retryHeaders);
        }
      } else {
        throw UnauthorizedException();
      }
    }

    return {
      "statusCode": response.statusCode,
      "data": jsonDecode(response.body),
    };
  }

  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    return _request('POST', url, body: body, headers: headers);
  }

  Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    return _request('PUT', url, body: body, headers: headers);
  }

  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    return _request('GET', url, headers: headers);
  }

  Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    return _request('DELETE', url, headers: headers);
  }
}
