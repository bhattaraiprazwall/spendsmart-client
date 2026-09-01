import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/providers/currency_provider.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/utils/currency_util.dart';
import 'package:spendsmart/features/home/domain/entities/transaction_item.dart';

class TransactionCard extends ConsumerWidget {
  final TransactionItem item;

  const TransactionCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = ref.watch(currencyProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: item.iconColor),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '${item.category} • ${item.day}',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              ],
            ),
          ),

          Text(
            CurrencyUtil.signed(item.amount, code),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: item.isPositive ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
