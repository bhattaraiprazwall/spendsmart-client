import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
import 'package:spendsmart/features/expenses/data/models/expense.dart';
import 'package:spendsmart/features/expenses/data/repositories/expense_repository.dart';
import 'dart:async';
final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository();
});

final expenseProvider =
    AsyncNotifierProvider<ExpenseNotifier, List<ExpenseModel>>(
  ExpenseNotifier.new,
);

class ExpenseNotifier extends AsyncNotifier<List<ExpenseModel>> {
  @override
  FutureOr<List<ExpenseModel>> build() => [];

  void _safeSetState(AsyncValue<List<ExpenseModel>> newState) {
    try {
      state = newState;
    } catch (_) {}
  }

  Future<ExpenseModel> createExpense(
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
      final repository = ref.read(expenseRepositoryProvider);
      final expense = await repository.createExpense(
        idToken,
        type: type,
        amount: amount,
        title: title,
        note: note,
        paymentMethod: paymentMethod,
        date: date,
        categoryId: categoryId,
      );
      _safeSetState(AsyncData([expense]));
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

  Future<List<ExpenseModel>> fetchExpenses(String idToken) async {
    _safeSetState(const AsyncLoading());
    try {
      final repository = ref.read(expenseRepositoryProvider);
      final expenses = await repository.getExpenses(idToken);
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
