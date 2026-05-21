import 'package:flutter/material.dart';
import 'package:spendsmart/core/widgets/cards/budget_card.dart';
import 'package:spendsmart/features/home/data/mock_home_data.dart';

class RemainingBudgetSection extends StatelessWidget {
  const RemainingBudgetSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: MockHomeData.budgetItems.length,
        itemBuilder: (context, index) {
          final item = MockHomeData.budgetItems[index];

          return BudgetCard(item: item);
        },
      ),
    );
  }
}