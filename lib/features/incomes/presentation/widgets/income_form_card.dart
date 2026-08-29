import 'package:flutter/material.dart';
import 'package:spendsmart/features/expenses/presentation/widgets/category_row.dart';
import 'package:spendsmart/features/expenses/presentation/widgets/field_label.dart';
import 'package:spendsmart/features/expenses/presentation/widgets/icon_text_row.dart';
import 'package:spendsmart/features/incomes/models/income_form_data.dart';

class IncomeFormCard extends StatelessWidget {
  final IncomeFormData formData;
  final VoidCallback? onCategoryTap;
  final VoidCallback? onDateTap;
  final ValueChanged<String>? onNoteChanged;
  final ValueChanged<String>? onTitleChanged;
  final String? titleError;
  final String? categoryError;

  const IncomeFormCard({
    super.key,
    required this.formData,
    this.onCategoryTap,
    this.onDateTap,
    this.onNoteChanged,
    this.onTitleChanged,
    this.titleError,
    this.categoryError,
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
            categoryColor: Colors.green,
            onTap: onCategoryTap,
          ),
          if (categoryError != null) ...[
            const SizedBox(height: 6),
            Text(
              categoryError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
          const Divider(height: 24),
          const FieldLabel(label: 'TITLE'),
          const SizedBox(height: 8),
          TextField(
            onChanged: onTitleChanged,
            decoration: const InputDecoration(
              hintText: 'Where did this come from?',
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
          if (titleError != null) ...[
            const SizedBox(height: 6),
            Text(
              titleError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
          const Divider(height: 24),
          const FieldLabel(label: 'DATE'),
          const SizedBox(height: 6),
          IconTextRow(
            icon: Icons.calendar_today_outlined,
            text: formData.date,
            onTap: onDateTap,
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
