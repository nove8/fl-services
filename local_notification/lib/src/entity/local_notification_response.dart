/// Represents response from [NotificationResponse] on click a local notification.
final class LocalNotificationResponse {
  /// Creates a [LocalNotificationResponse].
  const LocalNotificationResponse({
    this.notificationId,
    this.payload,
  });

  /// The id of the clicked notification (if available).
  final int? notificationId;

  /// The payload of the clicked notification (if available).
  final String? payload;
}
