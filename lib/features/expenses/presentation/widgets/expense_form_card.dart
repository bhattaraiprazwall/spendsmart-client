import 'package:flutter/material.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';
import 'package:spendsmart/features/category/domain/entities/category.dart';
import 'package:spendsmart/features/expenses/domain/entities/expense_form_data.dart';
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
  final Category? suggestionCategory;
  final String? suggestionConfidenceLabel;
  final String? suggestionAlternative;
  final bool showSuggestion;
  final bool isPredicting;
  final VoidCallback? onSuggestionTap;
  final String? titleError;
  final String? categoryError;

  const ExpenseFormCard({
    super.key,
    required this.formData,
    this.onCategoryTap,
    this.onDateTap,
    this.onMethodTap,
    this.onNoteChanged,
    this.onTitleChanged,
    this.suggestionCategory,
    this.suggestionConfidenceLabel,
    this.suggestionAlternative,
    this.showSuggestion = false,
    this.isPredicting = false,
    this.onSuggestionTap,
    this.titleError,
    this.categoryError,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel(label: 'TITLE'),
          const SizedBox(height: 8),
          TextField(
            onChanged: onTitleChanged,
            decoration: InputDecoration(
              hintText: 'What did you spend on?',
              hintStyle: TextStyle(color: c.textMuted, fontSize: 14),
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
          Divider(height: 24, color: c.divider),

          const FieldLabel(label: 'CATEGORY'),
          const SizedBox(height: 8),
          CategoryRow(
            category: formData.category,
            categoryIcon: formData.categoryId != null ? 'category' : null,
            categoryColor: Colors.blue,
            onTap: onCategoryTap,
          ),
          if (categoryError != null) ...[
            const SizedBox(height: 6),
            Text(
              categoryError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
          if (isPredicting)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Predicting category...',
                    style: TextStyle(
                      color: c.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          else if (showSuggestion && suggestionCategory != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _SuggestionTile(
                category: suggestionCategory!,
                confidenceLabel: suggestionConfidenceLabel,
                alternative: suggestionAlternative,
                onTap: onSuggestionTap,
              ),
            ),
          Divider(height: 24, color: c.divider),
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
                VerticalDivider(
                  thickness: 1,
                  width: 20,
                  color: c.divider,
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
          Divider(height: 24, color: c.divider),
          const FieldLabel(label: 'NOTE'),
          const SizedBox(height: 6),
          TextField(
            onChanged: onNoteChanged,
            decoration: InputDecoration(
              hintText: 'What was this for?',
              hintStyle: TextStyle(color: c.textMuted, fontSize: 13),
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

class _SuggestionTile extends StatelessWidget {
  final Category category;
  final String? confidenceLabel;
  final String? alternative;
  final VoidCallback? onTap;

  const _SuggestionTile({
    required this.category,
    this.confidenceLabel,
    this.alternative,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = _hexToColor(category.color);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(
              _mapIcon(category.icon),
              size: 20,
              color: color,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Suggested: ',
                          style: TextStyle(
                            color: c.textMuted,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: category.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (confidenceLabel != null || alternative != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (alternative != null) 'or $alternative',
                        if (confidenceLabel != null)
                          'confidence: $confidenceLabel',
                      ].join(' • '),
                      style: TextStyle(
                        color: c.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.check_circle_outline, size: 18, color: color),
          ],
        ),
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

  Color _hexToColor(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse(h.length == 6 ? 'FF$h' : h, radix: 16));
  }
}
