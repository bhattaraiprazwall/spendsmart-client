import 'package:spendsmart/features/insights/domain/entities/insight.dart';
import 'package:spendsmart/features/insights/domain/repositories/insights_repository.dart';

class GetInsights {
  final InsightsRepository _repository;

  GetInsights(this._repository);

  Future<Insight> call(String token, String period) {
    return _repository.getInsights(token, period);
  }
}
