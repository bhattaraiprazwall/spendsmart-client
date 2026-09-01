import 'package:spendsmart/features/budget/domain/entities/budget.dart';
import 'package:spendsmart/features/budget/domain/repositories/budget_repository.dart';

class GetBudgetStatus {
  final BudgetRepository _repository;

  GetBudgetStatus(this._repository);

  Future<BudgetStatus> call(String idToken, String budgetId) {
    return _repository.getBudgetStatus(idToken, budgetId);
  }
}
