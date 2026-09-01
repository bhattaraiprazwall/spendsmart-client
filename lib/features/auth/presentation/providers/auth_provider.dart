import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:spendsmart/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:spendsmart/features/auth/domain/repositories/auth_repository.dart';
import 'package:spendsmart/features/auth/domain/usecases/change_password.dart';
import 'package:spendsmart/features/auth/domain/usecases/login.dart';
import 'package:spendsmart/features/auth/domain/usecases/logout.dart';
import 'package:spendsmart/features/auth/domain/usecases/register.dart';
part 'auth_provider.g.dart';

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSource();
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
}

@riverpod
Login loginUseCase(Ref ref) {
  return Login(ref.watch(authRepositoryProvider));
}

@riverpod
Register registerUseCase(Ref ref) {
  return Register(ref.watch(authRepositoryProvider));
}

@riverpod
ChangePassword changePasswordUseCase(Ref ref) {
  return ChangePassword(ref.watch(authRepositoryProvider));
}

@riverpod
Logout logoutUseCase(Ref ref) {
  return Logout(ref);
}
