import 'package:drift/drift.dart';
import 'package:spendsmart/core/database/app_database.dart';
import 'package:spendsmart/core/database/daos/category_dao.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';
import 'package:spendsmart/core/services/local_storage_service.dart';
import 'package:spendsmart/features/category/data/models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<List<LocalCategory>> getCategories(String? userId);
  Future<LocalCategory?> getCategoryById(String id);
  Future<int> insertCategory(LocalCategoriesCompanion companion);
  Future<void> insertCategories(List<LocalCategoriesCompanion> companions);
  Future<bool> updateCategory(LocalCategoriesCompanion companion);
  Future<int> deleteCategory(String id);
  Future<void> markSynced(String id);
  Future<String?> getUserId();
  Future<void> cacheRemoteCategories(String? userId, List<CategoryModel> models);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final CategoryDao _categoryDao;
  final LocalStorageService _storageService;

  CategoryLocalDataSourceImpl({
    required CategoryDao categoryDao,
    required LocalStorageService storageService,
  })  : _categoryDao = categoryDao,
        _storageService = storageService;

  @override
  Future<List<LocalCategory>> getCategories(String? userId) {
    return _categoryDao.getCategories(userId);
  }

  @override
  Future<LocalCategory?> getCategoryById(String id) {
    return _categoryDao.getCategoryById(id);
  }

  @override
  Future<int> insertCategory(LocalCategoriesCompanion companion) {
    return _categoryDao.insertCategory(companion);
  }

  @override
  Future<void> insertCategories(List<LocalCategoriesCompanion> companions) {
    return _categoryDao.insertCategories(companions);
  }

  @override
  Future<bool> updateCategory(LocalCategoriesCompanion companion) {
    return _categoryDao.updateCategory(companion);
  }

  @override
  Future<int> deleteCategory(String id) {
    return _categoryDao.deleteCategory(id);
  }

  @override
  Future<void> markSynced(String id) {
    return _categoryDao.markSynced(id);
  }

  @override
  Future<String?> getUserId() {
    return _storageService.getUserId();
  }

  @override
  Future<void> cacheRemoteCategories(String? userId, List<CategoryModel> models) async {
    final companions = models.map((m) {
      return LocalCategoriesCompanion(
        id: Value(m.id),
        name: Value(m.name),
        icon: Value(m.icon),
        color: Value(m.color),
        canonicalKey: const Value(null),
        isDefault: Value(m.isDefault),
        type: Value(m.type),
        userId: Value(userId),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        syncStatus: const Value(SyncStatus.synced),
      );
    }).toList();

    await _categoryDao.insertCategories(companions);
  }
}
