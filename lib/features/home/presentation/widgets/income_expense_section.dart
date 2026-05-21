import 'package:flutter/material.dart';
import 'package:spendsmart/core/widgets/cards/summary_card.dart';
import 'package:spendsmart/features/home/data/mock_home_data.dart';

class IncomeExpenseSection extends StatelessWidget {
  const IncomeExpenseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: MockHomeData.summaryItems
          .map((item) => SummaryCard(item: item))
          .toList(),
    );
  }
}
