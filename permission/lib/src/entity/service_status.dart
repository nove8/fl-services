/// Defines the different states a service can be in.
enum ServiceStatus {
  /// The service for the permission is disabled.
  disabled,

  /// The service for the permission is enabled.
  enabled,

  /// The permission does not have an associated service on the current platform.
  notApplicable,
}
