part of '../device_settings_service_impl.dart';

/// Mapper that transforms service [DeviceSettingsType] to library [lib.AppSettingsType].
final class _DeviceSettingsTypeServiceToAppSettingsTypeLibMapper {
  /// Creates a [_DeviceSettingsTypeServiceToAppSettingsTypeLibMapper].
  const _DeviceSettingsTypeServiceToAppSettingsTypeLibMapper();

  /// Transforms a [DeviceSettingsType] to its corresponding [lib.AppSettingsType].
  lib.AppSettingsType transform(DeviceSettingsType type) {
    return switch (type) {
      DeviceSettingsType.accessibility => lib.AppSettingsType.accessibility,
      DeviceSettingsType.alarm => lib.AppSettingsType.alarm,
      DeviceSettingsType.apn => lib.AppSettingsType.apn,
      DeviceSettingsType.appSettingsLocale => lib.AppSettingsType.appLocale,
      DeviceSettingsType.appSettings => lib.AppSettingsType.settings,
      DeviceSettingsType.batteryOptimization => lib.AppSettingsType.batteryOptimization,
      DeviceSettingsType.bluetooth => lib.AppSettingsType.bluetooth,
      DeviceSettingsType.dataRoaming => lib.AppSettingsType.dataRoaming,
      DeviceSettingsType.date => lib.AppSettingsType.date,
      DeviceSettingsType.developer => lib.AppSettingsType.developer,
      DeviceSettingsType.settings => lib.AppSettingsType.device,
      DeviceSettingsType.generalSettings => lib.AppSettingsType.generalSettings,
      DeviceSettingsType.display => lib.AppSettingsType.display,
      DeviceSettingsType.hotspot => lib.AppSettingsType.hotspot,
      DeviceSettingsType.internalStorage => lib.AppSettingsType.internalStorage,
      DeviceSettingsType.location => lib.AppSettingsType.location,
      DeviceSettingsType.lockAndPassword => lib.AppSettingsType.lockAndPassword,
      DeviceSettingsType.manageUnknownAppSources => lib.AppSettingsType.manageUnknownAppSources,
      DeviceSettingsType.nfc => lib.AppSettingsType.nfc,
      DeviceSettingsType.appSettingsNotification => lib.AppSettingsType.notification,
      DeviceSettingsType.security => lib.AppSettingsType.security,
      DeviceSettingsType.sound => lib.AppSettingsType.sound,
      DeviceSettingsType.subscriptions => lib.AppSettingsType.subscriptions,
      DeviceSettingsType.vpn => lib.AppSettingsType.vpn,
      DeviceSettingsType.wifi => lib.AppSettingsType.wifi,
      DeviceSettingsType.wireless => lib.AppSettingsType.wireless,
      DeviceSettingsType.camera => lib.AppSettingsType.camera,
    };
  }
}
