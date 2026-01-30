part of 'local_notification.dart';

/// Android channel/notification details.
final class LocalNotificationAndroidDetails {
  /// Creates a [LocalNotificationAndroidDetails].
  const LocalNotificationAndroidDetails({
    this.importance = LocalNotificationImportance.max,
    this.priority = LocalNotificationPriority.high,
    this.androidScheduleMode = LocalNotificationAndroidScheduleMode.inexactAllowWhileIdle,
    this.shouldPlaySound = true,
    this.shouldEnableVibration = true,
    this.shouldShowBadge = true,
    this.shouldEnableLights = false,
    this.color,
    this.style,
    this.vibrationPattern,
    this.ledColor,
  });

  /// The importance level of the notification.
  final LocalNotificationImportance importance;

  /// The priority level of the notification.
  final LocalNotificationPriority priority;

  /// Android schedule mode.
  final LocalNotificationAndroidScheduleMode androidScheduleMode;

  /// Whether to play a sound when the notification is shown.
  final bool shouldPlaySound;

  /// Whether to enable vibration when the notification is shown.
  final bool shouldEnableVibration;

  /// Whether to show a badge for the notification.
  final bool shouldShowBadge;

  /// Whether to enable LED lights for the notification.
  final bool shouldEnableLights;

  /// The color to use for the notification.
  final Color? color;

  /// The style to use for the notification.
  final LocalNotificationAndroidStyle? style;

  /// The vibration pattern to use.
  final Int64List? vibrationPattern;

  /// The color to use for the LED light.
  final Color? ledColor;
}

/// Android notification importance (mirrors Android's channel importance).
enum LocalNotificationImportance {
  /// No importance.
  none,

  /// Minimum importance.
  min,

  /// Low importance.
  low,

  /// Default importance.
  defaultImportance,

  /// High importance.
  high,

  /// Maximum importance.
  max,
}

/// Android notification priority.
enum LocalNotificationPriority {
  /// Minimum priority.
  min,

  /// Low priority.
  low,

  /// Default priority.
  defaultPriority,

  /// High priority.
  high,

  /// Maximum priority.
  max,
}

/// Base class for Android notification styles.
sealed class LocalNotificationAndroidStyle {}

/// Big picture style for Android notifications.
final class LocalNotificationBigPictureStyle implements LocalNotificationAndroidStyle {
  /// Creates a [LocalNotificationBigPictureStyle].
  const LocalNotificationBigPictureStyle({required this.imageFilePath});

  /// The file path of the image to display.
  final String imageFilePath;
}

/// Android schedule mode for a scheduled local notification.
enum LocalNotificationAndroidScheduleMode {
  /// Inexact schedule mode that allows the notification to be shown while the device is idle.
  inexactAllowWhileIdle,
}
