// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transactionRepository)
final transactionRepositoryProvider = TransactionRepositoryProvider._();

final class TransactionRepositoryProvider
    extends
        $FunctionalProvider<
          TransactionRepository,
          TransactionRepository,
          TransactionRepository
        >
    with $Provider<TransactionRepository> {
  TransactionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionRepositoryHash();

  @$internal
  @override
  $ProviderElement<TransactionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransactionRepository create(Ref ref) {
    return transactionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionRepository>(value),
    );
  }
}

String _$transactionRepositoryHash() =>
    r'448c81bdf48423476ec36542bfe3d11ce786917e';

@ProviderFor(transactionRemoteDataSource)
final transactionRemoteDataSourceProvider =
    TransactionRemoteDataSourceProvider._();

final class TransactionRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          TransactionRemoteDataSource,
          TransactionRemoteDataSource,
          TransactionRemoteDataSource
        >
    with $Provider<TransactionRemoteDataSource> {
  TransactionRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<TransactionRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransactionRemoteDataSource create(Ref ref) {
    return transactionRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionRemoteDataSource>(value),
    );
  }
}

String _$transactionRemoteDataSourceHash() =>
    r'1f02412498393c7fabd543e3ba4abf3ce266dbad';

@ProviderFor(updateTransaction)
final updateTransactionProvider = UpdateTransactionProvider._();

final class UpdateTransactionProvider
    extends
        $FunctionalProvider<
          UpdateTransaction,
          UpdateTransaction,
          UpdateTransaction
        >
    with $Provider<UpdateTransaction> {
  UpdateTransactionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateTransactionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateTransactionHash();

  @$internal
  @override
  $ProviderElement<UpdateTransaction> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UpdateTransaction create(Ref ref) {
    return updateTransaction(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateTransaction value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateTransaction>(value),
    );
  }
}

String _$updateTransactionHash() => r'1b2a856723815486431f840168455b866e285cce';

@ProviderFor(deleteTransaction)
final deleteTransactionProvider = DeleteTransactionProvider._();

final class DeleteTransactionProvider
    extends
        $FunctionalProvider<
          DeleteTransaction,
          DeleteTransaction,
          DeleteTransaction
        >
    with $Provider<DeleteTransaction> {
  DeleteTransactionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteTransactionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteTransactionHash();

  @$internal
  @override
  $ProviderElement<DeleteTransaction> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeleteTransaction create(Ref ref) {
    return deleteTransaction(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteTransaction value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteTransaction>(value),
    );
  }
}

String _$deleteTransactionHash() => r'dfd1df258651261c97a382f75acfaa138b5fcece';

@ProviderFor(TransactionNotifier)
final transactionProvider = TransactionNotifierProvider._();

final class TransactionNotifierProvider
    extends $AsyncNotifierProvider<TransactionNotifier, List<Transaction>> {
  TransactionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionNotifierHash();

  @$internal
  @override
  TransactionNotifier create() => TransactionNotifier();
}

String _$transactionNotifierHash() =>
    r'1db52813143929c8187c7c1811c471176f104a2d';

abstract class _$TransactionNotifier extends $AsyncNotifier<List<Transaction>> {
  FutureOr<List<Transaction>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<Transaction>>, List<Transaction>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Transaction>>, List<Transaction>>,
              AsyncValue<List<Transaction>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
