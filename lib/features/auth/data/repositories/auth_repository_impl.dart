import 'package:spendsmart/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:spendsmart/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _remoteDataSource.register(
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await _remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<void> changePassword(
    String idToken,
    String currentPassword,
    String newPassword,
  ) async {
    return _remoteDataSource.changePassword(
      idToken,
      currentPassword,
      newPassword,
    );
  }
}
