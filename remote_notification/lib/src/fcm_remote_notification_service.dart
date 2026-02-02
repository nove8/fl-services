import 'dart:async';
import 'dart:ui';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fcm;
import 'package:remote_notification_service/src/data_source/background_callback_handle_preferences_data_source.dart';
import 'package:remote_notification_service/src/entity/remote_notification.dart';
import 'package:remote_notification_service/src/failure/remote_notification_failure.dart';
import 'package:remote_notification_service/src/mapper/fcm_remote_notification_mappers.dart';
import 'package:remote_notification_service/src/remote_notification_service.dart';
import 'package:remote_notification_service/src/util/future_util.dart';
import 'package:remote_notification_service/src/util/object_util.dart';
import 'package:remote_notification_service/src/util/stream_util.dart';
import 'package:rxdart/rxdart.dart';

/// Implementation of [RemoteNotificationService] using Firebase Cloud Messaging (FCM).
final class FcmRemoteNotificationService implements RemoteNotificationService {
  /// Creates a new instance of [FcmRemoteNotificationService].
  /// Optionally accepts a [BackgroundRemoteNotificationHandler] to handle background notifications.
  FcmRemoteNotificationService({BackgroundRemoteNotificationHandler? onBackgroundRemoteNotification}) {
    _init(onBackgroundNotification: onBackgroundRemoteNotification);
  }

  final StreamController<Result<RemoteNotification>> _foregroundNotificationReceivedSubject =
      BehaviorSubject<Result<RemoteNotification>>();
  final StreamController<Result<RemoteNotification>> _notificationClickedSubject =
      BehaviorSubject<Result<RemoteNotification>>();

  final FcmRemoteMessageToRemoteNotificationMapper _fcmRemoteMessageToRemoteNotificationMapper =
      const FcmRemoteMessageToRemoteNotificationMapper();

  late final fcm.FirebaseMessaging _firebaseMessaging = fcm.FirebaseMessaging.instance;

  StreamSubscription<Result<fcm.RemoteMessage>>? _notificationOpenedAppStreamSubscription;
  StreamSubscription<Result<fcm.RemoteMessage>>? _foregroundNotificationReceivedStreamSubscription;

  @override
  Stream<Result<String>> get tokenRefreshedStream =>
      _firebaseMessaging.onTokenRefresh.mapToResultStream(RemoteNotificationTokenRefreshedFailure.new);

  @override
  Stream<Result<RemoteNotification>> get foregroundNotificationReceivedStream =>
      _foregroundNotificationReceivedSubject.stream;

  @override
  Stream<Result<RemoteNotification>> get notificationClickedStream => _notificationClickedSubject.stream;

  @override
  Future<Result<String?>> getToken() {
    return _firebaseMessaging.getToken().mapToResult(GetRemoteNotificationTokenFailure.new);
  }

  @override
  Future<void> dispose() async {
    await _notificationOpenedAppStreamSubscription?.cancel();
    await _foregroundNotificationReceivedStreamSubscription?.cancel();
    await _foregroundNotificationReceivedSubject.close();
    await _notificationClickedSubject.close();
  }

  void _init({
    required BackgroundRemoteNotificationHandler? onBackgroundNotification,
  }) {
    _evaluateBackgroundRemoteNotificationHandler(onBackgroundNotification);
    _listenNotificationOpened();
    _listenForegroundNotification();
    _listenBackgroundNotification();
  }

  void _listenNotificationOpened() {
    _firebaseMessaging.getInitialMessage().mapToResult(GetInitialRemoteNotificationFailure.new).mapAsync((
      fcm.RemoteMessage? initialMessage,
    ) {
      if (initialMessage != null) {
        _handleInitialMessage(initialMessage);
      }
    });
    _notificationOpenedAppStreamSubscription = fcm.FirebaseMessaging.onMessageOpenedApp
        .mapToResultStream(RemoteNotificationOpenedAppFailure.new)
        .listen(_onNotificationOpen);
  }

  void _handleInitialMessage(fcm.RemoteMessage message) {
    final RemoteNotification notification = _fcmRemoteMessageToRemoteNotificationMapper.transform(message);
    _notificationClickedSubject.add(notification.toSuccessResult());
  }

  void _onNotificationOpen(Result<fcm.RemoteMessage> messageResult) {
    final Result<RemoteNotification> notificationResult = messageResult.map(
      _fcmRemoteMessageToRemoteNotificationMapper.transform,
    );
    _notificationClickedSubject.add(notificationResult);
  }

  void _listenForegroundNotification() {
    _foregroundNotificationReceivedStreamSubscription = fcm.FirebaseMessaging.onMessage
        .mapToResultStream(ForegroundRemoteNotificationReceivedFailure.new)
        .listen(_onForegroundNotificationReceived);
  }

  void _onForegroundNotificationReceived(Result<fcm.RemoteMessage> messageResult) {
    final Result<RemoteNotification> notification = messageResult.map(
      _fcmRemoteMessageToRemoteNotificationMapper.transform,
    );
    _foregroundNotificationReceivedSubject.add(notification);
  }

  void _listenBackgroundNotification() {
    fcm.FirebaseMessaging.onBackgroundMessage(_handleBackgroundFcmRemoteNotificationReceipt);
  }
}

void _evaluateBackgroundRemoteNotificationHandler(
  BackgroundRemoteNotificationHandler? onBackgroundNotification,
) {
  if (onBackgroundNotification != null) {
    final CallbackHandle? callback = PluginUtilities.getCallbackHandle(onBackgroundNotification);

    if (callback == null) {
      throw StateError('''
          The backgroundRemoteNotificationHandler needs to be either a static function or a top 
          level function to be accessible as a Flutter entry point.''');
    }

    BackgroundCallbackHandlePreferencesDataSource.setBackgroundCallbackHandle(callback);
  }
}

@pragma('vm:entry-point')
Future<void> _handleBackgroundFcmRemoteNotificationReceipt(fcm.RemoteMessage message) async {
  final CallbackHandle? callbackHandle =
      await BackgroundCallbackHandlePreferencesDataSource.getBackgroundCallbackHandle().outputOrNull;
  final BackgroundRemoteNotificationHandler? notificationHandler = callbackHandle
      ?.let(PluginUtilities.getCallbackFromHandle)
      ?.castTo();
  if (notificationHandler != null) {
    final RemoteNotification notification = const FcmRemoteMessageToRemoteNotificationMapper().transform(
      message,
    );
    await notificationHandler.call(notification.toSuccessResult());
  }
}
