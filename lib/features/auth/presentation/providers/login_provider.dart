import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
import 'package:spendsmart/core/services/notification_service.dart';
import 'package:spendsmart/core/providers/notification_provider.dart';

part 'login_provider.g.dart';

@riverpod
class Login extends _$Login {
  @override
  FutureOr<void> build() => null;

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      final data = await ref.read(loginUseCaseProvider)(
        email: email,
        password: password,
      );

      //saving the id token received from the backend in the local storage
      await ref.read(storageServiceProvider).saveToken(data["data"]["idToken"]);
      if (data["data"]["refreshToken"] != null) {
        await ref.read(storageServiceProvider).saveRefreshToken(data["data"]["refreshToken"]);
      }
      await ref.read(notificationServiceProvider).syncToken();

      ref.read(authStateProvider.notifier).state = true;
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
