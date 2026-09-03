import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/budget/data/datasources/budget_remote_datasource.dart';
import 'package:spendsmart/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:spendsmart/features/budget/domain/entities/budget.dart';
import 'package:spendsmart/features/budget/domain/repositories/budget_repository.dart';
import 'package:spendsmart/features/budget/domain/usecases/add_category_limit.dart';
import 'package:spendsmart/features/budget/domain/usecases/create_or_update_budget.dart';
import 'package:spendsmart/features/budget/domain/usecases/delete_budget.dart';
import 'package:spendsmart/features/budget/domain/usecases/get_budget.dart';
import 'package:spendsmart/features/budget/domain/usecases/get_budget_status.dart';
import 'package:spendsmart/features/budget/domain/usecases/remove_category_limit.dart';
import 'package:spendsmart/features/budget/domain/usecases/update_budget.dart';
import 'package:spendsmart/features/budget/domain/usecases/update_category_limit.dart';
import 'package:spendsmart/features/home/presentation/providers/dashboard_provider.dart';
part 'budget_provider.g.dart';

@riverpod
BudgetRemoteDataSource budgetRemoteDataSource(Ref ref) {
  return BudgetRemoteDataSource();
}

@riverpod
BudgetRepository budgetRepository(Ref ref) {
  return BudgetRepositoryImpl(ref.watch(budgetRemoteDataSourceProvider));
}

@riverpod
GetBudget getBudgetUseCase(Ref ref) {
  return GetBudget(ref.watch(budgetRepositoryProvider));
}

@riverpod
GetBudgetStatus getBudgetStatusUseCase(Ref ref) {
  return GetBudgetStatus(ref.watch(budgetRepositoryProvider));
}

@riverpod
CreateOrUpdateBudget createOrUpdateBudgetUseCase(Ref ref) {
  return CreateOrUpdateBudget(ref.watch(budgetRepositoryProvider));
}

@riverpod
UpdateBudget updateBudgetUseCase(Ref ref) {
  return UpdateBudget(ref.watch(budgetRepositoryProvider));
}

@riverpod
DeleteBudget deleteBudgetUseCase(Ref ref) {
  return DeleteBudget(ref.watch(budgetRepositoryProvider));
}

@riverpod
AddCategoryLimit addCategoryLimitUseCase(Ref ref) {
  return AddCategoryLimit(ref.watch(budgetRepositoryProvider));
}

@riverpod
UpdateCategoryLimit updateCategoryLimitUseCase(Ref ref) {
  return UpdateCategoryLimit(ref.watch(budgetRepositoryProvider));
}

@riverpod
RemoveCategoryLimit removeCategoryLimitUseCase(Ref ref) {
  return RemoveCategoryLimit(ref.watch(budgetRepositoryProvider));
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
      final budget = await ref.read(getBudgetUseCaseProvider)(
        idToken,
        month: month,
        year: year,
      );
      if (budget == null) {
        _safeSetState(const AsyncData(null));
        return;
      }
      final status = await ref
          .read(getBudgetStatusUseCaseProvider)(idToken, budget.id);
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
      await ref.read(createOrUpdateBudgetUseCaseProvider)(
        idToken,
        month: month,
        year: year,
        totalAmount: totalAmount,
        categories: categories,
      );
      await fetchBudget(idToken, month: month, year: year);
      ref.invalidate(dashboardProvider);
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
      await ref.read(updateBudgetUseCaseProvider)(
        idToken,
        budgetId,
        totalAmount: totalAmount,
      );
      await fetchBudget(idToken, month: _month, year: _year);
      ref.invalidate(dashboardProvider);
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
      await ref.read(deleteBudgetUseCaseProvider)(idToken, budgetId);
      _safeSetState(const AsyncData(null));
      ref.invalidate(dashboardProvider);
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
      await ref.read(addCategoryLimitUseCaseProvider)(
        idToken,
        budgetId,
        categoryId: categoryId,
        limit: limit,
      );
      await fetchBudget(idToken, month: _month, year: _year);
      ref.invalidate(dashboardProvider);
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
      await ref.read(updateCategoryLimitUseCaseProvider)(
        idToken,
        budgetId,
        categoryId,
        limit: limit,
      );
      await fetchBudget(idToken, month: _month, year: _year);
      ref.invalidate(dashboardProvider);
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
      await ref.read(removeCategoryLimitUseCaseProvider)(
        idToken,
        budgetId,
        categoryId,
      );
      await fetchBudget(idToken, month: _month, year: _year);
      ref.invalidate(dashboardProvider);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
    }
  }
}
