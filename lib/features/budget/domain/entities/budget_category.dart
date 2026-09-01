class BudgetCategory {
  final String categoryId;
  final String name;
  final String icon;
  final String color;
  final String limit;
  final String spent;
  final String remaining;
  final int usagePercentage;
  final bool isOverspent;
  final String status;

  const BudgetCategory({
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.color,
    required this.limit,
    required this.spent,
    required this.remaining,
    required this.usagePercentage,
    required this.isOverspent,
    required this.status,
  });
}
