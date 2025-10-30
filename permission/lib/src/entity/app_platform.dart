/// Represents the different platforms that the app can run on.
enum AppPlatform {
  /// iOS platform
  iOS,

  /// Android platform
  android;

  /// Returns true if the current platform is iOS.
  bool get isIos => this == iOS;
}
