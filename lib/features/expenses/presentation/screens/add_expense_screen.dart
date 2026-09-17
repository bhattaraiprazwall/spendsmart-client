import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/core/services/api_service.dart';
import 'package:spendsmart/core/services/connectivity_service.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/widgets/buttons/primary_button.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';
import 'package:spendsmart/features/category/domain/entities/category.dart';
import 'package:spendsmart/features/category/presentation/providers/category_provider.dart';
import 'package:spendsmart/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:spendsmart/features/expenses/domain/entities/expense_form_data.dart';
import 'package:spendsmart/features/expenses/presentation/providers/expense_provider.dart';
import 'package:spendsmart/features/expenses/presentation/widgets/amount_display.dart';
import 'package:spendsmart/features/expenses/presentation/widgets/expense_form_card.dart';

IconData _mapCategoryIcon(String iconName) {
  const iconMap = {
    "shopping_cart": Icons.shopping_cart,
    "directions_car": Icons.directions_car,
    "restaurant": Icons.restaurant,
    "home": Icons.home,
    "local_gas_station": Icons.local_gas_station,
    "flight": Icons.flight,
    "medical_services": Icons.medical_services,
    "checkroom": Icons.checkroom,
    "video_library": Icons.video_library,
    "more_horiz": Icons.more_horiz,
    "pets": Icons.pets,
    "fitness_center": Icons.fitness_center,
    "school": Icons.school,
    "desk": Icons.desk,
    "monitor": Icons.monitor,
    "keyboard": Icons.keyboard,
    "store": Icons.store,
    "work": Icons.work,
    "category": Icons.category,
  };
  return iconMap[iconName] ?? Icons.category;
}

