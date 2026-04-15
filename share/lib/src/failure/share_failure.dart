import 'package:common_result/common_result.dart';

/// Base class for share failures.
sealed class ShareFailure implements Failure {}

/// Failure that occurs when the user dismissed the share sheet.
final class SharingDismissedFailure implements ShareFailure {
  /// Creates a [SharingDismissedFailure].
  const SharingDismissedFailure();
}

/// Failure that occurs when the platform cannot determine the share result.
final class UnavailableToShareFailure implements ShareFailure {
  /// Creates an [UnavailableToShareFailure].
  const UnavailableToShareFailure();
}

/// Failure that occurs when an unexpected error happens during sharing.
final class OtherShareFailure implements ShareFailure {
  /// Creates an [OtherShareFailure].
  const OtherShareFailure(this.error);

  /// An error that occurred.
  final Object error;

  @override
  String toString() {
    return 'OtherShareFailure{error: $error}';
  }
}
