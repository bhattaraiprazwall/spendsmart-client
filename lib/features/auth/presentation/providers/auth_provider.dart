import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/features/auth/data/repositories/auth_repository.dart';
part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}

@riverpod
class Auth extends _$Auth {
  @override
  FutureOr<void> build() {
    null;
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider);

      final response = await repository.register(
        name: name,
        email: email,
        password: password,
      );
      if (response["statusCode"] != 201) {
        throw Exception(response["data"]["message"] ?? "Registration failed");
      }

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
