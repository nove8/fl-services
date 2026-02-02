import 'package:firebase_messaging/firebase_messaging.dart' as fcm;
import 'package:remote_notification_service/src/entity/remote_notification.dart';

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
    );
  }
}
