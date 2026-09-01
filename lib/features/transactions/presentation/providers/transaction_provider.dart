import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/budget/presentation/providers/budget_provider.dart';
import 'package:spendsmart/features/expenses/presentation/providers/expense_provider.dart';
import 'package:spendsmart/features/home/presentation/providers/dashboard_provider.dart';
import 'package:spendsmart/features/incomes/presentation/providers/income_provider.dart';
import 'package:spendsmart/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:spendsmart/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:spendsmart/features/transactions/domain/entities/transaction.dart';
import 'package:spendsmart/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:spendsmart/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:spendsmart/features/transactions/domain/usecases/update_transaction.dart';
part 'transaction_provider.g.dart';

@riverpod
TransactionRepository transactionRepository(Ref ref) {
  return TransactionRepositoryImpl(ref.watch(transactionRemoteDataSourceProvider));
}

@riverpod
TransactionRemoteDataSource transactionRemoteDataSource(Ref ref) {
  return TransactionRemoteDataSource();
}

@riverpod
UpdateTransaction updateTransaction(Ref ref) {
  return UpdateTransaction(ref.watch(transactionRepositoryProvider));
}

@riverpod
DeleteTransaction deleteTransaction(Ref ref) {
  return DeleteTransaction(ref.watch(transactionRepositoryProvider));
}

@riverpod
class TransactionNotifier extends _$TransactionNotifier {
  @override
  FutureOr<List<Transaction>> build() async {
    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null) return [];
    
    final repository = ref.watch(transactionRepositoryProvider);
    return await repository.getTransactions(token);
  }

  Future<void> _refreshDependents(String idToken) async {
    final now = DateTime.now();
    await Future.wait([
      ref.read(expenseProvider.notifier).fetchExpenses(idToken),
      ref.read(incomeProvider.notifier).fetchIncomes(idToken),
      ref.read(dashboardProvider.notifier).fetchSummary(idToken),
      ref
          .read(budgetProvider.notifier)
          .fetchBudget(idToken, month: now.month, year: now.year),
    ]);
  }

  Future<Transaction?> updateTransaction(
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
    state = const AsyncLoading();
    try {
      final updated = await ref.read(updateTransactionProvider)(
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
      ref.invalidateSelf();
      await future;
      await _refreshDependents(idToken);
      return updated;
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> deleteTransaction(String idToken, String transactionId) async {
    state = const AsyncLoading();
    try {
      await ref.read(deleteTransactionProvider)(idToken, transactionId);
      ref.invalidateSelf();
      await future;
      await _refreshDependents(idToken);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
