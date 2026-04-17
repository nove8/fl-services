import 'package:async/async.dart';
import 'package:remote_notification_service/src/entity/remote_notification.dart';
import 'package:remote_notification_service/src/entity/remote_notification_service_facade_configuration.dart';
import 'package:remote_notification_service/src/entity/remote_notification_user_custom_field.dart';
import 'package:remote_notification_service/src/fcm_remote_notification_service.dart';
import 'package:remote_notification_service/src/reteno_remote_notification_service.dart';

/// Unified facade interface for remote notification services.
///
/// Aggregates [FcmRemoteNotificationService] and [RetenoRemoteNotificationService]
/// behind a single API so that consumers are decoupled from individual service implementations.
abstract interface class RemoteNotificationServiceFacade {
  /// Merged stream of clicked notifications from all underlying services.
  Stream<Result<RemoteNotification>> get notificationClickedStream;

  /// Stream that emits refreshed notification tokens (e.g. when FCM/APNs token changes).
  Stream<Result<String>> get tokenRefreshedStream;

  /// Stream that emits a [RemoteNotification] when a notification is received in the foreground.
  Stream<Result<RemoteNotification>> get foregroundNotificationReceivedStream;

  /// Returns the current device push notification token, or `null` if unavailable.
  Future<Result<String?>> getToken();

  /// Sets user attributes for targeting and segmentation on the Reteno platform.
  ///
  /// [userId] is the unique user identifier.
  /// [userEmail] is the optional user email.
  /// [customFields] are optional custom user fields for segmentation.
  Future<Result<void>> setUserAttributes({
    required String userId,
    String? userEmail,
    List<RemoteNotificationUserCustomField>? customFields,
  });

  /// Disposes all underlying services, cancels subscriptions and closes stream controllers.
  Future<void> dispose();
}

/// Implementation of [RemoteNotificationServiceFacade].
///
/// Internally creates and manages [FcmRemoteNotificationServiceImpl] and
/// [RetenoRemoteNotificationServiceImpl] based on the provided [configuration].
final class RemoteNotificationServiceFacadeImpl implements RemoteNotificationServiceFacade {
  /// Creates a new [RemoteNotificationServiceFacadeImpl] from the given [configuration].
  RemoteNotificationServiceFacadeImpl({
    required RemoteNotificationServiceFacadeConfiguration configuration,
  }) : _webVapidKey = configuration.webVapidKey,
       _fcmService = FcmRemoteNotificationServiceImpl(
         onBackgroundRemoteNotification: configuration.onBackgroundRemoteNotification,
       ),
       _retenoService = RetenoRemoteNotificationServiceImpl(
         isTestEnvironment: configuration.isTestEnvironment,
         testAccessKey: configuration.retenoTestAccessKey,
         prodAccessKey: configuration.retenoProductionAccessKey,
       );

  final String? _webVapidKey;
  final FcmRemoteNotificationServiceImpl _fcmService;
  final RetenoRemoteNotificationServiceImpl _retenoService;

  @override
  Stream<Result<RemoteNotification>> get notificationClickedStream {
    return StreamGroup.merge(<Stream<Result<RemoteNotification>>>[
      _fcmService.notificationClickedStream,
      _retenoService.notificationClickedStream,
    ]);
  }

  @override
  Stream<Result<String>> get tokenRefreshedStream => _fcmService.tokenRefreshedStream;

  @override
  Stream<Result<RemoteNotification>> get foregroundNotificationReceivedStream {
    return _fcmService.foregroundNotificationReceivedStream;
  }

  @override
  Future<Result<String?>> getToken() {
    return _fcmService.getToken(webVapidKey: _webVapidKey);
  }

  @override
  Future<Result<void>> setUserAttributes({
    required String userId,
    String? userEmail,
    List<RemoteNotificationUserCustomField>? customFields,
  }) {
    return _retenoService.setUserAttributes(
      userId: userId,
      userEmail: userEmail,
      customFields: customFields,
    );
  }

  @override
  Future<void> dispose() async {
    await _fcmService.dispose();
    await _retenoService.dispose();
  }
}