Color _hexToColor(String hex) {
  final h = hex.replaceFirst('#', '');
  return Color(int.parse(h.length == 6 ? 'FF$h' : h, radix: 16));
}

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  ExpenseFormData formData = const ExpenseFormData();
  late final TextEditingController _amountController;
  late final FocusNode _amountFocusNode;
  bool _isSaving = false;
  Category? _suggestionCategory;
  String? _suggestionConfidenceLabel;
  String? _suggestionAlternative;
  bool _showSuggestion = false;
  bool _isPredicting = false;
  Timer? _debounceTimer;

  //Amount error initialization
  String? _amountError;
  String? _titleError;
  String? _categoryError;

  static const List<String> _paymentMethods = [
    'CARD',
    'CASH',
    'ESEWA',
    'KHALTI',
    'BANK_TRANSFER',
    'OTHER',
  ];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _amountFocusNode = FocusNode();
    _amountFocusNode.requestFocus();
    Future.microtask(() async {
      final token = await ref.read(storageServiceProvider).getToken();
      if (token == null) return;
      ref
          .read(categoriesProvider.notifier)
          .fetchCategories(token, type: 'EXPENSE');
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _onTitleChanged(String value) {
    setState(() {
      formData = formData.copyWith(title: value);
      _titleError = null;
    });
    _debounceTimer?.cancel();
    if (value.trim().isEmpty) {
      setState(() {
        _suggestionCategory = null;
        _showSuggestion = false;
        _isPredicting = false;
      });
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _predictCategory(value.trim());
    });
  }

  Future<void> _predictCategory(String title) async {
    if (ConnectivityService().isOffline) {
      final categories = ref.read(categoriesProvider).value ?? [];
      final lowerTitle = title.toLowerCase();
      Category? matched;
      for (final cat in categories) {
        if (cat.type == 'EXPENSE' &&
            lowerTitle.contains(cat.name.toLowerCase())) {
          matched = cat;
          break;
        }
      }
      if (mounted) {
        setState(() {
          _suggestionCategory = matched;
          _suggestionConfidenceLabel = matched != null ? 'Local Match' : null;
          _suggestionAlternative = null;
          _showSuggestion = matched != null;
          _isPredicting = false;
        });
      }
      return;
    }

    setState(() => _isPredicting = true);
    try {
      final token = await ref.read(storageServiceProvider).getToken();
      if (token == null) return;
      final response = await ApiService().post(
        ApiConstants.categoryPrediction,
        {"title": title},
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (!mounted) return;
      if (response["statusCode"] == 200) {
        final body = response["data"] as Map<String, dynamic>;
        final data = body["data"] as Map<String, dynamic>?;
        final shouldSuggest = data?["shouldSuggest"] as bool? ?? false;
        final categoryData = data?["category"] as Map<String, dynamic>?;
        final confidenceLabel = data?["confidenceLevel"] as String?;
        final alternative = data?["alternative"] as Map<String, dynamic>?;

        Category? matched;
        if (categoryData != null) {
          matched = Category(
            id: categoryData["id"] as String? ?? "",
            name: categoryData["name"] as String? ?? "",
            icon: categoryData["icon"] as String? ?? "",
            color: categoryData["color"] as String? ?? "",
            isDefault: categoryData["isDefault"] as bool? ?? false,
            canonicalKey: categoryData["canonicalKey"] as String?,
            type: "EXPENSE",
          );
        }

        setState(() {
          _suggestionCategory = matched;
          _suggestionConfidenceLabel = confidenceLabel;
          _suggestionAlternative = alternative?["category"] as String?;
          _showSuggestion = (matched != null && shouldSuggest);
          _isPredicting = false;
        });
      } else {
        if (mounted) setState(() => _isPredicting = false);
      }
    } catch (e) {
      debugPrint('Category prediction error: $e');
      if (mounted) setState(() => _isPredicting = false);
    }
  }

  void _selectSuggestion(Category category) {
    setState(() {
      formData = formData.copyWith(
        category: category.name,
        categoryId: category.id,
      );
      _suggestionCategory = null;
      _showSuggestion = false;
      _categoryError = null;
    });
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Consumer(
            // ← gives access to ref INSIDE the modal
            builder: (context, ref, _) {
              final categoriesAsync = ref.watch(
                categoriesProvider,
              ); // ← watch, not read

              return categoriesAsync.when(
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(ctx.tr('failed_to_load_categories')),
                  ),
                ),
                data: (categories) => ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      ctx.tr('select_category'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ctx.colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...categories
                        .where((cat) => cat.type == 'EXPENSE')
                        .map((cat) => _buildCategoryItem(cat, ctx)),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryItem(Category cat, BuildContext ctx) {
    final color = _hexToColor(cat.color);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.15),
        child: Icon(_mapCategoryIcon(cat.icon), color: color, size: 20),
      ),
      title: Text(cat.name, style: TextStyle(color: ctx.colors.textPrimary)),
      trailing: formData.categoryId == cat.id
          ? const Icon(Icons.check, color: Colors.blue)
          : null,
      onTap: () {
        final now = DateTime.now();
        setState(() {
          formData = formData.copyWith(
            category: cat.name,
            categoryId: cat.id,
            date: _formatDate(formData.selectedDate ?? now),
          );
          _suggestionCategory = null;
          _showSuggestion = false;
          _categoryError = null;
        });
        Navigator.of(ctx).pop();
      },
    );
  }

  void _showDatePicker() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: formData.selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        formData = formData.copyWith(
          selectedDate: picked,
          date: _formatDate(picked),
        );
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showMethodPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                ctx.tr('select_payment_method'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ctx.colors.textPrimary,
                ),
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
                  title: Text(
                    method.replaceAll('_', ' '),
                    style: TextStyle(color: ctx.colors.textPrimary),
                  ),
                  trailing: formData.paymentMethod == method
                      ? const Icon(Icons.check, color: Colors.blue)
                      : null,
                  onTap: () {
                    setState(() {
                      formData = formData.copyWith(paymentMethod: method);
                    });
                    Navigator.of(ctx).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleSave() async {
    if (_isSaving) return;

    final amount = double.tryParse(formData.amount);

    setState(() {
      _amountError = (amount == null || amount <= 0)
          ? context.tr('valid_amount_error')
          : null;
      _titleError = formData.title.trim().isEmpty
          ? context.tr('title_required_error')
          : null;
      _categoryError = formData.categoryId == null
          ? context.tr('category_required_error')
          : null;
    });

    if (amount == null ||
        amount <= 0 ||
        formData.title.trim().isEmpty ||
        formData.categoryId == null) {
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
          .read(expenseProvider.notifier)
          .createExpense(
            token,
            type: 'EXPENSE',
            amount: amount,
            title: formData.title.trim(),
            note: formData.note.isEmpty ? null : formData.note,
            paymentMethod: formData.paymentMethod,
            date: (formData.selectedDate ?? DateTime.now()).toIso8601String(),
            categoryId: formData.categoryId!,
          );

      final alert = ExpenseRemoteDataSource.latestAlertNotifier.value;
      ExpenseRemoteDataSource.latestAlertNotifier.value = null;

      if (!mounted) return;

      if (alert != null) {
        final isExceeded = alert.type == 'BUDGET_EXCEEDED';
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(
                  isExceeded
                      ? Icons.error_rounded
                      : Icons.warning_amber_rounded,
                  color: isExceeded ? Colors.red : Colors.orange,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  isExceeded ? 'Budget Exceeded!' : 'Budget Warning',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            content: Text(
              isExceeded
                  ? 'You have exceeded 100% of this category\'s monthly budget!\n\nSpent: \$${alert.spent.toStringAsFixed(2)} / Limit: \$${alert.limit.toStringAsFixed(2)}'
                  : 'You have reached ${alert.usagePercent.toStringAsFixed(0)}% of this category\'s monthly budget.\n\nSpent: \$${alert.spent.toStringAsFixed(2)} / Limit: \$${alert.limit.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text(
                  'OK',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.tr('expense_added'))));
      }

      if (mounted) {
        context.go(RoutePaths.dashboard);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${context.tr('failed_to_add_expense')}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(categoriesProvider);
    final c = context.colors;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: c.textPrimary),
        centerTitle: true,
        title: Text(context.tr('add_expense'), style: AppTextStyles.body),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AmountDisplay(
                controller: _amountController,
                focusNode: _amountFocusNode,
                errorText: _amountError,
                onChanged: (value) => setState(() {
                  formData = formData.copyWith(amount: value);
                  _amountError = null;
                }),
              ),
              const SizedBox(height: 40),
              ExpenseFormCard(
                formData: formData,
                onCategoryTap: _showCategoryPicker,
                onDateTap: _showDatePicker,
                onMethodTap: _showMethodPicker,
                titleError: _titleError,
                categoryError: _categoryError,
                onNoteChanged: (note) =>
                    setState(() => formData = formData.copyWith(note: note)),
                onTitleChanged: _onTitleChanged,
                suggestionCategory: _suggestionCategory,
                suggestionConfidenceLabel: _suggestionConfidenceLabel,
                suggestionAlternative: _suggestionAlternative,
                showSuggestion: _showSuggestion,
                isPredicting: _isPredicting,
                onSuggestionTap: _suggestionCategory == null
                    ? null
                    : () => _selectSuggestion(_suggestionCategory!),
              ),
              const SizedBox(height: 40),

              // Expanded(child: ExpenseNumpad(onKeyTap: _handleKeyTap)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PrimaryButton(
            onPressed: _handleSave,
            label: _isSaving
                ? context.tr('saving')
                : context.tr('save_expense'),
          ),
        ),
      ),
    );
  }
}
