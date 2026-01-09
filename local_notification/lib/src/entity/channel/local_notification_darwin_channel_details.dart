part of 'local_notification_channel.dart';

/// iOS (Darwin) notification details.
final class LocalNotificationDarwinChannelDetails {
  /// Creates a [LocalNotificationDarwinChannelDetails].
  const LocalNotificationDarwinChannelDetails({
    this.soundFileNameWithExtension,
    this.attachmentFilePaths,
  });

  /// The name of the sound file to play (including extension).
  final String? soundFileNameWithExtension;

  /// The file paths of attachments to include with the notification.
  final List<String>? attachmentFilePaths;
}
