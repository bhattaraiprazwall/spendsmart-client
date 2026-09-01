import 'package:spendsmart/features/budget/domain/entities/budget.dart';
import 'package:spendsmart/features/budget/domain/repositories/budget_repository.dart';

class UpdateBudget {
  final BudgetRepository _repository;

  UpdateBudget(this._repository);

  Future<Budget> call(
    String idToken,
    String budgetId, {
    required double totalAmount,
  }) {
    return _repository.updateBudget(
      idToken,
      budgetId,
      totalAmount: totalAmount,
    );
  }
}
