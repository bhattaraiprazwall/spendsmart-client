import 'package:flutter/material.dart';
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
            title: 'INCOME',
            amount: CurrencyUtil.format(income, currency),
            icon: Icons.arrow_downward,
            iconBg: const Color.fromARGB(255, 187, 251, 119),
            iconColor: Colors.green,
            titleColor: const Color.fromARGB(255, 77, 143, 2),
          ),
        ),
        SummaryCard(
          item: SummaryItem(
            title: 'EXPENSE',
            amount: CurrencyUtil.format(expense, currency),
            icon: Icons.arrow_upward,
            iconBg: c.border,
            iconColor: c.textPrimary,
            titleColor: c.textSecondary,
          ),
        ),
      ],
    );
  }
}
