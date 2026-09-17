class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'No internet connection. Please check your network.']);

  @override
  String toString() => message;
}
