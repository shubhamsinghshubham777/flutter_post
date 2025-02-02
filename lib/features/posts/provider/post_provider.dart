import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter_post/features/authentication/provider/authentication_provider.dart';
import 'package:flutter_post/features/common/provider/network_provider.dart';
import 'package:flutter_post/features/posts/model/post.dart';
import 'package:flutter_post/utils/constants.dart';
import 'package:flutter_post/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_provider.g.dart';

@riverpod
Stream<List<Post>> pendingPosts(Ref ref) async* {
  final box = await Hive.openBox<Post>(Constants.collectionPendingPosts);
  yield box.values.toList();
  yield* box.watch().map((_) => box.values.toList());
}

@riverpod
class PostManager extends _$PostManager {
  static const _pageSize = 10;

  Box<Post>? _postsBox;
  Box<Post>? _pendingBox;

  CollectionReference<Map<String, dynamic>> get _postsCollection =>
      FirebaseFirestore.instance.collection(Constants.collectionPosts);

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _remoteSubscription;

  @override
  Stream<List<Post>> build() async* {
    _postsBox ??= await Hive.openBox<Post>(Constants.collectionPosts);
    _pendingBox ??= await Hive.openBox<Post>(Constants.collectionPendingPosts);

    unawaited(loadNextPage().then((_) => syncPendingPosts()));

    yield* _localPostsStream;
  }

  /// Keeps currently displayed posts updated by observing remote DB. Should
  /// be called from a listener of this provider to ensure that we only
  /// start observing posts when the post count actually gets updated.
  Future<void> observeDisplayedPosts() async {
    final posts = state.valueOrNull;
    if (posts == null || posts.isEmpty) {
      consoleLog('❌ No posts available in current state! Aborting...');
      return;
    }

    final firstDoc = await _postsCollection.doc(posts.first.id).get();
    final lastDoc = await _postsCollection.doc(posts.last.id).get();

    if (!firstDoc.exists || !lastDoc.exists) {
      consoleLog(
        '❌ One or more of the provided docs do not exist in remote DB! '
        'Hence, aborting...',
      );
      return;
    }

    _remoteSubscription?.cancel();

    _remoteSubscription = _postsCollection
        .startAtDocument(firstDoc)
        .endAtDocument(lastDoc)
        .snapshots()
        .listen((snapshot) {
      for (final change in snapshot.docChanges) {
        _handleRemotePostChange(change, _postsBox);
      }
    });

    ref.onDispose(_remoteSubscription!.cancel);
  }

  /// Fetches and appends the next set of posts to the existing state.
  Future<void> loadNextPage() async {
    final existingPosts = state.valueOrNull ?? [];

    final postsFromLocalDB =
        _getPostsFromLocalDB(startIndex: existingPosts.length);

    if (postsFromLocalDB.length < _pageSize) {
      consoleLog(
        '⏳ Local DB does not have enough posts '
        '(${postsFromLocalDB.length}/$_pageSize) to load the next page! '
        'Checking if remote DB has them and fetching if necessary...',
      );

      final remotePosts = await _getPostsFromRemoteDB(
        startId: existingPosts.lastOrNull?.id,
      );

      if (remotePosts.isNotEmpty) {
        consoleLog(
          '⏳ Storing ${remotePosts.length} remote posts to local DB...',
        );

        var existingCount = 0;

        for (final post in remotePosts) {
          final doesPostExistAlready = _postsBox?.containsKey(post.id) ?? false;
          if (!doesPostExistAlready) {
            consoleLog('💾 Storing post with id: ${post.id}');
            await _postsBox?.put(post.id, post);
          } else {
            existingCount += 1;
          }
        }
        if (existingCount == remotePosts.length) {
          consoleLog('⚠️ All remote posts already existed in local DB!');
        }
      } else {
        consoleLog('⚠️ Remote DB did not return any new posts!');
      }
    }
  }

  /// Uploads a new post to remote DB and refreshes current displayed list
  Future<void> uploadNewPost(Post post) async {
    await _pendingBox?.put(post.id, post);
    await syncPendingPosts();
  }

