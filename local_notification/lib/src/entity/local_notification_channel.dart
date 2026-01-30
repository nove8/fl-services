/// Represents a notification channel configuration for local notifications.
final class LocalNotificationChannel {
  /// Creates a [LocalNotificationChannel].
  const LocalNotificationChannel({
    required this.id,
    required this.name,
    this.groupId,
    this.soundResourceName,
  });

  /// The unique identifier of notification channel.
  final String id;

  /// Notification channel name.
  final String name;

  /// The thread identifier for grouping notifications.
  final String? groupId;

  /// The name of the sound resource to play.
  final String? soundResourceName;
}
