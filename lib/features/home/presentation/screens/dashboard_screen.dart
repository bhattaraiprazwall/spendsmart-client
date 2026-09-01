import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/core/utils/currency_util.dart';
import 'package:spendsmart/core/widgets/sections/section_header.dart';
import 'package:spendsmart/core/widgets/sections/smart_forecast_card.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/profile/presentation/providers/profile_provider.dart';
import 'package:spendsmart/features/home/presentation/providers/dashboard_provider.dart';
import 'package:spendsmart/features/home/presentation/widgets/dashboard_topbar.dart';
import 'package:spendsmart/features/home/presentation/widgets/income_expense_section.dart';
import 'package:spendsmart/features/home/presentation/widgets/recent_transactions_section.dart';
import 'package:spendsmart/features/home/presentation/widgets/remaining_budget_section.dart';
import 'package:spendsmart/features/home/presentation/widgets/total_balance_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _fetchProfile();
    _fetchDashboard();
  }

  Future<void> _fetchDashboard() async {
    final token = await ref.read(storageServiceProvider).getToken();
    if (token != null && mounted) {
      ref.read(dashboardProvider.notifier).fetchSummary(token);
    }
  }

  Future<void> _fetchProfile() async {
    final token = await ref.read(storageServiceProvider).getToken();
    if (token != null && mounted) {
      ref.read(profileProvider.notifier).fetchProfile(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showExitConfirmation(context);
      },
      child: Scaffold(
        appBar: DashboardTopBar(),
        body: SafeArea(
          child: _buildBody(context),
        ),
      ),
    );
  }

  Future<void> _showExitConfirmation(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Icon(
                  Icons.exit_to_app,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Exit App?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              const Text(
                'Are you sure you want to exit?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFDDE0EF)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('No', style: TextStyle(color: Colors.black54)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Yes', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (shouldExit == true && context.mounted) {
      SystemNavigator.pop();
    }
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
              'Unable to load dashboard',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _fetchDashboard,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (summary) {
        final overview = summary.overview;
        final symbol = CurrencyUtil.symbolFor(ref.watch(currencyProvider));
        final forecastDescription =
            'You\'re on the track to save ${symbol}120 this month. '
            'Keep dining out below ${symbol}50 this week to hit your goal.';

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  TotalBalanceCard(
                    balance: overview.totalBalance,
                    currency: overview.currency,
                    periodLabel: summary.period.label,
                  ),
                  const SizedBox(height: 20),
                  IncomeExpenseSection(
                    income: overview.totalIncome,
                    expense: overview.totalExpenses,
                    currency: overview.currency,
                  ),
                  const SizedBox(height: 30),
                  SmartForecastCard(
                    title: 'Smart Forecast',
                    description: forecastDescription,
                  ),
                  const SizedBox(height: 30),
                  const SectionHeader(title: 'Remaining Budget'),
                  const SizedBox(height: 16),
                  const RemainingBudgetSection(),
                  const SizedBox(height: 30),
                  SectionHeader(
                    title: 'Recent Transactions',
                    actionText: 'SEE ALL',
                    onActionTap: () {
                      context.push(RoutePaths.transactions);
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
        );
      },
    );
  }
}
