part of 'local_notification.dart';

/// iOS (Darwin) notification details.
final class LocalNotificationDarwinDetails {
  /// Creates a [LocalNotificationDarwinDetails].
  const LocalNotificationDarwinDetails({
    this.soundFileNameWithExtension,
    this.attachmentFilePaths,
  });

  /// The name of the sound file to play (including extension).
  final String? soundFileNameWithExtension;

  /// The file paths of attachments to include with the notification.
  final List<String>? attachmentFilePaths;
}
