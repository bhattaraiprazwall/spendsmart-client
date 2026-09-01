// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(budgetRemoteDataSource)
final budgetRemoteDataSourceProvider = BudgetRemoteDataSourceProvider._();

final class BudgetRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          BudgetRemoteDataSource,
          BudgetRemoteDataSource,
          BudgetRemoteDataSource
        >
    with $Provider<BudgetRemoteDataSource> {
  BudgetRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<BudgetRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BudgetRemoteDataSource create(Ref ref) {
    return budgetRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetRemoteDataSource>(value),
    );
  }
}

String _$budgetRemoteDataSourceHash() =>
    r'19f560267084af4db6b8c8d45fb0c36bc993fd13';

@ProviderFor(budgetRepository)
final budgetRepositoryProvider = BudgetRepositoryProvider._();

final class BudgetRepositoryProvider
    extends
        $FunctionalProvider<
          BudgetRepository,
          BudgetRepository,
          BudgetRepository
        >
    with $Provider<BudgetRepository> {
  BudgetRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetRepositoryHash();

  @$internal
  @override
  $ProviderElement<BudgetRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BudgetRepository create(Ref ref) {
    return budgetRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetRepository>(value),
    );
  }
}

String _$budgetRepositoryHash() => r'6046a061abbf6b70ce9834de30a4744af9acb5c7';

@ProviderFor(getBudgetUseCase)
final getBudgetUseCaseProvider = GetBudgetUseCaseProvider._();

final class GetBudgetUseCaseProvider
    extends $FunctionalProvider<GetBudget, GetBudget, GetBudget>
    with $Provider<GetBudget> {
  GetBudgetUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getBudgetUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getBudgetUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetBudget> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetBudget create(Ref ref) {
    return getBudgetUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetBudget value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetBudget>(value),
    );
  }
}

String _$getBudgetUseCaseHash() => r'50fe6492ef8a0de01adc9281b732fc5c20437fe3';

@ProviderFor(getBudgetStatusUseCase)
final getBudgetStatusUseCaseProvider = GetBudgetStatusUseCaseProvider._();

final class GetBudgetStatusUseCaseProvider
    extends
        $FunctionalProvider<GetBudgetStatus, GetBudgetStatus, GetBudgetStatus>
    with $Provider<GetBudgetStatus> {
  GetBudgetStatusUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getBudgetStatusUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getBudgetStatusUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetBudgetStatus> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetBudgetStatus create(Ref ref) {
    return getBudgetStatusUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetBudgetStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetBudgetStatus>(value),
    );
  }
}

String _$getBudgetStatusUseCaseHash() =>
    r'0d01ed65638d1b4ab8d8e6884d5ce39ba62ec0b3';

@ProviderFor(createOrUpdateBudgetUseCase)
final createOrUpdateBudgetUseCaseProvider =
    CreateOrUpdateBudgetUseCaseProvider._();

final class CreateOrUpdateBudgetUseCaseProvider
    extends
        $FunctionalProvider<
          CreateOrUpdateBudget,
          CreateOrUpdateBudget,
          CreateOrUpdateBudget
        >
    with $Provider<CreateOrUpdateBudget> {
  CreateOrUpdateBudgetUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createOrUpdateBudgetUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createOrUpdateBudgetUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateOrUpdateBudget> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateOrUpdateBudget create(Ref ref) {
    return createOrUpdateBudgetUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateOrUpdateBudget value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateOrUpdateBudget>(value),
    );
  }
}

String _$createOrUpdateBudgetUseCaseHash() =>
    r'c1294a6b3d491c2480acd53c44134afb57ad94ec';

@ProviderFor(updateBudgetUseCase)
final updateBudgetUseCaseProvider = UpdateBudgetUseCaseProvider._();

final class UpdateBudgetUseCaseProvider
    extends $FunctionalProvider<UpdateBudget, UpdateBudget, UpdateBudget>
    with $Provider<UpdateBudget> {
  UpdateBudgetUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateBudgetUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateBudgetUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateBudget> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateBudget create(Ref ref) {
    return updateBudgetUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateBudget value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateBudget>(value),
    );
  }
}

