import 'package:async/async.dart';
import 'package:common_result/common_result.dart';

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

/// Extensions on nullable objects.
extension NullableObjectExtensions<T> on T {
  /// Calls the specified function [block] with `this` value as its argument and returns its result.
  R let<R>(R Function(T) block) => block(this);
}
