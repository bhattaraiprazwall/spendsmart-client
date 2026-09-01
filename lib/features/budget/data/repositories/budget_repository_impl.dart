import 'package:spendsmart/features/budget/data/datasources/budget_remote_datasource.dart';
import 'package:spendsmart/features/budget/domain/entities/budget.dart';
import 'package:spendsmart/features/budget/domain/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource _remoteDataSource;

  BudgetRepositoryImpl(this._remoteDataSource);

  @override
  Future<Budget?> getBudget(
    String idToken, {
    required int month,
    required int year,
  }) async {
    final model = await _remoteDataSource.getBudget(
      idToken,
      month: month,
      year: year,
    );
    return model?.toEntity();
  }

  @override
  Future<BudgetStatus> getBudgetStatus(String idToken, String budgetId) async {
    final model = await _remoteDataSource.getBudgetStatus(idToken, budgetId);
    return model.toEntity();
  }

  @override
  Future<Budget> createOrUpdateBudget(
    String idToken, {
    required int month,
    required int year,
    required double totalAmount,
    List<Map<String, dynamic>>? categories,
  }) async {
    final model = await _remoteDataSource.createOrUpdateBudget(
      idToken,
      month: month,
      year: year,
      totalAmount: totalAmount,
      categories: categories,
    );
    return model.toEntity();
  }

  @override
  Future<Budget> updateBudget(
    String idToken,
    String budgetId, {
    required double totalAmount,
  }) async {
    final model = await _remoteDataSource.updateBudget(
      idToken,
      budgetId,
      totalAmount: totalAmount,
    );
    return model.toEntity();
  }

  @override
  Future<void> deleteBudget(String idToken, String budgetId) {
    return _remoteDataSource.deleteBudget(idToken, budgetId);
  }

  @override
  Future<void> addCategoryLimit(
    String idToken,
    String budgetId, {
    required String categoryId,
    required double limit,
  }) {
    return _remoteDataSource.addCategoryLimit(
      idToken,
      budgetId,
      categoryId: categoryId,
      limit: limit,
    );
  }

  @override
  Future<void> updateCategoryLimit(
    String idToken,
    String budgetId,
    String categoryId, {
    required double limit,
  }) {
    return _remoteDataSource.updateCategoryLimit(
      idToken,
      budgetId,
      categoryId,
      limit: limit,
    );
  }

  @override
  Future<void> removeCategoryLimit(
    String idToken,
    String budgetId,
    String categoryId,
  ) {
    return _remoteDataSource.removeCategoryLimit(
      idToken,
      budgetId,
      categoryId,
    );
  }
}
