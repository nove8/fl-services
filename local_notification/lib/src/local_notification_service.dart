import 'package:async/async.dart';
import 'package:local_notification_service/src/entity/local_notification.dart';
import 'package:local_notification_service/src/entity/local_notification_channel.dart';
import 'package:local_notification_service/src/entity/local_notification_response.dart';

/// Service interface for managing local notifications.
abstract interface class LocalNotificationService {
  /// Ensures that a notification channel is created on Android.
  ///
  /// On Android 8.0 (API level 26) and higher, notification channels are required
  /// to display notifications. This method creates a channel with the specified
  /// configuration if it doesn't exist.
  ///
  /// On non-Android platforms, this method completes successfully without any action.
  ///
  /// Returns a [Result] that is successful if the channel was created or already exists,
  /// or contains a failure if the channel creation failed.
  Future<Result<void>> ensureAndroidChannelCreated({required LocalNotificationChannel channel});

  /// Stream that emits when a notification is clicked.
  Stream<LocalNotificationResponse> getClickedNotificationResponseStream();

  /// Schedules a local notification to be shown at the specified time.
  Future<Result<void>> scheduleNotification({
    required LocalNotification notification,
    required LocalNotificationChannel channel,
  });

  /// Shows a local notification immediately.
  Future<Result<void>> showNotification({
    required LocalNotification notification,
    required LocalNotificationChannel channel,
  });

  /// Cancels a previously scheduled  notification with the specified ID.
  ///
  /// This applies to notifications that have been scheduled and those that
  /// have already been presented.
  Future<Result<void>> cancelNotification({required int notificationId});

  /// Cancels all previously scheduled notifications.
  Future<Result<void>> cancelAllScheduledNotifications();

  /// Checks if a notification channel is enabled.
  Future<Result<bool>> isNotificationChannelEnabled({required String notificationChannelId});

  /// Disposes the service, cancels stream subscriptions and closes stream controllers
  Future<void> dispose();
}
