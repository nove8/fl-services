/// Defines the different types of device settings that can be opened.
enum DeviceSettingsType {
  /// Open the accessibility settings.
  ///
  /// Only supported on Android.
  accessibility,

  /// Open the alarm settings.
  ///
  /// Only supported on Android.
  alarm,

  /// Open the APN settings.
  ///
  /// Only supported on Android.
  apn,

  /// Open the app language settings.
  ///
  /// Only supported on Android 13+.
  appLocale,

  /// Open the app settings.
  ///
  /// Supported on all platforms.
  appSettings,

  /// Open the Battery Optimization settings.
  ///
  /// Only supported on Android.
  batteryOptimization,

  /// Open the Bluetooth settings.
  ///
  /// Only supported on Android.
  bluetooth,

  /// Open the Data Roaming settings.
  ///
  /// Only supported on Android.
  dataRoaming,

  /// Open the date settings.
  ///
  /// Only supported on Android.
  date,

  /// Open the Developer settings.
  ///
  /// Only supported on Android.
  developer,

  /// Open the device settings.
  ///
  /// Only supported on Android.
  device,

  /// Open the general device settings.
  ///
  /// Only supported on Android.
  generalSettings,

  /// Open the display settings.
  ///
  /// Only supported on Android.
  display,

  /// Open the Hotspot settings.
  ///
  /// Only supported on Android.
  hotspot,

  /// Open the internal storage settings.
  ///
  /// Only supported on Android.
  internalStorage,

  /// Open the location settings.
  ///
  /// Only supported on Android.
  location,

  /// Open the Lock And Password settings.
  ///
  /// Only supported on Android.
  lockAndPassword,

  /// Open the request app install settings.
  ///
  /// Only supported on Android.
  manageUnknownAppSources,

  /// Open the NFC settings.
  ///
  /// Only supported on Android.
  nfc,

  /// Open the notification settings.
  ///
  /// Supported on Android and iOS 16+.
  notification,

  /// Open the security settings.
  ///
  /// Only supported on Android.
  security,

  /// Open the audio settings.
  ///
  /// Only supported on Android.
  sound,

  /// Open the subscription settings.
  ///
  /// Only supported on iOS 15+.
  subscriptions,

  /// Open the VPN settings.
  ///
  /// Only supported on Android.
  vpn,

  /// Open the wifi settings.
  ///
  /// Only supported on Android.
  wifi,

  /// Open the wireless settings.
  ///
  /// Only supported on Android.
  wireless,

  /// Open the camera settings.
  ///
  /// Only supported on macOS.
  camera,
}
