import 'package:common_result/common_result.dart';

/// Base class for all local notification failures.
sealed class LocalNotificationFailure implements Failure {}

/// Failure when canceling all scheduled notifications.
final class CancelAllScheduledNotificationsFailure implements LocalNotificationFailure {
  /// Creates a [CancelAllScheduledNotificationsFailure].
  const CancelAllScheduledNotificationsFailure(this.error);

  /// The error that occurred during canceling all scheduled notifications.
  final Object error;

  @override
  String toString() {
    return 'CancelAllScheduledNotificationsFailure{error: $error}';
  }
}

/// Failure when canceling a notification.
final class LocalNotificationNotCancelledFailure implements LocalNotificationFailure {
  /// Creates a [LocalNotificationNotCancelledFailure].
  const LocalNotificationNotCancelledFailure(this.error);

  /// The error that occurred during canceling a notification.
  final Object error;

  @override
  String toString() {
    return 'LocalNotificationNotCancelledFailure{error: $error}';
  }
}

/// Failure when scheduling a notification.
final class LocalNotificationNotScheduledFailure implements LocalNotificationFailure {
  /// Creates a [LocalNotificationNotScheduledFailure].
  const LocalNotificationNotScheduledFailure(this.error);

  /// The error that occurred during notification scheduling.
  final Object error;

  @override
  String toString() {
    return 'LocalNotificationNotScheduledFailure{error: $error}';
  }
}

/// Failure when getting the local timezone.
final class GetLocalTimezoneFailure implements LocalNotificationFailure {
  /// Creates a [GetLocalTimezoneFailure].
  const GetLocalTimezoneFailure(this.error);

  /// The error that occurred during getting the local timezone.
  final Object error;

  @override
  String toString() {
    return 'GetLocalTimezoneFailure{error: $error}';
  }
}

/// Failure when setting the local location for timezone.
final class SetLocalLocationFailure implements LocalNotificationFailure {
  /// Creates a [SetLocalLocationFailure].
  const SetLocalLocationFailure(this.error);

  /// The error that occurred during setting the local location for timezone.
  final Object error;

  @override
  String toString() {
    return 'SetLocalLocationFailure{error: $error}';
  }
}
