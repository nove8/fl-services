import 'package:async/async.dart';
import 'package:remote_notification_service/src/entity/remote_notification.dart';

/// Service interface for managing remote notifications (e.g. FCM/APNs).
abstract interface class RemoteNotificationService {
  /// Stream that emits refreshed notification token (e.g. when FCM/APNs token changes).
  Stream<Result<String>> get tokenRefreshedStream;

  /// Stream that emits a [RemoteNotification] when a notification is received in the foreground.
  Stream<Result<RemoteNotification>> get foregroundNotificationReceivedStream;

  /// Stream that emits a [RemoteNotification] when a notification is clicked by the user.
  Stream<Result<RemoteNotification>> get remoteNotificationClickedStream;

  /// Gets the current device notification token, or null if unavailable.
  Future<Result<String?>> getToken();

  /// Disposes the service, cancels stream subscriptions and closes stream controllers
  Future<void> dispose();
}
