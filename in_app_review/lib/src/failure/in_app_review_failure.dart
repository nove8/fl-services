import 'package:common_result/common_result.dart';

/// Base class for in-app review failures
sealed class InAppReviewFailure implements Failure {}

/// Failure that occurs when requesting an in-app review.
final class RequestInAppReviewFailure implements InAppReviewFailure {
  /// Creates a [RequestInAppReviewFailure].
  const RequestInAppReviewFailure(this.error);

  /// An error that occurred.
  final Object error;

  @override
  String toString() {
    return 'RequestInAppReviewFailure{error: $error}';
  }
}
