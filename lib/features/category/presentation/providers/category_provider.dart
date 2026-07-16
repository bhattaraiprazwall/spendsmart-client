import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/features/auth/presentation/providers/auth_provider.dart';
import 'package:spendsmart/features/category/data/models/category_model.dart';
import 'package:spendsmart/features/category/data/repositories/category_repository.dart';
part 'category_provider.g.dart';

@riverpod
CategoryRepository categoryRepository(Ref ref) {
  return CategoryRepository();
}

@riverpod
class Category extends _$Category {
  @override
  FutureOr<List<CategoryModel>> build() => const [];

  Future<void> fetchCategories(String idToken) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(categoryRepositoryProvider);
      final data = await repository.getCategories(idToken);
      state = AsyncData(data);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      state = AsyncError(e, st);
    }
  }

  Future<void> createCategory(
    String idToken, {
    required String name,
    required String icon,
    required String color,
  }) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(categoryRepositoryProvider);
      await repository.createCategory(
        idToken,
        name: name,
        icon: icon,
        color: color,
      );
      await fetchCategories(idToken);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      state = AsyncError(e, st);
    }
  }

  Future<void> updateCategory(
    String idToken,
    String categoryId, {
    required String name,
    required String icon,
    required String color,
  }) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(categoryRepositoryProvider);
      await repository.updateCategory(
        idToken,
        categoryId,
        name: name,
        icon: icon,
        color: color,
      );
      await fetchCategories(idToken);
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).deleteToken();
        ref.read(authStateProvider.notifier).state = false;
      }
      state = AsyncError(e, st);
    }
  }
}
