import 'dart:io';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/core/providers/locale_provider.dart';
import 'package:spendsmart/core/providers/theme_provider.dart';
import 'package:spendsmart/core/services/sync_provider.dart';
import 'package:spendsmart/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:spendsmart/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:spendsmart/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:spendsmart/features/profile/domain/entities/profile.dart';
import 'package:spendsmart/features/profile/domain/repositories/profile_repository.dart';
import 'package:spendsmart/features/profile/domain/usecases/get_profile.dart';
import 'package:spendsmart/features/profile/domain/usecases/update_profile.dart';
import 'package:spendsmart/features/profile/domain/usecases/update_settings.dart';
part 'profile_provider.g.dart';

@riverpod
ProfileLocalDataSource profileLocalDataSource(Ref ref) {
  return ProfileLocalDataSourceImpl(
    storageService: ref.watch(storageServiceProvider),
  );
}

@riverpod
ProfileRemoteDataSource profileRemoteDataSource(Ref ref) {
  return ProfileRemoteDataSourceImpl();
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepositoryImpl(
    ref.watch(profileRemoteDataSourceProvider),
    ref.watch(profileLocalDataSourceProvider),
    ref.watch(connectivityServiceProvider),
  );
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
  FutureOr<Profile?> build() async {
    final cached = await ref.read(profileLocalDataSourceProvider).getCachedProfile();
    return cached?.toEntity();
  }

  Future<void> uploadAvatar(String idToken, File file) async {
    final previousState = state;
    try {
      final updatedProfile = await ref
          .read(profileRepositoryProvider)
          .uploadAvatar(idToken, file);
      state = AsyncData(updatedProfile);
    } catch (e) {
      state = previousState;
      if (e is UnauthorizedException) {
        await ref.read(profileLocalDataSourceProvider).clearAuth();
        ref.read(authStateProvider.notifier).state = false;
      }
      rethrow;
    }
  }

  Future<void> fetchProfile(String idToken) async {
    if (!state.hasValue) {
      state = const AsyncLoading();
    }
    final localDs = ref.read(profileLocalDataSourceProvider);
    try {
      final Profile data = await ref.read(getProfileProvider)(idToken);
      state = AsyncData(data);
      await localDs.saveUserId(data.id);
      if (data.currency.isNotEmpty) {
        ref.read(currencyProvider.notifier).state = data.currency;
        await localDs.saveCurrency(data.currency);
      }
      final localTheme = await localDs.getTheme();
      if (localTheme == null && data.theme.isNotEmpty) {
        await ref.read(themeProvider.notifier).setTheme(
          data.theme == 'dark' ? ThemeMode.dark : ThemeMode.light,
        );
      }
      final localLanguage = await localDs.getLanguage();
      if (localLanguage == null && data.language.isNotEmpty) {
        await ref.read(localeProvider.notifier).setLocale(data.language);
      }
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await localDs.clearAuth();
        ref.read(authStateProvider.notifier).state = false;
        state = AsyncError(e, st);
      } else if (!state.hasValue) {
        final cached = await localDs.getCachedProfile();
        if (cached != null) {
          state = AsyncData(cached.toEntity());
          return;
        }
        state = AsyncError(e, st);
      }
    }
  }

  Future<void> updateProfile(
    String idToken, {
    String? name,
    String? avatarUrl,
  }) async {
    try {
      final updatedProfile = await ref.read(updateProfileProvider)(
        idToken,
        name: name,
        avatarUrl: avatarUrl,
      );
      state = AsyncData(updatedProfile);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(profileLocalDataSourceProvider).clearAuth();
        ref.read(authStateProvider.notifier).state = false;
        state = AsyncError(e, st);
      } else {
        if (state.hasValue && state.value != null) {
          final current = state.value!;
          state = AsyncData(Profile(
            id: current.id,
            email: current.email,
            name: name ?? current.name,
            avatarUrl: avatarUrl ?? current.avatarUrl,
            currency: current.currency,
            theme: current.theme,
            language: current.language,
            notificationsEnabled: current.notificationsEnabled,
            budgetAlertThreshold: current.budgetAlertThreshold,
          ));
        } else {
          state = AsyncError(e, st);
        }
      }
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
      final updatedProfile = await ref.read(updateSettingsProvider)(
        idToken,
        currency: currency,
        theme: theme,
        language: language,
        notificationsEnabled: notificationsEnabled,
        budgetAlertThreshold: budgetAlertThreshold,
      );
      state = AsyncData(updatedProfile);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(profileLocalDataSourceProvider).clearAuth();
        ref.read(authStateProvider.notifier).state = false;
        state = AsyncError(e, st);
      } else {
        if (state.hasValue && state.value != null) {
          final current = state.value!;
          state = AsyncData(Profile(
            id: current.id,
            email: current.email,
            name: current.name,
            avatarUrl: current.avatarUrl,
            currency: currency ?? current.currency,
            theme: theme ?? current.theme,
            language: language ?? current.language,
            notificationsEnabled:
                notificationsEnabled ?? current.notificationsEnabled,
            budgetAlertThreshold:
                budgetAlertThreshold ?? current.budgetAlertThreshold,
          ));
        } else {
          state = AsyncError(e, st);
        }
      }
    }
  }
}
