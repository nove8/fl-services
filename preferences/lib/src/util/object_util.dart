import 'package:async/async.dart';
import 'package:common_result/common_result.dart';

extension NullableObjectExtensions<T> on T {
  Future<T> toFuture() => Future<T>.value(this);
}

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
