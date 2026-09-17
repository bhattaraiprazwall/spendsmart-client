import 'package:drift/drift.dart';
import 'package:spendsmart/core/database/app_database.dart';
import 'package:spendsmart/core/database/daos/category_dao.dart';
import 'package:spendsmart/core/database/daos/transaction_dao.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';
import 'package:spendsmart/features/incomes/data/models/income.dart';

abstract class IncomeLocalDataSource {
  Future<LocalCategory?> getCategoryById(String categoryId);
  Future<int> insertTransaction(LocalTransactionsCompanion transaction);
  Future<int> hardDeleteTransaction(String id);
  Future<void> markSynced(String id);
  Future<String?> getUserId();
  Future<List<TransactionWithCategory>> getTransactionsWithCategory(String userId);
  Future<void> cacheRemoteIncomes(String userId, List<IncomeModel> models);
}

class IncomeLocalDataSourceImpl implements IncomeLocalDataSource {
  final TransactionDao _transactionDao;
  final CategoryDao _categoryDao;
  final LocalStorageService _storageService;

  IncomeLocalDataSourceImpl({
    required TransactionDao transactionDao,
    required CategoryDao categoryDao,
    required LocalStorageService storageService,
  })  : _transactionDao = transactionDao,
        _categoryDao = categoryDao,
        _storageService = storageService;

  @override
  Future<LocalCategory?> getCategoryById(String categoryId) {
    return _categoryDao.getCategoryById(categoryId);
  }

  @override
  Future<int> insertTransaction(LocalTransactionsCompanion transaction) {
    return _transactionDao.insertTransaction(transaction);
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
  Future<List<TransactionWithCategory>> getTransactionsWithCategory(String userId) {
    return _transactionDao.getTransactionsWithCategory(userId);
  }

  @override
  Future<void> cacheRemoteIncomes(String userId, List<IncomeModel> models) async {
    for (final m in models) {
      await _transactionDao.insertTransaction(
        LocalTransactionsCompanion(
          id: Value(m.id),
          userId: Value(userId),
          type: Value(m.type),
          amount: Value(m.amount),
          title: Value(m.title),
          note: Value(m.note),
          paymentMethod: const Value('CASH'),
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
