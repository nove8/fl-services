import 'dart:async';

import 'package:async/async.dart';
import 'package:remote_notification_service/src/entity/remote_notification.dart';
import 'package:remote_notification_service/src/entity/reteno_user_custom_field.dart';
import 'package:remote_notification_service/src/failure/remote_notification_failure.dart';
import 'package:remote_notification_service/src/mapper/reteno_remote_notification_mappers.dart';
import 'package:remote_notification_service/src/remote_notification_service.dart';
import 'package:remote_notification_service/src/util/future_util.dart';
import 'package:reteno_plugin/reteno.dart' as reteno;
import 'package:rxdart/rxdart.dart';

/// Implementation of [RemoteNotificationService] that wraps another [RemoteNotificationService]
/// (typically FCM) and adds Reteno SDK functionality (initialization, user attributes,
/// and notification click handling).
final class RetenoRemoteNotificationService implements RemoteNotificationService {
  /// Creates a new instance of [RetenoRemoteNotificationService].
  ///
  /// [remoteNotificationService] is the delegate service (typically [FcmRemoteNotificationService])
  /// that handles the core push notification functionality.
  ///
  /// [accessKey] is the Reteno API access key.
  /// [isDebug] enables Reteno debug mode.
  /// [lifecycleTrackingOptions] configures Reteno lifecycle tracking.
  RetenoRemoteNotificationService({
    required RemoteNotificationService remoteNotificationService,
    required String accessKey,
    bool isDebug = false,
    reteno.LifecycleTrackingOptions? lifecycleTrackingOptions,
  }) : _delegate = remoteNotificationService,
       _accessKey = accessKey,
       _isDebug = isDebug,
       _lifecycleTrackingOptions = lifecycleTrackingOptions {
    _init();
  }

  final RemoteNotificationService _delegate;
  final String _accessKey;
  final bool _isDebug;
  final reteno.LifecycleTrackingOptions? _lifecycleTrackingOptions;

  final reteno.Reteno _reteno = reteno.Reteno();

  final RetenoNotificationDataToRemoteNotificationMapper _retenoMapper =
      const RetenoNotificationDataToRemoteNotificationMapper();

  final StreamController<Result<RemoteNotification>> _notificationClickedController =
      BehaviorSubject<Result<RemoteNotification>>();

  @override
  Stream<Result<String>> get tokenRefreshedStream => _delegate.tokenRefreshedStream;

  @override
  Stream<Result<RemoteNotification>> get foregroundNotificationReceivedStream =>
      _delegate.foregroundNotificationReceivedStream;

  @override
  Stream<Result<RemoteNotification>> get notificationClickedStream => _notificationClickedController.stream;

  StreamSubscription<Result<RemoteNotification>>? _delegateNotificationClickedSubscription;
  StreamSubscription<Map<String, Object?>>? _retenoNotificationClickedSubscription;

  @override
  Future<Result<String?>> getToken() => _delegate.getToken();

  @override
  Future<Result<void>> setUserAttributes({
    required String userId,
    String? userEmail,
    List<RetenoUserCustomField>? customFields,
  }) {
    final List<reteno.UserCustomField>? retenoCustomFields = customFields
        ?.map((RetenoUserCustomField field) => reteno.UserCustomField(key: field.key, value: field.value))
        .toList();

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
  Future<void> dispose() async {
    await _delegateNotificationClickedSubscription?.cancel();
    await _retenoNotificationClickedSubscription?.cancel();
    await _notificationClickedController.close();
    await _delegate.dispose();
  }

  void _init() {
    _initReteno();
    _listenNotificationClicks();
  }

  void _initReteno() {
    _reteno.initWith(
      accessKey: _accessKey,
      isDebug: _isDebug,
      lifecycleTrackingOptions: _lifecycleTrackingOptions ?? reteno.LifecycleTrackingOptions.all(),
    );
  }

  void _listenNotificationClicks() {
    _delegateNotificationClickedSubscription = _delegate.notificationClickedStream.listen(
      _notificationClickedController.add,
    );
    _retenoNotificationClickedSubscription = reteno.Reteno.onRetenoNotificationClicked.listen(
      _onRetenoNotificationClicked,
    );
  }

  void _onRetenoNotificationClicked(Map<String, Object?> notificationData) {
    _notificationClickedController.add(_retenoMapper.transform(notificationData));
  }
}
