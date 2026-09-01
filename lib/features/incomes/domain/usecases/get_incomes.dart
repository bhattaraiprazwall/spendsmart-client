import 'package:spendsmart/features/incomes/domain/entities/income.dart';
import 'package:spendsmart/features/incomes/domain/repositories/income_repository.dart';

class GetIncomes {
  final IncomeRepository _repository;

  GetIncomes(this._repository);

  Future<List<Income>> call(String idToken) {
    return _repository.getIncomes(idToken);
  }
}
