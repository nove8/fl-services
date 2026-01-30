import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification_service/src/entity/local_notification_channel.dart';

/// Mapper for converting [LocalNotificationChannel] to [AndroidNotificationChannel].
class LocalNotificationChannelToAndroidNotificationChannelMapper {
  /// Creates a [LocalNotificationChannelToAndroidNotificationChannelMapper].
  const LocalNotificationChannelToAndroidNotificationChannelMapper();

  static const LocalNotificationChannelSoundToAndroidSoundMapper _channelSoundToAndroidSoundMapper =
      LocalNotificationChannelSoundToAndroidSoundMapper();

  /// Transforms [LocalNotificationChannel] to [AndroidNotificationChannel].
  AndroidNotificationChannel transform({required LocalNotificationChannel channel}) {
    return AndroidNotificationChannel(
      channel.id,
      channel.name,
      sound: _channelSoundToAndroidSoundMapper.transform(channel.soundResourceName),
    );
  }
}

/// Mapper for converting channel sound resource name to [RawResourceAndroidNotificationSound].
class LocalNotificationChannelSoundToAndroidSoundMapper {
  /// Creates a [LocalNotificationChannelSoundToAndroidSoundMapper].
  const LocalNotificationChannelSoundToAndroidSoundMapper();

  /// Transforms sound resource name to [RawResourceAndroidNotificationSound].
  RawResourceAndroidNotificationSound? transform(String? soundResourceName) {
    return soundResourceName == null ? null : RawResourceAndroidNotificationSound(soundResourceName);
  }
}
