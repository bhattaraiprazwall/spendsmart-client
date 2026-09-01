import 'package:spendsmart/features/incomes/domain/entities/income.dart';
import 'package:spendsmart/features/incomes/domain/repositories/income_repository.dart';

class CreateIncome {
  final IncomeRepository _repository;

  CreateIncome(this._repository);

  Future<Income> call(
    String idToken, {
    required String type,
    required double amount,
    required String title,
    String? note,
    required String date,
    required String categoryId,
  }) {
    return _repository.createIncome(
      idToken,
      type: type,
      amount: amount,
      title: title,
      note: note,
      date: date,
      categoryId: categoryId,
    );
  }
}
