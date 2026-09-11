import 'package:flutter/material.dart';
import 'package:spendsmart/core/localization/localization_extension.dart';
import 'package:spendsmart/core/theme/app_theme_extension.dart';
import 'package:spendsmart/core/utils/currency_util.dart';
import 'package:spendsmart/core/widgets/cards/summary_card.dart';
import 'package:spendsmart/features/home/domain/entities/summary_item.dart';

class IncomeExpenseSection extends StatelessWidget {
  final String income;
  final String expense;
  final String currency;

  const IncomeExpenseSection({
    super.key,
    this.income = '0.00',
    this.expense = '0.00',
    this.currency = 'USD',
  });

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        SummaryCard(
          item: SummaryItem(
            title: context.tr('income').toUpperCase(),
            amount: CurrencyUtil.format(income, currency),
            icon: Icons.arrow_downward_rounded,
            iconBg: const Color(0xFF10B981).withValues(alpha: 0.12),
            iconColor: const Color(0xFF10B981),
            titleColor: c.textSecondary,
          ),
        ),
        const SizedBox(width: 12),
        SummaryCard(
          item: SummaryItem(
            title: context.tr('expense').toUpperCase(),
            amount: CurrencyUtil.format(expense, currency),
            icon: Icons.arrow_upward_rounded,
            iconBg: const Color(0xFFEF4444).withValues(alpha: 0.12),
            iconColor: const Color(0xFFEF4444),
            titleColor: c.textSecondary,
          ),
        ),
      ],
    );
  }
}
