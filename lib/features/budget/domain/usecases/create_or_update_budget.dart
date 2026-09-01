import 'package:spendsmart/features/budget/domain/entities/budget.dart';
import 'package:spendsmart/features/budget/domain/repositories/budget_repository.dart';

class CreateOrUpdateBudget {
  final BudgetRepository _repository;

  CreateOrUpdateBudget(this._repository);

  Future<Budget> call(
    String idToken, {
    required int month,
    required int year,
    required double totalAmount,
    List<Map<String, dynamic>>? categories,
  }) {
    return _repository.createOrUpdateBudget(
      idToken,
      month: month,
      year: year,
      totalAmount: totalAmount,
      categories: categories,
    );
  }
}
