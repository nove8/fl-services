import 'package:async/async.dart';
import 'package:remote_notification_service/src/entity/remote_notification.dart';
import 'package:remote_notification_service/src/entity/remote_notification_user_custom_field.dart';

/// Handler function type for processing remote notifications received in the background.
typedef BackgroundRemoteNotificationHandler =
    Future<void> Function(Result<RemoteNotification> remoteNotification);

/// Service interface for managing remote notifications (e.g. FCM/APNs).
abstract interface class RemoteNotificationService {
  /// Stream that emits refreshed notification token (e.g. when FCM/APNs token changes).
  Stream<Result<String>> get tokenRefreshedStream;

  /// Stream that emits a [RemoteNotification] when a notification is received in the foreground.
  Stream<Result<RemoteNotification>> get foregroundNotificationReceivedStream;

  /// Stream that emits a [RemoteNotification] when a notification is clicked by the user.
  Stream<Result<RemoteNotification>> get notificationClickedStream;

  /// Gets the current device notification token, or null if unavailable.
  Future<Result<String?>> getToken({String? webVapidKey});

  /// Sets user attributes for targeting and segmentation on the notification platform.
  ///
  /// [userId] is the unique user identifier.
  /// [userEmail] is the optional user email.
  /// [customFields] are optional custom user fields for segmentation.
  Future<Result<void>> setUserAttributes({
    required String userId,
    String? userEmail,
    List<RemoteNotificationUserCustomField>? customFields,
  });

  /// Disposes the service, cancels stream subscriptions and closes stream controllers
  Future<void> dispose();
}
