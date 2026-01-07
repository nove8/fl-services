import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification_service/src/entity/local_notification_channel.dart';

/// Mapper for converting [LocalNotificationAndroidStyle] to [StyleInformation].
final class LocalNotificationAndroidStyleToStyleInformationMapper {
  /// Creates a new instance of [LocalNotificationAndroidStyleToStyleInformationMapper].
  const LocalNotificationAndroidStyleToStyleInformationMapper();

  /// Transforms [LocalNotificationAndroidStyle] to [StyleInformation].
  StyleInformation? transform(LocalNotificationAndroidStyle? style) {
    return switch (style) {
      final LocalNotificationBigPictureStyle localNotificationBigPictureStyle => BigPictureStyleInformation(
          FilePathAndroidBitmap(localNotificationBigPictureStyle.imageFilePath),
        ),
      null => null,
    };
  }
}
