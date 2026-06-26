import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
part 'login_provider.g.dart';

@riverpod
class Login extends _$Login {
  @override
  FutureOr<void> build() => null;

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(authRepositoryProvider);
      final response = await repository.login(email: email, password: password);
      if (response['statusCode'] != 200) {
        throw Exception(response["data"]["message"] ?? "Login Failed");
      }
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}