import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  Future<void> pushScreenReplacement(Widget screen) {
    return Navigator.of(this).pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void showSimpleSnackbar(String? message) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message ?? 'Unexpected error occurred!'),
        ),
      );
  }
}
