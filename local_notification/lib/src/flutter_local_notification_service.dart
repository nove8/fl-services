import 'dart:async';

import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:common_result/common_result.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:local_notification_service/src/entity/flutter_local_notification_android_initialization_settings.dart';
import 'package:local_notification_service/src/entity/local_notification.dart';
import 'package:local_notification_service/src/entity/local_notification_channel.dart';
import 'package:local_notification_service/src/entity/local_notification_response.dart';
import 'package:local_notification_service/src/failure/local_notification_failure.dart';
import 'package:local_notification_service/src/local_notification_service.dart';
import 'package:local_notification_service/src/util/async_util.dart';
import 'package:local_notification_service/src/util/object_util.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as timezone_data;
import 'package:timezone/timezone.dart' as timezone;

/// Flutter implementation of [LocalNotificationService] using flutter_local_notifications plugin.
final class FlutterLocalNotificationService implements LocalNotificationService {
  /// Returns the singleton instance of [FlutterLocalNotificationService].
  factory FlutterLocalNotificationService({
    required FlutterLocalNotificationAndroidInitializationSettings androidInitializationSettings,
  }) {
    return _instance ??= FlutterLocalNotificationService._(
      androidInitializationSettings: androidInitializationSettings,
    );
  }

  FlutterLocalNotificationService._({required this.androidInitializationSettings}) {
    _init();
  }

  static FlutterLocalNotificationService? _instance;

  /// Android initialization settings.
  final FlutterLocalNotificationAndroidInitializationSettings androidInitializationSettings;

  final StreamController<LocalNotificationResponse> _clickedNotificationResponseSubject =
      BehaviorSubject<LocalNotificationResponse>();

  late final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Stream<LocalNotificationResponse> getClickedNotificationResponseStream() {
    return _clickedNotificationResponseSubject.stream;
  }

  @override
  Future<Result<void>> scheduleNotification({
    required LocalNotification notification,
    required LocalNotificationChannel channel,
  }) async {
    await _setLocalLocation();
    await _ensureAndroidChannelCreated(channel);

    return _localNotificationsPlugin
        .zonedSchedule(
          notification.id,
          notification.title,
          notification.body,
          timezone.TZDateTime.from(notification.triggerDateTime, timezone.local),
          _obtainNotificationDetails(channel: channel),
          androidScheduleMode: _obtainAndroidScheduleMode(notification.androidScheduleMode),
          payload: notification.payload,
          matchDateTimeComponents: _obtainDateTimeComponents(notification.repeatInterval),
        )
        .mapToResult(LocalNotificationNotScheduledFailure.new);
  }

  @override
  Future<Result<void>> showNotification({
    required LocalNotification notification,
    required LocalNotificationChannel channel,
  }) async {
    await _ensureAndroidChannelCreated(channel);

    return _localNotificationsPlugin
        .show(
          notification.id,
          notification.title,
          notification.body,
          _obtainNotificationDetails(channel: channel),
          payload: notification.payload,
        )
        .mapToResult(LocalNotificationNotShownFailure.new);
  }

  @override
  Future<Result<void>> cancelNotification({required int notificationId}) {
    return _localNotificationsPlugin
        .cancel(notificationId)
        .mapToResult(LocalNotificationNotCancelledFailure.new);
  }

  @override
  Future<Result<void>> cancelAllScheduledNotifications() {
    return _localNotificationsPlugin.cancelAllPendingNotifications().mapToResult(
      CancelAllScheduledNotificationsFailure.new,
    );
  }

  @override
  Future<Result<bool?>> isNotificationChannelEnabled({required String notificationChannelId}) async {
    final List<AndroidNotificationChannel>? notificationChannels = await _obtainNotificationChannels();
    final AndroidNotificationChannel? notificationChannel = notificationChannels?.firstWhereOrNull(
      (AndroidNotificationChannel channel) => channel.id == notificationChannelId,
    );
    final bool? isNotificationChannelEnabled = notificationChannel?.let(
      (AndroidNotificationChannel channel) => channel.importance != Importance.none,
    );

    // TODO: Return true for not Android platform
    return isNotificationChannelEnabled.toFutureSuccessResult();
  }

  @override
  Future<void> dispose() {
    return _clickedNotificationResponseSubject.close();
  }

  Future<void> _init() async {
    timezone_data.initializeTimeZones();
    await _checkIsAppLaunchedByNotification();
    await _initializePlugin();
  }

