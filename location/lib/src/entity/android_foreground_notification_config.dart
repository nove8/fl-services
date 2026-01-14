/// Configuration for the android foreground notification.
final class AndroidForegroundNotificationConfig {
  /// Creates a [AndroidForegroundNotificationConfig]
  const AndroidForegroundNotificationConfig({
    required this.notificationTitle,
    required this.notificationBody,
    required this.notificationChannelName,
    required this.notificationIconResName,
    required this.colorCode,
  });

  /// The title used for the foreground service notification.
  final String notificationTitle;

  /// The body used for the foreground service notification.
  final String notificationBody;

  /// The user visible name of the notification channel.
  final String notificationChannelName;

  /// The resource name of the icon to be used for the foreground notification.
  ///
  /// This should be the resource name without extension (e.g., "ic_notification")
  /// and must be located in the native Android drawable directory.
  final String notificationIconResName;

  /// Color code to be applied by the standard Style templates when presenting this notification.
  ///
  /// This is an ARGB integer in the format 0xAARRGGBB, where:
  /// - AA: Alpha channel (transparency, 00-FF)
  /// - RR: Red channel (00-FF)
  /// - GG: Green channel (00-FF)
  /// - BB: Blue channel (00-FF)
  ///
  /// Example: `0xFF6200EE` for a solid purple color (fully opaque).
  final int colorCode;
}
