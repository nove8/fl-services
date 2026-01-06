/// Represents a click on a local notification.
final class LocalNotificationClick {
  /// Creates a [LocalNotificationClick].
  const LocalNotificationClick({
    this.notificationId,
    this.payload,
  });

  /// The id of the clicked notification (if available).
  final int? notificationId;

  /// The payload of the clicked notification (if available).
  final String? payload;
}
