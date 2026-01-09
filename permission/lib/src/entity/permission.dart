/// Represents different types of device permissions that can be requested.
enum Permission {
  /// Permission to track user activity across apps and websites (iOS only).
  appTrackingTransparency,

  /// Permission to access external (platform provided) system camera.
  cameraSystemExternal,

  /// Permission to access data from device camera.
  cameraPreviewInternal,

  /// Permission to access the device's location.
  location,

  /// Permission to access the device's location when the app is running in the background.
  locationAlways,

  /// Permission to send push notifications.
  notification,

  /// Permission to access external storage.
  saveToStorage,
}
