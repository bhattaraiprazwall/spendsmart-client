import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/category/data/datasources/category_remote_datasource.dart';
import 'package:spendsmart/features/category/data/repositories/category_repository_impl.dart';
import 'package:spendsmart/features/category/domain/entities/category.dart';
import 'package:spendsmart/features/category/domain/repositories/category_repository.dart';
import 'package:spendsmart/features/category/domain/usecases/create_category.dart';
import 'package:spendsmart/features/category/domain/usecases/delete_category.dart';
import 'package:spendsmart/features/category/domain/usecases/get_categories.dart';
import 'package:spendsmart/features/category/domain/usecases/update_category.dart';
part 'category_provider.g.dart';

@riverpod
CategoryRemoteDataSource categoryRemoteDataSource(Ref ref) {
  return CategoryRemoteDataSource();
}

@riverpod
CategoryRepository categoryRepository(Ref ref) {
  return CategoryRepositoryImpl(ref.watch(categoryRemoteDataSourceProvider));
}

@riverpod
GetCategories getCategoriesUseCase(Ref ref) {
  return GetCategories(ref.watch(categoryRepositoryProvider));
}

@riverpod
CreateCategory createCategoryUseCase(Ref ref) {
  return CreateCategory(ref.watch(categoryRepositoryProvider));
}

@riverpod
UpdateCategory updateCategoryUseCase(Ref ref) {
  return UpdateCategory(ref.watch(categoryRepositoryProvider));
}

@riverpod
DeleteCategory deleteCategoryUseCase(Ref ref) {
  return DeleteCategory(ref.watch(categoryRepositoryProvider));
}

@riverpod
class Categories extends _$Categories {
  @override
  FutureOr<List<Category>> build() => const [];

  void _safeSetState(AsyncValue<List<Category>> newState) {
    try {
      state = newState;
    } catch (_) {}
  }

  Future<void> fetchCategories(String idToken, {String? type}) async {
    _safeSetState(const AsyncLoading());
    try {
      final data = await ref
          .read(getCategoriesUseCaseProvider)(idToken, type: type);
      _safeSetState(AsyncData(data));
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
    }
  }

  Future<void> createCategory(
    String idToken, {
    required String name,
    required String icon,
    required String color,
    String type = 'EXPENSE',
  }) async {
    _safeSetState(const AsyncLoading());
    try {
      await ref.read(createCategoryUseCaseProvider)(
        idToken,
        name: name,
        icon: icon,
        color: color,
        type: type,
      );
      await fetchCategories(idToken);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
    }
  }

  Future<void> deleteCategory(String idToken, String categoryId) async {
    _safeSetState(const AsyncLoading());
    try {
      await ref.read(deleteCategoryUseCaseProvider)(idToken, categoryId);
      await fetchCategories(idToken);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
    }
  }

  Future<void> updateCategory(
    String idToken,
    String categoryId, {
    required String name,
    required String icon,
    required String color,
    String? type,
  }) async {
    _safeSetState(const AsyncLoading());
    try {
      await ref.read(updateCategoryUseCaseProvider)(
        idToken,
        categoryId,
        name: name,
        icon: icon,
        color: color,
        type: type,
      );
      await fetchCategories(idToken);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
    }
  }
}
