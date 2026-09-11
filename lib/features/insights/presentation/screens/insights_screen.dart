import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/core/utils/currency_util.dart';
import 'package:spendsmart/core/utils/icon_helper.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';
import '../providers/insights_provider.dart';
import '../../domain/entities/insight.dart';
import '../widgets/spending_anomaly_card.dart';
import '../../domain/entities/spending_anomaly.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/features/forecast/presentation/providers/forecast_provider.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final insightsAsync = ref.watch(insightsProvider);
    final AsyncValue<SpendingAnomaly> anomalyAsync =
    ref.watch(spendingAnomalyProvider);
    final selectedPeriod = ref.watch(insightsPeriodProvider);

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: insightsAsync.when(
          data: (data) => _buildContent(
            context,
            ref,
            data,
            selectedPeriod,
            anomalyAsync,
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      WidgetRef ref,
      Insight data,
      String selectedPeriod,
      AsyncValue<SpendingAnomaly> anomalyAsync,
      ) {
    final currency = ref.watch(currencyProvider);
    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          ref.refresh(insightsProvider.future),
          ref.refresh(spendingAnomalyProvider.future),
        ]);
      },      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeriodSwitcher(context, ref, selectedPeriod),

            const SizedBox(height: 24),

            if (data.topInsight != null) ...[
              _buildInsightCard(context, data.topInsight!),
              const SizedBox(height: 24),
            ],

            anomalyAsync.when(
              data: (anomaly) => SpendingAnomalyCard(
                anomaly: anomaly,
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, _) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 24),

            _buildForecastSummaryCard(context, ref),

            const SizedBox(height: 24),

            if (data.breakdown.isNotEmpty) ...[
              _buildChartCard(context, data, currency),
              const SizedBox(height: 24),
              _buildBreakdownSection(context, data.breakdown, currency),
            ] else
              Center(
                child: Text(context.tr('no_expense_period')),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSwitcher(
      BuildContext context,
      WidgetRef ref,
      String selectedPeriod,
    ) {
    final c = context.colors;
    final periods = [
      {'key': 'Weekly', 'label': context.tr('weekly')},
      {'key': 'Monthly', 'label': context.tr('monthly')},
      {'key': 'Yearly', 'label': context.tr('yearly')},
    ];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: periods.map((periodItem) {
          final periodKey = periodItem['key']!;
          final periodLabel = periodItem['label']!;
          final isSelected = selectedPeriod == periodKey;
          return Expanded(
            child: GestureDetector(
              onTap: () => ref.read(insightsPeriodProvider.notifier).setPeriod(periodKey),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? c.card : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    periodLabel,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF2D5BFF) : c.textSecondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInsightCard(BuildContext context, TopInsight insight) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _hexToColor(insight.color).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              IconHelper.getIcon(insight.icon), 
              color: _hexToColor(insight.color), 
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('top_spending_insight'),
                  style: TextStyle(
                    color: c.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: c.textPrimary,
                      fontSize: 15,
                      height: 1.5,
                      fontFamily: 'Manrope',
                    ),
                    children: [
                      TextSpan(
                        text: insight.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' ${context.tr('highest_expense_desc_1')} '),
                      TextSpan(
                        text: '${insight.percentage}%',
                        style: TextStyle(
                          color: _hexToColor(insight.color), 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: ' ${context.tr('highest_expense_desc_2')}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastSummaryCard(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final forecastAsync = ref.watch(monthlyForecastProvider);

    return GestureDetector(
      onTap: () => context.push(RoutePaths.forecast),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: c.border),
        ),
        child: forecastAsync.when(
          loading: () => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D5BFF).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up,
                  color: Color(0xFF2D5BFF),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('spending_forecast'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 14,
                      width: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: c.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          error: (_, _) => const SizedBox.shrink(),
          data: (forecast) {
            if (forecast.status == 'INSUFFICIENT_DATA') {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D5BFF).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.trending_up,
                      color: Color(0xFF2D5BFF),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('spending_forecast'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: c.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          context.tr('keep_tracking_insights_hint'),
                          style: TextStyle(
                            fontSize: 14,
                            color: c.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: c.chevron,
                  ),
                ],
              );
            }

            final monthLabel = _formatMonth(
              forecast.forecastMonth,
              forecast.forecastYear,
            );
            final amount = CurrencyUtil.format(forecast.forecast ?? 0, ref.watch(currencyProvider));

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D5BFF).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.trending_up,
                    color: Color(0xFF2D5BFF),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr('spending_forecast'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (monthLabel.isNotEmpty) ...[
                        Text(
                          monthLabel,
                          style: TextStyle(
                            fontSize: 14,
                            color: c.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      Text(
                        amount,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: c.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: c.chevron,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatMonth(int? month, int? year) {
    if (month == null || year == null) return '';
    return DateFormat('MMMM yyyy').format(DateTime(year, month));
  }

  Widget _buildChartCard(BuildContext context, Insight data, String currency) {
    final c = context.colors;
    return Container(
      height: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 8,
              centerSpaceRadius: 80,
              sections: data.breakdown.map((item) {
                return PieChartSectionData(
                  color: _hexToColor(item.color),
                  value: item.percentage * 100,
                  radius: 30,
                  showTitle: false,
                );
              }).toList(),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr('total_spent'),
                style: TextStyle(
                  color: c.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                CurrencyUtil.format(data.totalSpent, currency),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: c.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownSection(
      BuildContext context,
      List<CategoryBreakdown> breakdown,
      String currency,
    ) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('breakdown'),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: c.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          ...breakdown.map((item) => _buildBreakdownItem(context, item, currency)),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(BuildContext context, CategoryBreakdown item, String currency) {
    final c = context.colors;
    final color = _hexToColor(item.color);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(IconHelper.getIcon(item.icon), color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${(item.percentage * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 13,
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            CurrencyUtil.format(item.amount, currency),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Color _hexToColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse(h.length == 6 ? 'FF$h' : h, radix: 16));
  }


}


