import 'package:async/async.dart';
import 'package:common_result/common_result.dart';
import 'package:remote_notification_reteno_service/src/util/object_util.dart';
import 'package:remote_notification_service/remote_notification_service.dart';

/// Mapper class to convert Reteno notification data [Map] into [RemoteNotification].
final class RemoteNotificationRetenoNotificationDataToRemoteNotificationMapper {
  /// Default constructor for [RemoteNotificationRetenoNotificationDataToRemoteNotificationMapper].
  const RemoteNotificationRetenoNotificationDataToRemoteNotificationMapper();

  static const String _notificationIdKey = 'es_interaction_id';
  static const String _apsKey = 'aps';
  static const String _alertKey = 'alert';
  static const String _titleKey = 'title';
  static const String _bodyKey = 'body';
  static const String _imageKey = 'es_notification_image';

  /// Transforms a Reteno notification data map into a [Result] of [RemoteNotification].
  ///
  /// Returns [InvalidRetenoNotificationDataFailure] if the data cannot be parsed.
  Result<RemoteNotification> transform(Map<String, Object?> notificationData) {
    try {
      final Map<String, Object?>? aps = notificationData.getIfValueType(_apsKey);
      final Map<String, Object?>? alert = aps?.getIfValueType(_alertKey);
      final String? title = alert?.getIfValueType(_titleKey) ?? notificationData.getIfValueType(_titleKey);
      final String? body = alert?.getIfValueType(_bodyKey) ?? notificationData.getIfValueType(_bodyKey);

      return RemoteNotification(
        notificationId: notificationData.getIfValueType(_notificationIdKey),
        title: title,
        body: body,
        imageUrl: notificationData.getIfValueType(_imageKey),
        additionalData: notificationData,
      ).toSuccessResult();
    } catch (_) {
      return InvalidRetenoNotificationDataFailure(notificationData).toFailureResult();
    }
  }
}
