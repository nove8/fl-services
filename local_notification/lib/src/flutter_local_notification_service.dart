import 'dart:async';

import 'package:async/async.dart';
import 'package:collection/collection.dart';
import 'package:common_result/common_result.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:local_notification_service/src/entity/channel/local_notification_channel.dart';
import 'package:local_notification_service/src/entity/flutter_local_notification_android_initialization_settings.dart';
import 'package:local_notification_service/src/entity/local_notification.dart';
import 'package:local_notification_service/src/entity/local_notification_response.dart';
import 'package:local_notification_service/src/failure/local_notification_failure.dart';
import 'package:local_notification_service/src/local_notification_service.dart';
import 'package:local_notification_service/src/mapper/local_notification_channel_mapper.dart';
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

  final StreamController<LocalNotificationResponse> _clickedNotificationResponseController =
      BehaviorSubject<LocalNotificationResponse>();

  final LocalNotificationAndroidStyleToStyleInformationMapper _androidStyleToStyleInformationMapper =
      const LocalNotificationAndroidStyleToStyleInformationMapper();
  final LocalNotificationImportanceToAndroidImportanceMapper _importanceToAndroidImportanceMapper =
      const LocalNotificationImportanceToAndroidImportanceMapper();
  final LocalNotificationPriorityToAndroidPriorityMapper _priorityToAndroidPriorityMapper =
      const LocalNotificationPriorityToAndroidPriorityMapper();
  final LocalNotificationSoundToAndroidSoundMapper _soundToAndroidSoundMapper =
      const LocalNotificationSoundToAndroidSoundMapper();
  final LocalNotificationFilePathToDarwinNotificationAttachmentMapper _filePathToAttachmentMapper =
      const LocalNotificationFilePathToDarwinNotificationAttachmentMapper();
  final LocalNotificationScheduleModeToAndroidScheduleModeMapper _scheduleModeToAndroidScheduleModeMapper =
      const LocalNotificationScheduleModeToAndroidScheduleModeMapper();
  final LocalNotificationRepeatIntervalToDateTimeComponentsMapper _repeatIntervalToDateTimeComponentsMapper =
      const LocalNotificationRepeatIntervalToDateTimeComponentsMapper();
  late final LocalNotificationChannelToAndroidNotificationChannelMapper
  _channelToAndroidNotificationChannelMapper = LocalNotificationChannelToAndroidNotificationChannelMapper(
    _importanceToAndroidImportanceMapper,
    _soundToAndroidSoundMapper,
  );

  late final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  Stream<LocalNotificationResponse> getClickedNotificationResponseStream() {
    return _clickedNotificationResponseController.stream;
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
          payload: notification.payload,
          timezone.TZDateTime.from(notification.triggerDateTime, timezone.local),
          _obtainNotificationDetails(channel: channel),
          androidScheduleMode: _scheduleModeToAndroidScheduleModeMapper.transform(
            notification.androidScheduleMode,
          ),
          matchDateTimeComponents: _repeatIntervalToDateTimeComponentsMapper.transform(
            notification.repeatInterval,
          ),
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
  Future<Result<bool>> isNotificationChannelEnabled({required String notificationChannelId}) {
    return _getAndroidNotificationsPlugin() == null
        ? true.toFutureSuccessResult()
        : _obtainNotificationChannels().mapAsync((List<AndroidNotificationChannel>? notificationChannels) {
            return notificationChannels
                    ?.firstWhereOrNull((AndroidNotificationChannel channel) {
                      return channel.id == notificationChannelId;
                    })
                    ?.let((AndroidNotificationChannel channel) {
                      return channel.importance != Importance.none;
                    }) ??
                false;
          });
  }

  @override
  Future<void> dispose() {
    return _clickedNotificationResponseController.close();
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
    return _getAndroidNotificationsPlugin()?.createNotificationChannel(
      _channelToAndroidNotificationChannelMapper.transform(channel),
    );
  }

  AndroidFlutterLocalNotificationsPlugin? _getAndroidNotificationsPlugin() {
    return _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  }

  NotificationDetails _obtainNotificationDetails({required LocalNotificationChannel channel}) {
    final LocalNotificationAndroidChannelDetails androidDetails = channel.androidDetails;
    final LocalNotificationDarwinChannelDetails darwinDetails = channel.darwinDetails;

    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        groupKey: androidDetails.groupId,
        color: androidDetails.color,
        importance: _importanceToAndroidImportanceMapper.transform(androidDetails.importance),
        priority: _priorityToAndroidPriorityMapper.transform(androidDetails.priority),
        sound: _soundToAndroidSoundMapper.transform(androidDetails.soundResourceName),
        styleInformation: _androidStyleToStyleInformationMapper.transform(androidDetails.style),
      ),
      iOS: DarwinNotificationDetails(
        threadIdentifier: darwinDetails.groupId ?? channel.id,
        sound: darwinDetails.soundFileNameWithExtension,
        attachments: _filePathToAttachmentMapper.transform(darwinDetails.attachmentFilePaths),
      ),
    );
  }

  Future<Result<List<AndroidNotificationChannel>?>> _obtainNotificationChannels() async {
    try {
      final AndroidFlutterLocalNotificationsPlugin? androidNotificationsPlugin =
          _getAndroidNotificationsPlugin();
      return await (androidNotificationsPlugin == null
          ? null.toFutureSuccessResult()
          : androidNotificationsPlugin.getNotificationChannels().mapToResult(
              GetNotificationChannelsFailure.new,
            ));
    } on Object catch (error, stackTrace) {
      return FailureResult(GetNotificationChannelsFailure(error), stackTrace);
    }
  }

  void _onNotificationClick(NotificationResponse? response) {
    final LocalNotificationResponse localNotificationResponse = LocalNotificationResponse(
      notificationId: response?.id,
      payload: response?.payload,
    );
    _clickedNotificationResponseController.add(localNotificationResponse);
  }
}
