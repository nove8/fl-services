/// Represents a remote notification received by the app.
final class RemoteNotification {
  /// Creates a [RemoteNotification] instance.
  const RemoteNotification({
    required this.notificationId,
    required this.title,
    required this.body,
    required this.additionalData,
  });

  /// A unique ID assigned to every notification.
  final String? notificationId;

  /// The notification title.
  final String? title;

  /// The notification body content.
  final String? body;

  /// Any additional data sent with the notification.
  final Map<String, Object?> additionalData;

  @override
  String toString() {
    return 'RemoteNotification{notificationId: $notificationId, title: $title, body: $body, additionalData: $additionalData}';
  }
}
