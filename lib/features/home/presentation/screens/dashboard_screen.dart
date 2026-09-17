import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';
import 'package:spendsmart/core/widgets/sections/section_header.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/budget/presentation/providers/budget_provider.dart';
import 'package:spendsmart/features/forecast/presentation/widgets/forecast_summary_card.dart';
import 'package:spendsmart/features/profile/presentation/providers/profile_provider.dart';
import 'package:spendsmart/features/home/presentation/providers/dashboard_provider.dart';
import 'package:spendsmart/features/home/presentation/widgets/dashboard_topbar.dart';
import 'package:spendsmart/features/home/presentation/widgets/income_expense_section.dart';
import 'package:spendsmart/features/home/presentation/widgets/recent_transactions_section.dart';
import 'package:spendsmart/features/home/presentation/widgets/remaining_budget_section.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/features/home/presentation/widgets/total_balance_card.dart';
import 'package:spendsmart/features/notifications/presentation/providers/notification_provider.dart';
import 'package:spendsmart/features/forecast/presentation/providers/forecast_provider.dart';
import 'package:spendsmart/features/insights/presentation/providers/insights_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    final token = await ref.read(storageServiceProvider).getToken();
    if (token != null && mounted) {
      final now = DateTime.now();
      await Future.wait([
        (() async {
          try {
            await ref.read(dashboardProvider.notifier).fetchSummary(token);
          } catch (_) {}
        })(),
        (() async {
          try {
            await ref.read(budgetProvider.notifier).fetchBudget(token, month: now.month, year: now.year);
          } catch (_) {}
        })(),
        (() async {
          try {
            await ref.read(profileProvider.notifier).fetchProfile(token);
          } catch (_) {}
        })(),
        (() async {
          try {
            ref.invalidate(monthlyForecastProvider);
            await ref.read(monthlyForecastProvider.future);
          } catch (_) {}
        })(),
        (() async {
          try {
            ref.invalidate(insightsProvider);
            ref.invalidate(spendingAnomalyProvider);
            await ref.read(insightsProvider.future);
            await ref.read(spendingAnomalyProvider.future);
          } catch (_) {}
        })(),
      ]);
      if (mounted) {
        try {
          ref.read(notificationProvider.notifier).refresh();
        } catch (_) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DashboardTopBar(),
      body: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    final dashboardAsync = ref.watch(dashboardProvider);

    return dashboardAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.tr('unable_to_load_dashboard'),
              style: TextStyle(color: context.colors.textSecondary),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _fetchDashboard,
              child: Text(context.tr('retry')),
            ),
          ],
        ),
      ),
      data: (summary) {
        final overview = summary.overview;

        return RefreshIndicator(
          onRefresh: _fetchDashboard,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    TotalBalanceCard(
                      balance: overview.totalBalance,
                      currency: ref.watch(currencyProvider),
                      periodLabel: summary.period.label,
                    ),
                    const SizedBox(height: 20),
                    IncomeExpenseSection(
                      income: overview.totalIncome,
                      expense: overview.totalExpenses,
                      currency: ref.watch(currencyProvider),
                    ),
                    const SizedBox(height: 30),
                    const ForecastSummaryCard(),
                    const SizedBox(height: 30),
                    SectionHeader(
                      title: context.tr('remaining_budget'),
                      actionText: context.tr('see_all'),
                      onActionTap: () => context.push(RoutePaths.budget),
                    ),
                    const SizedBox(height: 16),
                    const RemainingBudgetSection(),
                    const SizedBox(height: 30),
                    SectionHeader(
                      title: context.tr('recent_transactions'),
                      actionText: context.tr('see_all'),
                      onActionTap: () {
                        final shell = StatefulNavigationShell.maybeOf(context);
                        if (shell != null) {
                          shell.goBranch(1);
                        } else {
                          context.go(RoutePaths.transactions);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    RecentTransactionsSection(
                      transactions: summary.recentTransactions,
                    ),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
