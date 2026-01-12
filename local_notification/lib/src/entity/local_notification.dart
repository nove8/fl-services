import 'dart:typed_data';
import 'dart:ui';

part 'local_notification_android_details.dart';

part 'local_notification_darwin_details.dart';

/// Represents a local notification with scheduling information.
final class LocalNotification {
  /// Creates a [LocalNotification].
  const LocalNotification({
    required this.id,
    required this.title,
    required this.triggerDateTime,
    this.androidDetails = const LocalNotificationAndroidDetails(),
    this.darwinDetails = const LocalNotificationDarwinDetails(),
    this.body,
    this.payload,
    this.repeatInterval,
  });

  /// The unique identifier of the notification.
  final int id;

  /// The title of the notification.
  final String title;

  /// The body of the notification.
  final String? body;

  /// The date and time when the notification should be triggered.
  final DateTime triggerDateTime;

  /// Custom payload that will be returned on click.
  final String? payload;

  /// Repeat interval.
  final LocalNotificationRepeatInterval? repeatInterval;

  /// Android-specific channel and notification details.
  final LocalNotificationAndroidDetails androidDetails;

  /// iOS-specific notification details.
  final LocalNotificationDarwinDetails darwinDetails;
}

/// Repeat interval for a scheduled local notification.
enum LocalNotificationRepeatInterval {
  /// Repeat daily.
  daily,

  /// Repeat weekly.
  weekly,

  /// Repeat monthly.
  monthly,

  /// Repeat every three months.
  threeMonths,

  /// Repeat every six months.
  sixMonths,

  /// Repeat annually.
  annually,
}
