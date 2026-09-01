import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/home/data/datasources/dashboard_remote_data_source.dart';
import 'package:spendsmart/features/home/data/repositories/dashboard_repository_impl.dart';
import 'package:spendsmart/features/home/domain/entities/dashboard_summary.dart';
import 'package:spendsmart/features/home/domain/repositories/dashboard_repository.dart';
import 'package:spendsmart/features/home/domain/usecases/get_dashboard_summary.dart';
import 'dart:async';

final dashboardRemoteDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  return DashboardRemoteDataSource();
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(ref.watch(dashboardRemoteDataSourceProvider));
});

final getDashboardSummaryUseCaseProvider = Provider<GetDashboardSummary>((ref) {
  return GetDashboardSummary(ref.watch(dashboardRepositoryProvider));
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
      final summary = await ref.read(getDashboardSummaryUseCaseProvider)(
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
