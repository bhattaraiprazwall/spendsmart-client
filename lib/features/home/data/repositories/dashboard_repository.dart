import 'package:spendsmart/features/home/data/services/dashboard_service.dart';
import 'package:spendsmart/features/home/models/dashboard_summary.dart';

class DashboardRepository {
  final DashboardService _service = DashboardService();

  Future<DashboardSummary> getSummary(
    String idToken, {
    int? month,
    int? year,
  }) {
    return _service.getSummary(
      idToken,
      month: month,
      year: year,
    );
  }
}
