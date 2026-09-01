import 'package:spendsmart/features/expenses/domain/entities/expense.dart';

abstract class ExpenseRepository {
  Future<Expense> createExpense(
    String idToken, {
    required String type,
    required double amount,
    required String title,
    String? note,
    required String paymentMethod,
    required String date,
    required String categoryId,
  });

  Future<List<Expense>> getExpenses(String idToken);
}
