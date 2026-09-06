class SpendingAnomaly {
  final String status;
  final String message;
  final double currentSpending;
  final List<double> historicalSpending;
  final double? mean;
  final double? standardDeviation;
  final double? zScore;
  final bool? isAnomaly;

  const SpendingAnomaly({
    required this.status,
    required this.message,
    required this.currentSpending,
    required this.historicalSpending,
    this.mean,
    this.standardDeviation,
    this.zScore,
    this.isAnomaly,
  });
}