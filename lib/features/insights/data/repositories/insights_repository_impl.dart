import 'package:spendsmart/features/insights/data/datasources/insights_remote_data_source.dart';
import 'package:spendsmart/features/insights/domain/entities/insight.dart';
import 'package:spendsmart/features/insights/domain/repositories/insights_repository.dart';

class InsightsRepositoryImpl implements InsightsRepository {
  final InsightsRemoteDataSource _remoteDataSource = InsightsRemoteDataSource();

  @override
  Future<Insight> getInsights(String token, String period) async {
    final model = await _remoteDataSource.getInsights(token, period);
    return model.toEntity();
  }
}
