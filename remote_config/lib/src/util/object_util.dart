import 'package:async/async.dart';
import 'package:common_result/common_result.dart';

/// Transforms all errors from [valueProvider] to [FailureResult]s.
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
