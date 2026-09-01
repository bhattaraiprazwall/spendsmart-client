import 'package:spendsmart/features/budget/domain/repositories/budget_repository.dart';

class DeleteBudget {
  final BudgetRepository _repository;

  DeleteBudget(this._repository);

  Future<void> call(String idToken, String budgetId) {
    return _repository.deleteBudget(idToken, budgetId);
  }
}
