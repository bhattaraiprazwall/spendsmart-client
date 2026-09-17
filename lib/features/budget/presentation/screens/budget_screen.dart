import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';
import 'package:spendsmart/core/utils/currency_util.dart';
import 'package:spendsmart/core/widgets/navigation/apptopbar.dart';
import 'package:spendsmart/features/budget/domain/entities/budget.dart';
import 'package:spendsmart/features/budget/presentation/providers/budget_provider.dart';
import 'package:spendsmart/features/budget/presentation/widgets/budget_status_widgets.dart';
import 'package:spendsmart/features/category/domain/entities/category.dart';
import 'package:spendsmart/features/category/presentation/providers/category_provider.dart';

class _CategoryBudgetItem {
  final Category category;
  final TextEditingController controller;
  double spent;
  double limit;

  _CategoryBudgetItem({
    required this.category,
    required this.controller,
    required this.spent,
    required this.limit,
  });

  void dispose() {
    controller.dispose();
  }
}

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

  final TextEditingController _totalBudgetController = TextEditingController();
  final List<_CategoryBudgetItem> _categoryItems = [];
  bool _isSaving = false;

  // Tracks the last synced state to avoid wiping active user inputs on re-renders
  int? _lastSyncedMonth;
  int? _lastSyncedYear;
  String? _lastSyncedBudgetId;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = now.month;
    _year = now.year;
    Future.microtask(_load);
  }

  @override
  void dispose() {
    _totalBudgetController.dispose();
    for (final item in _categoryItems) {
      item.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null) return;
    await Future.wait([
      ref
          .read(budgetProvider.notifier)
          .fetchBudget(token, month: _month, year: _year),
      ref.read(categoriesProvider.notifier).fetchCategories(token),
    ]);
  }

  Future<void> _setMonth(int month, int year) async {
    setState(() {
      _month = month;
      _year = year;
      _lastSyncedBudgetId = null;
      _lastSyncedMonth = null;
      _lastSyncedYear = null;
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

  void _syncFromStatus(BudgetStatus? status, List<Category> allCategories) {
    // If month/year or budget ID changed, synchronize local inputs
    if (_lastSyncedMonth == _month &&
        _lastSyncedYear == _year &&
        _lastSyncedBudgetId == status?.id) {
      return;
    }

    _lastSyncedMonth = _month;
    _lastSyncedYear = _year;
    _lastSyncedBudgetId = status?.id;

    for (final item in _categoryItems) {
      item.dispose();
    }
    _categoryItems.clear();

    if (status != null) {
      final totalVal = double.tryParse(status.totalAmount) ?? 0.0;
      _totalBudgetController.text = totalVal > 0
          ? (totalVal % 1 == 0 ? totalVal.toInt().toString() : totalVal.toStringAsFixed(2))
          : '';

      for (final bc in status.categories) {
        Category cat;
        try {
          cat = allCategories.firstWhere((c) => c.id == bc.categoryId);
        } catch (_) {
          cat = Category(
            id: bc.categoryId,
            name: bc.name,
            icon: bc.icon,
            color: bc.color,
            isDefault: false,
            type: 'EXPENSE',
          );
        }
        final limitVal = double.tryParse(bc.limit) ?? 0.0;
        final spentVal = double.tryParse(bc.spent) ?? 0.0;
        final ctrl = TextEditingController(
          text: limitVal > 0
              ? (limitVal % 1 == 0 ? limitVal.toInt().toString() : limitVal.toStringAsFixed(2))
              : '',
        );

        _categoryItems.add(_CategoryBudgetItem(
          category: cat,
          controller: ctrl,
          spent: spentVal,
          limit: limitVal,
        ));
      }
    } else {
      _totalBudgetController.text = '';
    }
  }

  double get _totalMonthlyBudget =>
      double.tryParse(_totalBudgetController.text.trim()) ?? 0.0;

  double get _totalAllocated => _categoryItems.fold<double>(
        0.0,
        (sum, item) =>
            sum + (double.tryParse(item.controller.text.trim()) ?? 0.0),
      );

  double get _unallocatedRemaining => _totalMonthlyBudget - _totalAllocated;

  Future<void> _handleSave() async {
    if (_isSaving) return;

    final totalBudget = _totalMonthlyBudget;
    if (totalBudget <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('valid_amount_error')),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null) return;

    setState(() => _isSaving = true);

    try {
      final categoriesPayload = _categoryItems.map((item) {
        final limit = double.tryParse(item.controller.text.trim()) ?? 0.0;
        return {
          'categoryId': item.category.id,
          'limit': limit,
        };
      }).where((c) => (c['limit'] as double) > 0).toList();

      // Invalidate sync cache so the incoming refreshed status from the server re-syncs local inputs
      _lastSyncedBudgetId = null;

      await ref.read(budgetProvider.notifier).createOrUpdateBudget(
            token,
            month: _month,
            year: _year,
            totalAmount: totalBudget,
            categories: categoriesPayload,
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Budget saved successfully!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save budget: $e'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showAddCategoryPicker(List<Category> allCategories) async {
    final currentIds = _categoryItems.map((item) => item.category.id).toSet();
    final available = allCategories
        .where((c) => c.type == 'EXPENSE' && !currentIds.contains(c.id))
        .toList();

    if (available.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(allCategories.isEmpty
              ? context.tr('no_categories')
              : context.tr('all_categories_budgeted')),
        ),
      );
      return;
    }

    final Category? selected = await showModalBottomSheet<Category>(
      context: context,
      backgroundColor: context.colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                ctx.tr('choose_category'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
                      backgroundColor: color.withValues(alpha: 0.15),
                      child: Icon(
                        budgetResolveIcon(c.icon),
                        color: color,
                        size: 22,
                      ),
                    ),
                    title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    onTap: () => Navigator.of(ctx).pop(c),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selected == null || !mounted) return;

    setState(() {
      _categoryItems.add(_CategoryBudgetItem(
        category: selected,
        controller: TextEditingController(),
        spent: 0.0,
        limit: 0.0,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final currency = ref.watch(currencyProvider);
    final symbol = CurrencyUtil.symbolFor(currency);
    final budgetAsync = ref.watch(budgetProvider);
    final allCategories = ref.watch(categoriesProvider).value ?? [];

    return Scaffold(
      backgroundColor: c.surface,
      appBar: AppTopBar(title: 'SpendSmart'),
      body: SafeArea(
        child: budgetAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _buildErrorState(e),
          data: (status) {
            _syncFromStatus(status, allCategories);

            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final token =
                          await ref.read(storageServiceProvider).getToken();
                      if (token == null) return;
                      _lastSyncedBudgetId = null;
                      await ref.read(budgetProvider.notifier).fetchBudget(
                            token,
                            month: _month,
                            year: _year,
                          );
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: 12),
                          _buildMonthSwitcher(),
                          const SizedBox(height: 18),
                          _buildTotalBudgetCard(c, symbol),
                          const SizedBox(height: 24),
                          _buildCategoryLimitsSection(c, symbol, allCategories),
                          const SizedBox(height: 16),
                          _buildAddCategoryButton(c, allCategories),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildSaveButton(c),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Budget',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: c.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Set your limits to keep your spending smart and stress-free.',
          style: TextStyle(
            fontSize: 13,
            color: c.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthSwitcher() {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            onPressed: () => _shiftMonth(-1),
          ),
          Text(
            '${_months[_month - 1]} $_year',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: c.textPrimary,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 22),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            onPressed: () => _shiftMonth(1),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalBudgetCard(dynamic c, String symbol) {
    final total = _totalMonthlyBudget;
    final allocated = _totalAllocated;
    final remaining = _unallocatedRemaining;
    final progress = total > 0 ? (allocated / total).clamp(0.0, 1.0) : 0.0;
    final isOverAllocated = remaining < 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL MONTHLY BUDGET',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: c.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          // Large in-line input field matching mockup
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Text(
                  symbol,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _totalBudgetController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Allocated: $symbol${allocated.toStringAsFixed(allocated % 1 == 0 ? 0 : 2)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: c.textSecondary,
                ),
              ),
              Text(
                isOverAllocated
                    ? 'Exceeded: $symbol${(-remaining).toStringAsFixed(remaining % 1 == 0 ? 0 : 2)}'
                    : 'Remaining: $symbol${remaining.toStringAsFixed(remaining % 1 == 0 ? 0 : 2)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isOverAllocated
                      ? Colors.red.shade600
                      : const Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation(
                isOverAllocated ? Colors.red.shade600 : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryLimitsSection(
    dynamic c,
    String symbol,
    List<Category> allCategories,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Limits',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: c.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        if (_categoryItems.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: c.card,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'No category limits added yet. Tap below to allocate your budget to specific categories.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: c.textSecondary),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categoryItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = _categoryItems[index];
              return _buildCategoryCard(item, c, symbol);
            },
          ),
      ],
    );
  }

  Widget _buildCategoryCard(_CategoryBudgetItem item, dynamic c, String symbol) {
    final catColor = budgetHexToColor(item.category.color);
    final limit = double.tryParse(item.controller.text.trim()) ?? 0.0;
    final spent = item.spent;
    final left = limit - spent;
    final isOver = left < 0;
    final isNearLimit = limit > 0 && !isOver && (spent / limit) >= 0.8;
    final progress = limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: catColor.withValues(alpha: 0.15),
                child: Icon(
                  budgetResolveIcon(item.category.icon),
                  color: catColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item.category.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: c.textPrimary,
                  ),
                ),
              ),
              // In-line limit input box matching mockup
              Container(
                height: 38,
                width: 96,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Text(
                      symbol,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: TextField(
                        controller: item.controller,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '0',
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (val) {
                          item.limit = double.tryParse(val) ?? 0.0;
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                icon: Icon(Icons.close_rounded, size: 18, color: c.textMuted),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                onPressed: () {
                  setState(() {
                    item.dispose();
                    _categoryItems.remove(item);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent: $symbol${spent.toStringAsFixed(spent % 1 == 0 ? 0 : 2)}',
                style: TextStyle(
                  fontSize: 12,
                  color: c.textSecondary,
                ),
              ),
              if (limit > 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isOver) ...[
                      const Icon(Icons.warning_amber_rounded, size: 14, color: Colors.red),
                      const SizedBox(width: 3),
                      Text(
                        '$symbol${(-left).toStringAsFixed(left % 1 == 0 ? 0 : 2)} over',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ] else if (isNearLimit) ...[
                      const Icon(Icons.warning_amber_rounded, size: 14, color: Colors.amber),
                      const SizedBox(width: 3),
                      Text(
                        '$symbol${left.toStringAsFixed(left % 1 == 0 ? 0 : 2)} left',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.amber.shade800,
                        ),
                      ),
                    ] else ...[
                      Text(
                        '$symbol${left.toStringAsFixed(left % 1 == 0 ? 0 : 2)} left',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation(
                isOver ? Colors.red.shade600 : catColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddCategoryButton(dynamic c, List<Category> allCategories) {
    return InkWell(
      onTap: () => _showAddCategoryPicker(allCategories),
      borderRadius: BorderRadius.circular(16),
      child: CustomPaint(
        painter: _DashedRectPainter(
          color: AppColors.primary.withValues(alpha: 0.4),
          dash: 6,
          gap: 4,
          strokeWidth: 1.4,
          radius: 16,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Add Category',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(dynamic c) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: c.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: _isSaving ? null : _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          icon: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                )
              : const Icon(Icons.bookmark_added_outlined, size: 20),
          label: Text(
            _isSaving ? 'Saving...' : 'Save Budget',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(Object e) {
    final c = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: c.textMuted),
            const SizedBox(height: 12),
            Text(
              context.tr('unable_to_load_budget'),
              style: TextStyle(color: c.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _load,
              child: Text(context.tr('retry')),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dash;
  final double radius;

  _DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.2,
    this.dash = 5,
    this.gap = 3,
    this.radius = 12,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final pathMetrics = path.computeMetrics();

    for (final metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final len =
            (distance + dash > metric.length) ? metric.length - distance : dash;
        final extract = metric.extractPath(distance, distance + len);
        canvas.drawPath(extract, paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter oldDelegate) =>
      color != oldDelegate.color;
}
