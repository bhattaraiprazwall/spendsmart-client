import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionChangeController =
      StreamController<bool>.broadcast();

  bool _isOnline = true;
  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;

  bool _initialized = false;
  bool get isInitialized => _initialized;

  Future<bool>? _initialCheckFuture;

  Stream<bool> get onConnectivityChanged async* {
    if (!_initialized) {
      await checkConnection();
    }
    yield _isOnline;
    yield* _connectionChangeController.stream;
  }

  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;

  ConnectivityService._internal() {
    _init();
  }

  void _init() {
    _connectivity.onConnectivityChanged.listen(_checkStatus);
    checkConnection();
  }

  Future<bool> checkConnection() {
    _initialCheckFuture ??= _runCheckConnection();
    return _initialCheckFuture!;
  }

  Future<bool> _runCheckConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return await _checkStatus(results);
    } catch (_) {
      _updateStatus(false);
      return false;
    }
  }

  Future<bool> _checkStatus(List<ConnectivityResult> results) async {
    final hasNetwork = results.any((r) => r != ConnectivityResult.none);
    if (!hasNetwork) {
      _updateStatus(false);
      return false;
    }

    try {
      final lookup = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));
      final connected = lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty;
      _updateStatus(connected);
      return connected;
    } on SocketException catch (_) {
      _updateStatus(false);
      return false;
    } on TimeoutException catch (_) {
      _updateStatus(false);
      return false;
    } catch (_) {
      _updateStatus(false);
      return false;
    }
  }

  void _updateStatus(bool status) {
    final wasInitialized = _initialized;
    _initialized = true;
    if (!wasInitialized || _isOnline != status) {
      _isOnline = status;
      _connectionChangeController.add(_isOnline);
    }
  }

  void dispose() {
    _connectionChangeController.close();
  }
}
