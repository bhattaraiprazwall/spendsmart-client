import 'package:spendsmart/features/budget/domain/repositories/budget_repository.dart';

class RemoveCategoryLimit {
  final BudgetRepository _repository;

  RemoveCategoryLimit(this._repository);

  Future<void> call(String idToken, String budgetId, String categoryId) {
    return _repository.removeCategoryLimit(idToken, budgetId, categoryId);
  }
}
