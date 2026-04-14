import 'dart:io';

import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fcm;
import 'package:flutter/foundation.dart';
import 'package:remote_notification_service/src/entity/app_platform.dart';
import 'package:remote_notification_service/src/entity/remote_notification.dart';
import 'package:remote_notification_service/src/failure/remote_notification_failure.dart';

/// Mapper class to convert [fcm.RemoteMessage] into [RemoteNotification].
final class FcmRemoteMessageToRemoteNotificationMapper {
  /// Default constructor for [FcmRemoteMessageToRemoteNotificationMapper].
  const FcmRemoteMessageToRemoteNotificationMapper();

  /// Transforms a [fcm.RemoteMessage] into a [RemoteNotification].
  RemoteNotification transform(fcm.RemoteMessage message) {
    final fcm.RemoteNotification? notification = message.notification;
    return RemoteNotification(
      notificationId: message.messageId,
      title: notification?.title,
      body: notification?.body,
      additionalData: message.data,
      imageUrl: _obtainImageUrlByPlatform(notification),
    );
  }

  String? _obtainImageUrlByPlatform(fcm.RemoteNotification? notification) {
    return _determineAppPlatform().map((AppPlatform appPlatform) {
      return switch (appPlatform) {
        AppPlatform.android => notification?.android?.imageUrl,
        AppPlatform.iOS => notification?.apple?.imageUrl,
        AppPlatform.web => notification?.web?.image,
      };
    }).outputOrNull;
  }

  Result<AppPlatform> _determineAppPlatform() {
    if (kIsWeb) {
      return AppPlatform.web.toSuccessResult();
    } else if (Platform.isIOS) {
      return AppPlatform.iOS.toSuccessResult();
    } else if (Platform.isAndroid) {
      return AppPlatform.android.toSuccessResult();
    } else {
      return const UnsupportedPlatformFailure().toFailureResult();
    }
  }
}
