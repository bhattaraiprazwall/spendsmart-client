import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/services/api_service.dart';
import 'package:spendsmart/features/expenses/data/models/expense.dart';

class ExpenseRemoteDataSource {
  final ApiService _apiService = ApiService();

  Future<ExpenseModel> createExpense(
    String idToken, {
    required String type,
    required double amount,
    required String title,
    String? note,
    required String paymentMethod,
    required String date,
    required String categoryId,
  }) async {
    final body = <String, dynamic>{
      "type": type,
      "amount": amount,
      "title": title,
      "paymentMethod": paymentMethod,
      "date": date,
      "categoryId": categoryId,
    };
    if (note != null && note.isNotEmpty) body["note"] = note;

    final response = await _apiService.post(
      ApiConstants.transactions,
      body,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      },
    );

    if (response["statusCode"] != 201) {
      String message = "Failed to create expense";
      final data = response["data"];
      if (data is Map<String, dynamic>) {
        final errors = data["errors"];
        if (errors is List && errors.isNotEmpty) {
          message = errors.map((e) => e is Map ? e["message"] : null).whereType<String>().join(", ");
        } else if (data["message"] != null) {
          message = data["message"].toString();
        }
      }
      throw Exception(message);
    }

    return ExpenseModel.fromJson(response["data"]["data"]["transaction"]);
  }

  Future<List<ExpenseModel>> getExpenses(String idToken) async {
    final response = await _apiService.get(
      ApiConstants.transactions,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      },
    );

    if (response["statusCode"] != 200) {
      throw Exception(
        response["data"]["message"] ?? "Failed to fetch expenses",
      );
    }

    final List<dynamic> items = response["data"]["data"]["items"] ?? [];
    return items
        .map((json) => ExpenseModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
