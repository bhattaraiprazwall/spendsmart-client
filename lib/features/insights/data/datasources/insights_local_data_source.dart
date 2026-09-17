import 'dart:math' as math;
import 'package:spendsmart/core/database/daos/transaction_dao.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';
import 'package:spendsmart/features/insights/domain/entities/insight.dart';
import 'package:spendsmart/features/insights/domain/entities/spending_anomaly.dart';

class _LocalCategoryAgg {
  final String name;
  final String icon;
  final String color;
  double amount;

  _LocalCategoryAgg({
    required this.name,
    required this.icon,
    required this.color,
    required this.amount,
  });
}

abstract class InsightsLocalDataSource {
  Future<Insight> computeLocalInsights(String period);
  Future<SpendingAnomaly> computeLocalSpendingAnomaly();
  Insight computeInsightsFromRows(
    List<TransactionWithCategory> allTxs,
    String period,
  );
  SpendingAnomaly computeAnomalyFromRows(List<TransactionWithCategory> allTxs);
  Stream<Insight> watchLocalInsights(String userId, String period);
  Stream<SpendingAnomaly> watchLocalSpendingAnomaly(String userId);
  Stream<List<TransactionWithCategory>> watchTransactions(String userId);
  Future<String?> getUserId();
}

class InsightsLocalDataSourceImpl implements InsightsLocalDataSource {
  final TransactionDao _transactionDao;
  final LocalStorageService _storageService;

  InsightsLocalDataSourceImpl({
    required TransactionDao transactionDao,
    required LocalStorageService storageService,
  }) : _transactionDao = transactionDao,
       _storageService = storageService;

  @override
  Future<String?> getUserId() => _storageService.getUserId();

  @override
  Stream<List<TransactionWithCategory>> watchTransactions(String userId) {
    return _transactionDao.watchTransactionsWithCategory(userId);
  }

  @override
  Stream<Insight> watchLocalInsights(String userId, String period) {
    return _transactionDao.watchTransactionsWithCategory(userId).map((items) {
      return computeInsightsFromRows(items, period);
    });
  }

  @override
  Stream<SpendingAnomaly> watchLocalSpendingAnomaly(String userId) {
    return _transactionDao.watchTransactionsWithCategory(userId).map((items) {
      return computeAnomalyFromRows(items);
    });
  }

  @override
  Insight computeInsightsFromRows(
    List<TransactionWithCategory> allTxs,
    String period,
  ) {
    final now = DateTime.now();
    DateTime startDate;
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    if (period.toLowerCase() == 'weekly') {
      final weekday = now.weekday % 7; // Sunday = 0
      startDate = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: weekday));
    } else if (period.toLowerCase() == 'monthly') {
      startDate = DateTime(now.year, now.month, 1);
    } else {
      // Yearly
      startDate = DateTime(now.year, 1, 1);
    }

    // Filter to EXPENSE within range and not deleted
    final expenseTxs = allTxs.where((item) {
      final t = item.transaction;
      if (t.type.toUpperCase() != 'EXPENSE') return false;
      if (t.syncStatus == SyncStatus.pendingDelete) return false;
      return !t.date.isBefore(startDate) && !t.date.isAfter(endDate);
    }).toList();

    double totalSpent = 0.0;
    final Map<String, _LocalCategoryAgg> categoryMap = {};

    for (final item in expenseTxs) {
      final t = item.transaction;
      final c = item.category;
      totalSpent += t.amount;

      final catId = t.categoryId;
      if (categoryMap.containsKey(catId)) {
        categoryMap[catId]!.amount += t.amount;
      } else {
        categoryMap[catId] = _LocalCategoryAgg(
          name: c?.name ?? 'Other',
          icon: c?.icon ?? 'category',
          color: c?.color ?? '#3D5CFF',
          amount: t.amount,
        );
      }
    }

    final breakdown = categoryMap.values.map((agg) {
      final percentage = totalSpent > 0 ? (agg.amount / totalSpent) : 0.0;
      return CategoryBreakdown(
        name: agg.name,
        icon: agg.icon,
        color: agg.color,
        amount: agg.amount,
        percentage: percentage,
      );
    }).toList()..sort((a, b) => b.amount.compareTo(a.amount));

    TopInsight? topInsight;
    if (breakdown.isNotEmpty) {
      final top = breakdown.first;
      topInsight = TopInsight(
        name: top.name,
        icon: top.icon,
        color: top.color,
        percentage: (top.percentage * 100).toStringAsFixed(0),
      );
    }

    return Insight(
      totalSpent: totalSpent.toStringAsFixed(2),
      breakdown: breakdown,
      topInsight: topInsight,
    );
  }

  @override
  SpendingAnomaly computeAnomalyFromRows(List<TransactionWithCategory> allTxs) {
    final now = DateTime.now();
    double currentMonthSpending = 0.0;
    final Map<String, double> monthlyTotals = {};

    for (final item in allTxs) {
      final t = item.transaction;
      if (t.type.toUpperCase() != 'EXPENSE') continue;
      if (t.syncStatus == SyncStatus.pendingDelete) continue;

      if (t.date.year == now.year && t.date.month == now.month) {
        currentMonthSpending += t.amount;
      }

      final key = '${t.date.year}-${t.date.month}';
      monthlyTotals[key] = (monthlyTotals[key] ?? 0.0) + t.amount;
    }

    final historical = <double>[];
    for (int i = 1; i <= 6; i++) {
      final prevDate = DateTime(now.year, now.month - i, 1);
      final key = '${prevDate.year}-${prevDate.month}';
      if (monthlyTotals.containsKey(key)) {
        historical.add(monthlyTotals[key]!);
      }
    }

    if (historical.length < 3) {
      return SpendingAnomaly(
        status: 'INSUFFICIENT_DATA',
        message:
            'Need at least 3 months of spending history to detect anomalies.',
        currentSpending: currentMonthSpending,
        historicalSpending: historical,
      );
    }

    final mean = historical.reduce((a, b) => a + b) / historical.length;
    final variance =
        historical.map((x) => (x - mean) * (x - mean)).reduce((a, b) => a + b) /
        historical.length;
    final stdDev = variance > 0 ? math.sqrt(variance) : 0.0;
    final zScore = stdDev > 0 ? ((currentMonthSpending - mean) / stdDev) : 0.0;
    final isAnomaly = zScore > 1.5;

    return SpendingAnomaly(
      status: 'ANALYZED',
      message: isAnomaly
          ? 'Spending is significantly higher than usual this month.'
          : 'Your spending is within the expected range.',
      currentSpending: currentMonthSpending,
      historicalSpending: historical,
      mean: mean,
      standardDeviation: stdDev,
      zScore: zScore,
      isAnomaly: isAnomaly,
    );
  }

  @override
  Future<Insight> computeLocalInsights(String period) async {
    final userId = await _storageService.getUserId() ?? '';
    final allTxs = await _transactionDao.getTransactionsWithCategory(userId);
    return computeInsightsFromRows(allTxs, period);
  }

  @override
  Future<SpendingAnomaly> computeLocalSpendingAnomaly() async {
    final userId = await _storageService.getUserId() ?? '';
    final allTxs = await _transactionDao.getTransactionsWithCategory(userId);
    return computeAnomalyFromRows(allTxs);
  }
}
