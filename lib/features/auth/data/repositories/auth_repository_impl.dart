import 'package:spendsmart/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:spendsmart/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:spendsmart/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

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
    final response = await _remoteDataSource.login(email: email, password: password);
    final data = response["data"];
    if (data != null) {
      if (data["idToken"] != null) {
        await _localDataSource.saveToken(data["idToken"]);
      }
      if (data["refreshToken"] != null) {
        await _localDataSource.saveRefreshToken(data["refreshToken"]);
      }
      if (data["user"]?["id"] != null) {
        await _localDataSource.saveUserId(data["user"]["id"]);
      }
    }
    return response;
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
