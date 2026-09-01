import 'package:spendsmart/features/expenses/data/datasources/expense_remote_datasource.dart';
import 'package:spendsmart/features/expenses/domain/entities/expense.dart';
import 'package:spendsmart/features/expenses/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource _remoteDataSource;

  ExpenseRepositoryImpl(this._remoteDataSource);

  @override
  Future<Expense> createExpense(
    String idToken, {
    required String type,
    required double amount,
    required String title,
    String? note,
    required String paymentMethod,
    required String date,
    required String categoryId,
  }) async {
    final model = await _remoteDataSource.createExpense(
      idToken,
      type: type,
      amount: amount,
      title: title,
      note: note,
      paymentMethod: paymentMethod,
      date: date,
      categoryId: categoryId,
    );
    return model.toEntity();
  }

  @override
  Future<List<Expense>> getExpenses(String idToken) async {
    final models = await _remoteDataSource.getExpenses(idToken);
    return models.map((m) => m.toEntity()).toList();
  }
}
