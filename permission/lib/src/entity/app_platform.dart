/// Enum representing the different application platforms.
///
/// Used to identify the current platform the application is running on.
enum AppPlatform {
  /// Apple's iOS platform.
  iOS,

  /// Google's Android platform.
  android,

  /// Web platform.
  web;

  /// Returns true if the current platform is iOS.
  bool get isIos => this == iOS;

  /// Returns true if the current platform is Android.
  bool get isAndroid => this == android;
}
