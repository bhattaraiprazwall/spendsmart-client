import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spendsmart/core/exceptions/unauthorized_exception.dart';
import 'package:spendsmart/core/providers/auth_state_provider.dart';
import 'package:spendsmart/core/providers/core_providers.dart';
import 'package:spendsmart/features/category/data/datasources/category_remote_data_source.dart';
import 'package:spendsmart/features/category/data/repositories/category_repository_impl.dart';
import 'package:spendsmart/features/category/domain/entities/category.dart';
import 'package:spendsmart/features/category/domain/repositories/category_repository.dart';
import 'package:spendsmart/features/category/domain/usecases/create_category.dart';
import 'package:spendsmart/features/category/domain/usecases/delete_category.dart';
import 'package:spendsmart/features/category/domain/usecases/get_categories.dart';
import 'package:spendsmart/features/category/domain/usecases/update_category.dart';
import 'package:spendsmart/features/expenses/presentation/providers/expense_provider.dart';
import 'package:spendsmart/features/incomes/presentation/providers/income_provider.dart';
import 'package:spendsmart/features/insights/presentation/providers/insights_provider.dart';
import 'package:spendsmart/features/transactions/presentation/providers/transaction_provider.dart';
import 'package:spendsmart/core/database/database_provider.dart';
import 'package:spendsmart/features/category/data/datasources/category_local_data_source.dart';
part 'category_provider.g.dart';

@riverpod
CategoryRemoteDataSource categoryRemoteDataSource(Ref ref) {
  return CategoryRemoteDataSourceImpl();
}

@riverpod
CategoryLocalDataSource categoryLocalDataSource(Ref ref) {
  return CategoryLocalDataSourceImpl(
    categoryDao: ref.watch(categoryDaoProvider),
    storageService: ref.watch(storageServiceProvider),
  );
}

@riverpod
CategoryRepository categoryRepository(Ref ref) {
  return CategoryRepositoryImpl(
    ref.watch(categoryRemoteDataSourceProvider),
    ref.watch(categoryLocalDataSourceProvider),
  );
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
  FutureOr<List<Category>> build() async {
    final token = await ref.read(storageServiceProvider).getToken();
    if (token == null) return const [];
    try {
      return await ref.read(getCategoriesUseCaseProvider)(token);
    } catch (_) {
      return const [];
    }
  }

  void _safeSetState(AsyncValue<List<Category>> newState) {
    try {
      state = newState;
    } catch (_) {}
  }

  Future<void> fetchCategories(String idToken, {String? type}) async {
    if (!state.hasValue) {
      _safeSetState(const AsyncLoading());
    }
    try {
      final data = await ref
          .read(getCategoriesUseCaseProvider)(idToken, type: type);
      _safeSetState(AsyncData(data));
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).clearAuth();
        ref.read(authStateProvider.notifier).state = false;
        _safeSetState(AsyncError(e, st));
      } else {
        if (!state.hasValue) {
          _safeSetState(const AsyncData([]));
        }
      }
    }
  }

  void _refreshDependents() {
    ref.invalidate(transactionProvider);
    ref.invalidate(insightsProvider);
    ref.invalidate(expenseProvider);
    ref.invalidate(incomeProvider);
  }

  Future<void> createCategory(
    String idToken, {
    required String name,
    required String icon,
    required String color,
    String type = 'EXPENSE',
  }) async {
    try {
      final newCat = await ref.read(createCategoryUseCaseProvider)(
        idToken,
        name: name,
        icon: icon,
        color: color,
        type: type,
      );
      if (state.hasValue) {
        _safeSetState(AsyncData([...state.value!, newCat]));
      } else {
        _safeSetState(AsyncData([newCat]));
      }
      _refreshDependents();
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).clearAuth();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
    }
  }

  Future<void> deleteCategory(String idToken, String categoryId) async {
    try {
      await ref.read(deleteCategoryUseCaseProvider)(idToken, categoryId);
      if (state.hasValue) {
        _safeSetState(
          AsyncData(
            state.value!.where((c) => c.id != categoryId).toList(),
          ),
        );
      }
      _refreshDependents();
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).clearAuth();
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
    try {
      final updatedCat = await ref.read(updateCategoryUseCaseProvider)(
        idToken,
        categoryId,
        name: name,
        icon: icon,
        color: color,
        type: type,
      );
      if (state.hasValue) {
        _safeSetState(
          AsyncData(
            state.value!
                .map((c) => c.id == categoryId ? updatedCat : c)
                .toList(),
          ),
        );
      }
      _refreshDependents();
    } catch (e, st) {
      if (e is UnauthorizedException) {
        await ref.read(storageServiceProvider).clearAuth();
        ref.read(authStateProvider.notifier).state = false;
      }
      _safeSetState(AsyncError(e, st));
    }
  }
}
