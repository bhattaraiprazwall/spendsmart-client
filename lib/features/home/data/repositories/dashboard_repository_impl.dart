import 'package:spendsmart/features/home/data/datasources/dashboard_remote_data_source.dart';
import 'package:spendsmart/features/home/domain/entities/dashboard_summary.dart';
import 'package:spendsmart/features/home/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<DashboardSummary> getSummary(
    String idToken, {
    int? month,
    int? year,
  }) {
    return _remoteDataSource.getSummary(
      idToken,
      month: month,
      year: year,
    );
  }
}
