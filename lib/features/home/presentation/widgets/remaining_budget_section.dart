import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/core/utils/currency_util.dart';
import 'package:spendsmart/core/widgets/cards/budget_card.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/budget/domain/entities/budget_category.dart';
import 'package:spendsmart/features/budget/presentation/providers/budget_provider.dart';
import 'package:spendsmart/features/budget/presentation/widgets/budget_status_widgets.dart';
import 'package:spendsmart/features/home/domain/entities/budget_item.dart';

class RemainingBudgetSection extends ConsumerStatefulWidget {
  const RemainingBudgetSection({super.key});

  @override
  ConsumerState<RemainingBudgetSection> createState() =>
      _RemainingBudgetSectionState();
}

class _RemainingBudgetSectionState
    extends ConsumerState<RemainingBudgetSection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  Future<void> _load() async {
    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null) return;
    final now = DateTime.now();
    await ref
        .read(budgetProvider.notifier)
        .fetchBudget(token, month: now.month, year: now.year);
  }

  @override
  Widget build(BuildContext context) {
    final budgetAsync = ref.watch(budgetProvider);
    final currency = ref.watch(currencyProvider);

    return budgetAsync.when(
      loading: () => const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const _EmptyBudgetCard(),
      data: (status) {
        if (status == null || status.categories.isEmpty) {
          return const _EmptyBudgetCard();
        }
        return SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: status.categories.length,
            itemBuilder: (context, index) {
              return BudgetCard(
                item: _toBudgetItem(status.categories[index], currency),
              );
            },
          ),
        );
      },
    );
  }

  BudgetItem _toBudgetItem(BudgetCategory cat, String currency) {
    final color = budgetStatusColor(cat.status);
    final icon = budgetResolveIcon(cat.icon);
    return BudgetItem(
      icon: icon,
      amount:
          '${CurrencyUtil.format(cat.remaining, currency)} left',
      label: cat.name.toUpperCase(),
      progress: (cat.usagePercentage.clamp(0, 100)) / 100,
      color: color,
      iconColor: color,
    );
  }
}

class _EmptyBudgetCard extends StatelessWidget {
  const _EmptyBudgetCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No budget set for this month',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 6),
          Text(
            'Manage budgets from the quick action menu.',
            style: TextStyle(fontSize: 13, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
