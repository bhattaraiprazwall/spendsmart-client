import 'package:spendsmart/features/category/data/datasources/category_remote_datasource.dart';
import 'package:spendsmart/features/category/domain/entities/category.dart';
import 'package:spendsmart/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Category>> getCategories(
    String idToken, {
    String? type,
  }) async {
    final models = await _remoteDataSource.getCategories(idToken, type: type);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Category> createCategory(
    String idToken, {
    required String name,
    required String icon,
    required String color,
    String type = 'EXPENSE',
  }) async {
    final model = await _remoteDataSource.createCategory(
      idToken,
      name: name,
      icon: icon,
      color: color,
      type: type,
    );
    return model.toEntity();
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
    final model = await _remoteDataSource.updateCategory(
      idToken,
      categoryId,
      name: name,
      icon: icon,
      color: color,
      type: type,
    );
    return model.toEntity();
  }

  @override
  Future<void> deleteCategory(String idToken, String categoryId) {
    return _remoteDataSource.deleteCategory(idToken, categoryId);
  }
}
