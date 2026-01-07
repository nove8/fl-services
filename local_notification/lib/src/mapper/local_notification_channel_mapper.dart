import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification_service/src/entity/local_notification.dart';
import 'package:local_notification_service/src/entity/local_notification_channel.dart';

/// Mapper for converting [LocalNotificationChannel] to [AndroidNotificationChannel].
class LocalNotificationChannelToAndroidNotificationChannelMapper {
  /// Creates a [LocalNotificationChannelToAndroidNotificationChannelMapper].
  const LocalNotificationChannelToAndroidNotificationChannelMapper(
    this._importanceMapper,
    this._soundToAndroidSoundMapper,
  );

  /// Mapper for converting [LocalNotificationImportance] to [Importance].
  final LocalNotificationImportanceToAndroidImportanceMapper _importanceMapper;

  /// Mapper for converting sound resource name to [RawResourceAndroidNotificationSound].
  final LocalNotificationSoundToAndroidSoundMapper _soundToAndroidSoundMapper;

  /// Transforms [LocalNotificationChannel] to [AndroidNotificationChannel].
  AndroidNotificationChannel transform(LocalNotificationChannel channel) {
    final LocalNotificationAndroidChannelDetails? androidDetails = channel.androidDetails;

    return AndroidNotificationChannel(
      channel.id,
      channel.name,
      importance: _importanceMapper.transform(androidDetails?.importance),
      playSound: androidDetails?.isPlaySound ?? true,
      sound: _soundToAndroidSoundMapper.transform(androidDetails?.soundResourceName),
      enableVibration: androidDetails?.isEnableVibration ?? true,
      vibrationPattern: androidDetails?.vibrationPattern,
      showBadge: androidDetails?.isShowBadge ?? true,
      enableLights: androidDetails?.isEnableLights ?? false,
      ledColor: androidDetails?.ledColor,
    );
  }
}

/// Mapper for converting [LocalNotificationImportance] to [Importance].
class LocalNotificationImportanceToAndroidImportanceMapper {
  /// Creates a [LocalNotificationImportanceToAndroidImportanceMapper].
  const LocalNotificationImportanceToAndroidImportanceMapper();

  /// Transforms [LocalNotificationImportance] to [Importance].
  Importance transform(LocalNotificationImportance? importance) {
    return switch (importance) {
      LocalNotificationImportance.none => Importance.none,
      LocalNotificationImportance.min => Importance.min,
      LocalNotificationImportance.low => Importance.low,
      LocalNotificationImportance.defaultImportance => Importance.defaultImportance,
      LocalNotificationImportance.high => Importance.high,
      LocalNotificationImportance.max || null => Importance.max,
    };
  }
}

/// Mapper for converting [LocalNotificationPriority] to [Priority].
class LocalNotificationPriorityToAndroidPriorityMapper {
  /// Creates a [LocalNotificationPriorityToAndroidPriorityMapper].
  const LocalNotificationPriorityToAndroidPriorityMapper();

  /// Transforms [LocalNotificationPriority] to [Priority].
  Priority transform(LocalNotificationPriority? priority) {
    return switch (priority) {
      LocalNotificationPriority.min => Priority.min,
      LocalNotificationPriority.low => Priority.low,
      LocalNotificationPriority.defaultPriority => Priority.defaultPriority,
      LocalNotificationPriority.high || null => Priority.high,
      LocalNotificationPriority.max => Priority.max,
    };
  }
}

/// Mapper for converting sound resource name to [RawResourceAndroidNotificationSound].
class LocalNotificationSoundToAndroidSoundMapper {
  /// Creates a [LocalNotificationSoundToAndroidSoundMapper].
  const LocalNotificationSoundToAndroidSoundMapper();

  /// Transforms sound resource name to [RawResourceAndroidNotificationSound].
  RawResourceAndroidNotificationSound? transform(String? soundResourceName) {
    return soundResourceName == null ? null : RawResourceAndroidNotificationSound(soundResourceName);
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
