import 'package:async/async.dart';

/// Service interface for managing remote notifications (e.g. FCM/APNs).
abstract interface class RemoteNotificationService {
  /// Stream that emits refreshed notification token (e.g. when FCM/APNs token changes).
  Result<Stream<String>> get tokenRefreshedStream;

  /// Gets the current device notification token, or null if unavailable.
  Future<Result<String?>> getToken();

  /// Disposes the service, cancels stream subscriptions and closes stream controllers
  Future<void> dispose();
}
