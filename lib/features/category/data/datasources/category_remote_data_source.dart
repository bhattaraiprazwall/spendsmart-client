import 'package:spendsmart/core/constants/api_constants.dart';
import 'package:spendsmart/core/services/api_service.dart';
import 'package:spendsmart/features/category/data/models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories(
    String idToken, {
    String? type,
  });

  Future<CategoryModel> createCategory(
    String idToken, {
    required String name,
    required String icon,
    required String color,
    String type = 'EXPENSE',
  });

  Future<void> deleteCategory(String idToken, String categoryId);

  Future<CategoryModel> updateCategory(
    String idToken,
    String categoryId, {
    String? name,
    String? icon,
    String? color,
    String? type,
  });
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiService _apiService;

  CategoryRemoteDataSourceImpl({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  @override
  Future<List<CategoryModel>> getCategories(
    String idToken, {
    String? type,
  }) async {
    final uri = type != null
        ? Uri.parse(ApiConstants.categories)
            .replace(queryParameters: {"type": type})
        : Uri.parse(ApiConstants.categories);

    final response = await _apiService.get(
      uri.toString(),
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

  @override
  Future<CategoryModel> createCategory(
    String idToken, {
    required String name,
    required String icon,
    required String color,
    String type = 'EXPENSE',
  }) async {
    final response = await _apiService.post(
      ApiConstants.categories,
      {"name": name, "icon": icon, "color": color, "type": type},
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

  @override
  Future<void> deleteCategory(String idToken, String categoryId) async {
    final response = await _apiService.delete(
      '${ApiConstants.categories}/$categoryId',
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      },
    );
    if (response["statusCode"] != 200 && response["statusCode"] != 204) {
      throw Exception(
        response["data"]["message"] ?? "Failed to delete category",
      );
    }
  }

  @override
  Future<CategoryModel> updateCategory(
    String idToken,
    String categoryId, {
    String? name,
    String? icon,
    String? color,
    String? type,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body["name"] = name;
    if (icon != null) body["icon"] = icon;
    if (color != null) body["color"] = color;
    if (type != null) body["type"] = type;

    final response = await _apiService.put(
      '${ApiConstants.categories}/$categoryId',
      body,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $idToken",
      },
    );
    if (response["statusCode"] != 200) {
      throw Exception(
        response["data"]["message"] ?? "Failed to update category..",
      );
    }
    return CategoryModel.fromJson(response["data"]["data"]["category"]);
  }
}
