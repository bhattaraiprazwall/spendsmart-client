import 'package:spendsmart/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:spendsmart/features/transactions/domain/entities/transaction.dart';
import 'package:spendsmart/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;

  TransactionRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Transaction>> getTransactions(String idToken) async {
    final models = await _remoteDataSource.getTransactions(idToken);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
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
  }) async {
    final model = await _remoteDataSource.updateTransaction(
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
    return model.toEntity();
  }

  @override
  Future<void> deleteTransaction(String idToken, String transactionId) {
    return _remoteDataSource.deleteTransaction(idToken, transactionId);
  }
}
