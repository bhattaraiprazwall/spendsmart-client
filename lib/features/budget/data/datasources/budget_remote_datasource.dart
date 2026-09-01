import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/services/api_service.dart';
import 'package:spendsmart/features/budget/data/models/budget_model.dart';

class BudgetRemoteDataSource {
  final ApiService _apiService = ApiService();

  Map<String, String> _headers(String idToken) => {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      };

  Future<BudgetModel?> getBudget(
    String idToken, {
    required int month,
    required int year,
  }) async {
    final uri = Uri.parse(ApiConstants.budgets).replace(
      queryParameters: {"month": "$month", "year": "$year"},
    );
    final response = await _apiService.get(
      uri.toString(),
      headers: _headers(idToken),
    );

    if (response["statusCode"] != 200) {
      throw Exception(
        response["data"]["message"] ?? "Failed to load budget",
      );
    }

    final data = response["data"]["data"];
    final budget = data["budget"];
    if (budget == null) return null;
    return BudgetModel.fromJson(budget as Map<String, dynamic>);
  }

  Future<BudgetStatusModel> getBudgetStatus(
    String idToken,
    String budgetId,
  ) async {
    final response = await _apiService.get(
      '${ApiConstants.budgets}/$budgetId/status',
      headers: _headers(idToken),
    );

    if (response["statusCode"] != 200) {
      throw Exception(
        response["data"]["message"] ?? "Failed to load budget status",
      );
    }

    return BudgetStatusModel.fromJson(
      response["data"]["data"] as Map<String, dynamic>,
    );
  }

  Future<BudgetModel> createOrUpdateBudget(
    String idToken, {
    required int month,
    required int year,
    required double totalAmount,
    List<Map<String, dynamic>>? categories,
  }) async {
    final body = <String, dynamic>{
      "month": month,
      "year": year,
      "totalAmount": totalAmount,
    };
    if (categories != null && categories.isNotEmpty) {
      body["categories"] = categories;
    }

    final response = await _apiService.post(
      ApiConstants.budgets,
      body,
      headers: _headers(idToken),
    );

    if (response["statusCode"] != 200) {
      throw Exception(
        response["data"]["message"] ?? "Failed to save budget",
      );
    }

    return BudgetModel.fromJson(
      response["data"]["data"]["budget"] as Map<String, dynamic>,
    );
  }

  Future<BudgetModel> updateBudget(
    String idToken,
    String budgetId, {
    required double totalAmount,
  }) async {
    final response = await _apiService.put(
      '${ApiConstants.budgets}/$budgetId',
      {"totalAmount": totalAmount},
      headers: _headers(idToken),
    );

    if (response["statusCode"] != 200) {
      throw Exception(
        response["data"]["message"] ?? "Failed to update budget",
      );
    }

    return BudgetModel.fromJson(
      response["data"]["data"]["budget"] as Map<String, dynamic>,
    );
  }

  Future<void> deleteBudget(String idToken, String budgetId) async {
    final response = await _apiService.delete(
      '${ApiConstants.budgets}/$budgetId',
      headers: _headers(idToken),
    );

    if (response["statusCode"] != 200 && response["statusCode"] != 204) {
      throw Exception(
        response["data"]["message"] ?? "Failed to delete budget",
      );
    }
  }

  Future<void> addCategoryLimit(
    String idToken,
    String budgetId, {
    required String categoryId,
    required double limit,
  }) async {
    final response = await _apiService.post(
      '${ApiConstants.budgets}/$budgetId/categories',
      {"categoryId": categoryId, "limit": limit},
      headers: _headers(idToken),
    );

    if (response["statusCode"] != 200) {
      throw Exception(
        response["data"]["message"] ?? "Failed to add category limit",
      );
    }
  }

  Future<void> updateCategoryLimit(
    String idToken,
    String budgetId,
    String categoryId, {
    required double limit,
  }) async {
    final response = await _apiService.put(
      '${ApiConstants.budgets}/$budgetId/categories/$categoryId',
      {"limit": limit},
      headers: _headers(idToken),
    );

    if (response["statusCode"] != 200) {
      throw Exception(
        response["data"]["message"] ?? "Failed to update category limit",
      );
    }
  }

  Future<void> removeCategoryLimit(
    String idToken,
    String budgetId,
    String categoryId,
  ) async {
    final response = await _apiService.delete(
      '${ApiConstants.budgets}/$budgetId/categories/$categoryId',
      headers: _headers(idToken),
    );

    if (response["statusCode"] != 200 && response["statusCode"] != 204) {
      throw Exception(
        response["data"]["message"] ?? "Failed to remove category limit",
      );
    }
  }
}
