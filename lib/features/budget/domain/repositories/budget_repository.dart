import 'package:spendsmart/features/budget/domain/entities/budget.dart';

abstract class BudgetRepository {
  Future<Budget?> getBudget(
    String idToken, {
    required int month,
    required int year,
  });

  Future<BudgetStatus> getBudgetStatus(String idToken, String budgetId);

  Future<Budget> createOrUpdateBudget(
    String idToken, {
    required int month,
    required int year,
    required double totalAmount,
    List<Map<String, dynamic>>? categories,
  });

  Future<Budget> updateBudget(
    String idToken,
    String budgetId, {
    required double totalAmount,
  });

  Future<void> deleteBudget(String idToken, String budgetId);

  Future<void> addCategoryLimit(
    String idToken,
    String budgetId, {
    required String categoryId,
    required double limit,
  });

  Future<void> updateCategoryLimit(
    String idToken,
    String budgetId,
    String categoryId, {
    required double limit,
  });

  Future<void> removeCategoryLimit(
    String idToken,
    String budgetId,
    String categoryId,
  );
}
