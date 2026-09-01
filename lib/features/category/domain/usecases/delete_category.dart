import 'package:spendsmart/features/category/domain/repositories/category_repository.dart';

class DeleteCategory {
  final CategoryRepository _repository;

  DeleteCategory(this._repository);

  Future<void> call(String idToken, String categoryId) {
    return _repository.deleteCategory(idToken, categoryId);
  }
}
