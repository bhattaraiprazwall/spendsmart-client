import 'dart:async';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:spendsmart/core/database/app_database.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';
import 'package:spendsmart/features/category/data/datasources/category_local_data_source.dart';
import 'package:spendsmart/features/category/data/datasources/category_remote_data_source.dart';
import 'package:spendsmart/features/category/domain/entities/category.dart';
import 'package:spendsmart/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;
  final CategoryLocalDataSource _localDataSource;

  CategoryRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  Category _toDomain(LocalCategory row) {
    return Category(
      id: row.id,
      name: row.name,
      icon: row.icon,
      color: row.color,
      isDefault: row.isDefault,
      type: row.type,
      canonicalKey: row.canonicalKey,
    );
  }

  void _fetchAndCacheRemote(String idToken, String? userId, String? type) {
    _remoteDataSource.getCategories(idToken, type: type).then((models) {
      _localDataSource.cacheRemoteCategories(userId, models);
    }).catchError((_) {
      // Ignored in background
    });
  }

  @override
  Future<List<Category>> getCategories(
    String idToken, {
    String? type,
  }) async {
    final userId = await _localDataSource.getUserId();

    // 1. Check local SQLite cache first
    final local = await _localDataSource.getCategories(userId);
    if (local.isNotEmpty) {
      _fetchAndCacheRemote(idToken, userId, type);
      final filtered = type == null
          ? local
          : local.where((c) => c.type == type).toList();
      return filtered.map(_toDomain).toList();
    }

    // 2. Fetch remote if local is empty
    try {
      final models = await _remoteDataSource.getCategories(idToken, type: type);
      await _localDataSource.cacheRemoteCategories(userId, models);
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      if (local.isNotEmpty) {
        return local.map(_toDomain).toList();
      }
      return [];
    }
  }

  @override
  Future<Category> createCategory(
    String idToken, {
    required String name,
    required String icon,
    required String color,
    String type = 'EXPENSE',
  }) async {
    final userId = await _localDataSource.getUserId();
    final localId = const Uuid().v4();
    final now = DateTime.now();

    // 1. Insert into SQLite immediately
    await _localDataSource.insertCategory(
      LocalCategoriesCompanion(
        id: Value(localId),
        name: Value(name),
        icon: Value(icon),
        color: Value(color),
        canonicalKey: const Value(null),
        isDefault: const Value(false),
        type: Value(type),
        userId: Value(userId),
        createdAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pendingCreate),
      ),
    );

    final localCategory = Category(
      id: localId,
      name: name,
      icon: icon,
      color: color,
      isDefault: false,
      type: type,
    );

    // 2. Push remote in background
    _remoteDataSource
        .createCategory(
          idToken,
          name: name,
          icon: icon,
          color: color,
          type: type,
        )
        .then((remoteModel) async {
          if (remoteModel.id != localId) {
            await _localDataSource.deleteCategory(localId);
            await _localDataSource.insertCategory(
              LocalCategoriesCompanion(
                id: Value(remoteModel.id),
                name: Value(remoteModel.name),
                icon: Value(remoteModel.icon),
                color: Value(remoteModel.color),
                canonicalKey: const Value(null),
                isDefault: Value(remoteModel.isDefault),
                type: Value(remoteModel.type),
                userId: Value(userId),
                createdAt: Value(now),
                updatedAt: Value(now),
                syncStatus: const Value(SyncStatus.synced),
              ),
            );
          } else {
            await _localDataSource.markSynced(localId);
          }
        })
        .catchError((_) {
          // Stays pendingCreate for SyncEngine
        });

    return localCategory;
  }

  @override
  Future<Category> updateCategory(
    String idToken,
    String categoryId, {
    required String name,
    required String icon,
    required String color,
    String? type,
  }) async {
    final existing = await _localDataSource.getCategoryById(categoryId);
    final now = DateTime.now();

    if (existing != null) {
      await _localDataSource.updateCategory(
        LocalCategoriesCompanion(
          id: Value(categoryId),
          name: Value(name),
          icon: Value(icon),
          color: Value(color),
          canonicalKey: Value(existing.canonicalKey),
          isDefault: Value(existing.isDefault),
          type: Value(type ?? existing.type),
          userId: Value(existing.userId),
          createdAt: Value(existing.createdAt),
          updatedAt: Value(now),
          syncStatus: Value(
            existing.syncStatus == SyncStatus.pendingCreate
                ? SyncStatus.pendingCreate
                : SyncStatus.pendingUpdate,
          ),
        ),
      );
    }

    final updatedLocal = Category(
      id: categoryId,
      name: name,
      icon: icon,
      color: color,
      isDefault: existing?.isDefault ?? false,
      type: type ?? existing?.type ?? 'EXPENSE',
      canonicalKey: existing?.canonicalKey,
    );

    _remoteDataSource
        .updateCategory(
          idToken,
          categoryId,
          name: name,
          icon: icon,
          color: color,
          type: type,
        )
        .then((remoteModel) async {
          await _localDataSource.markSynced(categoryId);
        })
        .catchError((_) {
          // Stays pendingUpdate for SyncEngine
        });

    return updatedLocal;
  }

  @override
  Future<void> deleteCategory(String idToken, String categoryId) async {
    await _localDataSource.deleteCategory(categoryId);

    _remoteDataSource.deleteCategory(idToken, categoryId).catchError((_) {
      // Background failure
    });
  }
}
