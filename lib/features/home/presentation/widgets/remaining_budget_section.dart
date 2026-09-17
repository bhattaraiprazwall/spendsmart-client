import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';
import 'package:spendsmart/core/utils/currency_util.dart';
import 'package:spendsmart/core/widgets/cards/budget_card.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/budget/domain/entities/budget.dart';
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
      error: (_, _) => const _EmptyBudgetCard(),
      data: (status) {
        final totalBudget = status != null
            ? (double.tryParse(status.totalAmount) ?? 0)
            : 0.0;
        if (status == null || totalBudget <= 0) {
          return const _EmptyBudgetCard();
        }

        // When only an overall monthly budget exists without category sub-budgets
        if (status.categories.isEmpty) {
          return _TotalBudgetCard(status: status, currency: currency);
        }

        // When category budgets exist, display overall card first followed by categories
        return SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: status.categories.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () => context.push(RoutePaths.budget),
                  child: BudgetCard(
                    item: _toTotalBudgetItem(context, status, currency),
                  ),
                );
              }
              final category = status.categories[index - 1];
              return GestureDetector(
                onTap: () => context.push(RoutePaths.budget),
                child: BudgetCard(
                  item: _toBudgetItem(context, category, currency),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _formatRemaining(String remainingStr, String currency) {
    final val = double.tryParse(remainingStr) ?? 0.0;
    final symbol = CurrencyUtil.symbolFor(currency);
    final formattedNum = val % 1 == 0
        ? val.toInt().toString()
        : val.toStringAsFixed(2);
    return '$symbol$formattedNum ${context.tr('left')}';
  }

  BudgetItem _toTotalBudgetItem(
    BuildContext context,
    BudgetStatus status,
    String currency,
  ) {
    final isAlert = status.usagePercentage >= 80 ||
        status.isOverspent ||
        status.status == 'WARNING' ||
        status.status == 'EXCEEDED';

    final barColor =
        isAlert ? const Color(0xFFDC2626) : const Color(0xFF0D53FC);
    final trackColor =
        isAlert ? const Color(0xFFFEECEB) : const Color(0xFFEBF2FE);
    final amountColor =
        isAlert ? const Color(0xFFDC2626) : context.colors.textPrimary;

    return BudgetItem(
      icon: Icons.account_balance_wallet_rounded,
      amount: _formatRemaining(status.remaining, currency),
      label: context.tr('monthly_budget').toUpperCase(),
      progress: (status.usagePercentage.clamp(0, 100)) / 100.0,
      color: barColor,
      iconColor: barColor,
      iconBgColor: trackColor,
      amountColor: amountColor,
      trackColor: trackColor,
    );
  }

  BudgetItem _toBudgetItem(
    BuildContext context,
    BudgetCategory cat,
    String currency,
  ) {
    final isAlert = cat.usagePercentage >= 80 ||
        cat.isOverspent ||
        cat.status == 'WARNING' ||
        cat.status == 'EXCEEDED';

    final barColor =
        isAlert ? const Color(0xFFDC2626) : const Color(0xFF0D53FC);
    final trackColor =
        isAlert ? const Color(0xFFFEECEB) : const Color(0xFFEBF2FE);
    final amountColor =
        isAlert ? const Color(0xFFDC2626) : context.colors.textPrimary;
    final icon = budgetResolveIcon(cat.icon);

    return BudgetItem(
      icon: icon,
      amount: _formatRemaining(cat.remaining, currency),
      label: cat.name.toUpperCase(),
      progress: (cat.usagePercentage.clamp(0, 100)) / 100.0,
      color: barColor,
      iconColor: barColor,
      iconBgColor: trackColor,
      amountColor: amountColor,
      trackColor: trackColor,
    );
  }
}

class _TotalBudgetCard extends StatelessWidget {
  final BudgetStatus status;
  final String currency;

  const _TotalBudgetCard({required this.status, required this.currency});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isAlert = status.usagePercentage >= 80 ||
        status.isOverspent ||
        status.status == 'WARNING' ||
        status.status == 'EXCEEDED';
    final color = isAlert ? const Color(0xFFDC2626) : const Color(0xFF0D53FC);
    final trackColor = isAlert ? const Color(0xFFFEECEB) : const Color(0xFFEBF2FE);
    final progress = (status.usagePercentage.clamp(0, 100)) / 100.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(RoutePaths.budget),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: c.card,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: trackColor,
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          color: color,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        context.tr('monthly_budget').toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: c.textSecondary,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: trackColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status.status,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    CurrencyUtil.format(status.remaining, currency),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    context.tr('left'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${status.usagePercentage}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: trackColor,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${context.tr('spent')}: ${CurrencyUtil.format(status.totalSpent, currency)}',
                    style: TextStyle(fontSize: 12, color: c.textSecondary),
                  ),
                  Text(
                    'Limit: ${CurrencyUtil.format(status.totalAmount, currency)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: c.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyBudgetCard extends StatelessWidget {
  const _EmptyBudgetCard();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(RoutePaths.budget),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: c.card,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.withValues(alpha: 0.1),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('no_budget_set'),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.tr('manage_budgets_hint'),
                      style: TextStyle(fontSize: 13, color: c.textSecondary),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
