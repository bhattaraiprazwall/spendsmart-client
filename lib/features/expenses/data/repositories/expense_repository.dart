import 'package:spendsmart/features/expenses/data/models/expense.dart';
import 'package:spendsmart/features/expenses/data/services/expense_service.dart';

class ExpenseRepository {
  final ExpenseService _service = ExpenseService();

  Future<ExpenseModel> createExpense(
    String idToken, {
    required String type,
    required double amount,
    required String title,
    String? note,
    required String paymentMethod,
    required String date,
    required String categoryId,
  }) {
    return _service.createExpense(
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

  Future<List<ExpenseModel>> getExpenses(String idToken) {
    return _service.getExpenses(idToken);
  }
}
