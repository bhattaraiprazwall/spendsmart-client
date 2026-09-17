import 'package:spendsmart/features/insights/data/datasources/insights_local_data_source.dart';
import 'package:spendsmart/features/insights/data/datasources/insights_remote_data_source.dart';
import 'package:spendsmart/features/insights/domain/entities/insight.dart';
import 'package:spendsmart/features/insights/domain/entities/spending_anomaly.dart';
import 'package:spendsmart/features/insights/domain/repositories/insights_repository.dart';

class InsightsRepositoryImpl implements InsightsRepository {
  final InsightsRemoteDataSource _remoteDataSource;
  final InsightsLocalDataSource _localDataSource;

  InsightsRepositoryImpl({
    required InsightsRemoteDataSource remoteDataSource,
    required InsightsLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Insight> getInsights(
    String token,
    String period,
  ) async {
    if (token.isNotEmpty) {
      try {
        final model = await _remoteDataSource.getInsights(token, period);
        return model.toEntity();
      } catch (_) {
        // Fallback to local computation
      }
    }

    return _localDataSource.computeLocalInsights(period);
  }

  @override
  Future<SpendingAnomaly> getSpendingAnomaly(String token) async {
    if (token.isNotEmpty) {
      try {
        final model = await _remoteDataSource.getSpendingAnomaly(token);
        return model.toEntity();
      } catch (_) {
        // Fallback to local computation
      }
    }

    return _localDataSource.computeLocalSpendingAnomaly();
  }
}