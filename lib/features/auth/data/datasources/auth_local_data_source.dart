import 'package:spendsmart/core/services/local_storage_service.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> saveUserId(String userId);
  Future<String?> getUserId();
  Future<void> clearAuth();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorageService _storageService;

  AuthLocalDataSourceImpl(this._storageService);

  @override
  Future<void> saveToken(String token) => _storageService.saveToken(token);

  @override
  Future<String?> getToken() => _storageService.getToken();

  @override
  Future<void> saveRefreshToken(String token) =>
      _storageService.saveRefreshToken(token);

  @override
  Future<String?> getRefreshToken() => _storageService.getRefreshToken();

  @override
  Future<void> saveUserId(String userId) => _storageService.saveUserId(userId);

  @override
  Future<String?> getUserId() => _storageService.getUserId();

  @override
  Future<void> clearAuth() => _storageService.clearAuth();
}
