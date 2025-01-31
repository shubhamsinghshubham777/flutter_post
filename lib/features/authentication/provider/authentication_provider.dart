import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_post/features/authentication/model/flutter_post_user.dart';
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
}

extension on User? {
  FlutterPostUser? toFlutterPostUser() =>
      this?.email == null ? null : FlutterPostUser(email: this!.email!);
}
