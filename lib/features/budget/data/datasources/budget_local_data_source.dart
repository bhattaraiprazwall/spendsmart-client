import 'package:drift/drift.dart';
import 'package:spendsmart/core/database/app_database.dart';
import 'package:spendsmart/core/database/daos/budget_dao.dart';
import 'package:spendsmart/core/database/daos/category_dao.dart';
import 'package:spendsmart/core/database/daos/transaction_dao.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';
import 'package:spendsmart/features/budget/data/models/budget_model.dart';
import 'package:spendsmart/features/budget/domain/entities/budget_category.dart';

abstract class BudgetLocalDataSource {
  Future<LocalBudget?> getBudget(String userId, int month, int year);
  Future<LocalBudget?> getBudgetById(String id);
  Stream<LocalBudget?> watchBudget(String userId, int month, int year);
  Future<int> insertBudget(LocalBudgetsCompanion budget);
  Future<int> deleteBudget(String budgetId);
  Future<List<LocalBudgetCategory>> getBudgetCategories(String budgetId);
  Stream<List<LocalBudgetCategory>> watchBudgetCategories(String budgetId);
  Future<void> setBudgetCategories(String budgetId, List<LocalBudgetCategoriesCompanion> limits);
  Future<int> insertOrUpdateCategoryLimit(LocalBudgetCategoriesCompanion limit);
  Future<int> deleteCategoryLimit(String budgetId, String categoryId);
  Future<void> markSynced(String id);
  Future<String?> getUserId();
  Future<String?> getCurrency();
  Future<List<TransactionWithCategory>> getTransactionsWithCategory(String userId);
  Future<List<LocalCategory>> getCategories(String? userId);
  Future<void> cacheRemoteBudget(String userId, BudgetModel model);
  Future<void> cacheCategoryLimits(String budgetId, List<BudgetCategory> categories);
}

class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  final BudgetDao _budgetDao;
  final TransactionDao _transactionDao;
  final CategoryDao _categoryDao;
  final LocalStorageService _storageService;

  BudgetLocalDataSourceImpl({
    required BudgetDao budgetDao,
    required TransactionDao transactionDao,
    required CategoryDao categoryDao,
    required LocalStorageService storageService,
  })  : _budgetDao = budgetDao,
        _transactionDao = transactionDao,
        _categoryDao = categoryDao,
        _storageService = storageService;

  @override
  Future<LocalBudget?> getBudget(String userId, int month, int year) {
    return _budgetDao.getBudget(userId, month, year);
  }

  @override
  Future<LocalBudget?> getBudgetById(String id) {
    return (_budgetDao.select(_budgetDao.localBudgets)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  @override
  Stream<LocalBudget?> watchBudget(String userId, int month, int year) {
    return _budgetDao.watchBudget(userId, month, year);
  }

  @override
  Future<int> insertBudget(LocalBudgetsCompanion budget) {
    return _budgetDao.insertBudget(budget);
  }

  @override
  Future<int> deleteBudget(String budgetId) async {
    await (_budgetDao.delete(_budgetDao.localBudgetCategories)
          ..where((tbl) => tbl.budgetId.equals(budgetId)))
        .go();
    return (_budgetDao.delete(_budgetDao.localBudgets)
          ..where((tbl) => tbl.id.equals(budgetId)))
        .go();
  }

  @override
  Future<List<LocalBudgetCategory>> getBudgetCategories(String budgetId) {
    return _budgetDao.getBudgetCategories(budgetId);
  }

  @override
  Stream<List<LocalBudgetCategory>> watchBudgetCategories(String budgetId) {
    return _budgetDao.watchBudgetCategories(budgetId);
  }

  @override
  Future<void> setBudgetCategories(
      String budgetId, List<LocalBudgetCategoriesCompanion> limits) {
    return _budgetDao.setBudgetCategories(budgetId, limits);
  }

  @override
  Future<int> insertOrUpdateCategoryLimit(
      LocalBudgetCategoriesCompanion limit) {
    return _budgetDao
        .into(_budgetDao.localBudgetCategories)
        .insertOnConflictUpdate(limit);
  }

  @override
  Future<int> deleteCategoryLimit(String budgetId, String categoryId) {
    return (_budgetDao.delete(_budgetDao.localBudgetCategories)
          ..where((tbl) =>
              tbl.budgetId.equals(budgetId) &
              tbl.categoryId.equals(categoryId)))
        .go();
  }

  @override
  Future<void> markSynced(String id) {
    return _budgetDao.markSynced(id);
  }

  @override
  Future<String?> getUserId() {
    return _storageService.getUserId();
  }

  @override
  Future<String?> getCurrency() {
    return _storageService.getCurrency();
  }

  @override
  Future<List<TransactionWithCategory>> getTransactionsWithCategory(
      String userId) {
    return _transactionDao.getTransactionsWithCategory(userId);
  }

  @override
  Future<List<LocalCategory>> getCategories(String? userId) {
    return _categoryDao.getCategories(userId);
  }

  @override
  Future<void> cacheRemoteBudget(String userId, BudgetModel model) async {
    await _budgetDao.insertBudget(
      LocalBudgetsCompanion(
        id: Value(model.id),
        userId: Value(userId),
        month: Value(model.month),
        year: Value(model.year),
        totalAmount: Value(double.tryParse(model.totalAmount) ?? 0.0),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.synced),
      ),
    );
  }

  @override
  Future<void> cacheCategoryLimits(
      String budgetId, List<BudgetCategory> categories) async {
    if (categories.isEmpty) return;
    final companions = categories.map((c) {
      return LocalBudgetCategoriesCompanion(
        id: Value('${budgetId}_${c.categoryId}'),
        budgetId: Value(budgetId),
        categoryId: Value(c.categoryId),
        limit: Value(double.tryParse(c.limit) ?? 0.0),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.synced),
      );
    }).toList();
    await _budgetDao.setBudgetCategories(budgetId, companions);
  }
}
