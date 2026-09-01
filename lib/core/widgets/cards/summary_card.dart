import 'package:flutter/material.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/features/home/domain/entities/summary_item.dart';

class SummaryCard extends StatelessWidget {
  final SummaryItem item;

  const SummaryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 3),
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
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.iconBg,
                  ),
                  child: Icon(item.icon, color: item.iconColor),
                ),
                const SizedBox(width: 8),
                Text(
                  item.title,
                  style: AppTextStyles.body.copyWith(
                    color: item.titleColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              item.amount,
              style: AppTextStyles.body.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
