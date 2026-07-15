import 'package:spendsmart/features/category/data/models/category_model.dart';
import 'package:spendsmart/features/category/data/services/category_service.dart';

class CategoryRepository {
  final CategoryService _categoryService = CategoryService();

  Future<List<CategoryModel>> getCategories(String idToken) async {
    return await _categoryService.getCategories(idToken);
  }

  Future<CategoryModel> createCategory(
    String idToken, {
    required String name,
    required String icon,
    required String color,
  }) async {
    return await _categoryService.createCategory(
      idToken,
      name: name,
      icon: icon,
      color: color,
    );
  }

  Future<CategoryModel> updateCategory(
    String idToken,
    String categoryId, {
    required String name,
    required String icon,
    required String color,
  }) async {
    return await _categoryService.updateCategory(
      idToken,
      categoryId,
      name: name,
      icon: icon,
      color: color,
    );
  }
}
