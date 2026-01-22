import 'dart:async';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fcm;
import 'package:remote_notification_service/src/failure/remote_notification_failure.dart';
import 'package:remote_notification_service/src/remote_notification_service.dart';
import 'package:remote_notification_service/src/util/future_util.dart';

/// Implementation of [RemoteNotificationService] using Firebase Cloud Messaging (FCM).
final class FcmRemoteNotificationService implements RemoteNotificationService {
  /// Returns the singleton instance of [FcmRemoteNotificationService].
  factory FcmRemoteNotificationService() => _instance ??= FcmRemoteNotificationService._();

  FcmRemoteNotificationService._() {
    _init();
  }

  static FcmRemoteNotificationService? _instance;

  final fcm.FirebaseMessaging _firebaseMessaging = fcm.FirebaseMessaging.instance;

  @override
  Result<Stream<String>> get tokenRefreshedStream => _firebaseMessaging.onTokenRefresh.toSuccessResult();

  @override
  Future<Result<String?>> getToken() {
    return _firebaseMessaging.getToken().mapToResult(GetRemoteNotificationTokenFailure.new);
  }

  @override
  Future<void> dispose() async {
    // TODO The logic will be added later
  }

  void _init() {
    // TODO The logic will be added later
  }
}
