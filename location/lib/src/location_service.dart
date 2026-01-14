import 'package:async/async.dart';
import 'package:location_service/src/entity/android_foreground_notification_config.dart';
import 'package:location_service/src/entity/coordinates.dart';
import 'package:location_service/src/entity/permission_status.dart';

/// A service interface for accessing device location functionality.
///
/// Provides methods for checking location service status, requesting permissions,
/// retrieving coordinates, and calculating distances between locations.
abstract interface class LocationService {
  /// Checks if location services are enabled on the device.
  ///
  /// Returns [true] if location services are enabled, otherwise [false].
  Future<Result<bool>> get isLocationServiceEnabled;

  /// Provides a stream of location coordinates updates.
  ///
  /// For Android, the optional [androidForegroundNotificationConfig] parameter can be provided to configure
  /// foreground notification settings when tracking location in the background.
  ///
  /// Returns a stream that emits [Coordinates] when location updates are available,
  /// or null if the location cannot be determined.
  Result<Stream<Coordinates?>> getCoordinatesStream([
    AndroidForegroundNotificationConfig? androidForegroundNotificationConfig,
  ]);

  /// Calculates the distance in meters between two coordinates.
  ///
  /// Uses the Haversine formula to compute the great-circle distance between
  /// [beginCoordinates] (starting point) and [endCoordinates] (ending point).
  ///
  /// Returns the distance in meters as a [double].
  Result<double> distanceBetween({
    required Coordinates beginCoordinates,
    required Coordinates endCoordinates,
  });

  /// Checks the current location permission status without requesting permission.
  ///
  /// Returns the current [PermissionStatus] for location access.
  Future<Result<PermissionStatus>> checkPermission();

  /// Requests location permission from the user.
  ///
  /// Returns the [PermissionStatus] after the user responds to the permission request.
  Future<Result<PermissionStatus>> requestPermission();

  /// Retrieves the last known location coordinates.
  ///
  /// Returns the last cached [Coordinates] if available, otherwise null.
  /// This method is faster than requesting a new location but may return stale data.
  Future<Result<Coordinates?>> getLastKnownCoordinates();
}
