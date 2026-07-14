import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/widgets/navigation/bottom_nav_bar.dart';
import 'package:spendsmart/core/widgets/navigation/spendsmart_appbar.dart';
import 'package:spendsmart/core/widgets/sections/section_header.dart';
import 'package:spendsmart/core/widgets/sections/smart_forecast_card.dart';
import 'package:spendsmart/features/category/presentation/providers/category_provider.dart';
import 'package:spendsmart/features/category/presentation/screens/add_category_screen.dart';
import 'package:spendsmart/features/category/presentation/screens/categories_list.dart';
import 'package:spendsmart/features/home/presentation/widgets/income_expense_section.dart';
import 'package:spendsmart/features/home/presentation/widgets/recent_transactions_section.dart';
import 'package:spendsmart/features/home/presentation/widgets/remaining_budget_section.dart';
import 'package:spendsmart/features/home/presentation/widgets/total_balance_card.dart';
import 'package:spendsmart/features/profile/presentation/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 4
          ? null
          : SpendsmartAppbar(
              onProfileTap: () {},
              onMenuTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const CategoriesScreen();
                    },
                  ),
                );
              },
              profileImageUrl:
                  'https://www.gravatar.com/avatar/2c7d99fe281ecd3bcd65ab915bac6dd5?s=250',
            ),
      body: _buildPage(),
      bottomNavigationBar: BottomNavBar(
        onTabChanged: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard();
      case 1:
        return const Center(child: Text("Transactions"));
      case 3:
        return const Center(child: Text("Insights"));
      case 4:
        return const ProfileScreen();
      default:
        return const SizedBox();
    }
  }

  Widget _buildDashboard() {
    return SafeArea(
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
    );
  }
}
