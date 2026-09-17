// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_dao.dart';

// ignore_for_file: type=lint
mixin _$TransactionDaoMixin on DatabaseAccessor<AppDatabase> {
  $LocalTransactionsTable get localTransactions =>
      attachedDatabase.localTransactions;
  $LocalCategoriesTable get localCategories => attachedDatabase.localCategories;
  TransactionDaoManager get managers => TransactionDaoManager(this);
}

class TransactionDaoManager {
  final _$TransactionDaoMixin _db;
  TransactionDaoManager(this._db);
  $$LocalTransactionsTableTableManager get localTransactions =>
      $$LocalTransactionsTableTableManager(
        _db.attachedDatabase,
        _db.localTransactions,
      );
  $$LocalCategoriesTableTableManager get localCategories =>
      $$LocalCategoriesTableTableManager(
        _db.attachedDatabase,
        _db.localCategories,
      );
}