String _$updateBudgetUseCaseHash() =>
    r'2d849a976ccd4b724f0e287e7da7a33d5d4a8408';

@ProviderFor(deleteBudgetUseCase)
final deleteBudgetUseCaseProvider = DeleteBudgetUseCaseProvider._();

final class DeleteBudgetUseCaseProvider
    extends $FunctionalProvider<DeleteBudget, DeleteBudget, DeleteBudget>
    with $Provider<DeleteBudget> {
  DeleteBudgetUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteBudgetUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteBudgetUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeleteBudget> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeleteBudget create(Ref ref) {
    return deleteBudgetUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteBudget value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteBudget>(value),
    );
  }
}

String _$deleteBudgetUseCaseHash() =>
    r'e24d20216d76748f4bdeafe24abfed74804822c9';

@ProviderFor(addCategoryLimitUseCase)
final addCategoryLimitUseCaseProvider = AddCategoryLimitUseCaseProvider._();

final class AddCategoryLimitUseCaseProvider
    extends
        $FunctionalProvider<
          AddCategoryLimit,
          AddCategoryLimit,
          AddCategoryLimit
        >
    with $Provider<AddCategoryLimit> {
  AddCategoryLimitUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addCategoryLimitUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addCategoryLimitUseCaseHash();

  @$internal
  @override
  $ProviderElement<AddCategoryLimit> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AddCategoryLimit create(Ref ref) {
    return addCategoryLimitUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddCategoryLimit value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddCategoryLimit>(value),
    );
  }
}

String _$addCategoryLimitUseCaseHash() =>
    r'7549d9124e8e19047dc5e033097cd8f9892b4eee';

@ProviderFor(updateCategoryLimitUseCase)
final updateCategoryLimitUseCaseProvider =
    UpdateCategoryLimitUseCaseProvider._();

final class UpdateCategoryLimitUseCaseProvider
    extends
        $FunctionalProvider<
          UpdateCategoryLimit,
          UpdateCategoryLimit,
          UpdateCategoryLimit
        >
    with $Provider<UpdateCategoryLimit> {
  UpdateCategoryLimitUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateCategoryLimitUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateCategoryLimitUseCaseHash();

  @$internal
  @override
  $ProviderElement<UpdateCategoryLimit> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateCategoryLimit create(Ref ref) {
    return updateCategoryLimitUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateCategoryLimit value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateCategoryLimit>(value),
    );
  }
}

String _$updateCategoryLimitUseCaseHash() =>
    r'2c3f48a4b75888d68ed36007dbbc8f9207b1d50c';

@ProviderFor(removeCategoryLimitUseCase)
final removeCategoryLimitUseCaseProvider =
    RemoveCategoryLimitUseCaseProvider._();

final class RemoveCategoryLimitUseCaseProvider
    extends
        $FunctionalProvider<
          RemoveCategoryLimit,
          RemoveCategoryLimit,
          RemoveCategoryLimit
        >
    with $Provider<RemoveCategoryLimit> {
  RemoveCategoryLimitUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'removeCategoryLimitUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$removeCategoryLimitUseCaseHash();

  @$internal
  @override
  $ProviderElement<RemoveCategoryLimit> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RemoveCategoryLimit create(Ref ref) {
    return removeCategoryLimitUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoveCategoryLimit value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoveCategoryLimit>(value),
    );
  }
}

String _$removeCategoryLimitUseCaseHash() =>
    r'baad2afdc02f02ab43cb7981934dbc05846b5572';

@ProviderFor(Budget)
final budgetProvider = BudgetProvider._();

final class BudgetProvider
    extends $AsyncNotifierProvider<Budget, BudgetStatus?> {
  BudgetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'budgetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$budgetHash();

  @$internal
  @override
  Budget create() => Budget();
}

String _$budgetHash() => r'43d97e9852bcfda5487d9a0c38eeb8ffb47709e9';

abstract class _$Budget extends $AsyncNotifier<BudgetStatus?> {
  FutureOr<BudgetStatus?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<BudgetStatus?>, BudgetStatus?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<BudgetStatus?>, BudgetStatus?>,
              AsyncValue<BudgetStatus?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
