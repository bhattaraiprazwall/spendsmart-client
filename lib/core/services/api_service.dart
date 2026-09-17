import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/exceptions/network_exception.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';

class ApiService {
  final LocalStorageService _storage = LocalStorageService();
  Future<String?>? _refreshFuture;

  Future<String?> _performTokenRefresh() async {
    if (_refreshFuture != null) {
      return _refreshFuture;
    }
    _refreshFuture = _doTokenRefresh();
    try {
      return await _refreshFuture;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<String?> _doTokenRefresh() async {
    final refreshToken = await _storage.getRefreshToken();

    if (refreshToken == null) return null;

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.refresh),
        body: jsonEncode({
          "refreshToken": refreshToken,
        }),
        headers: {
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final newIdToken = data["data"]["idToken"];
        final newRefreshToken = data["data"]["refreshToken"];

        await _storage.saveToken(newIdToken);
        if (newRefreshToken != null) {
          await _storage.saveRefreshToken(newRefreshToken);
        }

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
    try {
      final uri = Uri.parse(url);

      final finalHeaders =
          headers ??
          {
            "Content-Type": "application/json",
          };

      http.Response response;

      final encodedBody = body != null ? jsonEncode(body) : null;

      const timeout = Duration(seconds: 8);

      // Initial request
      switch (method.toUpperCase()) {
        case 'POST':
          response = await http
              .post(
                uri,
                headers: finalHeaders,
                body: encodedBody,
              )
              .timeout(timeout);
          break;

        case 'PUT':
          response = await http
              .put(
                uri,
                headers: finalHeaders,
                body: encodedBody,
              )
              .timeout(timeout);
          break;

        case 'PATCH':
          response = await http
              .patch(
                uri,
                headers: finalHeaders,
                body: encodedBody,
              )
              .timeout(timeout);
          break;

        case 'DELETE':
          response = await http
              .delete(
                uri,
                headers: finalHeaders,
              )
              .timeout(timeout);
          break;

        default:
          response = await http
              .get(
                uri,
                headers: finalHeaders,
              )
              .timeout(timeout);
      }

      // Debug logs
      print('URL: ${response.request?.url}');
      print('STATUS: ${response.statusCode}');
      print('BODY: ${response.body}');

      // Token expired / Unauthorized
      if (response.statusCode == 401) {
        final isAuthEndpoint = url == ApiConstants.login ||
            url == ApiConstants.register ||
            url == ApiConstants.refresh;

        if (!isAuthEndpoint) {
          final newToken = await _performTokenRefresh();

          if (newToken != null) {
            final retryHeaders = Map<String, String>.from(finalHeaders);
            retryHeaders["Authorization"] = "Bearer $newToken";

            // Retry request with new token
            switch (method.toUpperCase()) {
              case 'POST':
                response = await http
                    .post(
                      uri,
                      headers: retryHeaders,
                      body: encodedBody,
                    )
                    .timeout(timeout);
                break;

              case 'PUT':
                response = await http
                    .put(
                      uri,
                      headers: retryHeaders,
                      body: encodedBody,
                    )
                    .timeout(timeout);
                break;

              case 'PATCH':
                response = await http
                    .patch(
                      uri,
                      headers: retryHeaders,
                      body: encodedBody,
                    )
                    .timeout(timeout);
                break;

              case 'DELETE':
                response = await http
                    .delete(
                      uri,
                      headers: retryHeaders,
                    )
                    .timeout(timeout);
                break;

              default:
                response = await http
                    .get(
                      uri,
                      headers: retryHeaders,
                    )
                    .timeout(timeout);
            }

            // If still 401 after retry, throw UnauthorizedException
            if (response.statusCode == 401) {
              await _storage.clearAuth();
              throw UnauthorizedException();
            }
          } else {
            await _storage.clearAuth();
            throw UnauthorizedException();
          }
        }
      }

      return {
        "statusCode": response.statusCode,
        "data": jsonDecode(response.body),
      };
    } on SocketException catch (_) {
      throw const NetworkException('No internet connection. Please check your network.');
    } on http.ClientException catch (e) {
      if (e.message.contains('SocketException') ||
          e.message.contains('No route to host') ||
          e.message.contains('Network is unreachable') ||
          e.message.contains('Failed host lookup') ||
          e.message.contains('errno')) {
        throw const NetworkException('No internet connection. Please check your network.');
      }
      throw NetworkException(e.message);
    } on TimeoutException catch (_) {
      throw const NetworkException('Connection timed out. Please check your network.');
    } on HandshakeException catch (_) {
      throw const NetworkException('Connection security error. Please check your network.');
    }
  }

  Future<Map<String, dynamic>> post(
    String url,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    return _request(
      'POST',
      url,
      body: body,
      headers: headers,
    );
  }

  Future<Map<String, dynamic>> put(
    String url,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    return _request(
      'PUT',
      url,
      body: body,
      headers: headers,
    );
  }

  Future<Map<String, dynamic>> patch(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _request(
      'PATCH',
      url,
      body: body,
      headers: headers,
    );
  }

  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    return _request(
      'GET',
      url,
      headers: headers,
    );
  }

  Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    return _request(
      'DELETE',
      url,
      headers: headers,
    );
  }
}