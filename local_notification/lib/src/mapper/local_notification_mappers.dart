import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification_service/src/entity/local_notification.dart';

/// Mapper for converting [LocalNotificationImportance] to [Importance].
class LocalNotificationImportanceToAndroidImportanceMapper {
  /// Creates a [LocalNotificationImportanceToAndroidImportanceMapper].
  const LocalNotificationImportanceToAndroidImportanceMapper();

  /// Transforms [LocalNotificationImportance] to [Importance].
  Importance transform(LocalNotificationImportance importance) {
    return switch (importance) {
      LocalNotificationImportance.none => Importance.none,
      LocalNotificationImportance.min => Importance.min,
      LocalNotificationImportance.low => Importance.low,
      LocalNotificationImportance.defaultImportance => Importance.defaultImportance,
      LocalNotificationImportance.high => Importance.high,
      LocalNotificationImportance.max => Importance.max,
    };
  }
}

/// Mapper for converting [LocalNotificationPriority] to [Priority].
class LocalNotificationPriorityToAndroidPriorityMapper {
  /// Creates a [LocalNotificationPriorityToAndroidPriorityMapper].
  const LocalNotificationPriorityToAndroidPriorityMapper();

  /// Transforms [LocalNotificationPriority] to [Priority].
  Priority transform(LocalNotificationPriority priority) {
    return switch (priority) {
      LocalNotificationPriority.min => Priority.min,
      LocalNotificationPriority.low => Priority.low,
      LocalNotificationPriority.defaultPriority => Priority.defaultPriority,
      LocalNotificationPriority.high => Priority.high,
      LocalNotificationPriority.max => Priority.max,
    };
  }
}

/// Mapper for converting [LocalNotificationAndroidStyle] to [StyleInformation].
class LocalNotificationAndroidStyleToStyleInformationMapper {
  /// Creates a [LocalNotificationAndroidStyleToStyleInformationMapper].
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

/// Mapper for converting file paths to [DarwinNotificationAttachment].
class LocalNotificationFilePathToDarwinNotificationAttachmentMapper {
  /// Creates a [LocalNotificationFilePathToDarwinNotificationAttachmentMapper].
  const LocalNotificationFilePathToDarwinNotificationAttachmentMapper();

  /// Transforms list of file paths to list of [DarwinNotificationAttachment].
  List<DarwinNotificationAttachment>? transform(List<String>? filePaths) {
    return filePaths?.map(DarwinNotificationAttachment.new).toList();
  }
}

/// Mapper for converting [LocalNotificationAndroidScheduleMode] to [AndroidScheduleMode].
class LocalNotificationScheduleModeToAndroidScheduleModeMapper {
  /// Creates a [LocalNotificationScheduleModeToAndroidScheduleModeMapper].
  const LocalNotificationScheduleModeToAndroidScheduleModeMapper();

  /// Transforms [LocalNotificationAndroidScheduleMode] to [AndroidScheduleMode].
  AndroidScheduleMode transform(LocalNotificationAndroidScheduleMode scheduleMode) {
    return switch (scheduleMode) {
      LocalNotificationAndroidScheduleMode.inexactAllowWhileIdle => AndroidScheduleMode.inexactAllowWhileIdle,
    };
  }
}

/// Mapper for converting [LocalNotificationRepeatInterval] to [DateTimeComponents].
class LocalNotificationRepeatIntervalToDateTimeComponentsMapper {
  /// Creates a [LocalNotificationRepeatIntervalToDateTimeComponentsMapper].
  const LocalNotificationRepeatIntervalToDateTimeComponentsMapper();

  /// Transforms [LocalNotificationRepeatInterval] to [DateTimeComponents].
  DateTimeComponents? transform(LocalNotificationRepeatInterval? repeatInterval) {
    return switch (repeatInterval) {
      LocalNotificationRepeatInterval.daily => DateTimeComponents.time,
      LocalNotificationRepeatInterval.weekly => DateTimeComponents.dayOfWeekAndTime,
      LocalNotificationRepeatInterval.monthly => DateTimeComponents.dayOfMonthAndTime,
      LocalNotificationRepeatInterval.threeMonths ||
      LocalNotificationRepeatInterval.sixMonths ||
      LocalNotificationRepeatInterval.annually => DateTimeComponents.dateAndTime,
      null => null,
    };
  }
}
