import 'package:flutter/material.dart';
import 'package:spendsmart/core/widgets/cards/transaction_card.dart';
import 'package:spendsmart/features/home/data/mock_home_data.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        children: List.generate(
          MockHomeData.transactions.length,
          (index) {
            final item = MockHomeData.transactions[index];

            final bool isLast =
                index == MockHomeData.transactions.length - 1;

            return Column(
              children: [
                TransactionCard(item: item),

                if (!isLast)
                  Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}