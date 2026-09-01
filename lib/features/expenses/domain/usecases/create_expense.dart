import 'package:spendsmart/features/expenses/domain/entities/expense.dart';
import 'package:spendsmart/features/expenses/domain/repositories/expense_repository.dart';

class CreateExpense {
  final ExpenseRepository _repository;

  CreateExpense(this._repository);

  Future<Expense> call(
    String idToken, {
    required String type,
    required double amount,
    required String title,
    String? note,
    required String paymentMethod,
    required String date,
    required String categoryId,
  }) {
    return _repository.createExpense(
      idToken,
      type: type,
      amount: amount,
      title: title,
      note: note,
      paymentMethod: paymentMethod,
      date: date,
      categoryId: categoryId,
    );
  }
}
