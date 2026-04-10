import 'package:async/async.dart';
import 'package:common_result/common_result.dart';

/// Extension methods for converting [Future] values to [Result] types with error handling
extension FutureExtensions<T> on Future<T> {
  /// Converts a [Future] to a [Future<Result>], mapping any errors to a [Failure].
  Future<Result<T>> mapToResult(Failure Function(Object error) failureProvider) {
    return toSuccessResultFuture().mapErrorToFailure(failureProvider);
  }
}

/// Extension methods for handling errors in [Future<Result>] values
extension FutureResultExtensions<T> on Future<Result<T>> {
  /// Maps any errors that occur during the future execution to a [FailureResult].
  Future<Result<T>> mapErrorToFailure(Failure Function(Object error) failureProvider) {
    return onError((Object error, StackTrace stackTrace) {
      return FailureResult(failureProvider(error), stackTrace);
    });
  }
}
