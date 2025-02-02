import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_post/features/authentication/model/flutter_post_user.dart';
import 'package:flutter_post/features/posts/provider/post_provider.dart';
import 'package:flutter_post/utils/utils.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthenticationState extends _$AuthenticationState {
  @override
  Future<FlutterPostUser?> build() async {
    return FirebaseAuth.instance.currentUser.toFlutterPostUser();
  }

  Future<void> authenticateWithEmailAndPassword({
    required bool shouldSignUp,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final credential = shouldSignUp
          ? await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: email,
              password: password,
            )
          : await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email,
              password: password,
            );

      return credential.user.toFlutterPostUser();
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      consoleLog('⏳ Signing out of remote auth SDK & clearing local posts...');
      await FirebaseAuth.instance.signOut();
      await FirebaseFirestore.instance.clearPersistence();
      await Hive.deleteFromDisk();
      ref
        ..invalidate(postManagerProvider)
        ..invalidate(pendingPostsProvider);
      return null;
    });
  }
}

extension on User? {
  FlutterPostUser? toFlutterPostUser() =>
      this?.email == null ? null : FlutterPostUser(email: this!.email!);
}
