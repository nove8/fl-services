import 'dart:async';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';

/// Extensions on [FutureOr].
extension FutureOrExtension<T> on FutureOr<T> {
  /// Awaiting [FutureOr] with checking if the returned value is actually a Future.
  /// Fixes unnecessary async gap with default await [FutureOr] solution.
  Future<T> wait() async {
    final FutureOr<T> futureOr = this;
    return futureOr is Future ? await futureOr : futureOr;
  }
}

/// Extensions on [Future].
extension FutureExtensions<T> on Future<T> {
  /// Transforms all errors on this future to [FailureResult]s.
  Future<Result<T>> mapToResult(Failure Function(Object error) failureProvider) {
    return toSuccessResultFuture().onError((Object error, StackTrace stackTrace) {
      return FailureResult(failureProvider(error), stackTrace);
    });
  }
}
