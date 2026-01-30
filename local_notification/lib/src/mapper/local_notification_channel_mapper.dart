import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification_service/src/entity/local_notification_channel.dart';
import 'package:local_notification_service/src/mapper/local_notification_mappers.dart';

/// Mapper for converting [LocalNotificationChannel] to [AndroidNotificationChannel].
class LocalNotificationChannelToAndroidNotificationChannelMapper {
  /// Creates a [LocalNotificationChannelToAndroidNotificationChannelMapper].
  const LocalNotificationChannelToAndroidNotificationChannelMapper();

  static const LocalNotificationSoundToAndroidSoundMapper _soundToAndroidSoundMapper =
      LocalNotificationSoundToAndroidSoundMapper();

  /// Transforms [LocalNotificationChannel] to [AndroidNotificationChannel].
  AndroidNotificationChannel transform({required LocalNotificationChannel channel}) {
    return AndroidNotificationChannel(
      channel.id,
      channel.name,
      sound: _soundToAndroidSoundMapper.transform(channel.soundResourceName),
    );
  }
}
