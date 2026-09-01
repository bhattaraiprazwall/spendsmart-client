// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categoryRemoteDataSource)
final categoryRemoteDataSourceProvider = CategoryRemoteDataSourceProvider._();

final class CategoryRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          CategoryRemoteDataSource,
          CategoryRemoteDataSource,
          CategoryRemoteDataSource
        >
    with $Provider<CategoryRemoteDataSource> {
  CategoryRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<CategoryRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoryRemoteDataSource create(Ref ref) {
    return categoryRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryRemoteDataSource>(value),
    );
  }
}

String _$categoryRemoteDataSourceHash() =>
    r'0691f70d96f4ea7ee63013a1e1f115f15f5e45db';

@ProviderFor(categoryRepository)
final categoryRepositoryProvider = CategoryRepositoryProvider._();

final class CategoryRepositoryProvider
    extends
        $FunctionalProvider<
          CategoryRepository,
          CategoryRepository,
          CategoryRepository
        >
    with $Provider<CategoryRepository> {
  CategoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CategoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoryRepository create(Ref ref) {
    return categoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryRepository>(value),
    );
  }
}

String _$categoryRepositoryHash() =>
    r'50ba97881e1c81c55cb88c31432aa4865eeffddb';

@ProviderFor(getCategoriesUseCase)
final getCategoriesUseCaseProvider = GetCategoriesUseCaseProvider._();

final class GetCategoriesUseCaseProvider
    extends $FunctionalProvider<GetCategories, GetCategories, GetCategories>
    with $Provider<GetCategories> {
  GetCategoriesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCategoriesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCategoriesUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCategories> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetCategories create(Ref ref) {
    return getCategoriesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCategories value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCategories>(value),
    );
  }
}

String _$getCategoriesUseCaseHash() =>
    r'cb12bcb452558d9b4f6551dc642d76aee64bcfc6';

@ProviderFor(createCategoryUseCase)
final createCategoryUseCaseProvider = CreateCategoryUseCaseProvider._();

final class CreateCategoryUseCaseProvider
    extends $FunctionalProvider<CreateCategory, CreateCategory, CreateCategory>
    with $Provider<CreateCategory> {
  CreateCategoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createCategoryUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createCategoryUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateCategory> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CreateCategory create(Ref ref) {
    return createCategoryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateCategory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateCategory>(value),
    );
  }
}

String _$createCategoryUseCaseHash() =>
    r'cf2358c957221be00e0beb35f36116e1d46ed5e8';

@ProviderFor(updateCategoryUseCase)
final updateCategoryUseCaseProvider = UpdateCategoryUseCaseProvider._();

final class UpdateCategoryUseCaseProvider
    extends $FunctionalProvider<UpdateCategory, UpdateCategory, UpdateCategory>
    with $Provider<UpdateCategory> {
  UpdateCategoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateCategoryUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateCategoryUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateCategory> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateCategory create(Ref ref) {
    return updateCategoryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateCategory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateCategory>(value),
    );
  }
}

String _$updateCategoryUseCaseHash() =>
    r'6525da4cbd667c52d0f8bb009ac8c3e2130d31ed';

@ProviderFor(deleteCategoryUseCase)
final deleteCategoryUseCaseProvider = DeleteCategoryUseCaseProvider._();

final class DeleteCategoryUseCaseProvider
    extends $FunctionalProvider<DeleteCategory, DeleteCategory, DeleteCategory>
    with $Provider<DeleteCategory> {
  DeleteCategoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteCategoryUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteCategoryUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteCategory> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeleteCategory create(Ref ref) {
    return deleteCategoryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteCategory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteCategory>(value),
    );
  }
}

String _$deleteCategoryUseCaseHash() =>
    r'b0027adeeec343605680d6f947cb8babb9f142d7';

@ProviderFor(Categories)
final categoriesProvider = CategoriesProvider._();

final class CategoriesProvider
    extends $AsyncNotifierProvider<Categories, List<Category>> {
  CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  Categories create() => Categories();
}

String _$categoriesHash() => r'67f81d2ec7b57e3e9fbe072fa4513401d7464dcf';

abstract class _$Categories extends $AsyncNotifier<List<Category>> {
  FutureOr<List<Category>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Category>>, List<Category>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Category>>, List<Category>>,
              AsyncValue<List<Category>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
