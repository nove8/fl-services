/// Configuration for the android foreground notification.
final class AndroidForegroundNotificationConfig {
  /// Creates a [AndroidForegroundNotificationConfig]
  const AndroidForegroundNotificationConfig({
    required this.notificationTitle,
    required this.notificationText,
    required this.notificationChannelName,
    required this.notificationIcon,
    required this.colorCode,
  });

  /// The title used for the foreground service notification.
  final String notificationTitle;

  /// The body used for the foreground service notification.
  final String notificationText;

  /// The user visible name of the notification channel.
  final String notificationChannelName;

  /// The resource name of the icon to be used for the foreground notification.
  final String notificationIcon;

  /// Color code (an ARGB integer) to be applied
  /// by the standard Style templates when presenting this notification.
  final int colorCode;
}
