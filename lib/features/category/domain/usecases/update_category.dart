import 'package:spendsmart/features/category/domain/entities/category.dart';
import 'package:spendsmart/features/category/domain/repositories/category_repository.dart';

class UpdateCategory {
  final CategoryRepository _repository;

  UpdateCategory(this._repository);

  Future<Category> call(
    String idToken,
    String categoryId, {
    required String name,
    required String icon,
    required String color,
    String? type,
  }) {
    return _repository.updateCategory(
      idToken,
      categoryId,
      name: name,
      icon: icon,
      color: color,
      type: type,
    );
  }
}
