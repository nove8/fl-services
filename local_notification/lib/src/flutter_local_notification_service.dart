import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:local_notification_service/src/entity/flutter_local_notification_android_initialization_settings.dart';
import 'package:local_notification_service/src/entity/local_notification.dart';
import 'package:local_notification_service/src/entity/local_notification_channel.dart';
import 'package:local_notification_service/src/failure/local_notification_failure.dart';
import 'package:local_notification_service/src/local_notification_service.dart';
import 'package:local_notification_service/src/util/async_util.dart';
import 'package:local_notification_service/src/util/object_util.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart' as tz;

/// Flutter implementation of [LocalNotificationService] using flutter_local_notifications plugin.
final class FlutterLocalNotificationService implements LocalNotificationService {
  FlutterLocalNotificationService._({required this.androidInitializationSettings}) {
    _init();
  }

  static FlutterLocalNotificationService? _instance;

  /// Android initialization settings.
  final FlutterLocalNotificationAndroidInitializationSettings androidInitializationSettings;

  late final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Returns the singleton instance of [FlutterLocalNotificationService].
  // ignore:prefer_constructors_over_static_methods
  static FlutterLocalNotificationService getInstance({
    required FlutterLocalNotificationAndroidInitializationSettings androidInitializationSettings,
  }) {
    return _instance ??= FlutterLocalNotificationService._(
      androidInitializationSettings: androidInitializationSettings,
    );
  }

  @override
  Future<Result<void>> scheduleNotification({
    required LocalNotification notification,
    required LocalNotificationChannel channel,
  }) async {
    await _setLocalLocation();
    return _localNotificationsPlugin
        .zonedSchedule(
          notification.id,
          notification.title,
          null,
          tz.TZDateTime.from(notification.triggerDateTime, tz.local),
          _obtainNotificationDetails(channel: channel),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        )
        .mapToResult(LocalNotificationNotScheduledFailure.new);
  }

  @override
  Future<Result<void>> cancelAllScheduledNotifications() {
    return _localNotificationsPlugin.cancelAllPendingNotifications().mapToResult(
      CancelAllScheduledNotificationsFailure.new,
    );
  }

  Future<Result<void>> _setLocalLocation() {
    return _getLocalTimezoneIdentifier().flatMapAsync(_setLocalLocationForTimezoneIdentifier);
  }

  Future<Result<String>> _getLocalTimezoneIdentifier() {
    return FlutterTimezone.getLocalTimezone()
        .mapToResult(GetLocalTimezoneFailure.new)
        .mapAsync((TimezoneInfo timezoneInfo) => timezoneInfo.identifier);
  }

  Result<void> _setLocalLocationForTimezoneIdentifier(String timezoneIdentifier) {
    return mapToResult(
      valueProvider: () => tz.setLocalLocation(tz.getLocation(timezoneIdentifier)),
      failureProvider: SetLocalLocationFailure.new,
    );
  }

  NotificationDetails _obtainNotificationDetails({required LocalNotificationChannel channel}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  Future<void> _init() async {
    initializeTimeZones();
    await _localNotificationsPlugin.initialize(
      InitializationSettings(
        iOS: const DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
        android: AndroidInitializationSettings(androidInitializationSettings.iconResourceName),
      ),
    );
  }
}
