import '../../domain/entities/monthly_forecast.dart';

class MonthlySpendingModel {
  final int year;
  final int month;
  final double total;

  const MonthlySpendingModel({
    required this.year,
    required this.month,
    required this.total,
  });

  factory MonthlySpendingModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MonthlySpendingModel(
      year: json['year'] as int,
      month: json['month'] as int,
      total: (json['total'] as num).toDouble(),
    );
  }

  MonthlySpending toEntity() {
    return MonthlySpending(
      year: year,
      month: month,
      total: total,
    );
  }
}

class MonthlyForecastModel {
  final String status;
  final String message;

  final int? forecastYear;
  final int? forecastMonth;

  final List<MonthlySpendingModel> historicalMonths;

  final int windowSize;
  final List<double> valuesUsed;

  final double? forecast;

  const MonthlyForecastModel({
    required this.status,
    required this.message,
    this.forecastYear,
    this.forecastMonth,
    required this.historicalMonths,
    required this.windowSize,
    required this.valuesUsed,
    this.forecast,
  });

  factory MonthlyForecastModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MonthlyForecastModel(
      status: json['status'] as String,
      message: json['message'] as String,

      forecastYear:
          json['forecastYear'] as int?,

      forecastMonth:
          json['forecastMonth'] as int?,

      historicalMonths:
          (json['historicalMonths'] as List<dynamic>)
              .map(
                (item) =>
                    MonthlySpendingModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),

      windowSize:
          json['windowSize'] as int,

      valuesUsed:
          (json['valuesUsed'] as List<dynamic>)
              .map(
                (value) =>
                    (value as num).toDouble(),
              )
              .toList(),

      forecast:
          (json['forecast'] as num?)?.toDouble(),
    );
  }

  MonthlyForecast toEntity() {
    return MonthlyForecast(
      status: status,
      message: message,
      forecastYear: forecastYear,
      forecastMonth: forecastMonth,
      historicalMonths:
          historicalMonths
              .map((item) => item.toEntity())
              .toList(),
      windowSize: windowSize,
      valuesUsed: valuesUsed,
      forecast: forecast,
    );
  }
}