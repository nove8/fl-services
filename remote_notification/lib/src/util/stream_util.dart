import 'dart:async';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';

/// Extension on [Stream] to provide utility methods for working with results.
extension StreamExtensions<T> on Stream<T> {
  /// Transforms a [Stream] of [T] into a [Stream] of [Result<T>], wrapping each element in a [SuccessResult]
  /// and each error in a [FailureResult] using the provided [failureProvider].
  Stream<Result<T>> mapToResultStream(Failure Function(Object error) failureProvider) {
    return transform(
      StreamTransformer<T, Result<T>>.fromHandlers(
        handleData: (T value, EventSink<Result<Object?>> sink) => sink.add(value.toSuccessResult()),
        // ignore: prefer-trailing-comma
        handleError: (Object error, StackTrace stackTrace, EventSink<Result<Object?>> sink) {
          return sink.add(FailureResult(failureProvider(error), stackTrace));
        },
      ),
    );
  }
}
