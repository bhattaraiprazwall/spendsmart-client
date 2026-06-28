import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spendsmart/core/constants/storage_constants.dart';

class LocalStorageService {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  Future<void> saveToken(String token) =>
      _storage.write(key: StorageConstants.idToken, value: token);

  Future<String?> getToken() => _storage.read(key: StorageConstants.idToken);

  Future<void> deleteToken() => _storage.delete(key: StorageConstants.idToken);

  Future<void> clearAll() => _storage.deleteAll();
}
