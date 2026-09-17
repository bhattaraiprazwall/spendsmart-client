import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spendsmart/core/constants/storage_constants.dart';

class LocalStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) =>
      _storage.write(key: StorageConstants.idToken, value: token);

  Future<String?> getToken() => _storage.read(key: StorageConstants.idToken);

  Future<void> deleteToken() => _storage.delete(key: StorageConstants.idToken);

  Future<void> saveUserId(String userId) =>
      _storage.write(key: StorageConstants.userId, value: userId);

  Future<String?> getUserId() => _storage.read(key: StorageConstants.userId);

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

  Future<void> clearAuth() async {
    await deleteToken();
    await deleteRefreshToken();
  }

  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: StorageConstants.refreshToken, value: token);

  Future<String?> getRefreshToken() => _storage.read(key: StorageConstants.refreshToken);

  Future<void> deleteRefreshToken() =>
      _storage.delete(key: StorageConstants.refreshToken);

  Future<void> saveTheme(String theme) =>
      _storage.write(key: StorageConstants.theme, value: theme);

  Future<String?> getTheme() => _storage.read(key: StorageConstants.theme);

  Future<void> saveHasSeenIntro(bool value) =>
      _storage.write(key: StorageConstants.hasSeenIntro, value: value.toString());

  Future<bool> hasSeenIntro() async {
    final val = await _storage.read(key: StorageConstants.hasSeenIntro);
    return val == 'true';
  }

  Future<void> saveHasCompletedOnboarding(bool value) =>
      _storage.write(key: StorageConstants.hasCompletedOnboarding, value: value.toString());

  Future<bool> hasCompletedOnboarding() async {
    final val = await _storage.read(key: StorageConstants.hasCompletedOnboarding);
    return val == 'true';
  }

  Future<void> saveUserProfile(String profileJson) =>
      _storage.write(key: StorageConstants.userProfile, value: profileJson);

  Future<String?> getUserProfile() => _storage.read(key: StorageConstants.userProfile);
}
