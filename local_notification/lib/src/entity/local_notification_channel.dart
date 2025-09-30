/// Represents a notification channel configuration for local notifications.
final class LocalNotificationChannel {
  /// Creates a [LocalNotificationChannel].
  const LocalNotificationChannel({
    required this.id,
    required this.name,
  });

  /// The unique identifier of notification channel.
  final String id;

  /// Notification channel name.
  final String name;
}
