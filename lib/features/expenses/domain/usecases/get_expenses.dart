import 'package:spendsmart/features/expenses/domain/entities/expense.dart';
import 'package:spendsmart/features/expenses/domain/repositories/expense_repository.dart';

class GetExpenses {
  final ExpenseRepository _repository;

  GetExpenses(this._repository);

  Future<List<Expense>> call(String idToken) {
    return _repository.getExpenses(idToken);
  }
}
