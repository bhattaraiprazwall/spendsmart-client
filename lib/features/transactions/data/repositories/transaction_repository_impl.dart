import 'dart:async';
import 'package:drift/drift.dart';
import 'package:spendsmart/core/database/app_database.dart';
import 'package:spendsmart/core/database/daos/transaction_dao.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';
import 'package:spendsmart/features/transactions/data/datasources/transaction_local_data_source.dart';
import 'package:spendsmart/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:spendsmart/features/transactions/domain/entities/transaction.dart';
import 'package:spendsmart/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;
  final TransactionLocalDataSource _localDataSource;

  TransactionRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  Transaction _toDomain(TransactionWithCategory item) {
    final t = item.transaction;
    final c = item.category;
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
  }

  Transaction _localToDomain(LocalTransaction t, LocalCategory? c) {
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
  }

  void _fetchAndCacheRemote(String idToken, String userId) {
    _remoteDataSource.getTransactions(idToken).then((models) {
      _localDataSource.cacheRemoteTransactions(userId, models);
    }).catchError((_) {
      // Background cache failure is safely ignored
    });
  }

  @override
  Future<List<Transaction>> getTransactions(String idToken) async {
    final userId = await _localDataSource.getUserId();

    // 1. Check local SQLite cache first for instant response
    if (userId != null) {
      final local = await _localDataSource.getTransactionsWithCategory(userId);
      if (local.isNotEmpty) {
        // Trigger background remote refresh
        _fetchAndCacheRemote(idToken, userId);
        return local.map(_toDomain).toList();
      }
    }

    // 2. Fetch remote if local is empty
    try {
      final models = await _remoteDataSource.getTransactions(idToken);
      if (userId != null) {
        await _localDataSource.cacheRemoteTransactions(userId, models);
      }
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      if (userId != null) {
        final fallback = await _localDataSource.getTransactionsWithCategory(userId);
        if (fallback.isNotEmpty) {
          return fallback.map(_toDomain).toList();
        }
      }
      return [];
    }
  }

  @override
  Future<Transaction> updateTransaction(
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
    final existing = await _localDataSource.getTransactionById(transactionId);
    final now = DateTime.now();

    // 1. Immediately update locally in SQLite
    if (existing != null) {
      final isPendingCreate = existing.syncStatus == SyncStatus.pendingCreate;
      await _localDataSource.updateTransaction(
        LocalTransactionsCompanion(
          id: Value(transactionId),
          userId: Value(existing.userId),
          type: Value(type ?? existing.type),
          amount: Value(amount ?? existing.amount),
          title: Value(title ?? existing.title),
          note: Value(note ?? existing.note),
          paymentMethod: Value(paymentMethod ?? existing.paymentMethod),
          date: Value(date != null ? (DateTime.tryParse(date) ?? existing.date) : existing.date),
          categoryId: Value(categoryId ?? existing.categoryId),
          createdAt: Value(existing.createdAt),
          updatedAt: Value(now),
          syncStatus: Value(isPendingCreate ? SyncStatus.pendingCreate : SyncStatus.pendingUpdate),
        ),
      );
    }

    // 2. Attempt remote update
    try {
      final model = await _remoteDataSource.updateTransaction(
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
      await _localDataSource.markSynced(transactionId);
      return model.toEntity();
    } catch (e) {
      // If offline or network error, return local state without throwing!
      final updatedLocal = await _localDataSource.getTransactionById(transactionId);
      if (updatedLocal != null) {
        final cat = await _localDataSource.getCategoryById(updatedLocal.categoryId);
        return _localToDomain(updatedLocal, cat);
      }
      rethrow;
    }
  }

  @override
  Future<void> deleteTransaction(String idToken, String transactionId) async {
    final existing = await _localDataSource.getTransactionById(transactionId);

    if (existing != null && existing.syncStatus == SyncStatus.pendingCreate) {
      // Record was created offline and never pushed; hard delete locally
      await _localDataSource.hardDeleteTransaction(transactionId);
      return;
    }

    // Mark soft deleted so UI removes it immediately
    await _localDataSource.softDeleteTransaction(transactionId);

    // Attempt remote deletion
    try {
      await _remoteDataSource.deleteTransaction(idToken, transactionId);
      await _localDataSource.hardDeleteTransaction(transactionId);
    } catch (e) {
      // Remains pendingDelete in SQLite for background sync
    }
  }
}
