import 'package:flutter/material.dart';
import 'package:spendsmart/core/constants/app_colors.dart';

class CategoryRow extends StatelessWidget {
  final String category;
  final String? categoryIcon;
  final Color? categoryColor;
  final VoidCallback? onTap;
  final String? predictedCategoryName;
  final IconData? predictedCategoryIcon;
  final Color? predictedCategoryColor;
  final bool isPredicting;

  const CategoryRow({
    super.key,
    required this.category,
    this.categoryIcon,
    this.categoryColor,
    this.onTap,
    this.predictedCategoryName,
    this.predictedCategoryIcon,
    this.predictedCategoryColor,
    this.isPredicting = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (categoryColor ?? Colors.blue).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  categoryIcon != null
                      ? _mapIcon(categoryIcon!)
                      : Icons.category_outlined,
                  size: 16,
                  color: categoryColor ?? AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                category,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (isPredicting)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else if (predictedCategoryName != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: (predictedCategoryColor ?? Colors.blue).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    predictedCategoryIcon ?? Icons.category,
                    size: 14,
                    color: predictedCategoryColor ?? Colors.blue.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    predictedCategoryName!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: predictedCategoryColor ?? Colors.blue.shade600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  IconData _mapIcon(String iconName) {
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
}
