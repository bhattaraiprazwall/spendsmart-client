import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';

class Logout {
  final Ref _ref;

  Logout(this._ref);

  Future<void> call() async {
    await _ref.read(storageServiceProvider).deleteToken();
    _ref.read(authStateProvider.notifier).state = false;
  }
}
