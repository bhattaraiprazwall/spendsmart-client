import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/core/widgets/navigation/spendsmart_appbar.dart';
import 'package:spendsmart/core/widgets/sections/section_header.dart';
import 'package:spendsmart/core/widgets/sections/smart_forecast_card.dart';
import 'package:spendsmart/features/home/presentation/widgets/income_expense_section.dart';
import 'package:spendsmart/features/home/presentation/widgets/recent_transactions_section.dart';
import 'package:spendsmart/features/home/presentation/widgets/remaining_budget_section.dart';
import 'package:spendsmart/features/home/presentation/widgets/total_balance_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpendsmartAppbar(
        onProfileTap: () {},
        onMenuTap: () => context.push(RoutePaths.categories),
        profileImageUrl:
            'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const TotalBalanceCard(),
                  const SizedBox(height: 20),
                  const IncomeExpenseSection(),
                  const SizedBox(height: 30),
                  const SmartForecastCard(
                    title: 'Smart Forecast',
                    description:
                        'You\'re on the track to save \$120 this month.Keep dining out below \$50 this week to hit your goal.',
                  ),
                  const SizedBox(height: 30),
                  SectionHeader(title: 'Remaining Budget'),
                  const SizedBox(height: 16),
                  const RemainingBudgetSection(),
                  const SizedBox(height: 30),
                  SectionHeader(
                    title: 'Recent Transactions',
                    actionText: 'SEE ALL',
                    onActionTap: () {},
                  ),
                  const SizedBox(height: 16),
                  const RecentTransactionsSection(),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
