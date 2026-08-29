import 'package:flutter/material.dart';
import 'package:spendsmart/core/widgets/cards/transaction_card.dart';
import 'package:spendsmart/features/expenses/data/models/expense.dart';
import 'package:spendsmart/features/home/models/transaction_item.dart';

class RecentTransactionsSection extends StatelessWidget {
  final List<ExpenseModel> transactions;

  const RecentTransactionsSection({
    super.key,
    this.transactions = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'No transactions yet',
          style: TextStyle(color: Colors.grey.shade500),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        children: List.generate(
          transactions.length,
          (index) {
            final item = _mapToItem(transactions[index]);

            final bool isLast = index == transactions.length - 1;

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

  TransactionItem _mapToItem(ExpenseModel e) {
    final months = const [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final day = '${months[e.date.month - 1]} ${e.date.day}';

    return TransactionItem(
      icon: _mapCategoryIcon(e.categoryIcon),
      title: e.title,
      category: e.categoryName,
      day: day,
      amount: e.type == 'INCOME' ? e.amount : -e.amount,
      iconColor: _hexToColor(e.categoryColor),
      iconBg: _hexToColor(e.categoryColor).withOpacity(0.1),
    );
  }

  IconData _mapCategoryIcon(String iconName) {
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
