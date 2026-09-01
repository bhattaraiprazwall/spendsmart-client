import 'package:spendsmart/features/category/domain/entities/category.dart';
import 'package:spendsmart/features/category/domain/repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository _repository;

  GetCategories(this._repository);

  Future<List<Category>> call(String idToken, {String? type}) {
    return _repository.getCategories(idToken, type: type);
  }
}
