class Insight {
  final String totalSpent;
  final List<CategoryBreakdown> breakdown;
  final TopInsight? topInsight;

  const Insight({
    required this.totalSpent,
    required this.breakdown,
    this.topInsight,
  });
}

class CategoryBreakdown {
  final String name;
  final String icon;
  final String color;
  final double amount;
  final double percentage;

  const CategoryBreakdown({
    required this.name,
    required this.icon,
    required this.color,
    required this.amount,
    required this.percentage,
  });
}

class TopInsight {
  final String name;
  final String icon;
  final String color;
  final String percentage;

  const TopInsight({
    required this.name,
    required this.icon,
    required this.color,
    required this.percentage,
  });
}
