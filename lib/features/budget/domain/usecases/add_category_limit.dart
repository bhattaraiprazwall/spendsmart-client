import 'package:spendsmart/features/budget/domain/repositories/budget_repository.dart';

class AddCategoryLimit {
  final BudgetRepository _repository;

  AddCategoryLimit(this._repository);

  Future<void> call(
    String idToken,
    String budgetId, {
    required String categoryId,
    required double limit,
  }) {
    return _repository.addCategoryLimit(
      idToken,
      budgetId,
      categoryId: categoryId,
      limit: limit,
    );
  }
}
