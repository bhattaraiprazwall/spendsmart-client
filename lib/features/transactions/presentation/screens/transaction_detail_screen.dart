import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/core/utils/currency_util.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/budget/domain/entities/budget.dart';
import 'package:spendsmart/features/budget/domain/entities/budget_category.dart';
import 'package:spendsmart/features/budget/presentation/providers/budget_provider.dart';
import 'package:spendsmart/features/budget/presentation/widgets/budget_status_widgets.dart';
import 'package:spendsmart/features/transactions/domain/entities/transaction.dart';
import 'package:spendsmart/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:spendsmart/features/transactions/presentation/widgets/edit_transaction_sheet.dart';
import 'package:spendsmart/features/transactions/presentation/widgets/transaction_ui.dart';

class TransactionDetailScreen extends ConsumerStatefulWidget {
  final Transaction transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  ConsumerState<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState
    extends ConsumerState<TransactionDetailScreen> {
  late Transaction _transaction;

  @override
  void initState() {
    super.initState();
    _transaction = widget.transaction;
    Future.microtask(() async {
      final token = await ref.read(storageServiceProvider).getToken();
      if (token == null) return;
      final now = DateTime.now();
      ref
          .read(budgetProvider.notifier)
          .fetchBudget(token, month: now.month, year: now.year);
    });
  }

  Future<void> _handleEdit() async {
    showEditTransactionSheet(
      context,
      _transaction,
      onSaved: () async {
        final updatedList = ref.read(transactionProvider).value;
        if (updatedList != null && updatedList.isNotEmpty && mounted) {
          setState(() => _transaction = updatedList.firstWhere((t) => t.id == _transaction.id, orElse: () => _transaction));
        }
      },
    );
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null) return;

    try {
      await ref
          .read(transactionProvider.notifier)
          .deleteTransaction(token, _transaction.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction deleted')),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete transaction: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);
    final budgetAsync = ref.watch(budgetProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFEEF0FB),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAmountCard(currency),
            const SizedBox(height: 12),
            _buildDetailsCard(),
            const SizedBox(height: 12),
            _buildBudgetCard(budgetAsync, currency),
            const SizedBox(height: 24),
            _buildEditButton(),
            const SizedBox(height: 8),
            _buildDeleteButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFEEF0FB),
      elevation: 0,
      leading: const BackButton(color: Colors.black),
      title: const Text(
        'Transaction Details',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildAmountCard(String currency) {
    final color = _transaction.isIncome ? Colors.green : Colors.red;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildCategoryIcon(),
          const SizedBox(height: 16),
          Text(
            CurrencyUtil.format(_transaction.amount, currency),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _transaction.title,
            style: const TextStyle(fontSize: 14, color: Colors.black45),
          ),
          const SizedBox(height: 12),
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon() {
    final color = transactionHexToColor(_transaction.categoryColor);
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(transactionResolveIcon(_transaction.categoryIcon), color: color, size: 26),
    );
  }

  Widget _buildStatusBadge() {
    final isIncome = _transaction.isIncome;
    final color = isIncome ? Colors.green : Colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: color, size: 8),
          const SizedBox(width: 6),
          Text(
            isIncome ? 'Income' : 'Expense',
            style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.category_outlined, 'Category', _transaction.categoryName),
          _buildDivider(),
          _buildDetailRow(Icons.calendar_today_outlined, 'Date', formatTransactionDate(_transaction.date)),
          _buildDivider(),
          _buildDetailRow(Icons.access_time_outlined, 'Time', formatTransactionTime(_transaction.date)),
          _buildDivider(),
          _buildDetailRow(Icons.credit_card_outlined, 'Payment Method', _transaction.paymentMethod.replaceAll('_', ' ')),
          if (_transaction.note != null && _transaction.note!.isNotEmpty) ...[
            _buildDivider(),
            _buildNoteRow(_transaction.note!),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black45),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 14)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildNoteRow(String note) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.notes_outlined, size: 18, color: Colors.black45),
              SizedBox(width: 10),
              Text('Note', style: TextStyle(color: Colors.black54, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              note,
              style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Color(0xFFF2F3F7));
  }

  Widget _buildBudgetCard(AsyncValue<BudgetStatus?> budgetAsync, String currency) {
    if (_transaction.isIncome) {
      return const SizedBox.shrink();
    }

    return budgetAsync.when(
      loading: () => _budgetContainer(
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, _) => _budgetContainer(
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text('Could not load budget', style: TextStyle(color: Colors.black45))),
        ),
      ),
      data: (status) {
        if (status == null) {
          return _budgetContainer(
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No budget set for this month',
                  style: TextStyle(color: Colors.black45, fontSize: 13),
                ),
              ),
            ),
          );
        }

        final cat = status.categories.where(
          (c) => c.categoryId == _transaction.categoryId,
        ).firstOrNull;
        if (cat == null) {
          return _budgetContainer(
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No budget limit for this category',
                  style: TextStyle(color: Colors.black45, fontSize: 13),
                ),
              ),
            ),
          );
        }

        return _buildBudgetProgress(cat, currency);
      },
    );
  }

  Widget _budgetContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildBudgetProgress(BudgetCategory cat, String currency) {
    final color = budgetStatusColor(cat.status);
    final percent = (cat.usagePercentage / 100).clamp(0.0, 1.0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${cat.name} Budget',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              Icon(budgetResolveIcon(cat.icon), color: color, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent: ${CurrencyUtil.format(cat.spent, currency)}',
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
              Text(
                'Total: ${CurrencyUtil.format(cat.limit, currency)}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${cat.usagePercentage}% Used',
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _handleEdit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
        label: const Text(
          'Edit Transaction',
          style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return TextButton.icon(
      onPressed: _handleDelete,
      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
      label: const Text('Delete Transaction', style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600)),
    );
  }
}
