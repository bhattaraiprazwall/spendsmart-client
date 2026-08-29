import 'package:spendsmart/features/budget/data/models/budget_category_model.dart';

class BudgetModel {
  final String id;
  final int month;
  final int year;
  final String totalAmount;

  const BudgetModel({
    required this.id,
    required this.month,
    required this.year,
    required this.totalAmount,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json["id"] as String,
      month: json["month"] as int,
      year: json["year"] as int,
      totalAmount: (json["totalAmount"] ?? "0.00").toString(),
    );
  }
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

  final List<BudgetCategoryModel> categories;

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

  factory BudgetStatus.fromJson(Map<String, dynamic> json) {
    final budget = json["budget"] as Map<String, dynamic>? ?? json;

    final rawCategories = json["categories"] as List<dynamic>? ?? [];

    return BudgetStatus(
      id: budget["id"] as String? ?? "",
      month: budget["month"] as int? ?? 0,
      year: budget["year"] as int? ?? 0,
      totalAmount: (budget["totalAmount"] ?? "0.00").toString(),
      totalSpent: (budget["totalSpent"] ?? "0.00").toString(),
      remaining: (budget["remaining"] ?? "0.00").toString(),
      usagePercentage: (budget["usagePercentage"] as num?)?.toInt() ?? 0,
      isOverspent: budget["isOverspent"] as bool? ?? false,
      status: budget["status"] as String? ?? "OK",
      categories: rawCategories
          .map((c) => BudgetCategoryModel.fromStatusJson(
              c as Map<String, dynamic>))
          .toList(),
    );
  }
}
