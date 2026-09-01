import 'package:spendsmart/features/budget/domain/entities/budget.dart';
import 'package:spendsmart/features/budget/domain/repositories/budget_repository.dart';

class GetBudget {
  final BudgetRepository _repository;

  GetBudget(this._repository);

  Future<Budget?> call(
    String idToken, {
    required int month,
    required int year,
  }) {
    return _repository.getBudget(idToken, month: month, year: year);
  }
}
