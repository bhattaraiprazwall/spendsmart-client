import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/widgets/buttons/primary_button.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
import 'package:spendsmart/features/category/data/models/category_model.dart';
import 'package:spendsmart/features/category/presentation/providers/category_provider.dart';
import 'package:spendsmart/features/expenses/models/expense_form_data.dart';
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
  String? _predictedCategoryName;
  IconData? _predictedCategoryIcon;
  Color? _predictedCategoryColor;
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
      ref.read(categoryProvider.notifier).fetchCategories(token, type: 'EXPENSE');
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
        _predictedCategoryName = null;
        _isPredicting = false;
      });
      return;
    }
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _predictCategory(value.trim());
    });
  }

  Future<void> _predictCategory(String title) async {
    setState(() => _isPredicting = true);
    try {
      final token = await ref.read(storageServiceProvider).getToken();
      if (token == null) return;
      final response = await http.get(
        Uri.parse('${ApiConstants.categories}/predict?title=$title&type=EXPENSE'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (!mounted) return;
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final data = body["data"] as Map<String, dynamic>?;
        final predicted = data?["predictedCategory"] as Map<String, dynamic>?;
        if (predicted != null) {
          setState(() {
            _predictedCategoryName = predicted["name"] as String?;
            _predictedCategoryIcon = _mapCategoryIcon(
              predicted["icon"] as String? ?? "",
            );
            _predictedCategoryColor = _hexToColor(
              predicted["color"] as String? ?? "#3D5CFF",
            );
            _isPredicting = false;
          });
        } else {
          setState(() {
            _predictedCategoryName = null;
            _isPredicting = false;
          });
        }
      } else {
        if (mounted) setState(() => _isPredicting = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isPredicting = false);
    }
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Consumer(
          // ← gives access to ref INSIDE the modal
          builder: (context, ref, _) {
            final categoriesAsync = ref.watch(
              categoryProvider,
            ); // ← watch, not read

            return categoriesAsync.when(
              loading: () => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SizedBox(
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
                      .where((cat) => cat.type == 'EXPENSE')
                      .map((cat) => _buildCategoryItem(cat, ctx)),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryItem(CategoryModel cat, BuildContext ctx) {
    final color = _hexToColor(cat.color);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.15),
        child: Icon(_mapCategoryIcon(cat.icon), color: color, size: 20),
      ),
      title: Text(cat.name),
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
          _predictedCategoryName = null;
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
        );
      },
    );
  }

  Future<void> _handleSave() async {
    if (_isSaving) return;

    final amount = double.tryParse(formData.amount);

    setState(() {
      _amountError = (amount == null || amount <= 0)
          ? 'Please enter a valid amount'
          : null;
      _titleError = formData.title.trim().isEmpty
          ? 'Please enter a title'
          : null;
      _categoryError = formData.categoryId == null
          ? 'Please select a category'
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

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully')),
      );
      context.go(RoutePaths.dashboard);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add expense: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.neutral),
        centerTitle: true,
        title: const Text('Add Expense', style: AppTextStyles.body),
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
                predictedCategoryName: _predictedCategoryName,
                predictedCategoryIcon: _predictedCategoryIcon,
                predictedCategoryColor: _predictedCategoryColor,
                isPredicting: _isPredicting,
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
            label: _isSaving ? 'Saving...' : 'Save Expense',
          ),
        ),
      ),
    );
  }
}
