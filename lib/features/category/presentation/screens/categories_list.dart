import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/widgets/navigation/apptopbar.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
import 'package:spendsmart/features/category/data/models/category_model.dart';
import 'package:spendsmart/features/category/presentation/providers/category_provider.dart';
import 'package:spendsmart/features/category/presentation/screens/add_category_screen.dart';

final Map<String, IconData> _categoryIcons = {
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

Color _hexToColor(String hex) {
  final h = hex.replaceFirst('#', '');
  return Color(int.parse(h.length == 6 ? 'FF$h' : h, radix: 16));
}

IconData _resolveIcon(String iconName) {
  return _categoryIcons[iconName] ?? Icons.category;
}

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final token = await ref.read(storageServiceProvider).getToken();
      if (token == null) return;
      ref.read(categoryProvider.notifier).fetchCategories(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFEEF0FB),
      appBar: const AppTopBar(title: 'Categories'),
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (categories) {
          final custom =
              categories.where((c) => !c.isDefault).toList();
          final defaults =
              categories.where((c) => c.isDefault).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (custom.isNotEmpty) ...[
                  _buildSectionLabel('CUSTOM CATEGORIES'),
                  const SizedBox(height: 8),
                  ...custom.map((c) => _buildCustomCard(c)),
                  const SizedBox(height: 20),
                ],
                if (defaults.isNotEmpty) ...[
                  _buildSectionLabel('DEFAULT CATEGORIES'),
                  const SizedBox(height: 8),
                  ...defaults.map((c) => _buildDefaultCard(c)),
                ],
                if (categories.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(
                      child: Text(
                        'No categories yet.\nTap + to create one.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black45, fontSize: 15),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildSectionLabel(String text) {
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

  Widget _buildCustomCard(CategoryModel item) {
    final icon = _resolveIcon(item.icon);
    final color = _hexToColor(item.color);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildIconCircle(icon, color, false),
          const SizedBox(width: 14),
          Expanded(child: _buildNameAndCount(item)),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black45, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black45, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultCard(CategoryModel item) {
    final icon = _resolveIcon(item.icon);
    final color = _hexToColor(item.color);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildIconCircle(icon, color, true),
          const SizedBox(width: 14),
          Expanded(child: _buildNameAndCount(item)),
          _buildDefaultBadge(),
        ],
      ),
    );
  }

  Widget _buildIconCircle(IconData icon, Color color, bool isDefault) {
    return CircleAvatar(
      radius: 26,
      backgroundColor: isDefault ? color.withOpacity(0.15) : color,
      child: Icon(
        icon,
        color: isDefault ? color : Colors.white,
        size: 22,
      ),
    );
  }

  Widget _buildNameAndCount(CategoryModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        const Text(
          '0 transactions',
          style: TextStyle(fontSize: 13, color: Colors.black45),
        ),
      ],
    );
  }

  Widget _buildDefaultBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Default',
        style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AddCategoryScreen()),
      ),
      backgroundColor: Colors.blue,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
