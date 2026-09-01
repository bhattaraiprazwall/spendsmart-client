import 'package:spendsmart/features/transactions/domain/repositories/transaction_repository.dart';

class DeleteTransaction {
  final TransactionRepository _repository;

  DeleteTransaction(this._repository);

  Future<void> call(String idToken, String transactionId) {
    return _repository.deleteTransaction(idToken, transactionId);
  }
}
