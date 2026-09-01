import 'package:spendsmart/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:spendsmart/features/profile/domain/entities/profile.dart';
import 'package:spendsmart/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<Profile> getProfile(String idToken) async {
    final model = await _remoteDataSource.getProfile(idToken);
    return model.toEntity();
  }

  @override
  Future<Profile> updateProfile(
    String idToken, {
    String? name,
    String? avatarUrl,
  }) async {
    final model = await _remoteDataSource.updateProfile(
      idToken,
      name: name,
      avatarUrl: avatarUrl,
    );
    return model.toEntity();
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
    final model = await _remoteDataSource.updateSettings(
      idToken,
      currency: currency,
      theme: theme,
      language: language,
      notificationsEnabled: notificationsEnabled,
      budgetAlertThreshold: budgetAlertThreshold,
    );
    return model.toEntity();
  }
}
