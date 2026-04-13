import 'package:async/async.dart';
import 'package:remote_notification_service/src/entity/remote_notification_user_custom_field.dart';
import 'package:remote_notification_service/src/failure/remote_notification_failure.dart';
import 'package:remote_notification_service/src/util/future_util.dart';
import 'package:reteno_plugin/reteno.dart' as reteno;

/// Service that uses the Reteno SDK for user attributes and targeting.
final class RetenoRemoteNotificationService {
  /// Creates a new instance of [RetenoRemoteNotificationService] and initializes the Reteno SDK.
  ///
  /// [isTestEnvironment] controls which Reteno access key is used.
  /// [testAccessKey] is used when [isTestEnvironment] is `true`.
  /// [prodAccessKey] is used when [isTestEnvironment] is `false`.
  /// [isDebug] enables Reteno debug mode.
  /// [lifecycleTrackingOptions] configures Reteno lifecycle tracking.
  RetenoRemoteNotificationService({
    required bool isTestEnvironment,
    required String testAccessKey,
    required String prodAccessKey,
  }) : _isTestEnvironment = isTestEnvironment,
       _testAccessKey = testAccessKey,
       _prodAccessKey = prodAccessKey {
    _initReteno();
  }

  final bool _isTestEnvironment;
  final String _testAccessKey;
  final String _prodAccessKey;

  final reteno.Reteno _reteno = reteno.Reteno();

  /// Sets user attributes for targeting and segmentation on the Reteno platform.
  ///
  /// [userId] is the unique user identifier.
  /// [userEmail] is the optional user email.
  /// [customFields] are optional custom user fields for segmentation.
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

  void _initReteno() {
    _reteno.initialize(
      accessKey: _isTestEnvironment ? _testAccessKey : _prodAccessKey,
      options: reteno.RetenoInitOptions(
        isDebug: _isTestEnvironment,
        lifecycleTrackingOptions: reteno.LifecycleTrackingOptions.all(),
      ),
    );
  }
}
