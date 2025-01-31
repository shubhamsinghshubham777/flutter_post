import 'package:flutter/material.dart';
import 'package:flutter_post/extensions.dart';
import 'package:flutter_post/features/authentication/provider/authentication_provider.dart';
import 'package:flutter_post/features/authentication/view/authentication_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticator = ref.watch(authenticationStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Post'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Dashboard Screen'),
            FilledButton(
              onPressed: () async {
                await authenticator.signOut();
                if (context.mounted) {
                  await context.pushScreenReplacement(
                    const AuthenticationScreen(),
                  );
                }
              },
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
