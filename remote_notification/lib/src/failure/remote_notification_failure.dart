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

/// Failure when getting initial remote notification.
final class GetInitialRemoteNotificationFailure implements RemoteNotificationFailure {
  /// Creates a [GetInitialRemoteNotificationFailure].
  const GetInitialRemoteNotificationFailure(this.error);

  /// The error that occurred while getting the initial remote notification.
  final Object error;

  @override
  String toString() {
    return 'GetInitialRemoteNotificationFailure{error: $error}';
  }
}

/// Failure when refreshing remote notification token.
final class RemoteNotificationTokenRefreshedFailure implements RemoteNotificationFailure {
  /// Creates a [RemoteNotificationTokenRefreshedFailure].
  const RemoteNotificationTokenRefreshedFailure(this.error);

  /// The error that occurred during refreshing the remote notification token.
  final Object error;

  @override
  String toString() {
    return 'RemoteNotificationTokenRefreshedFailure{error: $error}';
  }
}

/// Failure when opening the app from a remote notification.
final class RemoteNotificationOpenedAppFailure implements RemoteNotificationFailure {
  /// Creates a [RemoteNotificationOpenedAppFailure].
  const RemoteNotificationOpenedAppFailure(this.error);

  /// The error that occurred while opening the app from a remote notification.
  final Object error;

  @override
  String toString() {
    return 'RemoteNotificationOpenedAppFailure{error: $error}';
  }
}

/// Failure when receiving a remote notification in the foreground.
final class ForegroundRemoteNotificationReceivedFailure implements RemoteNotificationFailure {
  /// Creates a [ForegroundRemoteNotificationReceivedFailure].
  const ForegroundRemoteNotificationReceivedFailure(this.error);

  /// The error that occurred while receiving a remote notification in the foreground.
  final Object error;

  @override
  String toString() {
    return 'ForegroundRemoteNotificationReceivedFailure{error: $error}';
  }
}
