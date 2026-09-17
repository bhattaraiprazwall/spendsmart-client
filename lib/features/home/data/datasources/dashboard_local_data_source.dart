import 'dart:async';
import 'package:intl/intl.dart';
import 'package:spendsmart/core/database/daos/transaction_dao.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';
import 'package:spendsmart/features/expenses/domain/entities/expense.dart';
import 'package:spendsmart/features/home/domain/entities/dashboard_summary.dart';

abstract class DashboardLocalDataSource {
  Future<DashboardSummary?> getSummary(String userId, {int? month, int? year});
  Stream<List<TransactionWithCategory>> watchTransactions(String userId);
  DashboardSummary computeFromRows(
    List<TransactionWithCategory> items,
    String currency, {
    int? month,
    int? year,
  });
  Future<String?> getUserId();
  Future<String?> getCurrency();
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final TransactionDao _transactionDao;
  final LocalStorageService _storageService;

  DashboardLocalDataSourceImpl({
    required TransactionDao transactionDao,
    required LocalStorageService storageService,
  })  : _transactionDao = transactionDao,
        _storageService = storageService;

  @override
  Stream<List<TransactionWithCategory>> watchTransactions(String userId) {
    return _transactionDao.watchTransactionsWithCategory(userId);
  }

  @override
  Future<String?> getUserId() => _storageService.getUserId();

  @override
  Future<String?> getCurrency() => _storageService.getCurrency();

  @override
  DashboardSummary computeFromRows(
    List<TransactionWithCategory> items,
    String currency, {
    int? month,
    int? year,
  }) {
    final now = DateTime.now();
    final targetMonth = month ?? now.month;
    final targetYear = year ?? now.year;

    double income = 0.0;
    double expense = 0.0;

    for (final item in items) {
      final t = item.transaction;
      if (t.date.month == targetMonth && t.date.year == targetYear) {
        if (t.type == 'INCOME') {
          income += t.amount;
        } else {
          expense += t.amount;
        }
      }
    }

    final balance = income - expense;

    final recent = items.take(5).map((item) {
      final t = item.transaction;
      final c = item.category;
      return Expense(
        id: t.id,
        type: t.type,
        amount: t.amount,
        title: t.title,
        note: t.note,
        paymentMethod: t.paymentMethod,
        date: t.date,
        categoryId: t.categoryId,
        categoryName: c?.name ?? '',
        categoryIcon: c?.icon ?? 'category',
        categoryColor: c?.color ?? '#3D5CFF',
        createdAt: t.createdAt,
        updatedAt: t.updatedAt,
      );
    }).toList();

    return DashboardSummary(
      period: DashboardPeriod(
        month: targetMonth,
        year: targetYear,
        label: DateFormat('MMMM yyyy').format(
          DateTime(targetYear, targetMonth),
        ),
      ),
      overview: Overview(
        totalBalance: balance.toStringAsFixed(2),
        totalIncome: income.toStringAsFixed(2),
        totalExpenses: expense.toStringAsFixed(2),
        currency: currency,
      ),
      recentTransactions: recent,
    );
  }

  @override
  Future<DashboardSummary?> getSummary(
    String userId, {
    int? month,
    int? year,
  }) async {
    final items = await _transactionDao.getTransactionsWithCategory(userId);
    if (items.isEmpty) return null;

    final currency = await _storageService.getCurrency() ?? 'USD';
    return computeFromRows(items, currency, month: month, year: year);
  }
}
