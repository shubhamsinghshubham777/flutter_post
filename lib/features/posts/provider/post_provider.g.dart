// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pendingPostsHash() => r'db45a4f27e8a15cef11917ce148b41965c883461';

/// See also [pendingPosts].
@ProviderFor(pendingPosts)
final pendingPostsProvider = AutoDisposeStreamProvider<List<Post>>.internal(
  pendingPosts,
  name: r'pendingPostsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$pendingPostsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingPostsRef = AutoDisposeStreamProviderRef<List<Post>>;
String _$postManagerHash() => r'f85fc79f452d6859198f5afa103e620e6338f93f';

/// See also [PostManager].
@ProviderFor(PostManager)
final postManagerProvider =
    AutoDisposeStreamNotifierProvider<PostManager, List<Post>>.internal(
  PostManager.new,
  name: r'postManagerProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$postManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PostManager = AutoDisposeStreamNotifier<List<Post>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
