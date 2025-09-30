/// Represents a local notification with scheduling information.
final class LocalNotification {
  /// Creates a [LocalNotification].
  const LocalNotification({
    required this.id,
    required this.title,
    required this.triggerDateTime,
  });

  /// The unique identifier of the notification.
  final int id;

  /// The title of the notification.
  final String title;

  /// The date and time when the notification should be triggered.
  final DateTime triggerDateTime;
}
