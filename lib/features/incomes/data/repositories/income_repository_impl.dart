import 'package:spendsmart/features/incomes/data/datasources/income_remote_datasource.dart';
import 'package:spendsmart/features/incomes/domain/entities/income.dart';
import 'package:spendsmart/features/incomes/domain/repositories/income_repository.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final IncomeRemoteDataSource _remoteDataSource;

  IncomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Income> createIncome(
    String idToken, {
    required String type,
    required double amount,
    required String title,
    String? note,
    required String date,
    required String categoryId,
  }) async {
    final model = await _remoteDataSource.createIncome(
      idToken,
      type: type,
      amount: amount,
      title: title,
      note: note,
      date: date,
      categoryId: categoryId,
    );
    return model.toEntity();
  }

  @override
  Future<List<Income>> getIncomes(String idToken) async {
    final models = await _remoteDataSource.getIncomes(idToken);
    return models.map((m) => m.toEntity()).toList();
  }
}
