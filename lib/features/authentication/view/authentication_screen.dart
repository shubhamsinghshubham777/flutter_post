import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post/features/authentication/provider/authentication_provider.dart';
import 'package:flutter_post/features/posts/view/dashboard_screen.dart';
import 'package:flutter_post/utils/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationScreen extends ConsumerStatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  ConsumerState<AuthenticationScreen> createState() =>
      _AuthenticationScreenState();
}

class _AuthenticationScreenState extends ConsumerState<AuthenticationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authenticationStateProvider);
    final authenticator = ref.watch(authenticationStateProvider.notifier);

    ref.listen(authenticationStateProvider, (_, state) {
      state.whenOrNull(
        data: (user) {
          if (user != null) {
            context.pushScreenReplacement(const DashboardScreen());
          }
        },
        error: (error, stackTrace) {
          if (error is FirebaseAuthException) {
            final error = state.error as FirebaseAuthException;
            context.showSimpleSnackbar(error.message);
          }
        },
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text('Authentication')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(hintText: 'Enter your email'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(hintText: 'Enter your password'),
                obscureText: true,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 8,
                children: [
                  FilledButton.tonal(
                    onPressed: () {
                      authenticator.authenticateWithEmailAndPassword(
                        shouldSignUp: false,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                    },
                    child: Text('Login'),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      authenticator.authenticateWithEmailAndPassword(
                        shouldSignUp: true,
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                    },
                    child: Text('Sign Up'),
                  ),
                ],
              ),
              if (authState.isLoading) CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
