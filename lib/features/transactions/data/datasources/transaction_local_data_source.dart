import 'dart:async';
import 'package:drift/drift.dart';
import 'package:spendsmart/core/database/app_database.dart';
import 'package:spendsmart/core/database/daos/category_dao.dart';
import 'package:spendsmart/core/database/daos/transaction_dao.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';
import 'package:spendsmart/features/transactions/data/models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Stream<List<TransactionWithCategory>> watchTransactionsWithCategory(String userId);
  Future<List<TransactionWithCategory>> getTransactionsWithCategory(String userId);
  Future<LocalTransaction?> getTransactionById(String id);
  Future<LocalCategory?> getCategoryById(String id);
  Future<int> insertTransaction(LocalTransactionsCompanion transaction);
  Future<bool> updateTransaction(LocalTransactionsCompanion transaction);
  Future<int> softDeleteTransaction(String id);
  Future<int> hardDeleteTransaction(String id);
  Future<void> markSynced(String id);
  Future<void> cacheRemoteTransactions(String userId, List<TransactionModel> models);
  Future<String?> getUserId();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final TransactionDao _transactionDao;
  final CategoryDao _categoryDao;
  final LocalStorageService _storageService;

  TransactionLocalDataSourceImpl({
    required TransactionDao transactionDao,
    required CategoryDao categoryDao,
    required LocalStorageService storageService,
  })  : _transactionDao = transactionDao,
        _categoryDao = categoryDao,
        _storageService = storageService;

  @override
  Stream<List<TransactionWithCategory>> watchTransactionsWithCategory(String userId) {
    return _transactionDao.watchTransactionsWithCategory(userId);
  }

  @override
  Future<List<TransactionWithCategory>> getTransactionsWithCategory(String userId) {
    return _transactionDao.getTransactionsWithCategory(userId);
  }

  @override
  Future<LocalTransaction?> getTransactionById(String id) {
    return _transactionDao.getTransactionById(id);
  }

  @override
  Future<LocalCategory?> getCategoryById(String id) {
    return _categoryDao.getCategoryById(id);
  }

  @override
  Future<int> insertTransaction(LocalTransactionsCompanion transaction) {
    return _transactionDao.insertTransaction(transaction);
  }

  @override
  Future<bool> updateTransaction(LocalTransactionsCompanion transaction) {
    return _transactionDao.updateTransaction(transaction);
  }

  @override
  Future<int> softDeleteTransaction(String id) {
    return _transactionDao.softDeleteTransaction(id);
  }

  @override
  Future<int> hardDeleteTransaction(String id) {
    return _transactionDao.hardDeleteTransaction(id);
  }

  @override
  Future<void> markSynced(String id) {
    return _transactionDao.markSynced(id);
  }

  @override
  Future<String?> getUserId() {
    return _storageService.getUserId();
  }

  @override
  Future<void> cacheRemoteTransactions(String userId, List<TransactionModel> models) async {
    for (final m in models) {
      await _transactionDao.insertTransaction(
        LocalTransactionsCompanion(
          id: Value(m.id),
          userId: Value(userId),
          type: Value(m.type),
          amount: Value(m.amount),
          title: Value(m.title),
          note: Value(m.note),
          paymentMethod: Value(m.paymentMethod),
          date: Value(m.date),
          categoryId: Value(m.categoryId),
          createdAt: Value(m.createdAt),
          updatedAt: Value(m.updatedAt),
          syncStatus: const Value(SyncStatus.synced),
          lastSyncedAt: Value(DateTime.now()),
        ),
      );

      if (m.categoryId.isNotEmpty && m.categoryName.isNotEmpty) {
        await _categoryDao.insertCategory(
          LocalCategoriesCompanion(
            id: Value(m.categoryId),
            name: Value(m.categoryName),
            icon: Value(m.categoryIcon),
            color: Value(m.categoryColor),
            isDefault: const Value(false),
            type: Value(m.type),
            userId: Value(userId),
            syncStatus: const Value(SyncStatus.synced),
          ),
        );
      }
    }
  }
}
