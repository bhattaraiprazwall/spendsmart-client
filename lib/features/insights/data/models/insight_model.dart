import 'package:spendsmart/features/insights/domain/entities/insight.dart';

class InsightModel {
  final String totalSpent;
  final List<CategoryBreakdownModel> breakdown;
  final TopInsightModel? topInsight;

  InsightModel({
    required this.totalSpent,
    required this.breakdown,
    this.topInsight,
  });

  factory InsightModel.fromJson(Map<String, dynamic> json) {
    return InsightModel(
      totalSpent: json['totalSpent'] ?? '0.00',
      breakdown: (json['breakdown'] as List? ?? [])
          .map((item) => CategoryBreakdownModel.fromJson(item))
          .toList(),
      topInsight: json['topInsight'] != null 
          ? TopInsightModel.fromJson(json['topInsight']) 
          : null,
    );
  }

  Insight toEntity() {
    return Insight(
      totalSpent: totalSpent,
      breakdown: breakdown.map((m) => m.toEntity()).toList(),
      topInsight: topInsight?.toEntity(),
    );
  }
}

class CategoryBreakdownModel {
  final String name;
  final String icon;
  final String color;
  final double amount;
  final double percentage;

  CategoryBreakdownModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.amount,
    required this.percentage,
  });

  factory CategoryBreakdownModel.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdownModel(
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
      amount: (json['amount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  CategoryBreakdown toEntity() {
    return CategoryBreakdown(
      name: name,
      icon: icon,
      color: color,
      amount: amount,
      percentage: percentage,
    );
  }
}

class TopInsightModel {
  final String name;
  final String icon;
  final String color;
  final String percentage;

  TopInsightModel({
    required this.name,
    required this.icon,
    required this.color,
    required this.percentage,
  });

  factory TopInsightModel.fromJson(Map<String, dynamic> json) {
    return TopInsightModel(
      name: json['name'],
      icon: json['icon'],
      color: json['color'],
      percentage: json['percentage'],
    );
  }

  TopInsight toEntity() {
    return TopInsight(
      name: name,
      icon: icon,
      color: color,
      percentage: percentage,
    );
  }
}
