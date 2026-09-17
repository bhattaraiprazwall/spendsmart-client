import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:spendsmart/core/database/database_provider.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/home/data/datasources/dashboard_local_data_source.dart';
import 'package:spendsmart/features/home/data/datasources/dashboard_remote_data_source.dart';
import 'package:spendsmart/features/home/data/repositories/dashboard_repository_impl.dart';
import 'package:spendsmart/features/home/domain/entities/dashboard_summary.dart';
import 'package:spendsmart/features/home/domain/repositories/dashboard_repository.dart';
import 'package:spendsmart/features/home/domain/usecases/get_dashboard_summary.dart';

final dashboardLocalDataSourceProvider = Provider<DashboardLocalDataSource>((ref) {
  return DashboardLocalDataSourceImpl(
    transactionDao: ref.watch(transactionDaoProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});

final dashboardRemoteDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  return DashboardRemoteDataSource();
});

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl(
    ref.watch(dashboardRemoteDataSourceProvider),
    ref.watch(dashboardLocalDataSourceProvider),
  );
});

final getDashboardSummaryUseCaseProvider = Provider<GetDashboardSummary>((ref) {
  return GetDashboardSummary(ref.watch(dashboardRepositoryProvider));
});

final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardSummary>(
  DashboardNotifier.new,
);

class DashboardNotifier extends AsyncNotifier<DashboardSummary> {
  StreamSubscription? _driftSub;
  int? _selectedMonth;
  int? _selectedYear;

  @override
  FutureOr<DashboardSummary> build() async {
    final localDataSource = ref.watch(dashboardLocalDataSourceProvider);
    final token = await ref.read(storageServiceProvider).getToken();
    final userId = await localDataSource.getUserId();

    if (userId != null) {
      _driftSub?.cancel();
      _driftSub = localDataSource.watchTransactions(userId).listen((items) async {
        final currency = await localDataSource.getCurrency() ?? 'USD';
        final summary = localDataSource.computeFromRows(
          items,
          currency,
          month: _selectedMonth,
          year: _selectedYear,
        );
        _safeSetState(AsyncData(summary));
      });
      ref.onDispose(() => _driftSub?.cancel());

      final localSummary = await localDataSource.getSummary(
        userId,
        month: _selectedMonth,
        year: _selectedYear,
      );
      if (localSummary != null) {
        if (token != null) {
          _fetchRemoteInBackground(token, _selectedMonth, _selectedYear);
        }
        return localSummary;
      }
    }

    if (token == null) {
      throw UnauthorizedException();
    }
    try {
      return await ref.read(getDashboardSummaryUseCaseProvider)(
        token,
        month: _selectedMonth,
        year: _selectedYear,
      );
    } catch (e) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).clearAuth();
        ref.read(authStateProvider.notifier).state = false;
      }
      final now = DateTime.now();
      final currency = await ref.read(storageServiceProvider).getCurrency() ?? 'USD';
      return DashboardSummary(
        period: DashboardPeriod(
          month: _selectedMonth ?? now.month,
          year: _selectedYear ?? now.year,
          label: DateFormat('MMMM yyyy').format(
            DateTime(_selectedYear ?? now.year, _selectedMonth ?? now.month),
          ),
        ),
        overview: Overview(
          totalBalance: '0.00',
          totalIncome: '0.00',
          totalExpenses: '0.00',
          currency: currency,
        ),
        recentTransactions: [],
      );
    }
  }

  void _safeSetState(AsyncValue<DashboardSummary> newState) {
    try {
      state = newState;
    } catch (_) {}
  }

  void _fetchRemoteInBackground(String token, int? month, int? year) {
    ref
        .read(getDashboardSummaryUseCaseProvider)(token, month: month, year: year)
        .then((remoteSummary) {
      // Background sync updated
    }).catchError((_) {});
  }


  Future<DashboardSummary> fetchSummary(
    String idToken, {
    int? month,
    int? year,
  }) async {
    _selectedMonth = month;
    _selectedYear = year;

    final localDataSource = ref.read(dashboardLocalDataSourceProvider);
    final userId = await localDataSource.getUserId();
    if (userId != null) {
      final summary = await localDataSource.getSummary(
        userId,
        month: month,
        year: year,
      );
      if (summary != null) {
        _safeSetState(AsyncData(summary));
        _fetchRemoteInBackground(idToken, month, year);
        return summary;
      }
    }

    // Only show full loading spinner if there is no cached data yet
    if (!state.hasValue) {
      _safeSetState(const AsyncLoading());
    }
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
        await ref.read(storageServiceProvider).clearAuth();
        ref.read(authStateProvider.notifier).state = false;
        _safeSetState(AsyncError(e, st));
        rethrow;
      }
      if (state.hasValue) {
        return state.value!;
      }
      _safeSetState(AsyncError(e, st));
      rethrow;
    }
  }
}
