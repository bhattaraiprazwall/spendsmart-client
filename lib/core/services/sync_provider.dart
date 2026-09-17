import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/database/database_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/core/services/connectivity_service.dart';
import 'package:spendsmart/core/services/sync_engine.dart';
import 'package:spendsmart/features/budget/presentation/providers/budget_provider.dart';
import 'package:spendsmart/features/category/presentation/providers/category_provider.dart';
import 'package:spendsmart/features/expenses/presentation/providers/expense_provider.dart';
import 'package:spendsmart/features/incomes/presentation/providers/income_provider.dart';
import 'package:spendsmart/features/transactions/presentation/providers/transaction_provider.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  ref.onDispose(() => service.dispose());
  return service;
});

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final transactionRemote = ref.watch(transactionRemoteDataSourceProvider);
  final expenseRemote = ref.watch(expenseRemoteDataSourceProvider);
  final incomeRemote = ref.watch(incomeRemoteDataSourceProvider);
  final categoryRemote = ref.watch(categoryRemoteDataSourceProvider);
  final budgetRemote = ref.watch(budgetRemoteDataSourceProvider);
  final connectivity = ref.watch(connectivityServiceProvider);
  final storage = ref.watch(storageServiceProvider);

  final engine = SyncEngine(
    db,
    transactionRemote,
    expenseRemote,
    incomeRemote,
    categoryRemote,
    budgetRemote,
    connectivity,
    storage,
  );

  ref.onDispose(() => engine.dispose());
  return engine;
});

/// Stream provider for network connectivity status
final isOnlineProvider = StreamProvider<bool>((ref) {
  final connectivity = ref.watch(connectivityServiceProvider);
  return connectivity.onConnectivityChanged;
});
