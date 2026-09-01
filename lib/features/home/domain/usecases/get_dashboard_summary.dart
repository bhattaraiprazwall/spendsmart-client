import 'package:spendsmart/features/home/domain/entities/dashboard_summary.dart';
import 'package:spendsmart/features/home/domain/repositories/dashboard_repository.dart';

class GetDashboardSummary {
  final DashboardRepository _repository;

  GetDashboardSummary(this._repository);

  Future<DashboardSummary> call(
    String idToken, {
    int? month,
    int? year,
  }) {
    return _repository.getSummary(
      idToken,
      month: month,
      year: year,
    );
  }
}
