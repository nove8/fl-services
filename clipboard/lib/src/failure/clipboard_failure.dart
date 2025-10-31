import 'package:common_result/common_result.dart';

/// Base class for clipboard failures
sealed class ClipboardFailure implements Failure {}

/// Failure that occurs when setting text to clipboard.
final class SetTextToClipboardFailure implements ClipboardFailure {
  /// Creates a [SetTextToClipboardFailure].
  const SetTextToClipboardFailure(this.error);

  /// An error that occurred.
  final Object error;

  @override
  String toString() {
    return 'SetTextToClipboardFailure{error: $error}';
  }
}
