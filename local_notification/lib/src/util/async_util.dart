import 'package:async/async.dart';
import 'package:common_result/common_result.dart';

/// Extensions on [Future].
extension FutureExtensions<T> on Future<T> {
  /// Transforms all errors on this future to [FailureResult]s.
  Future<Result<T>> mapToResult(Failure Function(Object error) failureProvider) {
    return toSuccessResultFuture().mapErrorToFailure(failureProvider);
  }
}

/// Extensions on Future result.
extension FutureResultExtensions<T> on Future<Result<T>> {
  /// Transforms all errors on this future to [FailureResult]s.
  Future<Result<T>> mapErrorToFailure(Failure Function(Object error) failureProvider) {
    return onError((Object error, StackTrace stackTrace) {
      return FailureResult(failureProvider(error), stackTrace);
    });
  }
}
