import 'package:remote_notification_service/src/fcm_remote_notification_service.dart';

/// Configuration for [RemoteNotificationServiceFacadeImpl].
///
/// Contains all parameters required to initialize the underlying
/// [FcmRemoteNotificationServiceImpl] and [RetenoRemoteNotificationServiceImpl].
final class RemoteNotificationServiceFacadeConfiguration {
  /// Creates a configuration for [RemoteNotificationServiceFacadeImpl].
  ///
  /// [webVapidKey] is used for web push token retrieval via FCM.
  /// [onBackgroundRemoteNotification] is an optional top-level or static function
  /// called when a background FCM notification is received.
  /// [isTestEnvironment] controls which Reteno access key is used.
  /// [retenoTestAccessKey] is used when [isTestEnvironment] is `true`.
  /// [retenoProductionAccessKey] is used when [isTestEnvironment] is `false`.
  const RemoteNotificationServiceFacadeConfiguration({
    this.webVapidKey,
    this.onBackgroundRemoteNotification,
    required this.isTestEnvironment,
    required this.retenoTestAccessKey,
    required this.retenoProductionAccessKey,
  });

  /// The VAPID key used for web push token retrieval. Has no effect on non-web platforms.
  final String? webVapidKey;

  /// Optional handler invoked when a notification is received in the background.
  ///
  /// Must be either a static function or a top-level function.
  final BackgroundRemoteNotificationHandler? onBackgroundRemoteNotification;

  /// Controls which Reteno access key is used.
  final bool isTestEnvironment;

  /// Reteno access key used in test environments.
  final String retenoTestAccessKey;

  /// Reteno access key used in production environments.
  final String retenoProductionAccessKey;
}
