import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spendsmart/core/constants/storage_constants.dart';

class LocalStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) =>
      _storage.write(key: StorageConstants.idToken, value: token);

  Future<String?> getToken() => _storage.read(key: StorageConstants.idToken);

  Future<void> deleteToken() => _storage.delete(key: StorageConstants.idToken);

  Future<void> saveCurrency(String currency) =>
      _storage.write(key: StorageConstants.currency, value: currency);

  Future<String?> getCurrency() =>
      _storage.read(key: StorageConstants.currency);

  Future<void> saveLanguage(String language) =>
      _storage.write(key: StorageConstants.language, value: language);

  Future<String?> getLanguage() =>
      _storage.read(key: StorageConstants.language);

  Future<void> saveBiometricEnabled(bool enabled) =>
      _storage.write(key: StorageConstants.biometricEnabled, value: enabled.toString());

  Future<bool> isBiometricEnabled() async {
    final val = await _storage.read(key: StorageConstants.biometricEnabled);
    return val == 'true';
  }

  Future<void> clearAll() => _storage.deleteAll();
}
