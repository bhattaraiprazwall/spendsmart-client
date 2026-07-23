import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:spendsmart/core/constants/category_constants.dart';
import 'package:spendsmart/core/widgets/inputs/custom_textfield.dart';
import 'package:spendsmart/core/widgets/navigation/apptopbar.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
import 'package:spendsmart/features/category/data/models/category_model.dart';
import 'package:spendsmart/features/category/presentation/providers/category_provider.dart';

final Map<String, IconData> _icons = {
  "pets": Icons.pets,
  "shopping_cart": Icons.shopping_cart,
  "restaurant": Icons.restaurant,
  "local_gas_station": Icons.local_gas_station,
  "home": Icons.home,
  "flight": Icons.flight,
  "medical_services": Icons.medical_services,
  "checkroom": Icons.checkroom,
  "video_library": Icons.video_library,
  "more_horiz": Icons.more_horiz,
};

class EditCategoryScreen extends ConsumerStatefulWidget {
  final String categoryId;
  const EditCategoryScreen({super.key, required this.categoryId});

  @override
  ConsumerState<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends ConsumerState<EditCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryProvider);
    return categoriesAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Error: $e')),
      ),
      data: (categories) {
        final category = categories.firstWhere(
          (c) => c.id == widget.categoryId,
          orElse: () => CategoryModel(
            id: '',
            name: 'Unknown',
            icon: 'category',
            color: '#3D5CFF',
            isDefault: false,
          ),
        );
        return _EditCategoryContent(category: category);
      },
    );
  }
}

class _EditCategoryContent extends ConsumerStatefulWidget {
  final CategoryModel category;

  const _EditCategoryContent({
    required this.category,
  });

  @override
  ConsumerState<_EditCategoryContent> createState() =>
      _EditCategoryContentState();
}

class _EditCategoryContentState extends ConsumerState<_EditCategoryContent> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String _selectedIconName;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _selectedIconName = widget.category.icon;
    _selectedColor = _hexToColor(widget.category.color);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse(h.length == 6 ? 'FF$h' : h, radix: 16));
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
        .updateCategory(
          token,
          widget.category.id,
          name: _nameController.text.trim(),
          icon: _selectedIconName,
          color: _colorToHex(_selectedColor),
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: const Text('Category updated successfully'),
        ),
      );
      if (mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = ref.watch(categoryProvider).isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF0FB),
      appBar: const AppTopBar(title: 'Edit Category'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildNameCard(),
              const SizedBox(height: 12),
              _buildIconCard(),
              const SizedBox(height: 12),
              _buildColorCard(),
              const SizedBox(height: 32),
              _buildDeleteButton(),
              const SizedBox(height: 12),
              _buildUpdateButton(isSaving),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: _selectedColor,
            child: Icon(
              _icons[_selectedIconName],
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomTextField(
              controller: _nameController,
              label: 'Category Name',
              validator: (v) =>
                  v == null || v.trim().isEmpty ? "Name is required" : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Icon',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: _icons.entries
                .map((e) => _buildIconTile(e.key, e.value))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIconTile(String iconName, IconData icon) {
    final isSelected = _selectedIconName == iconName;
    return GestureDetector(
      onTap: () => setState(() => _selectedIconName = iconName),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? _selectedColor : const Color(0xFFE8EAF6),
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: _selectedColor, width: 2)
              : null,
        ),
        child: Icon(
          icon,
          size: 22,
          color: isSelected ? Colors.white : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildColorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Color',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: colors.map(_buildColorCircle).toList()),
          ),
        ],
      ),
    );
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
          border: isSelected
              ? Border.all(color: Colors.black87, width: 2.5)
              : null,
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 22)
            : null,
      ),
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFF0F0),
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        label: const Text(
          'Delete Category',
          style: TextStyle(
            color: Colors.red,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton(bool isSaving) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSaving ? null : _save,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Update Category',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
