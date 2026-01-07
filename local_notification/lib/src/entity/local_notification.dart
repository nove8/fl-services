/// Represents a local notification with scheduling information.
final class LocalNotification {
  /// Creates a [LocalNotification].
  const LocalNotification({
    required this.id,
    required this.title,
    required this.triggerDateTime,
    this.androidScheduleMode = LocalNotificationAndroidScheduleMode.inexactAllowWhileIdle,
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

  /// Android schedule mode.
  final LocalNotificationAndroidScheduleMode androidScheduleMode;
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

/// Android schedule mode for a scheduled local notification.
enum LocalNotificationAndroidScheduleMode {
  /// Inexact schedule mode that allows the notification to be shown while the device is idle.
  inexactAllowWhileIdle,
}
