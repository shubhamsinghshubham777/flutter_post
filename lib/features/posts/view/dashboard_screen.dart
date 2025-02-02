import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post/features/authentication/provider/authentication_provider.dart';
import 'package:flutter_post/features/authentication/view/authentication_screen.dart';
import 'package:flutter_post/features/common/provider/network_provider.dart';
import 'package:flutter_post/features/posts/provider/post_provider.dart';
import 'package:flutter_post/features/posts/view/create_post_screen.dart';
import 'package:flutter_post/features/posts/view/post_card.dart';
import 'package:flutter_post/utils/extensions.dart';
import 'package:flutter_post/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _scrollController = ScrollController();
  PostManager? postManager;

  @override
  void initState() {
    _scrollController.addListener(_listViewScrollListener);
    postFrameCallback(
      () => postManager = ref.read(postManagerProvider.notifier),
    );
    super.initState();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_listViewScrollListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authenticator = ref.watch(authenticationStateProvider.notifier);
    final nonPendingPostsState = ref.watch(postManagerProvider);

    final pendingPosts = ref.watch(pendingPostsProvider).valueOrNull ?? [];
    final nonPendingPosts = nonPendingPostsState.valueOrNull ?? [];

    final totalPostsCount = max(pendingPosts.length, nonPendingPosts.length);

    ref.listen(postManagerProvider, (oldState, newState) {
      final oldLength = oldState?.valueOrNull?.length;
      final newLength = newState.valueOrNull?.length;

      if (newLength != oldLength) {
        consoleLog('ℹ️ Length: Old ($oldLength), New ($newLength)');
        postManager?.observeDisplayedPosts();

        Future.delayed(Durations.long2, () {
          if (!_scrollController.position.atEdge &&
              _scrollController.position.pixels != 0) {
            consoleLog(
              '🆕 New posts available! Scrolling a bit to make them visible...',
            );

            _scrollController.animateTo(
              _scrollController.position.pixels + 64,
              duration: const Duration(seconds: 4),
              curve: Curves.elasticOut,
            );

            if (context.mounted) {
              context.showSimpleSnackbar(
                'New posts loaded, try scrolling down',
              );
            }
          }
        });
      }

      if (newState.hasError || (oldState?.hasError ?? false)) {
        consoleLog(
          'Error is: ${newState.error ?? oldState?.error}',
          stackTrace: newState.stackTrace ?? oldState?.stackTrace,
        );
      }
    });

    ref.listen(isNetworkConnectedProvider, (_, newState) {
      final isNetworkConnected = newState.value ?? false;
      if (isNetworkConnected) postManager?.syncPendingPosts();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Post'),
        centerTitle: false,
        actions: [
          if (nonPendingPostsState.isLoading)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          IconButton(
            onPressed: () => ref.invalidate(postManagerProvider),
            icon: Icon(Icons.refresh),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () => _signOutAndNavigate(authenticator, context),
              icon: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushScreen(const CreatePostScreen()),
        icon: Icon(Icons.post_add),
        label: Text('New Post'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: totalPostsCount,
        itemBuilder: (context, index) {
          final nonPendingPost = nonPendingPosts.elementAtOrNull(index);

          final pendingPost = pendingPosts.firstWhereOrNull(
            (p) => p.id == nonPendingPost?.id,
          );

          final post = pendingPost ?? nonPendingPost;

          if (post != null) {
            return PostCard(
              post,
              key: Key(post.id),
              onLikeButtonTap: () => postManager?.likePost(post: post),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _listViewScrollListener() {
    if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      consoleLog('🔚 Reached end, loading next page...');
      postManager?.loadNextPage();
    }
  }

  Future<void> _signOutAndNavigate(
    AuthenticationState authenticator,
    BuildContext context,
  ) async {
    await authenticator.signOut();
    if (context.mounted) {
      await context.pushScreenReplacement(const AuthenticationScreen());
    }
  }
}
