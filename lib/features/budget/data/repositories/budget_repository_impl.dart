import 'dart:async';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:spendsmart/core/database/app_database.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';
import 'package:spendsmart/features/budget/data/datasources/budget_local_data_source.dart';
import 'package:spendsmart/features/budget/data/datasources/budget_remote_data_source.dart';
import 'package:spendsmart/features/budget/domain/entities/budget.dart';
import 'package:spendsmart/features/budget/domain/entities/budget_category.dart';
import 'package:spendsmart/features/budget/domain/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource _remoteDataSource;
  final BudgetLocalDataSource _localDataSource;

  BudgetRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  Budget _toDomain(LocalBudget row) {
    return Budget(
      id: row.id,
      month: row.month,
      year: row.year,
      totalAmount: row.totalAmount.toString(),
    );
  }

  @override
  Future<Budget?> getBudget(
    String idToken, {
    required int month,
    required int year,
  }) async {
    final userId = await _localDataSource.getUserId();

    // 1. Check local SQLite first
    if (userId != null) {
      final local = await _localDataSource.getBudget(userId, month, year);
      if (local != null) {
        // Refresh in background
        _remoteDataSource
            .getBudget(idToken, month: month, year: year)
            .then((m) {
              if (m != null) _localDataSource.cacheRemoteBudget(userId, m);
            })
            .catchError((_) {});
        return _toDomain(local);
      }
    }

    // 2. Fetch remote if local is empty
    try {
      final model = await _remoteDataSource.getBudget(
        idToken,
        month: month,
        year: year,
      );
      if (model != null && userId != null) {
        await _localDataSource.cacheRemoteBudget(userId, model);
      }
      return model?.toEntity();
    } catch (e) {
      if (userId != null) {
        final fallback = await _localDataSource.getBudget(userId, month, year);
        if (fallback != null) return _toDomain(fallback);
      }
      return null;
    }
  }

  @override
  Future<BudgetStatus> getBudgetStatus(String idToken, String budgetId) async {
    final userId = await _localDataSource.getUserId();

    // Attempt remote status fetch first when possible
    try {
      final model = await _remoteDataSource.getBudgetStatus(idToken, budgetId);
      final entity = model.toEntity();

      // Cache category limits into SQLite
      if (entity.categories.isNotEmpty) {
        await _localDataSource.cacheCategoryLimits(budgetId, entity.categories);
      }

      return entity;
    } catch (e) {
      // Offline fallback: compute budget status locally from Drift SQLite
      if (userId != null) {
        final localStatus = await _computeLocalBudgetStatus(userId, budgetId);
        if (localStatus != null) {
          return localStatus;
        }
      }
      return BudgetStatus(
        id: budgetId,
        month: DateTime.now().month,
        year: DateTime.now().year,
        totalAmount: '0.00',
        totalSpent: '0.00',
        remaining: '0.00',
        usagePercentage: 0,
        isOverspent: false,
        status: 'ON_TRACK',
        categories: [],
      );
    }
  }

  Future<BudgetStatus?> _computeLocalBudgetStatus(String userId, String budgetId) async {
    // 1. Get budget row
    final budgets = await _localDataSource.getBudgetById(budgetId);
    if (budgets == null) return null;

    final totalBudget = budgets.totalAmount;
    final month = budgets.month;
    final year = budgets.year;

    // 2. Get all local transactions for this month and year
    final allTransactions = await _localDataSource.getTransactionsWithCategory(userId);
    final monthExpenses = allTransactions.where((t) {
      final dt = t.transaction.date;
      return t.transaction.type == 'EXPENSE' && dt.month == month && dt.year == year;
    }).toList();

    double totalSpent = 0.0;
    final Map<String, double> categorySpentMap = {};

    for (final item in monthExpenses) {
      final amt = item.transaction.amount;
      totalSpent += amt;
      final catId = item.transaction.categoryId;
      categorySpentMap[catId] = (categorySpentMap[catId] ?? 0.0) + amt;
    }

    final remaining = totalBudget - totalSpent;
    final usagePct = totalBudget > 0 ? ((totalSpent / totalBudget) * 100).round() : 0;
    final isOverspent = totalSpent > totalBudget;
    final status = isOverspent ? 'EXCEEDED' : (usagePct >= 80 ? 'WARNING' : 'ON_TRACK');

    // 3. Get category limits from SQLite
    final limits = await _localDataSource.getBudgetCategories(budgetId);
    final allCategories = await _localDataSource.getCategories(userId);
    final categoryMap = {for (final c in allCategories) c.id: c};
    final List<BudgetCategory> categoryStatusList = [];

    for (final lim in limits) {
      final cat = categoryMap[lim.categoryId];
      final spent = categorySpentMap[lim.categoryId] ?? 0.0;
      final catLimit = lim.limit;
      final catRemaining = catLimit - spent;
      final catUsagePct = catLimit > 0 ? ((spent / catLimit) * 100).round() : 0;
      final catIsOverspent = spent > catLimit;
      final catStatus = catIsOverspent ? 'EXCEEDED' : (catUsagePct >= 80 ? 'WARNING' : 'ON_TRACK');

      categoryStatusList.add(
        BudgetCategory(
          categoryId: lim.categoryId,
          name: cat?.name ?? '',
          icon: cat?.icon ?? 'category',
          color: cat?.color ?? '#3D5CFF',
          limit: catLimit.toStringAsFixed(2),
          spent: spent.toStringAsFixed(2),
          remaining: catRemaining.toStringAsFixed(2),
          usagePercentage: catUsagePct,
          isOverspent: catIsOverspent,
          status: catStatus,
        ),
      );
    }

    return BudgetStatus(
      id: budgetId,
      month: month,
      year: year,
      totalAmount: totalBudget.toStringAsFixed(2),
      totalSpent: totalSpent.toStringAsFixed(2),
      remaining: remaining.toStringAsFixed(2),
      usagePercentage: usagePct,
      isOverspent: isOverspent,
      status: status,
      categories: categoryStatusList,
    );
  }

  @override
  Future<Budget> createOrUpdateBudget(
    String idToken, {
    required int month,
    required int year,
    required double totalAmount,
    List<Map<String, dynamic>>? categories,
  }) async {
    final userId = await _localDataSource.getUserId() ?? '';
    final localId = const Uuid().v4();
    final now = DateTime.now();

    // 1. Write to SQLite immediately
    await _localDataSource.insertBudget(
      LocalBudgetsCompanion(
        id: Value(localId),
        userId: Value(userId),
        month: Value(month),
        year: Value(year),
        totalAmount: Value(totalAmount),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pendingCreate),
      ),
    );

    if (categories != null && categories.isNotEmpty) {
      final companions = categories.map((c) {
        final catId = c['categoryId'] as String;
        final lim = double.tryParse(c['limit'].toString()) ?? 0.0;
        return LocalBudgetCategoriesCompanion(
          id: Value('${localId}_$catId'),
          budgetId: Value(localId),
          categoryId: Value(catId),
          limit: Value(lim),
          createdAt: Value(now),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatus.pendingCreate),
        );
      }).toList();
      await _localDataSource.setBudgetCategories(localId, companions);
    }

    final localBudget = Budget(
      id: localId,
      month: month,
      year: year,
      totalAmount: totalAmount.toString(),
    );

    // 2. Dispatch remote in background
    _remoteDataSource
        .createOrUpdateBudget(
          idToken,
          month: month,
          year: year,
          totalAmount: totalAmount,
          categories: categories,
        )
        .then((remoteModel) async {
          if (remoteModel.id != localId) {
            await _localDataSource.deleteBudget(localId);
            await _localDataSource.cacheRemoteBudget(userId, remoteModel);
          } else {
            await _localDataSource.markSynced(localId);
          }
        })
        .catchError((_) {
          // Stays pendingCreate
        });

    return localBudget;
  }

  @override
  Future<Budget> updateBudget(
    String idToken,
    String budgetId, {
    required double totalAmount,
  }) async {
    final existing = await _localDataSource.getBudgetById(budgetId);

    final now = DateTime.now();
    if (existing != null) {
      await _localDataSource.insertBudget(
        LocalBudgetsCompanion(
          id: Value(budgetId),
          userId: Value(existing.userId),
          month: Value(existing.month),
          year: Value(existing.year),
          totalAmount: Value(totalAmount),
          createdAt: Value(existing.createdAt),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatus.pendingUpdate),
        ),
      );
    }

    _remoteDataSource
        .updateBudget(idToken, budgetId, totalAmount: totalAmount)
        .then((_) async {
          await _localDataSource.markSynced(budgetId);
        })
        .catchError((_) {});

    return Budget(
      id: budgetId,
      month: existing?.month ?? 1,
      year: existing?.year ?? DateTime.now().year,
      totalAmount: totalAmount.toString(),
    );
  }

  @override
  Future<void> deleteBudget(String idToken, String budgetId) async {
    await _localDataSource.deleteBudget(budgetId);
    _remoteDataSource.deleteBudget(idToken, budgetId).catchError((_) {});
  }

  @override
  Future<void> addCategoryLimit(
    String idToken,
    String budgetId, {
    required String categoryId,
    required double limit,
  }) async {
    await _localDataSource.insertOrUpdateCategoryLimit(
      LocalBudgetCategoriesCompanion(
        id: Value('${budgetId}_$categoryId'),
        budgetId: Value(budgetId),
        categoryId: Value(categoryId),
        limit: Value(limit),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingCreate),
      ),
    );

    _remoteDataSource.addCategoryLimit(
      idToken,
      budgetId,
      categoryId: categoryId,
      limit: limit,
    ).catchError((_) {});
  }

  @override
  Future<void> updateCategoryLimit(
    String idToken,
    String budgetId,
    String categoryId, {
    required double limit,
  }) async {
    await _localDataSource.insertOrUpdateCategoryLimit(
      LocalBudgetCategoriesCompanion(
        id: Value('${budgetId}_$categoryId'),
        budgetId: Value(budgetId),
        categoryId: Value(categoryId),
        limit: Value(limit),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.pendingUpdate),
      ),
    );

    _remoteDataSource.updateCategoryLimit(
      idToken,
      budgetId,
      categoryId,
      limit: limit,
    ).catchError((_) {});
  }

  @override
  Future<void> removeCategoryLimit(
    String idToken,
    String budgetId,
    String categoryId,
  ) async {
    await _localDataSource.deleteCategoryLimit(budgetId, categoryId);
    _remoteDataSource.removeCategoryLimit(idToken, budgetId, categoryId).catchError((_) {});
  }
}
