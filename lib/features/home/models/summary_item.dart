import 'package:flutter/material.dart';

class SummaryItem {
  final String title;
  final String amount;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color titleColor;

  const SummaryItem({
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.titleColor,
  });
}