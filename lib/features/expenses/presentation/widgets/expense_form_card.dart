import 'package:flutter/material.dart';
import 'package:spendsmart/features/expenses/models/expense_form_data.dart';
import 'package:spendsmart/features/expenses/presentation/widgets/category_row.dart';
import 'package:spendsmart/features/expenses/presentation/widgets/field_label.dart';
import 'package:spendsmart/features/expenses/presentation/widgets/icon_text_row.dart';

class ExpenseFormCard extends StatelessWidget {
  final ExpenseFormData formData;
  final VoidCallback? onCategoryTap;
  final VoidCallback? onDateTap;
  final VoidCallback? onMethodTap;
  final ValueChanged<String>? onNoteChanged;
  final ValueChanged<String>? onTitleChanged;
  final String? predictedCategoryName;
  final IconData? predictedCategoryIcon;
  final Color? predictedCategoryColor;
  final bool isPredicting;

  const ExpenseFormCard({
    super.key,
    required this.formData,
    this.onCategoryTap,
    this.onDateTap,
    this.onMethodTap,
    this.onNoteChanged,
    this.onTitleChanged,
    this.predictedCategoryName,
    this.predictedCategoryIcon,
    this.predictedCategoryColor,
    this.isPredicting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel(label: 'CATEGORY'),
          const SizedBox(height: 8),
          CategoryRow(
            category: formData.category,
            categoryIcon: formData.categoryId != null ? 'category' : null,
            categoryColor: Colors.blue,
            onTap: onCategoryTap,
            predictedCategoryName: predictedCategoryName,
            predictedCategoryIcon: predictedCategoryIcon,
            predictedCategoryColor: predictedCategoryColor,
            isPredicting: isPredicting,
          ),
          const Divider(height: 24),
          const FieldLabel(label: 'TITLE'),
          const SizedBox(height: 8),
          TextField(
            onChanged: onTitleChanged,
            decoration: const InputDecoration(
              hintText: 'What did you spend on?',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              isDense: true,
            ),
            style: const TextStyle(fontSize: 14),
          ),
          const Divider(height: 24),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldLabel(label: 'DATE'),
                      const SizedBox(height: 6),
                      IconTextRow(
                        icon: Icons.calendar_today_outlined,
                        text: formData.date,
                        onTap: onDateTap,
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(
                  thickness: 1,
                  width: 20,
                  color: Colors.grey,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const FieldLabel(label: 'METHOD'),
                      const SizedBox(height: 6),
                      IconTextRow(
                        icon: Icons.credit_card_outlined,
                        text: formData.paymentMethod,
                        onTap: onMethodTap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 24),
          const FieldLabel(label: 'NOTE'),
          const SizedBox(height: 6),
          TextField(
            onChanged: onNoteChanged,
            decoration: const InputDecoration(
              hintText: 'What was this for?',
              hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            style: const TextStyle(fontSize: 13),
            maxLines: 2,
            minLines: 1,
          ),
        ],
      ),
    );
  }
}
