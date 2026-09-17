import 'package:drift/drift.dart';
import 'package:spendsmart/core/database/app_database.dart';
import 'package:spendsmart/core/database/tables/local_categories.dart';
import 'package:spendsmart/core/database/tables/local_transactions.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';

part 'transaction_dao.g.dart';

class TransactionWithCategory {
  final LocalTransaction transaction;
  final LocalCategory? category;

  TransactionWithCategory({required this.transaction, this.category});
}

@DriftAccessor(tables: [LocalTransactions, LocalCategories])
class TransactionDao extends DatabaseAccessor<AppDatabase> with _$TransactionDaoMixin {
  TransactionDao(super.db);

  /// Watch active transactions joined with category for a user
  Stream<List<TransactionWithCategory>> watchTransactionsWithCategory(String userId) {
    final query = select(localTransactions).join([
      leftOuterJoin(
        localCategories,
        localCategories.id.equalsExp(localTransactions.categoryId),
      ),
    ])
      ..where(localTransactions.userId.equals(userId) &
          localTransactions.syncStatus.isNotValue(SyncStatus.pendingDelete.index))
      ..orderBy([OrderingTerm.desc(localTransactions.date)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
          transaction: row.readTable(localTransactions),
          category: row.readTableOrNull(localCategories),
        );
      }).toList();
    });
  }

  /// Get active transactions joined with category
  Future<List<TransactionWithCategory>> getTransactionsWithCategory(String userId) async {
    final query = select(localTransactions).join([
      leftOuterJoin(
        localCategories,
        localCategories.id.equalsExp(localTransactions.categoryId),
      ),
    ])
      ..where(localTransactions.userId.equals(userId) &
          localTransactions.syncStatus.isNotValue(SyncStatus.pendingDelete.index))
      ..orderBy([OrderingTerm.desc(localTransactions.date)]);

    final rows = await query.get();
    return rows.map((row) {
      return TransactionWithCategory(
        transaction: row.readTable(localTransactions),
        category: row.readTableOrNull(localCategories),
      );
    }).toList();
  }

  /// Get single transaction by ID
  Future<LocalTransaction?> getTransactionById(String id) {
    return (select(localTransactions)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  /// Insert or replace transaction
  Future<int> insertTransaction(LocalTransactionsCompanion transaction) {
    return into(localTransactions).insertOnConflictUpdate(transaction);
  }

  /// Update existing transaction
  Future<bool> updateTransaction(LocalTransactionsCompanion transaction) {
    return update(localTransactions).replace(transaction);
  }

  /// Soft delete transaction for sync engine
  Future<int> softDeleteTransaction(String id) {
    return (update(localTransactions)..where((tbl) => tbl.id.equals(id))).write(
      LocalTransactionsCompanion(
        syncStatus: const Value(SyncStatus.pendingDelete),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Hard delete transaction once remote deletion is confirmed
  Future<int> hardDeleteTransaction(String id) {
    return (delete(localTransactions)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Get all pending sync transactions
  Future<List<LocalTransaction>> getPendingSync() {
    return (select(localTransactions)
          ..where((tbl) => tbl.syncStatus.isNotValue(SyncStatus.synced.index)))
        .get();
  }

  /// Mark transaction as successfully synced
  Future<int> markSynced(String id) {
    final now = DateTime.now();
    return (update(localTransactions)..where((tbl) => tbl.id.equals(id))).write(
      LocalTransactionsCompanion(
        syncStatus: const Value(SyncStatus.synced),
        lastSyncedAt: Value(now),
      ),
    );
  }

  /// Clear transactions for a user (e.g., on logout)
  Future<int> clearUserTransactions(String userId) {
    return (delete(localTransactions)..where((tbl) => tbl.userId.equals(userId))).go();
  }
}
