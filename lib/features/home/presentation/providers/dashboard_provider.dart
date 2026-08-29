import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
import 'package:spendsmart/features/home/data/repositories/dashboard_repository.dart';
import 'package:spendsmart/features/home/models/dashboard_summary.dart';
import 'dart:async';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository();
});

final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardSummary>(
  DashboardNotifier.new,
);

class DashboardNotifier extends AsyncNotifier<DashboardSummary> {
  @override
  FutureOr<DashboardSummary> build() => throw UnimplementedError(
        'Call fetchSummary to load dashboard data',
      );

  void _safeSetState(AsyncValue<DashboardSummary> newState) {
    try {
      state = newState;
    } catch (_) {}
  }

  Future<DashboardSummary> fetchSummary(
    String idToken, {
    int? month,
    int? year,
  }) async {
    _safeSetState(const AsyncLoading());
    try {
      final repository = ref.read(dashboardRepositoryProvider);
      final summary = await repository.getSummary(
        idToken,
        month: month,
        year: year,
      );
      _safeSetState(AsyncData(summary));
      return summary;
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
      rethrow;
    }
  }
}
