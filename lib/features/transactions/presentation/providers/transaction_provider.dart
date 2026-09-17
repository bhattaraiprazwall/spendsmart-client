import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/budget/presentation/providers/budget_provider.dart';
import 'package:spendsmart/features/home/presentation/providers/dashboard_provider.dart';
import 'package:spendsmart/core/database/database_provider.dart';
import 'package:spendsmart/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:spendsmart/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:spendsmart/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:spendsmart/features/transactions/domain/entities/transaction.dart';
import 'package:spendsmart/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:spendsmart/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:spendsmart/features/transactions/domain/usecases/update_transaction.dart';
import 'package:spendsmart/features/insights/presentation/providers/insights_provider.dart';
import 'package:spendsmart/features/forecast/presentation/providers/forecast_provider.dart';
part 'transaction_provider.g.dart';

@riverpod
TransactionRemoteDataSource transactionRemoteDataSource(Ref ref) {
  return TransactionRemoteDataSource();
}

@riverpod
TransactionLocalDataSource transactionLocalDataSource(Ref ref) {
  return TransactionLocalDataSourceImpl(
    transactionDao: ref.watch(transactionDaoProvider),
    categoryDao: ref.watch(categoryDaoProvider),
    storageService: ref.watch(storageServiceProvider),
  );
}

@riverpod
TransactionRepository transactionRepository(Ref ref) {
  return TransactionRepositoryImpl(
    ref.watch(transactionRemoteDataSourceProvider),
    ref.watch(transactionLocalDataSourceProvider),
  );
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
  StreamSubscription? _driftSub;

  @override
  FutureOr<List<Transaction>> build() async {
    final token = await ref.read(storageServiceProvider).getToken();
    final userId = await ref.read(storageServiceProvider).getUserId();

    if (userId != null) {
      final transactionDao = ref.watch(transactionDaoProvider);
      _driftSub?.cancel();
      bool isFirstEmit = true;
      _driftSub = transactionDao.watchTransactionsWithCategory(userId).listen((items) {
        state = AsyncData(items.map((row) {
          final t = row.transaction;
          final c = row.category;
          return Transaction(
            id: t.id,
            type: t.type,
            amount: t.amount,
            title: t.title,
            note: t.note,
            paymentMethod: t.paymentMethod,
            date: t.date,
            categoryId: t.categoryId,
            categoryName: c?.name ?? '',
            categoryIcon: c?.icon ?? 'category',
            categoryColor: c?.color ?? '#3D5CFF',
            createdAt: t.createdAt,
            updatedAt: t.updatedAt,
          );
        }).toList());

        if (!isFirstEmit) {
          _invalidateDependents();
        }
        isFirstEmit = false;
      });
      ref.onDispose(() => _driftSub?.cancel());
    }

    if (token == null) return [];
    
    final repository = ref.watch(transactionRepositoryProvider);
    return await repository.getTransactions(token);
  }

  void _invalidateDependents() {
    Future.microtask(() {
      ref.invalidate(insightsProvider);
      ref.invalidate(spendingAnomalyProvider);
      ref.invalidate(monthlyForecastProvider);
      ref.invalidate(dashboardProvider);
      ref.invalidate(budgetProvider);
    });
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

      if (state.hasValue) {
        state = AsyncData(
          state.value!
              .map((t) => t.id == transactionId ? updated : t)
              .toList(),
        );
      }
      _invalidateDependents();
      return updated;
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).clearAuth();
        ref.read(authStateProvider.notifier).state = false;
      }
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> deleteTransaction(String idToken, String transactionId) async {
    try {
      await ref.read(deleteTransactionProvider)(idToken, transactionId);
      if (state.hasValue) {
        state = AsyncData(
          state.value!.where((t) => t.id != transactionId).toList(),
        );
      }
      _invalidateDependents();
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).clearAuth();
        ref.read(authStateProvider.notifier).state = false;
      }
      state = AsyncError(e, st);
      rethrow;
    }
  }
}