  /// Increments or Decrements the like count for a post from current user.
  Future<void> likePost({required Post post}) async {
    final currentUserEmail =
        (await ref.read(authenticationStateProvider.future))?.email;

    final likeEmails = post.likeEmails.toList();

    if (currentUserEmail == null) {
      consoleLog('❌ Current user email not found! Aborting LIKE process!');
      return;
    }

    if (likeEmails.contains(currentUserEmail)) {
      likeEmails.remove(currentUserEmail);
    } else {
      likeEmails.add(currentUserEmail);
    }

    await _pendingBox?.put(post.id, post.copyWith(likeEmails: likeEmails));
    await syncPendingPosts();
  }

  /// Publishes pending/offline posts to remote DB if network connection is
  /// available.
  Future<void> syncPendingPosts() async {
    state = const AsyncLoading();

    final isInternetOn = await ref.read(isNetworkConnectedProvider.future);

    if (!isInternetOn) {
      consoleLog('❌ Network connection not available! Aborting sync...');
      _setProviderStateToData();
      return;
    }

    final pendingPosts = _pendingBox?.values ?? [];

    if (pendingPosts.isEmpty) {
      consoleLog('❌ No pending posts. Aborting sync...');
      _setProviderStateToData();
      return;
    }

    consoleLog('⏳ Syncing ${pendingPosts.length} posts to remote DB...');

    for (final pendingPost in pendingPosts) {
      await _postsCollection.doc(pendingPost.id).set(pendingPost.toJson());
    }

    for (final pendingPost in pendingPosts) {
      consoleLog(
        '⏳ Putting post with id (${pendingPost.id}) from pending box to '
        'posts box...',
      );
      await _postsBox?.put(pendingPost.id, pendingPost);
    }
    await _pendingBox?.clear();

    consoleLog('✅ Synced ${pendingPosts.length} posts to remote DB');

    _setProviderStateToData();
  }

  void _setProviderStateToData() {
    state = AsyncData(state.valueOrNull ?? []);
  }

  Future<void> _handleRemotePostChange(
    DocumentChange<Map<String, dynamic>> change,
    Box<Post>? postsBox,
  ) async {
    if (postsBox == null) {
      consoleLog('❌ Box not available! Aborting operation...');
      return;
    }
    consoleLog('Post with id: ${change.doc.id} has been: ${change.type.name}');
    final doc = change.doc;
    final docData = doc.data();
    switch (change.type) {
      case DocumentChangeType.added:
        if (docData != null && !postsBox.containsKey(doc.id)) {
          await postsBox.put(doc.id, Post.fromJson(docData));
        }
      case DocumentChangeType.modified:
        if (docData != null) await postsBox.put(doc.id, Post.fromJson(docData));
      case DocumentChangeType.removed:
        if (postsBox.containsKey(doc.id)) await postsBox.delete(doc.id);
    }
  }

  List<Post> _getPostsFromLocalDB({required int startIndex}) {
    consoleLog(
      'Fetching posts $startIndex-${startIndex + _pageSize} from box...',
    );

    final sortedPosts =
        (_postsBox?.values ?? []).sortedBy((post) => post.timestamp).toList();

    return sortedPosts.sublist(
      startIndex,
      _pageSize.clamp(startIndex, sortedPosts.length),
    );
  }

  Future<List<Post>> _getPostsFromRemoteDB({required String? startId}) async {
    consoleLog('Start id is: $startId');

    final doc =
        startId == null ? null : await _postsCollection.doc(startId).get();

    var query = _postsCollection.orderBy(Constants.collectionPostsOrderField);
    query = doc?.exists ?? false ? query.startAfterDocument(doc!) : query;
    query = query.limit(_pageSize - 1);

    final querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => Post.fromJson(doc.data())).toList();
  }

  Stream<List<Post>> get _localPostsStream async* {
    final box = _postsBox;

    yield (_postsBox?.values ?? []).sortedBy((post) => post.timestamp).toList();

    if (box != null) {
      yield* box
          .watch()
          .map((_) => box.values.sortedBy((post) => post.timestamp).toList());
    }
  }
}
