import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/routing/route_paths.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/widgets/buttons/primary_button.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/category/domain/entities/category.dart';
import 'package:spendsmart/features/category/presentation/providers/category_provider.dart';
import 'package:spendsmart/features/incomes/domain/entities/income_form_data.dart';
import 'package:spendsmart/features/incomes/presentation/providers/income_provider.dart';
import 'package:spendsmart/features/incomes/presentation/widgets/income_amount_display.dart';
import 'package:spendsmart/features/incomes/presentation/widgets/income_form_card.dart';

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

class AddIncomeScreen extends ConsumerStatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  ConsumerState<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends ConsumerState<AddIncomeScreen> {
  IncomeFormData formData = const IncomeFormData();
  late final TextEditingController _amountController;
  late final FocusNode _amountFocusNode;
  bool _isSaving = false;

  String? _amountError;
  String? _titleError;
  String? _categoryError;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _amountFocusNode = FocusNode();
    _amountFocusNode.requestFocus();
    Future.microtask(() async {
      final token = await ref.read(storageServiceProvider).getToken();
      if (token == null) return;
      ref.read(categoriesProvider.notifier).fetchCategories(token, type: 'INCOME');
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  void _onTitleChanged(String value) {
    setState(() {
      formData = formData.copyWith(title: value);
      _titleError = null;
    });
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Consumer(
            builder: (context, ref, _) {
              final categoriesAsync = ref.watch(categoriesProvider);
          
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
                        .where((cat) => cat.type == 'INCOME')
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
        backgroundColor: color.withOpacity(0.15),
        child: Icon(_mapCategoryIcon(cat.icon), color: color, size: 20),
      ),
      title: Text(cat.name),
      trailing: formData.categoryId == cat.id
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      onTap: () {
        final now = DateTime.now();
        setState(() {
          formData = formData.copyWith(
            category: cat.name,
            categoryId: cat.id,
            date: _formatDate(formData.selectedDate ?? now),
          );
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
          .read(incomeProvider.notifier)
          .createIncome(
            token,
            type: 'INCOME',
            amount: amount,
            title: formData.title.trim(),
            note: formData.note.isEmpty ? null : formData.note,
            date: (formData.selectedDate ?? DateTime.now()).toIso8601String(),
            categoryId: formData.categoryId!,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Income added successfully')),
      );
      context.go(RoutePaths.dashboard);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add income: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.neutral),
        centerTitle: true,
        title: const Text('Add Income', style: AppTextStyles.body),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              IncomeAmountDisplay(
                controller: _amountController,
                focusNode: _amountFocusNode,
                errorText: _amountError,
                onChanged: (value) => setState(() {
                  formData = formData.copyWith(amount: value);
                  _amountError = null;
                }),
              ),
              const SizedBox(height: 40),
              IncomeFormCard(
                formData: formData,
                onCategoryTap: _showCategoryPicker,
                onDateTap: _showDatePicker,
                titleError: _titleError,
                categoryError: _categoryError,
                onNoteChanged: (note) =>
                    setState(() => formData = formData.copyWith(note: note)),
                onTitleChanged: _onTitleChanged,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PrimaryButton(
            onPressed: _handleSave,
            label: _isSaving ? 'Saving...' : 'Save Income',
          ),
        ),
      ),
    );
  }
}
