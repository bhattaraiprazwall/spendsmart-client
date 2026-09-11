import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';
import 'package:spendsmart/core/utils/currency_util.dart';

import '../providers/forecast_provider.dart';

class ForecastSummaryCard extends ConsumerWidget {
  const ForecastSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final forecastAsync = ref.watch(monthlyForecastProvider);
    final currencyCode = ref.watch(currencyProvider);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: c.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: forecastAsync.when(
            loading: () => _buildLoadingState(context),
            error: (_, _) => _buildErrorState(context),
            data: (forecast) {
              if (forecast.status == 'INSUFFICIENT_DATA') {
                return _buildInsufficientDataState(context, forecast.message);
              }
              return _buildForecastDataState(
                context,
                forecast.forecastMonth,
                forecast.forecastYear,
                forecast.forecast ?? 0,
                currencyCode,
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => context.push(RoutePaths.forecast),
            child: Text(context.tr('spending_forecast')),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final c = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildForecastIcon(),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('spending_forecast'),
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: c.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final c = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildForecastIcon(),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('spending_forecast'),
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                context.tr('unable_to_load_forecast'),
                style: AppTextStyles.body.copyWith(
                  fontSize: 15,
                  color: c.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsufficientDataState(BuildContext context, String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildForecastIcon(),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('spending_forecast'),
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message.isNotEmpty
                    ? message
                    : context.tr('keep_tracking_forecast_hint'),
                style: AppTextStyles.body.copyWith(
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForecastDataState(
    BuildContext context,
    int? forecastMonth,
    int? forecastYear,
    double amount,
    String currencyCode,
  ) {
    final monthLabel = _formatMonth(forecastMonth, forecastYear);
    final formattedAmount = CurrencyUtil.format(amount, currencyCode);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildForecastIcon(),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('spending_forecast'),
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              if (monthLabel.isNotEmpty) ...[
                Text(
                  monthLabel,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                formattedAmount,
                style: AppTextStyles.body.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatMonth(int? month, int? year) {
    if (month == null || year == null) return '';
    return DateFormat('MMMM yyyy').format(DateTime(year, month));
  }

  Widget _buildForecastIcon() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
      ),
      child: const Icon(Icons.trending_up, color: Colors.white),
    );
  }
}
