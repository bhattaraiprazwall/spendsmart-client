import 'dart:io';
import 'package:spendsmart/core/services/connectivity_service.dart';
import 'package:spendsmart/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:spendsmart/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:spendsmart/features/profile/domain/entities/profile.dart';
import 'package:spendsmart/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final ProfileLocalDataSource _localDataSource;
  final ConnectivityService _connectivity;

  ProfileRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._connectivity,
  );

  @override
  Future<Profile> uploadAvatar(String idToken, File imageFile) async {
    final model = await _remoteDataSource.uploadAvatar(idToken, imageFile);
    await _localDataSource.cacheProfile(model);
    return model.toEntity();
  }

  @override
  Future<Profile> getProfile(String idToken) async {
    final cached = await _localDataSource.getCachedProfile();

    // 1. If online, attempt to refresh from backend
    if (_connectivity.isOnline) {
      try {
        final model = await _remoteDataSource.getProfile(idToken);
        await _localDataSource.cacheProfile(model);
        return model.toEntity();
      } catch (_) {
        if (cached != null) return cached.toEntity();
      }
    }

    // 2. Return local cached profile if available
    if (cached != null) {
      return cached.toEntity();
    }

    // 3. Fallback to basic profile from local storage settings (guarantees no offline crash)
    final fallback = await _localDataSource.getFallbackProfile();
    return fallback.toEntity();
  }

  @override
  Future<Profile> updateProfile(
    String idToken, {
    String? name,
    String? avatarUrl,
  }) async {
    final localProfile = await _localDataSource.updateLocalProfile(
      name: name,
      avatarUrl: avatarUrl,
    );

    if (_connectivity.isOnline) {
      try {
        final model = await _remoteDataSource.updateProfile(
          idToken,
          name: name,
          avatarUrl: avatarUrl,
        );
        await _localDataSource.cacheProfile(model);
        return model.toEntity();
      } catch (_) {
        return localProfile.toEntity();
      }
    }

    return localProfile.toEntity();
  }

  @override
  Future<Profile> updateSettings(
    String idToken, {
    String? currency,
    String? theme,
    String? language,
    bool? notificationsEnabled,
    int? budgetAlertThreshold,
  }) async {
    final localProfile = await _localDataSource.updateLocalSettings(
      currency: currency,
      theme: theme,
      language: language,
      notificationsEnabled: notificationsEnabled,
      budgetAlertThreshold: budgetAlertThreshold,
    );

    // If online, sync to server; if offline or fails, return local profile safely
    if (_connectivity.isOnline) {
      try {
        final model = await _remoteDataSource.updateSettings(
          idToken,
          currency: currency,
          theme: theme,
          language: language,
          notificationsEnabled: notificationsEnabled,
          budgetAlertThreshold: budgetAlertThreshold,
        );
        await _localDataSource.cacheProfile(model);
        return model.toEntity();
      } catch (_) {
        return localProfile.toEntity();
      }
    }

    return localProfile.toEntity();
  }
}
