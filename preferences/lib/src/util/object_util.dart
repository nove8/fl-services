import 'package:async/async.dart';
import 'package:common_result/common_result.dart';

/// Extension methods for nullable objects to provide additional utility functionality.
extension NullableObjectExtensions<T> on T {
  /// Wraps this value in a [Future] that completes immediately with the value.
  Future<T> toFuture() => Future<T>.value(this);
}

/// Maps a value provider function to a [Result], catching any exceptions
/// and converting them to [Failure] results.
Result<T> mapToResult<T>({
  required T Function() valueProvider,
  required Failure Function(Object error) failureProvider,
}) {
  try {
    return valueProvider.call().toSuccessResult();
  } catch (error, stackTrace) {
    return FailureResult(failureProvider(error), stackTrace);
  }
}
