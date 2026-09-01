import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/insights/data/datasources/insights_remote_data_source.dart';
import 'package:spendsmart/features/insights/data/repositories/insights_repository_impl.dart';
import 'package:spendsmart/features/insights/domain/entities/insight.dart';
import 'package:spendsmart/features/insights/domain/repositories/insights_repository.dart';
import 'package:spendsmart/features/insights/domain/usecases/get_insights.dart';

part 'insights_provider.g.dart';

@riverpod
InsightsRemoteDataSource insightsRemoteDataSource(Ref ref) {
  return InsightsRemoteDataSource();
}

@riverpod
InsightsRepository insightsRepository(Ref ref) {
  return InsightsRepositoryImpl();
}

@riverpod
GetInsights getInsights(Ref ref) {
  return GetInsights(ref.watch(insightsRepositoryProvider));
}

@riverpod
class InsightsPeriod extends _$InsightsPeriod {
  @override
  String build() => 'Monthly';

  void setPeriod(String period) => state = period;
}

@riverpod
Future<Insight> insights(Ref ref) async {
  final period = ref.watch(insightsPeriodProvider);
  final token = await ref.read(storageServiceProvider).getToken();

  if (token == null) throw Exception('No token found');

  return ref.read(getInsightsProvider)(token, period);
}
