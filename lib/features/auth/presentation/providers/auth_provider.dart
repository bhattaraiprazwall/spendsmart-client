import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/features/auth/data/repositories/auth_repository.dart';
part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository();
}