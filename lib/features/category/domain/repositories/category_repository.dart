import 'package:spendsmart/features/category/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories(
    String idToken, {
    String? type,
  });

  Future<Category> createCategory(
    String idToken, {
    required String name,
    required String icon,
    required String color,
    String type = 'EXPENSE',
  });

  Future<Category> updateCategory(
    String idToken,
    String categoryId, {
    required String name,
    required String icon,
    required String color,
    String? type,
  });

  Future<void> deleteCategory(String idToken, String categoryId);
}
