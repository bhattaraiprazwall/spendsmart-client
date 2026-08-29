import 'package:flutter/material.dart';
import 'package:spendsmart/core/constants/app_colors.dart';
import 'package:spendsmart/core/theme/app_text_styles.dart';
import 'package:spendsmart/core/utils/currency_util.dart';

class TotalBalanceCard extends StatelessWidget {
  final String balance;
  final String currency;
  final String periodLabel;

  const TotalBalanceCard({
    super.key,
    this.balance = '0.00',
    this.currency = 'USD',
    this.periodLabel = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL BALANCE',
            style: AppTextStyles.body.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            CurrencyUtil.format(balance, currency),
            style: AppTextStyles.body.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),

          if (periodLabel.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  periodLabel,
                  style: AppTextStyles.label.copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
