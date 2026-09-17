import 'package:spendsmart/core/database/daos/transaction_dao.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';
import 'package:spendsmart/features/forecast/domain/entities/monthly_forecast.dart';

abstract class ForecastLocalDataSource {
  Future<MonthlyForecast> computeLocalForecast();
  MonthlyForecast computeForecastFromRows(List<TransactionWithCategory> allTxs);
  Stream<MonthlyForecast> watchLocalForecast(String userId);
  Stream<List<TransactionWithCategory>> watchTransactions(String userId);
  Future<String?> getUserId();
}

class ForecastLocalDataSourceImpl implements ForecastLocalDataSource {
  final TransactionDao _transactionDao;
  final LocalStorageService _storageService;

  ForecastLocalDataSourceImpl({
    required TransactionDao transactionDao,
    required LocalStorageService storageService,
  })  : _transactionDao = transactionDao,
        _storageService = storageService;

  @override
  Future<String?> getUserId() => _storageService.getUserId();

  @override
  Stream<List<TransactionWithCategory>> watchTransactions(String userId) {
    return _transactionDao.watchTransactionsWithCategory(userId);
  }

  @override
  Stream<MonthlyForecast> watchLocalForecast(String userId) {
    return _transactionDao.watchTransactionsWithCategory(userId).map((items) {
      return computeForecastFromRows(items);
    });
  }

  @override
  MonthlyForecast computeForecastFromRows(List<TransactionWithCategory> allTxs) {
    final now = DateTime.now();
    final Map<String, double> monthlyTotals = {};

    for (final item in allTxs) {
      final t = item.transaction;
      if (t.type.toUpperCase() != 'EXPENSE') continue;
      if (t.syncStatus == SyncStatus.pendingDelete) continue;

      final key = '${t.date.year}-${t.date.month}';
      monthlyTotals[key] = (monthlyTotals[key] ?? 0.0) + t.amount;
    }

    final historical = <MonthlySpending>[];
    for (int i = 1; i <= 6; i++) {
      final prevDate = DateTime(now.year, now.month - i, 1);
      final key = '${prevDate.year}-${prevDate.month}';
      if (monthlyTotals.containsKey(key)) {
        historical.add(MonthlySpending(
          year: prevDate.year,
          month: prevDate.month,
          total: monthlyTotals[key]!,
        ));
      }
    }

    // Sort chronologically ascending
    historical.sort((a, b) {
      if (a.year != b.year) return a.year.compareTo(b.year);
      return a.month.compareTo(b.month);
    });

    if (historical.length < 3) {
      return MonthlyForecast(
        status: 'INSUFFICIENT_DATA',
        message:
            'At least 3 months of historical spending required for forecast.',
        historicalMonths: historical,
        windowSize: 3,
        valuesUsed: historical.map((h) => h.total).toList(),
      );
    }

    final last3 =
        historical.skip(historical.length - 3).map((h) => h.total).toList();
    final avg = last3.reduce((a, b) => a + b) / 3;
    final nextMonthDate = DateTime(now.year, now.month + 1, 1);

    return MonthlyForecast(
      status: 'SUCCESS',
      message: 'Forecast calculated using local 3-month moving average.',
      forecastYear: nextMonthDate.year,
      forecastMonth: nextMonthDate.month,
      historicalMonths: historical,
      windowSize: 3,
      valuesUsed: last3,
      forecast: avg,
    );
  }

  @override
  Future<MonthlyForecast> computeLocalForecast() async {
    final userId = await _storageService.getUserId() ?? '';
    final allTxs = await _transactionDao.getTransactionsWithCategory(userId);
    return computeForecastFromRows(allTxs);
  }
}
