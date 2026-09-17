import 'dart:async';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:spendsmart/core/database/app_database.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';
import 'package:spendsmart/features/incomes/data/datasources/income_local_data_source.dart';
import 'package:spendsmart/features/incomes/data/datasources/income_remote_data_source.dart';
import 'package:spendsmart/features/incomes/domain/entities/income.dart';
import 'package:spendsmart/features/incomes/domain/repositories/income_repository.dart';

class IncomeRepositoryImpl implements IncomeRepository {
  final IncomeRemoteDataSource _remoteDataSource;
  final IncomeLocalDataSource _localDataSource;

  IncomeRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Income> createIncome(
    String idToken, {
    required String type,
    required double amount,
    required String title,
    String? note,
    required String date,
    required String categoryId,
  }) async {
    final userId = await _localDataSource.getUserId() ?? '';
    final localId = const Uuid().v4();
    final now = DateTime.now();
    final parsedDate = DateTime.tryParse(date) ?? now;

    // 1. Fetch category from local SQLite for instant UI display
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
        paymentMethod: const Value('CASH'),
        date: Value(parsedDate),
        categoryId: Value(categoryId),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pendingCreate),
      ),
    );

    final localIncome = Income(
      id: localId,
      type: type,
      amount: amount,
      title: title,
      note: note,
      paymentMethod: 'CASH',
      date: parsedDate,
      categoryId: categoryId,
      categoryName: category?.name ?? '',
      categoryIcon: category?.icon ?? 'category',
      categoryColor: category?.color ?? '#4CAF50',
      createdAt: now,
      updatedAt: now,
    );

    // 3. Attempt remote push in background
    _remoteDataSource
        .createIncome(
          idToken,
          type: type,
          amount: amount,
          title: title,
          note: note,
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

    return localIncome;
  }

  @override
  Future<List<Income>> getIncomes(String idToken) async {
    final userId = await _localDataSource.getUserId();

    // Check local SQLite first
    if (userId != null) {
      final local = await _localDataSource.getTransactionsWithCategory(userId);
      final incomeList = local
          .where((t) => t.transaction.type == 'INCOME')
          .map((item) {
            final t = item.transaction;
            final c = item.category;
            return Income(
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
              categoryColor: c?.color ?? '#4CAF50',
              createdAt: t.createdAt,
              updatedAt: t.updatedAt,
            );
          })
          .toList();

      if (incomeList.isNotEmpty) {
        return incomeList;
      }
    }

    // Remote fallback
    final models = await _remoteDataSource.getIncomes(idToken);
    return models.map((m) => m.toEntity()).toList();
  }
}
