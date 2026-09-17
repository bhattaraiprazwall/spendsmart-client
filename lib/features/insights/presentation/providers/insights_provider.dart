import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/database/database_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/insights/data/datasources/insights_local_data_source.dart';
import 'package:spendsmart/features/insights/data/datasources/insights_remote_data_source.dart';
import 'package:spendsmart/features/insights/data/repositories/insights_repository_impl.dart';
import 'package:spendsmart/features/insights/domain/entities/insight.dart';
import 'package:spendsmart/features/insights/domain/entities/spending_anomaly.dart';
import 'package:spendsmart/features/insights/domain/repositories/insights_repository.dart';
import 'package:spendsmart/features/insights/domain/usecases/get_insights.dart';
import 'package:spendsmart/features/insights/domain/usecases/get_spending_anomaly.dart';

part 'insights_provider.g.dart';

@riverpod
InsightsLocalDataSource insightsLocalDataSource(Ref ref) {
  return InsightsLocalDataSourceImpl(
    transactionDao: ref.watch(transactionDaoProvider),
    storageService: ref.watch(storageServiceProvider),
  );
}

@riverpod
InsightsRemoteDataSource insightsRemoteDataSource(Ref ref) {
  return InsightsRemoteDataSourceImpl();
}

@riverpod
InsightsRepository insightsRepository(Ref ref) {
  return InsightsRepositoryImpl(
    remoteDataSource: ref.watch(insightsRemoteDataSourceProvider),
    localDataSource: ref.watch(insightsLocalDataSourceProvider),
  );
}

@riverpod
GetInsights getInsights(Ref ref) {
  return GetInsights(ref.watch(insightsRepositoryProvider));
}

@riverpod
GetSpendingAnomaly getSpendingAnomaly(Ref ref) {
  return GetSpendingAnomaly(
    ref.watch(insightsRepositoryProvider),
  );
}

@riverpod
class InsightsPeriod extends _$InsightsPeriod {
  @override
  String build() => 'Monthly';

  void setPeriod(String period) => state = period;
}

@Riverpod(keepAlive: true)
class InsightsNotifier extends _$InsightsNotifier {
  StreamSubscription? _driftSub;

  @override
  FutureOr<Insight> build() async {
    final period = ref.watch(insightsPeriodProvider);
    final localDataSource = ref.watch(insightsLocalDataSourceProvider);
    final userId = await localDataSource.getUserId();

    if (userId != null) {
      _driftSub?.cancel();
      _driftSub = localDataSource
          .watchLocalInsights(userId, period)
          .listen((insight) {
        state = AsyncData(insight);
      });
      ref.onDispose(() => _driftSub?.cancel());
    }

    final token = await ref.read(storageServiceProvider).getToken() ?? '';
    return ref.read(getInsightsProvider)(token, period);
  }
}


@Riverpod(keepAlive: true)
class SpendingAnomalyNotifier extends _$SpendingAnomalyNotifier {
  StreamSubscription? _driftSub;

  @override
  FutureOr<SpendingAnomaly> build() async {
    final localDataSource = ref.watch(insightsLocalDataSourceProvider);
    final userId = await localDataSource.getUserId();

    if (userId != null) {
      _driftSub?.cancel();
      _driftSub = localDataSource
          .watchLocalSpendingAnomaly(userId)
          .listen((anomaly) {
        state = AsyncData(anomaly);
      });
      ref.onDispose(() => _driftSub?.cancel());
    }

    final token = await ref.read(storageServiceProvider).getToken() ?? '';
    return ref.read(getSpendingAnomalyProvider).call(token);
  }
}

