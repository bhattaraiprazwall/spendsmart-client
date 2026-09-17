import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/services/api_service.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';

abstract class NotificationRemoteDataSource {
  Future<Map<String, dynamic>> getNotifications({String? token});
  Future<Map<String, dynamic>> markAsRead(String notificationId, {String? token});
  Future<Map<String, dynamic>> markAllAsRead({String? token});
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiService _apiService;
  final LocalStorageService _storage;

  NotificationRemoteDataSourceImpl({
    ApiService? apiService,
    LocalStorageService? storageService,
  })  : _apiService = apiService ?? ApiService(),
        _storage = storageService ?? LocalStorageService();

  @override
  Future<Map<String, dynamic>> getNotifications({String? token}) async {
    final effectiveToken = token ?? await _storage.getToken();
    return _apiService.get(
      ApiConstants.notifications,
      headers: {
        'Content-Type': 'application/json',
        if (effectiveToken != null) 'Authorization': 'Bearer $effectiveToken',
      },
    );
  }

  @override
  Future<Map<String, dynamic>> markAsRead(String notificationId, {String? token}) async {
    final effectiveToken = token ?? await _storage.getToken();
    return _apiService.patch(
      '${ApiConstants.notifications}/$notificationId/read',
      body: {},
      headers: {
        'Content-Type': 'application/json',
        if (effectiveToken != null) 'Authorization': 'Bearer $effectiveToken',
      },
    );
  }

  @override
  Future<Map<String, dynamic>> markAllAsRead({String? token}) async {
    final effectiveToken = token ?? await _storage.getToken();
    return _apiService.patch(
      '${ApiConstants.notifications}/read-all',
      body: {},
      headers: {
        'Content-Type': 'application/json',
        if (effectiveToken != null) 'Authorization': 'Bearer $effectiveToken',
      },
    );
  }
}
