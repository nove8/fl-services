import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification_service/src/entity/local_notification_channel.dart';

/// Mapper for converting [LocalNotificationChannel] to [AndroidNotificationChannel].
class LocalNotificationChannelToAndroidNotificationChannelMapper {
  /// Creates a [LocalNotificationChannelToAndroidNotificationChannelMapper].
  const LocalNotificationChannelToAndroidNotificationChannelMapper();

  /// Transforms [LocalNotificationChannel] to [AndroidNotificationChannel].
  AndroidNotificationChannel transform({required LocalNotificationChannel channel}) {
    return AndroidNotificationChannel(channel.id, channel.name);
  }
}
