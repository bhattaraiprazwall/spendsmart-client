class AuthResult {
  final String idToken;
  final String? refreshToken;
  final String? expiresIn;

  const AuthResult({
    required this.idToken,
    this.refreshToken,
    this.expiresIn,
  });
}
