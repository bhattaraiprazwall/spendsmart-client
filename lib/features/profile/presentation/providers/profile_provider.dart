import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:spendsmart/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:spendsmart/features/profile/domain/entities/profile.dart';
import 'package:spendsmart/features/profile/domain/repositories/profile_repository.dart';
import 'package:spendsmart/features/profile/domain/usecases/get_profile.dart';
import 'package:spendsmart/features/profile/domain/usecases/update_profile.dart';
import 'package:spendsmart/features/profile/domain/usecases/update_settings.dart';
part 'profile_provider.g.dart';

@riverpod
ProfileRemoteDataSource profileRemoteDataSource(Ref ref) {
  return ProfileRemoteDataSource();
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepositoryImpl(ref.watch(profileRemoteDataSourceProvider));
}

@riverpod
GetProfile getProfile(Ref ref) {
  return GetProfile(ref.watch(profileRepositoryProvider));
}

@riverpod
UpdateProfile updateProfile(Ref ref) {
  return UpdateProfile(ref.watch(profileRepositoryProvider));
}

@riverpod
UpdateSettings updateSettings(Ref ref) {
  return UpdateSettings(ref.watch(profileRepositoryProvider));
}

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  FutureOr<Profile?> build() => null;

  Future<void> fetchProfile(String idToken) async {
    state = const AsyncLoading();
    try {
      final Profile data = await ref.read(getProfileProvider)(idToken);
      state = AsyncData(data);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      state = AsyncError(e, st);
    }
  }

  Future<void> updateProfile(
    String idToken, {
    String? name,
    String? avatarUrl,
  }) async {
    try {
      await ref.read(updateProfileProvider)(
        idToken,
        name: name,
        avatarUrl: avatarUrl,
      );
      await fetchProfile(idToken);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      state = AsyncError(e, st);
    }
  }

  Future<void> updateSettings(
    String idToken, {
    String? currency,
    String? theme,
    String? language,
    bool? notificationsEnabled,
    int? budgetAlertThreshold,
  }) async {
    try {
      await ref.read(updateSettingsProvider)(
        idToken,
        currency: currency,
        theme: theme,
        language: language,
        notificationsEnabled: notificationsEnabled,
        budgetAlertThreshold: budgetAlertThreshold,
      );
      await fetchProfile(idToken);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      state = AsyncError(e, st);
    }
  }
}
