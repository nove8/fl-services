import 'dart:typed_data';
import 'dart:ui';

part 'local_notification_android_channel_details.dart';

part 'local_notification_darwin_channel_details.dart';

/// Represents a notification channel configuration for local notifications.
final class LocalNotificationChannel {
  /// Creates a [LocalNotificationChannel].
  const LocalNotificationChannel({
    required this.id,
    required this.name,
    this.groupId,
  });

  /// The unique identifier of notification channel.
  final String id;

  /// Notification channel name.
  final String name;

  /// The thread identifier for grouping notifications.
  final String? groupId;


}
