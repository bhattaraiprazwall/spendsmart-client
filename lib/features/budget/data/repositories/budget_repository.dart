import 'package:spendsmart/features/budget/data/models/budget_model.dart';
import 'package:spendsmart/features/budget/data/services/budget_service.dart';

class BudgetRepository {
  final BudgetService _budgetService = BudgetService();

  Future<BudgetModel?> getBudget(
    String idToken, {
    required int month,
    required int year,
  }) {
    return _budgetService.getBudget(idToken, month: month, year: year);
  }

  Future<BudgetStatus> getBudgetStatus(String idToken, String budgetId) {
    return _budgetService.getBudgetStatus(idToken, budgetId);
  }

  Future<BudgetModel> createOrUpdateBudget(
    String idToken, {
    required int month,
    required int year,
    required double totalAmount,
    List<Map<String, dynamic>>? categories,
  }) {
    return _budgetService.createOrUpdateBudget(
      idToken,
      month: month,
      year: year,
      totalAmount: totalAmount,
      categories: categories,
    );
  }

  Future<BudgetModel> updateBudget(
    String idToken,
    String budgetId, {
    required double totalAmount,
  }) {
    return _budgetService.updateBudget(
      idToken,
      budgetId,
      totalAmount: totalAmount,
    );
  }

  Future<void> deleteBudget(String idToken, String budgetId) {
    return _budgetService.deleteBudget(idToken, budgetId);
  }

  Future<void> addCategoryLimit(
    String idToken,
    String budgetId, {
    required String categoryId,
    required double limit,
  }) {
    return _budgetService.addCategoryLimit(
      idToken,
      budgetId,
      categoryId: categoryId,
      limit: limit,
    );
  }

  Future<void> updateCategoryLimit(
    String idToken,
    String budgetId,
    String categoryId, {
    required double limit,
  }) {
    return _budgetService.updateCategoryLimit(
      idToken,
      budgetId,
      categoryId,
      limit: limit,
    );
  }

  Future<void> removeCategoryLimit(
    String idToken,
    String budgetId,
    String categoryId,
  ) {
    return _budgetService.removeCategoryLimit(
      idToken,
      budgetId,
      categoryId,
    );
  }
}
