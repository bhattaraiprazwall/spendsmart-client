import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/core/utils/currency_util.dart';

import '../providers/forecast_provider.dart';

class ForecastScreen extends ConsumerStatefulWidget {
  const ForecastScreen({super.key});

  @override
  ConsumerState<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends ConsumerState<ForecastScreen> {
  bool _isCalculationExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(monthlyForecastProvider);
    });
  }

  String formatMonth(int? month, int? year) {
    if (month == null || year == null) {
      return '';
    }

    final date = DateTime(year, month);

    return DateFormat('MMMM yyyy').format(date);
  }

  String formatShortMonth(int year, int month) {
    final date = DateTime(year, month);

    return DateFormat('MMM').format(date);
  }

  String formatCurrency(double amount, String currencyCode) {
    return CurrencyUtil.format(amount, currencyCode);
  }

  Widget _sectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  BoxDecoration _cardDecoration(ThemeData theme) {
    return BoxDecoration(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final forecastAsync = ref.watch(monthlyForecastProvider);
    final currencyCode = ref.watch(currencyProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(context.tr('spending_forecast')),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),

      body: forecastAsync.when(
        // ---------------------------------------------------------
        // LOADING
        // ---------------------------------------------------------
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },

        // ---------------------------------------------------------
        // ERROR
        // ---------------------------------------------------------
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 48,
                      color: theme.colorScheme.error,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    context.tr('unable_to_load_forecast'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    (error.toString().contains('SocketException') ||
                            error.toString().contains('NetworkException') ||
                            error.toString().contains('No internet connection') ||
                            error.toString().contains('No route to host'))
                        ? context.tr('no_internet')
                        : error.toString().replaceAll('Exception: ', ''),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  FilledButton.icon(
                    onPressed: () {
                      ref.invalidate(
                        monthlyForecastProvider,
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(context.tr('try_again')),
                  ),
                ],
              ),
            ),
          );
        },

        // ---------------------------------------------------------
        // DATA
        // ---------------------------------------------------------
        data: (forecast) {
          // -------------------------------------------------------
          // INSUFFICIENT DATA
          // -------------------------------------------------------
          if (forecast.status == 'INSUFFICIENT_DATA') {
            return RefreshIndicator(
              onRefresh: () {
                return ref.refresh(
                  monthlyForecastProvider.future,
                );
              },

              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),

                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.22,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.insights_outlined,
                            size: 56,
                            color: theme.colorScheme.primary,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          context.tr('not_enough_data'),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 12),

                        Text(
                          forecast.message,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        Text(
                          context.tr('keep_tracking_three_months'),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          // -------------------------------------------------------
          // FORECASTED DATA
          // -------------------------------------------------------

          final forecastAmount = forecast.forecast ?? 0;

          return RefreshIndicator(
            onRefresh: () {
              return ref.refresh(
                monthlyForecastProvider.future,
              );
            },

            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),

              children: [
                // =================================================
                // FORECAST HEADER
                // =================================================

                Text(
                  context.tr('next_month_forecast'),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  context.tr('based_on_recent_history'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 16),

                // =================================================
                // FORECAST CARD
                // =================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withValues(alpha: 0.75),
                      ],
                    ),
                  ),

                  child: Column(
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 40,
                        color: theme.colorScheme.onPrimary,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        formatMonth(
                          forecast.forecastMonth,
                          forecast.forecastYear,
                        ),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        formatCurrency(
                                      forecastAmount,
                                      currencyCode,
                                    ),
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        context.tr('estimated_spending'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Divider(
                        color: theme.colorScheme.onPrimary.withValues(alpha: 0.3),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        forecast.message,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // =================================================
                // HOW IT IS CALCULATED (EXPANDABLE)
                // =================================================

                _sectionTitle(theme, context.tr('how_it_calculated')),

                const SizedBox(height: 12),

                Container(
                  decoration: _cardDecoration(theme),
                  clipBehavior: Clip.antiAlias,

                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isCalculationExpanded =
                                !_isCalculationExpanded;
                          });
                        },

                        child: Padding(
                          padding: const EdgeInsets.all(20),

                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer
                                      .withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.calculate_outlined,
                                  color: theme.colorScheme.primary,
                                  size: 20,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  context.tr('three_month_moving_average'),
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              AnimatedRotation(
                                turns: _isCalculationExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      AnimatedCrossFade(
                        firstChild: const SizedBox(width: double.infinity),
                        secondChild: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                context.tr('forecast_calculation_desc'),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),

                              const SizedBox(height: 16),

                              if (forecast.valuesUsed.isNotEmpty)
                                ...forecast.valuesUsed.asMap().entries.map(
                                  (entry) {
                                    final index = entry.key;
                                    final value = entry.value;

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8,
                                      ),

                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,

                                        children: [
                                          Text(
                                            '${context.tr('month_num')} ${index + 1}',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                              color: theme
                                                  .colorScheme.onSurfaceVariant,
                                            ),
                                          ),

                                          Text(
                                            formatCurrency(
                                              value,
                                              currencyCode,
                                            ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                              const Divider(height: 24),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,

                                children: [
                                  Text(
                                    context.tr('forecast_label'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
formatCurrency(forecastAmount, currencyCode),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        crossFadeState: _isCalculationExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 200),
                        sizeCurve: Curves.easeInOut,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // =================================================
                // HISTORICAL SPENDING
                // =================================================

                _sectionTitle(theme, context.tr('recent_spending')),

                const SizedBox(height: 12),

                if (forecast.historicalMonths.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: _cardDecoration(theme),
                    child: Text(
                      context.tr('no_historical_spending'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                else
                  ...forecast.historicalMonths.map(
                    (month) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: _cardDecoration(theme),

                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor:
                                theme.colorScheme.primaryContainer,
                            foregroundColor: theme.colorScheme.primary,
                            child: Text(
                              formatShortMonth(
                                month.year,
                                month.month,
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          title: Text(
                            DateFormat('MMMM yyyy').format(
                              DateTime(
                                month.year,
                                month.month,
                              ),
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          trailing: Text(
                            formatCurrency(month.total, currencyCode),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 20),

                // =================================================
                // ALGORITHM INFORMATION
                // =================================================

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer
                        .withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Text(
                          context.tr('forecast_algorithm_info'),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // =================================================
                // REFRESH BUTTON
                // =================================================

                OutlinedButton.icon(
                  onPressed: () {
                    ref.invalidate(
                      monthlyForecastProvider,
                    );
                  },

                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  icon: const Icon(Icons.refresh),

                  label: Text(
                    context.tr('refresh_forecast'),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}