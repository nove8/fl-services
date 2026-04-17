import 'package:async/async.dart';
import 'package:common_result/common_result.dart';

/// Synchronously executes [valueProvider] and wraps the result in a [Result].
///
/// Returns a [SuccessResult] if [valueProvider] completes without errors,
/// or a [FailureResult] created via [failureProvider] if an exception is thrown.
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
