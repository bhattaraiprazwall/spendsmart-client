import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/incomes/data/datasources/income_remote_data_source.dart';
import 'package:spendsmart/features/incomes/data/repositories/income_repository_impl.dart';
import 'package:spendsmart/features/incomes/domain/entities/income.dart';
import 'package:spendsmart/features/incomes/domain/repositories/income_repository.dart';
import 'package:spendsmart/features/incomes/domain/usecases/create_income.dart';
import 'package:spendsmart/features/incomes/domain/usecases/get_incomes.dart';
import 'package:spendsmart/features/budget/presentation/providers/budget_provider.dart';
import 'package:spendsmart/features/home/presentation/providers/dashboard_provider.dart';
import 'package:spendsmart/features/insights/presentation/providers/insights_provider.dart';
import 'package:spendsmart/features/forecast/presentation/providers/forecast_provider.dart';
import 'package:spendsmart/features/transactions/presentation/providers/transaction_provider.dart';
import 'dart:async';
import 'package:spendsmart/core/database/database_provider.dart';
import 'package:spendsmart/features/incomes/data/datasources/income_local_data_source.dart';

final incomeRemoteDataSourceProvider = Provider<IncomeRemoteDataSource>((ref) {
  return IncomeRemoteDataSourceImpl();
});

final incomeLocalDataSourceProvider = Provider<IncomeLocalDataSource>((ref) {
  return IncomeLocalDataSourceImpl(
    transactionDao: ref.watch(transactionDaoProvider),
    categoryDao: ref.watch(categoryDaoProvider),
    storageService: ref.watch(storageServiceProvider),
  );
});

final incomeRepositoryProvider = Provider<IncomeRepository>((ref) {
  return IncomeRepositoryImpl(
    ref.watch(incomeRemoteDataSourceProvider),
    ref.watch(incomeLocalDataSourceProvider),
  );
});

final createIncomeUseCaseProvider = Provider<CreateIncome>((ref) {
  return CreateIncome(ref.watch(incomeRepositoryProvider));
});

final getIncomesUseCaseProvider = Provider<GetIncomes>((ref) {
  return GetIncomes(ref.watch(incomeRepositoryProvider));
});

final incomeProvider = AsyncNotifierProvider<IncomeNotifier, List<Income>>(
  IncomeNotifier.new,
);

class IncomeNotifier extends AsyncNotifier<List<Income>> {
  @override
  FutureOr<List<Income>> build() => [];

  void _safeSetState(AsyncValue<List<Income>> newState) {
    try {
      state = newState;
    } catch (_) {}
  }

  Future<Income> createIncome(
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
      final income = await ref.read(createIncomeUseCaseProvider)(
        idToken,
        type: type,
        amount: amount,
        title: title,
        note: note,
        date: date,
        categoryId: categoryId,
      );
      
      // Invalidate dependent providers to trigger automatic background updates
      ref.invalidate(transactionProvider);
      ref.invalidate(insightsProvider);
      ref.invalidate(spendingAnomalyProvider);
      ref.invalidate(monthlyForecastProvider);
      ref.invalidate(dashboardProvider);
      ref.invalidate(budgetProvider);

      if (state.hasValue) {
        _safeSetState(AsyncData([income, ...state.value!]));
      } else {
        _safeSetState(AsyncData([income]));
      }
      return income;
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).clearAuth();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
      rethrow;
    }
  }

  Future<List<Income>> fetchIncomes(String idToken) async {
    _safeSetState(const AsyncLoading());
    try {
      final incomes = await ref.read(getIncomesUseCaseProvider)(idToken);
      _safeSetState(AsyncData(incomes));
      return incomes;
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).clearAuth();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
      rethrow;
    }
  }
}
