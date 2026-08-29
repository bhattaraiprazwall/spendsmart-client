import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
import 'package:spendsmart/features/budget/data/models/budget_model.dart';
import 'package:spendsmart/features/budget/data/repositories/budget_repository.dart';
part 'budget_provider.g.dart';

@riverpod
BudgetRepository budgetRepository(Ref ref) {
  return BudgetRepository();
}

@riverpod
class Budget extends _$Budget {
  int _month = DateTime.now().month;
  int _year = DateTime.now().year;

  @override
  FutureOr<BudgetStatus?> build() => null;

  void _safeSetState(AsyncValue<BudgetStatus?> newState) {
    try {
      state = newState;
    } catch (_) {}
  }

  int get month => _month;
  int get year => _year;

  Future<void> setMonth(
    String idToken, {
    required int month,
    required int year,
  }) async {
    _month = month;
    _year = year;
    await fetchBudget(idToken, month: month, year: year);
  }

  Future<void> fetchBudget(
    String idToken, {
    required int month,
    required int year,
  }) async {
    _month = month;
    _year = year;
    _safeSetState(const AsyncLoading());
    try {
      final repository = ref.read(budgetRepositoryProvider);
      final budget = await repository.getBudget(
        idToken,
        month: month,
        year: year,
      );
      if (budget == null) {
        _safeSetState(const AsyncData(null));
        return;
      }
      final status = await repository.getBudgetStatus(idToken, budget.id);
      _safeSetState(AsyncData(status));
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
    }
  }

  Future<void> createOrUpdateBudget(
    String idToken, {
    required int month,
    required int year,
    required double totalAmount,
    List<Map<String, dynamic>>? categories,
  }) async {
    _safeSetState(const AsyncLoading());
    try {
      final repository = ref.read(budgetRepositoryProvider);
      await repository.createOrUpdateBudget(
        idToken,
        month: month,
        year: year,
        totalAmount: totalAmount,
        categories: categories,
      );
      await fetchBudget(idToken, month: month, year: year);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
    }
  }

  Future<void> updateBudget(
    String idToken,
    String budgetId, {
    required double totalAmount,
  }) async {
    _safeSetState(const AsyncLoading());
    try {
      final repository = ref.read(budgetRepositoryProvider);
      await repository.updateBudget(
        idToken,
        budgetId,
        totalAmount: totalAmount,
      );
      await fetchBudget(idToken, month: _month, year: _year);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
    }
  }

  Future<void> deleteBudget(String idToken, String budgetId) async {
    _safeSetState(const AsyncLoading());
    try {
      final repository = ref.read(budgetRepositoryProvider);
      await repository.deleteBudget(idToken, budgetId);
      _safeSetState(const AsyncData(null));
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
    }
  }

  Future<void> addCategoryLimit(
    String idToken,
    String budgetId, {
    required String categoryId,
    required double limit,
  }) async {
    _safeSetState(const AsyncLoading());
    try {
      final repository = ref.read(budgetRepositoryProvider);
      await repository.addCategoryLimit(
        idToken,
        budgetId,
        categoryId: categoryId,
        limit: limit,
      );
      await fetchBudget(idToken, month: _month, year: _year);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
    }
  }

  Future<void> updateCategoryLimit(
    String idToken,
    String budgetId,
    String categoryId, {
    required double limit,
  }) async {
    _safeSetState(const AsyncLoading());
    try {
      final repository = ref.read(budgetRepositoryProvider);
      await repository.updateCategoryLimit(
        idToken,
        budgetId,
        categoryId,
        limit: limit,
      );
      await fetchBudget(idToken, month: _month, year: _year);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
    }
  }

  Future<void> removeCategoryLimit(
    String idToken,
    String budgetId,
    String categoryId,
  ) async {
    _safeSetState(const AsyncLoading());
    try {
      final repository = ref.read(budgetRepositoryProvider);
      await repository.removeCategoryLimit(idToken, budgetId, categoryId);
      await fetchBudget(idToken, month: _month, year: _year);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
    }
  }
}
