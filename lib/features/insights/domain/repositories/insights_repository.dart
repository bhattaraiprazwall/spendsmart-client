import 'package:spendsmart/features/insights/domain/entities/insight.dart';
import 'package:spendsmart/features/insights/domain/entities/spending_anomaly.dart';

abstract class InsightsRepository {
  Future<Insight> getInsights(
      String token,
      String period,
      );

  Future<SpendingAnomaly> getSpendingAnomaly(
      String token,
      );
}