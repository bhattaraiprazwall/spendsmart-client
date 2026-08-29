import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/services/api_service.dart';
import 'package:spendsmart/features/transactions/data/models/transaction_model.dart';

class TransactionService {
  final ApiService _apiService = ApiService();

  Map<String, String> _headers(String idToken) {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $idToken",
    };
  }

  Future<TransactionModel> updateTransaction(
    String idToken,
    String transactionId, {
    String? type,
    double? amount,
    String? title,
    String? note,
    String? paymentMethod,
    String? date,
    String? categoryId,
  }) async {
    final body = <String, dynamic>{};
    if (type != null) body["type"] = type;
    if (amount != null) body["amount"] = amount;
    if (title != null && title.isNotEmpty) body["title"] = title;
    if (note != null) body["note"] = note.isEmpty ? null : note;
    if (paymentMethod != null) body["paymentMethod"] = paymentMethod;
    if (date != null) body["date"] = date;
    if (categoryId != null) body["categoryId"] = categoryId;

    final response = await _apiService.put(
      '${ApiConstants.transactions}/$transactionId',
      body,
      headers: _headers(idToken),
    );

    if (response["statusCode"] != 200) {
      throw Exception(
        response["data"]?["message"] ?? "Failed to update transaction",
      );
    }

    return TransactionModel.fromJson(
      response["data"]["data"]["transaction"] as Map<String, dynamic>,
    );
  }

  Future<void> deleteTransaction(String idToken, String transactionId) async {
    final response = await _apiService.delete(
      '${ApiConstants.transactions}/$transactionId',
      headers: _headers(idToken),
    );

    if (response["statusCode"] != 200) {
      throw Exception(
        response["data"]?["message"] ?? "Failed to delete transaction",
      );
    }
  }
}
