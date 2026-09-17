import 'package:flutter/material.dart';

class BudgetItem {
  final IconData icon;
  final String amount;
  final String label;
  final double progress;
  final Color color;
  final Color iconColor;
  final Color? iconBgColor;
  final Color? amountColor;
  final Color? trackColor;

  const BudgetItem({
    required this.icon,
    required this.amount,
    required this.label,
    required this.progress,
    required this.color,
    required this.iconColor,
    this.iconBgColor,
    this.amountColor,
    this.trackColor,
  });
}