import 'package:async/async.dart';
import 'package:common_result/common_result.dart';

/// Extension methods for converting [Future] values to [Result] types with error handling
extension FutureExtensions<T> on Future<T> {
  /// Converts a [Future] to a [Future<Result>], mapping any errors to a [Failure].
  Future<Result<T>> mapToResult(Failure Function(Object error) failureProvider) {
    return toSuccessResultFuture().onError((Object error, StackTrace stackTrace) {
      return FailureResult(failureProvider(error), stackTrace);
    });
  }
}
