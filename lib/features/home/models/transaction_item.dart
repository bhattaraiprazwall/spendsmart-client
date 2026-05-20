import 'package:flutter/material.dart';

class TransactionItem {
  final IconData icon;
  final String title;
  final String category;
  final String day;
  final double amount;
  final Color iconColor;
  final Color iconBg;

  const TransactionItem({
    required this.icon,
    required this.title,
    required this.category,
    required this.day,
    required this.amount,
    required this.iconColor,
    required this.iconBg,
  });

  bool get isPositive => amount > 0;

  String get formattedAmount {
    return '${isPositive ? '+' : '-'}\$${amount.abs().toStringAsFixed(2)}';
  }
}