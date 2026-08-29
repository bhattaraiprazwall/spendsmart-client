import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
import 'package:spendsmart/features/budget/presentation/providers/budget_provider.dart';
import 'package:spendsmart/features/expenses/presentation/providers/expense_provider.dart';
import 'package:spendsmart/features/home/presentation/providers/dashboard_provider.dart';
import 'package:spendsmart/features/incomes/presentation/providers/income_provider.dart';
import 'package:spendsmart/features/transactions/data/models/transaction_model.dart';
import 'package:spendsmart/features/transactions/data/repositories/transaction_repository.dart';
part 'transaction_provider.g.dart';

@riverpod
TransactionRepository transactionRepository(Ref ref) {
  return TransactionRepository();
}

@riverpod
class Transaction extends _$Transaction {
  @override
  FutureOr<TransactionModel?> build() => null;

  void _safeSetState(AsyncValue<TransactionModel?> newState) {
    try {
      state = newState;
    } catch (_) {}
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

  Future<TransactionModel?> updateTransaction(
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
    _safeSetState(const AsyncLoading());
    try {
      final repository = ref.read(transactionRepositoryProvider);
      final updated = await repository.updateTransaction(
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
      _safeSetState(AsyncData(updated));
      await _refreshDependents(idToken);
      return updated;
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
      rethrow;
    }
  }

  Future<void> deleteTransaction(String idToken, String transactionId) async {
    _safeSetState(const AsyncLoading());
    try {
      final repository = ref.read(transactionRepositoryProvider);
      await repository.deleteTransaction(idToken, transactionId);
      _safeSetState(const AsyncData(null));
      await _refreshDependents(idToken);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
      rethrow;
    }
  }
}
