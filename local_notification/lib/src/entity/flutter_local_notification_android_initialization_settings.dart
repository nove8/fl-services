/// Android-specific initialization settings for local notifications for Android.
final class FlutterLocalNotificationAndroidInitializationSettings {
  /// Creates a [FlutterLocalNotificationAndroidInitializationSettings].
  const FlutterLocalNotificationAndroidInitializationSettings({
    required this.iconResourceName,
  });

  /// The name of the drawable resource to use as the notification icon.
  final String iconResourceName;
}
