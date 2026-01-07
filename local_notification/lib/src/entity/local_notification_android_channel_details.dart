part of 'local_notification_channel.dart';

/// Android channel/notification details.
final class LocalNotificationAndroidChannelDetails {
  /// Creates a [LocalNotificationAndroidChannelDetails].
  const LocalNotificationAndroidChannelDetails({
    this.importance = LocalNotificationImportance.max,
    this.priority = LocalNotificationPriority.high,
    this.groupKey,
    this.color,
    this.soundResourceName,
    this.style,
    this.isPlaySound,
    this.isEnableVibration,
    this.vibrationPattern,
    this.isShowBadge,
    this.isEnableLights,
    this.ledColor,
  });

  /// The importance level of the notification.
  final LocalNotificationImportance importance;

  /// The priority level of the notification.
  final LocalNotificationPriority priority;

  /// The group key for grouping notifications.
  final String? groupKey;

  /// The color to use for the notification.
  final Color? color;

  /// The name of the sound resource to play.
  final String? soundResourceName;

  /// The style to use for the notification.
  final LocalNotificationAndroidStyle? style;

  /// Whether to play a sound when the notification is shown.
  final bool? isPlaySound;

  /// Whether to enable vibration when the notification is shown.
  final bool? isEnableVibration;

  /// The vibration pattern to use.
  final Int64List? vibrationPattern;

  /// Whether to show a badge for the notification.
  final bool? isShowBadge;

  /// Whether to enable LED lights for the notification.
  final bool? isEnableLights;

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
sealed class LocalNotificationAndroidStyle {
  /// Creates a [LocalNotificationAndroidStyle].
  const LocalNotificationAndroidStyle();
}

/// Big picture style for Android notifications.
final class LocalNotificationBigPictureStyle extends LocalNotificationAndroidStyle {
  /// Creates a [LocalNotificationBigPictureStyle].
  const LocalNotificationBigPictureStyle({required this.imageFilePath});

  /// The file path of the image to display.
  final String imageFilePath;
}
