import 'package:spendsmart/features/incomes/domain/entities/income.dart';

abstract class IncomeRepository {
  Future<Income> createIncome(
    String idToken, {
    required String type,
    required double amount,
    required String title,
    String? note,
    required String date,
    required String categoryId,
  });

  Future<List<Income>> getIncomes(String idToken);
}
