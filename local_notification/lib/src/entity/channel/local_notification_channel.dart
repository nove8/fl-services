import 'dart:typed_data';
import 'dart:ui';

part 'local_notification_android_channel_details.dart';

part 'local_notification_darwin_channel_details.dart';

/// Represents a notification channel configuration for local notifications.
final class LocalNotificationChannel {
  /// Creates a [LocalNotificationChannel].
  const LocalNotificationChannel({
    required this.id,
    required this.name,
    this.androidDetails = const LocalNotificationAndroidChannelDetails(),
    this.darwinDetails = const LocalNotificationDarwinChannelDetails(),
  });

  /// The unique identifier of notification channel.
  final String id;

  /// Notification channel name.
  final String name;

  /// Android-specific channel and notification details.
  final LocalNotificationAndroidChannelDetails androidDetails;

  /// iOS-specific notification details.
  final LocalNotificationDarwinChannelDetails darwinDetails;
}
