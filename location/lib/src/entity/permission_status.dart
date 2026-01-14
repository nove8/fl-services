/// Represents the various states a permission request can have.
enum PermissionStatus {
  /// Permission has been granted by the user
  granted,

  /// Permission has been denied by the user
  denied,

  /// Permission has been permanently denied and requires manual intervention
  permanentlyDenied,

  /// Permission has been granted with limitations
  limited,

  /// Other permission status not covered by the above cases
  other,
}
