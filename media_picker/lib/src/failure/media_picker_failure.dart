import 'package:common_result/common_result.dart';

/// Base class for media picker related failures.
sealed class MediaPickerServiceFailure implements Failure {}

/// Failure when picking an image.
final class PickImageServiceFailure implements MediaPickerServiceFailure {
  /// Creates a [PickImageServiceFailure].
  const PickImageServiceFailure(this.error);

  /// The original error that caused the failure.
  final Object error;

  @override
  String toString() {
    return 'PickImageServiceFailure{error: $error}';
  }
}
