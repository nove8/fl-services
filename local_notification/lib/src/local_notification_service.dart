import 'package:async/async.dart';
import 'package:local_notification_service/src/entity/local_notification.dart';
import 'package:local_notification_service/src/entity/local_notification_channel.dart';

/// Service interface for managing local notifications.
abstract interface class LocalNotificationService {
  /// Schedules a local notification to be shown at the specified time.
  Future<Result<void>> scheduleNotification({
    required LocalNotification notification,
    required LocalNotificationChannel channel,
  });

  /// Cancels all previously scheduled notifications.
  Future<Result<void>> cancelAllScheduledNotifications();
}
