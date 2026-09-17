import 'dart:async';
import 'package:drift/drift.dart';
import 'package:spendsmart/core/database/app_database.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';
import 'package:spendsmart/core/services/connectivity_service.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';
import 'package:spendsmart/features/budget/data/datasources/budget_remote_data_source.dart';
import 'package:spendsmart/features/category/data/datasources/category_remote_data_source.dart';
import 'package:spendsmart/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:spendsmart/features/incomes/data/datasources/income_remote_data_source.dart';
import 'package:spendsmart/features/transactions/data/datasources/transaction_remote_data_source.dart';
import 'package:spendsmart/features/transactions/data/models/transaction_model.dart';

class SyncEngine {
  final AppDatabase _db;
  final TransactionRemoteDataSource _transactionRemote;
  final ExpenseRemoteDataSource _expenseRemote;
  final IncomeRemoteDataSource _incomeRemote;
  final CategoryRemoteDataSource _categoryRemote;
  final BudgetRemoteDataSource _budgetRemote;
  final ConnectivityService _connectivity;
  final LocalStorageService _storage;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  DateTime? _lastSyncTime;
  DateTime? get lastSyncTime => _lastSyncTime;

  StreamSubscription? _connectivitySub;

  SyncEngine(
    this._db,
    this._transactionRemote,
    this._expenseRemote,
    this._incomeRemote,
    this._categoryRemote,
    this._budgetRemote,
    this._connectivity,
    this._storage,
  ) {
    _initListener();
  }

  void _initListener() {
    _connectivitySub = _connectivity.onConnectivityChanged.listen((isOnline) {
      if (isOnline) {
        syncAll();
      }
    });
  }

