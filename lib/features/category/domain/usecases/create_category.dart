import 'package:spendsmart/features/category/domain/entities/category.dart';
import 'package:spendsmart/features/category/domain/repositories/category_repository.dart';

class CreateCategory {
  final CategoryRepository _repository;

  CreateCategory(this._repository);

  Future<Category> call(
    String idToken, {
    required String name,
    required String icon,
    required String color,
    String type = 'EXPENSE',
  }) {
    return _repository.createCategory(
      idToken,
      name: name,
      icon: icon,
      color: color,
      type: type,
    );
  }
}
