import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post/features/authentication/provider/authentication_provider.dart';
import 'package:flutter_post/features/authentication/view/authentication_screen.dart';
import 'package:flutter_post/features/posts/provider/dashboard_screen.dart';
import 'package:flutter_post/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _setupFirebase();
  runApp(const ProviderScope(child: FlutterPostApp()));
}

Future<void> _setupFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);
  }
}

class FlutterPostApp extends ConsumerStatefulWidget {
  const FlutterPostApp({super.key});

  @override
  ConsumerState<FlutterPostApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<FlutterPostApp> {
  bool? isLoggedIn;

  @override
  void initState() {
    // Using `postFrameCallback` because `ref` is not available until the first
    // frame is rendered.
    postFrameCallback(() async {
      final user = await ref.watch(authenticationStateProvider.future);
      isLoggedIn = user != null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: switch (isLoggedIn) {
        null => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        true => const DashboardScreen(),
        false => const AuthenticationScreen(),
      },
    );
  }
}
