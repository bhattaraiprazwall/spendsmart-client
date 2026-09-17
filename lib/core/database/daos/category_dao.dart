import 'package:drift/drift.dart';
import 'package:spendsmart/core/database/app_database.dart';
import 'package:spendsmart/core/database/tables/local_categories.dart';
import 'package:spendsmart/core/database/tables/sync_status.dart';

part 'category_dao.g.dart';

@DriftAccessor(tables: [LocalCategories])
class CategoryDao extends DatabaseAccessor<AppDatabase> with _$CategoryDaoMixin {
  CategoryDao(super.db);

  /// Watch all categories accessible to this user (defaults + user custom)
  Stream<List<LocalCategory>> watchCategories(String? userId) {
    return (select(localCategories)
          ..where((tbl) => tbl.isDefault.equals(true) | (userId != null ? tbl.userId.equals(userId) : const Constant(false)))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .watch();
  }

  /// Get list of categories
  Future<List<LocalCategory>> getCategories(String? userId) {
    return (select(localCategories)
          ..where((tbl) => tbl.isDefault.equals(true) | (userId != null ? tbl.userId.equals(userId) : const Constant(false)))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)]))
        .get();
  }

  /// Get category by ID
  Future<LocalCategory?> getCategoryById(String id) {
    return (select(localCategories)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  /// Insert or replace category
  Future<int> insertCategory(LocalCategoriesCompanion category) {
    return into(localCategories).insertOnConflictUpdate(category);
  }

  /// Batch insert categories
  Future<void> insertCategories(List<LocalCategoriesCompanion> categories) async {
    await batch((b) {
      b.insertAllOnConflictUpdate(localCategories, categories);
    });
  }

  /// Update existing category
  Future<bool> updateCategory(LocalCategoriesCompanion category) {
    return update(localCategories).replace(category);
  }

  /// Delete category
  Future<int> deleteCategory(String id) {
    return (delete(localCategories)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Get pending sync categories
  Future<List<LocalCategory>> getPendingSync() {
    return (select(localCategories)
          ..where((tbl) => tbl.syncStatus.isNotValue(SyncStatus.synced.index)))
        .get();
  }

  /// Mark category as synced
  Future<int> markSynced(String id) {
    return (update(localCategories)..where((tbl) => tbl.id.equals(id))).write(
      const LocalCategoriesCompanion(
        syncStatus: Value(SyncStatus.synced),
      ),
    );
  }
}
