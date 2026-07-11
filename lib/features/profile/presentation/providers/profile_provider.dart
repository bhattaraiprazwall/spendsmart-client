import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
import 'package:spendsmart/features/profile/data/models/profile_model.dart';
import 'package:spendsmart/features/profile/data/repositories/profile_repository.dart';
part 'profile_provider.g.dart';

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepository();
}

@riverpod
class Profile extends _$Profile {
  @override
  FutureOr<ProfileModel?> build() => null;

  Future<void> fetchProfile(String idToken) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(profileRepositoryProvider);
      final ProfileModel data = await repository.getProfile(idToken);
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
      final repository = ref.read(profileRepositoryProvider);
      await repository.updateProfile(idToken, name: name, avatarUrl: avatarUrl);
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
      final repository = ref.read(profileRepositoryProvider);
      await repository.updateSettings(
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
