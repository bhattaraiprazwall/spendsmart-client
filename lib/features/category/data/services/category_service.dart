import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/services/api_service.dart';
import 'package:spendsmart/features/category/data/models/category_model.dart';

class CategoryService {
  final ApiService _apiService = ApiService();

  Future<List<CategoryModel>> getCategories(String idToken) async {
    final response = await _apiService.get(
      ApiConstants.categories,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      },
    );

    if (response["statusCode"] != 200) {
      throw Exception(
        response["data"]["message"] ?? "Failed to fetch categories",
      );
    }

    final List<dynamic> categories =
        response["data"]["data"]["categories"] ?? [];
    return categories
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<CategoryModel> createCategory(
    String idToken, {
    required String name,
    required String icon,
    required String color,
  }) async {
    final response = await _apiService.post(
      ApiConstants.categories,
      {
        "name": name,
        "icon": icon,
        "color": color,
      },
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      },
    );

    if (response["statusCode"] != 201) {
      throw Exception(
        response["data"]["message"] ?? "Failed to create category",
      );
    }

    return CategoryModel.fromJson(response["data"]["data"]["category"]);
  }
}
