import 'package:spendsmart/features/budget/domain/entities/budget_category.dart';

class Budget {
  final String id;
  final int month;
  final int year;
  final String totalAmount;

  const Budget({
    required this.id,
    required this.month,
    required this.year,
    required this.totalAmount,
  });
}

class BudgetStatus {
  final String id;
  final int month;
  final int year;
  final String totalAmount;
  final String totalSpent;
  final String remaining;
  final int usagePercentage;
  final bool isOverspent;
  final String status;
  final List<BudgetCategory> categories;

  const BudgetStatus({
    required this.id,
    required this.month,
    required this.year,
    required this.totalAmount,
    required this.totalSpent,
    required this.remaining,
    required this.usagePercentage,
    required this.isOverspent,
    required this.status,
    required this.categories,
  });
}
