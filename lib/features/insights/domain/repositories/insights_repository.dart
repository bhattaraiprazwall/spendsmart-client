import 'package:spendsmart/features/insights/domain/entities/insight.dart';

abstract class InsightsRepository {
  Future<Insight> getInsights(String token, String period);
}
