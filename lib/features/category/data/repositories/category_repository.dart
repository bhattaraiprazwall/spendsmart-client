import 'package:spendsmart/features/category/data/models/category_model.dart';
import 'package:spendsmart/features/category/data/services/category_service.dart';

class CategoryRepository {
  final CategoryService _categoryService = CategoryService();

  Future<List<CategoryModel>> getCategories(
    String idToken, {
    String? type,
  }) async {
    return await _categoryService.getCategories(idToken, type: type);
  }

  Future<CategoryModel> createCategory(
    String idToken, {
    required String name,
    required String icon,
    required String color,
    String type = 'EXPENSE',
  }) async {
    return await _categoryService.createCategory(
      idToken,
      name: name,
      icon: icon,
      color: color,
      type: type,
    );
  }

  Future<CategoryModel> updateCategory(
    String idToken,
    String categoryId, {
    required String name,
    required String icon,
    required String color,
    String? type,
  }) async {
    return await _categoryService.updateCategory(
      idToken,
      categoryId,
      name: name,
      icon: icon,
      color: color,
      type: type,
    );
  }

  Future<void> deleteCategory(String idToken, String categoryId) async {
    return await _categoryService.deleteCategory(idToken, categoryId);
  }
}
