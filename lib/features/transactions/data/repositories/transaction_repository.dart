import 'package:spendsmart/features/transactions/data/models/transaction_model.dart';
import 'package:spendsmart/features/transactions/data/services/transaction_service.dart';

class TransactionRepository {
  final TransactionService _service = TransactionService();

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
  }) {
    return _service.updateTransaction(
      idToken,
      transactionId,
      type: type,
      amount: amount,
      title: title,
      note: note,
      paymentMethod: paymentMethod,
      date: date,
      categoryId: categoryId,
    );
  }

  Future<void> deleteTransaction(String idToken, String transactionId) {
    return _service.deleteTransaction(idToken, transactionId);
  }
}
