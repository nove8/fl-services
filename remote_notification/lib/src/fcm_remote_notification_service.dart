import 'dart:async';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fcm;
import 'package:remote_notification_service/src/entity/remote_notification.dart';
import 'package:remote_notification_service/src/failure/remote_notification_failure.dart';
import 'package:remote_notification_service/src/mapper/fcm_remote_notification_mappers.dart';
import 'package:remote_notification_service/src/remote_notification_service.dart';
import 'package:remote_notification_service/src/util/future_util.dart';
import 'package:rxdart/rxdart.dart';

/// Implementation of [RemoteNotificationService] using Firebase Cloud Messaging (FCM).
final class FcmRemoteNotificationService implements RemoteNotificationService {
  /// Returns the singleton instance of [FcmRemoteNotificationService].
  factory FcmRemoteNotificationService() => _instance ??= FcmRemoteNotificationService._();

  FcmRemoteNotificationService._() {
    _init();
  }

  static FcmRemoteNotificationService? _instance;

  final BehaviorSubject<Result<RemoteNotification>> _foregroundNotificationReceivedSubject =
      BehaviorSubject<Result<RemoteNotification>>();
  final BehaviorSubject<Result<RemoteNotification>> _notificationClickedSubject =
      BehaviorSubject<Result<RemoteNotification>>();

  final FcmRemoteMessageToRemoteNotificationMapper _fcmRemoteMessageToRemoteNotificationMapper =
      const FcmRemoteMessageToRemoteNotificationMapper();

  late final fcm.FirebaseMessaging _firebaseMessaging = fcm.FirebaseMessaging.instance;

  StreamSubscription<fcm.RemoteMessage>? _notificationOpenedAppStreamSubscription;

  @override
  Result<Stream<String>> get tokenRefreshedStream => _firebaseMessaging.onTokenRefresh.toSuccessResult();

  @override
  Stream<Result<RemoteNotification>> get foregroundNotificationReceivedStream =>
      _foregroundNotificationReceivedSubject;

  @override
  Stream<Result<RemoteNotification>> get remoteNotificationClickedStream => _notificationClickedSubject;

  @override
  Future<Result<String?>> getToken() {
    return _firebaseMessaging.getToken().mapToResult(GetRemoteNotificationTokenFailure.new);
  }

  @override
  Future<void> dispose() async {
    await _notificationOpenedAppStreamSubscription?.cancel();
    await _foregroundNotificationReceivedSubject.close();
    await _notificationClickedSubject.close();
  }

  void _init() {
    _listenNotificationOpened();
    _listenForegroundNotification();
  }

  void _listenNotificationOpened() {
    _firebaseMessaging.getInitialMessage().then((fcm.RemoteMessage? initialMessage) {
      if (initialMessage != null) {
        _onNotificationOpen(initialMessage);
      }
    });
    _notificationOpenedAppStreamSubscription = fcm.FirebaseMessaging.onMessageOpenedApp.listen(
      _onNotificationOpen,
    );
  }

  void _onNotificationOpen(fcm.RemoteMessage message) {
    final RemoteNotification notification = _fcmRemoteMessageToRemoteNotificationMapper.transform(message);
    _notificationClickedSubject.add(notification.toSuccessResult());
  }

  void _listenForegroundNotification() {
    fcm.FirebaseMessaging.onMessage.listen((fcm.RemoteMessage message) {
      final RemoteNotification notification = _fcmRemoteMessageToRemoteNotificationMapper.transform(message);
      _foregroundNotificationReceivedSubject.add(notification.toSuccessResult());
    });
  }
}
