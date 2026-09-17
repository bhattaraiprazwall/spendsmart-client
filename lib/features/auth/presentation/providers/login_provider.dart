import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/notification_provider.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';

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

      // Save token and refreshToken via AuthLocalDataSource
      if (data["data"]?["idToken"] != null) {
        await ref
            .read(authLocalDataSourceProvider)
            .saveToken(data["data"]["idToken"]);
      }
      if (data["data"]?["refreshToken"] != null) {
        await ref
            .read(authLocalDataSourceProvider)
            .saveRefreshToken(data["data"]["refreshToken"]);
      }
      await ref.read(notificationServiceProvider).syncToken();

      ref.read(authStateProvider.notifier).state = true;
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
