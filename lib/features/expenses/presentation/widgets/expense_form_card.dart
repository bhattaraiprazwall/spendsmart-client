import 'package:flutter/material.dart';
import 'package:spendsmart/features/expenses/models/expense_form_data.dart';
import 'package:spendsmart/features/expenses/presentation/widgets/category_row.dart';
import 'package:spendsmart/features/expenses/presentation/widgets/field_label.dart';
import 'package:spendsmart/features/expenses/presentation/widgets/icon_text_row.dart';

class ExpenseFormCard extends StatelessWidget {
  final ExpenseFormData formData;

  const ExpenseFormCard({
    super.key,
    required this.formData,
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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // ───────────────── CATEGORY ─────────────────
          const FieldLabel(
            label: 'CATEGORY',
          ),

          const SizedBox(height: 8),

          CategoryRow(
            category: formData.category,
          ),

          const Divider(height: 24),

          // ───────────────── DATE & METHOD ─────────────────
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const FieldLabel(
                        label: 'DATE',
                      ),

                      const SizedBox(height: 6),

                      IconTextRow(
                        icon: Icons
                            .calendar_today_outlined,
                        text: formData.date,
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
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const FieldLabel(
                        label: 'METHOD',
                      ),

                      const SizedBox(height: 6),

                      IconTextRow(
                        icon:
                            Icons.credit_card_outlined,
                        text:
                            formData.paymentMethod,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 24),

          // ───────────────── NOTE ─────────────────
          const FieldLabel(
            label: 'NOTE',
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Icon(
                Icons.edit_note_outlined,
                size: 18,
                color: Colors.grey.shade400,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  formData.note.isEmpty
                      ? 'What was this for?'
                      : formData.note,
                  style: TextStyle(
                    color: formData.note.isEmpty
                        ? Colors.grey.shade400
                        : Colors.black87,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}