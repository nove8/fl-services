part of '../app_settings_service_impl.dart';

/// Mapper that transforms service [AppSettingsType] to library [lib.AppSettingsType].
final class _AppSettingsTypeServiceToLibMapper {
  /// Creates an [_AppSettingsTypeServiceToLibMapper].
  const _AppSettingsTypeServiceToLibMapper();

  /// Transforms an [AppSettingsType] to its corresponding [lib.AppSettingsType].
  lib.AppSettingsType transform(AppSettingsType type) {
    return switch (type) {
      AppSettingsType.accessibility => lib.AppSettingsType.accessibility,
      AppSettingsType.alarm => lib.AppSettingsType.alarm,
      AppSettingsType.apn => lib.AppSettingsType.apn,
      AppSettingsType.appLocale => lib.AppSettingsType.appLocale,
      AppSettingsType.batteryOptimization => lib.AppSettingsType.batteryOptimization,
      AppSettingsType.bluetooth => lib.AppSettingsType.bluetooth,
      AppSettingsType.dataRoaming => lib.AppSettingsType.dataRoaming,
      AppSettingsType.date => lib.AppSettingsType.date,
      AppSettingsType.developer => lib.AppSettingsType.developer,
      AppSettingsType.device => lib.AppSettingsType.device,
      AppSettingsType.generalSettings => lib.AppSettingsType.generalSettings,
      AppSettingsType.display => lib.AppSettingsType.display,
      AppSettingsType.hotspot => lib.AppSettingsType.hotspot,
      AppSettingsType.internalStorage => lib.AppSettingsType.internalStorage,
      AppSettingsType.location => lib.AppSettingsType.location,
      AppSettingsType.lockAndPassword => lib.AppSettingsType.lockAndPassword,
      AppSettingsType.manageUnknownAppSources => lib.AppSettingsType.manageUnknownAppSources,
      AppSettingsType.nfc => lib.AppSettingsType.nfc,
      AppSettingsType.notification => lib.AppSettingsType.notification,
      AppSettingsType.security => lib.AppSettingsType.security,
      AppSettingsType.settings => lib.AppSettingsType.settings,
      AppSettingsType.sound => lib.AppSettingsType.sound,
      AppSettingsType.subscriptions => lib.AppSettingsType.subscriptions,
      AppSettingsType.vpn => lib.AppSettingsType.vpn,
      AppSettingsType.wifi => lib.AppSettingsType.wifi,
      AppSettingsType.wireless => lib.AppSettingsType.wireless,
      AppSettingsType.camera => lib.AppSettingsType.camera,
    };
  }
}
