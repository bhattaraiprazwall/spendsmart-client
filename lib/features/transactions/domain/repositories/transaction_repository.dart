import 'package:spendsmart/features/transactions/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions(String idToken);

  Future<Transaction> updateTransaction(
    String idToken,
    String transactionId, {
    String? type,
    double? amount,
    String? title,
    String? note,
    String? paymentMethod,
    String? date,
    String? categoryId,
  });

  Future<void> deleteTransaction(String idToken, String transactionId);
}
