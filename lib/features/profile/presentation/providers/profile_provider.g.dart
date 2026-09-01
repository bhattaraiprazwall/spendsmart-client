// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profileRemoteDataSource)
final profileRemoteDataSourceProvider = ProfileRemoteDataSourceProvider._();

final class ProfileRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ProfileRemoteDataSource,
          ProfileRemoteDataSource,
          ProfileRemoteDataSource
        >
    with $Provider<ProfileRemoteDataSource> {
  ProfileRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ProfileRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRemoteDataSource create(Ref ref) {
    return profileRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRemoteDataSource>(value),
    );
  }
}

String _$profileRemoteDataSourceHash() =>
    r'5fd12ecca01ead418aa8975227038fa9638189e6';

@ProviderFor(profileRepository)
final profileRepositoryProvider = ProfileRepositoryProvider._();

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'1bc7478b9b63eaca024eef34329effb49b0cc45b';

@ProviderFor(getProfile)
final getProfileProvider = GetProfileProvider._();

final class GetProfileProvider
    extends $FunctionalProvider<GetProfile, GetProfile, GetProfile>
    with $Provider<GetProfile> {
  GetProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getProfileHash();

  @$internal
  @override
  $ProviderElement<GetProfile> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetProfile create(Ref ref) {
    return getProfile(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetProfile value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetProfile>(value),
    );
  }
}

String _$getProfileHash() => r'8eb5dd6c6b2b13ada8b2ef6c206f3b5ebc516284';

@ProviderFor(updateProfile)
final updateProfileProvider = UpdateProfileProvider._();

final class UpdateProfileProvider
    extends $FunctionalProvider<UpdateProfile, UpdateProfile, UpdateProfile>
    with $Provider<UpdateProfile> {
  UpdateProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateProfileHash();

  @$internal
  @override
  $ProviderElement<UpdateProfile> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateProfile create(Ref ref) {
    return updateProfile(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateProfile value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateProfile>(value),
    );
  }
}

String _$updateProfileHash() => r'f433f7ea2d18112fdb3d66e3e78968c967ba775b';

@ProviderFor(updateSettings)
final updateSettingsProvider = UpdateSettingsProvider._();

final class UpdateSettingsProvider
    extends $FunctionalProvider<UpdateSettings, UpdateSettings, UpdateSettings>
    with $Provider<UpdateSettings> {
  UpdateSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateSettingsHash();

  @$internal
  @override
  $ProviderElement<UpdateSettings> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UpdateSettings create(Ref ref) {
    return updateSettings(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UpdateSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UpdateSettings>(value),
    );
  }
}

String _$updateSettingsHash() => r'248cc1cb5855653895297ee007fee51921cdba05';

@ProviderFor(ProfileNotifier)
final profileProvider = ProfileNotifierProvider._();

final class ProfileNotifierProvider
    extends $AsyncNotifierProvider<ProfileNotifier, Profile?> {
  ProfileNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileNotifierHash();

  @$internal
  @override
  ProfileNotifier create() => ProfileNotifier();
}

String _$profileNotifierHash() => r'abff89698fcba513fd4f30fd4f9e015435feb4c2';

abstract class _$ProfileNotifier extends $AsyncNotifier<Profile?> {
  FutureOr<Profile?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Profile?>, Profile?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Profile?>, Profile?>,
              AsyncValue<Profile?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
