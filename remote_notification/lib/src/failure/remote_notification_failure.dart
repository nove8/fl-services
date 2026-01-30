import 'package:common_result/common_result.dart';

/// Base class for Remote notification failures.
sealed class RemoteNotificationFailure implements Failure {}

/// Failure when getting remote notification token.
final class GetRemoteNotificationTokenFailure implements RemoteNotificationFailure {
  /// Creates a [GetRemoteNotificationTokenFailure].
  const GetRemoteNotificationTokenFailure(this.error);

  /// The error that occurred during getting the remote notification token.
  final Object error;

  @override
  String toString() {
    return 'GetRemoteNotificationTokenFailure{error: $error}';
  }
}
