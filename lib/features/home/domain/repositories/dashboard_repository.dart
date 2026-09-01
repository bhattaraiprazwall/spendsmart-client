import 'package:spendsmart/features/home/domain/entities/dashboard_summary.dart';

abstract class DashboardRepository {
  Future<DashboardSummary> getSummary(
    String idToken, {
    int? month,
    int? year,
  });
}
