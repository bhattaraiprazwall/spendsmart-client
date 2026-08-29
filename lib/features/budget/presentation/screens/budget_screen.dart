import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/core/utils/currency_util.dart';
import 'package:spendsmart/core/widgets/navigation/apptopbar.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
import 'package:spendsmart/features/budget/data/models/budget_category_model.dart';
import 'package:spendsmart/features/budget/data/models/budget_model.dart';
import 'package:spendsmart/features/budget/presentation/providers/budget_provider.dart';
import 'package:spendsmart/features/budget/presentation/widgets/amount_input_dialog.dart';
import 'package:spendsmart/features/budget/presentation/widgets/budget_status_widgets.dart';
import 'package:spendsmart/features/category/data/models/category_model.dart';
import 'package:spendsmart/features/category/presentation/providers/category_provider.dart';

class BudgetScreen extends ConsumerStatefulWidget {
  const BudgetScreen({super.key});

  @override
  ConsumerState<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends ConsumerState<BudgetScreen> {
  late int _month;
  late int _year;

  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = now.month;
    _year = now.year;
    Future.microtask(_load);
  }

  Future<void> _load() async {
    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null) return;
    await ref
        .read(budgetProvider.notifier)
        .fetchBudget(token, month: _month, year: _year);
    await ref.read(categoryProvider.notifier).fetchCategories(token);
  }

  Future<void> _setMonth(int month, int year) async {
    setState(() {
      _month = month;
      _year = year;
    });
    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null) return;
    await ref
        .read(budgetProvider.notifier)
        .fetchBudget(token, month: month, year: year);
  }

  void _shiftMonth(int delta) {
    var year = _year;
    var month = _month + delta;
    if (month < 1) {
      month = 12;
      year -= 1;
    } else if (month > 12) {
      month = 1;
      year += 1;
    }
    _setMonth(month, year);
  }

  @override
  Widget build(BuildContext context) {
    final budgetAsync = ref.watch(budgetProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFEEF0FB),
      appBar: const AppTopBar(title: 'Budget'),
      body: SafeArea(
        child: Column(
          children: [
            _buildMonthSwitcher(),
            Expanded(
              child: budgetAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => _buildError(e),
                data: (status) => _buildContent(status),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(Object e) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.black38),
            const SizedBox(height: 12),
            Text(
              'Unable to load budget',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final token =
                    await ref.read(storageServiceProvider).getToken();
                if (token != null) {
                  await ref
                      .read(budgetProvider.notifier)
                      .fetchBudget(token, month: _month, year: _year);
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSwitcher() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _shiftMonth(-1),
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            '${_months[_month - 1]} $_year',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: () => _shiftMonth(1),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BudgetStatus? status) {
    if (status == null) {
      return _buildEmptyState();
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBudgetSummaryCard(status),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'CATEGORY BUDGETS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black54,
                letterSpacing: 0.8,
              ),
            ),
            TextButton.icon(
              onPressed: () => _addCategoryBudget(status),
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        if (status.categories.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'No category budgets set yet.\nTap Add to manage a category limit.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
            ),
          )
        else
          ...status.categories
              .map((c) => _buildCategoryCard(status, c))
              .toList(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.savings_outlined,
              size: 56,
              color: Colors.black26,
            ),
            const SizedBox(height: 16),
            const Text(
              'No budget set for this month',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create a monthly budget to track your spending.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _setTotalBudget(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D5BFF),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Set Budget',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetSummaryCard(BudgetStatus status) {
    final symbol = CurrencyUtil.symbolFor(ref.watch(currencyProvider));
    final statusColor = budgetStatusColor(status.status);
    final progress = status.usagePercentage.clamp(0, 100) / 100;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
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
              const Text(
                'MONTHLY BUDGET',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                  letterSpacing: 0.8,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            CurrencyUtil.format(status.totalAmount, statusBudgetCurrency()),
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation(statusColor),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat('Spent', status.totalSpent, symbol),
              _buildStat('Remaining', status.remaining, symbol),
              _buildStat(
                'Usage',
                '${status.usagePercentage}%',
                null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _setTotalBudget(status),
                  child: const Text('Edit Budget'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _deleteBudget(status),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFE53935),
                  ),
                  child: const Text('Delete'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String statusBudgetCurrency() {
    return ref.watch(currencyProvider);
  }

  Widget _buildStat(String label, String value, String? symbol) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value.contains('%') || symbol == null
              ? value
              : '$symbol$value',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black45),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(BudgetStatus status, BudgetCategoryModel cat) {
    final color = budgetHexToColor(cat.color);
    final icon = budgetResolveIcon(cat.icon);
    final statusColor = budgetStatusColor(cat.status);
    final progress = cat.usagePercentage.clamp(0, 100) / 100;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: color.withOpacity(0.15),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${CurrencyUtil.format(cat.spent, statusBudgetCurrency())} spent of ${CurrencyUtil.format(cat.limit, statusBudgetCurrency())}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined,
                        color: Colors.black45, size: 20),
                    onPressed: () => _editCategoryLimit(status, cat),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.black45, size: 20),
                    onPressed: () => _removeCategoryLimit(status, cat),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation(statusColor),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${CurrencyUtil.format(cat.remaining, statusBudgetCurrency())} left',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
              Text(
                '${cat.usagePercentage}%',
                style: const TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _setTotalBudget([BudgetStatus? existing]) async {
    final value = await showAmountInputDialog(
      context,
      ref,
      title: existing == null ? 'Set Monthly Budget' : 'Edit Monthly Budget',
      confirmLabel: 'Save',
      initialValue: existing != null
          ? double.tryParse(existing.totalAmount)
          : null,
      helperText: 'Set an overall spending limit for $_month/$_year.',
    );
    if (value == null) return;
    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null) return;
    if (existing == null) {
      await ref.read(budgetProvider.notifier).createOrUpdateBudget(
            token,
            month: _month,
            year: _year,
            totalAmount: value,
          );
    } else {
      await ref.read(budgetProvider.notifier).updateBudget(
            token,
            existing.id,
            totalAmount: value,
          );
    }
  }

  Future<void> _deleteBudget(BudgetStatus status) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Budget?'),
        content: const Text(
          'This removes the budget for this month, including all category limits.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete',
                style: TextStyle(color: Color(0xFFE53935))),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null) return;
    await ref
        .read(budgetProvider.notifier)
        .deleteBudget(token, status.id);
  }

  Future<void> _addCategoryBudget(BudgetStatus status) async {
    final categoriesAsync = ref.read(categoryProvider);
    final expenseCategories = categoriesAsync.value
            ?.where((c) => c.type == 'EXPENSE')
            .toList() ??
        [];
    final budgetedIds = status.categories.map((c) => c.categoryId).toSet();
    final available =
        expenseCategories.where((c) => !budgetedIds.contains(c.id)).toList();

    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All expense categories already have a budget limit.'),
        ),
      );
      return;
    }

    final CategoryModel? selected = await showModalBottomSheet<CategoryModel>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Choose a category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: available.length,
                itemBuilder: (ctx, i) {
                  final c = available[i];
                  final color = budgetHexToColor(c.color);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.15),
                      child: Icon(
                        budgetResolveIcon(c.icon),
                        color: color,
                        size: 22,
                      ),
                    ),
                    title: Text(c.name),
                    onTap: () => Navigator.of(ctx).pop(c),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selected == null) return;
    final limit = await showAmountInputDialog(
      context,
      ref,
      title: 'Budget for ${selected.name}',
      confirmLabel: 'Add',
      helperText: 'Set a spending limit for this category.',
    );
    if (limit == null) return;
    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null) return;
    await ref.read(budgetProvider.notifier).addCategoryLimit(
          token,
          status.id,
          categoryId: selected.id,
          limit: limit,
        );
  }

  Future<void> _editCategoryLimit(
    BudgetStatus status,
    BudgetCategoryModel cat,
  ) async {
    final limit = await showAmountInputDialog(
      context,
      ref,
      title: 'Edit ${cat.name} budget',
      confirmLabel: 'Save',
      initialValue: double.tryParse(cat.limit),
      helperText: 'Update the spending limit for this category.',
    );
    if (limit == null) return;
    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null) return;
    await ref.read(budgetProvider.notifier).updateCategoryLimit(
          token,
          status.id,
          cat.categoryId,
          limit: limit,
        );
  }

  Future<void> _removeCategoryLimit(
    BudgetStatus status,
    BudgetCategoryModel cat,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove category budget?'),
        content: Text(
          'Remove the budget limit for "${cat.name}".',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Remove',
                style: TextStyle(color: Color(0xFFE53935))),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null) return;
    await ref.read(budgetProvider.notifier).removeCategoryLimit(
          token,
          status.id,
          cat.categoryId,
        );
  }
}
