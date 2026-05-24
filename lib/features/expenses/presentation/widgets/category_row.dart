import 'package:flutter/material.dart';
import 'package:spendsmart/core/constants/app_colors.dart';

class CategoryRow extends StatelessWidget {
  final String category;

  const CategoryRow({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius:
                    BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.category_outlined,
                size: 16,
                color: AppColors.primary,
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

        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius:
                BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                Icons.fastfood_outlined,
                size: 14,
                color: Colors.blue.shade600,
              ),

              const SizedBox(width: 4),

              const Text(
                'Food?',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}