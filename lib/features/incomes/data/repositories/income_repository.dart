import 'package:spendsmart/features/incomes/data/models/income.dart';
import 'package:spendsmart/features/incomes/data/services/income_service.dart';

class IncomeRepository {
  final IncomeService _service = IncomeService();

  Future<IncomeModel> createIncome(
    String idToken, {
    required String type,
    required double amount,
    required String title,
    String? note,
    required String date,
    required String categoryId,
  }) {
    return _service.createIncome(
      idToken,
      type: type,
      amount: amount,
      title: title,
      note: note,
      date: date,
      categoryId: categoryId,
    );
  }

  Future<List<IncomeModel>> getIncomes(String idToken) {
    return _service.getIncomes(idToken);
  }
}
