import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_provider.g.dart';

@riverpod
Stream<bool> isNetworkConnected(Ref ref) async* {
  final connectionChecker = InternetConnectionChecker.instance;

  // Initialise stream
  yield await connectionChecker.hasConnection;

  // Observe stream
  yield* connectionChecker.onStatusChange.asyncMap(
    (_) => connectionChecker.hasConnection,
  );
}
