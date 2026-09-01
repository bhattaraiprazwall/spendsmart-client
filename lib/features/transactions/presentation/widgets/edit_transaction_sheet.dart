import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/widgets/buttons/primary_button.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/category/domain/entities/category.dart';
import 'package:spendsmart/features/category/presentation/providers/category_provider.dart';
import 'package:spendsmart/features/transactions/domain/entities/transaction.dart';
import 'package:spendsmart/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:spendsmart/features/transactions/presentation/widgets/transaction_ui.dart';

class EditTransactionSheet extends ConsumerStatefulWidget {
  final Transaction transaction;

  const EditTransactionSheet({super.key, required this.transaction});

  @override
  ConsumerState<EditTransactionSheet> createState() =>
      _EditTransactionSheetState();
}

class _EditTransactionSheetState extends ConsumerState<EditTransactionSheet> {
  static const List<String> _paymentMethods = [
    'CARD',
    'CASH',
    'ESEWA',
    'KHALTI',
    'BANK_TRANSFER',
    'OTHER',
  ];

  late final TextEditingController _amountController;
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;

  String? _paymentMethod;
  String? _categoryId;
  String? _categoryName;
  DateTime? _selectedDate;

  bool _isSaving = false;
  String? _amountError;
  String? _titleError;
  String? _categoryError;

  @override
  void initState() {
    super.initState();
    final t = widget.transaction;
    _amountController =
        TextEditingController(text: t.amount.toStringAsFixed(2));
    _titleController = TextEditingController(text: t.title);
    _noteController = TextEditingController(text: t.note ?? '');
    _paymentMethod = t.paymentMethod;
    _categoryId = t.categoryId;
    _categoryName = t.categoryName;
    _selectedDate = t.date;
    Future.microtask(() async {
      final token = await ref.read(storageServiceProvider).getToken();
      if (token == null) return;
      ref.read(categoriesProvider.notifier).fetchCategories(token, type: t.type);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final categoriesAsync = ref.watch(categoriesProvider);
            return categoriesAsync.when(
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => const SizedBox(
                height: 200,
                child: Center(child: Text('Failed to load categories')),
              ),
              data: (categories) => ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Select Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  ...categories
                      .where((cat) => cat.type == widget.transaction.type)
                      .map((cat) => _buildCategoryItem(cat, ctx)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryItem(Category cat, BuildContext ctx) {
    final color = transactionHexToColor(cat.color);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.15),
        child: Icon(transactionResolveIcon(cat.icon), color: color, size: 20),
      ),
      title: Text(cat.name),
      trailing: _categoryId == cat.id
          ? const Icon(Icons.check, color: Colors.blue)
          : null,
      onTap: () {
        setState(() {
          _categoryId = cat.id;
          _categoryName = cat.name;
          _categoryError = null;
        });
        Navigator.of(ctx).pop();
      },
    );
  }

  void _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _showMethodPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ..._paymentMethods.map(
              (method) => ListTile(
                leading: Icon(
                  method == 'CASH'
                      ? Icons.money
                      : method == 'CARD'
                      ? Icons.credit_card
                      : method == 'ESEWA'
                      ? Icons.phone_android
                      : method == 'KHALTI'
                      ? Icons.phone_iphone
                      : method == 'BANK_TRANSFER'
                      ? Icons.account_balance
                      : Icons.more_horiz,
                  color: AppColors.primary,
                ),
                title: Text(method.replaceAll('_', ' ')),
                trailing: _paymentMethod == method
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() => _paymentMethod = method);
                  Navigator.of(ctx).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSave() async {
    if (_isSaving) return;

    final amount = double.tryParse(_amountController.text);

    setState(() {
      _amountError = (amount == null || amount <= 0)
          ? 'Please enter a valid amount'
          : null;
      _titleError = _titleController.text.trim().isEmpty
          ? 'Please enter a title'
          : null;
      _categoryError = _categoryId == null ? 'Please select a category' : null;
    });

    if (amount == null ||
        amount <= 0 ||
        _titleController.text.trim().isEmpty ||
        _categoryId == null) {
      return;
    }

    setState(() => _isSaving = true);

    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null) {
      if (mounted) setState(() => _isSaving = false);
      return;
    }

    try {
      await ref
          .read(transactionProvider.notifier)
          .updateTransaction(
            token,
            widget.transaction.id,
            amount: amount,
            title: _titleController.text.trim(),
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
            paymentMethod: _paymentMethod,
            date: (_selectedDate ?? DateTime.now()).toIso8601String(),
            categoryId: _categoryId!,
          );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update transaction: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Edit Transaction',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Amount',
                errorText: _amountError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                errorText: _titleError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildFieldTile(
              icon: Icons.category_outlined,
              label: 'Category',
              value: _categoryName ?? 'Select Category',
              error: _categoryError,
              onTap: _showCategoryPicker,
            ),
            const SizedBox(height: 12),
            _buildFieldTile(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              value: formatTransactionDate(_selectedDate ?? DateTime.now()),
              onTap: _showDatePicker,
            ),
            const SizedBox(height: 12),
            _buildFieldTile(
              icon: Icons.credit_card_outlined,
              label: 'Payment Method',
              value: (_paymentMethod ?? 'CARD').replaceAll('_', ' '),
              onTap: _showMethodPicker,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              onPressed: _handleSave,
              label: _isSaving ? 'Saving...' : 'Save Changes',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldTile({
    required IconData icon,
    required String label,
    required String value,
    String? error,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: error != null ? Colors.red : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.black45),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: error != null ? Colors.red : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}

void showEditTransactionSheet(
  BuildContext context,
  Transaction transaction, {
  required Future<void> Function() onSaved,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFFEEF0FB),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => EditTransactionSheet(transaction: transaction),
  ).then((changed) {
    if (changed == true) onSaved();
  });
}
