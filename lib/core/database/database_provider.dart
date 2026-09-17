import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendsmart/core/database/app_database.dart';
import 'package:spendsmart/core/database/daos/budget_dao.dart';
import 'package:spendsmart/core/database/daos/category_dao.dart';
import 'package:spendsmart/core/database/daos/notification_dao.dart';
import 'package:spendsmart/core/database/daos/transaction_dao.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final transactionDaoProvider = Provider<TransactionDao>((ref) {
  return ref.watch(appDatabaseProvider).transactionDao;
});

final categoryDaoProvider = Provider<CategoryDao>((ref) {
  return ref.watch(appDatabaseProvider).categoryDao;
});

final budgetDaoProvider = Provider<BudgetDao>((ref) {
  return ref.watch(appDatabaseProvider).budgetDao;
});

final notificationDaoProvider = Provider<NotificationDao>((ref) {
  return ref.watch(appDatabaseProvider).notificationDao;
});
