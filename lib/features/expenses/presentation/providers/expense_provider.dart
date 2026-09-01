import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/expenses/data/datasources/expense_remote_datasource.dart';
import 'package:spendsmart/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:spendsmart/features/expenses/domain/entities/expense.dart';
import 'package:spendsmart/features/expenses/domain/repositories/expense_repository.dart';
import 'package:spendsmart/features/expenses/domain/usecases/create_expense.dart';
import 'package:spendsmart/features/expenses/domain/usecases/get_expenses.dart';
import 'package:spendsmart/features/transactions/presentation/providers/transaction_provider.dart';
import 'dart:async';

final expenseRemoteDataSourceProvider = Provider<ExpenseRemoteDataSource>((ref) {
  return ExpenseRemoteDataSource();
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepositoryImpl(ref.watch(expenseRemoteDataSourceProvider));
});

final createExpenseUseCaseProvider = Provider<CreateExpense>((ref) {
  return CreateExpense(ref.watch(expenseRepositoryProvider));
});

final getExpensesUseCaseProvider = Provider<GetExpenses>((ref) {
  return GetExpenses(ref.watch(expenseRepositoryProvider));
});

final expenseProvider =
    AsyncNotifierProvider<ExpenseNotifier, List<Expense>>(
  ExpenseNotifier.new,
);

class ExpenseNotifier extends AsyncNotifier<List<Expense>> {
  @override
  FutureOr<List<Expense>> build() => [];

  void _safeSetState(AsyncValue<List<Expense>> newState) {
    try {
      state = newState;
    } catch (_) {}
  }

  Future<Expense> createExpense(
    String idToken, {
    required String type,
    required double amount,
    required String title,
    String? note,
    required String paymentMethod,
    required String date,
    required String categoryId,
  }) async {
    _safeSetState(const AsyncLoading());
    try {
      final current = state.value ?? [];
      final expense = await ref.read(createExpenseUseCaseProvider)(
        idToken,
        type: type,
        amount: amount,
        title: title,
        note: note,
        paymentMethod: paymentMethod,
        date: date,
        categoryId: categoryId,
      );
      _safeSetState(AsyncData([...current, expense]));
      ref.invalidate(transactionProvider);
      return expense;
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
      rethrow;
    }
  }

  Future<List<Expense>> fetchExpenses(String idToken) async {
    _safeSetState(const AsyncLoading());
    try {
      final expenses =
          await ref.read(getExpensesUseCaseProvider)(idToken);
      _safeSetState(AsyncData(expenses));
      return expenses;
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
