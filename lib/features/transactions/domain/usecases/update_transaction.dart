import 'package:spendsmart/features/transactions/domain/entities/transaction.dart';
import 'package:spendsmart/features/transactions/domain/repositories/transaction_repository.dart';

class UpdateTransaction {
  final TransactionRepository _repository;

  UpdateTransaction(this._repository);

  Future<Transaction> call(
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
    return _repository.updateTransaction(
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
}
