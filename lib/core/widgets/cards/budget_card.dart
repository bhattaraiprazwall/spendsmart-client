import 'package:flutter/material.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/features/home/models/budget_item.dart';

class BudgetCard extends StatelessWidget {
  final BudgetItem item;

  const BudgetCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: item.iconColor.withOpacity(0.1),
                ),
                child: Icon(
                  item.icon,
                  color: item.iconColor,
                ),
              ),

              const SizedBox(width: 8),

              Text(
                item.amount,
                style: AppTextStyles.body.copyWith(
                  color: item.iconColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const Spacer(),

          Text(
            item.label,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: item.progress,
              minHeight: 6,
              color: item.color,
            ),
          ),
        ],
      ),
    );
  }
}