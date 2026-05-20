import 'package:flutter/material.dart';
import '../models/budget_item.dart';
import '../models/summary_item.dart';
import '../models/transaction_item.dart';

class MockHomeData {
  static const List<SummaryItem> summaryItems = [
    SummaryItem(
      title: 'INCOME',
      amount: '\$3,100',
      icon: Icons.arrow_downward,
      iconBg: Color.fromARGB(255, 187, 251, 119),
      iconColor: Colors.green,
      titleColor: Color.fromARGB(255, 77, 143, 2),
    ),
    SummaryItem(
      title: 'EXPENSES',
      amount: '\$1,850',
      icon: Icons.arrow_upward,
      iconBg: Color(0xFFE5E7EB),
      iconColor: Colors.black,
      titleColor: Colors.grey,
    ),
  ];

  static final List<BudgetItem> budgetItems = [
    BudgetItem(
      icon: Icons.shopping_cart_outlined,
      amount: '\$150 left',
      label: 'GROCERIES',
      progress: 0.6,
      color: Colors.blue,
      iconColor: Colors.blue,
    ),
    BudgetItem(
      icon: Icons.restaurant_outlined,
      amount: '\$15 left',
      label: 'DINING OUT',
      progress: 0.9,
      color: Colors.red,
      iconColor: Colors.red,
    ),
  ];

  static final List<TransactionItem> transactions = [
    TransactionItem(
      icon: Icons.shopping_bag_outlined,
      title: 'Whole Foods Market',
      category: 'Groceries',
      day: 'Today',
      amount: -84.20,
      iconColor: Colors.blueGrey,
      iconBg: Color(0xFFEFF6FF),
    ),
    TransactionItem(
      icon: Icons.money_rounded,
      title: 'Salary Transfer',
      category: 'Income',
      day: 'Sep 14',
      amount: 2400.00,
      iconColor: Colors.green,
      iconBg: Color(0xFFECFDF5),
    ),
  ];
}