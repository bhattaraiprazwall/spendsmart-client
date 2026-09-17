import 'dart:async';
import 'package:intl/intl.dart';
import 'package:spendsmart/core/services/connectivity_service.dart';
import 'package:spendsmart/features/home/data/datasources/dashboard_local_data_source.dart';
import 'package:spendsmart/features/home/data/datasources/dashboard_remote_data_source.dart';
import 'package:spendsmart/features/home/domain/entities/dashboard_summary.dart';
import 'package:spendsmart/features/home/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;
  final DashboardLocalDataSource _localDataSource;

  DashboardRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<DashboardSummary> getSummary(
    String idToken, {
    int? month,
    int? year,
  }) async {
    final userId = await _localDataSource.getUserId();

    // 1. Check local SQLite cache first for instant response
    if (userId != null) {
      final local = await _localDataSource.getSummary(userId, month: month, year: year);
      if (local != null) {
        // Trigger background remote refresh if online
        if (!ConnectivityService().isOffline) {
          unawaited(() async {
            try {
              await _remoteDataSource.getSummary(idToken, month: month, year: year);
            } catch (_) {}
          }());
        }
        return local;
      }
    }

    // 2. Attempt remote fetch if no local transactions yet
    try {
      final summary = await _remoteDataSource.getSummary(
        idToken,
        month: month,
        year: year,
      );
      return summary;
    } catch (e) {
      // 3. Fallback to local calculation
      if (userId != null) {
        final localSummary = await _localDataSource.getSummary(userId, month: month, year: year);
        if (localSummary != null) {
          return localSummary;
        }
      }
      final now = DateTime.now();
      final targetMonth = month ?? now.month;
      final targetYear = year ?? now.year;
      final currency = await _localDataSource.getCurrency() ?? 'USD';
      return DashboardSummary(
        period: DashboardPeriod(
          month: targetMonth,
          year: targetYear,
          label: DateFormat('MMMM yyyy').format(DateTime(targetYear, targetMonth)),
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
}
