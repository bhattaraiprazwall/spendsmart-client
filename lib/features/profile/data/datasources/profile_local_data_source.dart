import 'dart:convert';
import 'package:spendsmart/core/services/local_storage_service.dart';
import 'package:spendsmart/features/profile/data/models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel?> getCachedProfile();
  Future<void> cacheProfile(ProfileModel model);
  Future<ProfileModel> updateLocalProfile({String? name, String? avatarUrl});
  Future<ProfileModel> updateLocalSettings({
    String? currency,
    String? theme,
    String? language,
    bool? notificationsEnabled,
    int? budgetAlertThreshold,
  });
  Future<ProfileModel> getFallbackProfile();
  Future<String?> getUserId();
  Future<void> saveUserId(String userId);
  Future<String?> getCurrency();
  Future<void> saveCurrency(String currency);
  Future<String?> getTheme();
  Future<void> saveTheme(String theme);
  Future<String?> getLanguage();
  Future<void> saveLanguage(String language);
  Future<void> clearAuth();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final LocalStorageService _storageService;

  ProfileLocalDataSourceImpl({required LocalStorageService storageService})
      : _storageService = storageService;

  @override
  Future<ProfileModel?> getCachedProfile() async {
    final cached = await _storageService.getUserProfile();
    if (cached == null) return null;
    try {
      final map = jsonDecode(cached) as Map<String, dynamic>;
      return ProfileModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> cacheProfile(ProfileModel model) async {
    await _storageService.saveUserProfile(
      jsonEncode({
        "id": model.id,
        "email": model.email,
        ...model.toJson(),
      }),
    );
  }

  @override
  Future<ProfileModel> updateLocalProfile({
    String? name,
    String? avatarUrl,
  }) async {
    final cachedStr = await _storageService.getUserProfile();
    Map<String, dynamic> map = {};
    if (cachedStr != null) {
      try {
        map = jsonDecode(cachedStr) as Map<String, dynamic>;
      } catch (_) {}
    }
    if (name != null) map['name'] = name;
    if (avatarUrl != null) map['avatarUrl'] = avatarUrl;
    final model = ProfileModel.fromJson(map);
    await _storageService.saveUserProfile(jsonEncode(map));
    return model;
  }

  @override
  Future<ProfileModel> updateLocalSettings({
    String? currency,
    String? theme,
    String? language,
    bool? notificationsEnabled,
    int? budgetAlertThreshold,
  }) async {
    if (currency != null) {
      await _storageService.saveCurrency(currency);
    }
    if (theme != null) {
      await _storageService.saveTheme(theme);
    }
    if (language != null) {
      await _storageService.saveLanguage(language);
    }

    final cachedStr = await _storageService.getUserProfile();
    Map<String, dynamic> map = {};
    if (cachedStr != null) {
      try {
        map = jsonDecode(cachedStr) as Map<String, dynamic>;
      } catch (_) {}
    }

    final userId = await _storageService.getUserId() ?? map['id'] ?? 'user';
    map['id'] = userId;
    map['email'] = map['email'] ?? '';
    map['name'] = map['name'] ?? 'User';

    if (currency != null) map['currency'] = currency;
    if (theme != null) map['theme'] = theme;
    if (language != null) map['language'] = language;
    if (notificationsEnabled != null) {
      map['notificationsEnabled'] = notificationsEnabled;
    }
    if (budgetAlertThreshold != null) {
      map['budgetAlertThreshold'] = budgetAlertThreshold;
    }

    final model = ProfileModel.fromJson(map);
    await _storageService.saveUserProfile(jsonEncode(map));
    return model;
  }

  @override
  Future<ProfileModel> getFallbackProfile() async {
    final userId = await _storageService.getUserId() ?? 'user';
    final currency = await _storageService.getCurrency() ?? 'USD';
    final theme = await _storageService.getTheme() ?? 'light';
    final language = await _storageService.getLanguage() ?? 'en';

    final fallback = ProfileModel(
      id: userId,
      email: '',
      name: 'User',
      currency: currency,
      theme: theme,
      language: language,
      notificationsEnabled: true,
      budgetAlertThreshold: 80,
    );

    await cacheProfile(fallback);
    return fallback;
  }

  @override
  Future<String?> getUserId() => _storageService.getUserId();

  @override
  Future<void> saveUserId(String userId) => _storageService.saveUserId(userId);

  @override
  Future<String?> getCurrency() => _storageService.getCurrency();

  @override
  Future<void> saveCurrency(String currency) => _storageService.saveCurrency(currency);

  @override
  Future<String?> getTheme() => _storageService.getTheme();

  @override
  Future<void> saveTheme(String theme) => _storageService.saveTheme(theme);

  @override
  Future<String?> getLanguage() => _storageService.getLanguage();

  @override
  Future<void> saveLanguage(String language) => _storageService.saveLanguage(language);

  @override
  Future<void> clearAuth() => _storageService.clearAuth();
}
