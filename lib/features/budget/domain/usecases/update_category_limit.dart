import 'package:spendsmart/features/budget/domain/repositories/budget_repository.dart';

class UpdateCategoryLimit {
  final BudgetRepository _repository;

  UpdateCategoryLimit(this._repository);

  Future<void> call(
    String idToken,
    String budgetId,
    String categoryId, {
    required double limit,
  }) {
    return _repository.updateCategoryLimit(
      idToken,
      budgetId,
      categoryId,
      limit: limit,
    );
  }
}
