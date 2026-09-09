class MonthlySpending {
  final int year;
  final int month;
  final double total;

  const MonthlySpending({
    required this.year,
    required this.month,
    required this.total,
  });
}

class MonthlyForecast {
  final String status;
  final String message;

  final int? forecastYear;
  final int? forecastMonth;

  final List<MonthlySpending> historicalMonths;

  final int windowSize;
  final List<double> valuesUsed;

  final double? forecast;

  const MonthlyForecast({
    required this.status,
    required this.message,
    this.forecastYear,
    this.forecastMonth,
    required this.historicalMonths,
    required this.windowSize,
    required this.valuesUsed,
    this.forecast,
  });
}