  /// Triggers full synchronization (Push pending mutations then Pull remote state)
  Future<void> syncAll() async {
    if (_isSyncing) return;

    final isOnline = await _connectivity.checkConnection();
    if (!isOnline) return;

    final idToken = await _storage.getToken();
    final userId = await _storage.getUserId();
    if (idToken == null || userId == null) return;

    _isSyncing = true;

    try {
      // 1. Push pending local mutations to backend
      await _pushPendingCategories(idToken, userId);
      await _pushPendingBudgets(idToken, userId);
      await _pushPendingTransactions(idToken, userId);

      // 2. Pull remote updates and reconcile with local database
      await _pullRemoteTransactions(idToken, userId);

      _lastSyncTime = DateTime.now();
    } catch (_) {
      // Background sync errors are safely caught and will retry on next sweep
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _pushPendingCategories(String idToken, String userId) async {
    final pending = await _db.categoryDao.getPendingSync();
    for (final item in pending) {
      try {
        if (item.syncStatus == SyncStatus.pendingCreate) {
          final remote = await _categoryRemote.createCategory(
            idToken,
            name: item.name,
            icon: item.icon,
            color: item.color,
            type: item.type,
          );
          if (remote.id != item.id) {
            await _db.categoryDao.deleteCategory(item.id);
            await _db.categoryDao.insertCategory(
              LocalCategoriesCompanion(
                id: Value(remote.id),
                name: Value(remote.name),
                icon: Value(remote.icon),
                color: Value(remote.color),
                canonicalKey: const Value(null),
                isDefault: Value(remote.isDefault),
                type: Value(remote.type),
                userId: Value(userId),
                createdAt: Value(DateTime.now()),
                updatedAt: Value(DateTime.now()),
                syncStatus: const Value(SyncStatus.synced),
              ),
            );
          } else {
            await _db.categoryDao.markSynced(item.id);
          }
        } else if (item.syncStatus == SyncStatus.pendingUpdate) {
          await _categoryRemote.updateCategory(
            idToken,
            item.id,
            name: item.name,
            icon: item.icon,
            color: item.color,
            type: item.type,
          );
          await _db.categoryDao.markSynced(item.id);
        }
      } catch (_) {}
    }
  }

  Future<void> _pushPendingBudgets(String idToken, String userId) async {
    final pending = await _db.budgetDao.getPendingSync();
    for (final b in pending) {
      try {
        final limits = await _db.budgetDao.getBudgetCategories(b.id);
        final catPayload = limits.map((l) => {'categoryId': l.categoryId, 'limit': l.limit}).toList();
        final remote = await _budgetRemote.createOrUpdateBudget(
          idToken,
          month: b.month,
          year: b.year,
          totalAmount: b.totalAmount,
          categories: catPayload.isNotEmpty ? catPayload : null,
        );
        if (remote.id != b.id) {
          await (_db.budgetDao.delete(_db.budgetDao.localBudgets)..where((tbl) => tbl.id.equals(b.id))).go();
          await _db.budgetDao.insertBudget(
            LocalBudgetsCompanion(
              id: Value(remote.id),
              userId: Value(userId),
              month: Value(remote.month),
              year: Value(remote.year),
              totalAmount: Value(double.tryParse(remote.totalAmount) ?? b.totalAmount),
              createdAt: Value(DateTime.now()),
              updatedAt: Value(DateTime.now()),
              syncStatus: const Value(SyncStatus.synced),
            ),
          );
        } else {
          await _db.budgetDao.markSynced(b.id);
        }
      } catch (_) {}
    }
  }

  /// Push pending creates, updates, and deletes to the backend API
  Future<void> _pushPendingTransactions(String idToken, String userId) async {
    final pending = await _db.transactionDao.getPendingSync();

    for (final item in pending) {
      try {
        switch (item.syncStatus) {
          case SyncStatus.pendingCreate:
            if (item.type == 'EXPENSE') {
              final remoteModel = await _expenseRemote.createExpense(
                idToken,
                type: item.type,
                amount: item.amount,
                title: item.title,
                note: item.note,
                paymentMethod: item.paymentMethod,
                date: item.date.toIso8601String(),
                categoryId: item.categoryId,
              );

              if (remoteModel.id != item.id) {
                await _db.transactionDao.hardDeleteTransaction(item.id);
                await _db.transactionDao.insertTransaction(
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
                await _db.transactionDao.markSynced(item.id);
              }
            } else {
              // INCOME
              final remoteModel = await _incomeRemote.createIncome(
                idToken,
                type: item.type,
                amount: item.amount,
                title: item.title,
                note: item.note,
                date: item.date.toIso8601String(),
                categoryId: item.categoryId,
              );

              if (remoteModel.id != item.id) {
                await _db.transactionDao.hardDeleteTransaction(item.id);
                await _db.transactionDao.insertTransaction(
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
                await _db.transactionDao.markSynced(item.id);
              }
            }
            break;

          case SyncStatus.pendingUpdate:
            await _transactionRemote.updateTransaction(
              idToken,
              item.id,
              type: item.type,
              amount: item.amount,
              title: item.title,
              note: item.note,
              paymentMethod: item.paymentMethod,
              date: item.date.toIso8601String(),
              categoryId: item.categoryId,
            );
            await _db.transactionDao.markSynced(item.id);
            break;

          case SyncStatus.pendingDelete:
            await _transactionRemote.deleteTransaction(idToken, item.id);
            await _db.transactionDao.hardDeleteTransaction(item.id);
            break;

          case SyncStatus.synced:
          case SyncStatus.failed:
            break;
        }
      } catch (_) {
        // Leave record in its pending state for next sync attempt
      }
    }
  }

  /// Pull remote transactions and reconcile with local SQLite database using Last-Write-Wins (LWW)
  Future<void> _pullRemoteTransactions(String idToken, String userId) async {
    final List<TransactionModel> remoteList = await _transactionRemote.getTransactions(idToken);

    for (final remote in remoteList) {
      final local = await _db.transactionDao.getTransactionById(remote.id);

      if (local == null) {
        await _db.transactionDao.insertTransaction(
          LocalTransactionsCompanion(
            id: Value(remote.id),
            userId: Value(userId),
            type: Value(remote.type),
            amount: Value(remote.amount),
            title: Value(remote.title),
            note: Value(remote.note),
            paymentMethod: Value(remote.paymentMethod),
            date: Value(remote.date),
            categoryId: Value(remote.categoryId),
            createdAt: Value(remote.createdAt),
            updatedAt: Value(remote.updatedAt),
            syncStatus: const Value(SyncStatus.synced),
            lastSyncedAt: Value(DateTime.now()),
          ),
        );
      } else if (local.syncStatus == SyncStatus.synced) {
        if (remote.updatedAt.isAfter(local.updatedAt)) {
          await _db.transactionDao.insertTransaction(
            LocalTransactionsCompanion(
              id: Value(remote.id),
              userId: Value(userId),
              type: Value(remote.type),
              amount: Value(remote.amount),
              title: Value(remote.title),
              note: Value(remote.note),
              paymentMethod: Value(remote.paymentMethod),
              date: Value(remote.date),
              categoryId: Value(remote.categoryId),
              createdAt: Value(remote.createdAt),
              updatedAt: Value(remote.updatedAt),
              syncStatus: const Value(SyncStatus.synced),
              lastSyncedAt: Value(DateTime.now()),
            ),
          );
        }
      } else if (local.syncStatus == SyncStatus.pendingUpdate) {
        if (remote.updatedAt.isAfter(local.updatedAt)) {
          await _db.transactionDao.insertTransaction(
            LocalTransactionsCompanion(
              id: Value(remote.id),
              userId: Value(userId),
              type: Value(remote.type),
              amount: Value(remote.amount),
              title: Value(remote.title),
              note: Value(remote.note),
              paymentMethod: Value(remote.paymentMethod),
              date: Value(remote.date),
              categoryId: Value(remote.categoryId),
              createdAt: Value(remote.createdAt),
              updatedAt: Value(remote.updatedAt),
              syncStatus: const Value(SyncStatus.synced),
              lastSyncedAt: Value(DateTime.now()),
            ),
          );
        }
      }
    }
  }

  void dispose() {
    _connectivitySub?.cancel();
  }
}
