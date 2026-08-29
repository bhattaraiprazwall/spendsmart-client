import 'package:spendsmart/features/expenses/data/models/expense.dart';

class DashboardSummary {
  final DashboardPeriod period;
  final Overview overview;
  final List<ExpenseModel> recentTransactions;

  const DashboardSummary({
    required this.period,
    required this.overview,
    required this.recentTransactions,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    final transactions = (json["recentTransactions"] as List<dynamic>? ?? [])
        .map((json) => ExpenseModel.fromJson(json as Map<String, dynamic>))
        .toList();

    return DashboardSummary(
      period: DashboardPeriod.fromJson(
        json["period"] as Map<String, dynamic>? ?? const {},
      ),
      overview: Overview.fromJson(
        json["overview"] as Map<String, dynamic>? ?? const {},
      ),
      recentTransactions: transactions,
    );
  }
}

class DashboardPeriod {
  final int month;
  final int year;
  final String label;

  const DashboardPeriod({required this.month, required this.year, required this.label});

  factory DashboardPeriod.fromJson(Map<String, dynamic> json) {
    return DashboardPeriod(
      month: json["month"] as int? ?? 0,
      year: json["year"] as int? ?? 0,
      label: json["label"] as String? ?? "",
    );
  }
}

class Overview {
  final String totalBalance;
  final String totalIncome;
  final String totalExpenses;
  final String currency;

  const Overview({
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpenses,
    required this.currency,
  });

  factory Overview.fromJson(Map<String, dynamic> json) {
    return Overview(
      totalBalance: json["totalBalance"]?.toString() ?? "0.00",
      totalIncome: json["totalIncome"]?.toString() ?? "0.00",
      totalExpenses: json["totalExpenses"]?.toString() ?? "0.00",
      currency: json["currency"] as String? ?? "USD",
    );
  }
}
