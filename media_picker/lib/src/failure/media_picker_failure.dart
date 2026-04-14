import 'package:common_result/common_result.dart';

/// Base class for media picker related failures.
sealed class MediaPickerFailure implements Failure {}

/// Failure when picking an image.
final class PickImageFailure implements MediaPickerFailure {
  /// Creates a [PickImageFailure].
  const PickImageFailure(this.error);

  /// The original error that caused the failure.
  final Object error;

  @override
  String toString() {
    return 'PickImageFailure{error: $error}';
  }
}
