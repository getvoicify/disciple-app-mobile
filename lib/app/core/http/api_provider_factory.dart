import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Creates a [Provider] whose value is derived from another provider.
///
/// This utility simplifies defining providers that depend on the value of
/// another provider — for example, constructing an API service from a shared
/// `Dio` or network client instance.
///
/// The [dependencyProvider] supplies the dependency that will be read inside
/// this provider. Its current value is passed into the [create] callback, which
/// is responsible for returning the derived object of type [T].
///
/// This pattern promotes clearer dependency management and consistency across
/// modules, as it makes explicit that the new provider is tied to a single
/// dependency.
///
/// The optional [name] parameter can be used to assign a human-readable name
/// to the resulting provider. This is particularly helpful when inspecting
/// provider relationships or debugging state changes in Riverpod DevTools.
///
/// Use [derivedProvider] instead of directly declaring a [Provider] when:
/// - You want to clearly express that a provider’s value is derived from another.
/// - You may later need to apply consistent initialization, logging, or error
///   handling logic to all dependent providers.
/// - You want to reduce boilerplate when multiple providers share the same
///   dependency pattern.
///
/// Example:
/// ```dart
/// final dioProvider = Provider((ref) => Dio());
///
/// final userApiProvider = derivedProvider<UserApi, Dio>(
///   dioProvider,
///   (dio) => UserApi(dio),
/// );
/// ```
///
/// In this example, [userApiProvider] depends on [dioProvider], and will be
/// automatically rebuilt if [dioProvider]’s value changes.
Provider<T> derivedProvider<T, D>(
  ProviderListenable<D> dependencyProvider,
  T Function(D dependency) create, {
  String? name,
}) => Provider<T>((ref) {
  final dependency = ref.read(dependencyProvider);
  return create(dependency);
}, name: name);
