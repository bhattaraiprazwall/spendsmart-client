import 'package:spendsmart/features/insights/domain/entities/spending_anomaly.dart';
import 'package:spendsmart/features/insights/domain/repositories/insights_repository.dart';

class GetSpendingAnomaly {
  final InsightsRepository _repository;

  GetSpendingAnomaly(this._repository);

  Future<SpendingAnomaly> call(String token) {
    return _repository.getSpendingAnomaly(token);
  }
}