  Future<void> _checkIsAppLaunchedByNotification() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails = await _localNotificationsPlugin
        .getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails != null && notificationAppLaunchDetails.didNotificationLaunchApp) {
      _onNotificationClick(notificationAppLaunchDetails.notificationResponse);
    }
  }

  Future<void> _initializePlugin() {
    return _localNotificationsPlugin.initialize(
      InitializationSettings(
        iOS: const DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
        android: AndroidInitializationSettings(androidInitializationSettings.iconResourceName),
      ),
      onDidReceiveNotificationResponse: _onNotificationClick,
    );
  }

  Future<Result<void>> _setLocalLocation() {
    return _getLocalTimezoneIdentifier().flatMapAsync(_setLocalLocationForTimezoneIdentifier);
  }

  // TODO take out to separate service to use timezone independently
  Future<Result<String>> _getLocalTimezoneIdentifier() {
    return FlutterTimezone.getLocalTimezone()
        .mapToResult(GetLocalTimezoneFailure.new)
        .mapAsync((TimezoneInfo timezoneInfo) => timezoneInfo.identifier);
  }

  Result<void> _setLocalLocationForTimezoneIdentifier(String timezoneIdentifier) {
    return mapToResult(
      valueProvider: () => timezone.setLocalLocation(timezone.getLocation(timezoneIdentifier)),
      failureProvider: SetLocalLocationFailure.new,
    );
  }

  Future<void> _ensureAndroidChannelCreated(LocalNotificationChannel channel) async {
    final AndroidNotificationChannel androidChannel = _obtainAndroidNotificationChannel(channel: channel);

    return _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  AndroidNotificationChannel _obtainAndroidNotificationChannel({required LocalNotificationChannel channel}) {
    final LocalNotificationAndroidChannelDetails? androidDetails = channel.androidDetails;

    return AndroidNotificationChannel(
      channel.id,
      channel.name,
      importance: _obtainImportance(androidDetails?.importance),
      playSound: androidDetails?.isPlaySound ?? true,
      sound: _obtainAndroidSound(androidDetails?.soundResourceName),
      enableVibration: androidDetails?.isEnableVibration ?? true,
      vibrationPattern: androidDetails?.vibrationPattern,
      showBadge: androidDetails?.isShowBadge ?? true,
      enableLights: androidDetails?.isEnableLights ?? false,
      ledColor: androidDetails?.ledColor,
    );
  }

  NotificationDetails _obtainNotificationDetails({required LocalNotificationChannel channel}) {
    final LocalNotificationAndroidChannelDetails? androidDetails = channel.androidDetails;
    final LocalNotificationDarwinChannelDetails? darwinDetails = channel.darwinDetails;

    final StyleInformation? style = _obtainAndroidStyle(androidDetails?.style);

    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        groupKey: androidDetails?.groupKey,
        color: androidDetails?.color,
        importance: _obtainImportance(androidDetails?.importance),
        priority: _obtainPriority(androidDetails?.priority),
        sound: _obtainAndroidSound(androidDetails?.soundResourceName),
        styleInformation: style,
      ),
      iOS: DarwinNotificationDetails(
        threadIdentifier: darwinDetails?.threadIdentifier ?? channel.id,
        sound: darwinDetails?.soundFileNameWithExtension,
        attachments: _obtainDarwinAttachments(darwinDetails?.attachmentFilePaths),
      ),
    );
  }

  StyleInformation? _obtainAndroidStyle(LocalNotificationAndroidStyle? style) {
    return switch (style) {
      final LocalNotificationBigPictureStyle localNotificationBigPictureStyle => BigPictureStyleInformation(
        FilePathAndroidBitmap(localNotificationBigPictureStyle.imageFilePath),
      ),
      null => null,
    };
  }

  Importance _obtainImportance(LocalNotificationImportance? importance) {
    return switch (importance) {
      LocalNotificationImportance.none => Importance.none,
      LocalNotificationImportance.min => Importance.min,
      LocalNotificationImportance.low => Importance.low,
      LocalNotificationImportance.defaultImportance => Importance.defaultImportance,
      LocalNotificationImportance.high => Importance.high,
      LocalNotificationImportance.max || null => Importance.max,
    };
  }

  Priority _obtainPriority(LocalNotificationPriority? priority) {
    return switch (priority) {
      LocalNotificationPriority.min => Priority.min,
      LocalNotificationPriority.low => Priority.low,
      LocalNotificationPriority.defaultPriority => Priority.defaultPriority,
      LocalNotificationPriority.high || null => Priority.high,
      LocalNotificationPriority.max => Priority.max,
    };
  }

  RawResourceAndroidNotificationSound? _obtainAndroidSound(String? soundResourceName) {
    return soundResourceName == null ? null : RawResourceAndroidNotificationSound(soundResourceName);
  }

  List<DarwinNotificationAttachment>? _obtainDarwinAttachments(List<String>? filePaths) {
    return filePaths?.map(DarwinNotificationAttachment.new).toList();
  }

  AndroidScheduleMode _obtainAndroidScheduleMode(LocalNotificationAndroidScheduleMode scheduleMode) {
    return switch (scheduleMode) {
      LocalNotificationAndroidScheduleMode.inexactAllowWhileIdle => AndroidScheduleMode.inexactAllowWhileIdle,
    };
  }

  DateTimeComponents? _obtainDateTimeComponents(LocalNotificationRepeatInterval? repeatInterval) {
    return switch (repeatInterval) {
      LocalNotificationRepeatInterval.daily => DateTimeComponents.time,
      LocalNotificationRepeatInterval.weekly => DateTimeComponents.dayOfWeekAndTime,
      LocalNotificationRepeatInterval.monthly => DateTimeComponents.dayOfMonthAndTime,
      LocalNotificationRepeatInterval.threeMonths ||
      LocalNotificationRepeatInterval.sixMonths ||
      LocalNotificationRepeatInterval.annually => DateTimeComponents.dateAndTime,
      null => null,
    };
  }

  Future<List<AndroidNotificationChannel>?> _obtainNotificationChannels() async {
    final List<AndroidNotificationChannel>? notificationChannels = await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.getNotificationChannels();
    return notificationChannels;
  }

  void _onNotificationClick(NotificationResponse? response) {
    final LocalNotificationResponse localNotificationResponse = LocalNotificationResponse(
      notificationId: response?.id,
      payload: response?.payload,
    );
    _clickedNotificationResponseSubject.add(localNotificationResponse);
  }
}
