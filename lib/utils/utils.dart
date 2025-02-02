import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void postFrameCallback(VoidCallback callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    callback();
  });
}

T? onPlatformOrNull<T>({
  T Function()? android,
  T Function()? iOS,
  T Function()? mobile,
  T Function()? macOS,
  T Function()? web,
  T Function()? windows,
  T Function()? linux,
  T Function()? desktop,
  T Function()? orElse,
}) {
  if (kIsWeb) {
    return web?.call();
  } else {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android?.call() ?? mobile?.call() ?? orElse?.call();
      case TargetPlatform.iOS:
        return iOS?.call() ?? mobile?.call() ?? orElse?.call();
      case TargetPlatform.linux:
        return linux?.call() ?? desktop?.call() ?? orElse?.call();
      case TargetPlatform.macOS:
        return macOS?.call() ?? desktop?.call() ?? orElse?.call();
      case TargetPlatform.windows:
        return windows?.call() ?? desktop?.call() ?? orElse?.call();
      default:
        return orElse?.call();
    }
  }
}

void consoleLog(String message, {StackTrace? stackTrace}) {
  if (kDebugMode) {
    debugPrint(message);
    if (stackTrace != null) debugPrintStack(stackTrace: stackTrace);
  }
}
