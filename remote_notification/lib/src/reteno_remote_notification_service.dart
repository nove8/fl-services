import 'dart:async';

import 'package:async/async.dart';
import 'package:remote_notification_service/src/entity/remote_notification.dart';
import 'package:remote_notification_service/src/entity/remote_notification_user_custom_field.dart';
import 'package:remote_notification_service/src/failure/remote_notification_failure.dart';
import 'package:remote_notification_service/src/mapper/reteno_remote_notification_mappers.dart';
import 'package:remote_notification_service/src/util/future_util.dart';
import 'package:reteno_plugin/reteno.dart' as reteno;
import 'package:rxdart/rxdart.dart';

/// Interface for Reteno remote notification service API.
abstract interface class RetenoRemoteNotificationService {
  /// Stream that emits a [RemoteNotification] when a notification is clicked by the user.
  Stream<Result<RemoteNotification>> get notificationClickedStream;

  /// Sets user attributes for targeting and segmentation on the Reteno platform.
  Future<Result<void>> setUserAttributes({
    required String userId,
    String? userEmail,
    List<RemoteNotificationUserCustomField>? customFields,
  });

  /// Disposes the service, cancels stream subscriptions and closes stream controllers.
  Future<void> dispose();
}

/// Service implementation that uses the Reteno SDK for user attributes and targeting.
final class RetenoRemoteNotificationServiceImpl implements RetenoRemoteNotificationService {
  /// Creates a new instance of [RetenoRemoteNotificationServiceImpl] and initializes the Reteno SDK.
  ///
  /// [isTestEnvironment] controls which Reteno access key is used.
  /// [testAccessKey] is used when [isTestEnvironment] is `true`.
  /// [prodAccessKey] is used when [isTestEnvironment] is `false`.
  RetenoRemoteNotificationServiceImpl({
    required bool isTestEnvironment,
    required String testAccessKey,
    required String prodAccessKey,
  }) : _isTestEnvironment = isTestEnvironment,
       _testAccessKey = testAccessKey,
       _prodAccessKey = prodAccessKey {
    _init();
  }

  final bool _isTestEnvironment;
  final String _testAccessKey;
  final String _prodAccessKey;

  final reteno.Reteno _reteno = reteno.Reteno();

  final StreamController<Result<RemoteNotification>> _notificationClickedController =
      BehaviorSubject<Result<RemoteNotification>>();

  final RetenoNotificationDataToRemoteNotificationMapper _notificationDataMapper =
      const RetenoNotificationDataToRemoteNotificationMapper();

  StreamSubscription<Map<String, Object?>>? _notificationClickedSubscription;

  @override
  Stream<Result<RemoteNotification>> get notificationClickedStream => _notificationClickedController.stream;

  @override
  Future<void> dispose() async {
    await _notificationClickedSubscription?.cancel();
    await _notificationClickedController.close();
  }

  /// Sets user attributes for targeting and segmentation on the Reteno platform.
  ///
  /// [userId] is the unique user identifier.
  /// [userEmail] is the optional user email.
  /// [customFields] are optional custom user fields for segmentation.
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

  void _init() {
    _initReteno();
    _listenNotificationClicks();
  }

  Future<void> _initReteno() {
    return _reteno.initialize(
      accessKey: _isTestEnvironment ? _testAccessKey : _prodAccessKey,
      options: reteno.RetenoInitOptions(
        isDebug: _isTestEnvironment,
        lifecycleTrackingOptions: reteno.LifecycleTrackingOptions.all(),
      ),
    );
  }

  void _listenNotificationClicks() {
    _notificationClickedSubscription = reteno.Reteno.onRetenoNotificationClicked.listen(
      _onRetenoNotificationClicked,
    );
  }

  void _onRetenoNotificationClicked(Map<String, Object?> notificationData) {
    _notificationClickedController.add(_notificationDataMapper.transform(notificationData));
  }
}
