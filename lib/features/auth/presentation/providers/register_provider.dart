import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
part 'register_provider.g.dart';

@riverpod
class Register extends _$Register {
  @override
  FutureOr<void> build() => null;

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