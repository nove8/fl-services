/// Represents different types of device permissions that can be requested.
enum Permission {
  /// Permission to track user activity across apps and websites (iOS only).
  appTrackingTransparency,

  /// Permission to access external (platform provided) system camera.
  cameraSystemExternal,

  /// Permission to access data from device camera.
  cameraPreviewInternal,

  /// Permission to send push notifications.
  notification,
}
