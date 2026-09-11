import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/services/api_service.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';

class NotificationRemoteDataSource {
  final ApiService _apiService = ApiService();
  final LocalStorageService _storage = LocalStorageService();

  Future<Map<String, dynamic>> getNotifications() async {
    final token = await _storage.getToken();
    return _apiService.get(
      ApiConstants.notifications,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  Future<Map<String, dynamic>> markAsRead(String notificationId) async {
    final token = await _storage.getToken();
    return _apiService.patch(
      '${ApiConstants.notifications}/$notificationId/read',
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }
}
