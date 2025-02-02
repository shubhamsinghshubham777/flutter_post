import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  Future<void> pushScreen(Widget screen) {
    return Navigator.of(this).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  Future<void> pushScreenReplacement(Widget screen) {
    return Navigator.of(this).pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void pop() => Navigator.of(this).pop();

  void showSimpleSnackbar(String? message) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message ?? 'Unexpected error occurred!'),
        ),
      );
  }

  void showSnackbarWithLoadingIndicator(String message) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Row(
            spacing: 16,
            children: [
              CircularProgressIndicator(),
              Text(message),
            ],
          ),
          duration: const Duration(days: 1),
        ),
        snackBarAnimationStyle: AnimationStyle(),
      );
  }

  void removeCurrentSnackbar() {
    ScaffoldMessenger.of(this).removeCurrentSnackBar();
  }
}
