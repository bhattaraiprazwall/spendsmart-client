import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'package:spendsmart/core/database/daos/budget_dao.dart';
import 'package:spendsmart/core/database/daos/category_dao.dart';
import 'package:spendsmart/core/database/daos/notification_dao.dart';
import 'package:spendsmart/core/database/daos/transaction_dao.dart';
import 'package:spendsmart/core/database/tables/local_budgets.dart';
import 'package:spendsmart/core/database/tables/local_categories.dart';
import 'package:spendsmart/core/database/tables/local_notifications.dart';
import 'package:spendsmart/core/database/tables/local_transactions.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    LocalTransactions,
    LocalCategories,
    LocalBudgets,
    LocalBudgetCategories,
    LocalNotifications,
  ],
  daos: [
    TransactionDao,
    CategoryDao,
    BudgetDao,
    NotificationDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.connection);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'spendsmart.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
