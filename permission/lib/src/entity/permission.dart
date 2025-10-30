/// Represents different types of device permissions that can be requested.
enum Permission {
  /// Permission to track user activity across apps and websites (iOS only)
  appTrackingTransparency,

  /// Permission to access the device camera
  camera,

  /// Permission to send push notifications
  notification,
}
