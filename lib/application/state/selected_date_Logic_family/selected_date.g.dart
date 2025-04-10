// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_date.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedFamilyHash() => r'0d2d1c646851150e2aa5f8be807957b0c4861631';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [selectedFamily].
@ProviderFor(selectedFamily)
const selectedFamilyProvider = SelectedFamilyFamily();

/// See also [selectedFamily].
class SelectedFamilyFamily extends Family<bool> {
  /// See also [selectedFamily].
  const SelectedFamilyFamily();

  /// See also [selectedFamily].
  SelectedFamilyProvider call(
    DateTime date,
  ) {
    return SelectedFamilyProvider(
      date,
    );
  }

  @override
  SelectedFamilyProvider getProviderOverride(
    covariant SelectedFamilyProvider provider,
  ) {
    return call(
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'selectedFamilyProvider';
}

/// See also [selectedFamily].
class SelectedFamilyProvider extends AutoDisposeProvider<bool> {
  /// See also [selectedFamily].
  SelectedFamilyProvider(
    DateTime date,
  ) : this._internal(
          (ref) => selectedFamily(
            ref as SelectedFamilyRef,
            date,
          ),
          from: selectedFamilyProvider,
          name: r'selectedFamilyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$selectedFamilyHash,
          dependencies: SelectedFamilyFamily._dependencies,
          allTransitiveDependencies:
              SelectedFamilyFamily._allTransitiveDependencies,
          date: date,
        );

  SelectedFamilyProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    bool Function(SelectedFamilyRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SelectedFamilyProvider._internal(
        (ref) => create(ref as SelectedFamilyRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _SelectedFamilyProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SelectedFamilyProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SelectedFamilyRef on AutoDisposeProviderRef<bool> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _SelectedFamilyProviderElement extends AutoDisposeProviderElement<bool>
    with SelectedFamilyRef {
  _SelectedFamilyProviderElement(super.provider);

  @override
  DateTime get date => (origin as SelectedFamilyProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
