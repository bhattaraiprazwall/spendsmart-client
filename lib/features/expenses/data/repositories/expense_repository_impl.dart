import 'dart:async';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:spendsmart/core/database/app_database.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';
import 'package:spendsmart/features/expenses/data/datasources/expense_local_data_source.dart';
import 'package:spendsmart/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:spendsmart/features/expenses/domain/entities/expense.dart';
import 'package:spendsmart/features/expenses/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteDataSource _remoteDataSource;
  final ExpenseLocalDataSource _localDataSource;

  ExpenseRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Expense> createExpense(
    String idToken, {
    required String type,
    required double amount,
    required String title,
    String? note,
    required String paymentMethod,
    required String date,
    required String categoryId,
  }) async {
    final userId = await _localDataSource.getUserId() ?? '';
    final localId = const Uuid().v4();
    final now = DateTime.now();
    final parsedDate = DateTime.tryParse(date) ?? now;

    // 1. Fetch category from local data source for instant UI display
    final category = await _localDataSource.getCategoryById(categoryId);

    // 2. Insert immediately into local SQLite database
    await _localDataSource.insertTransaction(
      LocalTransactionsCompanion(
        id: Value(localId),
        userId: Value(userId),
        type: Value(type),
        amount: Value(amount),
        title: Value(title),
        note: Value(note),
        paymentMethod: Value(paymentMethod),
        date: Value(parsedDate),
        categoryId: Value(categoryId),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pendingCreate),
      ),
    );

    final localExpense = Expense(
      id: localId,
      type: type,
      amount: amount,
      title: title,
      note: note,
      paymentMethod: paymentMethod,
      date: parsedDate,
      categoryId: categoryId,
      categoryName: category?.name ?? '',
      categoryIcon: category?.icon ?? 'category',
      categoryColor: category?.color ?? '#3D5CFF',
      createdAt: now,
      updatedAt: now,
    );

    // 3. Attempt remote push in background
    _remoteDataSource
        .createExpense(
          idToken,
          type: type,
          amount: amount,
          title: title,
          note: note,
          paymentMethod: paymentMethod,
          date: date,
          categoryId: categoryId,
        )
        .then((remoteModel) async {
          if (remoteModel.id != localId) {
            await _localDataSource.hardDeleteTransaction(localId);
            await _localDataSource.insertTransaction(
              LocalTransactionsCompanion(
                id: Value(remoteModel.id),
                userId: Value(userId),
                type: Value(remoteModel.type),
                amount: Value(remoteModel.amount),
                title: Value(remoteModel.title),
                note: Value(remoteModel.note),
                paymentMethod: Value(remoteModel.paymentMethod),
                date: Value(remoteModel.date),
                categoryId: Value(remoteModel.categoryId),
                createdAt: Value(remoteModel.createdAt),
                updatedAt: Value(remoteModel.updatedAt),
                syncStatus: const Value(SyncStatus.synced),
                lastSyncedAt: Value(DateTime.now()),
              ),
            );
          } else {
            await _localDataSource.markSynced(localId);
          }
        })
        .catchError((_) {
          // If offline, stays pendingCreate for background sync engine
        });

    return localExpense;
  }

  @override
  Future<List<Expense>> getExpenses(String idToken) async {
    final userId = await _localDataSource.getUserId();

    // Check local SQLite first
    if (userId != null) {
      final local = await _localDataSource.getTransactionsWithCategory(userId);
      final expenseList = local
          .where((t) => t.transaction.type == 'EXPENSE')
          .map((item) {
            final t = item.transaction;
            final c = item.category;
            return Expense(
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
          })
          .toList();

      if (expenseList.isNotEmpty) {
        return expenseList;
      }
    }

    // Remote fallback
    final models = await _remoteDataSource.getExpenses(idToken);
    return models.map((m) => m.toEntity()).toList();
  }
}
