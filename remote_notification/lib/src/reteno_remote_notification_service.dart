import 'package:async/async.dart';
import 'package:remote_notification_service/src/entity/remote_notification.dart';
import 'package:remote_notification_service/src/entity/remote_notification_user_custom_field.dart';
import 'package:remote_notification_service/src/failure/remote_notification_failure.dart';
import 'package:remote_notification_service/src/remote_notification_service.dart';
import 'package:remote_notification_service/src/util/future_util.dart';
import 'package:reteno_plugin/reteno.dart' as reteno;

/// Implementation of [RemoteNotificationService] that wraps another [RemoteNotificationService]
/// (typically FCM) and adds Reteno SDK functionality (initialization and user attributes).
final class RetenoRemoteNotificationService implements RemoteNotificationService {
  /// Creates a new instance of [RetenoRemoteNotificationService].
  ///
  /// [remoteNotificationService] is the delegate service (typically [FcmRemoteNotificationService])
  /// that handles the core push notification functionality.
  ///
  /// [isTestEnvironment] controls which Reteno access key is used.
  /// [testAccessKey] is used when [isTestEnvironment] is `true`.
  /// [prodAccessKey] is used when [isTestEnvironment] is `false`.
  /// [isDebug] enables Reteno debug mode.
  /// [lifecycleTrackingOptions] configures Reteno lifecycle tracking.
  RetenoRemoteNotificationService({
    required RemoteNotificationService remoteNotificationService,
    required bool isTestEnvironment,
    required String testAccessKey,
    required String prodAccessKey,
  }) : _delegate = remoteNotificationService,
       _isTestEnvironment = isTestEnvironment,
       _testAccessKey = testAccessKey,
       _prodAccessKey = prodAccessKey {
    _initReteno();
  }

  final RemoteNotificationService _delegate;
  final bool _isTestEnvironment;
  final String _testAccessKey;
  final String _prodAccessKey;

  final reteno.Reteno _reteno = reteno.Reteno();

  @override
  Stream<Result<String>> get tokenRefreshedStream => _delegate.tokenRefreshedStream;

  @override
  Stream<Result<RemoteNotification>> get foregroundNotificationReceivedStream =>
      _delegate.foregroundNotificationReceivedStream;

  @override
  Stream<Result<RemoteNotification>> get notificationClickedStream => _delegate.notificationClickedStream;

  @override
  Future<Result<String?>> getToken({String? webVapidKey}) => _delegate.getToken();

  @override
  Future<Result<void>> setUserAttributes({
    required String userId,
    String? userEmail,
    List<RemoteNotificationUserCustomField>? customFields,
  }) {
    final List<reteno.UserCustomField>? retenoCustomFields = customFields?.map((
      RemoteNotificationUserCustomField field,
    ) {
      return reteno.UserCustomField(key: field.key, value: field.value);
    }).toList();

    final reteno.UserAttributes userAttributes = reteno.UserAttributes(
      email: userEmail,
      fields: retenoCustomFields,
    );

    return _reteno
        .setUserAttributes(
          userExternalId: userId,
          user: reteno.RetenoUser(userAttributes: userAttributes),
        )
        .mapToResult(SetRetenoUserAttributesFailure.new);
  }

  @override
  Future<void> dispose() {
    return _delegate.dispose();
  }

  void _initReteno() {
    _reteno.initWith(
      accessKey: _isTestEnvironment ? _testAccessKey : _prodAccessKey,
      isDebug: _isTestEnvironment,
      lifecycleTrackingOptions: reteno.LifecycleTrackingOptions.all(),
    );
  }
}
