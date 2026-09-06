import 'package:spendsmart/features/insights/domain/entities/spending_anomaly.dart';

class SpendingAnomalyModel {
  final String status;
  final String message;
  final double currentSpending;
  final List<double> historicalSpending;
  final double? mean;
  final double? standardDeviation;
  final double? zScore;
  final bool? isAnomaly;

  SpendingAnomalyModel({
    required this.status,
    required this.message,
    required this.currentSpending,
    required this.historicalSpending,
    this.mean,
    this.standardDeviation,
    this.zScore,
    this.isAnomaly,
  });

  factory SpendingAnomalyModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return SpendingAnomalyModel(
      status: json['status'] as String,
      message: json['message'] as String,
      currentSpending:
      (json['currentSpending'] as num).toDouble(),
      historicalSpending:
      (json['historicalSpending'] as List? ?? [])
          .map((value) => (value as num).toDouble())
          .toList(),
      mean: json['mean'] != null
          ? (json['mean'] as num).toDouble()
          : null,
      standardDeviation: json['standardDeviation'] != null
          ? (json['standardDeviation'] as num).toDouble()
          : null,
      zScore: json['zScore'] != null
          ? (json['zScore'] as num).toDouble()
          : null,
      isAnomaly: json['isAnomaly'] as bool?,
    );
  }

  SpendingAnomaly toEntity() {
    return SpendingAnomaly(
      status: status,
      message: message,
      currentSpending: currentSpending,
      historicalSpending: historicalSpending,
      mean: mean,
      standardDeviation: standardDeviation,
      zScore: zScore,
      isAnomaly: isAnomaly,
    );
  }
}