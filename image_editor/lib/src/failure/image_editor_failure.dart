import 'package:common_result/common_result.dart';

/// Base class for image editor service related failures.
sealed class ImageEditorFailure implements Failure {}

/// Failure when image editing returns no result.
final class MissingResultImageEditorFailure implements ImageEditorFailure {
  /// Creates a [MissingResultImageEditorFailure].
  const MissingResultImageEditorFailure();
}

/// Failure when an unknown error occurs during image editing.
final class CommonImageEditorFailure implements ImageEditorFailure {
  /// Creates an [CommonImageEditorFailure].
  const CommonImageEditorFailure(this.error);

  /// The original error that caused the failure.
  final Object error;

  @override
  String toString() {
    return 'UnknownImageEditorFailure{error: $error}';
  }
}
