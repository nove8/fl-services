// ignore_for_file: prefer-boolean-prefixes

import 'dart:typed_data';
import 'dart:ui';

/// Represents a notification channel configuration for local notifications.
final class LocalNotificationChannel {
  /// Creates a [LocalNotificationChannel].
  const LocalNotificationChannel({
    required this.id,
    required this.name,
    this.android,
    this.darwin,
  });

  /// The unique identifier of notification channel.
  final String id;

  /// Notification channel name.
  final String name;

  /// Android-specific channel and notification details.
  final LocalNotificationAndroidChannelDetails? android;

  /// iOS-specific notification details.
  final LocalNotificationDarwinChannelDetails? darwin;
}

/// Android channel/notification details.
final class LocalNotificationAndroidChannelDetails {
  /// Creates a [LocalNotificationAndroidChannelDetails].
  const LocalNotificationAndroidChannelDetails({
    this.groupKey,
    this.color,
    this.importance = LocalNotificationImportance.max,
    this.priority = LocalNotificationPriority.high,
    this.soundResourceName,
    this.style,
    this.playSound,
    this.enableVibration,
    this.vibrationPattern,
    this.showBadge,
    this.enableLights,
    this.ledColor,
  });

  /// The group key for grouping notifications.
  final String? groupKey;

  /// The color to use for the notification.
  final Color? color;

  /// The importance level of the notification.
  final LocalNotificationImportance importance;

  /// The priority level of the notification.
  final LocalNotificationPriority priority;

  /// The name of the sound resource to play.
  final String? soundResourceName;

  /// The style to use for the notification.
  final LocalNotificationAndroidStyle? style;

  /// Whether to play a sound when the notification is shown.
  final bool? playSound;

  /// Whether to enable vibration when the notification is shown.
  final bool? enableVibration;

  /// The vibration pattern to use.
  final Int64List? vibrationPattern;

  /// Whether to show a badge for the notification.
  final bool? showBadge;

  /// Whether to enable LED lights for the notification.
  final bool? enableLights;

  /// The color to use for the LED light.
  final Color? ledColor;
}

/// iOS (Darwin) notification details.
final class LocalNotificationDarwinChannelDetails {
  /// Creates a [LocalNotificationDarwinChannelDetails].
  const LocalNotificationDarwinChannelDetails({
    this.threadIdentifier,
    this.soundFileNameWithExtension,
    this.attachmentFilePaths,
  });

  /// The thread identifier for grouping notifications.
  final String? threadIdentifier;

  /// The name of the sound file to play (including extension).
  final String? soundFileNameWithExtension;

  /// The file paths of attachments to include with the notification.
  final List<String>? attachmentFilePaths;
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
