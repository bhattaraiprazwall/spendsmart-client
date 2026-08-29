import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
import 'package:spendsmart/features/incomes/data/models/income.dart';
import 'package:spendsmart/features/incomes/data/repositories/income_repository.dart';
import 'dart:async';

final incomeRepositoryProvider = Provider<IncomeRepository>((ref) {
  return IncomeRepository();
});

final incomeProvider = AsyncNotifierProvider<IncomeNotifier, List<IncomeModel>>(
  IncomeNotifier.new,
);

class IncomeNotifier extends AsyncNotifier<List<IncomeModel>> {
  @override
  FutureOr<List<IncomeModel>> build() => [];

  void _safeSetState(AsyncValue<List<IncomeModel>> newState) {
    try {
      state = newState;
    } catch (_) {}
  }

  Future<IncomeModel> createIncome(
    String idToken, {
    required String type,
    required double amount,
    required String title,
    String? note,
    required String date,
    required String categoryId,
  }) async {
    _safeSetState(const AsyncLoading());
    try {
      final repository = ref.read(incomeRepositoryProvider);
      final income = await repository.createIncome(
        idToken,
        type: type,
        amount: amount,
        title: title,
        note: note,
        date: date,
        categoryId: categoryId,
      );
      _safeSetState(AsyncData([income]));
      return income;
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
      rethrow;
    }
  }

  Future<List<IncomeModel>> fetchIncomes(String idToken) async {
    _safeSetState(const AsyncLoading());
    try {
      final repository = ref.read(incomeRepositoryProvider);
      final incomes = await repository.getIncomes(idToken);
      _safeSetState(AsyncData(incomes));
      return incomes;
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
