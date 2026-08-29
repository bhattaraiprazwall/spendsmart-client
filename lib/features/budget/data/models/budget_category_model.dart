class BudgetCategoryModel {
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

  const BudgetCategoryModel({
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

  factory BudgetCategoryModel.fromStatusJson(Map<String, dynamic> json) {
    final category = json["category"] as Map<String, dynamic>? ?? const {};
    return BudgetCategoryModel(
      categoryId: category["id"] as String? ?? json["categoryId"] as String? ?? "",
      name: category["name"] as String? ?? "Category",
      icon: category["icon"] as String? ?? "category",
      color: category["color"] as String? ?? "#3D5CFF",
      limit: (json["limit"] ?? "0.00").toString(),
      spent: (json["spent"] ?? "0.00").toString(),
      remaining: (json["remaining"] ?? "0.00").toString(),
      usagePercentage: (json["usagePercentage"] as num?)?.toInt() ?? 0,
      isOverspent: json["isOverspent"] as bool? ?? false,
      status: json["status"] as String? ?? "OK",
    );
  }
}
