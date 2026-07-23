import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/widgets/buttons/primary_button.dart';
import 'package:spendsmart/core/widgets/navigation/apptopbar.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
import 'package:spendsmart/features/category/presentation/providers/category_provider.dart';

class AddCategoryScreen extends ConsumerStatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  ConsumerState<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends ConsumerState<AddCategoryScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedIconName = "shopping_cart";
  Color _selectedColor = Colors.blue;

  final Map<String, IconData> _icons = {
    "shopping_cart": Icons.shopping_cart,
    "directions_car": Icons.directions_car,
    "restaurant": Icons.restaurant,
    "home": Icons.home,
    "local_gas_station": Icons.local_gas_station,
    "flight": Icons.flight,
    "medical_services": Icons.medical_services,
    "fitness_center": Icons.fitness_center,
    "school": Icons.school,
    "pets": Icons.pets,
    "desk": Icons.desk,
    "monitor": Icons.monitor,
    "keyboard": Icons.keyboard,
    "store": Icons.store,
    "work": Icons.work,
  };

  final List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    const Color(0xFF8B6914),
    const Color(0xFF2E3A59),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null) return;

    await ref
        .read(categoryProvider.notifier)
        .createCategory(
          token,
          name: _nameController.text.trim(),
          icon: _selectedIconName,
          color: _colorToHex(_selectedColor),
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category created successfully")),
      );
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(categoryProvider).isLoading;
    return Scaffold(
      backgroundColor: const Color(0xFFEEF0FB),
      appBar: AppTopBar(
        title: 'Create Category',
        useCloseIcon: true,
        onLeading: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPreviewCard(),
              const SizedBox(height: 20),
              _buildLabel('CATEGORY NAME'),
              const SizedBox(height: 8),
              _buildNameField(),
              const SizedBox(height: 20),
              _buildLabel('SELECT ICON'),
              const SizedBox(height: 8),
              _buildIconGrid(),
              const SizedBox(height: 20),
              _buildLabel('SELECT COLOR'),
              const SizedBox(height: 12),
              _buildColorRow(),
              const SizedBox(height: 28),
              PrimaryButton(
                onPressed: isSaving ? () {} : _save,
                label: "Save Category",
                leadingIcon: const Icon(Icons.check_circle_outline),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                onPressed: () => context.pop(),
                label: 'Cancel',
                btnColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(_icons[_selectedIconName], size: 48, color: _selectedColor),
          const SizedBox(height: 12),
          Text(
            _nameController.text.isEmpty
                ? 'New Category'
                : _nameController.text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.black54,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      validator: (v) =>
          v == null || v.trim().isEmpty ? "Category name is required" : null,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'e.g., Groceries, Transport',
        hintStyle: const TextStyle(color: Colors.black38),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDE0EF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDE0EF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildIconGrid() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.count(
        crossAxisCount: 5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: _icons.entries
            .map((e) => _buildIconCell(e.key, e.value))
            .toList(),
      ),
    );
  }

  Widget _buildIconCell(String iconName, IconData icon) {
    final isSelected = _selectedIconName == iconName;
    return GestureDetector(
      onTap: () => setState(() => _selectedIconName = iconName),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? _selectedColor.withOpacity(0.15)
              : const Color(0xFFF5F6FA),
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: _selectedColor, width: 1.5)
              : null,
        ),
        child: Icon(
          icon,
          size: 24,
          color: isSelected ? _selectedColor : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildColorRow() {
    return Row(children: _colors.map(_buildColorCircle).toList());
  }

  Widget _buildColorCircle(Color color) {
    final isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        width: 52,
        height: 52,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}
